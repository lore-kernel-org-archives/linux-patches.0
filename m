Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A724E2F3C;
	Thu, 17 Sep 2026 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664794; cv=none; b=gYD8Cv9G2hsPk65NcivPjZqCjIdBt0HlEqnyo6sNS3gwcNFPorWUB8K7nCS/gt8TbwNrDNAaizw01e8ofI6et0bwSx3YBfeTkSVjvlDlXoYZkPRPICfwhUNDbn6hA3q8XnY10v8JdwlM2692IALRiYdI+QoOcBIwccc5OnAuk4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664794; c=relaxed/simple;
	bh=moppdQcd7llF8WiKlOyJRpBb8S+uroE2NSL/M+7x1tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpvtGXoMBhwGWvgwfMiD8N5vsWzmBM4g/rNzRSSlAmEIDbzJA0fjTp5jshxCaRQx3gkWLCAHGCYFR9X/QtuGfEQ4++L9ENcaxbzOB2SfQn+V3QGDmzY6KHJkqZemc8bCaAWg8FVarIA6q3oFZY9VZ13T4vo2F6m/SIXETkfyVrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fE8Kq3jX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fE8Kq3jX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76BC1F000FF;
	Thu, 17 Sep 2026 17:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664793;
	bh=4cbngDMyg2iiOUXgag+/tRbfxp2+KV/BzVRyBFaj7yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fE8Kq3jXUXZeABzN2VlPLw95WDpiogYv8FJm00UO39i2DFDZWXTcfdPktjTCtQoPb
	 9U8G30Hrjp1W3qJ0v3DdwYGqjrB7/LTGuh4v4kT8LlaHSWjWfDP8es59Ul46ZfdRfa
	 pptQvovtu/ghe1uDcHniL/8QqYMR3Yc+qns2zIXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0473/1250] ASoC: tas2781: Update default register address to TAS2563
Date: Thu, 17 Sep 2026 16:04:28 +0100
Message-ID: <20260917151604.790578182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baojun Xu <baojun.xu@ti.com>

[ Upstream commit 64184f07e7516eb3ac1839387eb7cbe2dbeaa96f ]

The previous TAS2781 address is overwritten during calibration,
so switching to the TAS2563 address is required.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20260625102815.20043-1-baojun.xu@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/tas2781.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/sound/tas2781.h b/include/sound/tas2781.h
index 29d15ba65f04d..648fb55073282 100644
--- a/include/sound/tas2781.h
+++ b/include/sound/tas2781.h
@@ -59,9 +59,9 @@
 #define TASDEVICE_CHECKSUM_REG		TASDEVICE_REG(0x0, 0x0, 0x7e)
 
 /* XM_340 */
-#define	TASDEVICE_XM_A1_REG	TASDEVICE_REG(0x64, 0x63, 0x3c)
+#define	TASDEVICE_XM_A1_REG	TASDEVICE_REG(0x64, 0x02, 0x4c)
 /* XM_341 */
-#define	TASDEVICE_XM_A2_REG	TASDEVICE_REG(0x64, 0x63, 0x38)
+#define	TASDEVICE_XM_A2_REG	TASDEVICE_REG(0x64, 0x02, 0x64)
 
 /* Volume control */
 #define TAS2563_DVC_LVL			TASDEVICE_REG(0x00, 0x02, 0x0c)
-- 
2.53.0



