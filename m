Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063797;
	b=T1709O5tfNicp/amBlUKnNeZhnk/lqID1liy4Johjpj5kRSX1gYMtWb6yJUfOjIMq70q
	 rkYLCE65Sy0GsM5lpHW6P5XZP/8BQObPMKLFspjf/vPd2ncJYBUYkHU0PEcVrdnyTyYfu
	 qvXc7SHZisQcmJhnBhEHy4w8VFvOVgdOB3CLMkjICA0Xsu0cnq+2gNxcYFAI0/J7r+Uj6
	 0fYwEdfIo1EYfvZdr4CJCGje4FwZ2N281HasHQ5s6Ip9BqWb4bQNEwirLHR7KVjqPDvON
	 jDftQkcrts9Jw4Gh/CaKxR9qrHD2EGZeiNFshG8mRomGGxvX5tGLmAszczax7A1Lr7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ce5ZupXn8QiguNKMEhU4YvCp+9lxEGL2uxrNctMH2vQ=;
	b=Mu9FvknSd0Zmh0/VAzCC8ctKbSVfMTmKDZ+F1GFk1tGsfq9gRTim+oPK/lYh81EqB9Su
	 dkFrWpKL47rM/vEsOJ8XARycwcC+3OFpS3DjgSWlUMyTYrJS3iM59RDfXoJ+03L7Wo8Wk
	 dFJtGIasWPJwkFUWRgKNjq040PH3gy7ZPpAuN+IBGmCQuXAwetFj97abJQvahj3UB4V4f
	 Df1gS0sC5ajGdkebt0Qv2SlQdBgozd9FQQIVpDYONqOa4hjwqtpt+inHfomD/2uvuOHMb
	 TswJAKrRXEwI1WlryR7kDAJrkEAI+k9mRo6IJPTZa6sCuISNAFGefr6A/4WEeGxd3sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jy8JD+cl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36682606EE9B;
	Sat,  7 Nov 2026 15:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jy8JD+cl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D635E1F0089F;
	Sat,  7 Nov 2026 15:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063797;
	bh=ce5ZupXn8QiguNKMEhU4YvCp+9lxEGL2uxrNctMH2vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jy8JD+cljgcAzvbmu+uxRGPSIC5Ke3p4X6ldEceaV0Wb+I+BpmHQoMLE7Re0oFIVT
	 hppB3W+MrMDGigWf8m9FWXUSt1vOq700hZ8ZsLos5ngLzuSQyq1Soc/z4nfSFbPldX
	 Il1szBhf6X/sfefEuFfSRmvCn+VF2ZseoYelYwMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0018/1257] drm/nouveau: cancel the DP IRQ work before freeing the connector
Date: Sat,  7 Nov 2026 08:38:34 -0500
Message-ID: <20261107134939.923026679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4cfc9c7c2ae0c..7c4f0a29b05bf 100644
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



