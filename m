Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8724F218;
	Thu, 12 Dec 2024 17:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023854; cv=none; b=Onu0zJ+uX/TJma0ouECTPIWRFATaAP3KgOdn2JyBACIrYzdm2dT9Ck9QTka3AFXczs/5VHXvW2lQO+F9DA60Hc5x/jAoyZxp56P/XA08p/SPIktHg5Nv8KU01xs+c8na9uBSRJE5k5GufvTPN97mBuEClmnPbQ+XALS0QPYZwNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023854; c=relaxed/simple;
	bh=3ZGcI+pG7nsDReZJsOPwIx0Jf9VHPmRfy9dC4bYcbsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOESYCdWuFSg45ChlGiVE5vvCYVbGuBlnPbMNqAe4hEIDCdYbFDBpS5smbxvCRiBU1UmxXWLk+3iukiZH1NR6Q+MtlIFLlxG0MYtH/1Ae0opSrCcfZSHMeQ9trR95KTGmiLJMH4DH6578Ug4frmj44yiMYsnLMg5GKoJxkdsfEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCRCO3wJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCRCO3wJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E34C4CECE;
	Thu, 12 Dec 2024 17:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023854;
	bh=3ZGcI+pG7nsDReZJsOPwIx0Jf9VHPmRfy9dC4bYcbsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCRCO3wJEYgH+6n7MVYiq8LVjPb+PlHNA+aDEiIhQbyDan0d10BZOjr39jh9DQliO
	 ymSCvGvnUiYbNoBtHDNYI3jeXN4K3dJD7KJgcPeSHBOQqx2breox5GVc/zjT8qbC/v
	 ykb0z8zSS4S9N2yxfuZtS/AQ4iDP6P9H0cvQBszs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/459] arm64: dts: mediatek: mt8173-elm-hana: Add vdd-supply to second source trackpad
Date: Thu, 12 Dec 2024 15:57:05 +0100
Message-ID: <20241212144256.953960777@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit f766fae08f6a2eaeb45d8d2c053724c91526835c ]

The Hana device has a second source option trackpad, but it is missing
its regulator supply. It only works because the regulator is marked as
always-on.

Add the regulator supply, but leave out the post-power-on delay. Instead,
document the post-power-on delay along with the reason for not adding
it in a comment.

Fixes: 689b937bedde ("arm64: dts: mediatek: add mt8173 elm and hana board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241018082001.1296963-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi b/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi
index bdcd35cecad90..fd6230352f4fd 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi
@@ -43,6 +43,14 @@ trackpad2: trackpad@2c {
 		interrupts = <117 IRQ_TYPE_LEVEL_LOW>;
 		reg = <0x2c>;
 		hid-descr-addr = <0x0020>;
+		/*
+		 * The trackpad needs a post-power-on delay of 100ms,
+		 * but at time of writing, the power supply for it on
+		 * this board is always on. The delay is therefore not
+		 * added to avoid impacting the readiness of the
+		 * trackpad.
+		 */
+		vdd-supply = <&mt6397_vgp6_reg>;
 		wakeup-source;
 	};
 };
-- 
2.43.0



