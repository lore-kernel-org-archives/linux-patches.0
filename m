Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31CB1442E8;
	Fri,  6 Dec 2024 14:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496979; cv=none; b=Ssy31/eN9/ZDIabhAKrezBYCtgnPTVWEi4kGGm9+ZzVOvu0C9jfsSjDon/iwa+L0OjVvg3RnFagyxlCF4tw/fiLMk3PyRuE04HxVPJlJajQenPEf05fh+VXUdKpoammaDp9BFvvKW8tXF18zdl5I5dGJzENrOlR5Uux6SonynSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496979; c=relaxed/simple;
	bh=m+7/7urf9HiL7AMPGIbd7ojw244O9Pjd2tMFL324S5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSwscZhIaA1qVGAViHmMM3qZ8gi8PVfrPiwMgqH3E1ZRJ7RXXwn0dpKto1bTWzFeGhtqc4IJiJK58kvLw/q6XmNr1//o12s7DjcNKXdPcaYfJBn5q4PSUB1uJEBB8KLxX88s4/4WLzyVdmQLDcJX01ZR5+znPCEed6b3iXtOtyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9zClSOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9zClSOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60917C4CED1;
	Fri,  6 Dec 2024 14:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496978;
	bh=m+7/7urf9HiL7AMPGIbd7ojw244O9Pjd2tMFL324S5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9zClSOlMA7mVxvs2cHEx2uMYIjvgZndKURtx1Mc7KaGh9uD2g4Luo9kMjydX6VWp
	 dDpla5n4SAObMzF4Mu5ShJWagvgfKhIyYiy5aTgs9dg4y+Z511aQlB2YGRuJBMK+KS
	 xLJ3A862ywGa/Os5t8KT89pHhh5ocjb9nrCpYplI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/676] arm64: dts: rockchip: correct analog audio name on Indiedroid Nova
Date: Fri,  6 Dec 2024 15:29:40 +0100
Message-ID: <20241206143659.642142341@linuxfoundation.org>
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
index 9299fa7e3e215..e813d426be105 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts
@@ -34,7 +34,7 @@ sdio_pwrseq: sdio-pwrseq {
 
 	sound {
 		compatible = "audio-graph-card";
-		label = "rockchip,es8388-codec";
+		label = "rockchip,es8388";
 		widgets = "Microphone", "Mic Jack",
 			  "Headphone", "Headphones";
 		routing = "LINPUT2", "Mic Jack",
-- 
2.43.0



