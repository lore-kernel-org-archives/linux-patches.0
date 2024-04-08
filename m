Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA082DF73;
	Mon,  8 Apr 2024 13:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582436; cv=none; b=QIdLOROyHd8TA3dDbfdp4XmqTTox9ThGnXMpwGhgW9ZhPoRJSpUBRKF+vd4Q/iL9jTVpLt1jx3C1let4aE7YmSHaOnBAAB32uhhDTzLtn6ZkGyC40RPzv7be8Z1VfPIzCrJcsBbrtsvzXItDbzxlDNVJrqqJWKP1vRv40qy7UZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582436; c=relaxed/simple;
	bh=Sfw9yePx2ksxx4tRoxWOPu8eCvqRRXkti3kWgPDwpCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lo1lLEtcj1FXZRgfnLjSNS+PwoDvuULqN2cgmjjmr6IkTR62ZRZWKCGirld8ePF9IXzhHDT7I6cvNb18ZT0BYWEoD3GhN0xYWDp0+EKeJqgeAKOe4a0unnARy3N5dG83zc6CtqW7EYN5qJ5bQ/Bo6hwGcOrLlNOuNzRqcwJlxNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqNvmAG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqNvmAG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D35C433C7;
	Mon,  8 Apr 2024 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582436;
	bh=Sfw9yePx2ksxx4tRoxWOPu8eCvqRRXkti3kWgPDwpCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqNvmAG8SZZXI4qTGo+f586sQgbwUZ9uZdaE0lcflyUfEQtYV5S2UNrtcCRR+SGBM
	 RFRUsd8TwEFp0ccIqZYO5+WFm+KdkQ75nVTX33I2inRE1pgEXrYtUX32sPgL7eNKOb
	 scq8tGUU1yOz4vKwxzC93c9+xOIenvMU/DhnOpPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 074/273] arm64: dts: qcom: sc7180-trogdor: mark bluetooth address as broken
Date: Mon,  8 Apr 2024 14:55:49 +0200
Message-ID: <20240408125311.598995926@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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
@@ -943,6 +943,8 @@ ap_spi_fp: &spi10 {
 		vddrf-supply = <&pp1300_l2c>;
 		vddch0-supply = <&pp3300_l10c>;
 		max-speed = <3200000>;
+
+		qcom,local-bd-address-broken;
 	};
 };
 


