Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79801A619E;
	Tue, 30 Jul 2024 16:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357763; cv=none; b=XQGGmNKIITc+OwQLM+P8tydPaiyI6LJwcZUvxosnEOaYhuoK7H2QEgIStcn3p1JL5Fa3DZfEsQF09Gf3vnZg3mNLjtcoautZQUqv/5DKUTYPN42rOQE8WyCGytElB75qJybS14Vd2t3msx76h7+a6Tmi4nUKqX2z3KzDLkKs0Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357763; c=relaxed/simple;
	bh=XO7nPTokJ0lN/WkGf2o+5pmA+EXHvyj3qE+ILELifas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RerSG1Vgkpgkz53NsOGMizXXKwtnoEqvYvSHW/PymPRIXy6/qYVbm9KRc++BneecIkR3WrFtWiVCEiNzi/sU0fMIJPeqKjthdfEzPKQ7EbRxzJQAcWXUIbBrfCkG1m5mKKyKwUKgEBC7z2hTu24Yc5eXrWbjdka+3OLt20P12Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXdfOwBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXdfOwBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0F3C32782;
	Tue, 30 Jul 2024 16:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357762;
	bh=XO7nPTokJ0lN/WkGf2o+5pmA+EXHvyj3qE+ILELifas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXdfOwBkBUeZtY6AlmNZYtxpi5t1zSMzWMGh+IgkT6d4laKzes2trlA0PKgtdvVb8
	 TXUG88U3ICSGW+yNsUj7g78RbEsF4JCrG40uaAnyrfk9HG/DmvAPgJk0U55Ip2rl8R
	 sYfWH4wtT62cuNmpE1uXyIh1THBK6Yb4gt6FhqRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/568] nvmem: rockchip-otp: set add_legacy_fixed_of_cells config option
Date: Tue, 30 Jul 2024 17:46:36 +0200
Message-ID: <20240730151651.168516436@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Heiko Stuebner <heiko.stuebner@cherry.de>

[ Upstream commit 2933e79db3c00a8cdc56f6bb050a857fec1875ad ]

The Rockchip OTP describes its layout via devicetree subnodes,
so set the appropriate property.

Fixes: 2cc3b37f5b6d ("nvmem: add explicit config option to read old syntax fixed OF cells")
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240705074852.423202-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/rockchip-otp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/rockchip-otp.c b/drivers/nvmem/rockchip-otp.c
index cb9aa5428350a..7107d68a2f8c7 100644
--- a/drivers/nvmem/rockchip-otp.c
+++ b/drivers/nvmem/rockchip-otp.c
@@ -255,6 +255,7 @@ static int rockchip_otp_read(void *context, unsigned int offset,
 static struct nvmem_config otp_config = {
 	.name = "rockchip-otp",
 	.owner = THIS_MODULE,
+	.add_legacy_fixed_of_cells = true,
 	.read_only = true,
 	.stride = 1,
 	.word_size = 1,
-- 
2.43.0



