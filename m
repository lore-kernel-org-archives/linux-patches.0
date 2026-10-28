Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212812;
	b=PVYuJN1ICaMDkkdHUNtfW+iU14M+lt1/9rSePx40RkPLohv6pivhNczxW7zSqxcmvVQ6
	 C0WHvTsrhX1462ppPstuHwwsRmgLDjPmhmQm3ztvaka6Umhal9aiGYvLhL2CnEFZg2G9p
	 UIgYaPq9kjn7F2KHTm7SiaWYBekFNywLmGFy5ux1PQSxROLp8GR1JBNkYGSZ9CI5AXtJ6
	 ih0vd3SgaREKF/4Ytyq/CItgGnzK3bMHFCZjezxd1uBqKhWEgsX5RJp95cVBVdCzcGKUi
	 DI96N0uQ04ahnxdxUu+72P0UtmlsanK6GcJF40IKuvQDpMdkgHato1grSXCpnvyRlQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BnLBmIxmubD6OXsy9TP2S+oPO+389+qacMqOGdIWcdE=;
	b=zI8QoymKLuZA9Fly7vdPz6vsY6dQcI5FlHgDNKx6uEi9hNF5tWWQTLMU5+gd6lTMk1vt
	 eVHeqE+C8+PselKjM8H4gBnS2STysbaJjNMa/6uc18BczOR3AB19a3QQeTx/VNTlq8j9x
	 XGTrle11BYzFaA8oRcDrxyNDdqhQEv67RaU+CpbXfMObN37MD4UW1+QSS3q69kM6VIV08
	 +Rh9Y78Xym1AbH/+PKrIgdnw+lEfZDKRkXrr5/ZlRkVKKoVKlqmSPtvZjZqF0R4+hy9JD
	 kotcefQLq9LKVuyrFU42qxK8A8kIP3HpscbBpY4Ln3v2vmB9fsmh7Bmw3AC/v7+WVCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pLFfcF+t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2659606A31A;
	Wed, 28 Oct 2026 18:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pLFfcF+t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315B11F01825;
	Wed, 28 Oct 2026 18:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212811;
	bh=BnLBmIxmubD6OXsy9TP2S+oPO+389+qacMqOGdIWcdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLFfcF+tcMmhkbASWwos2qCRThOqMBx1GMMf85buwjq9EFzt1X8v6ID7rqcuzvZue
	 Fn4fftB99v2fe/i9e6GjnciHh3ocYiWK6ZFRkq0LuSYWTj8SIEK8iBHuOtc9t8leFw
	 /TVYw6EFve4APqybK8yIY6d/7T5aK9SCB1QU2RSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 0284/1887] usb: typec: tipd: fix uninitialized typec_partner_desc in tps6598x_connect()
Date: Wed, 28 Oct 2026 17:39:40 +0100
Message-ID: <20261028170505.691032863@linuxfoundation.org>
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

commit c4b27b3605788bbf9e4251f3cd4ab94645ab036f upstream.

tps6598x_connect() passes a stack-allocated typec_partner_desc to
typec_register_partner() after initializing only usb_pd, accessory and
identity.

typec_register_partner() copies attach and deattach from the descriptor
into the partner. With those fields left unset, garbage function pointers
may be stored and later invoked from typec_partner_link_device() when a USB
device is linked to the port. Uninitialized pd_revision and usb_capability
similarly leak stack data through partner sysfs.

Zero-initialize the descriptor so optional callbacks remain NULL and the
remaining fields are zero.

Fixes: 0a4c005bd171 ("usb: typec: driver for TI TPS6598x USB Power Delivery controllers")
Cc: stable <stable@kernel.org> # 5.15+
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20260906131942.83153-2-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -231,7 +231,7 @@ static void tps6598x_set_data_role(struc
 
 static int tps6598x_connect(struct tps6598x *tps, u32 status)
 {
-	struct typec_partner_desc desc;
+	struct typec_partner_desc desc = { };
 	enum typec_pwr_opmode mode;
 	int ret;
 
@@ -242,7 +242,6 @@ static int tps6598x_connect(struct tps65
 
 	desc.usb_pd = mode == TYPEC_PWR_MODE_PD;
 	desc.accessory = TYPEC_ACCESSORY_NONE; /* XXX: handle accessories */
-	desc.identity = NULL;
 
 	if (desc.usb_pd) {
 		ret = tps6598x_read_partner_identity(tps);


