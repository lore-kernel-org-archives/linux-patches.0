Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590960;
	b=4o6TG7f8PcEq2+FGJGEhh6Ti6tGRcsVWA2cnAXEhgc3oHcyLmOefGz42jZVjQITsjPZa
	 qMTXb36Qr/fjwpau5pys7mH85uFDMSEjKFpL3fJyEt++crA2sKpRcVnEZaCw3rry/w2rE
	 oadAgDyWdol9twXq2ZU26Wt7Lf8O3L76r/m+ICp+iuibREXZa/qxaA4xIPXXQoSMwbm4G
	 GfPZOmx17WcxTMjDf/HZU0/IQFtYnT2O6vwYPRcpWr6XUccwgI7PP+1+zQmsYCuaS+5oz
	 L0AJE7eGKhz3b5NJi4zV2Qt4I6nS9eEYiRNmcAaXcyGF+svUAr/+39qfre9x9K8Z4Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iM+PfOW1372/WMHvyOPd/uhSZTQCR1nwnP/elfYjykw=;
	b=hRGlwTHcK6WssoklKJSCzt6aFzMDG9nbenJR/wfrSnFv6fVSrpI/2mSxHeKoP9nlKBBv
	 vtli4wVxTlj1U8v5NZvfgFEINnK5FA2Olpf5CiUf0goK8SfVRXURS0p9Ugf09Dgt0p10U
	 xc65VPDfpIC7mYs9JtYPgLRjJdMJeAJoPCvhckIruLoPrXp3v4BuhU09jc2F5xS0DoiT8
	 NyFig1F2sh9SYVDUy8svdDQOrQrR2RRp5YEmOuvHeSEAxBmXoDhoBgdXUcJjNos3EXgRY
	 1BH4wdt4uAqhoaYXhBe8pw+QG7iCUPgYO5D6M+QiKftgUe9SdLMoOCouXFwmCgdyPPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJgr0B8Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E28E606E67F;
	Fri, 13 Nov 2026 17:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJgr0B8Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE79E1F000C4;
	Fri, 13 Nov 2026 17:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590960;
	bh=iM+PfOW1372/WMHvyOPd/uhSZTQCR1nwnP/elfYjykw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJgr0B8YYYB3tFigFn69Ruq5mm+ia2wcKqOPH68IEwylsNXbPZv6VjFB702Ti4HUe
	 PGEyu8DLI400PjsILh5owEH9v27cegClCA3QJaWjraaB+kpIID/k/05K3F3mSgtr1C
	 Dmb/1ii5hXLEjzJhyWWbzZSklATlO1FQQjsIHHN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/670] rose: report a timed out call to connect()
Date: Fri, 13 Nov 2026 10:45:02 -0500
Message-ID: <20261113153816.517065858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

When the Call Request of a connecting socket gets no answer within T1,
rose_timer_expiry() sends a Clear Request and moves the socket to
state 2, leaving sk_state at TCP_SYN_SENT. The neighbour then confirms
the clearing, or clears the call itself, and rose_state2_machine()
calls rose_disconnect() with a reason of 0. sk_err stays 0, so a
blocking connect() leaves its wait with sock_error() returning 0 and
reports success on a call that never got through, and a non-blocking
caller reads 0 from SO_ERROR. The first send() then fails with EPIPE.

Report ETIMEDOUT when the socket is cleared from state 2 while it is
still connecting, as rose_timer_expiry() already does when T3 runs
out. A socket that was released or timed out while connected goes on
being cleared without an error.

On a QEMU bench with two guests, B listening with ROSE_DEFER and never
accepting, A calling it with T1 set to 3 s, twice blocking and twice
non-blocking: before, connect() or SO_ERROR returned 0 in all four
calls; after, ETIMEDOUT in all four. A call to nobody still gets
ECONNREFUSED at once.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit fc29d2c97f98f96d371e20d9b36b5ba08a914ff3)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_in.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/rose/rose_in.c b/net/rose/rose_in.c
index 7a556254ee790..84025b4b498fe 100644
--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -75,17 +75,24 @@ static int rose_state1_machine(struct sock *sk, struct sk_buff *skb, int framety
 static int rose_state2_machine(struct sock *sk, struct sk_buff *skb, int frametype)
 {
 	struct rose_sock *rose = rose_sk(sk);
+	/*
+	 * A call whose Call Request timed out (T1) is cleared from state 2
+	 * while connect() is still waiting for it: report the timeout, or
+	 * connect() and SO_ERROR would find no error on a call that never
+	 * got through.
+	 */
+	int reason = sk->sk_state == TCP_SYN_SENT ? ETIMEDOUT : 0;
 
 	switch (frametype) {
 	case ROSE_CLEAR_REQUEST:
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
-		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
+		rose_disconnect(sk, reason, skb->data[3], skb->data[4]);
 		rose_neigh_put(rose->neighbour);
 		rose->neighbour = NULL;
 		break;
 
 	case ROSE_CLEAR_CONFIRMATION:
-		rose_disconnect(sk, 0, -1, -1);
+		rose_disconnect(sk, reason, -1, -1);
 		rose_neigh_put(rose->neighbour);
 		rose->neighbour = NULL;
 		break;
-- 
2.53.0



