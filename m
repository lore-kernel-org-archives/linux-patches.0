Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9A83F1AD5;
	Mon, 17 Aug 2026 14:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975652; cv=none; b=TT7yfsuOrGjL+4uW5kCm/kv/vjzJ5frZfeBQ1NIgj1n8rOWq6BmTHOUiGZ2gKfIlajsVEbBDYjc0iRIB5Dz+/swcmdTTnKygpb3vZZgkCEYAK4FFFLzM8+Gcu+8qQb5aJui4cOE+33DySx5obJ/D+R6YrnCOtNMW3x5vB4RcScc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975652; c=relaxed/simple;
	bh=hbVqAquUjC343y5HdbbiU28kFReVZnnl9Io3EhDtefs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Flsh5HiVmw2h++1Z2Z22uXHRj91KqqtxaTSGEXmJw0va65+wmajCGpA+cfSpBMfF5Wxvbx9+xCN1IZuw2vXPYtmvZqWiP9LeWut4tKoHXFBGLtjD1Xn4m8X98dZIOKeaTqr/6w1BYMIVTBTGsxu0O9ob15cs6uC9SnRhHwLAT38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCSlwqHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCSlwqHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9D21F000E9;
	Mon, 17 Aug 2026 14:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975650;
	bh=o3oITmJAGVmtIhM8wq6hNbX+C4biDUu/Ybcvh+ncI2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCSlwqHd7FVnFv/22GEzBeE/5sn3UBHpAqUAyiTdCIWhjLZxF5A6mCYViDRAFqWim
	 AeQygJGV0kg3MLZyBdT/iLivUa06on1MhEo50oS1VZLdYwYEyglvZhU5S8WdAmlEW7
	 3IrNEnJ2tANbyAEgHBBj99IzV8cBrtYV/Q80f+Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Chaoyi Chen <chaoyi.chen@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.10 100/389] drm/rockchip: cdn-dp: add missing check in cdn_dp_config_video()
Date: Mon, 17 Aug 2026 15:28:59 +0200
Message-ID: <20260817132543.027354351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@auroraos.dev>

commit 46c31e1604d121221167cb09380de8c7d53290b9 upstream.

The result of cdn_dp_reg_write() is checked everywhere (with the error
being logged by the callers) except one place in cdn_dp_config_video().
Add the missing result check, bailing out early on error...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: 1a0f7ed3abe2 ("drm/rockchip: cdn-dp: add cdn DP support for rk3399")
Signed-off-by: Sergey Shtylyov <s.shtylyov@auroraos.dev>
Cc: stable@vger.kernel.org
Reviewed-by: Chaoyi Chen <chaoyi.chen@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/adf6b313-f7db-4d8f-9000-8c65446ba041@auroraos.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/cdn-dp-reg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/rockchip/cdn-dp-reg.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-reg.c
@@ -683,6 +683,8 @@ int cdn_dp_config_video(struct cdn_dp_de
 	val = div_u64(8 * (symbol + 1), bit_per_pix) - val;
 	val += 2;
 	ret = cdn_dp_reg_write(dp, DP_VC_TABLE(15), val);
+	if (ret)
+		goto err_config_video;
 
 	switch (video->color_depth) {
 	case 6:


