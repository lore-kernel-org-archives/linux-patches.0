Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C919A342CBD;
	Tue, 16 Dec 2025 11:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884831; cv=none; b=ZFIVPdSbJFsE6JPCXmFvYW/239cOIp27rNEWcQrDw9KroO1wpyXbQh0kIImFq4f/CL9HXw2bNCCoTwVuxalAN5Yq4ZFrbMQ1P07lJLmebCzCgRkO6KujaLFGcsMhUv4FRgDmhx2uTj/QWpPu0a3FAJSNaRVlxt07KI8TAymXmc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884831; c=relaxed/simple;
	bh=wxi7rLnlqV7CjoSR1VeKMqesOg09nAn/YbwTkutBTBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qH5aJ8+NiFQRuS0PosqlxBTMy7yTjP6Edb9/uzk+5KDWzxnnr9ViJLj6pQyLL02c/t+k1uWhxIle1/LfF2LF0aA0tFIQv7d3Qc4Wy5kOMwj7ZzPWBbxxIzbTjysDJ+pkzxMvSiMPfr34OoDhN90xG7Efdaw9hxzZXAfrQW2UH8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sznTRQNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sznTRQNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32179C4CEF1;
	Tue, 16 Dec 2025 11:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884831;
	bh=wxi7rLnlqV7CjoSR1VeKMqesOg09nAn/YbwTkutBTBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sznTRQNHCGZOZWr6JFtFXHMkciFKytyPtsErrey967+0Rh0xsmBQYAPstEmRxBSnb
	 20/SSoLR/dCgukNmN40n1Mr3+c3A3Qg8gNI99pUayTXXeadeWDhgpUEplDBxcwHfSv
	 nXU4goo/emeoDbALnYklJDLTxJh54DzklV/dvqAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/354] Revert "nfs: ignore SB_RDONLY when mounting nfs"
Date: Tue, 16 Dec 2025 12:14:38 +0100
Message-ID: <20251216111332.178766528@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 456b423402814..63ee469d6c8f7 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -13,7 +13,7 @@
 #include <linux/nfslocalio.h>
 #include <linux/wait_bit.h>
 
-#define NFS_SB_MASK (SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
+#define NFS_SB_MASK (SB_RDONLY|SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
 
 extern const struct export_operations nfs_export_ops;
 
-- 
2.51.0



