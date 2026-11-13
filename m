Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585431;
	b=L9auAJ7iE9Tb6dCnwOjwy9vDj/R01f6Niz3FAoXtMryxpL9cubxDvBl0yjypAJlgerhN
	 1rzk7LbbBbueRTfGzti4uduQFEKeSfB155fgoLzFNVhpMMbdvJEbOCAr2DlntxrZrQwVb
	 Jtj4zf1rOlF5woDrXmmWQxAfo0Qd3MwvV598tH+pNA6WTze5J+68qNS+49oPVGq7+whBA
	 vIABaPPEW07pccobSbnnyn1aA5BvIqC7pAsSTCVnhOa4eDoTtUUgbiWbsqMlfMTMKfAVh
	 NZ3au5lXem3s8V7Drf9LHsHHAYccfkkdWcsmmRjPCimFJtJRMriCFCmyfDfDWs/ztdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MAV4chkq9n808Re6V9Sl9tSQ8EaAcGXKz05mMKY6lhY=;
	b=yMhg29lsk5rRuGzI/J67k7pCkSWvZUqFe3sv5Spaa9lHzbd7oKk/S00gvXomczcpWKBb
	 BZ3YEtDhUU4U2J2P2+33na8IrmueuKtMZIkDwSx7QxDQaSdkF89Nk9Pn+j4W83jzI90qv
	 R3NKWhTpu8rjKSqqMJ6taqBGRNdN1OAZ9b4Te5+3IaZOPUvv2JheB3B3uskQyXU298rd4
	 qHBPx0lYfi+wzGjTYoHjurrvu5HiuKGjmEsQJMuSrIO5XZjWmPR3jV/Nax4RqY9Q5P6/I
	 LtKRNBIGQGxKAPdJ0YTXmI5H33Txcb3PxMY/DSM8VYeMiJzkpZEpoQuw5jNLJbF0yjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H8i3N76q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707E0606A8AA;
	Fri, 13 Nov 2026 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H8i3N76q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BACC1F000C5;
	Fri, 13 Nov 2026 15:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585431;
	bh=MAV4chkq9n808Re6V9Sl9tSQ8EaAcGXKz05mMKY6lhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8i3N76qxZa8qZ/Kli1qRTWGmYUh9cLN8EyJgTR1hx1qwy8beA38tO+t+Gqm9d5QR
	 gPtDXHls0/f5BfvM1SKP5JG9s2LkfgmGgpYltkuvCwNc3GQIg76ry4LLuYxYqfCvRJ
	 McxI7UrwyuxidhvDXx6JEGRCHRxU6pbZI5aBBja0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <lucas.tanure@neat.no>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 092/507] drm/vc4: hdmi: always cancel the scrambling work synchronously
Date: Fri, 13 Nov 2026 10:46:36 -0500
Message-ID: <20261113153757.144664837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index d4672aa81d85e..f58f645ec3c50 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -842,8 +842,7 @@ static void vc4_hdmi_disable_scrambling(struct drm_encoder *encoder)
 
 	vc4_hdmi->scdc_enabled = false;
 
-	if (delayed_work_pending(&vc4_hdmi->scrambling_work))
-		cancel_delayed_work_sync(&vc4_hdmi->scrambling_work);
+	cancel_delayed_work_sync(&vc4_hdmi->scrambling_work);
 
 	if (!drm_dev_enter(drm, &idx))
 		return;
-- 
2.53.0



