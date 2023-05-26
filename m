Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A263742EE
	for <patches@lists.linux.dev>; Fri, 26 May 2023 15:55:27 +0000 (UTC)
Received: from [213.219.167.32] (helo=deadeye)
	by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ben@decadent.org.uk>)
	id 1q2ZU8-0005NL-AY; Fri, 26 May 2023 17:36:08 +0200
Received: from ben by deadeye with local (Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1q2ZU7-00D7z6-2K;
	Fri, 26 May 2023 17:36:07 +0200
Message-ID: <c83138f6c2b65d0b51868af537ba03533f724cf8.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 076/529] crypto: ccp: Use the stack for small SEV
 command buffers
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Sean Christopherson
 <seanjc@google.com>, Brijesh Singh <brijesh.singh@amd.com>, Tom Lendacky
 <thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Sasha Levin
 <sashal@kernel.org>, Julien Cristau <jcristau@debian.org>, 
 1036543@bugs.debian.org
Date: Fri, 26 May 2023 17:36:02 +0200
In-Reply-To: <2023051729-jumbo-uncolored-05c1@gregkh>
References: <20230310133804.978589368@linuxfoundation.org>
	 <20230310133808.495306749@linuxfoundation.org>
	 <80d3ba7a1b8b7d65713f66ca3562a5ec4971c5ee.camel@decadent.org.uk>
	 <2023051720-studied-plutonium-7fa8@gregkh>
	 <2023051729-jumbo-uncolored-05c1@gregkh>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MlKEEJmnrkg27GcxE0/l"
User-Agent: Evolution 3.46.4-1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.167.32
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-MlKEEJmnrkg27GcxE0/l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-05-17 at 16:06 +0200, Greg Kroah-Hartman wrote:
> On Wed, May 17, 2023 at 04:02:35PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, May 17, 2023 at 02:56:21PM +0200, Ben Hutchings wrote:
> > > On Fri, 2023-03-10 at 14:33 +0100, Greg Kroah-Hartman wrote:
> > > > From: Sean Christopherson <seanjc@google.com>
> > > >=20
> > > > [ Upstream commit e4a9af799e5539b0feb99571f0aaed5a3c81dc5a ]
> > > >=20
> > > > For commands with small input/output buffers, use the local stack t=
o
> > > > "allocate" the structures used to communicate with the PSP.   Now t=
hat
> > > > __sev_do_cmd_locked() gracefully handles vmalloc'd buffers, there's=
 no
> > > > reason to avoid using the stack, e.g. CONFIG_VMAP_STACK=3Dy will ju=
st work.
> > > [...]
> > >=20
> > > Julien Cristau reported a regression in ccp - the
> > > WARN_ON_ONCE(!virt_addr_valid(data)) is now being triggered.  I belie=
ve
> > > this was introduced by the above commit, which depends on:
> > >=20
> > > commit 8347b99473a313be6549a5b940bc3c56a71be81c
> > > Author: Sean Christopherson <seanjc@google.com>
> > > Date:   Tue Apr 6 15:49:48 2021 -0700
> > > =20
> > >     crypto: ccp: Play nice with vmalloc'd memory for SEV command stru=
cts
> > >=20
> > > Ben.
> > >=20
> >=20
> > Thanks for letting me know, now queued up.
>=20
> Nope, now dropped, it breaks the build :(

I've now looked further and found that we need both:

d5760dee127b crypto: ccp: Reject SEV commands with mismatching command buff=
er
8347b99473a3 crypto: ccp: Play nice with vmalloc'd memory for SEV command s=
tructs

(Not yet tested; I'll ask Julien if he can do that.)

Ben.

--=20
Ben Hutchings
I haven't lost my mind; it's backed up on tape somewhere.

--=-MlKEEJmnrkg27GcxE0/l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmRw0eIACgkQ57/I7JWG
EQkqIBAAhKmqztezWpiujZVm5wOcT3ZZTjIHPRhLVyYbVD0F1VtS3Am1v77QIDSL
c21QAzDjkCoLPKz+VUVUA22/+VFLIxkCosaTdbHa+Ni1mIgVhhC1nNHIEzpyQAPZ
HFpu5IvHhjEr7iF5rozGt++tfmCabl+ojD67VQiuBGIdY+C9KR6Ky5Pgf2RwFVyz
KZfgRqqY1Wq9lVldt6QzaTt4iZnu5JIyP9depGHdCoVw7a7aM9k8ZueVjbdOLiL5
ttXmmBP7oOxp6eUuKX3JAtJ+aM2SpYA773fpthoEh1/0a5rqxNwmB82dE6nKeJmd
ZPU1Uly5WL/EC5ReWhm14ovMC9nrnRaF7tk2Up3Gj9XJ/YKVYFS0mU4LMPe8UDU/
7mo/sOKFjRO8fftzl65wPD2D14G78erbv+cSW/gzrQzGCBGZKOlGk0wLsz1A2w3q
Bhhaq8WytHq0CeJ+jYSVq9Gr/QB5/KHNem7UnA7BT58NGf78rORjAKWvCY+Mnwif
FACoaF1xA812z9oXV6e/wmIatMTtMUF6CTIv9Ss1jrWo1pcKKN2LXGj3WyKAFgl1
jHUBETNcyw9nGetNsMV/W//KKoZq1IrP8fjYXJEKH6fKmFXZqWZ1SE8HP2JVSHDM
GW05nz+etFlXyrKu3TeHtTWn6tCounkTgpaa9eHJ09Lvsb0VTXk=
=3ff+
-----END PGP SIGNATURE-----

--=-MlKEEJmnrkg27GcxE0/l--
