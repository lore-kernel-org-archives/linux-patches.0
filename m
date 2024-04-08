Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8907C0A9;
	Mon,  8 Apr 2024 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584985; cv=none; b=FCqZW0ob0xNnRxp7rgjWEDM6Qg6nLbeXiCwicuc4CjRlqA7luKS+X1B2LJmc4lSnKRSP0eZsbaZwZbNLG+13gu/b478E1/pUDOCeIkMAvFyCzYVlnB7hIZLZyQYsh3Y+sd7L82cot9+ZN5gsZxnC5nCPjfOj+2McIku4TQ+WcoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584985; c=relaxed/simple;
	bh=YO09xG1AUUIug5kl7aF+wWIeqBUvZlUT/YowXsk4qjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c01f9z0n3duFw3rV5G4ES4KCtpNG7OkuH6GdWa2J4GhoJteOFfRnvvoWMSuhz/+iARrU4c+LFKuPjRe+aFaRkH56wVzjBZ6FH3wHQQjovkTCvkz7gKhFt7umIHwr+wKZtlEoMnVqiBZGfRzkpVeu9xpy+UkWgQiQTySQ8YerDog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2Xcm5PC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2Xcm5PC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61936C433F1;
	Mon,  8 Apr 2024 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584984;
	bh=YO09xG1AUUIug5kl7aF+wWIeqBUvZlUT/YowXsk4qjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2Xcm5PCgh6bLiHJogyewWvwFeU6OBTvtTmOHCIsBlgz3WH/9gbDO3ngS5Tyv0CUZ
	 57/5LQWM/W5VcVaybrdZDCXOV3/MbU7eQsQ4epB2OhUdU/2rT/OgpGnmEHDTr/lmUp
	 WcI17nX859BwCEzxQmn61lL+loqqxqDYHVRdif5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 624/690] arm64: dts: qcom: sc7180-trogdor: mark bluetooth address as broken
Date: Mon,  8 Apr 2024 14:58:10 +0200
Message-ID: <20240408125422.250795869@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -911,6 +911,8 @@ ap_spi_fp: &spi10 {
 		vddrf-supply = <&pp1300_l2c>;
 		vddch0-supply = <&pp3300_l10c>;
 		max-speed = <3200000>;
+
+		qcom,local-bd-address-broken;
 	};
 };
 


