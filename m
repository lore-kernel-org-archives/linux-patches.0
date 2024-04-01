Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2F23BBC3;
	Mon,  1 Apr 2024 16:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990206; cv=none; b=Z2ph4AloR7c9CNj0ZVlto2b2PJ9XYV6IxE0U4vUDzEcn7eing8+WEAXOX4p10TkZdLz2dCHA1FFiakFlaUARiDI5HDO+o2nYyMV4yKbZAcd6WQaulLEXvrsIoJpYWAjAaG1ZrBWx2wKq2cRREsAy8qkJj7CeMna4eUbNo0BqVQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990206; c=relaxed/simple;
	bh=vp+K3nraCnwleMkYyy2YWU0P/17pcdgxr23KaFQsKmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDW5PcuxMT2ru7A3TLdxiELR8esyKlJk8a34akfoPRDjVD1H6pwWZy8AwNWRoSEYwsR3oHljQzMMuu5vdu4WPUG2wXtudpKpScXQVGgazEgZce4z/eKj66XgKQEfOA1W4JoFuwMkvCvYVtru7AJ8MyJ4vfcr1GwVfLv1HChAzwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzn8Q+LI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzn8Q+LI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E4CC433C7;
	Mon,  1 Apr 2024 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990205;
	bh=vp+K3nraCnwleMkYyy2YWU0P/17pcdgxr23KaFQsKmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzn8Q+LIvrN+9aSAhfIHOfGr/e7ZAEWUwutvuAUhyto11S1tvtrsGA1WapIpaYE6v
	 r9YaiywIaCZxsDcX3y5olU2UcTGaasJfplqHSmZhcV38kgRbGrlBPMVCzeAJ9MJ1DZ
	 AJvDjXsGKcu6/CedjROsutf5g0a/7HHpj020CT6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 241/396] arm64: dts: qcom: sc8280xp-x13s: limit pcie4 link speed
Date: Mon,  1 Apr 2024 17:44:50 +0200
Message-ID: <20240401152555.098793391@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

commit 7a1c6a8bf47b0b290c79b9cc3ba6ee68be5522e8 upstream.

Limit the WiFi PCIe link speed to Gen2 speed (500 MB/s), which is the
speed that the boot firmware has brought up the link at (and that
Windows uses).

This is specifically needed to avoid a large amount of link errors when
restarting the link during boot (but which are currently not reported).

This also appears to fix intermittent failures to download the ath11k
firmware during boot which can be seen when there is a longer delay
between restarting the link and loading the WiFi driver (e.g. when using
full disk encryption).

Fixes: 123b30a75623 ("arm64: dts: qcom: sc8280xp-x13s: enable WiFi controller")
Cc: stable@vger.kernel.org      # 6.2
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240223152124.20042-8-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -721,6 +721,8 @@
 };
 
 &pcie4 {
+	max-link-speed = <2>;
+
 	perst-gpios = <&tlmm 141 GPIO_ACTIVE_LOW>;
 	wake-gpios = <&tlmm 139 GPIO_ACTIVE_LOW>;
 


