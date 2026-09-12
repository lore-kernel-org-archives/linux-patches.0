Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1857E343893;
	Sat, 12 Sep 2026 09:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206120; cv=none; b=Qh0zPbGnhAAgu94Pn+ZZVX6DR1FB+OXHaO5UUKtIAxhjrWSiKjEBQLzWwvHEfvYv73KBZFOCa8AnBIb53gzvwYMCZWqgXE4wwdpi7+bliH5H57uddyXJ16Z/0WuAXdLUM5NQHDEhrmf68DpgqXbJv6KL0h/vluRyI6Iy9En9lBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206120; c=relaxed/simple;
	bh=9Hqor5Qzf2lMhnjITIDPtjWUVznoAbqGWjO24FU6W6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8ua4CsQ0RCtEEIBMlIh0ZK+aM8BjDbbcNWEk5UY4S/iva4oSmCAlJ5CIMe2OrJazCl5YZUfvLQ2XYitcF0hbfQqHyVZ2AAaSQqcBxjhTokjC0yziYiUREHSHITXpa4pWfoCp9xMHhIkaiCl+FDpw+L78fDtjsC/UlvzjPiKXcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjZ21z7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjZ21z7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AED01F000FF;
	Sat, 12 Sep 2026 09:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206119;
	bh=HyJGmq/pDmy3PhzzxFSO7lBTv+uOKIoX2hYH5qAeuMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjZ21z7uzVYKgU2VauUs3h/rf12rdFFc5LoMmoSAC+rbq6g6CPp/6PXGK+cqNj1g8
	 jskRWuL+lpx+ar6gFA/DvAXMXaCUeDbrd5LXQzWWerzQHKlfJn4ZWeC+vViww8VbVX
	 /dnERkNroS2HlaIcPC9pmh6FltnXTCglvalBdYpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0098/1518] drm/rockchip: dw_dp: Add missing newline in dev_err_probe() message
Date: Sat, 12 Sep 2026 08:37:47 +0200
Message-ID: <20260912065625.696266681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 0a01412178047bf3ff351c7e75d373e411072a87 ]

Add the missing trailing newline to dev_err_probe() call in
dw_dp_rockchip_bind().

Fixes: d68ba7bac955 ("drm/rockchip: Add RK3588 DPTX output support")
Fixes: 26cb3e26efa7 ("drm/rockchip: dw_dp: Simplify error handling")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260601-drm-rk-fixes-v4-2-c3f3f123e1da@collabora.com
Stable-dep-of: cc6d7aca2f37 ("drm/rockchip: dw_dp: Release core resources")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_dp-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
index 0e7a2d46dcb0b..b3a635609effa 100644
--- a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
@@ -110,7 +110,7 @@ static int dw_dp_rockchip_bind(struct device *dev, struct device *master, void *
 	connector = drm_bridge_connector_init(drm_dev, encoder);
 	if (IS_ERR(connector))
 		return dev_err_probe(dev, PTR_ERR(connector),
-				     "Failed to init bridge connector");
+				     "Failed to init bridge connector\n");
 
 	return drm_connector_attach_encoder(connector, encoder);
 }
-- 
2.53.0



