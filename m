Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF35330B2A;
	Mon, 29 Dec 2025 16:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025231; cv=none; b=YGTjC7PdqoPZMAxDhSYV1jGoWGf4cee7CviMzJ+QXOibvEhaWT3vTsKFbZ6HjDaQE3rmiigjDGDJkyJ1Z2PPgYGC889KvLWE3LzBEgRjWej2t2Mn4GIo32U+LPIOmu2svpuSjmkMH3mLkiQQqdEblewMK3SORIknrOrTypttfF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025231; c=relaxed/simple;
	bh=UdykiIfV+qMHpHgPPgMnYtYA2kynyRZ5hzZ49cnfPyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZCHz2Zdbql0P3eLlHCLjVWDeGyJZSYezzqXbKyjL3pKYM2gHpNbQYV5IP5GqA/AAF1O+svEIR1Vl5SR23P+wT5YJLmI+0sd/yuIUAhDv6iRZdBBOXXrvV+Hhdwe6sxaMJtW/cRNYNj1iq9gAl1L1Wm73BdEvwUyqMiN2B+ZMIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U32Srtek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U32Srtek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D47C4CEF7;
	Mon, 29 Dec 2025 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025231;
	bh=UdykiIfV+qMHpHgPPgMnYtYA2kynyRZ5hzZ49cnfPyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U32SrtekQx/kzwdmR6otmA60N5j6j2kFeFhhq0R93ODOXsh5ClXhOpITRhhpElEP9
	 t59Ic1wqR13NZsveRQlbN5wkfZf1u9PiA2Vnqw2/GRudxD5fn7RI/EtcKOyosfhRU+
	 DDbFQ9FgFx/LwzHLbLDiD3wm75cYbrttKpwWJqL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	AngeloGioacchino Del Regno <angelogiaocchino.delregno@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/430] arm64: dts: mediatek: Apply mt8395-radxa DT overlay at build time
Date: Mon, 29 Dec 2025 17:09:03 +0100
Message-ID: <20251229160729.552053468@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit ce7b1d58609abc2941a1f38094147f439fb74233 ]

It's a requirement that DT overlays be applied at build time in order to
validate them as overlays are not validated on their own.

Add missing target for mt8395-radxa hd panel overlay.

Fixes: 4c8ff61199a7 ("arm64: dts: mediatek: mt8395-radxa-nio-12l: Add Radxa 8 HD panel")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Acked-by: AngeloGioacchino Del Regno <angelogiaocchino.delregno@collabora.com>
Link: https://patch.msgid.link/20251205215940.19287-1-linux@fw-web.de
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/Makefile b/arch/arm64/boot/dts/mediatek/Makefile
index a4df4c21399e..b50799b2a65f 100644
--- a/arch/arm64/boot/dts/mediatek/Makefile
+++ b/arch/arm64/boot/dts/mediatek/Makefile
@@ -104,6 +104,8 @@ dtb-$(CONFIG_ARCH_MEDIATEK) += mt8390-genio-700-evk.dtb
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt8395-kontron-3-5-sbc-i1200.dtb
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt8395-radxa-nio-12l.dtb
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt8395-radxa-nio-12l-8-hd-panel.dtbo
+mt8395-radxa-nio-12l-8-hd-panel-dtbs := mt8395-radxa-nio-12l.dtb mt8395-radxa-nio-12l-8-hd-panel.dtbo
+dtb-$(CONFIG_ARCH_MEDIATEK) += mt8395-radxa-nio-12l-8-hd-panel.dtb
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt8516-pumpkin.dtb
 
 # Device tree overlays support
-- 
2.51.0



