Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829502;
	b=jsgr9fbF/JXCpQWUuBytpMqEmBrxkkPgeZIMEvDOTeiv2jcIMIzOy5jNJKEEwMRlSTxS
	 a4HSPuYDTPEWK9oKsD81qqe5/mMKmevJ3aLzRSr6wAEQcN6CnNrbl/wDScCJ/Ds0MmsjA
	 pkrhPuBfBOCX476xVozk/+Hc9PZqYkH+U0+Nejhm9wIRn121LOH6IpOQYmv1hfGvbrtTk
	 FxUktadd23Dn1vwEmAYjmOQnw4GGNdirA3npktdFUEAy70RrdmIE3ezAcIV8DW6SMo/l3
	 q5+pGEzC31WnLU/VYH0Gf/XZcpjcwtyRVY12JdiyjDUr+9qPM5wVD68sRV9vSJ67DAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B0/x5bAj+DofzRJ8wLIbWiKkDyV/41kpBnSGpbPhZSw=;
	b=dpfbSSVaOqwaW2VPJgoAu9iqw2LyX902WJAuAK8SnsQdGc97g4kRtJZQmSlU3/FwqKOx
	 CLW0DG7njsmrfgjfIRhOHXYkC2aleba5u7mbBe4YSWuaCh2d0aSipVlBk/1Tq3V1aAYrw
	 18mvOPEHpha0p69ZFKcRKC7MeWdtMbxM0V3aYUjnJXzQPjM95oi+dfj6a+J0lHO6djoZg
	 wmG+QVtYjtBBldsaJJv0Ngq7dopLluIfXEaTgd6k7jOGOExfclJdEwTPaNTcwtLEPP1El
	 OQlltmM42Jue0TcXsFqzagLCezj/bM/s6ui0mEpUTUcaa88RLxR4ENFeai6eRSoCS2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zFOQjW/1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C196B606A844;
	Wed,  4 Nov 2026 21:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFOQjW/1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626E01F000C1;
	Wed,  4 Nov 2026 21:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829501;
	bh=B0/x5bAj+DofzRJ8wLIbWiKkDyV/41kpBnSGpbPhZSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFOQjW/1fPlKiN97Zzf1HeXN5C+sdQ2tqEORcsLv/obA+7zAQg4DkRpFbYxgMn9+A
	 durzvn/l3ZujrOFN6De4juv9sN6J17RKWXUu0k5mCjx+vBHI+WP768Jl40d2fPykA+
	 zPq8bXEjOzXU+8WJIocpseVxja4MjYNQyufKcATI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0164/1005] wifi: iwlwifi: mld: cancel wiphy work before freeing wiphy
Date: Wed,  4 Nov 2026 15:58:17 -0500
Message-ID: <20261104211048.358377303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit c99bc4d4e0ba6f4661b2b914c96a597d26e7cc05 ]

When we fail to load the fw during op-mode start, we purge the list
of the async handlers but we don't cancel the work.
Same when we stop the op-mode.

Before freeing wiphy, we need to cancel/flush any pending wiphy work,
otherwise the work will fire with a freed memory.
cfg80211 will do it anyway, but it will warn.

Cancel the work in those cases.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260714165826.07aa49f755a2.I734a27b1b0eeb5b0e821aee3318fee8dc0a6bc03@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index cf003a4a37408..49fcbe6814677 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -440,6 +440,8 @@ iwl_op_mode_mld_start(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 	}
 
 	if (ret) {
+		/* wiphy memory is about to be freed, we should cancel any pending work */
+		wiphy_work_cancel(mld->wiphy, &mld->async_handlers_wk);
 		wiphy_unlock(mld->wiphy);
 		rtnl_unlock();
 		goto err;
@@ -505,6 +507,7 @@ iwl_op_mode_mld_stop(struct iwl_op_mode *op_mode)
 	iwl_mld_thermal_exit(mld);
 
 	wiphy_lock(mld->wiphy);
+	wiphy_work_cancel(mld->wiphy, &mld->async_handlers_wk);
 	iwl_mld_low_latency_stop(mld);
 	iwl_mld_deinit_time_sync(mld);
 	wiphy_unlock(mld->wiphy);
-- 
2.53.0



