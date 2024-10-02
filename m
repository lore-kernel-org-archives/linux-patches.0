Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09DA29CE7;
	Wed,  2 Oct 2024 13:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876848; cv=none; b=H+QC42TEaHo7gOFt3RjdXIaNl53oNK/TG1M7z1HgXifSDDgxAOqpnp71THAE/FYqHxPXupJBnWSndFE6FApLWA3cbNDn1PqyN4rVgLkClD4LzVlok/o5kOia2L2AK1GRVK8rNZntiWnzLNIxJSi2KJuQGmND+voPxowofOu2RHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876848; c=relaxed/simple;
	bh=pe4C9nSbafklvHeK08KjodA7AC9fVO+HokJLtD5/zyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNCxpR1EIZyookl/ICkDNTSCtO4RrtkpVjgNj3JHkdQc0FI9xJ9ev1K9Hj+qckC49HOAovekthL7QOjHRWVGwwjykeDvz1TXeRelAkYQKzYdGySfte4cy1LtCBG/1Nrl0WSQN8w18PjsB1YtImCNjodG4BcHytB5xRyE9Vs/RuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+HjQ9+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+HjQ9+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CADC4CEC2;
	Wed,  2 Oct 2024 13:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876848;
	bh=pe4C9nSbafklvHeK08KjodA7AC9fVO+HokJLtD5/zyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+HjQ9+Rc0lUxXLtpjpy5PGE+JOBhPCtxQmqrymx67nxnUubyvz6RCEblzF9FfOoZ
	 oH6Ia+/XVt88z0xfP8ORMcOnI7RSDfS/t7G2uE85QJh9gfo43YSmL6V2ZKhyaHD4Bf
	 4bcpymvsjV4XqlkcEm9+kQ+xabtMU66zBGjYPJb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.11 580/695] arm64: dts: mediatek: mt8395-nio-12l: Mark USB 3.0 on xhci1 as disabled
Date: Wed,  2 Oct 2024 14:59:38 +0200
Message-ID: <20241002125845.664406833@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit be985531a5dd9ca50fc9f3f85b8adeb2a4a75a58 upstream.

USB 3.0 on xhci1 is not used, as the controller shares the same PHY as
pcie1. The latter is enabled to support the M.2 PCIe WLAN card on this
design.

Mark USB 3.0 as disabled on this controller using the
"mediatek,u3p-dis-msk" property.

Fixes: 96564b1e2ea4 ("arm64: dts: mediatek: Introduce the MT8395 Radxa NIO 12L board")
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20240731034411.371178-3-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
@@ -898,6 +898,7 @@
 	usb2-lpm-disable;
 	vusb33-supply = <&mt6359_vusb_ldo_reg>;
 	vbus-supply = <&vsys>;
+	mediatek,u3p-dis-msk = <1>;
 	status = "okay";
 };
 


