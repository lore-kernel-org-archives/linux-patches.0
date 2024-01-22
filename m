Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3706280A;
	Tue, 23 Jan 2024 00:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971139; cv=none; b=EnMFHCa+O33/wDVbAPEIo5QC0ZQTVhGRhLQ29D7JFX3d8/EoWsjCJ5x38O6Bn8O3Jtsl3U3MjPxnV2EMWi4Z3IgBQ/Sjkp2qDsMXbZTVdcP6Jc2LQNO+8oqFyK6VCChg1dUcuw5tmj5kSvdNxI8HijZZa95ajuL5WrPc/3t5XpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971139; c=relaxed/simple;
	bh=3dtQpsyoN6XXyp15C61A3Mt1ee9qdX/lcaVlwyXLJbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Stx7BDJil1BHbMJPEDFMbkL8NJnazt+eIJVAkWDRO+aeGge21hLn1uRCSUrLPY8YehhMErOaAEf7p5cxbT4zlxUneoe9VA8PCsU54cjAYCA3aGJHcADCKT4aHSvL4Sc89pFozqcc1WuIUYjOSpeedOJwoNqmnlKNdwHXYxCJcFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=en+xl5a9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="en+xl5a9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9F6C433F1;
	Tue, 23 Jan 2024 00:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971139;
	bh=3dtQpsyoN6XXyp15C61A3Mt1ee9qdX/lcaVlwyXLJbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=en+xl5a9fIBtukh9lWz+jvjrq8DOzTWj39hUfMbqHXxYwn+uL7wyNImv3f6nUG0oS
	 BO+DY2dzCrnwQ6ckiEa8L7WB64J5Y45gLEohDz+jOs3/L4BDvuuptnhE0PDS9Bcrzw
	 9PNkQUZdkF9u8ZMYfK+ZcZ6jjGwE+vAmdVENLaNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/417] drm/bridge: cdns-mhdp8546: Fix use of uninitialized variable
Date: Mon, 22 Jan 2024 15:55:57 -0800
Message-ID: <20240122235758.457044038@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 155d6fb61270dd297f128731cd155080deee8f3a ]

'ret' could be uninitialized at the end of the function, although it's
not clear if that can happen in practice.

Fixes: 6a3608eae6d3 ("drm: bridge: cdns-mhdp8546: Enable HDCP")
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103-uninit-fixes-v2-3-c22b2444f5f5@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c
index 946212a95598..5e3b8edcf794 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c
@@ -403,7 +403,8 @@ static int _cdns_mhdp_hdcp_disable(struct cdns_mhdp_device *mhdp)
 
 static int _cdns_mhdp_hdcp_enable(struct cdns_mhdp_device *mhdp, u8 content_type)
 {
-	int ret, tries = 3;
+	int ret = -EINVAL;
+	int tries = 3;
 	u32 i;
 
 	for (i = 0; i < tries; i++) {
-- 
2.43.0



