Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631621F1306;
	Wed, 30 Jul 2025 09:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868276; cv=none; b=rbYfQV6BVZa+yCAB0LJfJWfsP3QO0se8MVvXN9sFHptrQO47J4HfwBleM3nF8caAQA5pfYDPv3i2+3P+jTodW/ZEIjDzuf2BUOUxEenlSIrimDyQ/wAwZscUm0DfBBln7EtPJsplI/gB+XLRj26JncLJl+Z2gDU1QyOJ9lYugos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868276; c=relaxed/simple;
	bh=iWjPBoHL27Ot6AKUZWnq9dknp3EP/IPd5eHQErVggLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dO6TVzCVkM2BRKaRths67B4CGtJ3B7ubk5qKkfEzZ+YbpDuhLcz7gX/r/7G0mlJ1JuJJalG+aqHa5WM1cS5+kNsK7Eh40c5VYH6KBHvB0cKbl9HzuMcg/RD38XywinrN3sprK16yhEU+JD6nrbP81EhqN33wcNE3WdRN/AblI+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PacikRy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PacikRy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7C8C4CEE7;
	Wed, 30 Jul 2025 09:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868276;
	bh=iWjPBoHL27Ot6AKUZWnq9dknp3EP/IPd5eHQErVggLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PacikRy8bea5mzMSSLWtUg0cT0d18xGblf5rcjJ4XxFaYcy3o4Yb9npknq7qLDDyU
	 iYNjr2vP18LY8bebrh/fNzBI4fLeMjJFkJR9W8iHRomRs/BoSLks670b9kKAvKvpWH
	 c2h58bLUErvelz/n4Uqeju0tuCGZKwRrzcURZaSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/76] drm/bridge: ti-sn65dsi86: Remove extra semicolon in ti_sn_bridge_probe()
Date: Wed, 30 Jul 2025 11:35:15 +0200
Message-ID: <20250730093227.706523384@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 15a7ca747d9538c2ad8b0c81dd4c1261e0736c82 ]

As reported by the kernel test robot, a recent patch introduced an
unnecessary semicolon. Remove it.

Fixes: 55e8ff842051 ("drm/bridge: ti-sn65dsi86: Add HPD for DisplayPort connector type")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506301704.0SBj6ply-lkp@intel.com/
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250714130631.1.I1cfae3222e344a3b3c770d079ee6b6f7f3b5d636@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 002f8aaa509bc..59cbff209acd6 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -1352,7 +1352,7 @@ static int ti_sn_bridge_probe(struct auxiliary_device *adev,
 			regmap_update_bits(pdata->regmap, SN_HPD_DISABLE_REG,
 					   HPD_DISABLE, 0);
 		mutex_unlock(&pdata->comms_mutex);
-	};
+	}
 
 	drm_bridge_add(&pdata->bridge);
 
-- 
2.39.5



