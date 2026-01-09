Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C4E31E107;
	Fri,  9 Jan 2026 12:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961953; cv=none; b=BgoGBy5cGRKaPs9OKP39uvpuq3jYNn6qXA99DN4GE/Tz/F4Jz7SBu9GkYVwdG4tKIYq5I2qaGjAba7xffD3z+35wfd6vRsO+9n/SHWjALjXJ53nCywcI7CzUOar9fNVdHXu2LlQZLf68QJ751KHJWaOomGoU2RtSSwrJ7TLHbTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961953; c=relaxed/simple;
	bh=iLjjtIGZqkZdSWMjki8K9ihTPCiaLLIjhPPa8ee6O1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jc64a+QUydlFlDjQden4Q9aVKqG7PHIUrxFQCyn/wqf5UswAoDDeJcSy3V5O3Wseoxj1XQ+M2iedX8nABhLDhY9i2O1Xaz35tu4G6cBAeU9rkNVklUbjMpcHT6l5pQ/IS+ulWafNGop+JYBAb8FsXEgGGqj7ofJATLYlPJ7kihM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVXkl2vq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVXkl2vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26BEC4CEF1;
	Fri,  9 Jan 2026 12:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961953;
	bh=iLjjtIGZqkZdSWMjki8K9ihTPCiaLLIjhPPa8ee6O1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVXkl2vq7in/PiHf60ZvIxKOcRVLOijvlwKTxxGUB9Zo0XYUSCiaZENCdY0LN8/ja
	 VYy3ti8bAJyOZ3EH7Qh+SF893yuUxz8exrwMrxyGCTURqaGqTL9q4xhXNGLbTKxzUX
	 Hx3UH0Zj1xOcDnqnuEjVAlmknco7YrPq3Nh+oYOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/634] Revert "nfs: ignore SB_RDONLY when mounting nfs"
Date: Fri,  9 Jan 2026 12:37:52 +0100
Message-ID: <20260109112124.735982642@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f6ed7113092e4..323f50962a786 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -11,7 +11,7 @@
 #include <linux/nfs_page.h>
 #include <linux/wait_bit.h>
 
-#define NFS_SB_MASK (SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
+#define NFS_SB_MASK (SB_RDONLY|SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
 
 extern const struct export_operations nfs_export_ops;
 
-- 
2.51.0



