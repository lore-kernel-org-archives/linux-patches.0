Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062714;
	b=LvkBygFbQbkzTyoy2ybC1powO42Y6HVhTyHNyJ9DGJJvW07LIDwUkwmnsKj1I4At10kB
	 RwEFR8JBZkvwGKjPo6L3FU6i1S3tSMnQW17snLQYPh5PDmFLN6B8dGycY9FLCKU8kw7PM
	 h8VxVb44vJ0DQVS31AhlLaf39qJx0S/JstT+4WszZ8SgZzPFnp7AQ4+W08KKGX9xztZMf
	 oI+gUHt5mRpJakI8CRcqGPoR/SwYeKMq29174gp277IG/ZWs12xNSRAtNbYc+40VFkpKd
	 llFafWYul5+4/UhAYDReL5zavIAoFUnxe4dOYOcOq2OJ3UuTIuqJoCk3tD9iP1FbpPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lPSa0qfvOUblO6opJF8nhmn722CeIjzb22COJqhLm0c=;
	b=ogkbSrF37HuwVUUynSnUc1fdqtF15gjOaY+DXIC4N6VWCzfkyGEdlldZ2m5hE/IVszJL
	 ycdRRrs/X2mEEtleP1E4OUbbru7OafytjwAXkEHj8Y2bIzEUFV/tt+rUVDkc2LKa0DHKp
	 OYUpAn7o9gy5RJM+mmh3AXWGGMcG2fSfDQMn//LZp80Gdlo/ydAmr2W7IwQjaffd2gPox
	 NOJ2OsW4NSU6rMeIKugjHVHIHoSUIiD2YceaQhBRdow+eR+KBXkJxYVX/GMuCu7mcCkjV
	 1YUfuVeZLuhoM4v4eVvsHr9junCdtLN7Mt2Cm77Y1xSdR3XuawVxd+dsGLiJSIOydFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4W8ZUN+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0309F606A326;
	Sat,  7 Nov 2026 14:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4W8ZUN+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6731F008A1;
	Sat,  7 Nov 2026 14:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062713;
	bh=lPSa0qfvOUblO6opJF8nhmn722CeIjzb22COJqhLm0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4W8ZUN+AxePt+OCyOcvOg+90vhhKC1yGpDzAh23CIW3rysi3rT9HPTBA8E74JKRO
	 cKa91J186j/ob/bwrSpcAqq7KY92gjFjZYFMUZpQl4D7ao/tD/wQr+ymo14rSMdB0U
	 AGW5OZAwym7AKK7CeqBwPLAH9A+jlAkF/kakBR+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/869] media: meson-ir-tx: Ensure clock is disabled on unbind
Date: Sat,  7 Nov 2026 08:45:17 -0500
Message-ID: <20261107134853.374935557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 1517326fcc9dfdb9acb24f42472366ac1b4b8237 ]

clk_prepare_enable() needs a call to clk_disable_unprepare() on
driver unbind. Make it devm managed.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index fded2c256f2a6..6beb9e97453dd 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -288,11 +288,12 @@ static int meson_irtx_mod_clock_probe(struct meson_irtx *ir,
 	if (!np)
 		return -ENODEV;
 
-	clock = devm_clk_get(ir->dev, "xtal");
-	if (IS_ERR(clock) || clk_prepare_enable(clock))
+	*clk_nr = IRB_MOD_XTAL3_CLK;
+
+	clock = devm_clk_get_enabled(ir->dev, "xtal");
+	if (IS_ERR(clock))
 		return -ENODEV;
 
-	*clk_nr = IRB_MOD_XTAL3_CLK;
 	ir->clk_rate = clk_get_rate(clock) / 3;
 
 	if (ir->clk_rate < IRB_MOD_1US_CLK_RATE) {
-- 
2.53.0



