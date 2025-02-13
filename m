Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527791411DE;
	Thu, 13 Feb 2025 15:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460478; cv=none; b=R/Xrygjh55dfyR/T+dVGyV6elhVOH6z9EZrDlZ6mmQwQ2q85C0un/maR8vIY+6J08kpKMqvQpsFvTEZAKb/0BC/6SDsCyp8x/BKOm/dYHX3ZUzo0nnYjm6abdg+VB+GDF+ZM0VjxftikvVCFmF1OqJ0iKk8tTR6ShJyYYeID5yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460478; c=relaxed/simple;
	bh=hX48zKxI8IIh4jS2dJ5pvQfNgu89/htwsh/awtN4Cbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiVLlf7fDSgVKbzBmef3Jv65cohluFun/bmfS4kUHcNraq6yzSOADQ4ptCSjXKZ3fPPodG6Hmq3wVRnwLySS7xSmtK9nm++nZh2fpFT2zFdEmJKYy0gTvI4bf+5EbdO5cKjnL7n+9JylhtLwpREeeQDM8EV1qn2061d9JOUEAAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTS013f3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTS013f3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B9BC4CED1;
	Thu, 13 Feb 2025 15:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460477;
	bh=hX48zKxI8IIh4jS2dJ5pvQfNgu89/htwsh/awtN4Cbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTS013f3yW3abtD224eS8DP4vrGmA9IN//0uJlUdEzeBZQEnZRfS4FTWrnaVMHuit
	 p1gwiKawvupllY3GCi1xYfIHXBmtR3VM5+LUfL5pGFCgm8ZQFp7k8C4WjoUr1rv64V
	 cZx58K2V/xSvpKsWKc8S9bsrL7UKXzCe2Io/iqAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Avri Altman <Avri.Altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 122/273] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit Definitions
Date: Thu, 13 Feb 2025 15:28:14 +0100
Message-ID: <20250213142412.165048940@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -384,8 +384,8 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
-	UFS_DEV_LOW_TEMP_NOTIF		= BIT(4),
-	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(5),
+	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(4),
+	UFS_DEV_LOW_TEMP_NOTIF		= BIT(5),
 	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),


