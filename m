Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023417;
	b=FQNEGuA08Z8oNVAhiJ9V8Ct7qhwcg+BFsiKF/dL8pxvnCNwRkJtVMwF1kBffmzo3KQEW
	 TmGOpYDCnmibA/GHIWKfQT4R3Tcb+FzT66FR2IcskVwrFaLGds6Rf4T7D0F/QPwo+bu5A
	 L6l/MyQHGqLkEwGv+F00/6w8VHUYZSmUBnnrAllHlUXWIlFVAr4QBP2AIsHOBmdHavjQs
	 8OcTZ5PTwjmb84X0Grgsspa2COAhYxiPQQaeSFkc8JdqReY0fV2jwOGqqsL3g+CMWqCML
	 lsiOVjDtbrbaJjvDXPQTfsj+2UGyfshdDpwLjbJ64auCqNd0VmgUOn1EIfNKJ2bdWZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FWlg3RPd1cP2T187ETtePxKgvOwNI9UoonZ9PDl72HA=;
	b=K58brjCwG4YEiKcF6k94XOULd3GwnI+R4ZV4xdDXocSFDIDaplc59AfBaSlt/DQYWAVA
	 prqqDmoXJ4DZt9mn+fYxMklOykyvoYLKYrF4nLTg9sFgzwK4DnaCMLcahfJTm/ajuUMFY
	 nO/fe6rwhpk8R8bE8l9gGTYrL70Qq2HNcx4OKcsRFJNa2RrTnNpeGbNGX1YG7j1nF2Wmm
	 ElVehZN+zOz4fa0K7AAgr3jWp5D949Y3eKRcwO8+ideiDKtteXYpMBVKqlS3sPOyMxJZ/
	 +3xTVV9EceY+EQcKvx+TasCRNDkp5jR70flm44z20mYiz5RmkZ0JL3z89lm1ShZ6X7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CKlxHZH/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A969D606A333;
	Wed, 18 Nov 2026 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CKlxHZH/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE121F000C4;
	Wed, 18 Nov 2026 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023417;
	bh=FWlg3RPd1cP2T187ETtePxKgvOwNI9UoonZ9PDl72HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKlxHZH/GFynDVO49RjGk1NWpidBiejOUgNExBUm7K//xeE27Ko5DDZGB1QmnzaGz
	 0Wc3hGjj+rVNz/6hjOrgrdI+0FNz6vFHUIGGBQXDw8bVp9BU0Y4A0mB5X6OavyFK3j
	 Mhj9kYlEwsPcSPDSDnDzqoQNedVjONa26FLdFlmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roland Dreier <rolanddreier@rivian.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0362/2151] firmware: arm_scmi: Dont reuse raw xfers with async_done still armed
Date: Wed, 18 Nov 2026 15:34:57 +0100
Message-ID: <20261118150135.283484814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Roland Dreier <rolanddreier@rivian.com>

[ Upstream commit 0543fc1443de1a0b04ec64684fb920d79e15de2f ]

In SCMI raw mode, scmi_xfer_raw_worker() releases the xfer before
releasing the waiter that disarms xfer->async_done, and scmi_xfer_get()
does not clear async_done when it hands out a recycled xfer. A concurrent
transaction can therefore pick up the xfer while it still points at the
old waiter's completion, so:

 - a delayed response arriving for the new transaction can be signalled
   on the old waiter's completion, which may already be re-armed for yet
   another unrelated transaction, making that transaction's wait return
   early; and

 - the old waiter's disarm, which still runs after the xfer has been
   released, clobbers the arming just installed by the new transaction,
   so the new waiter times out even if its delayed response arrives.

Release the waiter first, while the worker still holds a reference on
the xfer, so that an xfer can never reach the free list still
armed. Track whether a delayed response is expected in the waiter
itself instead of peeking at xfer->async_done outside xfer->lock, and
wait on the waiter's own embedded completion. (The new async flag is
not strictly needed but it makes the logic easier to reason about)

Finally, harden scmi_xfer_get() to clear async_done when handing out
an xfer, so that no future release-ordering change can leak a stale
arming into a new transaction.

