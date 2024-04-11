Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A6147C7E;
	Thu, 11 Apr 2024 11:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712835070; cv=none; b=i4gQ2m99oQwEjQnsVnt5SXJ1rdUPyCWCRTnPJbbqhSUAU9b0slGG3o+ONh6d8T9xqRrCqFbzFtuIGF6SpAIMLyjV+H+PGI2DRLpEGzOYwivGDd51e9ds9JVF/DQQ+eo5+DbTAPDKEm3suBK66Jxspgowj6p89/Nc8Re4LeyDVqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712835070; c=relaxed/simple;
	bh=8bmXSD5TR7GbqIdLzPU0tqPJQzerrcPq9z5gHkP2tOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mElXHTU9cq75+LnHcAaCzL80Ux3CRklLWlR6wYkd5RUh859uAYlADuj3L3fCNSFjhdo7CsRbbBVuI06FJ766wCjMFyiwQCLANpn3xsiW4GjNC9mZ9we+/0TsTMlWFo8xhojhqyeQzTDe88cyyGPfeboc+2ZqmHMwJZSAgBQWzp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=F8zmltR3; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="F8zmltR3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tERq9opbCgfNNvRYcUZvTrrVQXEmLqhRg5dU9H2JR9M=; b=F8zmltR3z/q/DpRNN3XdVVS53P
	1QwNidq7FV9L5uZRYdnrui5DxIrUXKcyjExy/TSyyomaFPpScty2eBOxAPPbtFLhRB9gYR4liU1JQ
	vMSGRBJfzJbHnb5KBF8a7Z/UGZVs9gb8P1z409zBZFehImkHr9DEuSdhqVO9nIDlHAZwAFohWBrAG
	EyEJiOVQKu0LXrdGhFBC76FQC61MneHgZFjYcH/rSPiEOUziSSIK+TGGKO043xOiOG/yCwuQRWZEL
	yBBk+tc6NXHhP8fJmqqyn0z6a9O3Q5czhpU37dIkB+2FG/Gs5JdHtM7z9yMF1VLvaChfBmkjvStVi
	2HEyM0YQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <kibi@debian.org>)
	id 1rusdx-001nuu-Ug; Thu, 11 Apr 2024 11:31:02 +0000
Date: Thu, 11 Apr 2024 13:30:59 +0200
From: Cyril Brulebois <kibi@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 76/83] scsi: sd: usb_storage: uas: Access media prior
 to querying device properties
Message-ID: <20240411113059.w743nqi4d7hydv4z@mraw.org>
Organization: Debian
References: <20240411095412.671665933@linuxfoundation.org>
 <20240411095414.976726082@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ddytng5kuvofzsfp"
Content-Disposition: inline
In-Reply-To: <20240411095414.976726082@linuxfoundation.org>
X-Debian-User: kibi


--ddytng5kuvofzsfp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Greg Kroah-Hartman <gregkh@linuxfoundation.org> (2024-04-11):
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.

Test report initially submitted to the thread where that patch
originated from:
  https://lore.kernel.org/linux-scsi/20240411044021.xejk54iznz3cdxem@mraw.o=
rg/

I've confirmed that applying patches 74+75+76 on top of v6.1.85 fixes
the (partial) loss of SMART information that started with v6.1.81 (and
cf33e6ca12d814e1be2263cb76960d0019d7fb94 precisely).

That was tested in a QEMU VM with a SATA disk (that exposes only a few
SMART attributes anyway) and also on baremetal with real disks (2 pairs
of Seagate IronWolf): smartctl returns data again, including
temperatures.


Closes: https://bugs.debian.org/1068675
Tested-by: Cyril Brulebois <kibi@debian.org>


Thanks everyone for the swift replies and fixes.


Cheers,
--=20
Cyril Brulebois (kibi@debian.org)            <https://debamax.com/>
D-I release manager -- Release team member -- Freelance Consultant

--ddytng5kuvofzsfp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEtg6/KYRFPHDXTPR4/5FK8MKzVSAFAmYXyfAACgkQ/5FK8MKz
VSD6RA/+NtFdbFMsg45RllOQVpB/P9Q/Y0pd9OOTYhU8ZgSXCho3HrK8gQIJHX1N
3Eleh8/WCvdW9vP7Swp6aNTsgmnTskuzIQivxoUZrR8c0prf5MnHi8IA26ijrOhr
xXTsdy4bUJq2ul/0dmLO5JSrtled4Xv8wHvPjYQPq8AdhQaFwRyM+x7aTSOuzkJV
aANt4j1bZyy2j+VPqMNhb49RoJ5u6gzegN587tlwV8MRJ61abKB2//MYv8FQLy4R
+4ssAYJqwhr91I1APXo4QwXg69o3PnEBYWZHZ9we/vRmLD49JXCVvghsE4v1QekR
UoWJSxzghm+LVuYEDOqbzKnJuiOHbcFx4TB0zsmt1X9d8wCgxOAKQtRK3stjJb5/
FkWaZ/FqSjpT+VhOKSOISUaA555OflFt00ORCyvIjjNWOWe4g7JXXzmHXXtBPSIt
z6Co0URZTcFdk3uY93ZxdNQZkVD55X5UczuRtaMo1mn08kL1A9//oIElu6rXPM3l
ghqFNyo2tURccRRh6RPG+b8itj88aKvxMjh/Uj5/oeR2GfT0oyRjhqpg4uGxNOWL
YmKasCgAcCGLjkEgN8HzS31rc6XZ+sflodzb9rZcuWXpnW0DEeL5Uf1Xm3zKt2gw
rXubtMrHzhGPSZ3jpTGP0a8tpGXoQ5jW0XMY6RpZXq5wruU8wFI=
=eSaE
-----END PGP SIGNATURE-----

--ddytng5kuvofzsfp--
