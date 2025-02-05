Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74477FC0B;
	Wed,  5 Feb 2025 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763724; cv=none; b=FlGgMSW8O0mA6zUmXH/o09cvTFoxzdq6QIYUB7LvVK4fgEN3aeQ95E0ee6B1GeZln3JVs/eD6HayEmG1nLFgacb4391XP+wLRi0U+ozX5vPOvBVXxDN29Ick9TkidSezodK6WrdIFIi3vHuIEKTemzHCXt1Km4Pi3NZKxBEmdVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763724; c=relaxed/simple;
	bh=eO1faI50EkKfCIJecrCmdEltzA8oBU5/4mKzgHz7xLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGzdD83oomYr7OqoHz4s3wV8pJcfFJLnUsr8rTeZIExIOLgOIbFXrXZ3yRrBglNCv0Qh+zpVTZDDl5Ttez0g8i8oEJsO7X27D/2sY3gK3GfxLGZAsx3s2mg4jDRFSGXZpoTZxCofzIV1ZrLhKa6Nw6K3DxUQlblEp3xwfPbMIOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgKXbcS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgKXbcS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFDFC4CED1;
	Wed,  5 Feb 2025 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763724;
	bh=eO1faI50EkKfCIJecrCmdEltzA8oBU5/4mKzgHz7xLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgKXbcS3mfaxHAuTPMePEw6tab4PArINoMgib6RscPKdqS7oPIUlr01CIs4WM3/Gv
	 uROSDnfIcwlK8LkrFA39fTFbRPU+Yzb5K0iL/hBCTcn+No5Hwh9Yiygw4WxAENTmU6
	 Y1qpOsLFbsgUBNQKCQNSXGqs5yrnQWCwip4eUDjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Derek Foreman <derek.foreman@collabora.com>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/590] drm/rockchip: vop2: Setup delay cycle for Esmart2/3
Date: Wed,  5 Feb 2025 14:36:46 +0100
Message-ID: <20250205134457.208685895@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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



