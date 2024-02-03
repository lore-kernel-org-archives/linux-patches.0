Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59D0171A6;
	Sat,  3 Feb 2024 04:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933534; cv=none; b=ajS4YF0fDW5d6TaZh66zvXDON5LE5BXcJTINj1j+x1sH2kU6G6h/G33d2zPGzUQma8Z3RyDaLgAuq/u1Jd11y2jojeV64Lx81gDLffPGSIDVf+xhbk+WBgfFJBekGyXl5tI1cGlx8fzgdWbgh8JllGSHwwQAGUNvF6ORVY6XQA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933534; c=relaxed/simple;
	bh=988bYwNPUCLu0SrFXBjxLvs0yhfvkvGKFqd464+O+jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfg0bmmxhIJf2IfVrHeyV7EsjkJqIOqH9Ol5zEgSHQ8TYl0xCknwQtOekxRiMk9o5Wpu+r3cuvxPm3Thq9onlXRKX6hY0/cW+fRYuBBJZIQ8aA31ebYur88GcE2CG/aGre75RVOLrbfb9eKs5XOAT1KC1muzS62rZCaGK9KCbgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oarZdWEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oarZdWEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC1CC433C7;
	Sat,  3 Feb 2024 04:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933534;
	bh=988bYwNPUCLu0SrFXBjxLvs0yhfvkvGKFqd464+O+jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oarZdWEZqMU0V1aFktCJZUl4gHz4Bo459N59A7auOMS4hEzl9a7UCoN4C6dUV7mMo
	 RhWLudPucfrUc6rzeWIMnpjxypac4ZZ1xSJvp08/HD51j9mojRi48Uj+oEK6hZmnLV
	 Aj/nITmeFbaa4TKIVjaKFqo7+O84v3yDH8FZz5E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/322] scsi: mpi3mr: Add support for SAS5116 PCI IDs
Date: Fri,  2 Feb 2024 20:02:56 -0800
Message-ID: <20240203035401.718180473@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c7c75257425d..5c50701aa3f7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5424,6 +5424,14 @@ static const struct pci_device_id mpi3mr_pci_id_table[] = {
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



