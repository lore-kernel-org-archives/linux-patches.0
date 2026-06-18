Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64FC2D94AB
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 06:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781762708; cv=pass; b=N8cUIpTjz+lM/2reZ97c02YVmAacCM7CcWsOfpB8NPTgTGzhwxJUWDK8/R6P6xT6awx9AqE3e329FuzZaAfqSPM+FEHDkQLBNn0B5IlanBXPJQb1GwLzX5swLMMDZmADK4onVMDV1IEnDpmMQy+tqznAuoADj7bh+E7JF+gQewM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781762708; c=relaxed/simple;
	bh=+kpJnXO4/8wwNzoHtaVQtv8o7oAoB303aXi/DiQlGLQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UyOFo/nhwZlG+x8daWrlS+GTwu3P2G0/GXoA7xnuDIrfzrw8UnBtsKXmf9vgkN/9NXqxJ2xeaaw95jAXqVRrjh4d1LP8ke9j+EyTf5SAVosMgnK4hXya0fiJPuBkaKjpB9g0oWHlMZKQDHlsP0YsPDfxVzqUjQvE1qA/kjY2f7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kwr0KDxM; arc=pass smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kwr0KDxM"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-30bd47b9f0fso604156eec.0
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 23:05:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781762707; cv=none;
        d=google.com; s=arc-20240605;
        b=DgLjeJ+K8Zdfn1l2ggAxkw5wiaWcAnu7KazUdg/nBQ8AbpP/gOqn6tjfvAPO+f9+Bu
         g8jksDpwgeuDTogSvYhunKSPNAL4jBVu+t6kxPxt/hyspYv+tQkrfyYfewrrCPXcHp/z
         Kl2pP37lyCaS23PYo31OVuSfhqhIs46vP5tw7FNpi95zeEPKIgDzCD2qkyou5ldfB22z
         HEL+LnQ9Bd5pNpT9G0ywF5ZyXQAmGTr7YbQfpoycYlwyWBAS/fJm6JwExuUXXqYk7/ju
         9JauevzpA10NqIxLsAtXa/gnXGRBqdKUI9FLaB0Fg5t2+JLZLEfidaOIq8sr3QJcS5Ci
         i63g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WkgBk3go1aRtnxlhVuzDR+Jr3GsyjXkZW1XpX+0nkCE=;
        fh=kQklRA870M7II99hXUIi5nrNuyA/9IMT5VxxuQ6x9YM=;
        b=lLg6Z9HUJVgvik7OcayAJh3NGKgBvHKnODa1/OZzP0djUd1mXn1yHt7s8m1qPbhgUo
         BasVem9MzVjmlUoDSysE77vQ9uuOOsS4AVmo0Unf46ErhoacHbWngrnDAEq7sC4wKnxF
         3TjKlAQ0KwEcTx9U/y7oT4YfTjx8DCHUquTRBImhLfhr7DnRhAIkGCj306RzRwedKKPd
         la8zGhLNlNRougCKAw72L5brEydYRRDcEDoC9vaAl+fpR+iXcWfnTfXrNLO+gArLBmDT
         ZPA+CEUhcy5AtgKF7L/8hDobDM9MsIUskI1r0jgsrA7OqX93A3XDl8Gmd+rZhB6kwRxg
         mG+A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781762707; x=1782367507; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkgBk3go1aRtnxlhVuzDR+Jr3GsyjXkZW1XpX+0nkCE=;
        b=Kwr0KDxMiICZBmTsyveFqhLDHTHAEJnxZv/+nQuv0c1NsZPaAGhbE5eq2piwLlghBc
         vkFrgOkfvnMG2VK2nfD5f+BDO9oogXura7mO2/VoqP6eCIPbGa0HR1ii+zc0MhMpTqai
         CGO/VobcEzo2NMhhW4KFIesKX5c2eWHvid8AZZi/8cFUpv8j83R8ORqliuO5LVP7AqDY
         1sPD0rqoB1AnJ6Y8T3N/7j9rXlU5kto2ciYHG/vcXNzRbP3f1GLj5qTDyXBs9hYsDhuo
         uVXZNlXs14jdrY6XoCU29OE7uKYO2vOzuBljVzIIIMYXdCPEruIYlr3ptnccE32oAmsG
         sMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781762707; x=1782367507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WkgBk3go1aRtnxlhVuzDR+Jr3GsyjXkZW1XpX+0nkCE=;
        b=m3cZx8rl07qo9aKUBmwNizI9HeUGgPQFISKGdPxkn2c4ex/waDpS6nsY4l9bky2qHw
         kklLUJTOivSiPv3IqMrtNFT3yLr0vo8kN7IZ5A9iDdcLHDzJXox95FcT6FuI7CeIeCkC
         WWwjElIGdau6zNhXAPBP6CUcGIUJ1Zigo+pMa9P2UaNXF08/iDM92OxRxiS/BW1xCuoJ
         PH3lZIfqfjcFyQ0+c0TOFzfSpE0v7oOrqWinklxRinnKLuLCmFyJIqvdj+mawPM0f9pA
         SSX3jmwh49TOExVonu/q0LJ3i4Smk+SFPA+kPkHBw2i1EsiGZwv42MZ3nDuPaWC8sw6J
         Ckcg==
