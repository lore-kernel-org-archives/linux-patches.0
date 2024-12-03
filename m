Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85701E3DF9;
	Tue,  3 Dec 2024 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238151; cv=none; b=p5Nlsda0F0uCM15WRYTaoWU6ncJGD3IQpNCR0Jb5l3ikOljbsT4SphOVyJFqzo3A8IdjW1nTV+2fpQA9aZsDK4LyBg1K4nMke28/v096/EkXnEXdnT56Ukp4znONtMq4HOtpoO79I6lEAT7uB5mpsHciyhXviEW0PTKPkDBc2Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238151; c=relaxed/simple;
	bh=2bB4El4V8S9xjfOblzJzkxCX+4XRi/JI/7uh2qBC9gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrluAv9pGhycgLjowPvPAucL4lQ348SzAfMgEODImV/i7WC4WVtZZPJD3Rxbu6nbPWbID8UkIcK+WOjM62CA8xIne8s/vHbm3+zZs8PPElMQxhf7s+5E4L2MU8VFbLhQw8gIqJ2pMyketLXNgT54TriqOtkGTfbCP0snbgtqSV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hhsdc5Ko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hhsdc5Ko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67092C4CECF;
	Tue,  3 Dec 2024 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238151;
	bh=2bB4El4V8S9xjfOblzJzkxCX+4XRi/JI/7uh2qBC9gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hhsdc5KoW6rWOepjBaLUuTa0BnzBnoALDdO417Ry6kBn180ezDSNwu50jlxNbz9Vy
	 WH4C0TOAYWoRnsY15z69zfu7/OgGpy9RBhL+AD5VdZOF4GLb2iM1goNhSrRN/JW1dE
	 W3+1kVDvCZONfvg95+yiye7qptdYXCRKhhsz9mfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 180/817] arm64: dts: mt8183: Damu: add i2c2s i2c-scl-internal-delay-ns
Date: Tue,  3 Dec 2024 15:35:52 +0100
Message-ID: <20241203144002.757940788@linuxfoundation.org>
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

[ Upstream commit 6ff2d45f2121c698a57c959ae21885a048615908 ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: cabc71b08eb5 ("arm64: dts: mt8183: Add kukui-jacuzzi-damu board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-4-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
index 0b45aee2e2995..65860b33c01fe 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
@@ -30,3 +30,6 @@ &qca_wifi {
 	qcom,ath10k-calibration-variant = "GO_DAMU";
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <20000>;
+};
-- 
2.43.0



