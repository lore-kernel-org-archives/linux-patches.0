Received: from elaine.keithp.com (home.keithp.com [63.227.221.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A499E76048;
	Tue,  8 Oct 2024 16:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.227.221.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728404279; cv=none; b=jJxhzraaT5gQzR1Fy59SX9KTiXJNm2vd87a+Iuad+dlpDbgc+ZEjOZfxdaNQIYU3A6NUqzr7nO69TORxrZ8rS7uRhjY+08mM3RUGK66XlXhm1lKBaT0aiyvBM7ncI6GXzWmch/16qKRM3YcHgdcdcsh0DiPi+tsXsU6WbbmnYb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728404279; c=relaxed/simple;
	bh=Be1lMPNnE3lyAmS0s0JekcNeCZMW9LO8oGmCCamfWiY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KgmVUBPdSql8SwVjlA7fRTTKV8vlc/hXXakD3oAAAfW6MFS5fEtE59BiEM9lz5DfXwwQ6zWBkiyHStM3L6maazS2+p5D7rwMmAB/XNKQOl188//d/i5Qv1BXYUazPqNGgTXolN5OfE/TEMGonSvpVzUEApxJG0KnzB4t8HVr470=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=keithp.com; spf=pass smtp.mailfrom=keithp.com; dkim=pass (2048-bit key) header.d=keithp.com header.i=@keithp.com header.b=wi5UHOGz; dkim=pass (2048-bit key) header.d=keithp.com header.i=@keithp.com header.b=e0/Uw2uz; arc=none smtp.client-ip=63.227.221.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=keithp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=keithp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=keithp.com header.i=@keithp.com header.b="wi5UHOGz";
	dkim=pass (2048-bit key) header.d=keithp.com header.i=@keithp.com header.b="e0/Uw2uz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=keithp.com; s=mail;
	t=1728403701; bh=Be1lMPNnE3lyAmS0s0JekcNeCZMW9LO8oGmCCamfWiY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=wi5UHOGzMPYDdaMlW6tAM0wzB8FAZqDhWv92xGXqSEUqu7UV2hqmBSumlq6u6YaGC
	 nm/Il6qLql7wMjPuJPYrsJvpTD380HBKq32xW4Omunf/U/mrHMqWFTEHgq6TY/sCgV
	 L7+mOTBuXhWnc+ft5GzRLDRL3u4qY5ZhL9RoI76mlIArSctcAuqxQBPWQFHOqSOeNk
	 fBeyz7QCEMfCjwFFA5YhKVQNhwq7H6tDXu+2MzgaXvYiFaafyVUUKJccQ0QdzfGzKQ
	 b+oIaB6dkGEsa7R2aUsrL2KVi1yi+SpE4W5GEGlMOSBiMvi/nXfkk8kXW2+y5I3o/Q
	 B+ailmMqIYXcQ==
Received: from localhost (localhost [127.0.0.1])
	by elaine.keithp.com (Postfix) with ESMTP id 1A8703F20A16;
	Tue,  8 Oct 2024 09:08:21 -0700 (PDT)
X-Virus-Scanned: Debian amavis at keithp.com
Received: from elaine.keithp.com ([127.0.0.1])
 by localhost (elaine.keithp.com [127.0.0.1]) (amavis, port 10024) with LMTP
 id wA-LEzRtO2wP; Tue,  8 Oct 2024 09:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=keithp.com; s=mail;
	t=1728403699; bh=Be1lMPNnE3lyAmS0s0JekcNeCZMW9LO8oGmCCamfWiY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=e0/Uw2uzSRNbLGxH1f5Vd//kAsgVYBI6+Ul0EuQeHEB2OfXgunGqjilMV/GChdZmM
	 ci6E9pHuPl8q8IulQcOKjNsifUOYXqQKqgZgRUliS3vunFVFMBeSSPiN7tXqpVl8uq
	 H5mU0bU7Vn3zaDiIhz+S66yKT+zwJUMI3UtPdI3fIsnbBvA5duj/HhMxdHWaNN0qR4
	 0XM9NIbuH4SKftzPQlvNp9yHmjUQsxyB61af7lq7g5NJAAMeTTV/+dGUA7zzX/4hcj
	 4Bf+6rw1UhrhXjK7N3iIE5wTYf65Yu35xMP/0XA3j9xhe+El0lgPkoXfzbP38FhWl1
	 /Om8JYcp3zeUw==
Received: from keithp.com (koto.keithp.com [192.168.11.2])
	by elaine.keithp.com (Postfix) with ESMTPSA id D5D763F208E2;
	Tue,  8 Oct 2024 09:08:19 -0700 (PDT)
Received: by keithp.com (Postfix, from userid 1000)
	id 597E41E60239; Tue, 08 Oct 2024 18:08:19 +0200 (CEST)
From: Keith Packard <keithp@keithp.com>
To: Christophe Leroy <christophe.leroy@csgroup.eu>, Nathan Chancellor
 <nathan@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>, Naveen N Rao <naveen@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Nick Desaulniers
 <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, linuxppc-dev@lists.ozlabs.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 3/3] powerpc: Include -m32 / -m64 for stack protector
 Kconfig test
In-Reply-To: <a57f21db-911c-4331-af7b-c02c0ea8b1e6@csgroup.eu>
References: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
 <20241007-powerpc-fix-stackprotector-test-clang-v1-3-08c15b2694e4@kernel.org>
 <a57f21db-911c-4331-af7b-c02c0ea8b1e6@csgroup.eu>
Date: Tue, 08 Oct 2024 09:08:18 -0700
Message-ID: <87o73uvaq5.fsf@keithp.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> Why is there any restriction at all on which register can be used ? I=20
> can't see such restriction in GCC documentation :=20
> https://gcc.gnu.org/onlinedocs/gcc/RS_002f6000-and-PowerPC-Options.html

The clang implementation shares the same code paths as the user space
thread local storage implementation. That code uses a fixed register (2
for 32-bit, 13 for 64-bit) and a fixed offset (-0x7008 for 32-bit and
=2D0x7010 for 64-bit).

The new code controls the offset value with a command line parameter.

I didn't see any need to make the changes more complicated by including
support for arbitrary registers. The implementation would be reasonably
straightforward, but it would make testing a bunch harder.

The command line parsing code validates that you've selected the correct
register =E2=80=94 if we allow other registers in the future, you'll be abl=
e to
verify whether the compiler supports that by testing at build time.

=2D-=20
=2Dkeith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw4O3eCVWE9/bQJ2R2yIaaQAAABEFAmcFWPMACgkQ2yIaaQAA
ABECOA//Sm+07+C6UnNX8tFcnftLQhSmKWADbibLW63BL6QrKDIiW4/KWPk7kyiN
vCqwS5vQ3vxWizedY2o/JZ4DiO7gtHDue9ikTkBnHs5w1lNjoOOd2NaV7kaaUkJW
AgXU8dZL0ldCFbeF0YqXuQ9ugf6D/FYK0trvurrHffvS4qMcE/C9SYG+5LkbCm38
vjZfihr32X/7QPXnRNqdNAp64Y1N3P0iPj/RdNpvg566mPhTDRr9gdMYH87l0uDX
Z+svG3DTILn96nPqlUG9hH0m0f/iW5D3aBuRuwZo5W3YbcKGTGaUhRXIukYZ4PCm
pI6U9wJMlSUMF4DggW0ZkrZmEOYOTEASm+LW8b7Z+vtd250lyeOFOCQDOhTdiYuP
RPVEEE+KgHAjO4S6NAoko7zBr4BkCnOXjRdP/xIw5ljorDWlJweL8C+AsjviSTpW
KxsKJbEHbJRMFyar8cGnRGbKG7eOg2sgQE5xz+bLwicmxTj5hd/5MALrg9W5fpMd
NmsL2lIhem54JZnSSfX8GO3iKfNI8d4Ra52b1hLtd5ZuJdu3vXxkcgq5puGpnaKA
EUDrcRPfofvlY8LCtAx5r8rCTonpeK3AwzXr3HIb30MgGhryzVBXCgsk/cnq6gAB
/tmswKMTEq/AALZryZ+7mFOXOzxcshzk863kdYkgLiwNJdQ9hKA=
=3DzG
-----END PGP SIGNATURE-----
--=-=-=--
