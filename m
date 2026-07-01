Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FE336A377
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 20:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782938279; cv=none; b=DGgf3Qcsjpx/rf16Gw89nAs5HdH3900DXT0Gg3tGKWRVL13jgw7zywn+MP/lBFqryDybvsWWtSjym7iMbuqADt2IhCaACtvQw8EVtnWPb8JjCZowN7asPmvZNRw7neiuLL8TD8MudYQEcuUhDYuoz34QV4hPhXO8XhKxr+2aDFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782938279; c=relaxed/simple;
	bh=iGhnoczsLBeVrWGKpe1o+6/CWqdl+LF+BNZ0Bebn3Kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MC+n18dGlXJIOnQIWnnj4ZS20sjuI76S58LHzT4g9vwu0bnK4s+m62jDSsAG3UGWJlGIi5f+iCln6Ydp7dMsSOoAISm9oVWDA5aZ8sgm5HbYcvEWSkZzL75BdmV1c5HseDqZhvclxE9cfiodPrCvWtexP1F4GK8N68j9esWy84M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=SVpgmXvr reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="SVpgmXvr"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DBA0B40E0140;
	Wed,  1 Jul 2026 20:37:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KZK5Chak0fJs; Wed,  1 Jul 2026 20:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1782938265; bh=kfYtEyEDBjOcbmK3Iqd8N99klr+OSFpJcEb2n2QRX4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SVpgmXvrF+IR07EeeZ5AODhT8ED42RwNEX99mB04y2V/O0R8MYmBqjYWRVT7OJYGL
	 mAu29lkI3BXp5OiGcj9aiUlbykfBQi38CsDyj4UcevABwf4rJyb5z6jmxvhk93+KMY
	 wbmBntAMD7//hgoKu9w5NoubN2GuZKSJLZUGnEUDJC6YYof3mWbbKEFtT/nOaf1qMp
	 pG/OrprcemnKt86L1fW+6tl1YXgrUpvgZ2in4QhAI3xlPsGqm59fsAgngsIKg5/QSf
	 f+0PwABtX+lD4hDFR6A9j44SnYjHxJGCBXTzGy4McFLXO3euaiFbTQNvVgajf4LQ1n
	 9AktQ2YtsOfuQKZlB7lByXoguntfggal43QKdJ4IPFlgXCDGizuhTX2yeUcckHVWuw
	 mARZ8pLjRPaiaGk/Cb3Qz2D9zIvJ6A0xJ7RD/vpN0b04RweB6cUUXeDlWrQFsocGuY
	 e6C8w4CbEeJWveO3o9QaTNlzvYThlaMhGMD0isxSng8k7EWbIu51pQdLivH7LTxEHE
	 wdyjZ9p3t1uLVBUflAdEWx+RIRp2UUkK/SwCxihi1X6YxTXqkqHsSwl9XY+vVDu8u/
	 hf9GFmnaHacQp7tlOtRBthWoCWaBotaQtwZx/qwDrT9LfbciXBx9T3NT+KasS3Gz26
	 isBMzW6tpu5ey4tL4t+JlEqU=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0ED4240E00BA;
	Wed,  1 Jul 2026 20:37:28 +0000 (UTC)
Date: Wed, 1 Jul 2026 13:37:25 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
Message-ID: <20260701203725.GCakV6hQ9-x2BTBEnx@fat_crate.local>
References: <cover.1781029125.git.reinette.chatre@intel.com>
 <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
 <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
 <b58d51c1-67f1-4640-b00a-1a99dc93ccef@intel.com>
 <20260630225759.GDakRJ93cg21As0xnf@fat_crate.local>
 <20260701170917.GCakVJvegWA9R9liDV@fat_crate.local>
 <4ba1c1b2-325f-477c-b7de-c12bf72990e8@intel.com>
 <20260701194027.GBakVtK7d4XKEeCZ2g@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260701194027.GBakVtK7d4XKEeCZ2g@fat_crate.local>
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 01, 2026 at 12:40:27PM -0700, Borislav Petkov wrote:
> On Wed, Jul 01, 2026 at 10:55:38AM -0700, Reinette Chatre wrote:
> > I agree there are serious issues here. What prevents me from advocati=
ng for them
> > all to go to stable is that the fixes to the intricate races required=
 changes to
> > resctrl's core locking flows. I absolutely tested and scrutinized the=
se changes but
> > having them go straight to all the stable kernels feels like a big ju=
mp to me.
>=20
> Makes sense to me.
>=20
> > The fixes that do not involve locking changes are below. They could b=
e considered
> > for stable.
> > 1/11: x86,fs/resctrl: Prevent out-of-bounds access while offlining CP=
U when SNC enabled
> > 4/11: fs/resctrl: Free mon_data structures on rdt_get_tree() failure
> > 5/11: fs/resctrl: Fix use-after-free during unmount
> > 8/11: fs/resctrl: Fix double-add of pseudo-locked region's RMID to fr=
ee list
>=20
> Ok, lemme hoist those up into urgent first.

Yeah, not easy, see below.

This is because 3/11 which is moving the functions, is missing now.

We can do a forward declaration but I'd let you reshuffle things the way =
you
want them and send me the urgent fixes by placing them at the beginning o=
f the
set so that I can stick them into urgent.

I'll queue 1/11 only now.

Thx.

fs/resctrl/rdtgroup.c: In function =E2=80=98rdt_get_tree=E2=80=99:
fs/resctrl/rdtgroup.c:2896:17: error: implicit declaration of function =E2=
=80=98mon_put_kn_priv=E2=80=99 [-Werror=3Dimplicit-function-declaration]
 2896 |                 mon_put_kn_priv();
      |                 ^~~~~~~~~~~~~~~
fs/resctrl/rdtgroup.c: At top level:
fs/resctrl/rdtgroup.c:3153:13: warning: conflicting types for =E2=80=98mo=
n_put_kn_priv=E2=80=99; have =E2=80=98void(void)=E2=80=99
 3153 | static void mon_put_kn_priv(void)
      |             ^~~~~~~~~~~~~~~
fs/resctrl/rdtgroup.c:3153:13: error: static declaration of =E2=80=98mon_=
put_kn_priv=E2=80=99 follows non-static declaration
fs/resctrl/rdtgroup.c:2896:17: note: previous implicit declaration of =E2=
=80=98mon_put_kn_priv=E2=80=99 with type =E2=80=98void(void)=E2=80=99
 2896 |                 mon_put_kn_priv();
      |                 ^~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
make[4]: *** [scripts/Makefile.build:289: fs/resctrl/rdtgroup.o] Error 1
make[3]: *** [scripts/Makefile.build:549: fs/resctrl] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:549: fs] Error 2
make[2]: *** Waiting for unfinished jobs....
drivers/gpu/drm/amd/amdgpu/../display/dc/link/accessories/link_dp_cts.c: =
In function =E2=80=98dp_retrain_link_dp_test.constprop=E2=80=99:
drivers/gpu/drm/amd/amdgpu/../display/dc/link/accessories/link_dp_cts.c:1=
61:1: warning: the frame size of 1032 bytes is larger than 1024 bytes [-W=
frame-larger-than=3D]
  161 | }
      | ^

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
