Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051894;
	b=g5xIIgsQRplTFOQrWWnwKamva2DzYJnvo3i2qc8QXPsSvD+2IQLh0OFp8LsdDeOGC4wI
	 S9aFUmDFM634Z1fW0sLPzaZwcXyk7frXFPxUyh2ZD17nYDa1sdYL4dNrQAWTgtQTwgab1
	 Q0ywaVItDMtwVs0TmGiPP6Uv9FDGKXO7K01WyQJPjCK8dCmU6D85Rw1Y9yV7PstUdp6C5
	 M9Df7B0ervCkpibJE72S8NWv1k84WS0bJp6Ocd3l+Rwo5TXlqlhPf/EQ8gExa51WoJtlh
	 vXrJbsecJ685DVJzcsEzXHPilyfdRKEtPXv6SB8M6tuHR/DHR5VVj9OsrmuXJYJ1OKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M1zko1X7jaLnGgpQnWeIrPuTAepmciMLBSJPFIKGhgM=;
	b=I0Iu2JyqpidbA/roOzpolPvDwBacMMMqZM1WZ73uw56pQlvv/0ZFLIAqIvWTLEIUKnt2
	 rdZpOn8s+ResziH48OdIjZPGIjuLcltasK6GqmpcfC8/aVqrC2P3ugC3NF6tG4YxGx/+V
	 T4eUhSA+kIs0uCG30Rd7HQYklUpDrsJJHuFql7QVR39jcIbuusMDeuaY6/ibBpyaNdrLQ
	 Z3rHPHWb/R5TYy3k+0bK0RFnGaKiez/Sg9417CwfaslFCeUuOuvGZ/vwWPBzOhMG72Edd
	 jhhw7zwVXPLKOYWnFHtgWwPTTJa4JsdpmAtPlNMLDX+nUihHx1wWXXWUUpM2PMY26FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bi3/szlx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91E160A383F;
	Thu, 19 Nov 2026 01:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bi3/szlx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D2C1F00929;
	Thu, 19 Nov 2026 01:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051894;
	bh=M1zko1X7jaLnGgpQnWeIrPuTAepmciMLBSJPFIKGhgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bi3/szlxtP6x/Err+ZTRr0F/1oKyycxQpy8yKZ/LcA/PvkHFt+AeN7RraGb0oFnfr
	 QXbaaPRE90F3wEy8Vhvx2KrWV1zzfilPVYKaDQ3HPA+QFK0uMM1Rxu6FxlOTtojoX3
	 Eoel5exGbmgNoQVZhP865wv0NGZHv94CwIvdhnOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.15 0372/2214] HID: core: Fix out-of-bounds left shift by 32 in s32ton()
Date: Wed, 18 Nov 2026 15:34:08 +0100
Message-ID: <20261118150025.604902837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 5fe63b415c636c7f4f6848a8e53bdd4bbf0c300d upstream.

Syzbot reported an out-of-bounds shift (32-bit integer shifted left by
32) in the s32ton() routine in the HID core.  This routine converts a
signed 32-bit integer to a signed n-bit integer, and it caps the value
of n at 32.  But when n == 32 there's no need to do anything; it can
simply return the input value.  This will avoid calculating (1 << n)
when n is 32, which was the cause of the invalid shift.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 69c02ffde6ed ("HID: core: clamp report_size in s32ton() to avoid undefined shift")
Reported-by: syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/6ac9cbd8.a150a118.27e199.0025.GAE@google.com/
Tested-by: syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/dfa0aa1c-e55e-4316-8307-f72a07383634@rowland.harvard.edu
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1360,8 +1360,8 @@ static u32 s32ton(__s32 value, unsigned
 	if (!value || !n)
 		return 0;
 
-	if (n > 32)
-		n = 32;
+	if (n >= 32)
+		return (u32) value;
 
 	a = value >> (n - 1);
 	if (a && a != -1)


