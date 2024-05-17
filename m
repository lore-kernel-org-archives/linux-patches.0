Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40C21CAA9
	for <patches@lists.linux.dev>; Fri, 17 May 2024 20:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715978568; cv=none; b=JAs8xj+PYuZXA5eqsU+7JIEFBjNPObMePZ6srZZPpx2XeugcUg3ZjpEoETio5FvC77dRh7yYMXQX+t5yp3UmxjDjjBkOhlZT8jmeLjWWzuxc9cKc0vjllEs/pqgnKdg//cHiEYx4iS0jIHHR17koijpuXd1RHyoEseQ6zHRaR9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715978568; c=relaxed/simple;
	bh=/aD3mENHTyGvfBzxvu8ejeq/Mm5dAFbXQMuFoOrnsbE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TJnxGffaITRKRDkk0VVrw9L9GV8M5gTHEddXwjIcr9nFDvrRoeBj5RDzqVm40rUkOquDT8ZQHoCgVoNRwLwJIEs5SDmJqtUz51aIUZ8knHbU89XSaG/7oq5qRdwVpxKi8a250BHOqR1/van+1ez0fpPPaYWUacQ2B5k1sr+S/Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=4fqrhmru; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1yREj0KP; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="4fqrhmru";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1yREj0KP"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1715978565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nb8T9+YAZvVq3/tnQ33z15ugIKC5aFR13sHCOd9V6s4=;
	b=4fqrhmrupFz9sg/pwPYQhp+gzZPmg04C3vpkpI5WWKwA2u8jZjEh8f1XSfYwAqSeHyq4n+
	hlummQwSf45aPFCzWb46IAESFaik3jmLYZJQv9c0hqZmht0vBonKLVIjNCiFPCPwwbk+3v
	k2QH8/Nduvqn+ikUvCixbC2JiJVmb8O0yTM2iIk1Nwv7ELPOzentaQEa2E3MVyl86zsd9k
	8toR4fryjFtnGYZZYbIv9LBp/VfuD7U0jVFA+MRFabyl/1nRWA+tBWOOE/v36X3EmC8o96
	8Ql1MK1PVJBXAexH7lDtZtslpw7DBhJ0JFKabt2OqqWd/Te4wiQkBP3mkQkvpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1715978565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nb8T9+YAZvVq3/tnQ33z15ugIKC5aFR13sHCOd9V6s4=;
	b=1yREj0KPTwOvCCsfxoGNuaMn+Mqt4hw8mwoT3svxlmZd3rbc/9KyZPDd1D90owUmxqQ5q1
	xp5p1fE8Ugf01UBw==
To: "Luck, Tony" <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "Peter
 Zijlstra (Intel)" <peterz@infradead.org>, Uros
 Bizjak <ubizjak@gmail.com>, "Edgecombe, Rick P"
 <rick.p.edgecombe@intel.com>, Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik
 <mjguzik@gmail.com>, Thomas
 Renninger <trenn@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>, Andi Kleen
 <ak@linux.intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
 <patches@lists.linux.dev>
Subject: RE: [PATCH v2] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
In-Reply-To: <SJ1PR11MB60837E7CD8952271654EA379FCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240516162925.79245-1-tony.luck@intel.com>
 <20240517144312.GBZkdtAOuJZCvxhFbJ@fat_crate.local>
 <863D0F06-1217-4C94-B2CA-816FC4ABB103@zytor.com>
 <SJ1PR11MB60837E7CD8952271654EA379FCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Date: Fri, 17 May 2024 22:42:44 +0200
Message-ID: <87eda0jhkr.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, May 17 2024 at 18:17, Luck, Tony wrote:
>> I'm confused. Why not simply use say -1 for wildcard vendor match, -2
>> for no vendor ID (no CPUID or other known probing mechanism) and -3
>> for unrecognized vendor (vendor detectable but not known.)
>
> It was really convenient to have "0" be the wildcard for all of
> vendor, family, model, stepping, feature because users of
> x86_match_cpu() could just initialize the fields they cared about in
> the struct x86_cpu_id and have the compiler make the rest be 0
> automagically.
>
> But X86_VENDOR_INTEL being zero has always been a thorn in that scheme.

As all initializers are macro based, that's really a non-problem.

Thanks,

        tglx

