Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142971CEAC2;
	Tue, 27 May 2025 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366257; cv=none; b=nUuUk87Cce/ZbQe13PUg6v9pBhnLCtpbGxr50kt7KuhVgkN3O29P6tRJU/FZCig20aH3Il71EEm8kpRq5X39IiiS1WpZHafvcnDjHGGvpztCcmGHe/WxuZ7J4Mk6+FzXCay6nRUcJfPE6mXIJ0rOX/416m3d4t9Ds+jerCz922Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366257; c=relaxed/simple;
	bh=4/5NnEtlhCC56YxrR5j/2kJp3wRGK3E81+J5MQ3U30g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zy41FdMa92dLaKDUSHOErtNDF+083NU6dhwYjdMjUm8Xj1aOsJ3Zb7h9fKxXSwx4ULRDVBugOKUGvw5idJf0m4xz12HPuASLejUie5kbheF9nbglnlUaW6TjRT3YBoa4vw+nYa6ZV3u2uTSiYQdSXo/oTX2Gz9FvJWa8vt54ca0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAtcGiZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAtcGiZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2F7C4CEE9;
	Tue, 27 May 2025 17:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366256;
	bh=4/5NnEtlhCC56YxrR5j/2kJp3wRGK3E81+J5MQ3U30g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAtcGiZfNuuXcvDNHWxqTvF2ZMmZEfS1ci50tuvBPegXtXYoy/Cr7IBNiZgpIzHUt
	 mzJRpRfOs9zn8PwN8Aukua07lT+nMAoudA1lsCQwF9z/nkAJ6vvE3kpgbjbGW4m1iL
	 jt43s0kOvEGJh6y0b6Vrddx9ECFnW+fALnWveAc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 011/783] nvmem: rockchip-otp: add rk3576 variant data
Date: Tue, 27 May 2025 18:16:48 +0200
Message-ID: <20250527162513.503579380@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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



