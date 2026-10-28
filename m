Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212513;
	b=Gwi9swdP75VtHze0Ds+z5mlw7s7e/XjOsdG4r5bssMq7cpKO+CqEMgnReqCm4DizUwSZ
	 gZOEJ2hgUgjaPUpuKyRIExizv7KRoaELwPQOoU8oaQz4jheCawBxgqIBZOxJVe5kT9Z1x
	 QfxJKZqOFfEc+YHnHjjme/WIqAJMa6ANZpkJdsPwtEnK6ecyLUWaIw1EoicYzc8URCqrY
	 leSJrZiTlwYasKATjYIJS8L56ScG1ZhTRK1aoQLFerZDaHuKr8Hf6+qgW3Xm3Cibzye9R
	 8Uhza6qpZsw3W3nmhYUdhAATs8eNzGPtyUgCODfD8f+rvnWzRV9Haw9htPdXLZCjWeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yYGrHkp+U4ZU/KXhuAZWdldAAKD2PNTsMIBxcG2Z5VQ=;
	b=dV6HWpTQfiuHB65Vsd3vzr2eZPAx6YngRLmwKZIcLWJwm3zbZ6ghqqrFKVTdtWGYgxLh
	 VCN2BevUljyRJXEW3y4ljUIdBtFoILY3JNYGaYEW4eD6m4mC/I7nz5lFRwf0KaI2B3udf
	 En/FtJ1IevQ0Id4EdX+M3SJymNHFrns7X82YzCpC2n8G5QDZ/JHFnaPjukK70tQfCsbwe
	 i0F25LVpj7/Y6b/0YGiOkbl9s4BLWzT3+Q0rpcQupqW81mIStf7opptY75ZlEggZSFlU8
	 vtrNbSsJlEqlzkkBPxSZ5m5q5fSj7I9bQsjs+DRVn1Z1eGRFEJ8OdyoS1IADGSvp54A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fZLVY4Dx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FB7606A31C;
	Wed, 28 Oct 2026 18:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fZLVY4Dx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2115A1F01825;
	Wed, 28 Oct 2026 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212512;
	bh=yYGrHkp+U4ZU/KXhuAZWdldAAKD2PNTsMIBxcG2Z5VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZLVY4Dxo867iPP/UpoJArs7FJ49m3PYic6xI+25kp8c3A89xQzooXntaUeAR7BCS
	 +w6MuaRuYSvfnY6BzTjMLnT2Q2NjMgWggwgm+wW9OfAKiY11j5Z4wjg9r69apwqU59
	 G70StOOhdkFHS7+mgf4NBxQua6l8bJLjUMnBBTho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Jun Yang <junvyyang@tencent.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0180/1887] sctp: check RCV_SHUTDOWN after the sendmsg connect wait
Date: Wed, 28 Oct 2026 17:37:56 +0100
Message-ID: <20261028170503.333127892@linuxfoundation.org>
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

From: Jun Yang <junvyyang@tencent.com>

commit 4f1da630d13de0370e2f6361f961f1c8b384af1c upstream.

sctp_wait_for_connect() drops the socket lock while it sleeps. An
out-of-the-blue ABORT can then be processed from the socket backlog and
unlink the association. If a concurrent shutdown(fd, SHUT_RD) sets
RCV_SHUTDOWN, the waiter breaks with err == 0 before checking
asoc->base.dead. Its final sctp_association_put() can then free the
association, leaving sctp_sendmsg_to_asoc() to continue with a dangling
pointer.

Check RCV_SHUTDOWN along with the wait error in sctp_sendmsg_to_asoc()
before using the association again. The check only accesses the socket,
so it needs no additional association reference. Return the existing
-ESRCH so that sctp_sendmsg() skips freeing a new association that may
already have been destroyed.

Keep sctp_wait_for_connect() unchanged to preserve its behavior for the
connect() caller.

Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260926095606.68601-1-juny24602@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1842,7 +1842,7 @@ static int sctp_sendmsg_to_asoc(struct s
 		if (asoc->ep->intl_enable) {
 			timeo = sock_sndtimeo(sk, 0);
 			err = sctp_wait_for_connect(asoc, &timeo);
-			if (err) {
+			if (err || sk->sk_shutdown & RCV_SHUTDOWN) {
 				err = -ESRCH;
 				goto err;
 			}


