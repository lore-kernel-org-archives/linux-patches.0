Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4046F33032C;
	Fri,  9 Jan 2026 12:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960047; cv=none; b=cuKQeXkMybThHg2VHwDxYo3ZbYyrn+Qgl74wTpg1Wskr4K6n1ECJIGX2mtegwRJniEDM46ZH5CNk+S/JDbmpo0R9BeAg8/PK7nv4nqqKItlaSWgvHxc2vbeVBQazGLMDbXJbNmEb8G7LkwBGwgTOtS8cPMQG2a7rtAqUFxBmf/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960047; c=relaxed/simple;
	bh=V7TKtz5rX9QvdZXABNKzkfGBQXfuClrEh3faoeWr/g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byNG5eXC6LoSR9cC5DgK9rAF5U47aAeoBPfZOz6X7eE0fUDcLO/F6fHAa87MrqI+GQPuGg8cYn9FxCx0UtT3xu8/6j/c8jiuNcPQcxwGSr38BVBnLJK0GSR5xW8lNvHfhHggWRbe+6Ez0tQSC5XMTNYcObf8aufY1I1ycU929I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWrN++lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWrN++lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C64C4CEF1;
	Fri,  9 Jan 2026 12:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960047;
	bh=V7TKtz5rX9QvdZXABNKzkfGBQXfuClrEh3faoeWr/g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWrN++lkYsoH+RikcJsyJjAYHk5cG7VoBQ9G3gt/Zc88w57GHs3xMqe9phayi085I
	 C8DgUsQGH3209iQkoXmsZZfs48SS7QUcVWzNax7F3PnELdPbTwJA3Hn5THfvQwJYl3
	 sHjUT9bwovVNqgExcaWe/ww+5iHyPVnCcaQL5hRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 266/737] Revert "nfs: ignore SB_RDONLY when mounting nfs"
Date: Fri,  9 Jan 2026 12:36:45 +0100
Message-ID: <20260109112144.000560143@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d4a26d34f1946142f9d32e540490e4926ae9a46b ]

This reverts commit 52cb7f8f177878b4f22397b9c4d2c8f743766be3.

Silently ignoring the "ro" and "rw" mount options causes user confusion,
and regressions.

Reported-by: Alkis Georgopoulos<alkisg@gmail.com>
Cc: Li Lingfeng <lilingfeng3@huawei.com>
Fixes: 52cb7f8f1778 ("nfs: ignore SB_RDONLY when mounting nfs")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index bde81e0abf0ae..161c8fffbc1d9 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -12,7 +12,7 @@
 #include <linux/nfs_page.h>
 #include <linux/wait_bit.h>
 
-#define NFS_SB_MASK (SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
+#define NFS_SB_MASK (SB_RDONLY|SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
 
 extern const struct export_operations nfs_export_ops;
 
-- 
2.51.0



