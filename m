Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEB9378D8C;
	Mon,  4 May 2026 14:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903286; cv=none; b=LM8/a39rTXEgfNLjx8ERPXTRcDuY13Z8z9PxD5i1GCgP5TXOIHXV21WFFSCwY6qTOh3CdDLEWPwpwJHFDVSoSnCxqIlIQJSLwj0N9HtmI2VHNrSVOLaJ9zBQ1IvqmXh4fLWtEw4EEF8nngZV/yC0Ud6kuYCYn5u0SfRJvOSn3+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903286; c=relaxed/simple;
	bh=Lj5jqLxr7GzoKsUyG2xZ2OFJz+h/SE4Zpkc7d+miRSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRD8yaU2OZqOG6IyEwht0yZRnKfUV5MGD0jioaiUALw4jzXC/CN23J7kcsYjJ22HsQ2dWU1KMZ2jZ4TsPKDJtacEwPIJPEkYOn5N3wrceBY48yifJu4GFLkoWFGKbN/g9X2zI7/QpQwG/WyX57Lu0tgBB5qtAN8a+mL1nIKPkIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4Y5CGgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4Y5CGgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F2EC2BCB8;
	Mon,  4 May 2026 14:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903286;
	bh=Lj5jqLxr7GzoKsUyG2xZ2OFJz+h/SE4Zpkc7d+miRSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4Y5CGgl3Bp+vhBcCA2EBGkLqSLgoauHsyIQ1DBGQ9xkeU/2f43a9ES+xvX5Wdd5e
	 ORdq7e9HsJ0tdFp/qSKLiYAuFMP/m5IegZ49n9kCvkFtR/+LEOFhhw4Nc+dXh8k+5u
	 Dd+8sEtqgk15SOtikVOSiosCWhR64UqI/ok76R3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 132/307] rxrpc: Fix rxrpc_input_call_event() to only unshare DATA packets
Date: Mon,  4 May 2026 15:50:17 +0200
Message-ID: <20260504135147.756554770@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 55b2984c96c37f909bbfe8851f13152693951382 upstream.

Fix rxrpc_input_call_event() to only unshare DATA packets and not ACK,
ABORT, etc..

And with that, rxrpc_input_packet() doesn't need to take a pointer to the
pointer to the packet, so change that to just a pointer.

Fixes: 1f2740150f90 ("rxrpc: Fix potential UAF after skb_unshare() failure")
Closes: https://sashiko.dev/#/patchset/20260422161438.2593376-4-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260423200909.3049438-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_event.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -332,7 +332,8 @@ bool rxrpc_input_call_event(struct rxrpc
 
 			saw_ack |= sp->hdr.type == RXRPC_PACKET_TYPE_ACK;
 
-			if (sp->hdr.securityIndex != 0 &&
+			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
+			    sp->hdr.securityIndex != 0 &&
 			    skb_cloned(skb)) {
 				/* Unshare the packet so that it can be
 				 * modified by in-place decryption.


