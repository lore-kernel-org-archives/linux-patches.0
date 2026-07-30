Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98818379988;
	Thu, 30 Jul 2026 15:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424229; cv=none; b=ErYB/dL7pu2cXGIIFbiehbFiE2xjIFxsxkTX5SovP4QHG9a3WidquQTNOwS0Z/5+xKIQ/0+ILwuGTF4qceajXyPa8Vb/wm+/K6JSr2en9u/SfM0QvkSxD4h/9O/cw82yIALEJE4koi9xTHtLvWP4Qf9Gr9mW3V8ZHp5DSyXgn3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424229; c=relaxed/simple;
	bh=uEt+P1TTJw8lsqMHqivXgJNFuZvryPlHDmX+7kQWMxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nft8WCjrtPtmXJ6fT7k5pk1G638BeF6S6uw1zcqxNIqZhGboY+8r5ZpblOYj57T1IWwV9KbTrut4yWL3lrYxdyw40QW25UKMUtOZo9wre+vWTxUVSh3nh5OZ4+BV41AcYU6TyMCTQu6FVU0JpVEk8La7TIpicGM3EqzEjO3YA/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTAIFTSa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTAIFTSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6141F000E9;
	Thu, 30 Jul 2026 15:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424227;
	bh=Ztt3cvuqdXKNxCYmTb9lHlf5l2w7SZLCKNMtoa5sZSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTAIFTSakLZnFqcYCE9ERiw6M94C+F0r8Fa4mhSJHNcunYmCbBVBlhuERBVXv1+oe
	 aYO7rpYbr2GSZ7AdkLXX7Ug1h/zxu08i4S6e99hiQelUdF7t+NBk8/aH4B4w7qaACR
	 B29eM2YaHbnjcmB+3/o5+wXIbAbI/LRFHn+whviQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Chaoyi Chen <chaoyi.chen@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 321/675] drm/rockchip: cdn-dp: add missing check in cdn_dp_config_video()
Date: Thu, 30 Jul 2026 16:10:51 +0200
Message-ID: <20260730141451.947930328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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


