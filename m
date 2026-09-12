Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C103C3B9952;
	Sat, 12 Sep 2026 07:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196815; cv=none; b=nPIyPWJ6xYv+orTLkJriSPD/OxOA2H/cVhtwWrn3N00q3lVj+c37nPKXve+IkpeIO9yD5qeTRDjIO3e+OT7RaP+BDQlKpFCUPPlOMKX5bisNhARTaEOsJb7P2IYmAVZi7fSqjgmjA0UTEZGovsExlhDa9PgDpMmX+6jQglQtTTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196815; c=relaxed/simple;
	bh=WMYDDx8ZrkqdaXzYUMiDtt8ExV/r96C4LGxvNRWE/zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8YVI/8JZ2dVYMrIAHSEk1IMNRs6fCLqWDqA+A2yk1pmbr3izxd2U+ZtF1A/W1J+DIlEAIZWbZb2EbTQB3+wS6zVhWwxl6/pqVMwv11ZvpEJmeYQPcBxOcLG+62G7JdbE/QwDJ1HJxO/srhzNRXBtA2mGmwORrJDjoT03lGVS98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A09FWrqs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A09FWrqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE371F000FF;
	Sat, 12 Sep 2026 07:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196811;
	bh=X3y41Ez4g/kOI8NZmRMutjjX9wO1VerqDU0Lbj2OtLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A09FWrqs3F/mOkSt0cve0BYjV5rfh6IvBVpVrpM47CLt04nd20KPR02OwBrs0ZPox
	 e1AuzV/frED66cXBnxR5DXU5wVcIpDK4zBC7ts+yT0eQthpZb0k/kV05xZiChEnz2l
	 sYdIZM4dvPUbsWzU8wGj7W1MlWuuz3p/Qxq2aLPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0040/1815] drm/rockchip: dw_dp: Add missing newline in dev_err_probe() message
Date: Sat, 12 Sep 2026 08:29:50 +0200
Message-ID: <20260912065649.962631793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_dp-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
index 32bc73a1d5e45..f137f699737cd 100644
--- a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
@@ -109,7 +109,7 @@ static int dw_dp_rockchip_bind(struct device *dev, struct device *master, void *
 	connector = drm_bridge_connector_init(drm_dev, encoder);
 	if (IS_ERR(connector))
 		return dev_err_probe(dev, PTR_ERR(connector),
-				     "Failed to init bridge connector");
+				     "Failed to init bridge connector\n");
 
 	return 0;
 }
-- 
2.53.0



