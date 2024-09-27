Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4779417B515;
	Fri, 27 Sep 2024 12:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440056; cv=none; b=ZSIjJwZbTsioq1DoG+JdaM01PhHICWUprHpd6lUwvRkrcpGthACsbrhCoCK/uDMv9JKOS6k4+TkY65YKvZaF/QxqV8ix/fe14XNC+ZSTE9rSMTWjsKRZjIKeVCZ6V3sEW0F6I7PPq+F5gXfWCfQG8JEzKuaIlZdgaUEz893gVUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440056; c=relaxed/simple;
	bh=qCG/e0e2GgQR7RPPdOYxNSbFh31Ut0XWvittWo3fr2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZBLaGsHG4flJ2RV3YUJasv8E8BfgcOZmAoIjkWfAUuZF3z8lRqKBHDqhEeu8afSU/mgjWKs8oB4B4bSFX/IczTQONShsLUfv6FR6Z6ld9MbB1l1+hlsKLonxc48Dl+YwTAbsR7dH1dgjpQSoaHfC8oYfSkQmFaqtBlLV6QfItY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKHwm9gH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKHwm9gH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9481C4CEC6;
	Fri, 27 Sep 2024 12:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440056;
	bh=qCG/e0e2GgQR7RPPdOYxNSbFh31Ut0XWvittWo3fr2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKHwm9gHJrMluDs6JVZh/fDEbHxRDNI8sX9XMGT5Z1rBpIux4KBqjhZBY6CukPltv
	 +1Un8hUJ9+vxrjKa4ogeWNVVv6dljYC1QG7QfjgzYNnzGUwNYJSEQxMFABAUScUWCS
	 m4rZjLAHQU69dJmCXfMC6C24n88I6O5YGKNrfQS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YR Yang <yr.yang@mediatek.com>,
	Fei Shao <fshao@chromium.org>,
	Trevor Wu <trevor.wu@mediatek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 02/58] ASoC: mediatek: mt8188: Mark AFE_DAC_CON0 register as volatile
Date: Fri, 27 Sep 2024 14:23:04 +0200
Message-ID: <20240927121718.877305007@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YR Yang <yr.yang@mediatek.com>

[ Upstream commit ff9f065318e17a1a97981d9e535fcfc6ce5d5614 ]

Add AFE Control Register 0 to the volatile_register.
AFE_DAC_CON0 can be modified by both the SOF and ALSA drivers.
If this register is read and written in cache mode, the cached value
might not reflect the actual value when the register is modified by
another driver. It can cause playback or capture failures. Therefore,
it is necessary to add AFE_DAC_CON0 to the list of volatile registers.

Signed-off-by: YR Yang <yr.yang@mediatek.com>
Reviewed-by: Fei Shao <fshao@chromium.org>
Reviewed-by: Trevor Wu <trevor.wu@mediatek.com>
Link: https://patch.msgid.link/20240801084326.1472-1-yr.yang@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
index ccb6c1f3adc7d..73e5c63aeec87 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
@@ -2748,6 +2748,7 @@ static bool mt8188_is_volatile_reg(struct device *dev, unsigned int reg)
 	case AFE_ASRC12_NEW_CON9:
 	case AFE_LRCK_CNT:
 	case AFE_DAC_MON0:
+	case AFE_DAC_CON0:
 	case AFE_DL2_CUR:
 	case AFE_DL3_CUR:
 	case AFE_DL6_CUR:
-- 
2.43.0



