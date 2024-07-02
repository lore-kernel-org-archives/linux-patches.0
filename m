Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278BB1BE226;
	Tue,  2 Jul 2024 17:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941197; cv=none; b=oxwyJYHU5qCnuHcc5XZEDBDd1WYhXHWHr8lN+z1wALLWXzel48tUJk7mSRESM/q4ba0ATro5EFcuh1/2Pe//JazSISXyCaVe3Bi27ZUOD2VrAj4folI2FjLJH5d9v2Ij5rMoB1Za28l1+KiIpxm4Ra3ZC+DcDKaQ9HM6RQyF1CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941197; c=relaxed/simple;
	bh=g7ONIvBKYPfBwAFWbU64YXqMjUD9z8BKZQteecm30js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qbv/oSw6WdXd7mNLDadPG7+u70815V2Uau6+/5L9M+mpiLhHlaHk0ah2nQT3gd/pdFqoivZfmRmwgZxOani3tICqBa6FnEuGqnBW1kgvXgT3+SZ3wGpyIk4gLRb0zcsSOOGOYMMBjuRGyGcjFDAS7JQgd8LwJ7bP9LreZfSiVbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnRnRJGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnRnRJGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFA1C4AF0A;
	Tue,  2 Jul 2024 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941197;
	bh=g7ONIvBKYPfBwAFWbU64YXqMjUD9z8BKZQteecm30js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnRnRJGOW7bKFH9Si5C3ET0Et5AuseiqOTAlW4RX+Wa8xgEy8/lggK7o2XtVcxiVh
	 mHzZnn5+WZPDsm7kPXuW2t+BGmKpEuEyg0nfrH1DZuouaOUjfNtoyQwfkbptx725wT
	 iHPP1+0ECdSjsFEoLYQbnVEDw/CQXDLMpH/NWO0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/163] arm64: dts: rockchip: Fix the value of `dlg,jack-det-rate` mismatch on rk3399-gru
Date: Tue,  2 Jul 2024 19:04:30 +0200
Message-ID: <20240702170238.966376238@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit a500c0b4b589ae6fb79140c9d96bd5cd31393d41 ]

According to Documentation/devicetree/bindings/sound/dialog,da7219.yaml,
the value of `dlg,jack-det-rate` property should be "32_64" instead of
"32ms_64ms".

Fixes: dc0ff0fa3a9b ("ASoC: da7219: Add Jack insertion detection polarity")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20240613-jack-rate-v2-2-ebc5f9f37931@chromium.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
index 789fd0dcc88ba..3cd63d1e8f15b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
@@ -450,7 +450,7 @@ ap_i2c_audio: &i2c8 {
 			dlg,btn-cfg = <50>;
 			dlg,mic-det-thr = <500>;
 			dlg,jack-ins-deb = <20>;
-			dlg,jack-det-rate = "32ms_64ms";
+			dlg,jack-det-rate = "32_64";
 			dlg,jack-rem-deb = <1>;
 
 			dlg,a-d-btn-thr = <0xa>;
-- 
2.43.0



