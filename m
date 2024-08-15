Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0CC17BEC0;
	Thu, 15 Aug 2024 14:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732299; cv=none; b=tJ3MnyDXouQIEmgwwTVS9RfF96syGd8nDKmiR0+0VJ5sAY2GGhsSnQkCuaYLODxKXWUveE0FVjBJKGvKh1aiy7jnizRkYXkufHV1aQTltljRuAivXgxhL5JQl0ETtSPccsVXod+6yDie56BBwb/Dxz+Yrk7qvFJ6bd6PKbVYRh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732299; c=relaxed/simple;
	bh=AvHXXcdUumRaKWPCxfGBy4A/BlVv2+6FDTjNUuF+Zog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6QJPUPO/2Ght2DiKMbiRuXTdxUfk6E/hfpSWLDFzAdoM4TQq/zG+mmRAxr/7ADQ51U3HxBqNZe/wPUV+cbD9u3rN0DTyLvAZhmTuvXMr8WQ0gcVDTXZZ4HNmkJuEc8aEkpCmquxS9emqR97232q58z2zfQ/vVEY2hRWur2zlzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxkxvBtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxkxvBtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B487C32786;
	Thu, 15 Aug 2024 14:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732299;
	bh=AvHXXcdUumRaKWPCxfGBy4A/BlVv2+6FDTjNUuF+Zog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxkxvBtDbnHvgzH04uuFMBMSfA6gXWsoGf8jsMWpi1sXqxeNf0p4XalQEWKqKykwL
	 CPpTOdUDPzVl/Y0JCd8Ll+cdePgHdbFeBjx7b4TLwfP7fwcZy4A1v5cO92s39wvp+2
	 3G4eOFs8CgqHNW52sJ9qx6XqjAl3BvSUEmxfOmsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 136/352] scsi: qla2xxx: Fix optrom version displayed in FDMI
Date: Thu, 15 Aug 2024 15:23:22 +0200
Message-ID: <20240815131924.512426941@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Shreyas Deodhar <sdeodhar@marvell.com>

commit 348744f27a35e087acc9378bf53537fbfb072775 upstream.

Bios version was popluated for FDMI response. Systems with EFI would show
optrom version as 0.  EFI version is populated here and BIOS version is
already displayed under FDMI_HBA_BOOT_BIOS_NAME.

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240710171057.35066-9-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1708,7 +1708,7 @@ qla2x00_hba_attributes(scsi_qla_host_t *
 	eiter->type = cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
 	alen = scnprintf(
 		eiter->a.orom_version, sizeof(eiter->a.orom_version),
-		"%d.%02d", ha->bios_revision[1], ha->bios_revision[0]);
+		"%d.%02d", ha->efi_revision[1], ha->efi_revision[0]);
 	alen += FDMI_ATTR_ALIGNMENT(alen);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);


