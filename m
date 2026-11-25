Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620506;
	b=mRnY+oj5b/r7VZLVK7fJfAwtd1/gVUesiaNRRnXdInrG3m+mlczzcrJQWnjI0fUXlGEc
	 873c7Tam357kz3JhXxo53yHoIt2gp3vOjlc3hBYVlwC5BuZlYsO0qnPFKLv2T/Zceldkm
	 mvJxTDOw6ciS1np+ikLNY/mMMDflyanzqbWEOIHnfyH8WpwgX5D4UmfQCu3MaO01afGNL
	 1Jlzis0jLIo0wNew/2FioA9PUcCUJ/6VrZ9jnL69CFqflO4sZYz1tXun1v+qZuPVeVbm5
	 f4OqrHGnmBlEdSpeERxpHdF1v/4ID/9gVBUP0xttuxhQ8m4rRhvzTC5UltG5mWD53Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5rfAgP0oTU080xRviVMIYAsN5Pqq+5+snzlI7iG/7v0=;
	b=pq9ZAUvb8xOa+Wl6aCLj56v5jOraS1c57n8oZ+iYRegRk4WX7jPRNRJCZh1Brmagz1Bv
	 4TOmg1NJ2nYrXrDSpF/MZqSt+m4paAkkar8rXxkOJUyvsTlVE4hhzyU39uPpnVuMbaCvf
	 JkdOsk7XNeG9Ea04xGjjWxe0DKYPnJgx9RPqaFpqbHW9Z+FiLH9PvpnqW5gSUmDyo1Sob
	 sZ4xuxV43cYdFDHrIXRABAkPPtuAOOM9R6QqzQeZ9EGMI1F+AVxhUBieG2Qw9QhxwVRQ/
	 +xSXfUPO6et9rCFxVzHkoFB9MNcbTFCkXPy6j/vvJJJIZU9ykkPCDJ8piup2qbrkcCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0lltTU0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AB3606A31E;
	Wed, 25 Nov 2026 15:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0lltTU0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F7A1F000C4;
	Wed, 25 Nov 2026 15:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620505;
	bh=5rfAgP0oTU080xRviVMIYAsN5Pqq+5+snzlI7iG/7v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0lltTU0BXbfBHDj5+4jCexibZs6AUKiwCucDbwoRCVE3vi5YLloVXllx1CZysqei
	 jiMxVT5AqTbf63154YF9dCaxPvcxWo1WCs6CUTKvVnCcSlFLypIzcnAmXw7+dvgUO4
	 +Ee6JikpEuQb2aE7kHth14s11vkE/2e7Vn2XsqeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 7.3 0933/1005] usb: dwc3: gadget: Clear delayed stop on End Transfer completion
Date: Wed, 25 Nov 2026 15:37:51 +0100
Message-ID: <20261125143843.541993711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit f2bd20f92a7dc68980a6098397503067192ce63a upstream.

When an End Transfer command times out outside of the SETUP phase, the
driver sets DWC3_EP_DELAY_STOP to retry it on the next SETUP phase. If
the command completes in the meantime, the flag is left set. Requests
queued to the endpoint are then deferred, and the retry may end a
transfer that is started later.

Clear DWC3_EP_DELAY_STOP when the End Transfer command completes.

Fixes: 4db0fbb60136 ("usb: dwc3: gadget: Don't delay End Transfer on delayed_status")
Cc: stable <stable@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/c28a9660f7b6bfa626077ddcfbadd50e6b503f86.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3872,6 +3872,7 @@ static void dwc3_gadget_endpoint_command
 	if (dep->stream_capable)
 		dep->flags |= DWC3_EP_IGNORE_NEXT_NOSTREAM;
 
+	dep->flags &= ~DWC3_EP_DELAY_STOP;
 	dep->flags &= ~DWC3_EP_END_TRANSFER_PENDING;
 	dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 	dwc3_gadget_ep_cleanup_cancelled_requests(dep);


