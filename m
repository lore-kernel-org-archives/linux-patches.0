Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4453081D7;
	Wed, 25 Feb 2026 06:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002693; cv=none; b=eo3wkqo+BOX1XTOirtx3sLSGaDUs3uPgGTGgaxdn5nzabGQJEPnlCVBR7H2G9I4Y516qkPFnixWXzVBrRHx1EAR4g8mGcp0G7ZAUU/pAVERvorZt7V5CITzUUuLPg73m3uGE9CnuE4KbHHaLd96xv9c65GmlbZ1cn1oX76ePNB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002693; c=relaxed/simple;
	bh=j2xwMmpoxMlzyR54aQX/0bT1RG46u4o+s0ioCK8oRtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnQoovSBZLkK0UXbrUsPWomtLi3GZ2e8qy41hXGM20YbkUPxAeoxcF0do+S98E0lJe2AS4ZMtnUjTtVynhHrt/QvfMmceGg6lPOIwGs+9hdA5gz85TqplLVgUsWLpKUQqyGh3PVbkiPNK05uDmbgpkJDo1Uii/lIC+AH6R+7Zi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZT4/Z/F6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZT4/Z/F6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B10C4AF09;
	Wed, 25 Feb 2026 06:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002693;
	bh=j2xwMmpoxMlzyR54aQX/0bT1RG46u4o+s0ioCK8oRtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZT4/Z/F6Obz01aFqjbhr3ZI1qQvaVW3kvDLD3xi36JlxWYWh48VMu/aZhzw8bjQrn
	 NwOisJLa+Fa6qcrbC1xjsltwtqTP0U7kFqdpvuFZPYpSisotvVfh4HUXZVXo4b5ZCC
	 ar1NuiG42tAce/JalScTcdZC6LsWlh2p54rIRyDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 488/641] pinctrl: qcom: sm8250-lpass-lpi: Fix i2s2_data_groups definition
Date: Tue, 24 Feb 2026 17:23:34 -0800
Message-ID: <20260225012400.342050056@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit eabf273c8466af3f033473c2d2267a6ea7946d57 ]

The i2s2_data function is available on both gpio12 and gpio13. Fix the
groups definition.

Fixes: 6e261d1090d6 ("pinctrl: qcom: Add sm8250 lpass lpi pinctrl driver")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c b/drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c
index 64494a86490e2..c27452eece3e6 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c
@@ -73,7 +73,7 @@ static const char * const i2s1_ws_groups[] = { "gpio7" };
 static const char * const i2s1_data_groups[] = { "gpio8", "gpio9" };
 static const char * const wsa_swr_clk_groups[] = { "gpio10" };
 static const char * const wsa_swr_data_groups[] = { "gpio11" };
-static const char * const i2s2_data_groups[] = { "gpio12", "gpio12" };
+static const char * const i2s2_data_groups[] = { "gpio12", "gpio13" };
 
 static const struct lpi_pingroup sm8250_groups[] = {
 	LPI_PINGROUP(0, 0, swr_tx_clk, qua_mi2s_sclk, _, _),
-- 
2.51.0



