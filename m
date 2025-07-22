Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE872C9A;
	Tue, 22 Jul 2025 14:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193182; cv=none; b=DKzMcxVIAgAbt/mf8CIcqhRZqh3x04B4r4eiezUm1ms2jVwnwkWuApsCBH6czJ7NTKVx9Z7f+BABxZQqlWFCUwpg1v2B6RRxVukwpFHRx8bHOPbLbFH1aPShrcbFuoG1hdu5FbIZDBdnhJtsdFeYEoMPx4iOvI5rlmnDaBRqBv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193182; c=relaxed/simple;
	bh=fEWFJUIAGJUrbnOaGLShkBZ21qn2KOl3ocSYIrWBXGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kst8Z071FSeQWr7LmFerLMp3KH1GtbD/j/p2obBhmX+4w73cxTYF5LC8weThLLCCNdkjCK5C1cuUcH75+xqTlQ3q6BLfgqk02m7sa+fCfg/BnUA9QylwTGg3QcK2DJ7ZwYuleT9GM1OhbPobwExKbdcza6FwvLMuy3IONbnl5C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ota+UY1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ota+UY1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DFCC4CEEB;
	Tue, 22 Jul 2025 14:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193182;
	bh=fEWFJUIAGJUrbnOaGLShkBZ21qn2KOl3ocSYIrWBXGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ota+UY1jNOADiLizkQfhminUXnx+4txjlnCDyJuhqAXYBQpd/xarJSQyAL7ehFItm
	 9y0Vk4TiW251Dj4cOq/QcYsUgWq4FE0/ff2FK2kO/Y/o8RSuD3ic0t4cFlGuQ3GQ1h
	 0AatgIWO7RUDod9igQtPt8JA3M1UgW+9xFyT0lp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	stable@kernel.org,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 6.15 016/187] Revert "staging: vchiq_arm: Improve initial VCHIQ connect"
Date: Tue, 22 Jul 2025 15:43:06 +0200
Message-ID: <20250722134346.363111849@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

commit ebe0b2ecb7b8285852414a0f20044432e37d9b4c upstream.

The commit 3e5def4249b9 ("staging: vchiq_arm: Improve initial VCHIQ connect")
based on the assumption that in good case the VCHIQ connect always happen and
therefore the keep-alive thread is guaranteed to be woken up. This is wrong,
because in certain configurations there are no VCHIQ users and so the VCHIQ
connect never happen. So revert it.

Fixes: 3e5def4249b9 ("staging: vchiq_arm: Improve initial VCHIQ connect")
Reported-by: Maíra Canal <mcanal@igalia.com>
Closes: https://lore.kernel.org/linux-staging/ba35b960-a981-4671-9f7f-060da10feaa1@usp.br/
Cc: stable@kernel.org
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://lore.kernel.org/r/20250715161108.3411-2-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../interface/vchiq_arm/vchiq_arm.c           | 28 ++++++++++++++-----
 .../interface/vchiq_arm/vchiq_core.c          |  1 -
 .../interface/vchiq_arm/vchiq_core.h          |  2 --
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 5dbf8d53db09..cdf5687ad4f0 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -97,6 +97,13 @@ struct vchiq_arm_state {
 	 * tracked separately with the state.
 	 */
 	int peer_use_count;
+
+	/*
+	 * Flag to indicate that the first vchiq connect has made it through.
+	 * This means that both sides should be fully ready, and we should
+	 * be able to suspend after this point.
+	 */
+	int first_connect;
 };
 
 static int
@@ -1329,19 +1336,26 @@ vchiq_check_service(struct vchiq_service *service)
 	return ret;
 }
 
-void vchiq_platform_connected(struct vchiq_state *state)
-{
-	struct vchiq_arm_state *arm_state = vchiq_platform_get_arm_state(state);
-
-	wake_up_process(arm_state->ka_thread);
-}
-
 void vchiq_platform_conn_state_changed(struct vchiq_state *state,
 				       enum vchiq_connstate oldstate,
 				       enum vchiq_connstate newstate)
 {
+	struct vchiq_arm_state *arm_state = vchiq_platform_get_arm_state(state);
+
 	dev_dbg(state->dev, "suspend: %d: %s->%s\n",
 		state->id, get_conn_state_name(oldstate), get_conn_state_name(newstate));
+	if (state->conn_state != VCHIQ_CONNSTATE_CONNECTED)
+		return;
+
+	write_lock_bh(&arm_state->susp_res_lock);
+	if (arm_state->first_connect) {
+		write_unlock_bh(&arm_state->susp_res_lock);
+		return;
+	}
+
+	arm_state->first_connect = 1;
+	write_unlock_bh(&arm_state->susp_res_lock);
+	wake_up_process(arm_state->ka_thread);
 }
 
 static const struct of_device_id vchiq_of_match[] = {
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
index e7b0c800a205..e2cac0898b8f 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -3343,7 +3343,6 @@ vchiq_connect_internal(struct vchiq_state *state, struct vchiq_instance *instanc
 			return -EAGAIN;
 
 		vchiq_set_conn_state(state, VCHIQ_CONNSTATE_CONNECTED);
-		vchiq_platform_connected(state);
 		complete(&state->connect);
 	}
 
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.h b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.h
index 3b5c0618e567..9b4e766990a4 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.h
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.h
@@ -575,8 +575,6 @@ int vchiq_send_remote_use(struct vchiq_state *state);
 
 int vchiq_send_remote_use_active(struct vchiq_state *state);
 
-void vchiq_platform_connected(struct vchiq_state *state);
-
 void vchiq_platform_conn_state_changed(struct vchiq_state *state,
 				       enum vchiq_connstate oldstate,
 				  enum vchiq_connstate newstate);
-- 
2.50.1



