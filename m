Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37326F075;
	Mon, 29 Jan 2024 17:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548460; cv=none; b=o5KRp3YpGo4Uxs+84WjeqojAtTX7d//H0L8vqyKNJwIEk0AF4XT0CnQv+49Hnj/4TBm7tja8bAK2uRkjh9sFjCM1Q+BqXUfwGtp5/pSURtFPXhYOhFPuHEzr5jlDFsdGHcuYRCPnjma5qP8DuG3z0YCF9WRXM9vvo9CLKnvHbcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548460; c=relaxed/simple;
	bh=O4v3Dk9DQZcAdLiTOYFJJcd0nUJM/cKVtYKjF0onODk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmDW46EksIXu9isCcP4tjFpuxdul9CmoxPIZkeOPpeNY2C6kpV68V04KIaDmndPiRblZbn+6SAoR7ZiKbDA0nUBvrNrCKYShFtQLtYPGM4EZSKVu8MkNGISRjjI495fmhZtmstQpOEJsXfDv9fB0lg3/b2Os0zR5DkS8rhzrN8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftUyeUEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftUyeUEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90134C433C7;
	Mon, 29 Jan 2024 17:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548460;
	bh=O4v3Dk9DQZcAdLiTOYFJJcd0nUJM/cKVtYKjF0onODk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftUyeUEt4y+DSan6KiFVxpze8jebe/ddQQ5ac1rniKQ/Q3O0kMmowXlcDkJHeRMtC
	 XrHWnDQtybDdXt1UnzjfPyQSAi0Qet7ujWB88aEE2IG7+3QnGm6J2zXpEyXe+xGAkM
	 4iNPUpuO9P0MU7uafjm8axotPc/z1lGZt/wIcgSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 073/331] arm64: dts: qcom: sc8280xp-crd: fix eDP phy compatible
Date: Mon, 29 Jan 2024 09:02:17 -0800
Message-ID: <20240129170017.058736968@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 663affdb12b3e26c77d103327cf27de720c8117e upstream.

The sc8280xp Display Port PHYs can be used in either DP or eDP mode and
this is configured using the devicetree compatible string which defaults
to DP mode in the SoC dtsi.

Override the default compatible string for the CRD eDP PHY node so that
the eDP settings are used.

Fixes: 4a883a8d80b5 ("arm64: dts: qcom: sc8280xp-crd: Enable EDP")
Cc: stable@vger.kernel.org      # 6.3
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231016080658.6667-1-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
index e4861c61a65b..ffc4406422ae 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
@@ -458,6 +458,8 @@ mdss0_dp3_out: endpoint {
 };
 
 &mdss0_dp3_phy {
+	compatible = "qcom,sc8280xp-edp-phy";
+
 	vdda-phy-supply = <&vreg_l6b>;
 	vdda-pll-supply = <&vreg_l3b>;
 
-- 
2.43.0



