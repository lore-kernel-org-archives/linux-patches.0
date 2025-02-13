Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F5518A6A7;
	Thu, 13 Feb 2025 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459263; cv=none; b=CLyPeDHD9349ErlczNzPqAgCYUeBs0HzZSc514VgJIfDC8c5vsz+lSN5cE/EwcMdYRp3LrXw8X1qYIa7caG5dh3vFjLDd33e62YTXO7G5mnWgPH8PrrGU9I+1jnP+DIgpkdPS9Si6ZAuQCvL2MlXtCjc1EpihmYiAmLNIQWAhAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459263; c=relaxed/simple;
	bh=NEqQkHa+6ddkS5XVxOJvB0+QBrUINR1tkpii9EagaCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=We3iUQanpcDTvyhkH6NBxN33XZQIJNMrjBGTMZlLAHCloKhxoj7wC8shBnU2QY95WHNCkBBJ8e5Krx2Dh6ICgwSbGmiBB3V+6l6Jewmlss6OBx3Vrjqx3CBxpbd5X4QKsePe5ipwE54P6Q+wf/rxxd1bNO/OKHWj7Gv4hvjsZbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1Nv/Shs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1Nv/Shs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1333FC4CED1;
	Thu, 13 Feb 2025 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459262;
	bh=NEqQkHa+6ddkS5XVxOJvB0+QBrUINR1tkpii9EagaCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1Nv/ShsfKWKwXcP9lGugnlOFmATlHwIwBAjLUtzN667xhsOU1VwKfMIY7IZeuRFe
	 CTHqRVnLmB44wUZ812jcoO/2hoF9XMTtCa2y9LVj8q5ZB3VOgj7d1YRVK7PzesfNj6
	 fo8fr/OdpyYSsN5qu4jUUsuBBSc5i3O55KOndqZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Avri Altman <Avri.Altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.13 214/443] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit Definitions
Date: Thu, 13 Feb 2025 15:26:19 +0100
Message-ID: <20250213142448.874096105@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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
@@ -386,8 +386,8 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
-	UFS_DEV_LOW_TEMP_NOTIF		= BIT(4),
-	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(5),
+	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(4),
+	UFS_DEV_LOW_TEMP_NOTIF		= BIT(5),
 	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),


