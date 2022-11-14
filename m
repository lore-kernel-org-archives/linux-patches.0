Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DC14C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB274C433D7;
	Mon, 14 Nov 2022 13:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430949;
	bh=ZkQFO2lsxpKKmTMwyzIdFgipSSX6fq+UGbj0zhWWjMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaiJ0zb8KfvTmvD3nQNDHbR32TRf8MV5wSsv5rf/trDuFundGo5xBnJcQ3hj4Ew5D
	 dmmikQoSf+JqlI1yZwIzXf738KvcoExvn0S2YKPyb4aotFxMgb3kEBmbvhTew4Di3A
	 4IKmYQILDeXqbr5v3fbNuQ2uuUoJTC4fhPkVBC3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 015/190] hwspinlock: qcom: correct MMIO max register for newer SoCs
Date: Mon, 14 Nov 2022 13:43:59 +0100
Message-Id: <20221114124459.451149434@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 90cb380f9ceb811059340d06ff5fd0c0e93ecbe1 ]

Newer ARMv8 Qualcomm SoCs using 0x1000 register stride have maximum
register 0x20000 (32 mutexes * 0x1000).

Fixes: 7a1e6fb1c606 ("hwspinlock: qcom: Allow mmio usage in addition to syscon")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220909092035.223915-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwspinlock/qcom_hwspinlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwspinlock/qcom_hwspinlock.c b/drivers/hwspinlock/qcom_hwspinlock.c
index 80ea45b3a815..9734e149d981 100644
--- a/drivers/hwspinlock/qcom_hwspinlock.c
+++ b/drivers/hwspinlock/qcom_hwspinlock.c
@@ -121,7 +121,7 @@ static const struct regmap_config tcsr_mutex_config = {
 	.reg_bits		= 32,
 	.reg_stride		= 4,
 	.val_bits		= 32,
-	.max_register		= 0x40000,
+	.max_register		= 0x20000,
 	.fast_io		= true,
 };
 
-- 
2.35.1