Fixes: 3c3d818a9317 ("firmware: arm_scmi: Add core raw transmission support")
Signed-off-by: Roland Dreier <rolanddreier@rivian.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://patch.msgid.link/20260909-scmi-async-done-race-v2-2-cc5dec25c6be@rivian.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c   |  1 +
 drivers/firmware/arm_scmi/raw_mode.c | 25 +++++++++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index fb352ff3665b4..59f120783658c 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -717,6 +717,7 @@ static struct scmi_xfer *scmi_xfer_get(const struct scmi_handle *handle,
 
 	refcount_set(&xfer->users, 1);
 	atomic_set(&xfer->busy, SCMI_XFER_FREE);
+	xfer->async_done = NULL;
 	spin_unlock_irqrestore(&minfo->xfer_lock, flags);
 
 	return xfer;
diff --git a/drivers/firmware/arm_scmi/raw_mode.c b/drivers/firmware/arm_scmi/raw_mode.c
index f292d8c1096aa..415506f61e6a9 100644
--- a/drivers/firmware/arm_scmi/raw_mode.c
+++ b/drivers/firmware/arm_scmi/raw_mode.c
@@ -198,6 +198,8 @@ struct scmi_raw_mode_info {
  * @async_response: A completion to be, optionally, used for async waits: it
  *		    will be setup by @scmi_do_xfer_raw_start, if needed, to be
  *		    pointed at by xfer->async_done.
+ * @async: True if @async_response was armed on @xfer, i.e. if a delayed
+ *	   response has to be waited for.
  * @node: A list node.
  */
 struct scmi_xfer_raw_waiter {
@@ -205,6 +207,7 @@ struct scmi_xfer_raw_waiter {
 	struct scmi_chan_info *cinfo;
 	struct scmi_xfer *xfer;
 	struct completion async_response;
+	bool async;
 	struct list_head node;
 };
 
@@ -349,6 +352,7 @@ scmi_xfer_raw_waiter_get(struct scmi_raw_mode_info *raw, struct scmi_xfer *xfer,
 			scmi_xfer_async_response_arm(xfer, &rw->async_response);
 		}
 
+		rw->async = async;
 		rw->cinfo = cinfo;
 		rw->xfer = xfer;
 	}
@@ -361,8 +365,16 @@ static void scmi_xfer_raw_waiter_put(struct scmi_raw_mode_info *raw,
 				     struct scmi_xfer_raw_waiter *rw)
 {
 	if (rw->xfer) {
+		/*
+		 * Disarm the delayed response before this waiter, and its
+		 * embedded completion, can be picked up again for a new
+		 * transaction: a delayed response received late, after the
+		 * related wait timed out, must not signal a completion which
+		 * has been in the meantime re-armed on a different xfer.
+		 */
 		scmi_xfer_async_response_disarm(rw->xfer);
 		rw->xfer = NULL;
+		rw->async = false;
 	}
 
 	mutex_lock(&raw->free_mtx);
@@ -479,18 +491,23 @@ static void scmi_xfer_raw_worker(struct work_struct *work)
 				    ret, scmi_inflight_count(raw->handle));
 
 		/* Wait also for an async delayed response if needed */
-		if (!ret && xfer->async_done) {
+		if (!ret && rw->async) {
 			unsigned long tmo = msecs_to_jiffies(SCMI_MAX_RESPONSE_TIMEOUT);
 
-			if (!wait_for_completion_timeout(xfer->async_done, tmo))
+			if (!wait_for_completion_timeout(&rw->async_response, tmo))
 				dev_err(dev,
 					"timed out in RAW delayed resp - HDR:%08X\n",
 					pack_scmi_header(&xfer->hdr));
 		}
 
-		/* Release waiter and xfer */
-		scmi_xfer_raw_put(raw->handle, xfer);
+		/*
+		 * Release the waiter first: this disarms the delayed response
+		 * while we still hold a reference on the xfer, so that the xfer
+		 * cannot be recycled by a new transaction while it still points
+		 * at this waiter's completion.
+		 */
 		scmi_xfer_raw_waiter_put(raw, rw);
+		scmi_xfer_raw_put(raw->handle, xfer);
 	} while (1);
 }
 
-- 
2.53.0



