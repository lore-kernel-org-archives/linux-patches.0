Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212044;
	b=x8PUJtZBu1a/aneExDVz4Y9d8gAzGha7v6v8r2l9/xsbE7+Gk8VKm5m0dgk1JjtDUzwR
	 d9iEfwPJb1NLmranpTIE7S7jwYskReSsQnh0XXRrcwMz/sM9NMBBQ/Oxpodd9kcU7nKsv
	 ztuD/9eMwtJG5t2gx50vWkDXWVWYW0Q/kLqGt0ThhNpG8jWFX7lB9M9TACB9bOs+AnF2/
	 vL8kv1H+xLqfBZLroHk4B1gGK1xJu6LJQWDK7l2G/IYA+i9thunllqPON2Tf54DVwaMX/
	 347w5EgTwfjHZeeFue/pybugSbqH5SQw6Us1chQEBpPLZwf1ZYpEj9lVEM3xK1hTViA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ov9fv6CrzHrGZpnS7rUX9LngmYXt8l/poN1xSn72T8w=;
	b=UxXb/avLWmOFySKVW7xcgCQYX+TUVyJotMjereKpn3SOxAWxpUdu9trQ6OKWp1yEj+IS
	 y1mzQQziDyeXQ/3StGk3eR5f1QRSm/x7iInlSmmXLBTk3pUSdv3YHeHy4NvRuo6+aRY1x
	 J+gtN8Qooi1y8pwqrp3I6zHusVQrKORoyY7Wj4mVPOJMyHKOTGoNDTuwUraYZ9knySDGH
	 0cSmJZXw5O1ttvrl2hx8/7b1QdFJg4G6TQQuy9z4TQY4OUleRWfdcSluReORZoXXJco44
	 y/YERNITNSTGOBeIosFkxHpqhwrxF47FpnuMNsNU111YHNq4vqMEckmRYeVhcx2i+MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONYL1bWJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A533606A31A;
	Wed, 28 Oct 2026 18:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONYL1bWJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683ED1F01825;
	Wed, 28 Oct 2026 18:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212044;
	bh=ov9fv6CrzHrGZpnS7rUX9LngmYXt8l/poN1xSn72T8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONYL1bWJXkFXVY7XaegOerBTp4Rjs1uaLWn4nkfboWEMGn4/IV4J6VFfJrGJrPqFl
	 wsBIhYch91XzdMhwK7Jia92Nw8oj/M4nMvrjEzna0mYhb+Z2+0qK4pD6iAEI8UEP2q
	 jMoqVY76LX3sdUivcWHKHmUAZuauH+0pkydODN8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.1 0007/1887] io_uring/io-wq: let cancel find picked up hashed work
Date: Wed, 28 Oct 2026 17:35:03 +0100
Message-ID: <20261028170459.387159752@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit e9efeb4fc97b0879512a3c3b995ed448f2487e12 upstream.

io_get_next_work() takes all the work items that share a hash off the
work list in one go, and the worker runs them one after the other. Only
the one it is working on is visible as ->cur_work. The others are neither
on the list nor current, so io_wq_cancel_cb() can't find them.

IORING_OP_ASYNC_CANCEL and IORING_REGISTER_SYNC_CANCEL return -ENOENT for
a request that has not even been started, e.g. a buffered write queued
behind another write to the same file that is blocked, and the request is
carried out. The cancellation done for a task or ring that goes away gets
there in the end, as it keeps trying, but it has to wait for each item to
become current.

Keep a pointer to the remainder of the chain next to ->cur_work, and have
io_wq_worker_cancel() look at it. The items on it belong to the worker,
which needs ->lock to move on to the next one. Matching work is flagged
with IO_WQ_WORK_CANCEL and fails with -ECANCELED when its turn comes. The
worker isn't signalled for it, that would interrupt the unrelated work it
is busy with. As the request isn't gone yet, it is reported like running
work, with -EALREADY.

[ 6.1: ->next_work is the item being picked up here, which
  io_wq_worker_cancel() checks next to ->cur_work, so the chain
  remainder is a new ->chain_work, set when the item is picked up as
  well. work->flags is not atomic here ]
Fixes: 86f3cd1b589a ("io-wq: handle hashed writes in chains")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-13-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -53,6 +53,8 @@ struct io_worker {
 
 	struct io_wq_work *cur_work;
 	struct io_wq_work *next_work;
+	/* rest of the hashed chain ->next_work or ->cur_work came with */
+	struct io_wq_work *chain_work;
 	raw_spinlock_t lock;
 
 	struct completion ref_done;
@@ -548,6 +550,9 @@ static void io_assign_current_work(struc
 	raw_spin_lock(&worker->lock);
 	worker->cur_work = work;
 	worker->next_work = NULL;
+	/* stays valid while in between two items of a chain */
+	if (work)
+		worker->chain_work = wq_next_work(work);
 	raw_spin_unlock(&worker->lock);
 }
 
@@ -584,6 +589,7 @@ static void io_worker_handle_work(struct
 			 */
 			raw_spin_lock(&worker->lock);
 			worker->next_work = work;
+			worker->chain_work = wq_next_work(work);
 			raw_spin_unlock(&worker->lock);
 		} else {
 			break;
@@ -1073,6 +1079,7 @@ static bool __io_wq_worker_cancel(struct
 static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
 	struct io_cb_cancel_data *match = data;
+	struct io_wq_work *work;
 
 	/*
 	 * Hold the lock to avoid ->cur_work going out of scope, caller
@@ -1082,6 +1089,19 @@ static bool io_wq_worker_cancel(struct i
 	if (__io_wq_worker_cancel(worker, match, worker->cur_work) ||
 	    __io_wq_worker_cancel(worker, match, worker->next_work))
 		match->nr_running++;
+	/*
+	 * Hashed work is taken off the work list a chain at a time, what the
+	 * worker hasn't started yet can only be found here. It doesn't move on
+	 * without the lock. Just mark the work, it fails once it is its turn.
+	 */
+	for (work = worker->chain_work; work; work = wq_next_work(work)) {
+		if (match->nr_running && !match->cancel_all)
+			break;
+		if (match->fn(work, match->data)) {
+			work->flags |= IO_WQ_WORK_CANCEL;
+			match->nr_running++;
+		}
+	}
 	raw_spin_unlock(&worker->lock);
 
 	return match->nr_running && !match->cancel_all;


