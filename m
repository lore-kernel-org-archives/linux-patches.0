Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D12B4C81;
	Thu, 15 Jan 2026 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498617; cv=none; b=kOKOmfMscXfvtRFu++DYbAlAWrTs02ToMKasDGBj7j93/1NWekAtLX4iaeQP+Lue5HSI322JigJCgFXxQitm2jUdLcobwOrQl12p1VEH2391Tx1LSpUztV/aUNmdu1Tf3z8KVGmjwSgaLFmV4gMTW3uOc0xkgwn9Ow8DR9W+nQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498617; c=relaxed/simple;
	bh=VlUH0oqdh9yUZLoK2OTKXhN7QC58oYLj4XSJuIb04Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVsU0rBzMfXJ3adBEi/u/EdtIGJ565HFKxSL7JRYaCWEwg+tHURRmby5kbN+ij74Ek3rtEvG40Z6tVMvBHukVl8mudJU+o3NYOFEBKgEfGQG7v+764yupURcOBhwo1z4JDxmAJDPg1i0d88Udy+i88/2QcqlFq/dmCvdoIkPkEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6GUvbsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6GUvbsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D8EC116D0;
	Thu, 15 Jan 2026 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498617;
	bh=VlUH0oqdh9yUZLoK2OTKXhN7QC58oYLj4XSJuIb04Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6GUvbsDkvR9PuHLg94nA0eD4JJoobmKxl8JwdU48GMaiEXCKFQHTBZmYFUS3Yy+9
	 fEFBYf6BU/OnwDgwPNrR9iABZJIZnv58cj++8NRGNnLwRuJTCqcdp7zDRbHj8BPbwC
	 Xs4kWEZp61NZt3qMYS0L5Jomp6ZT50rdtuzP9JAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 462/554] powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION
Date: Thu, 15 Jan 2026 17:48:48 +0100
Message-ID: <20260115164303.005974815@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit fc6bcf9ac4de76f5e7bcd020b3c0a86faff3f2d5 ]

Patch series "powerpc/pseries/cmm: two smaller fixes".

Two smaller fixes identified while doing a bigger rework.

This patch (of 2):

We always have to initialize the balloon_dev_info, even when compaction is
not configured in: otherwise the containing list and the lock are left
uninitialized.

Likely not many such configs exist in practice, but let's CC stable to
be sure.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20251021100606.148294-1-david@redhat.com
Link: https://lkml.kernel.org/r/20251021100606.148294-2-david@redhat.com
Fixes: fe030c9b85e6 ("powerpc/pseries/cmm: Implement balloon compaction")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ moved balloon_devinfo_init() call from inside cmm_balloon_compaction_init() to cmm_init() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/cmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -570,7 +570,6 @@ static int cmm_balloon_compaction_init(v
 {
 	int rc;
 
-	balloon_devinfo_init(&b_dev_info);
 	b_dev_info.migratepage = cmm_migratepage;
 
 	balloon_mnt = kern_mount(&balloon_fs);
@@ -624,6 +623,7 @@ static int cmm_init(void)
 	if (!firmware_has_feature(FW_FEATURE_CMO) && !simulate)
 		return -EOPNOTSUPP;
 
+	balloon_devinfo_init(&b_dev_info);
 	rc = cmm_balloon_compaction_init();
 	if (rc)
 		return rc;


