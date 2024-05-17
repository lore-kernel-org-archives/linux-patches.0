Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF70E12F583
	for <patches@lists.linux.dev>; Fri, 17 May 2024 20:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715979201; cv=none; b=ZL4xERblpX/49nzRwY2OFwe5Ws4TpNG5x9nvkoskNOOJT9WtPU7FK7ZlSVYgv5hN5HQHN6Gy/XE5wvubdU4/MUj2bY4NDapHoqg6Qzb8XYP4IN8w8Gblq5Uac1dlzjGg8BNCkm3pVH77kMwIK2equWpPZ1Nk8GfI7k3G1gZEyJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715979201; c=relaxed/simple;
	bh=tK9pBSIz6Z4aG/7wfoByRED2a8aC5VOKanqMUCImif4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=sZ6P1cStgOWGruDQsOUQJJ1y8sU1K4K8EKhcrjWCya9aOfXCtbZw2bWZ8bfubiT2aljobvSlh1iG5dt6ZGu5MK2k+nT4HUdKrrX4Ce6quBH38qgTEN/nr35eE9ZaSECpsnMDNRDHLc6IbB8HxB9a5DMaop54pHk6ifWZ7oelLfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=AsHJ+WWG; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Q+mrmRFC; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="AsHJ+WWG";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Q+mrmRFC"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1715979198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+qZPdcMmSdZgJZSuN/e5pS3lfwWTp+KrsaCYNQeGP9E=;
	b=AsHJ+WWGU1BYBKW00N2nqdTHD76QGP5j5UvB3e9vfbLzHvmfaYtBm/esPGUrWUbJSMmSAH
	8td0NYONmdzabawHauF5UjBpnWARQf6UKKN53FyJ/N+M4a8TLdKxcFJh+EdPh3t/6kLk8G
	CmLkw4G9Zip/O0e1vOFUju0ZNb6/Ap88dJxVJWoybyZPTa0aod0KqhfRxwGnIDV+zG9Rrm
	VICjP2euQHpsaaaERlN3iuTec9XS0JdHQsVoHPNYHButqAX6uhsPVkfyU+h90Bwyx5+49q
	RppMma5dcWlxMdMyeXM7yYSOo82Ks2KnVAZBo6XuyX7lkE8OnPKmNJO8zAqxEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1715979198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+qZPdcMmSdZgJZSuN/e5pS3lfwWTp+KrsaCYNQeGP9E=;
	b=Q+mrmRFC1dKcN11RbggtjjRhForM0Fm4nnWUZIhtXqM0lIgx6nFoGaxhrdArfvM3ZYMMaO
	JqACZN99mn6D9ZDA==
To: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
 <peterz@infradead.org>, Uros Bizjak <ubizjak@gmail.com>, "Edgecombe, Rick
 P" <rick.p.edgecombe@intel.com>, Arnd Bergmann <arnd@arndb.de>, Mateusz
 Guzik <mjguzik@gmail.com>, Thomas Renninger <trenn@suse.de>, Greg
 Kroah-Hartman <gregkh@suse.de>, Andi Kleen <ak@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
In-Reply-To: <SJ1PR11MB608353ACE099975A02532C6FFCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240517172134.7255-1-tony.luck@intel.com>
 <20240517173811.GFZkeWAzKjYtEMwe1e@fat_crate.local>
 <SJ1PR11MB608386716D1DA533791DE7A2FCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20240517175324.GGZkeZlNgjGxwfumLu@fat_crate.local>
 <SJ1PR11MB608353ACE099975A02532C6FFCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Date: Fri, 17 May 2024 22:53:17 +0200
Message-ID: <87bk54jh36.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, May 17 2024 at 18:13, Luck, Tony wrote:
>>> 	for (m = match; m->flags & X86_CPU_ID_FLAG_ENTRY_VALID; m++) {
>>
>> Yeah, makes sense at a first glance.
>>
>> This'll keep the terminators "{}" unchanged so that we don't have to
>> touch all those gazillion places and it'll explicitly state that an
>> entry is valid or not.
>
>> But the devil's in the detail, as always...
>
> Yes. One detail is that there are places not using the X86_MATCH
> macros.

Groan.

> E.g. in arch/x86/crypto/aesni-intel_glue.c there is:
>
> static const struct x86_cpu_id zmm_exclusion_list[] = {
>         { .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_SKYLAKE_X },
> 	...
> };
>
> This one (and likely most/all others) will be fixed by the remaining
> patches in my new families[1] series.

AFAICT, that's the only one.

# git grep -C5 'struct x86_cpu_id' | grep '\.vendor' | awk '{ print $1; }' | uniq
arch/x86/crypto/aesni-intel_glue.c-



