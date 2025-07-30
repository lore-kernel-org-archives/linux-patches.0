Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7A82957B6;
	Wed, 30 Jul 2025 09:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868712; cv=none; b=TrNLeLs2ZnxAMwYbFSGiaRVXVoizXEJgBluomqNupypJso93/iA+912Zy34Xxhb24jsBZHjcKB62X9is/cVbdetEbz1udXv67h5YHWQ+ZUpYgDs/b6gyuid7NjIJE3bmCuQrwMG/0lXnNaMPoTNUiXu4XzzWRCDW8DMzgfM35gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868712; c=relaxed/simple;
	bh=ohusYJfAAvhBRw9a1FsHTRPQI0Pxn4mZN2S1tyAMGNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDyHUHUhq2+3LuAZ+b5trbLIHDvRy0Xt7bYbVtxn5Lgk+19dqBM1KrXesCE001wob2raJZA6QVMchLJ5+g+c2zHxRQ5IhIeH2aGSw0pRun5pOl022D2oLO+y1gF2bVO1AUwOhZ5/BA+fcvYwwV2uXhhn9hyMb1L+EmyQ6wxvFcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMcsAuSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMcsAuSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD94C4CEF5;
	Wed, 30 Jul 2025 09:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868712;
	bh=ohusYJfAAvhBRw9a1FsHTRPQI0Pxn4mZN2S1tyAMGNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMcsAuSowJv+iWXQ889wAJXGbAb5EFB5rZmUsFmv6j95zCBOMBz+grzaXEhOWeaKg
	 dbVi9DaQlKQa/ZKWLmUS0dqaipz9LAzpF6U17PPb4oKm/3rgU97A6vtnlDHxYw1tdw
	 0r7KKxEtMQNy5LOiAGdN70vm5sJBf7WmhV9mGpZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/117] drm/bridge: ti-sn65dsi86: Remove extra semicolon in ti_sn_bridge_probe()
Date: Wed, 30 Jul 2025 11:35:00 +0200
Message-ID: <20250730093234.773862388@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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
index 5500767cda7e4..4d17d1e1c38b4 100644
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



