Received: from mail-10696.protonmail.ch (mail-10696.protonmail.ch [79.135.106.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA44155326
	for <patches@lists.linux.dev>; Wed, 26 Nov 2025 12:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764159706; cv=none; b=Z2JxEH7eOFv7lF/ka3sut8vmUfND8IYQ/9xWpnTy23EdABIk10wDjnaRMuHGo2QXevbiaFwmU/o6l8omlao9tX6MEB9kRFFj34bCRgH3eGUpsO19pVLwXCpPxkcrOFpguSKlCMFbPaHCkgn9DC7jU8WjIAzo7R8gqLC8MJUXgbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764159706; c=relaxed/simple;
	bh=80u4QxQYyXLo3vdGbNAAZV3e9b2yLQhx7oEAqnzqlDM=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=WvMEGv3mM40horIpiwckrCAmgqW4KvPlofYZ6RZ+CzrjXqi089jQb0wfj/qTm6LsxBTvncXiFSTlZ9/5ItMrjWjx5xJ/DjxFiyrb2jj6JQaUnNsProbdujbKP2IRkXXv790LvyThu082aNyDTJcgDQJPcueuJGtwnEZwCACM0wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=OAU8LzGY; arc=none smtp.client-ip=79.135.106.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="OAU8LzGY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1764159695; x=1764418895;
	bh=VZKBadD2hAHsYnRY1HCmufcZEoZ0UsobNfUbHsBhVr0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=OAU8LzGY6qlcd/2iQi9XbbEnecVBjqlhU4tRvTDhKeG9E7FJ1l1wLa17WWboIpK2b
	 J5fsg4l/mSjA8jAigySMWNjL8l1nbtdKmY98H+aFClNRhnFj0qkGoNOJn9s549mcgG
	 Bb67H+Po52Jib3ty35V46P7KZwzWrkdUDgyZawR9+lZOyU66KHZMoITEe6T5G2PuSu
	 S+uH0i2FKfvCTJPjaEa264FsK3XENhvt3xBIPwmF5TMcfUr00HFdrOjj6023utp8Xy
	 0cHgdUXc+h6+msLNAQ8QPk6ozirZN5BKujMo7EmCoL6y44gEAQpKO0NfW2e0V33TCR
	 p+vXACsg0Q5yA==
Date: Wed, 26 Nov 2025 12:21:30 +0000
To: Pavel Machek <pavel@denx.de>
From: Jari Ruusu <jariruusu@protonmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "wozizhi@huaweicloud.com" <wozizhi@huaweicloud.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux@roeck-us.net" <linux@roeck-us.net>, "shuah@kernel.org" <shuah@kernel.org>, "patches@kernelci.org" <patches@kernelci.org>, "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>, "jonathanh@nvidia.com" <jonathanh@nvidia.com>, "f.fainelli@gmail.com" <f.fainelli@gmail.com>, "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>, "rwarsow@gmx.de" <rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>, "hargar@microsoft.com" <hargar@microsoft.com>, "broonie@kernel.org" <broonie@kernel.org>, "achill@achill.org" <achill@achill.org>, "sr@sladewatkins.com" <sr@sladewatkins.com>
Subject: Re: [PATCH 6.12 000/565] 6.12.58-rc1 review
Message-ID: <0J4wVn9EZlfvRPNqx8nSODm77O0ErR5JMPhZe35m07lKoJoh9BQHAyH167l2S-cYMQDDGLsRM9IKtY9YEwPvqfXduwmg12aaW591N2f9iT0=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: 9f995b9be460101f297d9431f92a995d0ad597fd
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pavel Machek <pavel@denx.de> wrote:
> > Zizhi Wo <wozizhi@huaweicloud.com>
> >     tty/vt: Add missing return value for VT_RESIZE in vt_ioctl()
>=20
> This one was backported wrongly to 6.12:
>=20
> +++ b/drivers/tty/vt/vt_ioctl.c
> @@ -923,7 +923,9 @@ int vt_ioctl(struct tty_struct *tty,
> =20
>                         if (vc) {
>                                 /* FIXME: review v tty lock */
> -                               __vc_resize(vc_cons[i].d, cc, ll, true);
> +                               ret =3D __vc_resize(vc_cons[i].d, cc, ll,=
 true);
> +                               if (ret)
> +                                       return ret;
>                         }
>                 }
>                 console_unlock();
>=20
> It needs to do console_unlock() before returning.

I have already sent 2 emails about this, but Greg's to-do
list seems to be very long, or something like that.

https://lore.kernel.org/lkml/zuLBWV-yhJXc0iM4l5T-O63M-kKmI2FlUSVgZl6B3WubvF=
EHRbBYQyhKsRcK4YyKk_iePF4STJihe7hx5H3KCU2KblG32oXwsxn9tzpTm5w=3D@protonmail=
.com/

https://lore.kernel.org/lkml/8mT8aJsAQPfUnmI5mmsgbUweQAptUFDu5XqhrxPPI1DgJr=
7GPpbwrpQQW22Nj7fsBc5M5YKG8g0EceNQ_b3d-RPhk6RSQgGCqvaVzzWSIQw=3D@protonmail=
.com/

That second email has a small test program to demo the
problem and a patch to fix it for 6.12.58+ and 6.17.8+

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

