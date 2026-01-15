Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CB04C81;
	Thu, 15 Jan 2026 17:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497716; cv=none; b=PYQunwEMM11bqFf47KGCrHC/9x+mK5szGKyMsTUWRft01LFmOSDPKUV6cLan3ojPV/OOO56EGRk5ntahgGmd58B//N93+8pigm4MeNw1G0hU3KSxpXDvMNSfdcmuc8ySLOYcRFqG8TIYquA7OxXp9DVkmrvN2VSDrZBgVF9HXS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497716; c=relaxed/simple;
	bh=uQi6Luv4GitAOA5gKIZgj3wuNd44bYBtzK+6QGwkAO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5bHqfunRNL0KyeZ3Ar5Hf1Wrq9qr26d6uA2gY9R95Kgy75S2Izs9o+ZMeJ2YQWr/NdG95gxR2BtCkb2St1ik+vGRw1gCvqVmJX7xeqXPAeV0OXo10oqO7G08NHVSJBY+3bVZnICbbEQW42CLO9qRIqc33M4fIklZz3/1vydLyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/wGJFNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/wGJFNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B89C116D0;
	Thu, 15 Jan 2026 17:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497716;
	bh=uQi6Luv4GitAOA5gKIZgj3wuNd44bYBtzK+6QGwkAO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/wGJFNcZo6IITNjKSgS/5SvAEK/H+Vqcs2GScuZfg34oAi3L5q7CP/AEMZIa26IH
	 66HB80RGclhHs9AX0dJcvqP6ymIm8lJsdehjDuN6KKmURqRy1OyZ17dleRk1MaTvlk
	 I0uclspW3bWXfhOCU171SgyuFJwUpCD7b38zwo/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/554] Revert "nfs: ignore SB_RDONLY when mounting nfs"
Date: Thu, 15 Jan 2026 17:44:05 +0100
Message-ID: <20260115164252.745028179@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 00066057b1415..fc0a34e488617 100644
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



