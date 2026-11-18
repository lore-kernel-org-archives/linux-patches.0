Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016651;
	b=gOn3N6+RJbuLSi0TMsAnp+5TtvSWfd7SRH1R6Oc7IHUHwgeur10Ev4hHJDlgmmN7DK0c
	 s1oVkeZHrRE/Rh7AdUb8M+YJxWAzToTPJCYhB/lu0ov9XPP+AKlABea8fueRJxvYhdo5c
	 ZnHZipwzGFPpSrm9hM+wf7lWIbeUgJIopTTQiU7CrfxV0ftiBbZ3YtJ+Z28+CdoK9FKIa
	 YerYoEBHz5bb/kdKFTg+6dPU9VQHfccULl/47QTMqao7rZpc8+AYFmCjeFCnXJmKko00S
	 n7DCvMHYxWSiNS/AY4cUGLVZRbb+cazGzba1txv3Drk0MGR0MdY8Bb2Rj58dkiP5IFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ho3O0zkPXCI5l1ieHOKewxqo1wU6jq3lXqMIvSCUffY=;
	b=CwCDsCYP2H5obm1kG/xsr9uYdarlw3jkyBKbnjNAmiXSFc+iI6RsAL4kHWYhICIymFof
	 +hvP96Ycrx13+DxDJfOcL7CiLZwiGyc6N3uG6UkC6d1t145L69n2Lf61JmH22EgB0iXmt
	 Wm2NOwhgw6igDoNLePwlxGr9qRfayxjhwW6bWCYHdi/Xh4FCyHRWeMIvYbu62qU7Hqbc4
	 WswJNUHHtPh8LK/6RWQDFTL6fZq3WihFiL/u/J0o5nJcedubNEaBaaFYUngxDodI5q5pH
	 TyJOhz/xNGr4hDRKcYSmuOL4seXuYTDS41jbpUsZjCh6sO5kbn2lm3sWNpbaefVSqpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wiHqaQV3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6701D606A325;
	Wed, 18 Nov 2026 15:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wiHqaQV3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26341F000C4;
	Wed, 18 Nov 2026 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016651;
	bh=Ho3O0zkPXCI5l1ieHOKewxqo1wU6jq3lXqMIvSCUffY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wiHqaQV3Qk2YKCNKyyyxdF3J32XnFGi2/NMu+wibmdNEBBbSjKS0LvulYPI14v845
	 vld3de7go1RMX8n8FpHCo3jJZnON4iPEGgOOqb4c4OpGpbkqpAq/8UcwSwla5Sh/ZN
	 gD7qiKfrrHN13cQ60n1q7Fb+kySo+ZG8Q04WrS0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Maxime Ripard <mripard@kernel.org>,
	=?UTF-8?q?Robin=20R=C3=A4ber?= <robin.raebi@gmail.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 7.3 0602/2651] drm/connector: hdmi: Handle reset() state allocation failure
Date: Wed, 18 Nov 2026 15:30:42 +0100
Message-ID: <20261118150309.396061750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 54acd0c74eba2a2c9a726856f5fdc6f9e74ea2e1 ]

In drmm_connector_hdmi_init(), if the reset callback fails to allocate
memory, e.g. inside drm_atomic_helper_connector_reset(),
connector->state will remain NULL.  This is unconditionally passed to
drm_connector_attach_max_bpc_property(), leading to a NULL pointer
dereference.

Bail out with -ENOMEM if the reset callback leaves connector->state
unset.

Fixes: aadb3e16b8f3 ("drm/connector: hdmi: Add output BPC to the connector state")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260723015306.C94241F000E9@smtp.kernel.org/
Link: https://lore.kernel.org/all/20260723015306.C94241F000E9@smtp.kernel.org/
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Tested-by: Igor Paunovic <royalnet026@gmail.com> # RK3588 Orange Pi 5 Plus, dual HDMI
Tested-by: Robin Räber <robin.raebi@gmail.com>
Link: https://patch.msgid.link/20260901-dw-hdmi-qp-scramb-v11-2-bc12954a0688@collabora.com
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_connector.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 8b4baed060f3a..0e39431e85b20 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -628,6 +628,8 @@ int drmm_connector_hdmi_init(struct drm_device *dev,
 		connector->state = state;
 	} else if (connector->funcs->reset) {
 		connector->funcs->reset(connector);
+		if (!connector->state)
+			return -ENOMEM;
 	}
 
 	drm_connector_attach_max_bpc_property(connector, 8, max_bpc);
-- 
2.53.0



