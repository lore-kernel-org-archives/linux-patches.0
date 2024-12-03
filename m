Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D23E1F890A;
	Tue,  3 Dec 2024 15:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240686; cv=none; b=T5yXZiQJoM++p6tL6pVkayb/8/wzKnEZxaOne8PPpVLjELjPPEcDsfoXGuyzbaRfQEk5CCu3qoQg5rrNulS1TotxvPy1zau1q7sBTpd48bamAq/SX4IO0KTQ9FYePtW8yCIvysmfS8UOeTCGZWOi6FyDoogYq+6kDbV4MRdoc3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240686; c=relaxed/simple;
	bh=1CK0rDkWUrBNdBYB9XF3HavWhp5EM5fk0ZvO0+GN5Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYI/gcWHZiYGApnYbh1nqqReMIzVLsy76uQ55OnbwSa6k+M4IV64Nk3Nrp5ZNYKNSpnEk0gbdSHbatE0u2oi7nFATmw50SjUU4+YHaXw0O8dX2ApjHL0Tm8Hqn07mXtDHvTW/ZG3dsTMq3EMTmP7TUi+HhrkQxDV3uCKYggZMHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pgWWczL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pgWWczL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3624BC4CECF;
	Tue,  3 Dec 2024 15:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240685;
	bh=1CK0rDkWUrBNdBYB9XF3HavWhp5EM5fk0ZvO0+GN5Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pgWWczL8TMkOkLKe0d7XAn30EWv9irTXrzVhoTfZmQQbn6/LwUIOGM6VDI5D+2ry
	 xAElxUV55VTQEXZSIU/rN/7mEEh+svwRXdWaREht5DrLRoesVY+S0bNZBLG6l+oY4+
	 nsvRIvLnElTmPBfOtbpuFLMNdcUBzguU8ab8XE2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/826] arm64: dts: rockchip: correct analog audio name on Indiedroid Nova
Date: Tue,  3 Dec 2024 15:38:22 +0100
Message-ID: <20241203144750.562968425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit 42d85557527266804579bc5d20c101d93f6be3c6 ]

Correct the audio name for the Indiedroid Nova from
rockchip,es8388-codec to rockchip,es8388. This name change corrects a
kernel log error of "ASoC: driver name too long 'rockchip,es8388-codec'
-> 'rockchip_es8388'".

Fixes: 3900160e164b ("arm64: dts: rockchip: Add Indiedroid Nova board")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://lore.kernel.org/r/20241031150505.967909-2-macroalpha82@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts b/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts
index 8ba111d9283fe..d9d2bf822443b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts
@@ -62,7 +62,7 @@ sdio_pwrseq: sdio-pwrseq {
 
 	sound {
 		compatible = "audio-graph-card";
-		label = "rockchip,es8388-codec";
+		label = "rockchip,es8388";
 		widgets = "Microphone", "Mic Jack",
 			  "Headphone", "Headphones";
 		routing = "LINPUT2", "Mic Jack",
-- 
2.43.0



