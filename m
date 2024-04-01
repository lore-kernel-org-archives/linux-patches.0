Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF644D9FB;
	Mon,  1 Apr 2024 15:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986745; cv=none; b=poxtlleZaMdvIHV8RBxI86lIakoWRqsb1kDO+BafT+73mpuADg0R+vW7SbJULTSEQ4Prw+8CtLHT6+vlS7twPVUlUxU3Tss76jX5IOYq9jouWpW9MMjpuKaPNCqqMyUfRm73OG6cKv8y+VhpRTy69ExOWdDDUc75VayIzTe4BZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986745; c=relaxed/simple;
	bh=8LJd2eFqzxrqWUi0g3SJ5TygJ0vR3Zc7bylNf2lRekc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVkWKULlqOtQ/5sWZwenTalqKyPaw0N2PAYjrPmAEqKKkxJJKwhGpOkYjbqjlvr8bAF1Gw2di9uaMMV+cozD1p0JK5lB5kz+U2GUmVgOPi6YcO9E1aHviBnZ+U1mAemG3IYUETGPPLiVUYHUgKXo7o10Aa6FpjvVkjdUqicfYrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pwhEL7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pwhEL7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BC9C433C7;
	Mon,  1 Apr 2024 15:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986744;
	bh=8LJd2eFqzxrqWUi0g3SJ5TygJ0vR3Zc7bylNf2lRekc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pwhEL7go/CNEG2i4QsS8BxnYPLwY136Kw1QELg7uu5FwFMI3bV2QHcORxik8x8In
	 CztrE0nB8jHMcVTgjZyblkOlYglVv+8cs7x1jbAGzZsR5R5E9DrG6FE5+NuW9t3jFC
	 65cDre2zQcmMpXf1UL/0oj2ky3lzVxeCzzSgAVeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 041/399] pinctrl: qcom: sm8650-lpass-lpi: correct Kconfig name
Date: Mon,  1 Apr 2024 17:40:07 +0200
Message-ID: <20240401152550.402900046@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 47847b9bcdb13c2da1829323a66651ef63047b77 ]

Use proper model name in SM8650 LPASS pin controller Kconfig entry.

Cc:  <stable@vger.kernel.org>
Fixes: c4e47673853f ("pinctrl: qcom: sm8650-lpass-lpi: add SM8650 LPASS")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240216102435.89867-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/Kconfig b/drivers/pinctrl/qcom/Kconfig
index e0f2829c15d6a..24619e80b2cce 100644
--- a/drivers/pinctrl/qcom/Kconfig
+++ b/drivers/pinctrl/qcom/Kconfig
@@ -125,7 +125,7 @@ config PINCTRL_SM8550_LPASS_LPI
 	  platform.
 
 config PINCTRL_SM8650_LPASS_LPI
-	tristate "Qualcomm Technologies Inc SM8550 LPASS LPI pin controller driver"
+	tristate "Qualcomm Technologies Inc SM8650 LPASS LPI pin controller driver"
 	depends on ARM64 || COMPILE_TEST
 	depends on PINCTRL_LPASS_LPI
 	help
-- 
2.43.0



