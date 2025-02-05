Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED69A35946;
	Wed,  5 Feb 2025 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767928; cv=none; b=e5QR7MdXBHNG2bWNmQJvu5TCqv/fNBxIv1jOCZGjcKwsknCXNslzbiMubPIf2PMaliyBUU9rWMy5N/pen7WmhYhT2fBdwSBX4GL77hB8OB/w9+FMbkymfHBOmG4MbI3o+Zzh8DJiUrBmhIACIse7mgzWzj0g6qTmmvLnu62p3gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767928; c=relaxed/simple;
	bh=fLqYKHyBSGose0Vts4ruPCswdq03Gqs2NO2fHqBFY0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXIDFk2PXLdSBS5pmqVHBPRxVcwqSZtkUssUqsNmgh9jVw0/N+pGB2SXBdWKTsEKimkJoIKusOvtaFHARM5g5u4VEewPJZOxSpGrCzZ60U7Ex81AFZDG999vy6QFopjab0d6FyMKkOIuT1y6967pDA8oSsmgq6d5rrhmEOO5IvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkpjalvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkpjalvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F3FC4CEDD;
	Wed,  5 Feb 2025 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767927;
	bh=fLqYKHyBSGose0Vts4ruPCswdq03Gqs2NO2fHqBFY0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkpjalvIbPHRsdViPHyTJK+JazyE69uTGDPHMe7alUKcy593A/4XgHt9ENtrUZn25
	 HbK7xO6wa9Q4Cr2YCrPJGNLL/jQAYTEnY5vgXz5q/QPdedVc863BRh0GLZL85JvQkb
	 16SPSIrInEdVUV50xhIQr/TjLPGmcmCOPD6BpVtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 473/623] scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1
Date: Wed,  5 Feb 2025 14:43:35 +0100
Message-ID: <20250205134514.313531219@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit ad7c3c0cb8f61d6d5a48b83e62ca4a9fd2f26153 ]

Currently, the code does:

    if (x == 0) {
    	x &= ~0x3;
	x |= 0x1;
    }

Zeroing bits 0 and 1 of a variable that is 0 is not necessary. So directly
set the variable to 1.

Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://lore.kernel.org/r/20241212221817.78940-2-pmenzel@molgen.mpg.de
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 16ac2267c71e1..c1d8f2c91a5e5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5629,8 +5629,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	if (!ioc->is_gen35_ioc && ioc->manu_pg11.EEDPTagMode == 0) {
 		pr_err("%s: overriding NVDATA EEDPTagMode setting\n",
 		    ioc->name);
-		ioc->manu_pg11.EEDPTagMode &= ~0x3;
-		ioc->manu_pg11.EEDPTagMode |= 0x1;
+		ioc->manu_pg11.EEDPTagMode = 0x1;
 		mpt3sas_config_set_manufacturing_pg11(ioc, &mpi_reply,
 		    &ioc->manu_pg11);
 	}
-- 
2.39.5



