Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ECF30567C;
	Thu, 30 Jul 2026 15:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425963; cv=none; b=aGrZMNNPCqXvef9ElCdq6sh79iiV6px3mOit7HldKk0XFnMKqF+ss5fO8FiS2LFeK07V8qxsXFVRTx6aEpvP18pGw8Q5kEMaNFd9Nf8JQvJVLr4MgevoKcDMUwvpA3enUbVPK9mt2E5JYnBlnrzkhTKqGa38C8S5I/23rt2SKAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425963; c=relaxed/simple;
	bh=QvJn/mpFdwnfqkYhGzqe/op/dfLa/sIeBeXHmUtWjRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwSVCwA8+opoTw583f730BNbE8nCUBhJj7RL0T3blv/8tvxq96yt0w7j2TV05kWwWz0zVB2MQqmNpq1slmQyR9WdvJBNrdSCwsJge6gKBESoll/HFYRlwf1ys9tQ888ie52+n0kS0m5NhEeAZ7iy095CAGDW1kKnt2mOyBeJfZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GadkqPOW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GadkqPOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360341F000E9;
	Thu, 30 Jul 2026 15:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425960;
	bh=XFO5mZuMlWZucjMFGinaIW2adzQ7W23d2Bq4NBFpX1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GadkqPOWQQZiiYQp0d6UYn6O7WL9U2Zje0kOO3hEP5p2ddbLW6ezplowwHGVoa9yJ
	 u1OvE65nlnSr364Qj9dQKNvPA1XLLtLx1VBwQTW087v+Ue+jCfVxODzypeyyIbEHz2
	 R1DcoAjmCy4mIk6K7x52Rn5OkdIKuwYb0TLotabQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Chaoyi Chen <chaoyi.chen@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 252/602] drm/rockchip: cdn-dp: add missing check in cdn_dp_config_video()
Date: Thu, 30 Jul 2026 16:10:44 +0200
Message-ID: <20260730141441.266633926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


