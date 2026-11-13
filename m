Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590217;
	b=YuUwEX9va4y33Hv+0rKLepr18vgmTfV/plowJeAaEQEj96Mu2IJQET5jnAF41Cg5zcnX
	 MwczEb2IboD5XPs0rk9sD/aOF0q31qck/ZIs3JRqJqxFkxYg0d6EmIRC2v65FdQewMqh7
	 knBnyhJlhB8pjeeV5Cx2ykXzBrfISs4MHkpwFCFuwTPxlh+RlXcokyGMFdSp53VP160k0
	 RVrslHgHRBFSyMc1N30pmmdCfALH5VSUvcDl2NuCtc1L+801Qyw7E6yjHaSahkJeq9usM
	 GfqXo/2nu5rZo/pfboqHly/2RfVUOB/WRlPYT3cW7U9OqRksYktqAbMzP6iwgAJ+6fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=n6LMAzCMR0VVRUhg7TYhbyw8tD8NepPAannjXNKGAyc=;
	b=kY+52v789MJgNJrGWwkZLR50RmpxKUTdt7yD0PWInI+b0Z8+iJpb+GP0RqUIbeh7BywK
	 ykS1c/50z9iZ2evTMBOITN+08wF4Av+YhzFz4pCIqob8kKnMQN7Prx5dOi4xCt2RLMijQ
	 IOoXRjWEaKcnCVxE+iPQ2DTZLyBRie14p6VjMJdOWmg3UAonqBRCmh1CYXPsjTpPFT8bX
	 KWvN9gnDErhQMtDSaECDAbZpxgiwduMFEFtic4HwX6o6bvGQgTDsp6IZXHr6vrUr3Yhk4
	 kuTT+GBL674X2YUUrcBhY6c5/bXcqgFUYyaLE4YasBZRoZWH7exmZH3EAtX55m5H7RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYm8iU5R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238C5606BD29;
	Fri, 13 Nov 2026 17:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYm8iU5R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58BD1F000C4;
	Fri, 13 Nov 2026 17:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590217;
	bh=n6LMAzCMR0VVRUhg7TYhbyw8tD8NepPAannjXNKGAyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYm8iU5ReRMVhZNt6XMFt7IUPqaCuH62rmQPyla6O1Ou+kyiiYWzO7vI7qrDNXRfB
	 PTUzp52eAN6kUIkLEbBaCHPgUBi0IYmhcnBUjaOgSp6LGepGRajDLZ71McpL0o4ZFE
	 8lr4XLTPmFtxzj9YNF4zYBCrAdOKpW28c/63R140=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <lucas.tanure@neat.no>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 218/686] drm/vc4: hdmi: always cancel the scrambling work synchronously
Date: Fri, 13 Nov 2026 10:45:51 -0500
Message-ID: <20261113153828.416774417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2f854386c3389..7a84d8414436f 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -764,8 +764,7 @@ static void vc4_hdmi_disable_scrambling(struct drm_encoder *encoder)
 
 	vc4_hdmi->scdc_enabled = false;
 
-	if (delayed_work_pending(&vc4_hdmi->scrambling_work))
-		cancel_delayed_work_sync(&vc4_hdmi->scrambling_work);
+	cancel_delayed_work_sync(&vc4_hdmi->scrambling_work);
 
 	if (!drm_dev_enter(drm, &idx))
 		return;
-- 
2.53.0



