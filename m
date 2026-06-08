Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA654071FE
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 11:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917374; cv=pass; b=P8SUcix6QYCotzR30NYupo0c6yrefFoxkV75uAcIW6ts7p8EuNsGrpq7YVZCnDqWqM7GC23AAL9yN4UbzrZ3zJLZgLWSv1qqfJ4Gs9MVTbABTY2hMRhI64cXLQJ2PQMn6jsO5Sjit3lo080DyB5qpfQJCTsCPLimkWgH1bSabR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917374; c=relaxed/simple;
	bh=IIvuds8TvmyZhmHFQSb7b+CTObPtSQ97rmFd0ivEXPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ewQ75y0j62aL8/TzlrruU2MH6PxEXt1IwYNqFMAYj+zbeaxOYc7Psq16QKpPkFK+ExP8oUYgbf1IyBUSnUpLHqTn/mDNTagixSuaqmpniCd7sucmieO00Bx51YrRuVc9cxqghAd1ncjZPwj1Lx+Kz3I3tHxws3MFyfz2v7S9MnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XSvz+T5c; arc=pass smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XSvz+T5c"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-304dc707bfbso213560eec.2
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 04:16:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780917372; cv=none;
        d=google.com; s=arc-20240605;
        b=VlTTqIh3XWkBlxZb+FrLp1z5FbbT9aDBJ5mKhTCConjsQZ8T/wacOxXzGrj3w7vjYq
         aLg6wIsbLg7skqDY2tG05xn88snE0DjLY/MT0MbdITsl5R8oySVWl7n5aU0QX/trjuvq
         Sxbj1Q8asVM+m+Xoe+fZHuXXVtOemozJGK78nHExODe+jadpm8wYd3P2FmeZeZpHTMLh
         ngw9xM74LI0MMBGn9Rg9O3p3NDnYgQ4WnjZUKwPQyMAqrs0zcoFR3y6ye9Y2NAfUUBqb
         hlFLnoqkrv6qYDiOs7zCBB4rapkj/V0PfNveboo+26XZby868Y/GoGzDcVKjQ6M6hx2M
         5ytw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lpXOMtv18jGR6tMgBi7Hb/icQLkWTrdf0TFaa3c8mys=;
        fh=q+vHUm81QKJQBAR8DV3fLAJtWF8uYBkyBx5bXXfWX9c=;
        b=SP+XoZ1lIvpl3kEsA82iEZ/nnCgOyovIESNQsCO57uxnZ+V3QyjJuXouHygehyWQoa
         E8ssf7WKtJeKYpGkd/Xj4WMzEEMRyWRA1uNk8tarUzAEL2EwB/rJcO0V8gR9C9ooh1an
         cgq6WhnLaByStcLuz7WsEqYI10O/hLJ8nxqiu1CA6iOaFsCMYJcmdB0JWV1N6PG7Vs6C
         S7sZfCbZATtQ06fUwLVmxEAqWDAxHanB0L3JD5sMCZsbbBemPzi66oiVHu4uPuN1jJwv
         vbDRV8CnFwe7cinMNcrhib482BNGOqw7Upz0fQAAuQjqxgdRZEM3XKp+pqgSJjT64jOM
         e9vw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780917372; x=1781522172; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lpXOMtv18jGR6tMgBi7Hb/icQLkWTrdf0TFaa3c8mys=;
        b=XSvz+T5cCa0MZc41dAMkW0RlhpADfsVl4opzRoJc9MZ9KK8MaBnpimEsyviRyw03Id
         Lz8sqpEM7rRsH0K/e9oqImhsaBLWAJw+ZEJ+ZV2ZQraOXFPXRvMbVFGtO1Usxiy9mBGq
         E62Td6+JqX/tOym5ivWyVDeKzA/gFNm60bLEkQnQt8c/iWV/du5SFW8BgDyn557TfMTO
         TeO/Xw4Mm1MZbUUISREVT+YSHTcVijVYX7BBkVxbpsDiPHtuE7mKKNxo7AITxIvEHytp
         iWOJSBiq6PVXGRgbkciPal9GTyb8o6e/l7XG5fcoIsZVGZwc1WdPiFdu5inqvj4r3VOC
         8b2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780917372; x=1781522172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lpXOMtv18jGR6tMgBi7Hb/icQLkWTrdf0TFaa3c8mys=;
        b=ffrvDp2sbRmyuyQOZtVHaf5GZpZBWup2XGP8YH2Maw6Oex/Di71wgGqctu8nQI0NRq
         3hyq0g2Yr5+3ktihZO6XTEA01mYjn9TI/Zf08ckL1X4zW8KFqhY3HK5VrQ60lFkjV0dq
         PWGfipp0egKZaDPwlTNKeH/E2fZZWI8aYgBF099YKi0LuXkguFpDa5ok9MJ7sW3Ug+V7
         yNkYWcjBsUMmXdX2bkCHOad93s5TGiWrazs1x8pJDP0vTrBUB9cz5LGrfutGeVvZRX5c
         kIJsCs46cKaivQKFxVwXZjXMwSgCQUHxqP/amEo4WeSjooZXmj+z1KVwrx5FHEF+SxbY
         Y3Rg==
