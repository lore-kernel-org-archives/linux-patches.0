Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027972;
	b=N8xJcBusMFRMF6SPqaAOqDezR4n6m27rX2kRMoa6Fmm6mIGosGSTg5c5wSgrqjshDbEP
	 AHWprwpetyoNDAjAHYWCLIZ0FgAN5boSoKDkubLNKJ8YZQipkZcvBquiF65w99FPvMFpH
	 ZIYbvICRw1Cm3mtTVrIGQaDSIO9+XKyvlrlzcK6eDvovxTSdl/qgCzTJQmeId0K8+wC8s
	 JcuWyOc7/h5fWSU81xPmYDRQz7gi9ejp4szlMDl8UdPx3Jph21Y3kPgcpyvFVFFDFfni+
	 tUF/IGgmldKfkfBxbVza5zovFbdJOZEPNjzRJ9HxHC+i2nTtPXcEbg+WbMH83oSdNew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mo/c3VCawk7n90IHiE20ukkoHoP9qadBXqUa92RYaTc=;
	b=vtl2WLvdKLdV5DaSmNagzTplKBKjWQTozGbHPJIiG1ScMpPPefm5hNfj0UzCQJ1DGieY
	 9Fj5K6Y+ME0Pc/J6XPrYnKfbTMretLtmIHRpvy0dIjkUvGztc6zNDFGZWPQI8/4+8eXRT
	 iDP1+tzIbcyXelrIqAavOn16VidmQJZbvKP7b1n23O5xhAPLEk98eORpBroa0MYLZ+GKO
	 19uw1bxiKTrp9lPbwgL8PgwV197Od0zlXfqo/Eic7+P4cyd/DHS1Xnj8nigjuujfuSQIQ
	 BMBgpmIP661D0XoXcqt7QgyEwRER1EtEAMcb2yAe6EQakKjwcFCTG0ZX75ZeZVl2tqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=acOvLKZ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50CF606A32A;
	Wed, 18 Nov 2026 18:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=acOvLKZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BE41F000C4;
	Wed, 18 Nov 2026 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027972;
	bh=Mo/c3VCawk7n90IHiE20ukkoHoP9qadBXqUa92RYaTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=acOvLKZ22mYRebeKKl30v8+OjaQGuiSedwRHOd0kTnEHJvhxUeO2Sd2t3Yca0fK8D
	 YcdQmJQCn1pY96n2mkbQviEHgmEIYSSlD7BXedfwihFWSyaNFP6LTbkrD6Xk4kn9MA
	 NW+W7X/Ub9sm9ci1LMn+SlNF989I6eFH5QG0Ci9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1979/2151] clk: stm32: fix clock array size for STM32MP21
Date: Wed, 18 Nov 2026 16:01:54 +0100
Message-ID: <20261118150233.828973023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Gabriel Fernandez <gabriel.fernandez@foss.st.com>

[ Upstream commit 40e5d379cc19fa7fa477414087df5e915d5e843f ]

STM32MP21_LAST_CLK is used as the number of entries of the onecell
clk_hw array allocated in stm32_rcc_clock_init(), and as the bound of
the clock IDs it can hold. It was wrongly set to CK_SCMI_KER_ETR (112),
which belongs to the SCMI clock ID range, whereas the RCC clock IDs
go up to CK_KER_STM (289).

As a result the array is too small, and registering a clock whose ID
is greater than 111 writes past the end of the allocated clk_hw array
(hws[cfg_clock->id] = hw), and consumers requesting such a clock
get rejected or read out of bounds.

Define STM32MP21_LAST_CLK as CK_KER_STM + 1 so that the array covers
all the RCC clock IDs.

No device tree node uses the STM32MP21 RCC driver yet, so there is no
need to backport this patch to stable kernels.

Fixes: 37ae8501cdb0 ("clk: stm32: introduce clocks for STM32MP21 platform")
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@foss.st.com>
Link: https://patch.msgid.link/20261012131859.215240-1-gabriel.fernandez@foss.st.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/stm32/clk-stm32mp21.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/stm32/clk-stm32mp21.c b/drivers/clk/stm32/clk-stm32mp21.c
index bdb17419908c8..961a228d8c640 100644
--- a/drivers/clk/stm32/clk-stm32mp21.c
+++ b/drivers/clk/stm32/clk-stm32mp21.c
@@ -17,8 +17,8 @@
 #include <dt-bindings/clock/st,stm32mp21-rcc.h>
 #include <dt-bindings/reset/st,stm32mp21-rcc.h>
 
-/* Max clock binding value */
-#define STM32MP21_LAST_CLK	CK_SCMI_KER_ETR
+/* Number of RCC clock bindings (highest RCC clock ID + 1) */
+#define STM32MP21_LAST_CLK	(CK_KER_STM + 1)
 
 /* Clock security definition */
 #define SECF_NONE		-1
-- 
2.53.0



