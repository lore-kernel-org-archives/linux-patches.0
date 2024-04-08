Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2AC762F7;
	Mon,  8 Apr 2024 13:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582238; cv=none; b=Fs011aTvHJ3DrtDY/xiptoRaOsLaEbbyxWXAFa8ffmxXkBNbt3y6pWBEUI+dNB79mS5oyOox2aXaHLTOlMf6OKcvCk2OddeA4mBEOL4g8ZSAzuVAVdzEGncf9GLwYBlm9QUqBAjsub2QivnAcRR+WmzuhbTjOcPeUnjFECmQ3zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582238; c=relaxed/simple;
	bh=6JqBavFp5peUfz3Z/ruYKiRm2Ttb+PMRq06TXi+gsJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErpHTuxXdJAnvk4F/iwp4WJUAIb37XEUtFvI+dGfUGGP5eAU/aXXRG5n4xkR+GUKkkSYlSY/FwJJowPSf+Vv77yEsTY1o1bJt7AuB4dIrnnhYqGFXh7/PKfiY2oFW7FIWsvVKp+PaOC7gyEy7sWw2L8v4Iss6GfaWyZ/tNiCx3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sd9Wjn0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sd9Wjn0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8535AC433F1;
	Mon,  8 Apr 2024 13:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582237;
	bh=6JqBavFp5peUfz3Z/ruYKiRm2Ttb+PMRq06TXi+gsJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sd9Wjn0+ezLK2fbWVnpswJZB61W3EwcdW49T1VL4/SFRPSXuJfBsdoj9mbKnYjm2Y
	 YDJPQqhEByUCyXbZgTArqbWDPqs7FN/bRSQWOaRhaorKSwtegVeQVLEDslJU4jd+tr
	 0ZxJtey4CjUULYAZnwjL09fh70F+JE0kQrLxCAFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 077/252] arm64: dts: qcom: sc7180-trogdor: mark bluetooth address as broken
Date: Mon,  8 Apr 2024 14:56:16 +0200
Message-ID: <20240408125309.028499576@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

commit e12e28009e584c8f8363439f6a928ec86278a106 upstream.

Several Qualcomm Bluetooth controllers lack persistent storage for the
device address and instead one can be provided by the boot firmware
using the 'local-bd-address' devicetree property.

The Bluetooth bindings clearly states that the address should be
specified in little-endian order, but due to a long-standing bug in the
Qualcomm driver which reversed the address some boot firmware has been
providing the address in big-endian order instead.

The boot firmware in SC7180 Trogdor Chromebooks is known to be affected
so mark the 'local-bd-address' property as broken to maintain backwards
compatibility with older firmware when fixing the underlying driver bug.

Note that ChromeOS always updates the kernel and devicetree in lockstep
so that there is no need to handle backwards compatibility with older
devicetrees.

Fixes: 7ec3e67307f8 ("arm64: dts: qcom: sc7180-trogdor: add initial trogdor and lazor dt")
Cc: stable@vger.kernel.org      # 5.10
Cc: Rob Clark <robdclark@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -970,6 +970,8 @@ ap_spi_fp: &spi10 {
 		vddrf-supply = <&pp1300_l2c>;
 		vddch0-supply = <&pp3300_l10c>;
 		max-speed = <3200000>;
+
+		qcom,local-bd-address-broken;
 	};
 };
 


