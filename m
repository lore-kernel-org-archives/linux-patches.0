Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5288149C69;
	Fri,  6 Dec 2024 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496886; cv=none; b=Dp5jrn8972DmCgPP2VbBGY/NJDXNdDHeC0C5XHeviqYx0W3QeeRfDUpRpY4msi8VADkATKlxmzI/aq9na5H6l6tw1eZAym+qdECamsIXZclr+vkTR6tS1nFNBxf+m2fmFCxEdhv5+cVsJOP8eXVHu7/QBNONhxZeOyH+gk4tKXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496886; c=relaxed/simple;
	bh=avv3TEtfAWYd12bRiomQe7tcU65D/+zlKTJdxiwqH64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewhe8x+Ljt03RZY14JtL2JZdd07lkLx32OBwnWmv5GdV0ekG2ldTQSpi8mrF4anEQUfPRAHytuC61tq39ZhY5fOoblryQn0rKqG3/Z8l+xkRRcUhEj5q5iNw6gy6O2ENjfXZI0NI3Qxeo1TnVVbE/Y1H0Z7GBKrYblAJ6eKTeo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeUzgcTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeUzgcTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A77EC4CED1;
	Fri,  6 Dec 2024 14:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496886;
	bh=avv3TEtfAWYd12bRiomQe7tcU65D/+zlKTJdxiwqH64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yeUzgcTiUwnIWPL20KA4Y+EueFj0HtgB4cgWt/5E2w2W0P0ZpGRaM/tbBYKnmntUa
	 63bdcJ8jk1KEICJT000ZUqMVfW4qVEm2Y6yPIK29H7cqgJoDX6X7B/QhgO0EsCwPiw
	 fNK1seZOUSg/8r2sYD3LeO6Jni0tUN0oUxRgsCis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/676] arm64: dts: mt8183: cozmo: add i2c2s i2c-scl-internal-delay-ns
Date: Fri,  6 Dec 2024 15:29:13 +0100
Message-ID: <20241206143658.590988696@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>

[ Upstream commit bd0eb3b1f7aee698b86513edf10a50e2d0c7cb14 ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: 52e84f233459 ("arm64: dts: mt8183: Add kukui-jacuzzi-cozmo board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-3-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
index 072133fb0f016..47905f84bc161 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
@@ -17,6 +17,8 @@ &i2c_tunnel {
 };
 
 &i2c2 {
+	i2c-scl-internal-delay-ns = <25000>;
+
 	trackpad@2c {
 		compatible = "hid-over-i2c";
 		reg = <0x2c>;
-- 
2.43.0



