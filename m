Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591034;
	b=4KTWE1XTEEsf03mX16rhRBHjlMNnmpmT4gnMBU12v9WekrE7sKa3564/YAuIN2dFR75P
	 O7B8K5FImIXA+XZSy6T6bfmf+9cVwpLffG8NsGLZlZ8IxUuveDwwAim/rw3b4oAwM6kAq
	 w7NJ1GuUpveCYtL/0W65MyI5UtfxUWnhjw4uYXnPqMAeGCNkZkLhAtcOxKBCbAS+kfDQK
	 ShU97x0zomJxsswIlIpCSIleoBaVO7fTJjW5ayKu1m1NRY2gI+tUmoVYqRsNTmqCLTk9E
	 01PgS4d9ArpFUtI79d7Rq+oOJ6syk3J0OCpn7fzYh1Ag9dokgKkm6mWVTmw8hnxIl9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WJRvrv3Z8p8AdM5sHgmj7UYaOL0WpxdqyK0+5hkHdaI=;
	b=x4oKa/FmCotE9J5Xdv1/+7wqCMoW5ThZ4QCfa732pCurBYTumxA33YE879HUorHcp8qn
	 gL61e2U0mBUpXwPIq5fSj4yNEgrS2WQ4THHjknYYJxNjyzfg0POOj185Hc4R5l43T76tT
	 rzaEMvBcOw9PDN/xrulZDbqstKPX2QQzPrXqL8uOWmrzNOsS4dA83YAYqc+Zf6uLaJtVk
	 xZdVnBrwebvNpSJ+M2rAv/5hNoozKJ3WQIItAratxXusLwDYmDy1nqm+u7TOPzbbaWHh8
	 AEPs2WF/24QFYajIWakYOgAKyRHqmx0ZxUdrQrKOLmTCJWGac04iM4LnnaD5h+i3iAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qVmBtbwH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B701606B804;
	Fri, 13 Nov 2026 17:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qVmBtbwH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479991F000C8;
	Fri, 13 Nov 2026 17:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591034;
	bh=WJRvrv3Z8p8AdM5sHgmj7UYaOL0WpxdqyK0+5hkHdaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qVmBtbwHfrxgtAGxp2EAnbo7IJc2Nq8ewxQEEnMswVZZLv3xk8PEoea7JhFvprAW9
	 pI+zq2Sb6CvJkCPT19KIXQt/FqF0xK57R7wG4GRz6V5v0VdzoNrJcGGntZiX+ahvaT
	 duBJs11ymLJF2snK/hDsvehJm0vbso5U/Ak/+3v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <lucas.tanure@neat.no>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/670] drm/vc4: hdmi: always cancel the scrambling work synchronously
Date: Fri, 13 Nov 2026 10:46:05 -0500
Message-ID: <20261113153818.780358096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7ea1622377b58..419ea3bcddfc8 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -806,8 +806,7 @@ static void vc4_hdmi_disable_scrambling(struct drm_encoder *encoder)
 
 	vc4_hdmi->scdc_enabled = false;
 
-	if (delayed_work_pending(&vc4_hdmi->scrambling_work))
-		cancel_delayed_work_sync(&vc4_hdmi->scrambling_work);
+	cancel_delayed_work_sync(&vc4_hdmi->scrambling_work);
 
 	if (!drm_dev_enter(drm, &idx))
 		return;
-- 
2.53.0



