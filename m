Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7487C
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 12:09:51 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id 6-20020a9d0106000000b006a177038dfeso8040061otu.7
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 05:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mvista.com; s=google; t=1680610190; x=1683202190;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8oPqY1zqTSWWuFnXYMk5IRfPfNzCYHrrnpEWXw2ihf8=;
        b=fdH/nSXOZTLegg7uXy2m9wy3hloclX7py/atjby6rWeA3xM8va6QFJ+RpKx3xeW9gr
         QPiUhnst5d88WszM2O99auPj5zqSjsmSzmVZOqjdYgtvqVH7j25dKMVwIKea/W+jIatL
         LIjJMOPMtoaoiX/I7VGOAh3CkeMku93NinlHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680610190; x=1683202190;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8oPqY1zqTSWWuFnXYMk5IRfPfNzCYHrrnpEWXw2ihf8=;
        b=zEL2am2aENufQcCvSlqlHBFerdZjZSHAZ2isSyRmjd51tYO405roZIJCozFFPsiHbv
         0FBmD3YGnLtFtaokzecbviLrofsNKLgCBa/rubvJwKLzygTDtcBddw773JkJzXV8Tfzn
         4u+Lhv63b27MjheWU5JX0dod4JPCOlVbZ5uyNHv9SJqFayms77hagfDHGBPQN49ev31R
         GBlLIVuX3mc0DIP82G9KH+4KgMzWSPvL1jPKJxTiro7guv87/9ByJvWXdghZUB98kFzg
         MDf9pooAHHnXJBxeYxwiKgNYnhTt2hoz3b26jaUbzRcYhIJDJlnHQOBFVx4Ujx1/KYQi
         lcvQ==
X-Gm-Message-State: AAQBX9cuF6TWmdJjSjADkgu1MoJgehOV5EbMbo8OO2Mup1KETpmK9FON
	XACriv6J8yqpChFOfZq25k64VA==
X-Google-Smtp-Source: AKy350YelewO7iZrNwA15nomYKdzpattSgg57tmGLnlFTYYrFtOL58RfYzLIzxoragqjuRCu1ekHXQ==
X-Received: by 2002:a05:6830:2782:b0:6a1:23db:b139 with SMTP id x2-20020a056830278200b006a123dbb139mr1298454otu.0.1680610190295;
        Tue, 04 Apr 2023 05:09:50 -0700 (PDT)
Received: from minyard.net ([2001:470:b8f6:1b:75b6:e1c2:d759:60f9])
        by smtp.gmail.com with ESMTPSA id df5-20020a056830478500b0069d602841e7sm5320338otb.72.2023.04.04.05.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:09:49 -0700 (PDT)
Date: Tue, 4 Apr 2023 07:09:47 -0500
From: Corey Minyard <cminyard@mvista.com>
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 006/173] ipmi:ssif: resend_msg() cannot fail
Message-ID: <ZCwTiwWHOJPKxnpQ@minyard.net>
Reply-To: cminyard@mvista.com
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140414.435644519@linuxfoundation.org>
 <ZCwIWfSovPxvPzU2@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QOR+sTD+KrZFOVlt"
Content-Disposition: inline
In-Reply-To: <ZCwIWfSovPxvPzU2@duo.ucw.cz>


--QOR+sTD+KrZFOVlt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04, 2023 at 01:22:01PM +0200, Pavel Machek wrote:
> Hi!
>=20
> > The resend_msg() function cannot fail, but there was error handling
> > around using it.  Rework the handling of the error, and fix the out of
> > retries debug reporting that was wrong around this, too.
>=20
> > @@ -909,31 +909,17 @@ static void msg_written_handler(struct ssif_info =
*ssif_info, int result,
> >  	if (result < 0) {
> >  		ssif_info->retries_left--;
> >  		if (ssif_info->retries_left > 0) {
> > -			if (!start_resend(ssif_info)) {
> > -				ssif_inc_stat(ssif_info, send_retries);
> > -				return;
> > -			}
> > -			/* request failed, just return the error. */
> > -			ssif_inc_stat(ssif_info, send_errors);
> > -
> > -			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
> > -				dev_dbg(&ssif_info->client->dev,
> > -					"%s: Out of retries\n", __func__);
> > -			msg_done_handler(ssif_info, -EIO, NULL, 0);
> > +			start_resend(ssif_info);
> >  			return;
> >  		}
>=20
> ssif_inc_stat(ssif_info, send_errors); disappeared here, is that
> intentional?

Actually, ssif_inc_stat(ssif_info, send_retries); is the thing that
disappeared, since start_resend() cannot fail.  Thanks, I'll get in a
fix for that.

-corey

>=20
> Best regards,
> 								Pavel
> --=20
> DENX Software Engineering GmbH,        Managing Director: Erika Unter
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany



--QOR+sTD+KrZFOVlt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/Q1c5nzg9ZpmiCaGYfOMkJGb/4EFAmQsE4UACgkQYfOMkJGb
/4ESlA/+LTl+LFdmRMQ8AsPElqqJJERgZeiXD9BkcetNuf0i+8GrKSAR/BbdKXrp
oaofSpuFjT3C9epLiTBiiETCwjJtDV8VKKrT41300m99Vwz2Epc6yAv8Te3HMtjf
mgtobScM0ajHQSnlEypgKyDpIDakAN0oE5pLklj+3iw6FjxrdRK9Z/sAD23gYMo3
AtWMZv8xFEa3WFeTecJ7vd0vQtYrGPTYusoELHTdCOjM/4tlJky7oWi4PJ1HqvKg
bjqRTC4xG/IlL3ZP6pQHKtZzvqf9nD2JvBGKJB4tdcSxHZ6ieL5ss5nXKRkUH0wy
Os8ob7S5N+hrHibbGUueSmG4r+Cq4zQi61pS47RF1z0xdD0m28he2qlfiGm29f2p
StMqwvLc4nYVIS3O7BJIY00xqfDrtdTQ8TTvzOZaI1d7zgFkv3r651/bqfnPm47a
bh19fQfd3WTkbDz2MqlHDPzvH5jAp47bifBPbB5bVHKUKUfPYoHrt6RTTtw0pw5x
+J/s0nV1KGaaMoWtqEqm50F6XwrBC4FvQCTxC08//8nruVFZYI6qNPKlNQ36ijA3
+JV1KnHxbYsdHgiLay4VuoBCBiVt0zMu+qpnE0Xgv1BOCq/sP5ivLfDeIBEjcC4N
Qee3zVUicQp36+gRY9YaPSoIAGD8mEtZA51YMbGTEvH0P9f0HwU=
=mDbO
-----END PGP SIGNATURE-----

--QOR+sTD+KrZFOVlt--
