Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020721DEFE1;
	Wed, 19 Feb 2025 09:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956974; cv=none; b=D/EXlLdJg3kTbgirbS+LSjvAaxTJ0nDYlqn6BQRn2Qmu35saGZrBVPzEN8dHi4Whv3aRZeGgb0n198ROBQ8nDcUGN3sDQS5v35rjTMLQSQvpuoK/+24NtlSjP6Z/S6azvzsNE77fU6dDsatg63aPUUT0HAi4UtRFOLvSX7QZl+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956974; c=relaxed/simple;
	bh=1q3ajflRX+2LRMBS5Onnzi2qXi3ID4oipfUuh1UK2lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUE92fK+Zn8t5Me6DdjVYG8zMnfy4tWczU3e+WsC2wwLxrRcfi7vd56+Ou3uyjoyBt04SkZgvQBI+gK8Vb8bLY0mYd5r4T7Kgre8sufQwerXYYhwA03MTdXEu3BJ5fTXvrnuFame5MKUoDapgYhrQwpaVuBlphQkV23UGijbFC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ofg8x8rj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ofg8x8rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D37C4CED1;
	Wed, 19 Feb 2025 09:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956973;
	bh=1q3ajflRX+2LRMBS5Onnzi2qXi3ID4oipfUuh1UK2lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ofg8x8rjgZ/77ERKIZF56BJnhoCbstlE8zKKsz3xOhoNGh3Hc1Y9dljne9AHQ94YT
	 gFh6awmajSNUyLIYqvZscgp+53uZwbloDduyeOK2YreTiaTeQcXdiVHy1cXNnkjhHl
	 gW2EAYbFXqqut6AbvxK4hI7nguW48Ek+ngSmA6bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Avri Altman <Avri.Altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 365/578] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit Definitions
Date: Wed, 19 Feb 2025 09:26:09 +0100
Message-ID: <20250219082707.375891969@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bao D. Nguyen <quic_nguyenb@quicinc.com>

commit 1b3e2d4ec0c5848776cc56d2624998aa5b2f0d27 upstream.

According to the UFS Device Specification, the dExtendedUFSFeaturesSupport
defines the support for TOO_HIGH_TEMPERATURE as bit[4] and the
TOO_LOW_TEMPERATURE as bit[5]. Correct the code to match with
the UFS device specification definition.

Cc: stable@vger.kernel.org
Fixes: e88e2d32200a ("scsi: ufs: core: Probe for temperature notification support")
Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Link: https://lore.kernel.org/r/69992b3e3e3434a5c7643be5a64de48be892ca46.1736793068.git.quic_nguyenb@quicinc.com
Reviewed-by: Avri Altman <Avri.Altman@wdc.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/ufs/ufs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -347,8 +347,8 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
-	UFS_DEV_LOW_TEMP_NOTIF		= BIT(4),
-	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(5),
+	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(4),
+	UFS_DEV_LOW_TEMP_NOTIF		= BIT(5),
 	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),


