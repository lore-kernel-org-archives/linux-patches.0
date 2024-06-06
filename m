Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB726194C99
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 10:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717669894; cv=none; b=AZE6I/SOoHJromufXWML8v3uQYvOkWVScCsfmX22Gf+fq96xrmHS7Csku09lR7KPsLWQPARQXjDI2YlKbrxZkJIQFJ64Ra3+NKvBMpY+mMUpNf9uD6vEpJZKUh6s/tBkyRo+sseb6mU3okp4P+KP/hlBV5Cp3jClE9dvaBHxcl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717669894; c=relaxed/simple;
	bh=QG+XegQ1/r/iVUT6bSZGmh9xwOPL3hEw8L1Gf5xCFcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OdwZcJPlkWKggOpjp6UDUhyTn1cLQ5E9NEEP0cy31Fagsr26aZmEej4xVaQYsPlWe5gXhGA0Z2YMHqN9WhiM9GWnEo4S9q6nuSwqXtpmVJplUb7G5b8Q19HMhtnzKcSjMqlxmYeK2aMi9Vxi06ijY3ECOPHKYuRHi92cG7HH7J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=S7nT68Vm; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="S7nT68Vm"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DD16A40E016C;
	Thu,  6 Jun 2024 10:31:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cSr9dqY6uZdE; Thu,  6 Jun 2024 10:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1717669880; bh=KSCrX9oB1sfb0YE4irfnaZKrDq58FuJQTvrmtflRjIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S7nT68Vm6PWiPQK/kUXGHOV1a00Ckv/4KaHfLScjWjmWMCC/ATZbacSh3u/jKJS58
	 tNwSQI20buLwtv0EU0iKWJ/g0GB04GbFj/Wlf/tdT0IWsmPzRMXNr43ibDKEXicH8n
	 Y9hJrhyPiEqOFNaBwbs82pk4GPUU6kf3LsvXN9IdZzzZi5PXKY03sJGa9uX3Wl0m/w
	 eBHvTNTqfsPnInKov9xduRnVM3xCGgbU1pkJOm5or/DNPB8lG0dADT9zNsYgWW+a88
	 ENwez2SRaerxhwQUzFSlQ1rtkzoV+zRCXaii1DEh3Je3B8RBTMmqIbKnu1CKP8svbJ
	 bA59Z6ux9rVclmfriVWlSOjDDDS4HS4+18tSUkHQrpC/hMLaLDRIdxFsxZN4hfoozr
	 BtQkmnfAfxlOvdwetpo9YYYd4MHD7lHh7vn1oTpw+Q0xYvcwo3xyYal2P6KOq1hb+V
	 +lLin/DEkPntkH9buKfhP82rfHWjFobsn9bcVqPlGRaudFW4ioNfz2S5s9dPX4qszX
	 VcGXAg4j0xYvJf5S8ny8f/lSGXjyt9Z6AECRUJ9fW4e4DEYpmGZXE+rV3zwnbP7MYF
	 M6Iv8/lMyoM0T7VuHfqaj+WGsWhPSzoMnzfRlMYNmY4Jn7AafOuV8xDs0GbtlBHhfV
	 GU9sv8Dzd2hF13dY32/upY/Q=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 14C7F40E0027;
	Thu,  6 Jun 2024 10:31:08 +0000 (UTC)
Date: Thu, 6 Jun 2024 12:31:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 1/3] cacheinfo: Add function to get cacheinfo for a
 given (cpu, cachelevel)
Message-ID: <20240606103101.GAZmGP5Y6389EvCb8S@fat_crate.local>
References: <20240605161427.312994-1-tony.luck@intel.com>
 <20240605161427.312994-2-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240605161427.312994-2-tony.luck@intel.com>

On Wed, Jun 05, 2024 at 09:14:25AM -0700, Tony Luck wrote:
>  /*
> - * Get the id of the cache associated with @cpu at level @level.
> + * Get the cacheinfo structure for the cache associated with @cpu at
> + * level @level.
>   * cpuhp lock must be held.
>   */
> -static inline int get_cpu_cacheinfo_id(int cpu, int level)
> +static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
>  {
>  	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
>  	int i;
> @@ -124,12 +125,23 @@ static inline int get_cpu_cacheinfo_id(int cpu, int level)

So:

	lockdep_assert_cpus_held()

?

>  	for (i = 0; i < ci->num_leaves; i++) {
>  		if (ci->info_list[i].level == level) {
>  			if (ci->info_list[i].attributes & CACHE_ID)
> -				return ci->info_list[i].id;
> -			return -1;
> +				return &ci->info_list[i];
> +			return NULL;
>  		}
>  	}
>  
> -	return -1;
> +	return NULL;
> +}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
