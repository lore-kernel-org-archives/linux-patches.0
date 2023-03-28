Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434588476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD75CC433EF;
	Tue, 28 Mar 2023 14:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015277;
	bh=ZYWoRqy5TCloj0vmsZMJFllTYRHpUP0O66t2pYMcKeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgY6EUjP27ZUyB4ypOesjdBHvo3uKdXvbFZ1kNcRVnZf9J0umodnOAgreCFB/Td/d
	 XHVsPryTlUQOd/gSMR7GpuunTpPTgJMMhnxSlmGZxYL6otVsj0VRjmMGZDG389rWtI
	 ihLPtXN8JTZjA6se0BxKXTLh5MKFgqj0lscLTh0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.2 229/240] arm64: dts: qcom: sc8280xp-x13s: mark s11b regulator as always-on
Date: Tue, 28 Mar 2023 16:43:12 +0200
Message-Id: <20230328142629.259172649@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit b8838e653034425cd26983c7d96535e2742a6212 upstream.

The s11b supply is used by the wlan module (as well as some of the
pmics) which are not yet fully described in the devicetree.

Mark the regulator as always-on for now.

Fixes: 123b30a75623 ("arm64: dts: qcom: sc8280xp-x13s: enable WiFi controller")
Cc: stable@vger.kernel.org	# 6.2
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230322113318.17908-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -186,6 +186,7 @@
 			regulator-min-microvolt = <1272000>;
 			regulator-max-microvolt = <1272000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l3b: ldo3 {


