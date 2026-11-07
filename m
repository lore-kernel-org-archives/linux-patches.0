Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064248;
	b=nHvp8ADR5HyRmY0wjDTMlFuezAIlSesfFuQa64Kqq2IhvKuLdVssePa9epLsdY+g6H/d
	 wUoYVX2PBiVvhCsNdnXxgIo/LAw1y356VvQW+PdEqXk8I0Jz7/L/DQH7O9IKkFOOnvXrm
	 UgPYrBnP+qG5KiSGtqjaVfJV2HuXg7juGv9+fcdfiXDWZcTdczqjkr5ZQ71n0nYEzGh/T
	 z5Oy77ITJ/OV/ph5TfWoqbj4y+LzoX1QGLhP9s7FtWBn6z0frrqu+Ee3oQy+RxO6xKw4p
	 tVtCc3uLxwz2xHUevouOimuy/ESt6AVgfKac8nxBt54oEGCG0Vj5Docqaq0rM3yoU1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=buW+enNKtaNsvZnu1sWWBnS9oQXeSr0Dm23JM5tHfaI=;
	b=L/ZRuoZjGq6SyAoYL8fhJ64zQ7EyT+3zI2qXFDBfOZ7rzkW91rdjit5kuDxCk5anyyNP
	 annlKIjjIqgSCqXFKiWP1yFGqINzEenz9upBCdvdulo7uIccPXPkzJCqP+U8eCnC8o7MV
	 RbnWcSvOdjmmfrzWW7LuRtgYGPQ4jYIdD1P6YzmXjd9dAm7USFW3RSIzJR/BZtJlc6SGr
	 I7+EVHjeC24j2a3ArKjL/O6+M8Pos45Yh/7SCeAFEr0RocAWE4z1Feuu17uHRO/P3hZFp
	 BnkFr0uPPt9dsR7nGkq+Smx+Ryg9Nbf7+vZOQW2bBYBAX6UeJmmDPqFP1v/Fh9Xiziw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="E4z/rWGT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61086606A332;
	Sat,  7 Nov 2026 15:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E4z/rWGT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4EA1F0089F;
	Sat,  7 Nov 2026 15:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064248;
	bh=buW+enNKtaNsvZnu1sWWBnS9oQXeSr0Dm23JM5tHfaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4z/rWGThBQDF2mrC3okZ2eSlcjdPamUSXBaGc1rh98ATwWOidhFUIBsr4qsoh+ot
	 NVySFB9wKa7kbBb8lt0SC7FHP34VDKGu9jUrA6NNfqPLQQ9cPfrXJwVbve4BGRKuPZ
	 WKjSNtmNFeTFvwouba4dg32a6jr+WF1j82bPU1w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore-ext@st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0351/1257] iio: adc: stm32: fix minimum sampling time values
Date: Sat,  7 Nov 2026 08:44:07 -0500
Message-ID: <20261107134949.088244281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 90f0e257e6d1b..b024326775aeb 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -2734,7 +2734,7 @@ static const struct stm32_adc_cfg stm32h7_adc_cfg = {
 	.set_ovs = stm32h7_adc_set_ovs,
 };
 
-static const unsigned int stm32_adc_min_ts_mp1[] = { 100, 100, 100, 4300, 9800 };
+static const unsigned int stm32_adc_min_ts_mp1[] = { 100, 0, 0, 4300, 9800 };
 static_assert(ARRAY_SIZE(stm32_adc_min_ts_mp1) == STM32_ADC_INT_CH_NB);
 
 static const struct stm32_adc_cfg stm32mp1_adc_cfg = {
@@ -2756,7 +2756,7 @@ static const struct stm32_adc_cfg stm32mp1_adc_cfg = {
 	.set_ovs = stm32h7_adc_set_ovs,
 };
 
-static const unsigned int stm32_adc_min_ts_mp13[] = { 100, 0, 0, 4300, 9800 };
+static const unsigned int stm32_adc_min_ts_mp13[] = { 1000, 1000, 1000, 4300, 9800 };
 static_assert(ARRAY_SIZE(stm32_adc_min_ts_mp13) == STM32_ADC_INT_CH_NB);
 
 static const struct stm32_adc_cfg stm32mp13_adc_cfg = {
-- 
2.53.0



