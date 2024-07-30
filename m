Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20B73DAC15;
	Tue, 30 Jul 2024 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355591; cv=none; b=Z/7Nei0s3YoDQD3usOh4CsCMGGhqeHuxqoeuRii+a/PwMXr+mhQKbbcF6R36YPX2e7HAc2mOih+MU3zyX/vCtEJZLM/LqZjT1aapIECxOmpQxtvbaLgF6ane4jwnsfWB2Sg0bNfPnlPbAmwcb1200m4eHU9amctVg98tUVvMrV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355591; c=relaxed/simple;
	bh=4B/x6oOvg44ANdWndCWA0XpnqZh+kwHazcPDQHLflSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMkxTWsygVAxSE0fkw+GQbBSfvEC3Me5svN/hcAoq5Rex41EwO0hks3NseSWzM+rSjXYI2HdSoY24nojoxF0rCVWRFbVhGkxAIESYsyiTN7hTbg8CGIaWY7padLLPTJ1WFihNz2Hna8OvcOObUOSHCnRGe59imLcY6uMT7+CNPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeGV+9Rq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeGV+9Rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FABC32782;
	Tue, 30 Jul 2024 16:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355591;
	bh=4B/x6oOvg44ANdWndCWA0XpnqZh+kwHazcPDQHLflSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeGV+9Rq/bTHHFC7daZhGz1KiKHdV5NYv+dx28W1Mz3mcLyhdcrKSw/nRbFZXDhyA
	 Ry/6QrGKQLbIPcXS1zsvEKgT4PK0kv7LPAQNQ6Uge9qmdAp+fqPSYvMPl0YgEaDn1z
	 tjFe2bXAsGrJXKjWUVCcd+Saw6YBnBOzQ5s5nVcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 054/809] arm64: dts: qcom: sdm850-lenovo-yoga-c630: fix IPA firmware path
Date: Tue, 30 Jul 2024 17:38:50 +0200
Message-ID: <20240730151726.781083598@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit cae4c862d8b2d7debb07e6d831e079520163ac4f ]

Specify firmware path for the IPA network controller on the Lenovo Yoga
C630 laptop. Without this property IPA tries to load firmware from the
default location, which likely will fail.

Fixes: 2e01e0c21459 ("arm64: dts: qcom: sdm850-yoga: Enable IPA")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240527-yoga-ipa-fw-v1-1-99ac1f5db283@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 47dc42f6e936c..8e30f8cc0916c 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -494,6 +494,7 @@ ecsh: hid@5c {
 &ipa {
 	qcom,gsi-loader = "self";
 	memory-region = <&ipa_fw_mem>;
+	firmware-name = "qcom/sdm850/LENOVO/81JL/ipa_fws.elf";
 	status = "okay";
 };
 
-- 
2.43.0



