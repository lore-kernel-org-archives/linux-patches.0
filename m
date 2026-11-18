Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036153;
	b=XykCdnrTZE0f1OLwoELV715cEMJkSwEDnNcfPu+meQeSPvY74OhGY/LrsGJebTLY4Tz/
	 JGZLXZLAlJctQtjR78VKYxhBQo9PJy76oXAzEJPNLLd0xsBf8txR7l5Hze6eTNLqzjCIT
	 QaIkp/ulF0k4pCIOVR1m/OJjYCr/rVZOexN+ZcTtWsKPwII4AFXrwXAErgFYIA4WMiMsR
	 tjVC0NnolaHrPYrc5iFpQ8GPeIF3LimzlczonleTs0+SsXh8hq9NzzEmkJsiHiLy7rauM
	 DqS5KlqHdloqDU+xeC/uC5PAJuf7RQwJsGzChg127wMYEco6zJ5wxZK2YtpHs7Wa+rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q11VgwpyxjYGFjIoxXz3TlYsetYJsK0ANIIuflCHVBw=;
	b=eWMPk3SLM0YYGseA7X2bl+rrxYh7Az/u/WAd5Yc3joJhjjCZil2k7Bt/0L5vNqAzE6+j
	 BRlmg6sTsMWmVx3Z/Aj/NnrNGKGG2ezYWoYRdU4aE8wIgcX9RlEYF+/RFUKKhOY1AOdfI
	 cTR7GEn31r3YylzcjyFjpaA5lIlvOtFLOWIRscrpVYyY+LB6CxVu41PbJaOb3S/FZtrJI
	 DE/1UBdRqUsabqtYGI9GF/fx3Cnpausu9+qHcserw/L4hcTLBiebLB29rTlrAvfQ9yKz/
	 95TWjLeSQ9BCko8ZhA94tCXkuw/QhqXIag6tEKVohAxe3X6YnCMmtexMmCUxI6HBtMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhB4QCIq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA19560A2606;
	Wed, 18 Nov 2026 21:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhB4QCIq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3271F000CA;
	Wed, 18 Nov 2026 21:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036153;
	bh=q11VgwpyxjYGFjIoxXz3TlYsetYJsK0ANIIuflCHVBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhB4QCIqIs2MxVpQySncMS1zHHNf1O7pZjUWXFzB23gZ2JV+MIeFRcASk0Uyy0Noo
	 DaUtGU2iwqa6FidZUhmJFDMRktcns0TQshZZYZPC61Vts/P7UZ6eyGUXb4t/wcuEEt
	 9vrTLwewga8XrpUgJyd8B72h541XPXL4R/6IC7Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore-ext@st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0957/3318] iio: adc: stm32: fix minimum sampling time values
Date: Wed, 18 Nov 2026 15:26:19 +0100
Message-ID: <20261118150348.343919737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3b78581c5e785..55650e919fd2e 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -2622,7 +2622,7 @@ static const struct stm32_adc_cfg stm32h7_adc_cfg = {
 	.ts_int_ch = stm32_adc_min_ts_h7,
 };
 
-static const unsigned int stm32_adc_min_ts_mp1[] = { 100, 100, 100, 4300, 9800 };
+static const unsigned int stm32_adc_min_ts_mp1[] = { 100, 0, 0, 4300, 9800 };
 static_assert(ARRAY_SIZE(stm32_adc_min_ts_mp1) == STM32_ADC_INT_CH_NB);
 
 static const struct stm32_adc_cfg stm32mp1_adc_cfg = {
@@ -2642,7 +2642,7 @@ static const struct stm32_adc_cfg stm32mp1_adc_cfg = {
 	.ts_int_ch = stm32_adc_min_ts_mp1,
 };
 
-static const unsigned int stm32_adc_min_ts_mp13[] = { 100, 0, 0, 4300, 9800 };
+static const unsigned int stm32_adc_min_ts_mp13[] = { 1000, 1000, 1000, 4300, 9800 };
 static_assert(ARRAY_SIZE(stm32_adc_min_ts_mp13) == STM32_ADC_INT_CH_NB);
 
 static const struct stm32_adc_cfg stm32mp13_adc_cfg = {
-- 
2.53.0



