Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF9E33FE;
	Tue,  3 Dec 2024 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238146; cv=none; b=Ov/ca623QXrjwdJ+g+lz3VIpH1ivhSbXLReYklpAA3VWVgf1QLJphHo4AGXG3bL6WYRytax/y6K2X4tL64pSy9K2C02aLGIkq/wszea9qyskCNDW8vF9+9mmca75qa/fgWLkt7WlCAEOqoj/FFlBo5LS3g6nybAcUiZmQHggUxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238146; c=relaxed/simple;
	bh=eTvixIraFKKxTibFZHYdA+mp8RERowCDGDw4XLNECME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AopT3geGTIEYRDKi2MvYZcfH2ScqjasAUaSZEFJtxWaNfS4pE+hydJa/nXyTpR5kl6ea5x4zXk+gY2PSXqOiZC3SN8mfG61ScxHjebwHIHlAe20T8MYsinABuq9fjkcQNe4VaaFs4B0Z4SXLuLXFcyVSPeaBQSVhZc2fgR7NF+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfqVExyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfqVExyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6C3C4CECF;
	Tue,  3 Dec 2024 15:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238146;
	bh=eTvixIraFKKxTibFZHYdA+mp8RERowCDGDw4XLNECME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfqVExyzz2ZucDNbf4p4J2JYR7/4NT6YNHpCFxw0B3J1M8W41S9J+ddPLbF9DmTck
	 UCphpxDNDddFyHrL+jR5HJoVwZQg710okeNZrRx12K0VuYoxmkYphaKURLehuwtnrt
	 oxav1o4FD+I9saiMm9OEconVqCwWWLkG31nD9vHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 178/817] arm64: dts: mt8183: burnet: add i2c2s i2c-scl-internal-delay-ns
Date: Tue,  3 Dec 2024 15:35:50 +0100
Message-ID: <20241203144002.678181503@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>

[ Upstream commit 85af64983889c621e8868b744c8ca03bd5038c02 ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: dd6e3b06214f ("arm64: dts: mt8183: Add kukui-jacuzzi-burnet board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-2-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
index 19c1e2bee494c..20b71f2e7159a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
@@ -30,3 +30,6 @@ touchscreen@2c {
 	};
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <4100>;
+};
-- 
2.43.0



