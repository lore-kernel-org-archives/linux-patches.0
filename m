Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7498420E6
	for <patches@lists.linux.dev>; Thu, 19 Jun 2025 00:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750294229; cv=none; b=fOTQPlobtxXHiTZUa+2D9NHd5UAOsfN2Ss2b4TwGNTwmW4e12RipPdKVaEe0ksZR9kggvbm4LcJjWmpAcgPPelFpIBoSi9yBjs8cnKlJbjO2BNF+iEKZG8ehiWc2XIV4hoBEHc+ZkJiqHatpwjZrkQJwZWiGFtgsXEFLABUBLvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750294229; c=relaxed/simple;
	bh=iJcCEr5YM6unhJyVVmf3x7foPlfE4U2vE76HSyJENHo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=AsvpIt2IuESf6xbO0DHA1GWeKPcYIp7V5QOcnOJTY8REErVGw5UAbo6iBdSWeBQ7r/o+J9wnt1aLYbcZZfRIJ0VRP3fS5Fa17XCTbH/3qQ6NXhMIA4l/sVUkInib+ebSnBrBv25pJbD2Q/aY7CuE4cYcZ5jz/TWnn8IaWSCKwCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b=TjHORtFa; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b="TjHORtFa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1750294224; x=1750899024; i=s.l-h@gmx.de;
	bh=1IvPbKyDiRwKFNqTSdg0Pi3MvSBSZBgnfMgMMZkEKsY=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=TjHORtFaiVcZYXQtHhI6m523gzkqIwhKH28h/m3D7Vzfa+p3T5hqRYFEzWCl7+vv
	 G6MGmb76YO+NAwl9ZrTTJHL9l3az2WTNdkmvPEyiJo7onNcKdVtAZ3ibT/8rmu9yD
	 jlcf5GyXqaDEeyEOhDtF2cwEHkipcXf/dzIwL3QeSvk1AZ2o1attSOlKHWkF7i10U
	 X4cnPNsf4v54dKULsvRpwXuCBRNHEhyumrdctcmPLx7f6Prqlxrdy2hsx5UlDOP6h
	 xKIW/Nr7XVzE+z5zskC+Bhz1OAjtRze3GVRWWegHe/RAowxGlhJ1DFpKIxkf5uNwu
	 onOvsEnzpAmJYQZaHQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from mir ([94.31.111.154]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M26vL-1uTyMT1B3h-000en7; Thu, 19
 Jun 2025 02:50:24 +0200
Date: Thu, 19 Jun 2025 02:50:21 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, stable <stable@kernel.org>
Subject: stable-queue.git: queue-6.15/series corrupted (duplicate temporary
 patches)
Message-ID: <20250619025021.0ee12258@mir>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ki3ZOMxEQKKcwhi8G/OEDP3SqXaHlmIY2ZkBmwGpL+l1JhZarW0
 XQ5wDf0yrOT5NQ4fGtJP5d2gIz410f7jT/UEOHwfrHSbtFXXlqfPQ6MhFT3F/ZY+EN3sVif
 DE27MyAv5AP7iLDVKFiQvqz6ojgGJKVtsiyyeGjNI8VcbU5BNveZWN/RBtQuOf3VceVJ/BU
 Tg5xywaYSm83ZW55vnQ6Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fVa+7eVR3Wo=;w2fekKR+pCnOe/G2ex00GZEZS5d
 MGF1IqhbrQt6YX7dxCwMEw5QbSLz8yyi0SakFL1mD7Z84F0c6Jz8L9amt8z3/stOkp6zHsEJ0
 sWpfxAM97S+ywOyGMcSaL4pRDFyWHe8JQIv4yU4O338vy0LEei0p8tGfpsjgna2k6lISRgxcT
 e8qXqCrgbpuPNn4Y0vm2efrLZ9+A1I2dYQwplZi0xiKogmcB1HzMJ62FVmAMKH00KInb65l/t
 QNr/2hkAU3E+RcmGfGQVZyznaDnEiVsilEuupDo0lyLk6VeVEEXgRsJImTUVnH48N3jQSZsGq
 LadsWauhH8Sn9dm5QuAPbIvh6TxIF+b995ZMlkoa8o5o4CFUwWvq0Vb4NXwaJ8jdCP0+BmjWv
 5CSStLZhU1tHnzFgMlnPUqhYWWD/5eujZvkvt4+QVW9oaX2nhPzq6/iOTf/wrrTkvu8UkUOsM
 HCWKr70nULcFGsTOuCvXu08CDdOdeuKzrlaV6wjudmUcvY2fzT7GVEr8oafB3KO9edgFN++8f
 pKvfwv8/4MqlraDWBAFKo/6LaWrxcs56TPTwD4vehCYT7Kv36QvxRU8/AK5pPQgvfLs+E5/dR
 R9iJHWjStUtADO4IeoWh8coDs8M+si6jPRO6vSVi1pzzpFzSWFADI1dmpOBkTCW+lKCDh3Vgx
 XZVG97Vbm3gWMcWJAxZ3osyR23KaMb9Suz26ZlEE6WhrNDpv0slXbdDbGbLkr1fCxgO6O2MEf
 JvB0JRN/rpB1Vt8kGHuMYrn5bPTAW499Gotb7Lp+YX9aLDi7yeLAQsVDHOEztTf+3Q0BX1EV4
 qVStGXrIRZvkGyYmSZhJ5Vgy7mSJ0lJ/QUJzC9NoJCmA8+2ShZWNUyxXIU4BLfagFuFcxI/v0
 B+yQaNI/S9aYQlKKfzT4uwo7NMfJoptC80Ja2DObw+JmxTgijAn1ckQ7fthsfqTZXqfLdMVKv
 Vji/7aMH6mzwKdblqxDjtpONB7b09xuYkpGcIHyx+7FfuNH3IE8lRAMpOK+ChBIi+606rUhKm
 8Jn5hglVSUH9/z9Tdu3dyKsdVkYt4zpaSCyE2mW3LQy7hR6CHkewwclKEo9bwCPPnQ38fA5Mu
 pCYMUFVoHwyV9ndLK1S2BhkT29qoeG5n0BNRO04df9VM1HZ+7yuFt1YbZcpPVWES4tFIrsfRh
 9EkfaG4zFVeCb7uYPhZJA4sMjIseAL2LpTepeUsTg54PchOZnuiX0+m1KrwpqFWyUenfhRKXh
 uew2SjTyXDBhyVWm6nuUt47abTUFrUDUp1RiaR5J6F3QDaWJqcJ0fyLFIhLniThkTqmjye351
 CtA2DZ4FmhVRpoCPc5gv0uAijOhzpD/059Dc6mPN3zPTYlTLZ46yojYPBb97MzSV9yor9R87v
 xyJvWrKxzkId736LTttj0KQh+stPHy5PGitLqAGzaypf329qgbQNnP4Z0j6FMGk/62eSVOVGG
 C4yp8uUUG11jAvPJTMzuLAB6dgrCuUkHTlRqKleOx6iGHFhNADBxqPuWSOiZGWfZS8u/5ikxJ
 elA1YP4fFpnODjAqxChTG2zgPxXjxo+tvd88qjWZQGapM7jnjr5j/JZZyeAONwsvRajSfogMK
 O0izJNIRFoQ6QP2/SiG6wN6pvidIL0BXymufPKgGLWog5QOAbO/4fy/uru1d/aSQ2CWLcKcKv
 FVeOtn6b65UHwda85FA9dJPjyoGjNVj2nFW4pwLYAfYJ5tu/xSU93X7zRmIaAio1Cet09c5ZT
 gjgu2ZM9CKDA7zUN3v+1rMLqP0ra25aXGkWJRDfGOqBktkexSzk6rGy0jlV9FDfzq9F14Jo5g
 nhcq61hdfw1oCUVzRSobtTpvXuaG1FhEEGVRy9LVjkPkMrFDW2565HLcW5RagUhj74z/3KIY2
 OdbTLpmjU04OGb5wRn+W7EnikHwp/AwYoyxNzmDiBDOwefqTK26cyUmKpr71qgi96UfA+Jdm3
 udOb2x2DcNbr0rJdZr+FlCgbfhCyq8tO+uox6GKDRUfIyfF5Ph/Mj+3OGIZg7zTDFBNcQUr9q
 Q1GdmwKePRZ7CCAuS6+DSm4e+zkc3Zdy/EVsCHSskKyL3Ph0zYG5adS3nvdwrMHeZ5DyS2W3C
 YSCJ52b3mfLopR+rrsYLDquARgQbracOia8yJbrXLJkDfMRGS5g+P8EgqP1OpUCf9NUSuXcui
 7Wx9y9xQmWWvvlf9O0ibgHcZFNhaiHxkBbcl1RsLvFJFfA2CHyKULtaILUz5Z2hnznPZUOriq
 FkJxtUkIPxiGBCsCdZj38Y6bsamUWMQYapboAlaxnsETSV+Z3f1UJDqQdr7evBtQcqK7O96RG
 euqNs1B9bKEfEM3H1tBfIuXD2IylDY2RtpB2pUkuLAnhZw2RV+hFxwei7b5o3ggEmBEgtvuUI
 pFzjrn1LSmiJ4dMD+1M860Hq9Ru+o6wa47ppx2D9cWpQunP52yA4in/OEUjF+yqN3vto7NTUd
 g808nSCnD3W3cAwakhNwlaf0aWGS72H8pDwlSYnhgd39uUayheMVdxkU2h71AU8BwDzwMqVpj
 L9I2ISBgksUUR4qjNxDYDHvn6TV8lOfjTHmg/Gexmkk+7AcoUo2OfVc98Plckv4vPFkgyphj/
 WsMsWWFGvD6NajkmzF/6pL7MDMTugeZDazpUU8sMyArJECttsX9mWZfy4gD8bux4czujK3gRx
 UY0ypiSjdOnx1aqxFkzwOdicqEvBQCWdw8TlT1GmTVILbnwzK2QygJUPgSPrmCt5z9hkg4V8+
 dYxcq9scIFnIND4hPU2Y5TNFAz8j7dwDwbxR6NaucvyauYcugVVt++ivuTxigpIjitvBI1pr5
 hSVWD/Uwsh7Ug3dGpoh307txJzh+nHwOt9BgtRulG+4ptgGcU7J+dxMlE6eCp79zU2oaQb09u
 tQsaaaCQ/0X1F6NwOnO0xOt3HUkepb2pNPvhICOKSfGpvlVUtCYWr3B8O++bLUAPy1AOn0tIf
 nhCqWIWPbRfNpJIBY3NgPUA6hOCLy++k/H3e/cdkPC/dZBMOhbcK/qlRxT/gf+2Dwf2EIjbtn
 MU73thGsoVbaWj8Fnqw6YA5v3gn6UflDdtNvUkAzYMNybL+b7FBAnQYpiFG8TwJwkvGIzMvmT
 klSBtvAY88H8CfPOyfRxBs6KrljhyaaAZMoJZjplx7AscT8prWVJqx1iSoOrRJ4k6K+N2Osdw
 q/wiKm0E60DkT0U19l1O8jYxx/IgMZ5BCuWMK5ISTYFTsfvx8eo3rcpehwYXBklUjV5FTOO1/
 F+Sb4kg6E+AKy35sOl624BlgEmxf0Jz3ovRJlUVHH6MjRwHXHO0dq6v+gAs=

Hi

While trying to bisect a potential issue in v6.15.3-rc1, I noticed that=20
queue-6.15/series of the current (v6.15.2-74-g344d39fc8d)

	git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git

seems to contain artifacts of duplicate patch entries:

upstream/drm-msm-dpu-remove-dsc-feature-bit-for-pingpong-on-m.patch-13942
upstream/drm-msm-dpu-remove-dsc-feature-bit-for-pingpong-on-m.patch-8756
upstream/arm64-dts-rockchip-disable-unrouted-usb-controllers-.patch-25959

Thank you for keeping both the traditional patch-6.15.3-rc1.gz and the=20
split out/ individual patches so easily testable, it really helps=20
(especially for bisecting).

Regards
	Stefan Lippers-Hollmann
