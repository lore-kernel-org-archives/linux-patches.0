Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CD544236F;
	Mon, 17 Aug 2026 14:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976950; cv=none; b=glZDBe6Uoqa3oofWPiKDGBiaRKjoJDqeeYMyBxXKeR9kl2xwsS7fi/WoJKiYKxSJTGbikIIz5nm/hUzjV3YsThQ3FmGsMYjJEeDUGu1xxASfSsw2lfDLbH1806GShOI3P4tAbnCZ2E7N/Lo6UKpS74/pAJ9V3N00qGyFgYeasUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976950; c=relaxed/simple;
	bh=aibMQse8/5FbSsLuMJF9FnCHNDaidCTMagaZ9OFCZD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzgdSNHdGV3CPammnPbiQ3ivvczyFIY6I7ZZ3vyYboQgN5NnRodlJ8rla8+gmsn6RQVF83fQyu3WHS2HA4GtdhX8ik0DCAVscs7JNAZpMKdnFJCx0ldz8oMqpsfJdMUzNh57AV/Qli+S11ge1ysdIlecMM1QX6Mzg/uEQ+CjoUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wVYtqP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wVYtqP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163501F000E9;
	Mon, 17 Aug 2026 14:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976948;
	bh=vcMF3/eylqBleBsm8bMmnQweGK3D0SHufMDScdCBRm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0wVYtqP1/5kiYQdxI1sjQCCnYZQz5lAjFIm0tJDsBW9hT6figO96gwVMO3ugt4T1S
	 QhJzQ3j4s3uQ7S7og/Hx/1wm/k9AxxZgPnu7+qmDiUxqMyn7EVttEIN2GnfjWTNupX
	 a/UwlSgxZyVLGeehPBYosugLlhDEEHhxyDSZ9fXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Chaoyi Chen <chaoyi.chen@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.15 143/456] drm/rockchip: cdn-dp: add missing check in cdn_dp_config_video()
Date: Mon, 17 Aug 2026 15:28:53 +0200
Message-ID: <20260817132545.676537493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


