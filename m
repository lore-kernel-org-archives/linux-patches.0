Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83F413BAC3;
	Tue, 22 Oct 2024 11:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729597568; cv=none; b=rN/O3NompjT+EoNk3c3guvksvmz+ZPoLgglhnQzWJOyUwONB3D5VHdcFRhPaA5IJWI0MoLNGRL7u53qlsrnUnTRL5rKeXGAO211WZUi9gOkiNPbkI2EC9LZQose1VOSQFDntto7j+yyMr1IaemnjlwAHcxmwfe3Oqipc8R4cabk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729597568; c=relaxed/simple;
	bh=dyhqqPxWxhvsXZ6xt+xmu1F0phNnHnKPqdBnuj3cJiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bsi/4/oICf2WnJpwqdI6VcACHijHxU/3a5tSQe/l1RvdFRK7lcWLQZg6QdF1LZMOK9rkNr3yQqn3O2OAUBSrj32cHvy/ZpU8FJkjc6O+a0asPlhY4fupG6gL6UvDCILATUfsVLmF8BytRqgZh4OKvZ96Kb3Dpyp0i8vEUiRVMHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=JgCK9my9; arc=none smtp.client-ip=212.227.126.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="JgCK9my9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1729597543; x=1730202343; i=christian@heusel.eu;
	bh=NPOMW9DlAcdetDnRxy3ZQhFfvGu4tQyYYBb/IlBYNOc=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=JgCK9my94PiRC+zc4h+BpE65/Eesuwsi+G8kI7rgZn+xy+wu6bzrp57ECV8zfxZy
	 3Ekc52UfKMkrtNzJv/qBYIXjX/CQfFinRYmWRQBHo7d2APOGOkjPFgaUpfm6k0pjo
	 DhdqULYWeyxhOSZRWyXIHl1cCP2bT6cYTJwh1ex5Ildm9EYmpvAQdDjvP8NLP3KFD
	 mw8mzA3J0kZ6xM9zyYiTilEocQ0c1HnuarJa/MXHtlSX6ZqcULi7GBY1Mx/82mjMP
	 zF5Z0iKx3xw5oC4bk0ELwSjfREdxiJEIcyVnct5H+6po3nXrFJYHcEAHeSrOmX/qF
	 HWSNFV5FWktDUZkxbg==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue011
 [212.227.15.167]) with ESMTPSA (Nemesis) id 1MWzwP-1tRFS71pub-00RC7q; Tue, 22
 Oct 2024 13:39:38 +0200
Date: Tue, 22 Oct 2024 13:39:36 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/135] 6.11.5-rc1 review
Message-ID: <49328035-265d-43bc-9d5a-39207f51519c@heusel.eu>
References: <20241021102259.324175287@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ta6ncjdj7z2jnkjg"
Content-Disposition: inline
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
X-Provags-ID: V03:K1:Fc3fseVtIWAO1mndAvhytRWAovJgA3SDx6UdOnfPvhFrtqHSn92
 XwFFCb6aqxVea34XEAWRAvTgwm+TACFc66AesaIXBKjksdtYLjHdNNF4Ab/4bjX0skPIUIZ
 lz1F6K/6D2qUl3Wt1EDhuhlka+U2uPdIhbAJ+ePKXJNXwCCKf4/tpvrjR7BDvj+6Br6v+3k
 KjeInRCJn8S57v0Oif5Cw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2BIzwOjDU78=;AqUiFCVHW7BfsrMhkRiiIJqXEIN
 4Q0VqfAgnq7HFXoJLWWhotadBy2MvLYK+34Nh6/mxIp60JUyAnQJh4BIyJKiJIawd2Y7Dtr+k
 kojiQKw+gDuF/Ey8oiLhoFwGGdjcSNRLnHrIf9FLPn1JEUrUgr04WVV2/MI1XjR8w0xEze1pi
 3Q4GIzKq7JKWDH/XzWHp/1TuB1h+ig9F1mCp12JfHgu4SrRlhGU3uoazZgUn6SYnYh738oiwN
 UciGKw89Zf6hRLiBBxmee7+sLQ1iy9SBIP6O+mdLGHQhk7AW4bGP7veV2NYRO2PGCy6kjkuO6
 c0n8OZomfqFrdHtDhlonWziW7f9TWbGmMJqqjWOs9lDFhJ8XGXP8Em7hXGRK4z0mHrL7dzp37
 0sUHYbwo9CLMPcF+vJ2LGlFsMhAydJTLoRzJkfo8m371PzrEG5QT8Y5Drelkng2ivgxdPDV95
 fnWmssYBuAt57qCBZJiN7jUEXUrY7sAPlN592qWBmvsPWsrfP5HQc2hrzW+oJO8FGYIe+91Bl
 yIe4FWg+UtTtedovhNclm0OTGY2EXDBTFqoXbRDSChqqPpfsOQ7/Hpz/Qzr5pWffVPQM4R/iu
 wNW2ECZ5+DbulRqxHEGE3/kpQ6CIfb2bRK9HReqtDmjnFoyZ7Vim/SA0pUzvaVOEDkWfu+hqL
 fZ1Cilm3sh8SKC7/qoiemMP0ShJ1m0DYe8midGQFILhww/Ie8k7jJZF+/QWjWQ0+dBs5NXfvc
 V/7+DFRpqcI1oFZYA2xKssrNOkH0ZLCmQ==


