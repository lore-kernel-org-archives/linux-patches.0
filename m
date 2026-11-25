Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620181;
	b=zxBpVEN1TGMpS34hrWdJfcWBBRq1TKjVC9ZP9Hs6OQgzJH3BPaUiR/bIKhNJOr3hwBQN
	 ORemQJIeboueROD8q9h/2YAIOOBrnTO5qoYB4d+caC6tW0OFIzNZWBbqg2eqYcyYzlJjQ
	 gFoSiQt1jm/JeM9HW4R0/N/5Cf44PCwj9M5EtHZNHHN8mC8/TCFKxI1NvILtS4FHaHsA+
	 R8kDW6xSmdVlT3g2Sm5qZ2ngTSEQMbe864+Tt3Eo9mVvoWW6RXKncg4+SA3qk9wHL8F+0
	 bBQjT0x7KQPpz3XGFFFvqnG9WWj9hmCso5NS5Yd+IzeKtr8IoDXtArpzp0hD+woKhig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fLcP4YF8nMWGuoRbg/kX3NVjcQTducTHiqTxaM9iJf8=;
	b=ggvMKK4g/sH+S3yaqWa2K3uNB6vO1BDAfcPZ+IO5l+RVu9jfIXbcUrVDQsuc6NUDO7KV
	 O87WQTbdoGAI8IDgh3btNXa6ir9mqcOfuU86dM62Df6NJZpujbLINDdCcWemZBv46CMmx
	 QtsxVzK6iwrz3m8qSt/GzhejSnM6uC9XLiKHFEiGKlp6Pxe1s9fRfVgq2gxeFX3TfAOQ5
	 IgaXFNmi1gJPolwWOCC1RubdLA5o9pm+D3pid63jNRzwshgdti/5kUu/w/8b+fMPRdoKZ
	 M81fEk4OHQkJHFjUjAcv8xD/4wXPwYLes3zUwAFZihgozce59uU4+83EGvQ0fi2i63w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vn+spWVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE85606A327;
	Wed, 25 Nov 2026 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vn+spWVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910171F000C4;
	Wed, 25 Nov 2026 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620180;
	bh=fLcP4YF8nMWGuoRbg/kX3NVjcQTducTHiqTxaM9iJf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vn+spWVGfwJ9sGrjEvrHM4Gkpyez3ZgD8rVwc9mB+JoFWzR0eMqpYFob6TUD9U4FI
	 ZYsApqmsi05+9/rR4xFhRiAMimDfHCl9/xnEMByOnH415Yb0uSMaKLAoRSc00/14/l
	 UbDhWE3tbg883+vHcdrvr+GzI3w5OzRw1yRLsb9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liuyong <pkfxxxing@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0833/1005] smb: client: compare owner and group SIDs using their encoded lengths
Date: Wed, 25 Nov 2026 15:36:11 +0100
Message-ID: <20261125143841.235002663@linuxfoundation.org>
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

From: liuyong <pkfxxxing@gmail.com>

commit a2dabe73ea05ad3b3f8e1cc08fb2e7c2ddc5564b upstream.

populate_new_aces() compares owner and group SIDs over sizeof(struct
smb_sid), including storage for all 15 possible subauthorities. Received
SIDs contain only their encoded subauthorities. The comparison can read
past the security descriptor, as shown by the supplied KASAN report for
a 44-byte descriptor during chmod.

The input SIDs have already been checked by sid_from_sd(). Require equal
subauthority counts, then compare only the fixed SID header and the
encoded subauthorities with memcmp(). The count check ensures that both
validated SIDs contain the number of bytes being compared.

These issues were discovered and fixed by Qihoo 360's Tulongfeng
multi-agent system.

Fixes: 0f22053e811c ("cifs: Fix unix perm bits to cifsacl conversion for "other" bits.")
Cc: stable@vger.kernel.org
Signed-off-by: liuyong <pkfxxxing@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1134,7 +1134,10 @@ static void populate_new_aces(char *nacl
 	 * updated in the inode.
 	 */
 
-	if (!memcmp(pownersid, pgrpsid, sizeof(struct smb_sid))) {
+	if (pownersid->num_subauth == pgrpsid->num_subauth &&
+	    !memcmp(pownersid, pgrpsid,
+		    CIFS_SID_BASE_SIZE +
+		    pownersid->num_subauth * sizeof(__le32))) {
 		/*
 		 * Case when owner and group SIDs are the same.
 		 * Set the more restrictive of the two modes.


