Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512832D5436;
	Tue, 21 Jul 2026 17:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655579; cv=none; b=d8NpID2JjJpsiQQ2aY6W6HjHCbdNJlYg+7zuDJE8RLCLzU79vVZ8eH/dxTpGMYZgVEYCiNfKUMv9YVHuudFiAOyJy8uiWKY7BKNWIeDISdMyqeVDB3/BNg89WO+YfPvYKs8Xq6/tJeyq6ovFPTHYdcTCvC5LCFDn440Uk40ZGn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655579; c=relaxed/simple;
	bh=O9hUzqGV4OvCrNSpbCGT664Xqfw6+H5szkAj/MI+9Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0YSG4r+TwLvtoQgNBQWnPtM/1AVCN1z1SwVUqaIMbP8p60bsBWt9JnmR/GSAaFozInn2oLv+Sat7GSSuEJTx9hlCY9TwJ/z5NRiSE6D2D3cRVFYMszke8AU20irx71xnG5Jh/tW3pJGNuk1ZWqlznVNAD5FvnIiQ5jGRiA1KUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCJUh8C3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCJUh8C3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B709A1F000E9;
	Tue, 21 Jul 2026 17:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655578;
	bh=BgVVx/J5A0nABBmDMInvVBi03+6pHGY2+7oiMD5hZcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCJUh8C3EvLhSTY+tYMVeTA4VWfIV3nxsZzfCIiqDAYYx5RMfSTRG0vQewlaUkm+v
	 IHZwG7BjGUk5Li8DHaybGW79k7xIkp75qIoQBASDgKZbIOPks0sbUgf1bk0Ga51QmT
	 bN64aLpJI6AL4WMjiVKIw5aJMgxhmXuGl7/Zzp1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0063/1611] drm/tidss: Drop extra drm_mode_config_reset() call
Date: Tue, 21 Jul 2026 17:02:59 +0200
Message-ID: <20260721152516.247384071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit f468fef38716f667e805e0fa2c497c6b9c325bb9 ]

We are calling drm_mode_config_reset() twice at probe time. There's no
reason for this and the second call can be removed, reducing work at
probe time slightly.

Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20260311-tidss-minor-fixes-v2-1-cb4479784458@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_kms.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_kms.c b/drivers/gpu/drm/tidss/tidss_kms.c
index 9f5f98e707f2cc..838111e11186a6 100644
--- a/drivers/gpu/drm/tidss/tidss_kms.c
+++ b/drivers/gpu/drm/tidss/tidss_kms.c
@@ -291,8 +291,6 @@ int tidss_modeset_init(struct tidss_device *tidss)
 	if (ret)
 		return ret;
 
-	drm_mode_config_reset(ddev);
-
 	dev_dbg(tidss->dev, "%s done\n", __func__);
 
 	return 0;
-- 
2.53.0



