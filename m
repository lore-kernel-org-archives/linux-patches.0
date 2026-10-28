Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212897;
	b=wmSEq+Rsi4g3WVvI/LUKw2N3dbvtu1Mq9ugIwKMWB3Pg/eO4Pmg5h5PJWpbAfzhzaAGD
	 GizZZ+9VpLmiWKGdaf03nkT2oZPBJ9+7G4ZpLltOp/jyGTOXigDulWXrjUticRElmn5eY
	 uBxO8nxJnugGx8KpxFCMlIA2okZRxzVk0QVgrLe63bJGuvhGRbgXbdOPeAxEL9TYJioO8
	 7YwquVzgT8vkQ4C4D7NuSlCQn7jZuYL/WRUK6sIWTcxWbCggZ4a/G+Y5bX6XJAvoal3Xl
	 alWsH1fpPsVuOVsLEtJnHhTVYZRUTQ5/HwehRw7YYoron/xdTlf9fcAAbZJSwlzIkQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G1APIT10zpJXj3nnizL5wd9yn6iZ6n8BRSfoZeqyado=;
	b=BsPqhvGA1DvFTigQpt/zZWrN+6JTkDS5KkBM2gc6p8dJYfT4bU8hn21gEW8+ZWhUfXLI
	 cCK0KtUC4Wwgg6YUYC8nHT8jMIoaK0QGcI8EOFkSgOH0nH0p68391+LHkk5vZT3YeqEjA
	 I99sL+vVW2V0zh427zt41lIYwhX11UN68l7ZLx/ZlrPjEDTgpZq1MK+eM+Qc2nTVz2x2y
	 36Ptcrdexpg8+BP4NzbRdG9wZdUWF+twGr5/aN2y4g/1gCMFBJlYQSvPK+U8h0h6gwMvc
	 RYW+5Rz5ZBRuMlwNeBFBJ4oQNYD6i38Tl9XzWTFegIPbmz9s/jDpD41YUCNhniBfHJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSQKQiat;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2692E606A31D;
	Wed, 28 Oct 2026 18:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSQKQiat
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307A61F01825;
	Wed, 28 Oct 2026 18:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212896;
	bh=G1APIT10zpJXj3nnizL5wd9yn6iZ6n8BRSfoZeqyado=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSQKQiat7/PG+XmUX1aMGd26zUgwXtpZFwGF/guEMlcGjd/zpbkBYS+K25TOyIens
	 QfTkgt77n+StKwtmzEXgx8QtxfMFoHKgMsSMg5tthRBSQ/1XJKgQDUIVL6ppt3JmG8
	 Ioo6LEBZnviSWqRnChao+f170+fqylE2+Psw5hLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 0315/1887] wifi: mac80211: drain PS delivery work during station teardown
Date: Wed, 28 Oct 2026 17:40:11 +0100
Message-ID: <20261028170506.396285746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 67a9e80c3ca20c9044cd6ee72cd6278dd19b5023 upstream.

Removing an AP or mesh station can notify the driver and wake TXQs after
the station has already been removed from the driver, and can update
num_sta_ps and the power-save queues after station cleanup has purged
them.

sta_deliver_ps_frames() tests sta->dead only before it starts delivery. A
worker that passes that test can be delayed while teardown sets sta->dead
and removes the station from the driver; when it resumes it still runs the
full delivery.

The existing cancel_work_sync() sits near the end of
__cleanup_single_sta(), after the final driver state transition and after
PS accounting and queue purging, so it drains the worker only once the
state it has to protect has already changed. Before commit d34ba2168a3c
("mac80211: don't delay station destruction") cleanup was deferred
through the same ordered workqueue as the delivery work, which kept the
two ordered.

Cancel the work after setting sta->dead and before moving the driver
state, and move the existing cancellation to the start of
__cleanup_single_sta(). The first drain closes the driver-lifetime window;
driver callbacks during the remaining state transitions can still queue
drv_deliver_wk through ieee80211_sta_block_awake(), so retain the second
drain at the start of __cleanup_single_sta(). That drain also covers
insertion failures, which reach cleanup without setting sta->dead.

Fixes: d34ba2168a3c ("mac80211: don't delay station destruction")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse smatch coccinelle kasan
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260916113735.31029-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/sta_info.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -122,6 +122,8 @@ static void __cleanup_single_sta(struct
 	struct ieee80211_local *local = sdata->local;
 	struct ps_data *ps;
 
+	cancel_work_sync(&sta->drv_deliver_wk);
+
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
 	    test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
 	    test_sta_flag(sta, WLAN_STA_PS_DELIVER)) {
@@ -162,8 +164,6 @@ static void __cleanup_single_sta(struct
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_sta_cleanup(sta);
 
-	cancel_work_sync(&sta->drv_deliver_wk);
-
 	/*
 	 * Destroy aggregation state here. It would be nice to wait for the
 	 * driver to finish aggregation stop and then clean up, but for now
@@ -1303,6 +1303,8 @@ static void __sta_info_destroy_part2(str
 
 	sta->dead = true;
 
+	cancel_work_sync(&sta->drv_deliver_wk);
+
 	local->num_sta--;
 	local->sta_generation++;
 


