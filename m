Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FDD28727F;
	Wed, 30 Jul 2025 09:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869228; cv=none; b=OZdmNqaa6IFyXDAVMsd65y5ag8FUkj9R9ApqWbwf5vfQjq98KdQF/w5bJnVPUpdLiiZMBTMRAYmfCZy/USH0Pam5hg8Z1dkX6hVLqDnPjKSG4aQ2EPQA44q7HGtpajI7gqPxClx+Yf9bWZb7bbBrYAFCzyns5yVIChSGnserLu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869228; c=relaxed/simple;
	bh=ILzrtlGsMXLbaqMvdtidNCSQOVvvJ+bXiFCOZczwVIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nc90aGz4NRmb9kIdGviRA+CY2GvakBv5w76LLeg7qzFJVweN6lfPBfZz3VkO7O04z70qmgyPDLEjvH2xyEySLe7WLhHl8O2SYs+LNg93qdW3RHGYhwa0gOn31zRdKVVCN4poYq8ebEP0HWmuuJmVMQSykyclEXZncVRMudL/oaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usyaNAUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usyaNAUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A01C4CEF5;
	Wed, 30 Jul 2025 09:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869228;
	bh=ILzrtlGsMXLbaqMvdtidNCSQOVvvJ+bXiFCOZczwVIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usyaNAUF9FVKRTt+/7345zTxIGf2v5gtiQBWf4hUn2B+M70jGFCkbU0bW/ZruFGMS
	 /5vNdgaBWHR/fszKLqzuwvdiG0trlFJa8PgUIWXegExfud1KfBx2Gs0gRRCln1B1wn
	 pPMc2Ge1OJqUg3ke50/4kuHy7PoEcMS5b4hsZ54w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 35/92] drm/bridge: ti-sn65dsi86: Remove extra semicolon in ti_sn_bridge_probe()
Date: Wed, 30 Jul 2025 11:35:43 +0200
Message-ID: <20250730093232.113688303@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4ea13e5a3a54a..48766b6abd29a 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -1351,7 +1351,7 @@ static int ti_sn_bridge_probe(struct auxiliary_device *adev,
 			regmap_update_bits(pdata->regmap, SN_HPD_DISABLE_REG,
 					   HPD_DISABLE, 0);
 		mutex_unlock(&pdata->comms_mutex);
-	};
+	}
 
 	drm_bridge_add(&pdata->bridge);
 
-- 
2.39.5



