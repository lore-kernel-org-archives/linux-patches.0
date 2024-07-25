Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0728F19AA5F;
	Thu, 25 Jul 2024 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918439; cv=none; b=LVQPmD6aq3qb5xEW04pskMtU8+ZsSb+Dive9NLOMUIuSdQRQxI0qhlu1B2Hv4Y3P1o+nG78FjC4eZX4zoUJ9Zn9cJNeYa+HYcB6AdXigfNN1Eo7qzgf6msS/4/SARb5+uGLoIHCcfrFtVC1GLq6bu5/dlQLjsglAuT3Aw+mNMM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918439; c=relaxed/simple;
	bh=EBPnpkgm3VxHGYQ0Q2FhgKaHypFKjygLWUKrEeVBlf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Na/feuPv5+cPlabc0f16mEOoXKz/Ux0Voz03noR56T5+EEXWLXBGSmcKJHYjXw4GF/ycfOrCpjyTm0hIVjlxPL61FRggZEKWMDU/3iA4WBh66dhiGih6HGl/hsj4+OZ0sNRbs3XlAQ2WVZpic8v2O5Mwi0Ny1+LM9w/5zQT7NPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPkKi5HB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPkKi5HB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A863C116B1;
	Thu, 25 Jul 2024 14:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918438;
	bh=EBPnpkgm3VxHGYQ0Q2FhgKaHypFKjygLWUKrEeVBlf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPkKi5HBJGSIUF6LykiS73rzbSA+vzw+kZd3wCFfm12owwwK3ArqVtXgGo+kGPYwF
	 7XlP9xsKkgVXqLT3oQCZWhIl+K9T9fjktziAG1O83uCvg2GtqwQP6zfPVUObIw8GRK
	 V+xsJESEzrMEs+luybmhm+3VcFGIAh7hGB/RznNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/33] scsi: qedf: Set qed_slowpath_params to zero before use
Date: Thu, 25 Jul 2024 16:36:25 +0200
Message-ID: <20240725142728.607944263@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 6c3bb589debd763dc4b94803ddf3c13b4fcca776 ]

Zero qed_slowpath_params before use.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240515091101.18754-4-skashyap@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 01e27285b26ba..33fb0e1926831 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3101,6 +3101,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 
 	/* Start the Slowpath-process */
+	memset(&slowpath_params, 0, sizeof(struct qed_slowpath_params));
 	slowpath_params.int_mode = QED_INT_MODE_MSIX;
 	slowpath_params.drv_major = QEDF_DRIVER_MAJOR_VER;
 	slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
-- 
2.43.0



