Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF5D4DA18;
	Sat,  3 Feb 2024 04:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933805; cv=none; b=Y5O31YWbo6tzrGff/qNF0SkIUQOdRjMUB77LRHMb23hW0+iPFwwzcAO2+xqmBCPkWw2Xow3xaND03i496CS4HsGnFOF2CspqMOu7hTaeVxkXyhJPhF7oAlNtJsOc6PsH1txsn9XULDbeDuhrSQWW9VwliohPrn+0V59yX/O841Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933805; c=relaxed/simple;
	bh=N9m+UH/nJ9hf3PJ6J1iiybndxyerGOGTW4q9xmAr+hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7Emuq0QYublbsl7usIuEVgnSK6HUjZfuIhsHTAUd2/1v/V8yksBIKhbOpGviHV9AV0wSg6ukMLZE5VvTWOAw/LvXyHirjwB89/tx05FN0DZBkvueMFhOY573y4STDDM6zQOamFeBlrOsxAUF+i/wwpDp7TfQFRMnud/BV2BbOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSvSXrP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSvSXrP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3546FC433F1;
	Sat,  3 Feb 2024 04:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933805;
	bh=N9m+UH/nJ9hf3PJ6J1iiybndxyerGOGTW4q9xmAr+hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSvSXrP9C0F6oohB4NH/wCajARCgqKkHYfr1rwl0sDEgq5GEUmhc4csHYa7syvK/Z
	 fC+BuZXIb1PsKdPmucliukXzcnopv4V0NJ1s0GYyJfaSga+FDEqYsW8nuy1chVmP6j
	 uxryhJgP1yQXWKGH3ebiTG3Sbp41vLkUEMRPj2ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 084/353] scsi: mpi3mr: Add support for SAS5116 PCI IDs
Date: Fri,  2 Feb 2024 20:03:22 -0800
Message-ID: <20240203035406.466421604@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Saxena <sumit.saxena@broadcom.com>

[ Upstream commit 6fa21eab82be57a3ad2470fac27b982793805336 ]

Add support for Broadcom's SAS5116 IO/RAID controllers PCI IDs.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Link: https://lore.kernel.org/r/20231123160132.4155-2-sumit.saxena@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e2f2c205df71..94adb0b1afc9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5441,6 +5441,14 @@ static const struct pci_device_id mpi3mr_pci_id_table[] = {
 		PCI_DEVICE_SUB(MPI3_MFGPAGE_VENDORID_BROADCOM,
 		    MPI3_MFGPAGE_DEVID_SAS4116, PCI_ANY_ID, PCI_ANY_ID)
 	},
+	{
+		PCI_DEVICE_SUB(MPI3_MFGPAGE_VENDORID_BROADCOM,
+		    MPI3_MFGPAGE_DEVID_SAS5116_MPI, PCI_ANY_ID, PCI_ANY_ID)
+	},
+	{
+		PCI_DEVICE_SUB(MPI3_MFGPAGE_VENDORID_BROADCOM,
+		    MPI3_MFGPAGE_DEVID_SAS5116_MPI_MGMT, PCI_ANY_ID, PCI_ANY_ID)
+	},
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, mpi3mr_pci_id_table);
-- 
2.43.0



