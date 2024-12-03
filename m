Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2ED1E0E18;
	Tue,  3 Dec 2024 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238073; cv=none; b=a8DGu43e+dnYXoMd/SJNWuSKhaF5ro801qmnJxt9BwennSd5h0N7tWgFC2T0suXSU7LOFZP2FSM77VcyFpayhXpqhramypOwKeNOm2neRziH5g83tCpqlTV3rB5mzzuP7mww77CD5hruN0OA5DjUiiPYa8SvOavG4mqLHEbY1f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238073; c=relaxed/simple;
	bh=gH7HIFNHspSl768pyNQ31CdTTXrW2cDmd+IYlEBtDfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iorsyXMSgQw7kdnA/Qk7siH+mfh+ltqBJc6B5oPEARbXeu3TBpYmpzG2gIf5J4h276tCAnL3O9TUE86W5Cd8gOvHYLNS9xmJHX5h2f76oeDY4f0lMUqGLr/teWfCEgFJhijT6OozR1HfXFS+YN2fZ/TNmJB5chdp7xkMX/SJHjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZ45BTPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZ45BTPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEFDC4CECF;
	Tue,  3 Dec 2024 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238073;
	bh=gH7HIFNHspSl768pyNQ31CdTTXrW2cDmd+IYlEBtDfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZ45BTPJVjNaY2mEFwcAqbTmzM5nKqy6zBFzAabBssu1RsImJ9y+0xU05Oz+1KIsa
	 IQ7Tsp9M6uV/IwIbvf7r4jKLlSnYhaYAz1ZdQoMOumJmSSgmDXMbvzdTeyJ646smzR
	 cEnt1paGyn6m6nHaYDeWJ4zdiYje+btpK02a8mxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 153/817] arm64: dts: qcom: sda660-ifc6560: fix l10a voltage ranges
Date: Tue,  3 Dec 2024 15:35:25 +0100
Message-ID: <20241203144001.698611831@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1dd7d9d41dedf8d42e04c0f2febd4dbe5a062d4a ]

L10A, being a fixed regulator, should have min_voltage = max_voltage,
otherwise fixed rulator fails to probe. Fix the max_voltage range to be
equal to minimum.

Fixes: 4edbcf264fe2 ("arm64: dts: qcom: sda660-ifc6560: document missing USB PHY supplies")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Link: https://lore.kernel.org/r/20240907-sdm660-wifi-v1-4-e316055142f8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts b/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
index 60412281ab27d..962c8aa400440 100644
--- a/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
+++ b/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
@@ -104,7 +104,7 @@ vreg_l10a_1p8: vreg-l10a-regulator {
 		compatible = "regulator-fixed";
 		regulator-name = "vreg_l10a_1p8";
 		regulator-min-microvolt = <1804000>;
-		regulator-max-microvolt = <1896000>;
+		regulator-max-microvolt = <1804000>;
 		regulator-always-on;
 		regulator-boot-on;
 	};
-- 
2.43.0



