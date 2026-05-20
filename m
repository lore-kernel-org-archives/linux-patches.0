Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB733F660B;
	Wed, 20 May 2026 18:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301666; cv=none; b=Y+dUY92DSTq8Oz4iBiKKXyTKR2Ptp3EvtGLV1Z+M1E6iWvfG/lyzmq8Mm3njBvsviaR6XCuQSMEviQwdTQmtLF3ZOSFy0JPmaNPTc5OaDYsDMZTurvgeGRYkZRrYbKifQDKz6ualigcKb5ROn8JOW08YD1PZMoJ/qWCSBbTtSTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301666; c=relaxed/simple;
	bh=C3wcY7wIANH9cjG+rTkXnY4jBNCrRqPk4ZyvDe6pkh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HF8xIlaUjcXZX+89gAOXREMYhmMGqOMT4nXw5fqUSem7UJqDWjDx9sMiXzmMl95MwA+De8ZbfQhrfMHmM17lVeLtoxze5v8XDZEz24BbMK8UcglvaD1c4kcgWx9lSvFlj5lJ+4lpGt0Au/Vc9gzJV3g8ds4riFuqke/eaBIHd2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/ff7s8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/ff7s8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03EE1F000E9;
	Wed, 20 May 2026 18:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301665;
	bh=EIXar/VW/VnGuPhKMrmzSiA8UKPpfYnO/gabN3jbdKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/ff7s8Vp7bk/42oHTrEWurJol45Zj1mrauMpLW20hzztWgRuTqMn6RZJm7TGKPNR
	 U8lpSelIxqggOad05lIJGWQtodpribuLT4eTu64NmJ8X75wdS8iiZjhSXJ9MEcCGVt
	 2QV8xY0PVSSsXNJQlksO6qcbkrgfm8CODxPto4zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Naval=20Alcal=C3=A1?= <ari@naval.cat>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 640/666] iommu/vt-d: Disable DMAR for Intel Q35 IGFX
Date: Wed, 20 May 2026 18:24:11 +0200
Message-ID: <20260520162125.148465278@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4684,6 +4684,9 @@ static void quirk_iommu_igfx(struct pci_
 	disable_igfx_iommu = 1;
 }
 
+/* Q35 integrated gfx dmar support is totally busted. */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x29b2, quirk_iommu_igfx);
+
 /* G4x/GM45 integrated gfx dmar support is totally busted. */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_igfx);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e00, quirk_iommu_igfx);


