Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061876;
	b=5CouAGiHG5hehOIKaORNOvjFY4Df77ax97ACXWnKmCyOKH0WUnqLwJQ0zUKqe4N6HWnS
	 WTygLRvY2btyCLfeTgIXKWavbMkmKJc3hJnWu4S66GhY2YFM0yQH/L5MzkrYe32INUQ6u
	 7DpwR31RSwPavaqOr20SH3tUu/sGmCfBj8xGkvgqVee6TfY2LKA0GYb95IIEV4Dli/gFw
	 /krM2RgFSE2+Wo33Kqen6xzw+UFSp1dsIew1WXYih3VL+3TSZmQ2MR4zom932DduzzLzS
	 W7DcB3eqUIC9hCV7kbUz4ditEnGVJz/KvyNgVVpb5ITpkP5w783uzeQ7F7oZslqnoFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=02Z1VKoYDuPrFqkQmydKPvRvDJQe9JJe9huckTmck0Y=;
	b=KrxLV+HIdwtV9eYy2rMHr95V/T8GEICyZpJMzaFqkhFR816ARv45B/qCsHSgqeJ7GAlM
	 iJNVZ98ykH7EecOb2HOZhWql+A6WnSjLHfp1CJ9hs/V3P3PZ1sGIVH0FWcpZNpfs5dCP2
	 fmEy1lAK5+F0TLnwiiTQFRo4awK2IWOPRojlni+v1RYejz1E4BlfQRXN2SeuwZ6OkLFmD
	 jEQiwDbNWo/iBxspV3sm11Sb3abxeT37bTWBRJJujVdND7If5QKLE5/wItGbW3fcvR7SQ
	 /eWKR2+A/aHqqt67uYLux91JAGeFL7genZ1GVG6T7jXV69MNQGxAP1hALICNARq20/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lB4V3lSs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDE1606A331;
	Sat,  7 Nov 2026 14:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lB4V3lSs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF03C1F0089F;
	Sat,  7 Nov 2026 14:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061875;
	bh=02Z1VKoYDuPrFqkQmydKPvRvDJQe9JJe9huckTmck0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lB4V3lSstJO/aptQJpKgRE4utHfGW+7K4pqKoSyweuXUI6FGU8DPz3jAyhq47OLmC
	 ZzPwbIvIKML26iRPOyAH4cYmLNcr1DnVWRbC8UiQiaF3f5Bkz6z1jguCXfzw4THdm0
	 anYJc8AjEYoNrjMmxHZI9HojRhoGC7coiG4udKbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0889/1536] drm/nouveau: cancel the DP IRQ work before freeing the connector
Date: Sat,  7 Nov 2026 08:48:25 -0500
Message-ID: <20261107135022.594992147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Czernohous <marek@czernohous.de>

[ Upstream commit f60849975a886d70883bcb6b3658c0fa83c6971f ]

nouveau_connector_destroy() tears the two nvif events down and then
frees the connector, but never cancels the work the IRQ event queues:

	nvif_event_dtor(&nv_connector->irq);
	nvif_event_dtor(&nv_connector->hpd);
	kfree(nv_connector->edid);
	...
	kfree(connector);

nouveau_connector_irq() queues that work unconditionally:

	schedule_work(&nv_connector->irq_work);
	return NVIF_EVENT_KEEP;

A DP IRQ arriving just before nvif_event_dtor() therefore leaves
nv_connector->irq_work on the system queue past the kfree(). When it
runs, nouveau_dp_irq() derives both nv_connector and connector from the
work_struct and dereferences them, and goes on to take
outp->dp.hpd_irq_lock.

There is no cancel_work_sync() for irq_work anywhere in the driver, so
nothing else covers this. Add it after the event teardown, where no
further work can be queued, and before anything is freed.

Reported by the Sashiko review bot as a pre-existing issue, in its review
of an earlier nv04 FIFO series of mine, and confirmed against the source.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260812231330.705425-1-mczernohous@gmail.com?part=1
Fixes: 773eb04d14a1 ("drm/nouveau/disp: expose conn event class")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Marek Czernohous <marek@czernohous.de>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/178682366002.3748010.4096452389040554615@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index ea666d4f668d9..6f90b73d79ae4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -397,6 +397,7 @@ nouveau_connector_destroy(struct drm_connector *connector)
 	struct nouveau_connector *nv_connector = nouveau_connector(connector);
 	nvif_event_dtor(&nv_connector->irq);
 	nvif_event_dtor(&nv_connector->hpd);
+	cancel_work_sync(&nv_connector->irq_work);
 	kfree(nv_connector->edid);
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
-- 
2.53.0



