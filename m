Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC79A1CA8F;
	Mon,  1 Apr 2024 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988764; cv=none; b=gfiadgDJ1nROBPzPkegoggTm69uMQakixCJs60v5SE4e8Qag2WI9Ai4MEkstqRjpGNLzwMhVW2wYuaGINCPOAAgUwxYI4Hxqpo7nyne2kKuWenDcDsBHrn6gxnRgHv7NdHGO/w5n/FfUnKv4wD0AVOdKeEWIsCXRUIXBT5RI12c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988764; c=relaxed/simple;
	bh=DFdkk4/XFt0xYWoH+ThkCWL7of4s7flwa0lJJ6dhTdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OABhGHeGnywITl9SpigPji6aagi7jSgXi2Cl2WESa3PZwKnIwEGDz6GQATmG5GxHJIkalgxV/tlyd3ToNGB8iQ7VPkqQ4Jb6UvHAOVksw/Okcd/jagWyUHDHD1NFJ3qHndeTrZgqusQwVTJXSTwEapC9d1+amlZJanlERIatQYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+MHdhv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+MHdhv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19BBC433F1;
	Mon,  1 Apr 2024 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988764;
	bh=DFdkk4/XFt0xYWoH+ThkCWL7of4s7flwa0lJJ6dhTdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+MHdhv7vKByadWMjouYuW++r9RDUfnYO0hOh38e+79SM0JYXHVA0Sz5lKOQNIuAF
	 ZbIYEQN3kq22ZFGE5jUFdM9lpqDiDCRsmZ4IlKiNUuT+v37PR/1FOtr33XYN4Sv55N
	 JAeEKbXuwzmjPvgFnyZmGGYwOX73jfG0P15KmlNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 281/432] arm64: dts: qcom: sc8280xp-x13s: limit pcie4 link speed
Date: Mon,  1 Apr 2024 17:44:28 +0200
Message-ID: <20240401152601.555870285@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 


