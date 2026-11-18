Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053238;
	b=cNTDhxcBovljpzv7U+3ZUMfj+G09QXxsgZWSIiIGJyxuLv0hDHIN+4PUWY0KjEd/wXRN
	 uIkrB9L4KukYzDPKccnypoAjAbTpJKe2anrwhFdXXasmsC//QSn8/aiGiq8TBPV1+MUBg
	 5KLNKP3gAeSIjTiv5KLmP7v5kiKjix0eaOWAs1f2QTMYGpSZ04QRKPiOCG/WwZIlZBBT5
	 KcZtvC3TptcFRFWi7J0JmI6u+RtxyQBM02gGjYo5DbtsWR8YrgrVo+/4wF5gvBLXjVUPH
	 N5DnojWwUL3RTzDR4AcQ/VC5aPqqXGFH+5fecqU+BbuSBmuG7TyYqIMMeHpDrOKzyLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XM7ZOiX3OKpE41hSgpJCcz+ESX1qNFvx7Wm6IhcxRPg=;
	b=q1phv52KKKuFObnkL54Qg5ttkcQpqfwIBfclxNptsxe/k8rMmJTr1xLk4O/AIvS2OieO
	 XwVK5k+YnmH8SCBcQYlgKnm6+tU7MlaSM1KB7DIOqUVQU/ROOAqNLpzYJArjklBZasTRk
	 W43sOshVuKI9bw/GxioQNa9jxpPV6AAES3zTby2aMd6rll8OV9TS6M6ytpJNoA6mkxGQU
	 qjh2ilx2in9NHV1WQ50ficdMX3Y+Vk9EpLD525Xl4K/lqXGGkQf0Zt7OeVwvAzKgvpNz/
	 UJYLjGGT9B3OV63BlDU05lmRE/3AJrCMEz0jUmv0PUMKEsM6xchvpgvDOh68887/pig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5mFhqwO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C426606A33E;
	Thu, 19 Nov 2026 01:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5mFhqwO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588971F000C6;
	Thu, 19 Nov 2026 01:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053237;
	bh=XM7ZOiX3OKpE41hSgpJCcz+ESX1qNFvx7Wm6IhcxRPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5mFhqwO2lGuB5Qj+yrTO1mNPyeP8jMcGyJ7a9EtCjeO7nDHfQkX9tbSKlwV58cpd
	 xPxreviP1fyadgkYh2LAddNV8ZACvWGJv6Eq3Q1Nwq85gzzG4jtRBwPXPDZxql0Jvl
	 XBYHCQOapWoaEIoMcQnLeik7k1qRy9YJcCj/nafM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <lucas.tanure@neat.no>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0849/2214] drm/vc4: hdmi: always cancel the scrambling work synchronously
Date: Wed, 18 Nov 2026 15:42:05 +0100
Message-ID: <20261118150046.131476259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86d77794d8392..9b540728b8fae 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -584,8 +584,7 @@ static void vc4_hdmi_disable_scrambling(struct drm_encoder *encoder)
 	if (crtc && !vc4_hdmi_mode_needs_scrambling(&crtc->mode))
 		return;
 
-	if (delayed_work_pending(&vc4_hdmi->scrambling_work))
-		cancel_delayed_work_sync(&vc4_hdmi->scrambling_work);
+	cancel_delayed_work_sync(&vc4_hdmi->scrambling_work);
 
 	HDMI_WRITE(HDMI_SCRAMBLER_CTL, HDMI_READ(HDMI_SCRAMBLER_CTL) &
 		   ~VC5_HDMI_SCRAMBLER_CTL_ENABLE);
-- 
2.53.0



