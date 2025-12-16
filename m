Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5EB35503D;
	Tue, 16 Dec 2025 12:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886488; cv=none; b=M0nsMe5611/6CMFwFL4BO6mo0oCh/vT4OkTnpa8Kwdl2nPFs4OJ2b5yMknL9jgRZ+RLO2a00wrCf3XeWcfPAw1ok0vGis7rRdVmfcdkkNnrvjk6XNOoKm8aa8JrRCNvmlLIVLqOsGvfFgQnEHn3qSFaWhw9TWh5hiFkB+r9uPJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886488; c=relaxed/simple;
	bh=ronrqBTE9S+KJkSt8qXzAn05MG+QbsM2oRy+dJmkn8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iD9F2G7vRBixBkaE2Ba5urACXvAgWhM+hZ0blJaKfE1i2qi3jrxhiMyEXV6/XBaxyolhcr5cfYAhjwAw9U3YunEybLSh7sQ8D2gC0vm1SifEDXmV2wPAVCcyncC+Ruemz8gzlEJ/QFZlsce8rQ9SqehGkDPxN40lSuy+RY4fPe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnAcX3yE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnAcX3yE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A74C4CEF1;
	Tue, 16 Dec 2025 12:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886488;
	bh=ronrqBTE9S+KJkSt8qXzAn05MG+QbsM2oRy+dJmkn8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnAcX3yEPQxp1pT6YyTHbkVn+Y1OOjlX32GEiviG7jymsKuqmmDnjdhcoTtK0eMhJ
	 jfMkWl4t3RRcxFbldejhB++RRCKKt20ZPuna9kjPMMqr7fHUQUL/q50e5rbQjB9nZZ
	 uwaDQFwT/LHP04Vfu2pMREFPnX1b/bboirwweu30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 450/507] Revert "nfs: ignore SB_RDONLY when mounting nfs"
Date: Tue, 16 Dec 2025 12:14:51 +0100
Message-ID: <20251216111401.755250995@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index c0a44f389f8f4..5a43543c60b84 100644
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