X-Forwarded-Encrypted: i=1; AFNElJ8jurLB8cxcVO8DxIkBYds0DVk/EUCN8OJwqZBOgo3XJ1CCW20GrDq3YLdQp2QHgfF9uW633naB@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5yPFnCu9mZSAY6HoRaqKsFr1/mCqp63rYqnKye7W3cF/jua8d
	6y8vP0mPtTO/ZGyZ5xvTWWa7Gqa6fXzhpA3qFPQ2PQqzawprdJF5eCTqXWxYMWuJppGYajvTJVY
	NYWaIqwN23KfaH0fvtqx6xd4nxeYqkI4=
X-Gm-Gg: Acq92OFBk2GsDkqgHURWKyBl8BjfGD4bIrMapiQO27k7F9LN4UVohI+eSL5YnRFwQyl
	q2+SFbMovm+rYn2Bxvu5A6X3bcV2Lr2PPrx3dS62dESZoIOcMNEJrDKS2JSAF6MSHMB3p0HIQZP
	wk1tw7tOOH+2DfPYPaqZYHx1Y19fZ9lO+/y0jpJh/Bz5viTeaAW0/gmA6zmUqCxZi4gLc+l2MtN
	rASbCSRMxQqCbs5SuoGw/tkFoX1AsDhfgzWl4d6y4xP3pqv0DVtMHfP7VViVlQ1e2uLqRFG76yG
	H71FnR+FQJ2u5rf88pIk3Et+kAKcZuXmSHM0rmYw/8oZ652wuzBtLmp273Ec8KIY2+kP2x5boYV
	kXAfhVqmUm2v5sxcOhqL4TuyRbYoT+d9p8g==
X-Received: by 2002:a05:7300:72cc:b0:304:9b4b:3b9 with SMTP id
 5a478bee46e88-3077b2d94b2mr3980569eec.6.1780917371863; Mon, 08 Jun 2026
 04:16:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260607095727.647295505@linuxfoundation.org> <20260607173214.92693-1-ojeda@kernel.org>
 <CAM0EoMkszTXv82To=KnEYTgzQSmEdRW9XrAMVtJsUaDn=Akf6A@mail.gmail.com>
 <CANiq72mJNbNzYO37VK7s=ua5v31xBrRp8EnHDvEnKF8Z77jDmA@mail.gmail.com> <CAM0EoMmHd10iivCpDoEd3h+eae9fSnoGWAH_AkwFhrnS6PN63g@mail.gmail.com>
In-Reply-To: <CAM0EoMmHd10iivCpDoEd3h+eae9fSnoGWAH_AkwFhrnS6PN63g@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 8 Jun 2026 13:15:58 +0200
X-Gm-Features: AVVi8CeG7lrWEuAGzb5zU-XBUP8cHQXmo8nVywRiXByIqS5bhxDHiQX-RA7AR3M
Message-ID: <CANiq72k6J7FYT89svtX5qbCUWg-MKuhUHaT07cjk8o7PqaF8+A@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, gregkh@linuxfoundation.org, achill@achill.org, 
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org, 
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com, 
	linux-kernel@vger.kernel.org, linux@roeck-us.net, 
	lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev, 
	pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com, 
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, "Kito Xu (veritas501)" <hxzene@gmail.com>, 
	Victor Nogueira <victor@mojatatu.com>, Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 12:57=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> I believe this bug slipped in during a small window but was fixed very
> quickly. Probably some fix never trickled to stable.

Yeah, as I mentioned above, I think commit a005fa5d7502 ("net/sched:
act_mirred: Fix blockcast recursion bypass leading to stack overflow")
is missing (at least).

I would suggest reviewing the entire chain to see what needs to be backport=
ed.

> If you can point me to the exact tree where this happens i can take a loo=
k.

This is the 6.12.y -rc tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
linux-6.12.y

The stable kernel team puts the link to the repository at the top of
the thread too:

  https://lore.kernel.org/stable/20260607095727.647295505@linuxfoundation.o=
rg/

> Still curious: So only the arm compiler catches this?

It likely gets caught by other arches too, i.e. I just happened to
catch it in my arm64 build.

This is Clang, not GCC, by the way.

I hope this helps!

Cheers,
Miguel
