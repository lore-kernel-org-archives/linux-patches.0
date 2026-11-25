Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620548;
	b=BpylSUbQv3Z/SrZh6HB5A84R9Z2KJOBY8RPy507xs+zLvxM4zbYkqcXOrZ2i1NoXGkpX
	 tVLB+bvcq23iVJ3F928nekz6gKncY3frcd5SSoGghQ4U7nU0hD4o84YJPuov6eckLMdvS
	 UeHuQ56H22fWsuB141HCGqL0jMlmf4xk/atdyN833FhJnKaKkm435R58dA14eFwyC5KIW
	 2yHzbRellNhCLx0qfEPuVyE6WT4Y2fxdzhBBHQZ/jgAAO8SWy1oILbIYx7ehgVmtPE1kR
	 XLbxaepMjTuYoTOJfjqYCaYNgpiAo9sPRj7UMIEPfJv7FNjHc4OTv8H77i23CNULf8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ctmXe9Bx07bXmXhchdCEPuFfZ71XG3cEC9zH3BLI90w=;
	b=EkbnNzybc6LBzbLxZqCemx4St+jlyzQS12UNqRFzQKFR9woIMa8TyszdsmZyw9rDlgUk
	 NOtQr1bDhCaR0BCHQIMnGkz/WuGYiZFmLIj3ze5cTanqVWGUOnG4iVi1YQg3/6oktThE+
	 dN+4uf1PDoBOXm8VKzJqPFuTmRwTHz1AEy1nZY684D177XW1kncw7Ad+VjU9b+5ARAGkr
	 ICPILDNtIkT3UVilJDOTq03thAN4wc9j9/zJguVr/gSCsJEgHf2XKV0xVlmB7ateciOdO
	 jOFt+FijCJiin5kVXRQgnr1I27q6Bdg2Ypm6YiNL8Kr7N4ebgBCPO98BTUXlNGDttAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7DzAO7z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64544606A31E;
	Wed, 25 Nov 2026 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7DzAO7z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48901F000C0;
	Wed, 25 Nov 2026 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620548;
	bh=ctmXe9Bx07bXmXhchdCEPuFfZ71XG3cEC9zH3BLI90w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7DzAO7z1XXThs+KhVXeJCdFXkzX1vwCmR2E6y1f5bIZCzHfJHwv87yq7EVthQXJM
	 6HqcLkkU5IIZkxPhfGmX8EM3UEouTBwSviA7HTyCZ10PVz5pzxpBa1MKdG3PaaFxuz
	 fUP2xZX9Rj1aDoz+oiMCZt23HoAq2Jujn4tbej4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.3 0954/1005] USB: serial: sierra: validate URB length in instat callback
Date: Wed, 25 Nov 2026 15:38:12 +0100
Message-ID: <20261125143844.020245226@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit a3d43b39032cc5565a5693a10c581844342372cd upstream.

sierra_instat_callback() reads request fields and one byte past the
usb_ctrlrequest header without first checking that urb->actual_length
is large enough.  A short USB interrupt transfer could cause an
out-of-bounds read.

Add two length checks matching the pattern already present in the
option driver (option_instat_callback): one for the request header
before accessing bRequestType, and one for the line-state data byte
inside the serial-state notification handler.  Use dev_err() since
failing these checks causes the interrupt URB not to be resubmitted.

Fixes: 033a3fb980b041 ("USB: Sierra Wireless driver update")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
[ johan: use sizeof(*req_pkt) consistently ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/sierra.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -575,12 +575,24 @@ static void sierra_instat_callback(struc
 				__func__);
 			return;
 		}
+		if (urb->actual_length < sizeof(*req_pkt)) {
+			dev_err(&port->dev, "%s: short transfer\n",
+				__func__);
+			return;
+		}
 		if ((req_pkt->bRequestType == 0xA1) &&
 				(req_pkt->bRequest == 0x20)) {
 			int old_dcd_state;
-			unsigned char signals = *((unsigned char *)
-					urb->transfer_buffer +
-					sizeof(struct usb_ctrlrequest));
+			unsigned char signals;
+
+			if (urb->actual_length < sizeof(*req_pkt) + 1) {
+				dev_err(&port->dev,
+					"%s: short interrupt transfer\n",
+					__func__);
+				return;
+			}
+			signals = *((unsigned char *)urb->transfer_buffer +
+					sizeof(*req_pkt));
 
 			dev_dbg(&port->dev, "%s: signal x%x\n", __func__,
 				signals);


