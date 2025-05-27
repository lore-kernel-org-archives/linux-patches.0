Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF70527F16C;
	Tue, 27 May 2025 16:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364354; cv=none; b=FuM2IOpamRQUbILi1BwnqjooQ7jsF4A+s2Ie/LmgmGfbvdcC7HhJeAmsw7vb7xBxtbKs8G+jnkRI31ez38uBrTYBUUnf0zpMOgWW7/WwMHMj/NjNIGxY77QKfX+XYPIJeNYpO5NjVW+96CYeG0dFJFgD7oinUndEBMBv4nHur6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364354; c=relaxed/simple;
	bh=ZiZbvNpxZfYYTSQGKJMd9RwkAz8e14FrQte3an3I2jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GH4l3u5sfJYY/mohhOnpFaKKdzMBcoBopFRu6ytc3i+3qTjvFNMvC2/ZLEMoIyK4bWMhrE+Xp6MpQARZNaECHSXAkRbr77mqXEorITAOUQssotqxFcDjE89nw+WYIo8jgvL0BccxnkY7bGS3Ho/XL8BrbPdluIe6T7DHUomyyCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLNHnyJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLNHnyJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E49C4CEEB;
	Tue, 27 May 2025 16:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364354;
	bh=ZiZbvNpxZfYYTSQGKJMd9RwkAz8e14FrQte3an3I2jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLNHnyJI/WpHvfJkL+YYsYPYsDRimceEIUh0bcHh/UtaZyZDKsCtpLijG2yg3rPsc
	 0ouiaSqTe9UMogJn3krFvaLRwGn8EQ13f6UGJZD7dk/ckpo6S7Jpr6Ki9lH5EOxVQn
	 xz3dSTcxznYPguRrUgxQL6W1D9m5qjF32BDBiCoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/626] nvmem: rockchip-otp: add rk3576 variant data
Date: Tue, 27 May 2025 18:18:25 +0200
Message-ID: <20250527162445.556932076@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 50d75a13a9ce880a5ef07a4ccc63ba561cc2e69a ]

The variant works very similar to the rk3588, just with a different
read-offset and size.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20250411112251.68002-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/rockchip-otp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvmem/rockchip-otp.c b/drivers/nvmem/rockchip-otp.c
index 3edfbfc2d7220..d88f12c532426 100644
--- a/drivers/nvmem/rockchip-otp.c
+++ b/drivers/nvmem/rockchip-otp.c
@@ -274,6 +274,14 @@ static const struct rockchip_data px30_data = {
 	.reg_read = px30_otp_read,
 };
 
+static const struct rockchip_data rk3576_data = {
+	.size = 0x100,
+	.read_offset = 0x700,
+	.clks = px30_otp_clocks,
+	.num_clks = ARRAY_SIZE(px30_otp_clocks),
+	.reg_read = rk3588_otp_read,
+};
+
 static const char * const rk3588_otp_clocks[] = {
 	"otp", "apb_pclk", "phy", "arb",
 };
@@ -295,6 +303,10 @@ static const struct of_device_id rockchip_otp_match[] = {
 		.compatible = "rockchip,rk3308-otp",
 		.data = &px30_data,
 	},
+	{
+		.compatible = "rockchip,rk3576-otp",
+		.data = &rk3576_data,
+	},
 	{
 		.compatible = "rockchip,rk3588-otp",
 		.data = &rk3588_data,
-- 
2.39.5



