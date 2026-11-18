Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035812;
	b=2/R6z2TMNy5N8Za5592dbHjgaEWXGOFbWN3g4jdMycscEncnziREzpBSQhP6pNWYub7k
	 9YTv+LJgoErnZIRPN5IUPwP9/UmLbN8IKXDgCzuyvHSUbtWdzVSdy7+xqX0gQ8KrblfEb
	 guOAlyFYtRva5ZiBJtu6gHo8c1qJyzdQlbIDBY+PaAeWsKrbNqJM54+F5WfmG5jfpXitq
	 UxUqYJxZoS+JDk8CC70og3QPSS3hQoJKwHGjbW9dylKNPQuR0i5KhVdYw2foknFCXZDqE
	 bChWXVIkQlcGuDvity5iF5CXLVG3cOO1mUFRSKRCxqjbHA4ZKW3Fqpsf6toyKgxV1gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uHvXxqOh/1tw5fgXZky2RIjh/IaSqgTKn/mPt87huXg=;
	b=rgr+ahzl6tmpJ0ziJ8p3nxoqVxd12iF+1f4Bq1Li6mdGRI4BQdCQyYDYBfrroRLJTvOW
	 l2+YY8OUlbLE2izb3tFnZzqo5RpbSPAOHhfn+57FlUdc7U7s5TsowPlcPkx8WLgAkvSPW
	 b1DJ6tmX2WHJBWtCbXbbe4KVKaRgLspiHNF2Jjk0W4C0dy/gMpaO57DrFiHsRmXTkJQNF
	 RQnc5N8b/w52dGPwX2FhbZUoZqoAKvUqWytTEdMoQtobZObwhJ/f2vhGctdkKdHwI7Okl
	 pVfjPnSAt7m9FKsbsv8DlxcVdoTvea3MhJQ4chfUIVbz+4L5X1EtOdmx+dNnPwI2v1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vRI2Q8Bw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43B1606A336;
	Wed, 18 Nov 2026 21:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vRI2Q8Bw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305871F000C4;
	Wed, 18 Nov 2026 21:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035812;
	bh=uHvXxqOh/1tw5fgXZky2RIjh/IaSqgTKn/mPt87huXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vRI2Q8Bw05YDZouI1KV5g11h7uAdi504Xwbp23ZFPLeTfFmNMGiDt72pF2D2ztKmv
	 PFz22zbg0mOOB17TwrundIth2xZM5AuJ2O8V5QXjtsvYWG1p6Js/L4J+1AyHjgFUZo
	 3d0gfFckjRwf/jaqRwRk0K9x3ydpXm9EviOJiQUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0794/3318] drm/nouveau: cancel the DP IRQ work before freeing the connector
Date: Wed, 18 Nov 2026 15:23:36 +0100
Message-ID: <20261118150342.716837528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5661dcbe6f757..4211dfccb2379 100644
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



