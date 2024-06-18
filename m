Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CD4153819;
	Tue, 18 Jun 2024 12:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715236; cv=none; b=qlc/uXKUdNnvbvI5S5RYqmxR3dYi5CfjlFrxtj2kiMjyKOeuocYKLo1LBDKXekZ8DMe/Vh4JC8VD4dKeubgW5nkLCCHk8jXqFqy5EUaOYCD4k+IrEDSLbCfs5R6feM+UkhSroor1OVap0esmSce3WpE5ugUISMLQhPJF2LefApU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715236; c=relaxed/simple;
	bh=ywPmey+ldqGQUMANH4znrNcQt0cJkachknUGyEZ3oFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efgWpQf+MflX5Ia3hVd01otj7gPvbgTFhfLjcfoYRdcGn+DCWlTYu00Fsvsj80NgOCE/65mmNeq65vA1/ddsFDNCcp4kzBaa1CckNAUr45c2yuwcHmd0XBjZNT6IpLiZUlxu54LQHlFc/HzyzGjnmmnoPcC2IzOn39Pupm2UDBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3SJ3rpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3SJ3rpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929E6C3277B;
	Tue, 18 Jun 2024 12:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715236;
	bh=ywPmey+ldqGQUMANH4znrNcQt0cJkachknUGyEZ3oFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3SJ3rpu+vHkn/qlaOc74HhVMe0l+xXpEO3KANxz0vC0rIAGVMXBneWBwlm6UtbSr
	 924fI3ppiGiPaCx2GZXXumfJLgcoOuduH3tRb4otF5TYtg8gz5VhTAU13drJfzcCtI
	 DEbEtvreP8HteoxosvIEo5/yi4Ifag9InNaOYbRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/770] NFSD: Clean up NFSDDBG_FACILITY macro
Date: Tue, 18 Jun 2024 14:31:32 +0200
Message-ID: <20240618123416.504287026@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 219a170502b3d597c52eeec088aee8fbf7b90da5 ]

These are no longer needed because there are no dprintk() call sites
in these files.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 3 ---
 fs/nfsd/nfsxdr.c  | 2 --
 2 files changed, 5 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index fcfa0d611b931..0a5ebc52e6a9c 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -14,9 +14,6 @@
 #include "netns.h"
 #include "vfs.h"
 
-#define NFSDDBG_FACILITY		NFSDDBG_XDR
-
-
 /*
  * Force construction of an empty post-op attr
  */
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index b800cfefcab7a..a06c05fe3b421 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -9,8 +9,6 @@
 #include "xdr.h"
 #include "auth.h"
 
-#define NFSDDBG_FACILITY		NFSDDBG_XDR
-
 /*
  * Mapping of S_IF* types to NFS file types
  */
-- 
2.43.0



