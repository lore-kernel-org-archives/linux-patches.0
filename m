Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0827C4418EC;
	Thu, 30 Jul 2026 14:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422377; cv=none; b=FQuJ/Buhp2iqjd/diacovAEAwqkMWTGobPUSGXBzPv1Xf3B3wHw9003bbmB5rXiyMqj6xxjmK5ueF+CfaQdHZ6n7iO/ytagwBPjgNkYTwmyW3dz2hG/ecrrr1a6BygpNcb5mKh7cCdpBBlN1g+D7rkQR9qK4zWNtVE159ZWIPW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422377; c=relaxed/simple;
	bh=RXDxUlSIt8gB4yTazGcFnGS05djC57rwvPNGqkSFu3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXL7jnL39jfRBhJjXu90AzrIJp+TnRMmAkMpZVkrByMmxnvISM5y7FtQU93hS4I+Ige5pi2etVuObKm8WPaIpNJu1s05/dl5gWNRKzses0IP8E2gGDiVLx8RKmoF6jsa8t5JBbIrmz89PHzjSsrJQn0M7P1WzndIjqk7Esxvv30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weCuXpY/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weCuXpY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563B41F000E9;
	Thu, 30 Jul 2026 14:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422374;
	bh=o47eesJPikzg01pDoKv1wQpldjbKbQc5fD0vlZ0tz5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=weCuXpY/JHanb3Hs84GDlJfH2jfELa8GRRw2peuUh9rgwZzoFPX//HQwo9k1Q5Xmh
	 ZjAcqZxLLEekYL7bAI7gL/8DQ+O/v2PUUixb4VWK7K0EBa+AoTULWPwMExoQF/ivvg
	 hj7rfhSOoeVW0EawDino8BMbFyqPc4oA+NU+bDWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Chaoyi Chen <chaoyi.chen@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 7.1 362/744] drm/rockchip: cdn-dp: add missing check in cdn_dp_config_video()
Date: Thu, 30 Jul 2026 16:10:35 +0200
Message-ID: <20260730141451.980554093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -685,6 +685,8 @@ int cdn_dp_config_video(struct cdn_dp_de
 	val = div_u64(8 * (symbol + 1), bit_per_pix) - val;
 	val += 2;
 	ret = cdn_dp_reg_write(dp, DP_VC_TABLE(15), val);
+	if (ret)
+		goto err_config_video;
 
 	switch (video->color_depth) {
 	case 6:


