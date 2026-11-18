Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030915;
	b=zYvQGK4Ra9mXIwpAyc/YyrM9OHxpKQ2r9HRbLPxBBp9bo6Q96Hm0aC1rxuvJM/ql1Im1
	 YnKe7sgyMAwfCV2ClZx/Xk+aJO0hDUmnfdwNaUIluns3CVs86uffrqkCm/R2BOZecDMLz
	 gHYgNqs26JtA0kE+uCK8nDLMEi9yosFwQuHQ3lNMooD48/ZC4gozdINr5df8vPqwMWnKe
	 80q/sN9agOsu2TkLTgvB4LbXrb5Dz0NOMbwo20T4zb29znxxB9gTj7sx+ZCMoIVRms223
	 0FeufGmarixLfCfpQXkYOZrt4pWxjGS0WaJF5Wiw4W4rb7JqAWhhQR2xfM8C6FZzLfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A41BUfFEuJ9ksnajwPho5/IxysXO2e/vrGjT5YFWG74=;
	b=lYh83C16eO66VpwXcB+IGmrex0VSMds+9eQVXpGPdxYYIuQqn5AvATCH00Vbfi3aJEKQ
	 xa2GZdIGb6hweASLJPCaZ5WqUxv++tjE0olOH24OyVeNf9Ikp4SzBvzKNxN0nx0ZFJ2tz
	 bhK8U0tlv/Kah045hGX1h/CteRehd3MXuFP1WsO1mYiq7BbDrZfDe4kAJ3CBr2zdKacP/
	 oT4ee3XAUgrzQBGonxxS/GSGEiw6EtKETAdlpvTWun8JAwoJRQFRttF3aGNsqXTpwDddV
	 CbLq8WQQv+y094DnvmnXZ5be0apmE1WyUmrRTSqm3QcwiLeMBsuu0k28/kpTV9NCy3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0CJNR9cQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCD7606A331;
	Wed, 18 Nov 2026 19:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0CJNR9cQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF201F000C7;
	Wed, 18 Nov 2026 19:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030915;
	bh=A41BUfFEuJ9ksnajwPho5/IxysXO2e/vrGjT5YFWG74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0CJNR9cQvy99uI7tGE1pzy45e49L6nqZ8fvg7vsyPU/NjzpWP4xFOuEMNaSrkdpve
	 jJOCu8+W7w5g8MBhZiVO1xvk3UNcWQIpXpiNbFKqmAEcXACaoPhVhfSiXMXJvmC1fn
	 mn9COxGwa+c8+79IM4BrKCkyafvTyX1vpToADeMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0871/1756] SUNRPC: treat every client-side TLS error alert as fatal
Date: Wed, 18 Nov 2026 15:49:58 +0100
Message-ID: <20261118150044.030108425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 9b7b1f89b93a3ec1ed121e1ab28450acde815bff ]

xs_sock_process_cmsg() decides whether an alert ends the session by
reading the alert's level octet. RFC 8446 Section 6 retired that
field. The severity is implicit in the description, and a receiver
treats every alert listed in Section 6.2 as an error alert
"regardless of the AlertLevel in the message". A peer that aborts
with unexpected_message but leaves the legacy octet set to warning
makes the client return -EAGAIN. xs_stream_data_receive() wakes no
pending task for that error, so RPC Calls queued on a dead TLS
session wait for their timeouts to expire.

Decide from the alert description instead. close_notify and
user_canceled are the closure alerts (RFC 8446 Section 6.1). Every
other description ends the session, including one this kernel does
not recognize.

Fixes: 39067dda1d86 ("SUNRPC: Use new helpers to handle TLS Alerts")
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index ec7b29780eb94..a1f4fd26029e5 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -375,8 +375,18 @@ xs_sock_process_cmsg(struct socket *sock, struct msghdr *msg,
 		break;
 	case TLS_RECORD_TYPE_ALERT:
 		tls_alert_recv(sock->sk, msg, &level, &description);
-		ret = (level == TLS_ALERT_LEVEL_FATAL) ?
-			-EACCES : -EAGAIN;
+		/* RFC 8446 Section 6: every alert but a closure alert is
+		 * an error alert, whatever the legacy AlertLevel octet
+		 * says.
+		 */
+		switch (description) {
+		case TLS_ALERT_DESC_CLOSE_NOTIFY:
+		case TLS_ALERT_DESC_USER_CANCELED:
+			ret = -EAGAIN;
+			break;
+		default:
+			ret = -EACCES;
+		}
 		break;
 	default:
 		/* discard this record type */
-- 
2.53.0



