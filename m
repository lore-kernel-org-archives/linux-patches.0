Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00800137750;
	Sat, 30 May 2026 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166936; cv=none; b=mld138PQ7UtRK7oFth3In5IFs4UxujkT4P6AWog72yjqxUvdsindkU1epv4LA9iH/zghVmD6ZGvPzL/q6Oqf4aIye2uGxLSphBoM+KU2Vx9hY1pgYaaa2qp8Gl9yr/RLBQeVpAoLtjrz4JQyP+8cMu2gxa9UJ5OaxpmtPa34K48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166936; c=relaxed/simple;
	bh=tcVI3/PttgSvSsMo96VPVLb8QlIgTxaPEmGxE1GD8tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AOTrDFpC2TMqMV4JW2ksWIMYiQanVYxfv02kBljhCRrQX0USyFhmFtF0BlsrqFcuZGAOB5auWNdx9XPU7ME52i5EmrouSzjBGG4oNVC5ADQsHPi32gpuY9Oqk4hu4WM4VSr4cEOdQkFysxCZ234seBFxcLgxjZzh8wg50rqgpwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faYt0ZQI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faYt0ZQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456EE1F00893;
	Sat, 30 May 2026 18:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166934;
	bh=30GBYwRmRnkHN20sQpu6gmD3fCbMgiK7TW+3AgGs5TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=faYt0ZQI6VX/btf97ULITPna9XWBrjytvYsZUINqUzmGeBZ8uGxRLpF/5/j1wYk57
	 wKSILbl0Ts6+YEc7kSMSaT41k/Nw55FYMvzVKxP2FqHkqdhHYaD3YTWXrcX3d3nR26
	 1f1gCvC+Sv27fZF20ferDWvhfNcTLR9F3o9nqGcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Naval=20Alcal=C3=A1?= <ari@naval.cat>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.10 516/589] iommu/vt-d: Disable DMAR for Intel Q35 IGFX
Date: Sat, 30 May 2026 18:06:37 +0200
Message-ID: <20260530160238.191163241@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naval Alcalá <ari@naval.cat>

commit 2cda2e10dc8343ae01eae9e999a876b7e7d37861 upstream.

Intel Q35 integrated graphics (8086:29b2) exhibits broken DMAR
behaviour similar to other G4x/GM45 devices for which DMAR is
already disabled via quirks.

When DMAR is enabled, the system may hard lock up during boot or
early device initialization, requiring a reset.

Add the missing PCI ID to the existing quirk list to disable
DMAR for this device.

Fixes: 1f76249cc3be ("iommu/vt-d: Declare Broadwell igfx dmar support snafu")
Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=201185
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=216064
Signed-off-by: Naval Alcalá <ari@naval.cat>
Link: https://lore.kernel.org/r/20260410161622.13549-1-ari@naval.cat
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -6225,6 +6225,9 @@ static void quirk_iommu_igfx(struct pci_
 	dmar_map_gfx = 0;
 }
 
+/* Q35 integrated gfx dmar support is totally busted. */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x29b2, quirk_iommu_igfx);
+
 /* G4x/GM45 integrated gfx dmar support is totally busted. */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_igfx);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e00, quirk_iommu_igfx);


