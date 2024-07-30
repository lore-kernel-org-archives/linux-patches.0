Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F9B189902;
	Tue, 30 Jul 2024 16:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357434; cv=none; b=sYl5u4O4ghF/seZCg4kEpygvoXPNpJt3HE2Qw7bsXvSpeffnkt9WwGaaPMV0eyYHeUt2n/c2IPfanDyX0fqG4zgh01kxQXLz5ZFMMiEi05ij7MPuinAnbNwK7p1oqcLkMJct1tof9TMjsm3YyObVw52mhEVCPDMFToOsitXosPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357434; c=relaxed/simple;
	bh=obsY9om4RGj/TsLMRzXtAxR21rjosRiMV4thDaV2H8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY31ATo1cqHxlsWkoY7JRom5uYXl/GTo6A8YEH78G0pNRFtwzSrnIsdvKB32bsicuxmhA6NAUrpr80+7uQ3JO1kqyWml7vTau74F6r1HT+q/K2jKPVO+7GmgC6NVDBHn9k6q5ED/ZQlRrfH3jUSbT3v3j9R2CNwqsoKzEZjqMZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyCpF+oM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyCpF+oM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECE8C4AF0E;
	Tue, 30 Jul 2024 16:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357434;
	bh=obsY9om4RGj/TsLMRzXtAxR21rjosRiMV4thDaV2H8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyCpF+oMbPtGERWTY0nrC1aCCUkXyQpDIPhPMmt6SxDzCBM80pcoLSUuLVFhaw5Zc
	 pBobAYvqzvURZ3NL+hOtAlKx8YfT7fKi6zjsxItXr07XYJGIpxRs9bMCWxp4Muythl
	 +u9bcTZZaJUU9OXPxXG9czC0nT2J3KqqcyyUbSJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 292/440] scsi: qla2xxx: Fix optrom version displayed in FDMI
Date: Tue, 30 Jul 2024 17:48:45 +0200
Message-ID: <20240730151627.236984068@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1710,7 +1710,7 @@ qla2x00_hba_attributes(scsi_qla_host_t *
 	eiter->type = cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
 	alen = scnprintf(
 		eiter->a.orom_version, sizeof(eiter->a.orom_version),
-		"%d.%02d", ha->bios_revision[1], ha->bios_revision[0]);
+		"%d.%02d", ha->efi_revision[1], ha->efi_revision[0]);
 	alen += FDMI_ATTR_ALIGNMENT(alen);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);


