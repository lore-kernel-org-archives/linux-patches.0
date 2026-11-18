Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039579;
	b=rydQQUK/369xj9255GiPpplMEXd9dN/yFVBs9w5CvhfinMC+QETvCA9mXqd5nwidPKbw
	 bAIZI+hAVy+Me5xmGlA03fgfvuB2IVuCRcUsHSYQ2vawyEhxsqO4kYQQcK+G5RDiovr9Q
	 4K8RWY0uw3jqmKNzl8fLXSzJ3Yl4xsPS6nCB5ZnfvsRtwhz9Y/CbZqX/0jDe+DeMjUtAu
	 APKZ76//GCsJ8yUWCNuzeo2T4PPZv00mT7rqSUPFj3CUMpshRZmrFxpnGqyxhVQE0NNqo
	 Pmy7Q289t5Wk+UKDvqMTt3rWvCUfQ5TyD9bLFs6LQ1cp6nN9qmslWuwYbmou2LivDAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QlWT+alRFFTFdyXIAoXFuWY9hDw/RoBcgL34ROG2XR4=;
	b=CcA+JwPE3sQULbzLKQiLrWwcxtfPBYXPYMj/nFrxulXGPRGOocfhFDQr4sJo4FBg2Ru3
	 QnI4wfA79FqDdd1nDHM+8mNVwzVx/iKlNIxmX6U5ibi3b/f0TRwxthXE+cphZejNEjZ1R
	 /UY90Lka+FabtH3cRSptcoXdBT43VKGhkhuMAGBuyAQHodd+lLQ1GdvvNwI9gnz3hcUVi
	 KOOUoO53sUgy1lSW8v9g3zOfThadgk1zx78KQMMXYuO6ocimuXap2H3ERJkroFQyh5RyF
	 g6hPr5j6alFDO7hidaoidOFdnQzn6oqGgduwYTbLsouUki9GqXcMj2K5quMxRz276uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5Y+nsra;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F27606A325;
	Wed, 18 Nov 2026 22:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5Y+nsra
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75AB1F000C4;
	Wed, 18 Nov 2026 22:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039579;
	bh=QlWT+alRFFTFdyXIAoXFuWY9hDw/RoBcgL34ROG2XR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5Y+nsraELb6NpTJNq9uZFWFuLLmKEaU5eOW92c8U8Ol9l+geztnGLAnKqzh6G7Y8
	 g4U8dcIGdIrB9iuwyL8tSKZtkm67o0R+n4ZyKMUByZ2kWUHJ4sCUcdPnTU6W+w9Iet
	 ACWE9JhC3oQg6+kCVycAUxht9MFkzbjvvFiRK5Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roland Dreier <rolanddreier@rivian.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2152/3318] firmware: arm_scmi: Dont reuse raw xfers with async_done still armed
Date: Wed, 18 Nov 2026 15:46:14 +0100
Message-ID: <20261118150426.593589838@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4e84f6ee2a98b..ce6155ca8ee31 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -543,6 +543,7 @@ static struct scmi_xfer *scmi_xfer_get(const struct scmi_handle *handle,
 
 	refcount_set(&xfer->users, 1);
 	atomic_set(&xfer->busy, SCMI_XFER_FREE);
+	xfer->async_done = NULL;
 	spin_unlock_irqrestore(&minfo->xfer_lock, flags);
 
 	return xfer;
diff --git a/drivers/firmware/arm_scmi/raw_mode.c b/drivers/firmware/arm_scmi/raw_mode.c
index 297ddfe3cf0b7..56d93b1032e9a 100644
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
@@ -478,18 +490,23 @@ static void scmi_xfer_raw_worker(struct work_struct *work)
 				    xfer->hdr.protocol_id, xfer->hdr.seq, ret);
 
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



