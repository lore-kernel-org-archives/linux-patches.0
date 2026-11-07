Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063028;
	b=PHahH+h8uqw79Vle1El1u/nhlWXWf1ETOI61VtOTbWn4OKu3nnqoiHXBMNIi+zpFtNOo
	 2AWDbt0xmMf8WIEO0RF+htbVxcOFS7vQX/5TDQEDfc/iUShlq19IWLjcNLX3mfTpMazzO
	 JqvY9ss6109fzK2ZSi941rApbjaWThhPOj8/+4lLSHezSl1QiH+0sYhhJFKTJ9Ed+zB5z
	 oadN8NlreVEIecCBGu10uqNi2cy5tkPRJZvHVKoM8noh/UFj2cs669hf6dPu97mF8EJj6
	 VBZyUFxdiXWFCGLyGGYtkvt+dHxuqroI1e27g9G97C8mwexm2iGYYHvbExqs3sJHfgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GnFy9/F1FITb8aPtNuQCNPeuaG8LJNgjOBbGSI+BXwg=;
	b=06p9TQ62iNSXGNxVoQGbtNyJ3BVHwor/alztOgGAKGnzQXKeFZCYbFsllmX/ZjhBiSvN
	 TeXWVUYS1XPvu9vfvanzTHcqXI2gpEDSNmnKTYkthYijXPhFJc6bjJpBW25mQTW++EfJl
	 bnX5UllxORBkAJpqlgnOTSAwUSy333BDaBRAt6gsPAIycoWy8zqU7c0UQi4MYtF6DWdfV
	 0wKYdxyscok7AJYMFv8ugd030Uj8YLr9iuoSPS0cT2J+VvxZVzUYNFwxjSoZH1p5xWQT4
	 37WQ4iowCODCel7maCZG7LtCRZNp/ZN4JZCDX7DKNsUErXg7qp29WcHv2XQC//qs4Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EB9UsfPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F38606EEA1;
	Sat,  7 Nov 2026 14:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EB9UsfPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB7D1F008A3;
	Sat,  7 Nov 2026 14:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063027;
	bh=GnFy9/F1FITb8aPtNuQCNPeuaG8LJNgjOBbGSI+BXwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EB9UsfPERYbc8jYnOPe3X/iiAkMclPhjlcBxyvZ8cHG8jLK2GVdrjDCQ/SORBNAxz
	 WamE4awpUY5/7Gr+nXlWT6HR9gt8n4F9jSyKjEvPbnt9GYHiSjuyXOWUFS37aVGXmo
	 UdMp26Z2vkrYyMFZs2y4fZTB4bvLKUtnNoISRZfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore-ext@st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 278/869] iio: adc: stm32: fix minimum sampling time values
Date: Sat,  7 Nov 2026 08:49:20 -0500
Message-ID: <20261107134901.125505546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheick Traore <cheick.traore-ext@st.com>

[ Upstream commit ef04fdc999ee40a58d513ea48d391c7dc78c908c ]

- On stm32mp15: vddcpu and vddq_ddr are not connected to internal
channel, so their sampling time shouldn't be set.

- On stm32mp13: vddcpu and vddq_ddr are connected to internal channels
and the value for vddcore was not correct. Values from the datasheet
are 1us (e.g. 1000ns) for ts_vddcore, ts_vddcpu and ts_vddq_ddr.

Fixes: 7cb2303dd024 ("iio: adc: stm32: manage min sampling time on all internal channels")
Cc: stable@vger.kernel.org
Signed-off-by: Cheick Traore <cheick.traore-ext@st.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index dae35ab929b62..ab4433210ad09 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -2743,7 +2743,7 @@ static const struct stm32_adc_cfg stm32h7_adc_cfg = {
 	.set_ovs = stm32h7_adc_set_ovs,
 };
 
-static const unsigned int stm32_adc_min_ts_mp1[] = { 100, 100, 100, 4300, 9800 };
+static const unsigned int stm32_adc_min_ts_mp1[] = { 100, 0, 0, 4300, 9800 };
 static_assert(ARRAY_SIZE(stm32_adc_min_ts_mp1) == STM32_ADC_INT_CH_NB);
 
 static const struct stm32_adc_cfg stm32mp1_adc_cfg = {
@@ -2765,7 +2765,7 @@ static const struct stm32_adc_cfg stm32mp1_adc_cfg = {
 	.set_ovs = stm32h7_adc_set_ovs,
 };
 
-static const unsigned int stm32_adc_min_ts_mp13[] = { 100, 0, 0, 4300, 9800 };
+static const unsigned int stm32_adc_min_ts_mp13[] = { 1000, 1000, 1000, 4300, 9800 };
 static_assert(ARRAY_SIZE(stm32_adc_min_ts_mp13) == STM32_ADC_INT_CH_NB);
 
 static const struct stm32_adc_cfg stm32mp13_adc_cfg = {
-- 
2.53.0



