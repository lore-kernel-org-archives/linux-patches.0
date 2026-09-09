Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93273598BF4;
	Wed,  9 Sep 2026 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963777; cv=none; b=Ogwi40hha4FoYuqBHukVlVqCK61B3KSa84SnMBnCuYQgIjJkpwgL/uPjcXIAzjLsH1MYXUPBJBbD8vFxq5N1jo0+pMlEuGsJARopRZX6hAQNcS0OnhzDgh0UhGHLO2hMJk4OhuifejOxdhIayxDn2q/Bx0xI2tu8EwF9CKXnOaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963777; c=relaxed/simple;
	bh=61urAlROt90lmfcFrDpnSNkblbdF6KWrRyubxwSJhMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJZP2n/vDKbCzTk3eC/tT549x44JjWkP3hJGnotlqd5kfxke7u/ckPKsDRS2fbZH0ouoW9YJ9/vKDsY5zVmD4YySAK3LnNNpC3Y3ArAKJO+kWyjTZCntA3tNqxrggUaaoYcn7NgHAEwPCYgMvZd2ieM4AAHwPs+tg6cKuzWcv/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBP4u8ss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBP4u8ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAE51F00A3D;
	Wed,  9 Sep 2026 14:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963776;
	bh=nFjV3MdF0skax4CIZisi8xJ6t9Mx5majXnpomr7KVxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBP4u8ssJwEBPqIPrXU5AJvopcdkneg+2EZ3QPkSvvPX2aKFUL8eL9uAV84kxTh3G
	 Ce2hqteWZ+2qCkMGy6RCeXV0qNtvau5HrSrRB0Xer7dT+E+SALtp3xY9hzQufMssCG
	 TdNnFNZT1VZhOiWwtRCExSP/RVNmAKoY9tjWDcRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 195/583] ASoC: tas2783-sdw: drop duplicate reg_default entry
Date: Wed,  9 Sep 2026 15:38:00 +0200
Message-ID: <20260909134244.917569852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit ceba07ca24fab54e0e38ec96d196fca3e638d671 upstream.

TAS2783_AMP_LEVEL is defined as TASDEV_REG_SDW(0x0, 0x00, 0x03), so
tas2783_reg_default[] lists that register twice.  Drop the open coded
second entry.

Fixes: 4cc9bd8d7b32 ("ASoc: tas2783A: Add soundwire based codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805091327.23944-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2783-sdw.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/codecs/tas2783-sdw.c
+++ b/sound/soc/codecs/tas2783-sdw.c
@@ -87,7 +87,6 @@ struct tas2783_prv {
 
 static const struct reg_default tas2783_reg_default[] = {
 	{TAS2783_AMP_LEVEL, 0x28},
-	{TASDEV_REG_SDW(0, 0, 0x03), 0x28},
 	{TASDEV_REG_SDW(0, 0, 0x04), 0x21},
 	{TASDEV_REG_SDW(0, 0, 0x05), 0x41},
 	{TASDEV_REG_SDW(0, 0, 0x06), 0x00},


