Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7341DE4EF;
	Sat, 12 Sep 2026 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222323; cv=none; b=Lr07hrH5f6sy18vChzwX4j0oW/djLMsMECBe4EtAwIAqyo06HFliIlF9GPACxYR9B4FTeiyOoBN65xB8ID7CmRJ0eOozI1EHF+1mHwl5GPlNk9paHyxXvZ/AaENHGw7Fuu7Nq9XDBPXlexMt7trVvmbjSgX6VgLPx1dDiGuGhw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222323; c=relaxed/simple;
	bh=wVDe5e9EAHvLfAbWXzVx6XLXeSLPlOZKuix69S3SHEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nw/IdNOw6kv0BzVbR76BaTROsgl82zv5IQpd9IJnEEKv9EUaABkYOA3vye9NSCTadyzimTv+wFbkr5DLc0kP3FSk59LwH+gmL/COZadzg5CIEqGbGD5Dn0xVywWGps8T0wFjuptp1zMbhRZKwWXcIMUtrHeKjS3QK31xatQm1HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLRDzTTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLRDzTTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4A41F000FF;
	Sat, 12 Sep 2026 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222322;
	bh=FeuaaE51MdAXvNbCbvJVj167xdj0KoPVnfdsmXQ1gCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLRDzTTZX2sgQiyFP9jS1NW0mY3WiOz/m2viBULBVxnJo9p5524GY5DI6gDft30jd
	 gnk2FUAcAFSUdTPcuN9qy5VzPLYBbsFliHvU0LLeBq83Fsh9b/nEuEpQJWbzaMOqXh
	 TKh0DDQSgb1tMMsAhT1z3BL7Z4La+7BKMwq496f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Daniel Stone <daniel@fooishbar.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Daniel Stone <daniels@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0563/1424] drm/rockchip: vop2: Recognise 10-bit YUV422 as YUV format
Date: Sat, 12 Sep 2026 08:49:55 +0200
Message-ID: <20260912065619.914157847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit c1bfe8dac0a79d47eed313b9bcaa2658898684ec ]

The Rockchip VOP2 video output driver has a "is_yuv_output" function,
which returns true when a given bus format is a YUV format, and false
otherwise.

This switch statement is lacking the bus format used for YUV422 10-bit.

Add the two component orderings of the YUV422 10-bit bus formats to the
switch statement.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Daniel Stone <daniel@fooishbar.org>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://patch.msgid.link/20260609-color-format-v17-13-35739b5782cc@collabora.com
Signed-off-by: Daniel Stone <daniels@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 97486eba01b7b..bd5bce9d8c2cf 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -425,6 +425,8 @@ static bool is_yuv_output(u32 bus_format)
 	switch (bus_format) {
 	case MEDIA_BUS_FMT_YUV8_1X24:
 	case MEDIA_BUS_FMT_YUV10_1X30:
+	case MEDIA_BUS_FMT_YUYV10_1X20:
+	case MEDIA_BUS_FMT_UYVY10_1X20:
 	case MEDIA_BUS_FMT_UYYVYY8_0_5X24:
 	case MEDIA_BUS_FMT_UYYVYY10_0_5X30:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
-- 
2.53.0



