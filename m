Received: from mail.sf-mail.de (mail.sf-mail.de [116.202.16.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBBA2564
	for <patches@lists.linux.dev>; Tue, 11 Oct 2022 09:15:00 +0000 (UTC)
Received: (qmail 3812 invoked from network); 11 Oct 2022 09:14:33 -0000
Received: from p200300cf070e3b005801a0fffe58235d.dip0.t-ipconnect.de ([2003:cf:70e:3b00:5801:a0ff:fe58:235d]:45414 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
	by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
	for <linux-kernel@vger.kernel.org>; Tue, 11 Oct 2022 11:14:33 +0200
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org, patches@lists.linux.dev, "Jason A. Donenfeld" <Jason@zx2c4.com>, Andrew Morton <akpm@linux-foundation.org>, "David S . Miller" <davem@davemloft.net>, kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v6 5/7] treewide: use get_random_u32() when possible
Date: Tue, 11 Oct 2022 11:14:44 +0200
Message-ID: <2659449.sfTDpz5f83@eto.sf-tec.de>
In-Reply-To: <20221010230613.1076905-6-Jason@zx2c4.com>
References: <20221010230613.1076905-1-Jason@zx2c4.com> <20221010230613.1076905-6-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3381436.Qahr9VaOg4"; micalg="pgp-sha1"; protocol="application/pgp-signature"

--nextPart3381436.Qahr9VaOg4
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Tue, 11 Oct 2022 11:14:44 +0200
Message-ID: <2659449.sfTDpz5f83@eto.sf-tec.de>
In-Reply-To: <20221010230613.1076905-6-Jason@zx2c4.com>
MIME-Version: 1.0

Am Dienstag, 11. Oktober 2022, 01:06:11 CEST schrieb Jason A. Donenfeld:
> The prandom_u32() function has been a deprecated inline wrapper around
> get_random_u32() for several releases now, and compiles down to the
> exact same code. Replace the deprecated wrapper with a direct call to
> the real function. The same also applies to get_random_int(), which is
> just a wrapper around get_random_u32(). This was done as a basic find
> and replace.

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c index
> d0a7465be586..3a7aded30e8e 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
> @@ -177,7 +177,7 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp,
> struct brcmf_pno_info *pi) memcpy(pfn_mac.mac, mac_addr, ETH_ALEN);
>  	for (i = 0; i < ETH_ALEN; i++) {
>  		pfn_mac.mac[i] &= mac_mask[i];
> -		pfn_mac.mac[i] |= get_random_int() & ~(mac_mask[i]);
> +		pfn_mac.mac[i] |= get_random_u32() & ~(mac_mask[i]);
>  	}
>  	/* Clear multi bit */
>  	pfn_mac.mac[0] &= 0xFE;

mac is defined as u8 mac[ETH_ALEN]; in fwil_types.h.

Eike

P.S.: CC list trimmed because of an unrelated mailer bug
--nextPart3381436.Qahr9VaOg4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCY0U0BAAKCRBcpIk+abn8
TnN3AJ9qs8NaSunt7ijB2AR/P9fJUTF1VACfYISp1yW4g9+IC2YL331uQQXDH+I=
=wPNj
-----END PGP SIGNATURE-----

--nextPart3381436.Qahr9VaOg4--



