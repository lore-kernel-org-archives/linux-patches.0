Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA0F451997;
	Thu, 30 Jul 2026 16:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427539; cv=none; b=YOzlerGrBRznf6YIL7Fy1irh+68O0QsKnleHafSx/UH6T6ZUZ383Kws2TSP9TyoaKmpLWBnf+wxvHX3E5RotAbS4YbAWzPw6zSek1wZn+fc/EEo9WWCrmlwImwq8WYQci7ZzbdTtWUjiQGofbejXl8+pYupQYmTw3KYQbXhmSso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427539; c=relaxed/simple;
	bh=zlyxduETO4fk+jXAs+1E1z6kULk3b7pyO2FGFhVfpvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbyjJCgq7vqB00afWlbFJ85e1E2ee4JGy5rApGrFGIW+bWwV7WST1QSp97HwEQUGQsNKd2LDN/R3nInMjmDeJHLaUY/JJhsLacFlVV0uaP1x2NraStNnPxgmJV/teCadYFNaItXsXOGLR8JmccspspvIO/fkKNE4wL7gOuDi2KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hy/J9dKj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hy/J9dKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ABB1F000E9;
	Thu, 30 Jul 2026 16:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427536;
	bh=5AdJ4zdN/MJ4Bac56YHW0T8xiVEh0XJC79ozZOV7kKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hy/J9dKjpb5ojz/la7AIz7VZvCx3lkJ+rJliNN3Lu5uZMZUUH9ct3e7XM8Dmi69iB
	 eoDuXSxzjPwOaJs05cbH3cJOlX9Ju2O1ugCFqxUfnLLjPqfXVWNmBNcuS9lb170cJD
	 Na5FSqU5nUeSmixbJJjER1j+R3kKp0o+GplrQxs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Chaoyi Chen <chaoyi.chen@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 205/484] drm/rockchip: cdn-dp: add missing check in cdn_dp_config_video()
Date: Thu, 30 Jul 2026 16:11:42 +0200
Message-ID: <20260730141427.922709020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