--ta6ncjdj7z2jnkjg
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 6.11 000/135] 6.11.5-rc1 review
MIME-Version: 1.0

On 24/10/21 12:22PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.5 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.

Hello Greg,

I have tested the 6.11.5-rc1 and saw that it still has the [iptables
regression][0]. Since there already is a [fix pending][1] (I guess you
are aware since you commented in the thread), it would be good to
include it once it meets the stable criteria. Also while the issue
sounds a bit harmless at first it breaks [tailscale routing][2] so it
has a real world impact.

So I can't really sign off on this realease, but also everything besides
the issue mentioned above seems to work!

Cheers,
Chris


[0]: https://lore.kernel.org/all/CANPzkXkRKf1a6ZvOJU=m3NwW4B0gQnQSRggw=ZnK6kBYmqLtBw@mail.gmail.com/
[1]: https://lore.kernel.org/all/8cd31ad2-7351-4275-ab11-bca6494f408a@leemhuis.info/
[2]: https://github.com/tailscale/tailscale/issues/13863

--ta6ncjdj7z2jnkjg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmcXjvgACgkQwEfU8yi1
JYXHeQ//S8H3EBT4HWeWQ6uj+5WpiVARUVeluo9n9et1kPl2vjPZ0dfW4fWV1Z20
bNCTaplfzgEaPReGxSoa/MSSx7PkkiLDwG8qFVlg73jdOCJGwpBq86lzHvkszluX
h02bpqcvWIKlAYPAYzO69yJN+uuZqq++yceQQWkCXj3dTu0wTr6c+HVWRna5dMEU
5+IhUKu8kd5/RYd33MUInMdkVfP/8CCMGnl7d1ga5JAo9v/P53wyMUuKXjiF+oFc
FnTcNQx2t7/7MA+5mnPatBOHJyr6rOupdQig/ABk5cpG5VdU0Th1XX/ZqMuH7UFM
23IZ1aLGnzCyBzUQ4I/3erZbjQj483PRJ1RCDskBc58MzxaspbjsToNjeabSykFg
Tx/levMrqmKoKbCQHN2uBiyhQST/a/P1teuHf/zNg8qlOVoQlsAY0XIa4RHlNToM
eY8RZ4DXBUkcFwx8NCMmNqOcRWI46sd1SEFHM1mWhizKG+KFmstZxgsY3OaRZq1V
cw8UePWgB4Be3aXaJbpjj2PNKJhhmOrVV/pB+ciKvPNtvpx9pF/HGjeBuKq+DnDS
m0fRNBnS6mKx+aQ/IXdUlpm57/uh6dPMBbrZ0FaoNrQ6a2nhwzE60s0K0wlNDBVj
8ZMSlKCvyMHBN8nTAhAkHvUIQcXQMfa96EZ/73i3/B6F1XJgBho=
=E5VW
-----END PGP SIGNATURE-----

--ta6ncjdj7z2jnkjg--
