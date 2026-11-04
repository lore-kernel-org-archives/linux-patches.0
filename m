Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826890;
	b=lCUf/cdPf9Z96/YwsIU7G2SdWMGSSrld+S3CPd41AeIlp2z08qLV4wfXqPIIO0vsTZpN
	 10m2asdWo2ar6Ao0VZXBsgvGO1H0B5C/AGCzxkySqXLLewSd9h95uWP3caLJVYL3Y2N6r
	 4TLF75h7jJsDa2mvUTmG7zOvFmf+shmi6d7LeMalzK4NJRd6/eH2iNRRXHrPye5guBlAz
	 gX+49EYUZyDdBRqyfAi2bm47C3qsqtJiHlK49Iz+Ia12/bnLRRxRz8eR1Xu5KEzeTiNGD
	 U/Y0vil6+vcc7NQimOlVNdaWsUoBCbm2xNjmx4O39f2xVAE1lWuCk25u73NG1kWP2Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lgQZUzuKmQKYJMmHJGvwXUOxiL+MscIBeL4exR4rhXY=;
	b=hpyBJmJA+qUAx9vsMVFzeMbXSKBT/Q2q25c97C/U+97Vr+PsqxIIiu0wyvnp4515b3Sd
	 MMSPwE0Md7+uEtmVe+MgvrcJwvjC1HWtKVkGiCXt4LEvt0VkRX3/XLRRCTos2RduVKyvp
	 SSY5AuPLY+M2Saj791/yWyA+coBywMMdwdC06+ocV2xoIg+7okBV9IJkHRU+1lyz6I63y
	 JlLc1Dq+FVT3MPxfCzgh2yWvyEPLo7BFkVUaX/emaJ1RrJYtHVqlQkb4Ai5nqLjqBZP9S
	 pAw2w0/tuARtse7A5METrqT8jDrZS60HtASJSAh3zF/pYCeXKC/xCu7I1zsjF9/uG2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxQhqcNg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0914A6070745;
	Wed,  4 Nov 2026 21:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxQhqcNg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADD11F00919;
	Wed,  4 Nov 2026 21:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826889;
	bh=lgQZUzuKmQKYJMmHJGvwXUOxiL+MscIBeL4exR4rhXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxQhqcNgVM3KRJsimPMdKya8JMYXSVuYLHMB60lRhOJJlsHWh2N1hlCJJlJJEIaf2
	 co6G4AZsx9RbfIDyZBFAuqNPiKLz+fsccYpP2uNTKbwJiCHyuLVD8ExlGniN3jhB13
	 vtsShvsUsgXBgsDnyFwZcomNdzEZyY3ScQPiExVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Podgorny <radek@podgorny.cz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.3 068/547] Bluetooth: forget a peers RPA once it advertises its identity address
Date: Wed,  4 Nov 2026 16:04:12 -0500
Message-ID: <20261104211040.198772065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Radek Podgorny <radek@podgorny.cz>

commit 3889a5fcd091d2154861c19e9c581f9f04aabd0e upstream.

hci_connect_le() dials the RPA cached in the peer's IRK whenever one is
set, on the assumption that a peer holding an IRK is on air with a
resolvable private address. A peer that stops using privacy breaks that
assumption: it advertises its identity address, the cached RPA keeps the
value it had before the change, and the host aims at an address the peer
has abandoned.

Nothing clears the cache. hci_find_irk_by_rpa() refreshes irk->rpa each
time an advertisement resolves, so it tracks rotation, but a peer that
stops sending RPAs stops producing the reports that would update it, and
the stale address then survives until the adapter is powered off.

On the path that creates the connection object this is currently masked:
__hci_conn_add() resolves the cached RPA back to the identity address, so
that is what goes on air. It is not masked on the reuse branch, which
copies the swapped address straight into an existing conn->dst, and the
next patch removes the conversion for the case where the controller
cannot translate an identity address, so the stale RPA would be dialled
there too.

Clear the cached RPA when the peer is seen on its identity address.
hci_find_irk_by_addr() only matches public and static random addresses,
so an unresolved RPA belonging to some other device cannot reach this
path.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Radek Podgorny <radek@podgorny.cz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6311,6 +6311,15 @@ static void process_adv_report(struct hc
 	if (irk) {
 		bdaddr = &irk->bdaddr;
 		bdaddr_type = irk->addr_type;
+	} else {
+		/* The peer is on air with its identity address, so whatever
+		 * RPA is cached for it has been abandoned. Drop it, or
+		 * hci_connect_le() would swap it back in and dial an address
+		 * the peer no longer answers.
+		 */
+		irk = hci_find_irk_by_addr(hdev, bdaddr, bdaddr_type);
+		if (irk)
+			bacpy(&irk->rpa, BDADDR_ANY);
 	}
 
 	bdaddr_type = ev_bdaddr_type(hdev, bdaddr_type, &bdaddr_resolved);


