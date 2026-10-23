Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774464;
	b=jDQab9gjMZPG9U5/DDopZcqgBaQvvZxdMFYjDsfbXjQnmtx8nd+kESO730kDwV5Tgo1t
	 6EldPwakgfSVidDpNF9dapp/3hCm4izqVx2SYkwrJdDONNBZEahPp0QvV6d2oFoBYhf9m
	 9Xq0j4Q61SXuMbanSsuGAASkAfZNY20a/Eu00SmXjLzBMmqF9qBqCWegmNm8lk1k82E++
	 p1prhwsEBkQpGnbpfqtqhYEYlUvobOntjKPuag6p5XubBwRQeYO/wIX+coP7KfH+4zM1s
	 IO5WjCaNABwE7ZTIgkFtE228UR5wQgN/1PSlVa4yIpmEulU/qE1PAhBCOm73RqcdZPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3j3UHSIlYAn+P5HIKk7C8yASBayASW7IALdEUUCow+c=;
	b=u9RWPJjVRRPoEPUFoXsWo1K7Ba2C3/rY5QoCogrD6K5m1tvPJKkLi+2WAGEfIFePVCim
	 fagwKah9mOFEKdzNm5uh12pVgryAMLzeA1G6CnwHYEV8k9ki/Kxoipv6xhznPet+RU+Ia
	 PRhEHn8jUuxlInZhOdRZ9t/SVC77cDT7sZxNWBMDWs6zAamf0zW957Fnv/3mbvMnz8WzL
	 3oSi1oNFE7kLRXfb0gDhycDRxYxA9UGxs2pa88hx/jFlJwVK2rPiT0NwOp3ishv0frcgY
	 KGgJTOzNQsStHx2YEO8rEeTYRShQ5N4S2UcUSkbx3e6hk9SG2bLXu0zsDWJ7Gc/DZug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="D/EOWaCt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31032606A31B;
	Fri, 23 Oct 2026 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D/EOWaCt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795D81F01829;
	Fri, 23 Oct 2026 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774464;
	bh=3j3UHSIlYAn+P5HIKk7C8yASBayASW7IALdEUUCow+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/EOWaCtU4f+uIZwQKVGwi6BjN46od0XG1iLCsZLgNAPvgQQRHYpP6HCX/K0Oz/Mm
	 VEa2QuXVUd8FC5W+zYn6oeWlO7rEE2BLQRuPBrdQ/8DO2X7X5xiZLNZ/lOozwJxbgb
	 Kx1CWUqW/AbhtrIIsG3EhyH7hk4ydNIWGBHEJvbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhangfei Gao <zhangfei.gao@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 011/242] pinctrl: qcom: nord: fix GPIO interrupt target width
Date: Fri, 23 Oct 2026 18:37:33 +0200
Message-ID: <20261023163714.064534853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhangfei Gao <zhangfei.gao@oss.qualcomm.com>

[ Upstream commit 68ab4a6a84b92f52650508acb60317eb76454250 ]

The TARGET_PROC field in the Nord GPIO_INTR_CFG registers occupies bits
11:8. Describe it as four bits wide so the common Qualcomm pinctrl code
clears the complete field before routing an interrupt to the application
processor.

Without intr_target_width, the common code uses its three-bit default
mask. Since GPIO_INTR_CFG resets with TARGET_PROC set to 0xf (NONE), bit
11 remains set when the driver programs HMSS target 3. The resulting
target is 0xb (HPASS_DSP_1), observed as an interrupt configuration value
of 0xb1b instead of 0x31b.

The GPIO interrupt status is consequently latched, but the HMSS TLMM
summary interrupt at GIC SPI 208 is never asserted. This affects all Nord
GPIO interrupts using the TLMM summary path, including the Ethernet PHY
interrupts on GPIO55 and GPIO141.

Fixes: c24dd0826f06 ("pinctrl: qcom: add the TLMM driver for the Nord platforms")
Signed-off-by: Zhangfei Gao <zhangfei.gao@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916085720.771498-1-zhangfei.gao@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-nord.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-nord.c b/drivers/pinctrl/qcom/pinctrl-nord.c
index 7f37f8e819bab..010760cf0bf5c 100644
--- a/drivers/pinctrl/qcom/pinctrl-nord.c
+++ b/drivers/pinctrl/qcom/pinctrl-nord.c
@@ -32,6 +32,7 @@
 		.intr_wakeup_present_bit = 6,                         \
 		.intr_wakeup_enable_bit = 7,                          \
 		.intr_target_bit = 8,                                 \
+		.intr_target_width = 4,                               \
 		.intr_target_kpss_val = 3,                            \
 		.intr_raw_status_bit = 4,                             \
 		.intr_polarity_bit = 1,                               \
-- 
2.53.0



