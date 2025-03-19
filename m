Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B9D1C82F4;
	Wed, 19 Mar 2025 14:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395110; cv=none; b=LOBFauwt2X7MdI2ugyIaQgwg5kzLfYgbF7H8MP6rn2DKU1pcY2uMIkHzwZ9eaBFlXc68tZGacp4eZwqdRkKJRm2bbmqRzXQcfx13IipvmK7sY8bzreVMOHKkrVVeJ1/VZG9scqRyrzWs5t0auKZ9L4520l0PMVsiQcLf/wLoF4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395110; c=relaxed/simple;
	bh=mhDozVV6EqDbX7b3r6vNI/9dXnnQJPx8AIAGRfUuHQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlRLeAO6HgUWOKkt4BOvzIt3Ri7m8yrO6KBSB+SeyqDMbDneJJI21W64LTRUd1XoQg+cJUHQ8FwdSOo6Qq20wclZAXX2nzBcCKMxlUN78/TTqSoZoPatblBNAirMLwVIKDz0WDA2dft6brjEZHVojyEjZvlop9RBnsKUFk32X/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TjAmmJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TjAmmJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9781AC4CEE4;
	Wed, 19 Mar 2025 14:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395110;
	bh=mhDozVV6EqDbX7b3r6vNI/9dXnnQJPx8AIAGRfUuHQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TjAmmJrtUeiguycCEQxFj/VpZQ5Zg1LZLpgXVwNVpEBgRU0mSb1WlDILv2CZFeKt
	 hMB/o2MZcUHLfbcSSw1wGMxv8opyYh8RzdJkAJXmLFmMpeOELmt83+pXnfGPluh2Zm
	 CWcl/14QJm0xv5M78wi3FwCBDAgE7KER3ijkjEsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Hector Martin <marcan@marcan.st>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/231] ASoC: tas2764: Fix power control mask
Date: Wed, 19 Mar 2025 07:30:22 -0700
Message-ID: <20250319143030.022299263@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit a3f172359e22b2c11b750d23560481a55bf86af1 ]

Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250218-apple-codec-changes-v2-1-932760fd7e07@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2764.h b/sound/soc/codecs/tas2764.h
index 168af772a898f..d13ecae9c9c2f 100644
--- a/sound/soc/codecs/tas2764.h
+++ b/sound/soc/codecs/tas2764.h
@@ -25,7 +25,7 @@
 
 /* Power Control */
 #define TAS2764_PWR_CTRL		TAS2764_REG(0X0, 0x02)
-#define TAS2764_PWR_CTRL_MASK		GENMASK(1, 0)
+#define TAS2764_PWR_CTRL_MASK		GENMASK(2, 0)
 #define TAS2764_PWR_CTRL_ACTIVE		0x0
 #define TAS2764_PWR_CTRL_MUTE		BIT(0)
 #define TAS2764_PWR_CTRL_SHUTDOWN	BIT(1)
-- 
2.39.5



