Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6C11BA888;
	Tue, 30 Jul 2024 15:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355147; cv=none; b=rnaQgsMtM0tO8zKNhEVEbNtdxDOoWPNQ8VXmab5stcPnfK8qvJUAVPBG3/ERaNgvyhehOW7m8BQARwhN6wX4Cfxkt9cKRcgO6E1IpIeKa0SJ9S7w3hZ4NlnDR+ups2SGrx2hNJONC9ZMKpxP2xZAt8UUdns+Lb6c+NMvsxRsLqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355147; c=relaxed/simple;
	bh=XAJVmN9SffD0SglGsQ218TPvmNh+O2ZLdAzRLgaVf3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BySM1dfHgDPP/jDkuYeOALGXciX5ob0LplVmrLZcJkGcdteaVD8prTyRO8yGCxbCpvFPMU+3cW7eJcoZADdv8uAtiKhiiatHCauxhIle0KnOwUyyK/0uTqANeqaRPEJttQmhttPLBbYcj65K4glNJnpk+GtiQNPeXo/T4LtJHI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2S99XWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2S99XWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDDBC32782;
	Tue, 30 Jul 2024 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355147;
	bh=XAJVmN9SffD0SglGsQ218TPvmNh+O2ZLdAzRLgaVf3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2S99XWvt2Bjh5tTZsf1Puqwe5fxJb8fxnjaA+xejk9KmHYVIGC03nJo/B8usx0Tp
	 PDZ4dkzzr5HNA3JfXf8xdY7CYwNpCWLl8aCx4ueNkaCl9sbUcHuIhA+YZTpe7gCL46
	 dilrWgKyfZFnhQ3gtVA9TutegVhvguLMZk2YULe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/440] arm64: dts: rockchip: Fix mic-in-differential usage on rk3568-evb1-v10
Date: Tue, 30 Jul 2024 17:44:55 +0200
Message-ID: <20240730151618.188231169@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit ec03073888ad23223ebb986e62583c20a9ed3c07 ]

The 'mic-in-differential' DT property supported by the RK809/RK817 audio
codec driver is actually valid if prefixed with 'rockchip,':

  DTC_CHK arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dtb

  rk3568-evb1-v10.dtb: pmic@20: codec: 'mic-in-differential' does not match any of the regexes: 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#

Make use of the correct property name.

Fixes: 3e4c629ca680 ("arm64: dts: rockchip: enable rk809 audio codec on the rk3568 evb1-v10")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20240622-rk809-fixes-v2-5-c0db420d3639@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts b/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
index 674792567fa6e..4fc8354e069a7 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
@@ -478,7 +478,7 @@ regulator-state-mem {
 		};
 
 		codec {
-			mic-in-differential;
+			rockchip,mic-in-differential;
 		};
 	};
 };
-- 
2.43.0



