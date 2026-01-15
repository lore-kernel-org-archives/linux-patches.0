Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E16B2BDC13;
	Thu, 15 Jan 2026 17:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499254; cv=none; b=rSiMXNHXMoBSc3zOUEeMO2mKPwHJMwEbXNxjhEpLBW5uCSgLK1aFbLLdS0Vxej2Cb7v/RRj3m4ZExM9x2lXTjSTfJgcSdSYHeAJZdUK7l/84+g1/JRyJvgWa+msznlamiX4k1VwLim5hUnoPcGbkjszTJb8XXvNAB6P2sdkdt6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499254; c=relaxed/simple;
	bh=9/ub4R7db/trcoShj9psoB6dN2Cm0IPS0q8K33YFDV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTrB2CWDMUeyHgNJFkGyV0z/G0iKbFgU1cgHYjY4boU0+KKhDjCZV6RzEwVCKbnfoj/7/DIrE8Zs6ScgneIz7b1+N/GaiXx7uLyfwyqgM7n0OZrsd8OTlVuy+Esr39+WmFpsVOva1IMUlfNNmXQPgmAkIV7kXV4FjgAwUmIEOKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fA2zAe1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fA2zAe1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0B8C116D0;
	Thu, 15 Jan 2026 17:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499254;
	bh=9/ub4R7db/trcoShj9psoB6dN2Cm0IPS0q8K33YFDV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fA2zAe1C51rf7owRxxcSGmKoNjuWchX+8pjBUHXFPtFnjWPoBofABmD5gvGi9bo9+
	 CkLLPPQUTzYres1HEVHY0A0y/40yIz+VZ0Q4Ww6rrOdRSV83aB12DIf16ufqdzor1B
	 imv82jh2BP3UKsm4+zjad5I//1TnTDH/KfWPRazA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/451] Revert "nfs: ignore SB_RDONLY when mounting nfs"
Date: Thu, 15 Jan 2026 17:45:30 +0100
Message-ID: <20260115164235.589199188@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 10759e1b89fb2..fd15280e827a0 100644
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



