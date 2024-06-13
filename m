Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ECF44C6F;
	Thu, 13 Jun 2024 12:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280700; cv=none; b=tIkR12wvOntC9N37nMzKrwhbtTpOJw3kl7aRbb+qtKLjNS7rr8iyPRMEbvvb9xGpCxEcZeI1Xh1ZFv+K7oMQC/fsQlNciEdXxe0vsXyXabcx6m0p253seWhkOf2AD+bG8LTuXn9yTcUJk5Gfn0cbijsr0M1DJNq3UsprUmaQN8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280700; c=relaxed/simple;
	bh=uc3kI7uoIKby4I69r6wu1CRm18XVEC3S/+SRApVX3mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJfizR0RyD2hTAmLJEmxqfAeF1mnmUDH91JwtnwjsutY6FZCnaZffRMDxx/OwyKT0hbxnCJM5ulYSUQSlXlJBYvGlRNjNbjG3+0zxhmfITtpMeTs16uZM05JOYPI1oZDikCxhkxlKu1+HBj+0UQYmY9DIx9nvZUJCmIgtKbGNCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOLFc/gN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOLFc/gN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E5DC2BBFC;
	Thu, 13 Jun 2024 12:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280700;
	bh=uc3kI7uoIKby4I69r6wu1CRm18XVEC3S/+SRApVX3mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOLFc/gN/JIztoP8ml9bF64Pehnjn0cgpJgMkwu4GRf24fOK4811GlMMvaw+45fR8
	 ksTPi+509PbCCM5JJFz8JknJ9WLCU4O3WzJHmTbwjkuTqznkHxUMrnZqQLjxadzjDo
	 vzdNIJmWxdaeuri9rRxcbmtQPxS8v06U1gF+1pQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.6 112/137] ARM: dts: samsung: smdk4412: fix keypad no-autorepeat
Date: Thu, 13 Jun 2024 13:34:52 +0200
Message-ID: <20240613113227.642039103@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 4ac4c1d794e7ff454d191bbdab7585ed8dbf3758 upstream.

Although the Samsung SoC keypad binding defined
linux,keypad-no-autorepeat property, Linux driver never implemented it
and always used linux,input-no-autorepeat.  Correct the DTS to use
property actually implemented.

This also fixes dtbs_check errors like:

  exynos4412-smdk4412.dtb: keypad@100a0000: 'key-A', 'key-B', 'key-C', 'key-D', 'key-E', 'linux,keypad-no-autorepeat' do not match any of the regexes: '^key-[0-9a-z]+$', 'pinctrl-[0-9]+'

Cc: <stable@vger.kernel.org>
Fixes: c9b92dd70107 ("ARM: dts: Add keypad entries to SMDK4412")
Link: https://lore.kernel.org/r/20240312183105.715735-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/samsung/exynos4412-smdk4412.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/samsung/exynos4412-smdk4412.dts
+++ b/arch/arm/boot/dts/samsung/exynos4412-smdk4412.dts
@@ -69,7 +69,7 @@
 &keypad {
 	samsung,keypad-num-rows = <3>;
 	samsung,keypad-num-columns = <8>;
-	linux,keypad-no-autorepeat;
+	linux,input-no-autorepeat;
 	wakeup-source;
 	pinctrl-0 = <&keypad_rows &keypad_cols>;
 	pinctrl-names = "default";