X-Forwarded-Encrypted: i=1; AFNElJ80FdbvxzcCXzSbMS3OG7FoV7y7/abqsduEPixvyfhGHeDbw68bf8x11psLuAA9/TvY+/3tjPFE@lists.linux.dev
X-Gm-Message-State: AOJu0Yznp4bvH0s6ybcyaP9KPJzMoVFRiqyyKuCXW0j2cXm3I6a1M1h5
	WoAZSYLxTEnAJcIlCYqDUK7JBlMAPMZy1Dtlkl0XE8bg0Kpld4lqNKMfHYZy1Tl2loup+BBanUD
	sXdBjhIWI1wacO2jgvRoShsbWozLhH0Q=
X-Gm-Gg: AfdE7cm19cnOzx6fB5B8zkZYfF4OKEZ/RKsaCEtHn5qywPEVpDQOsk8gh2pPKhPZmt2
	QDwf46U/jyqXyO4yyMJQQ7pGULn5rtYaKSZs2NF2D9dz44tZBAIoLNe9WAgV+3lGpBDwAl4PSGe
	rQQKp4hqc/7eZumenxpvU03pn0B3iWfmLaNKfqna9GK2rnf2EFIJRGzSPR9MuG/3e6UWBaoDWXF
	2xeZ6vwd63anTife2Z1leruoo9pcWvH2G7jXNFXwa9GKzW0f5VzivY+h/6TwYrDVQwP/rxLjnsg
	VCpaL12KJAU/MaS813kUgoBhQF4jMmutbko046na35pYXZMcbokQVHYVM6u+P+M9LypugETacJ8
	OelMDze7EhS0/Cq6QST+DwlOxSSCZgSEzY2kR7k5IbhsFPn4NY+JI4sSvxH0PFcWQPTK9bRfNfj
	24zsxDeLN5
X-Received: by 2002:a05:693c:3105:b0:30b:a257:3a2d with SMTP id
 5a478bee46e88-30bca0a18c7mr3986622eec.26.1781762706420; Wed, 17 Jun 2026
 23:05:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260616145109.744539446@linuxfoundation.org> <f33dcd2f-787d-4705-9272-394e1d560ae0@googlemail.com>
In-Reply-To: <f33dcd2f-787d-4705-9272-394e1d560ae0@googlemail.com>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 18 Jun 2026 08:04:54 +0200
X-Gm-Features: AVVi8CdXBPQXTNC1zq_Qb8ITwFfGHIZRxK_GPHJGWi-dkCBBji6Nl3TN03zhaWo
Message-ID: <CADo9pHhAQHGsEB5i4R1GDeAqRubRb-oaUgMjTrk0y-Oc_8U5EA@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/378] 7.0.13-rc1 review
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Work a Dell Micro 3050 with Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz
and Arch Linux

Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den ons 17 juni 2026 kl 21:13 skrev Peter Schneider
<pschneider1968@googlemail.com>:
>
> Am 16.06.2026 um 16:53 schrieb Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 7.0.13 release.
> > There are 378 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server.=
 No dmesg oddities or regressions found.
>
> Tested-by: Peter Schneider <pschneider1968@googlemail.com>
>
>
> Beste Gr=C3=BC=C3=9Fe,
> Peter Schneider
>
> --
> Climb the mountain not to plant your flag, but to embrace the challenge,
> enjoy the air and behold the view. Climb it so you can see the world,
> not so the world can see you.                    -- David McCullough Jr.
>
> OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
> Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
> https://keys.mailvelope.com/pks/lookup?op=3Dget&search=3Dpschneider1968@g=
ooglemail.com
> https://keys.mailvelope.com/pks/lookup?op=3Dget&search=3Dpschneider1968@g=
mail.com
>
