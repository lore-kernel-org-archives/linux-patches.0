Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064615;
	b=JB4XCN9qLrQx8D9/ngFhlQTTKnKrNbMdO2558vr+IA5AkJ59pVCAx9rikWmW44/UgN2N
	 Filcg6PuxUFO7RBvSgdzvoVGI6L0rvqxKEGEuK2TatHZ7Fzxx6wOT2Nzk7Q9BlMl4eJsy
	 rS6o7sGyCIUvmX98jmI/gLUFEFvfX0qcASwbDKrshkN61MWSywjgWHVddr8p7RLFnPB7S
	 appbFBzQI0ohS+tQVj2QwBvTdCm6IqXw1RJcYDdvDTQyCBv645xU9aeCUJO28+4en+IQ5
	 vOPmae0LeUFV6zXIyrKWyJmNhRTSFQTIzWPy3Do8I4f2Vfo88N6Qr7SKZH9kL9dgR5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dn/b56h5xwY6SzJxZSlpYzAdJHx8vIEJJvmWwONQytM=;
	b=pQLWuLH5mFvPQdBFuzWlAGHAmKfiPvFRUQ0KVK0c8DN4t9z+3gXlx/z9/s90bZGbD0O4
	 cPYy+b107iS7rx4cnhC9vBY5YhMbDw+4obWXs5rvNrXqe9RINBWAcLDigtn00RkHbXZ2W
	 CSlX1imDJ/fvEsZrgUF79E4h5+iIuClHSRs57HVYId2IC3oWrOcWMGoYOGkyDhJbtP/+x
	 1SRPao/35RHub5P8GTUS33SyP86sk7Zpd12ZfGPY7JFpdNYTTC0pjYDHq6hWLE2clBV10
	 G1sUYp1K/CWSCMGAP7fjRTXFjFT6VMeAzwHzCnvTUw+oHaPrx5W7oFhTp9P7B+VLzqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syM7hxdT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A65606C002;
	Sat,  7 Nov 2026 15:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syM7hxdT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECBD1F0089F;
	Sat,  7 Nov 2026 15:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064614;
	bh=Dn/b56h5xwY6SzJxZSlpYzAdJHx8vIEJJvmWwONQytM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syM7hxdTKregKYf7GCUYlZ4ZO7dQ+P1REFALoJq8coyQqlVubkaykMSycC880amwE
	 Afnmzjuc6t4aYSmGqZQIm4JEgRa59YEsRQgKdsV3j/y7qvO4Lo0tZ//q+2TauSkJLc
	 L4T/zUl+1Aphj4PwlXkdcxFSCt4WwZIHUKVKm+pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Orgad Shaneh <orgads@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0623/1257] usb: octeon-hcd: keep SOF interrupts while a pipe needs them
Date: Sat,  7 Nov 2026 08:48:39 -0500
Message-ID: <20261107134956.503975850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit 68ee2f70d0257aa327ebf8406cd28475574585f2 ]

cvmx_usb_schedule() now sleeps on an hrtimer until the nearest future
periodic deadline instead of counting frames down on every SOF. The scan
that finds that deadline only looks at pipes with

	next_tx_frame > usb->frame_number

which is right for picking the deadline, but two kinds of pipe that
need a SOF to make progress are invisible to the decision:

- A periodic pipe that is due and was *not* started: no idle hardware
  channel this round, its split window is closed
  (cvmx_usb_find_ready_pipe() rejects both), or another pipe owns
  usb->active_split. cvmx_usb_next_pipe() looks at the isochronous and
  interrupt lists only when is_sof is true.

- Any pipe that has sent its start split and waits for the frame its
  split complete may go out in (split_sc_frame, also checked by
  cvmx_usb_find_ready_pipe()). A control or bulk pipe on a full or low
  speed device behind a hub is in this state between its two halves, and
  with SOF masked nothing guarantees an interrupt that brings
  frame_number there.

When some other periodic pipe sets a far deadline - a hub's status pipe,
whenever a hub is attached - the driver masks SOF, arms the timer for
that deadline and these pipes wait for it. That is hundreds of frames;
the code allows up to 8000 (one second) before it falls back to SOF.

Before the hrtimer this could not happen: any pipe with a future
deadline set need_sof, so SOF stayed enabled every frame and the pipe
was retried on the next one.

Note such a pipe and keep SOF enabled while there is one, whether or not
another pipe has a future deadline. Nothing changes when there is none,
which is the case the timer was added for.

Other control and bulk pipes are excluded deliberately: their
next_tx_frame is not updated on completion, so they are almost always
"due" and would keep SOF enabled permanently.

Fixes: aebbc7d63407 ("usb: octeon-hcd: sleep on an hrtimer for far-off periodic transfers")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Link: https://patch.msgid.link/20261011080506.2394708-1-orgads@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/octeon-hcd.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/octeon-hcd.c b/drivers/usb/host/octeon-hcd.c
index 4d6558e5492c2..4929c6a8e733b 100644
--- a/drivers/usb/host/octeon-hcd.c
+++ b/drivers/usb/host/octeon-hcd.c
@@ -1938,6 +1938,7 @@ static void cvmx_usb_schedule(struct octeon_hcd *usb, int is_sof)
 	struct cvmx_usb_pipe *pipe;
 	int need_sof;
 	u64 min_due;
+	bool due_now;
 	enum cvmx_usb_transfer ttype;
 
 	if (usb->init_flags & CVMX_USB_INITIALIZE_FLAGS_NO_DMA) {
@@ -1979,15 +1980,32 @@ static void cvmx_usb_schedule(struct octeon_hcd *usb, int is_sof)
 	 */
 	need_sof = 0;
 	min_due = ~0ull;
+	due_now = false;
 	for (ttype = CVMX_USB_TRANSFER_CONTROL;
 	     ttype <= CVMX_USB_TRANSFER_INTERRUPT; ttype++) {
 		list_for_each_entry(pipe, &usb->active_pipes[ttype], node) {
+			/*
+			 * Do not sleep past a pipe that is only retried from a
+			 * SOF: a periodic one that is due but was not started
+			 * (no idle channel, closed split window, another pipe's
+			 * split active), or any pipe waiting for the frame its
+			 * split complete may go out in. Other control and bulk
+			 * pipes are left out: their next_tx_frame is not updated
+			 * on completion, so they always look due.
+			 */
+			if (pipe->split_sc_frame != -1 ||
+			    (pipe->next_tx_frame <= usb->frame_number &&
+			     (ttype == CVMX_USB_TRANSFER_ISOCHRONOUS ||
+			      ttype == CVMX_USB_TRANSFER_INTERRUPT)))
+				due_now = true;
 			if (pipe->next_tx_frame > usb->frame_number &&
 			    pipe->next_tx_frame < min_due)
 				min_due = pipe->next_tx_frame;
 		}
 	}
-	if (min_due != ~0ull) {
+	if (due_now) {
+		need_sof = 1;
+	} else if (min_due != ~0ull) {
 		u64 delta = min_due - usb->frame_number;
 
 		/*
-- 
2.53.0



