Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABB3318ED6;
	Tue, 21 Jul 2026 20:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665592; cv=none; b=GKlBLxhQVMBVY1DkQSu+21Y27naa5HM9lgF/1xJdySaiF7PliVeR9OC4X61iZvqA7MvIr3y3xi2O5QEkSxj6ROZflHCTrIS45RvMTNW/J/NJX28Q5Ybso162vu/cyVorb/3JRjVeqaATu+WCUqNpJH0Wj6fabRlHUP4jzreJa+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665592; c=relaxed/simple;
	bh=ToLFnXBUoXgqzLxDGgu3yVJVE1/SNrFV0ZbP4ak2qMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAwkR09PST2CsDdfhezFAcyMvuJ2DNzOQ/gMY6GsVBYGTY4QFQ6V1TMxga/lJjovml/QbJIhC3IFkNE8xoHSUw8xyrRwDVierdaI3QTRibwBRDWAYl9xKlxTxaRzfHrzG+WFAlHtHiJXBJ3i6dAAZBGOwcuQ6vm2mhBbKuBof2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLeYnZy5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLeYnZy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C23F1F000E9;
	Tue, 21 Jul 2026 20:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665591;
	bh=9aYnGxp52ZdVdyr6BnV9X+rFo+JYrlxWzxJDM1DJNqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLeYnZy5ZpWV4MfPMavMR9njjm5PqxfYFVL7NkxniAz+uK4CoOZQZSPLv2uGH3szM
	 PzyazJQJVSf9o6TOiT7/MDLS6rzJlGkyhvVtpAYjb3RqtMNzYW+gySYc0wXYGFq4wc
	 sSEh6p9v4rN3n7gfx2vA5/+hejNODG5jfLaFkSjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0360/1266] drm/tidss: Drop extra drm_mode_config_reset() call
Date: Tue, 21 Jul 2026 17:13:17 +0200
Message-ID: <20260721152449.883532006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit f468fef38716f667e805e0fa2c497c6b9c325bb9 ]

We are calling drm_mode_config_reset() twice at probe time. There's no
reason for this and the second call can be removed, reducing work at
probe time slightly.

Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20260311-tidss-minor-fixes-v2-1-cb4479784458@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_kms.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_kms.c b/drivers/gpu/drm/tidss/tidss_kms.c
index d096d8d2bc8f84..3b8133be544ebf 100644
--- a/drivers/gpu/drm/tidss/tidss_kms.c
+++ b/drivers/gpu/drm/tidss/tidss_kms.c
@@ -268,8 +268,6 @@ int tidss_modeset_init(struct tidss_device *tidss)
 	if (ret)
 		return ret;
 
-	drm_mode_config_reset(ddev);
-
 	dev_dbg(tidss->dev, "%s done\n", __func__);
 
 	return 0;
-- 
2.53.0



