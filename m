Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA82144D13;
	Thu, 13 Jun 2024 11:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279599; cv=none; b=tFSgko7S5zyB/KSkqZHW0f0vDXc3wNL6Gsy2PDpxT/mNrjDWHmaILN67M1P3cukw95LGFyXSWZpDfE6m+f8fKhI+gfZ4XFDjouPdslO7PpOXSqT7vch7noXRWFtISDQ7xMxldicnmoADv5Bf6dbCfZqIgJ6YkEpv4p0lvZGZ4Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279599; c=relaxed/simple;
	bh=lwNwvrwowLnJX3agWzNiN5RnmMeie7rzRtmtLW6vmcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKYZJHb2m0pFkSwHbM3j96Z9txNc1q/9Qc4Mypt7/oVMr8jJPd0P8JsOi0qoRMdGbPGtqMWnCfC59TAXnd83jF6H48HPCVATRTLyK3Fq3DByGCJFZ0JGi7UdJm6UMaCeWB7XuzQMcT9pGLzoegl9jW0Kxh2XE9FVRI2WUsVkwZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5y14Tlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5y14Tlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9260AC2BBFC;
	Thu, 13 Jun 2024 11:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279599;
	bh=lwNwvrwowLnJX3agWzNiN5RnmMeie7rzRtmtLW6vmcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5y14TlqhQNJYFf7e8xqBvBIx+MLUm5pWGYYp3NvXG8AB0sDePKaTWwyK7cUCmvmz
	 nAnh+7cRP7QC1U7rC5K4Chok/mPIYcCZktvQBC4UO8LawDg2FW7CfqI4S++2ugR1og
	 d/Gx7sPxJKeLrWvfBUlAhiLuMhaG2Q63De30aGiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.9 123/157] ARM: dts: samsung: smdk4412: fix keypad no-autorepeat
Date: Thu, 13 Jun 2024 13:34:08 +0200
Message-ID: <20240613113232.169374574@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


