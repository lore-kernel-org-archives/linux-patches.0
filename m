Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590234;
	b=jXg2O/DmEsbTN84NnkEuWG2YrGuShoKCQ2aX0q2piBF2E4ClznZ5OE1BHwQATfFtDEqO
	 4Lf7EzpT5uVm9qR430DWdEe/9h3jcbLkrmoIiqP4CXbXBQgwYDD3Vf/aTynHIZgROd12h
	 N13AnWx/a1Ijv6dR7uRAZ7FFy3R/hiiuvQ13aMG44IpP0w7uLflaT12dTtP3jR3zGPv0p
	 +LMe5r/05VvjAohLSgd5cF4uJ66B69jHlRdmKYf5jXYEGfjKHZFXeJ3cZy68uHKddLOPl
	 ZKWwdlIm2+5scWyKW48n3AaQa/h8FbnWJs7qqcISICY0TONgyfjTP7QV5JTZsgaDaCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zxlcqecer0jmHl577LmZuZEjVo0CPSyPkhGK76PSbhU=;
	b=cOA92a5We06hua+UK5eClS+jG5tcuNV8MXQNg0Do0DJGrWSJkqlwZvJNC7fY7eP6bzdz
	 JDhAKsKdpr7jOCeIgvmwDU/7dDf7Mx+PaSjt+HnIKcDl0HsqP5zl3pcix98qkVFn5994V
	 YHxdF8HJ20np74gDoh7fCCSH7hUycCqGZezo5pegstUmVUhHa3Rd1R7Dnjrb2/kVUSyY7
	 vI9XdnLxiXAI+1x8RnXd6fERXihvgrECbca1HXONOqi8oI9zR6L+NmUjjm2BBqqHXKvnu
	 2rN2tOQtUN99Sx8NPCpQNAm1XfLllrM58bDIjYsMA2Xh23JmLJhOFkOc3wnrBzI9m0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqCwlD1t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7332C6075E19;
	Fri, 13 Nov 2026 17:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqCwlD1t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAF81F000C5;
	Fri, 13 Nov 2026 17:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590234;
	bh=zxlcqecer0jmHl577LmZuZEjVo0CPSyPkhGK76PSbhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqCwlD1tbQHvmPu8mMSVZeNf4yrbm39ylnyJGNpwr21mXzeUSaOan2exkdCujtmkB
	 mgK89tc2xExw+4RlEvhfgcDNLmND9QimjEq8vVgOY+wY5/QYrJgTA2WDt4bb0jGa1v
	 Z6Him8EriqSXfHtuM9UjjNSCf/rxbK9bFaxZP9lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 191/686] net/9p/usbg: remove bogus context initialization in alloc_requests
Date: Fri, 13 Nov 2026 10:45:24 -0500
Message-ID: <20261113153827.532028696@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <mgr@kernel.org>

[ Upstream commit bbdb38b2e543ffa72dca5450f2535cf998ef1cdd ]

alloc_requests() initializes usb9pfs->in_req->context to point at the
struct f_usb9pfs instance itself. usb9pfs_queue_tx() later overwrites
this with the real struct p9_req_t pointer before every transmit, and
usb9pfs_tx_complete() clears it back to NULL after each completion, so
in_req->context only ever holds a valid p9_req_t once a request has
actually been queued.

usb9pfs_clear_tx(), however, can run at any time (mount close, gadget
disable) independent of whether a request was ever queued. If it runs
before the first usb9pfs_transmit(), it reads the leftover sentinel
value, type-confuses the struct f_usb9pfs pointer as a struct
p9_req_t, and both writes through it (req->t_err = -ECONNRESET) and
hands it to p9_client_cb(), which manipulates req->wq and req->refcount
at bogus offsets inside f_usb9pfs. This reliably corrupts memory or
panics whenever the transport is torn down before any 9p request has
been transmitted, e.g. mounting and immediately unmounting, or a cable
disconnect racing the very first request.

usb9pfs->out_req->context is set the same way but is never read by
this transport (usb9pfs_rx_complete() identifies the instance via
ep->driver_data instead), so it serves no purpose either.

Both endpoints' ->driver_data are already set to usb9pfs in
enable_endpoint(), which is what the completion handlers actually use
to recover the f_usb9pfs instance. Just drop the leftover
->context assignments; usb_ep_alloc_request()/alloc_ep_req() already
return zeroed requests, so in_req->context correctly starts out NULL.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260922-usb9pfsfixes-v1-6-9d8dcc52904c@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index 301123725a671..ed8f01ead839a 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -313,10 +313,6 @@ static int alloc_requests(struct usb_composite_dev *cdev,
 	usb9pfs->in_req->complete = usb9pfs_tx_complete;
 	usb9pfs->out_req->complete = usb9pfs_rx_complete;
 
-	/* length will be set in complete routine */
-	usb9pfs->in_req->context = usb9pfs;
-	usb9pfs->out_req->context = usb9pfs;
-
 	return 0;
 
 fail_in:
-- 
2.53.0



