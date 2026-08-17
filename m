Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715073DB323;
	Mon, 17 Aug 2026 15:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979271; cv=none; b=pMzKYlW5dJRZIo6njXxXq6ZWXlItmp3TmnWwBKGTr4dti8IWZ5TfRkZ5pToQBNm1PJhOwyVsMtL2Umg85Po94weRhdbCxqoyNME99Ee09i5hFQsxch0MeXIB3iFuGgBwtD4MXWLBI1S5WVU3efubl+lpFLAiqnpSdE52Om3OipI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979271; c=relaxed/simple;
	bh=SGtv9QFg7wri3ae7MxxUxffwdfUFb06o4XFXB9lrZTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5Qz3yJPo/8CZTS7UVCOG2j9xHL0G4PlWpIJOFmYJxgemX2SqGkvgM8EDUAd53DvRKzlt1Jqemmv3/MCjLVw+yGKCxBvYtgLwZAbDl5CRMGu4JeoO7Tu6VW/ClbohI/AcjH/7aRKBkwTKvrWsUggsMnJB16x6aBR7cskkc3lsKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sf+ch2bY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sf+ch2bY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BA51F000E9;
	Mon, 17 Aug 2026 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979269;
	bh=+jSsaHluo3hDFxQEaRbtaAqSTX4bqWapkXYLg8YB+6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sf+ch2bYF+TJ9yHnxbkhCS0BW8lV8WK4t2uBTlVVR1V1oGoHk58V1vaLST7PFmQPV
	 Ekot/c9ORA+LW8en2fP8/fY59B2ufYsmLgea0GlFS/2ltUwN7hnL/yQqU5r01Aqu4F
	 otkedUoK4YA6N15GN4CKdIiMe682Uu/+3AeA0HFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Chaoyi Chen <chaoyi.chen@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.1 168/609] drm/rockchip: cdn-dp: add missing check in cdn_dp_config_video()
Date: Mon, 17 Aug 2026 15:27:44 +0200
Message-ID: <20260817132549.650831440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


