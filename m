Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037510;
	b=qPpsTyvF/3grQS1wKUzHMVEbmbWq9wCyrB5bbhwnEZX6vqeyR+ZlEaB9DWxuwiIugaoo
	 9s0vTatrgik+aAES2cdGm6DgCsJ7qzjLyhVdKlchTgAHKiaTyaQSEISfPR/lGR2j1NdjU
	 eZaq7x7PsCR+PpWquAfI16l9PWY1qyjsW0NDdasEx27V7xx7PR9mM0D/VY0i0UDh3Ow+h
	 ZagsUcRBDq2/23Q0P5Q4VPm1GCY/vELK9vTby7T7wBzD2uqeRU5ZpXrZ7oOEsQmuYZ0Nv
	 /5fh+X3B8fgMfsT6zI1NmG9RwGJfj9UT1IHYDgMtkUbPUVGQmIR3ebLy51Z/X3hId4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jYMdtubQwXUJtguXQo1KWzeOmgg1wNb3FQPWO6FlaJg=;
	b=QbxqSOdolCSWzk7A5mN2ba+RTPa6yxlQpq4CdeI7sW0N0lqr5rFd/J8pbuhfbecKY92x
	 7DvAO+zBxc7UsIvPXJ6OH6lifdgzWEoU6Lef9dXJCjPLI9I+qSbwmrv4QHh4j9iJx+VRJ
	 9aKFEleLQOxvHJNcPv3d/G/gqCFA+3MXjYzWhYLeatWmsmz1SzYuMF3QNNgaSDVZ33ups
	 1ROIM0C+dvaLHOOyJS7gCyvfk45LMhWqGT5BfDoD2lTBJ6p+e4jtamphxQ+ZRQdLyxLmX
	 GxY1OV9yVURqxfFNdQRtRMzY8lwF99QlM+qRktPq8Rmmgj2ArAsTcof/iz3RFhLZgsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yp6fZ+3B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3B3606A32F;
	Wed, 18 Nov 2026 21:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yp6fZ+3B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FA41F000C4;
	Wed, 18 Nov 2026 21:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037510;
	bh=jYMdtubQwXUJtguXQo1KWzeOmgg1wNb3FQPWO6FlaJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yp6fZ+3BSUUcfOu3W75WO96g67fi7hp9QnU5kgJFqbysWO5Dy8f3bXGcEdFxT82ZQ
	 s1DZvtOOOmPiC88XuF9+1Y2j7PWoebpkb2yLB75PW3U71PVIHo8HbE5W61UMJfrMNX
	 fvaRzLS0nwGOLViLezc0ptXfRTvAqGNTT8PN4jFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <lucas.tanure@neat.no>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1420/3318] drm/vc4: hdmi: always cancel the scrambling work synchronously
Date: Wed, 18 Nov 2026 15:34:02 +0100
Message-ID: <20261118150403.304185179@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Tanure <lucas.tanure@neat.no>

[ Upstream commit 2e47848f0d076dec66df3bc403214073cd2214ac ]

The scrambling work re-arms itself every second while a scrambled mode
is active. When the output is disabled, the work may be executing at
that moment rather than pending, and delayed_work_pending() is then
false, so the cancel is skipped. The running instance finishes after
the disable, sees the sink report scrambling off, writes the SCDC
scrambling and clock ratio bits back on, and queues itself again. The
sink is left configured for a scrambled 1/40 link that no longer exists
and the work keeps running until the next enable.

cancel_delayed_work_sync() handles both states: it waits for a running
instance and blocks it from queueing itself again.

Cc: stable@vger.kernel.org
Fixes: 257d36d493e9 ("drm/vc4: hdmi: Add a workqueue to set scrambling")
Assisted-by: LLM
Signed-off-by: Lucas Tanure <lucas.tanure@neat.no>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://patch.msgid.link/20261026164028.78792-3-lucas.tanure@neat.no
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index ac9b8ccdca3ec..213b7e65cff5c 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1058,8 +1058,7 @@ static void vc4_hdmi_disable_scrambling(struct drm_encoder *encoder)
 
 	vc4_hdmi->scdc_enabled = false;
 
-	if (delayed_work_pending(&vc4_hdmi->scrambling_work))
-		cancel_delayed_work_sync(&vc4_hdmi->scrambling_work);
+	cancel_delayed_work_sync(&vc4_hdmi->scrambling_work);
 
 	if (!drm_dev_enter(drm, &idx))
 		return;
-- 
2.53.0



