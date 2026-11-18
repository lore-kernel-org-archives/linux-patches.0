Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016256;
	b=AzZJmlaNiJH+hM600GWOz1BNS/nlsrsmhMFlbBMaYdeHI4Ma0/wKHPL3pVjct8i7wHk0
	 IDTB+g/m9UCgam+6gL77aE84jufzL4X9R5aGSm8zP2TWDea7nhHgZZjcxeOFmDHJTNd1/
	 14Ro9nF54pWguejVBp6y16JEZTtW1RFWrHEh2ntUgfhnWHcrI77/GjKYy5NffD5dnMexG
	 Nxrq5xd0v4R16eycvWKUaxEu+riBOWvlVt4z2T0p/X8nq/WM3iTokvpTLNhIQOrLwN7+A
	 xalrJCe3ih0VprJEUIIzWhWNnM9aUNfSxRdbnPDwR1j2u0r1RtvPn/X/gLrrU3sPdEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=B/EcW91HobCiuDiEv+Zr5CvCYSJGf+TFDpbeEMNgPEY=;
	b=CTKfFzFiR8LPuVshystRVQOFak6yYqcWreHSj5yJnxz8a+5pMis9ZxHu9BOj8/Y8wtav
	 yaTiCO7AJyyF/O/gF5U6/B09gW8t8eh1IKv761cA8cF43+WiYFhHMEnBhF+7b4C7lusL9
	 yttjMFz0+UMYIeaJQt1MwAMzTcQ1eNfeq34Kmwh5vTqiA4xCXGv3DiYA576JhEp8YbPMf
	 wQQX/FkKMbldvVRxEgvSsHtrRUKJukXdwvhft+Vn8NuZDs9jw6ZQh+1ZUOOpVwJQcWCzh
	 D8tzGYx1HAwsNw4PAXySzLsB2aAjmtueGhDZk4XOZvu9z3vEeSSOZd3md0ckkUuZs0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zqpJX7R1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E2960A2608;
	Wed, 18 Nov 2026 15:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zqpJX7R1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934E21F000CB;
	Wed, 18 Nov 2026 15:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016256;
	bh=B/EcW91HobCiuDiEv+Zr5CvCYSJGf+TFDpbeEMNgPEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqpJX7R16LPhRstGraUFM+PB6BlBISWdwVbRA/v6pQDOmz2zKllh/K3MSVndfWCHR
	 lW/jGYDh1OWcfJN7aS9qZiMLx6X6AjnXmUtxpQ5+sTQBsMJmdv+KsTSC0xa1qF3utO
	 7WDf9CNG3p3HgKp7MW3VtXphrU5hq5w2fayCFh5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0463/2651] wifi: wfx: fix use-after-free of the cooling work on device removal
Date: Wed, 18 Nov 2026 15:28:23 +0100
Message-ID: <20261118150304.469653524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 17402a869778f6c17b88fd360d7a96378779f97c ]

When the device reports that it is too hot, wfx_suspend_hot_dev() blocks
the Tx queues and arms cooling_timeout_work with a 10s delay. If the
device recovers a normal temperature before the delay expires, the work
is canceled. Else, the work declares the chip frozen and unblocks the Tx
queues.

However, this work is never canceled when the device is removed.
cooling_timeout_work is queued on the system workqueue, while struct
wfx_dev is released by wfx_free_common() (through ieee80211_free_hw()).
So, if the device is unbound during this 10s window, the work fires
after struct wfx_dev has been freed and dereferences it.

Cancel the work during the teardown. It has to be done after
wfx_bh_unregister(): the "device too hot" indication is processed by the
bh, so canceling the work earlier would allow the bh to rearm it. On the
other hand, the work calls wfx_tx_unlock(), which may in turn call
wfx_bh_request_tx(). So it has to be canceled before bh_wq is destroyed.

Note that the Tx queues are intentionally left blocked: the device is
going away, so there is nothing to unblock.

The issue was reported by the Sashiko review bot and the fix has been
written by Copilot (including the commit log). The use-case is difficult
to reproduce, so this code has not been tested. However, I don't believe
this patch could cause any regression.

Fixes: 1d52d29983e5d ("staging: wfx: add support for 'device too hot' indication")
Assisted-by: Sashiko:gemini-3.1-pro-preview
Assisted-by: Copilot:claude-opus-5
Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Tested-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://patch.msgid.link/20260906204831.949692-2-jerome.pouiller@silabs.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/silabs/wfx/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wireless/silabs/wfx/main.c
index 4e99fe7e5bb78..b6fd9d4c1f5fc 100644
--- a/drivers/net/wireless/silabs/wfx/main.c
+++ b/drivers/net/wireless/silabs/wfx/main.c
@@ -487,6 +487,7 @@ int wfx_probe(struct wfx_dev *wdev)
 		wdev->hwbus_ops->irq_unsubscribe(wdev->hwbus_priv);
 bh_unregister:
 	wfx_bh_unregister(wdev);
+	cancel_delayed_work_sync(&wdev->cooling_timeout_work);
 	destroy_workqueue(wdev->bh_wq);
 	return err;
 }
@@ -497,6 +498,7 @@ void wfx_release(struct wfx_dev *wdev)
 	wfx_hif_shutdown(wdev);
 	wdev->hwbus_ops->irq_unsubscribe(wdev->hwbus_priv);
 	wfx_bh_unregister(wdev);
+	cancel_delayed_work_sync(&wdev->cooling_timeout_work);
 	destroy_workqueue(wdev->bh_wq);
 }
 
-- 
2.53.0



