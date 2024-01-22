Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4E833CC3;
	Tue, 23 Jan 2024 00:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969628; cv=none; b=lF7gDlv1MDC1onNjnX5uH1flPJQYJFiRHStshR07ihkTDhckfMVCr/BHCEzxIcet3Z1Zkt2vZNj9fpDH6uaVhPfx7X1DVt15v3kCxtZDxMbC3EUIfUJI1UhmKIdcZs8zCCmcEceakSvKbFyDjFsMQCKaQ8/o54Rb6qaY/M5cblU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969628; c=relaxed/simple;
	bh=NEUeNftfmukrS54J+hzYqFc3ffVBtnKi7O/v1OymfG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BS4eli+uGU+UYz7+DsKz6JlOsN8y+T/bd8PThaO8VxdniYB8B55vogMlCBs8LoZvqgct6gSWeg56Hu4NbmH7wzRtPHUV3J2ryM/vFCIOXf4Pw5w2N1XfT4Dm9kGRjniVSPRfwxjy4jIpACEPW14xF57VbQc/SluBo3pqWBdcEMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0Qog0LW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0Qog0LW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EEFC433F1;
	Tue, 23 Jan 2024 00:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969628;
	bh=NEUeNftfmukrS54J+hzYqFc3ffVBtnKi7O/v1OymfG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0Qog0LWGytmzfKymYmQkjfAVnHMaA+9191QUFd7jax7kxq3QJvNX8jmVlKz5XozL
	 y5AxSVGoafgJna+o39Yv0aBpdql48+CJM/kjO6BeR0Fp+h44opFLe1e1OqfTkB2E3q
	 PQhfLuvbLsIwFZRTTT1LeRGiLdaJFJqhEHViA2uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 344/641] ASoC: tas2781: add support for FW version 0x0503
Date: Mon, 22 Jan 2024 15:54:08 -0800
Message-ID: <20240122235828.689985957@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit ee00330a5b78e2acf4b3aac32913da43e2c12a26 ]

Layout of FW version 0x0503 is compatible with 0x0502.
Already supported by TI's tas2781-linux-driver tree.
https://git.ti.com/cgit/tas2781-linux-drivers/tas2781-linux-driver/

Fixes: 915f5eadebd2 ("ASoC: tas2781: firmware lib")
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://msgid.link/r/98d4ee4e01e834af72a1a0bea6736facf43582e0.1702513517.git.soyer@irl.hu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-fmwlib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 5c09e441a936..85e14ff61769 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -1982,6 +1982,7 @@ static int tasdevice_dspfw_ready(const struct firmware *fmw,
 	case 0x301:
 	case 0x302:
 	case 0x502:
+	case 0x503:
 		tas_priv->fw_parse_variable_header =
 			fw_parse_variable_header_kernel;
 		tas_priv->fw_parse_program_data =
-- 
2.43.0



