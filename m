Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE3F15854F;
	Wed,  5 Feb 2025 14:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764231; cv=none; b=g0ngWxxYRId+J6P2PkWRsUfE9VNj0XKmRr+HYYFBEro0iSm9kuy2G5Stcfji6teqxdiWhNB9EBdzgiy4BpC62U/IeBQUst+oKiYvfrddGLn4649EBRxNyYimcUplrMSyL6cv+QjldbTxxhTTmAo7o8e3dTn1REjp/xuw3fLSgZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764231; c=relaxed/simple;
	bh=IC2nPK+jle/J71+PLYYoUadnj2jtU1Ux1te8OVamz6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKxMC1vnHpHvfFUdSDr6014jFYsmMMuU4c0aJ1x6tsaQxOXSdL1AXEF0IoVflhBbA66wYBfRorw/OR6fuSoKg9Oj0aXCmLM2SH/IjJYutasfP/XD7VpIOX0iOEWkbgKNyd9RgAOb/Jra4Hc2Z3VyObxnSdRUo5lbUuZtktmDk+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9J9yWwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9J9yWwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53999C4CED1;
	Wed,  5 Feb 2025 14:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764230;
	bh=IC2nPK+jle/J71+PLYYoUadnj2jtU1Ux1te8OVamz6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9J9yWwum0qZ5nq5x+UtxG0f9vsumzWr6gA0tHNHihN065CneMs6cgh1+9TTrBq7A
	 Qr4HeQi+cJ5VtJ5+4ZOxYhmcVzuDMlS+MMKu/LEJTnsjfT3b2e+kHUtcKbI/G7SA8W
	 HT729o0SQnPv1n+p+THx58kGG7t74fR+c6HS51aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Derek Foreman <derek.foreman@collabora.com>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 059/623] drm/rockchip: vop2: Setup delay cycle for Esmart2/3
Date: Wed,  5 Feb 2025 14:36:41 +0100
Message-ID: <20250205134458.484793209@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit c766998ba6df126ab6934d32ff2ff080316ec630 ]

Each layer needs to set the correct delay cycle to display properly
without unexpected offset on screen.

Fixes: 5a028e8f062f ("drm/rockchip: vop2: Add support for rk3588")
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Tested-by: Derek Foreman <derek.foreman@collabora.com>
Tested-by: Detlev Casanova <detlev.casanova@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20241214081719.3330518-5-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index cd3fb906d0089..68b5c438cdaba 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -2493,9 +2493,11 @@ static void vop2_setup_dly_for_windows(struct vop2 *vop2)
 			sdly |= FIELD_PREP(RK3568_SMART_DLY_NUM__ESMART1, dly);
 			break;
 		case ROCKCHIP_VOP2_SMART0:
+		case ROCKCHIP_VOP2_ESMART2:
 			sdly |= FIELD_PREP(RK3568_SMART_DLY_NUM__SMART0, dly);
 			break;
 		case ROCKCHIP_VOP2_SMART1:
+		case ROCKCHIP_VOP2_ESMART3:
 			sdly |= FIELD_PREP(RK3568_SMART_DLY_NUM__SMART1, dly);
 			break;
 		}
-- 
2.39.5



