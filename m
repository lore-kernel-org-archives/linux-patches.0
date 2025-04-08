Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70D9266583;
	Tue,  8 Apr 2025 11:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110568; cv=none; b=KGoobBoFJuUguIUIxmWlG0/i98LNOLzUnmTtIKbf/Xxc1diCWIC7vxlOVezYZmn2aOzlqMyGlbxyyswzgcXPklt4tfzfpB0HWiNad3ZS8o7yu+R6TaswK+vCBVR/YfHDaPnnZefC64FPQhg0W8jQ4o3+F7i+SkIcZmGRsHYGSUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110568; c=relaxed/simple;
	bh=GaTq/FQCYYHaBZVqb3rkikD3hX100hdBZu7BZ2KiNF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtKVvzmQDJJVAABKpWR47NDX3YNVw/YmAWHDHTq2zxegtW0q8r/bkNTBZTUDtdXy2XxHgrBAZSSv8YQcRHq6EdQOEq8yNc7Rm3OmUrpDN1kiUEtBH2VkDRLtvZO2OmJa4CB6rkuoAqcV6P/3soyNFj3wz229TiKuEy0dohjypKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVQMQm5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVQMQm5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E7BC4CEE5;
	Tue,  8 Apr 2025 11:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110567;
	bh=GaTq/FQCYYHaBZVqb3rkikD3hX100hdBZu7BZ2KiNF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVQMQm5dCGE7yG6S+ACF7MGUS4PmCTZatE9b6bGCL3P0A4lSv917VxdU/vlJSvAKc
	 hOhFmG6TxwJruFaET6HsMPeQTMSFlXv3uxjHbJsbvn/HgHtppBbNoxyKb/UrkeWcD2
	 ynt410xyxzURhpAlQyzsmKs8+z0/HG6ZJ4ASBpmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rini <trini@konsulko.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 085/731] ARM: dts: omap4-panda-a4: Add missing model and compatible properties
Date: Tue,  8 Apr 2025 12:39:42 +0200
Message-ID: <20250408104916.247392352@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Rini <trini@konsulko.com>

[ Upstream commit ea07a4775df03852c353514b5b7646a17bd425be ]

When moving the model and compatible properties out of the common
Pandaboard files and in to the specific boards, the omap4-panda-a4
file wasn't updated as well and so has lacked a model and compatible
entry ever since.

Fixes: a1a57abaaf82 ("ARM: dts: omap4-panda: Fix model and SoC family details")
Signed-off-by: Tom Rini <trini@konsulko.com>
Link: https://lore.kernel.org/r/20250123174901.1182176-2-trini@konsulko.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/omap4-panda-a4.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/ti/omap/omap4-panda-a4.dts b/arch/arm/boot/dts/ti/omap/omap4-panda-a4.dts
index 8fd076e5d1b01..4b8bfd0188add 100644
--- a/arch/arm/boot/dts/ti/omap/omap4-panda-a4.dts
+++ b/arch/arm/boot/dts/ti/omap/omap4-panda-a4.dts
@@ -7,6 +7,11 @@
 #include "omap443x.dtsi"
 #include "omap4-panda-common.dtsi"
 
+/ {
+	model = "TI OMAP4 PandaBoard (A4)";
+	compatible = "ti,omap4-panda-a4", "ti,omap4-panda", "ti,omap4430", "ti,omap4";
+};
+
 /* Pandaboard Rev A4+ have external pullups on SCL & SDA */
 &dss_hdmi_pins {
 	pinctrl-single,pins = <
-- 
2.39.5



