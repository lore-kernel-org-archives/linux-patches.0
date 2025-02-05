Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB2415EFA1;
	Wed,  5 Feb 2025 14:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767442; cv=none; b=onfv9Rh7G2Qng6V8dsyzGzBGecajZcT71BYcg4zwAaYnzgQe6+IMIYRmjwL/xUucK9TLKhtx9rQm2uDpbJQ4REq20fUz5gxd4jEKfqUFT4dqfcdxTazK+INwUTKmb9084KLxoN6F0XRccmi7IxMFANBe5XMRijsbIPKZlEk9SRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767442; c=relaxed/simple;
	bh=dGPOW0Zajp78AXAiiqXYE0mhn/nKx4+NEV4V7/jpRcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6qiArlAUgj02O9HMoHpiDN6vFvqQv7pZH+fb6jpBcrk73BpDMK1UCvbARQYy9h+P5axCCmpKqZxapxKW2R4oAMJvRL8p5xYjwEBN0eqWg4GvNdOlvjo7fhMuF01p8KOKZ6GRjMG2i+kc1NXemPt0K9nRwqRlUhpJF5/bENZQDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eubvEmZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eubvEmZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C543C4CED1;
	Wed,  5 Feb 2025 14:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767442;
	bh=dGPOW0Zajp78AXAiiqXYE0mhn/nKx4+NEV4V7/jpRcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eubvEmZeyDRDW45I+5ni/ZJtOAh/gw6ZIUzMkHijcbT8aNkat7GgixXWF7RIYkj5T
	 98M3xsvCvIeHAQv89I7c/65BFnYDKMQOQ5ZdLzQvXXmCVNjy/ONh9v59iLjGGroyPb
	 uMBs18VOUxv9eW8WuDySftc2e5bsHiqDAZsH1+PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 405/623] arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply
Date: Wed,  5 Feb 2025 14:42:27 +0100
Message-ID: <20250205134511.717125804@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit aa09de104d421e7ff8d8cde9af98568ce62a002c ]

The bindings requires the avee-supply, use the same regulator as
the avdd (positive voltage) which would also provide the negative
voltage by definition.

The fixes:
sc7180-trogdor-quackingstick-r0.dts: panel@0: 'avee-supply' is a required property
	from schema $id: http://devicetree.org/schemas/display/panel/boe,tv101wum-nl6.yaml#

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241230-topic-misc-dt-fixes-v4-3-1e6880e9dda3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
index 00229b1515e60..ff8996b4de4e1 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
@@ -78,6 +78,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&lcd_rst>;
 		avdd-supply = <&ppvar_lcd>;
+		avee-supply = <&ppvar_lcd>;
 		pp1800-supply = <&v1p8_disp>;
 		pp3300-supply = <&pp3300_dx_edp>;
 		backlight = <&backlight>;
-- 
2.39.5



