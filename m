Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3570829CF7
	for <patches@lists.linux.dev>; Sat,  8 Jun 2024 13:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717853964; cv=none; b=cAUfxWwg1NlDBffJ+Ttr7/W2zno0N5AAQHki2INvcaPipxE+WCyCMUIKxzFG4xmjDcg2chTOc+T0rhDKVO99rtophhNLBNzznlcAh4qp/RZqFgrmmQKNjYfLuPX63tyGCmZmXxEylkO0C1uAVJcS/bj3QFtYBKFxvG3da6PHkFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717853964; c=relaxed/simple;
	bh=uaPK4xrTNaoaOY/sggbFJGDdFEFu0GvkAoaczriQjN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNkFn23IgyLEZWwAISge4SjdrhRuhyYcGIQo34Ne0PM+v3ZztVKC240oLatzSgVLW+XM5lkFrGLRTAotxctG+pD8HaMiqNNT27KkoXXzyvXAKPR/+r7wyg/wuvPGBbKDLIwVySYDBYkHMIVsnASCyBlzXXNu/yp9/bhizlf6PR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=UcWsidjU; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UcWsidjU"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C845540E0176;
	Sat,  8 Jun 2024 13:39:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id CWErTM9s9C7R; Sat,  8 Jun 2024 13:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1717853955; bh=PQ29wWCcL69CHNpGbAphn9Hd4o/BHBI19wH67CwMGO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UcWsidjUwXX4R0wVlaFb0Pe3OrC2PNgzvOqIN7tBpmMNM6NYU2wK38mihW/aiKNia
	 l1YgOF0gXxbplYT3/EHdRhiHNoB4CsDC0svzHOsoGW+aKnr1GRpDLfYr1vRKALbsy2
	 /cbkcVeWgNv0oJ2eukG8WIH+yBfv6ITR54eWsq4mdalK4PDagweK8e36eDiijWcexK
	 Gxp4S3HplJQXIGUbLGxdfUttQFRiFmS9WS3yJm5y8ETX0LitF+5wG+TakZ0qp+hbuj
	 UXZWjLalEWPm3GUAa8HT6rQVcmNMr1peTVoNkGpQheTOfgwKkHl/17MmrMVIvjkcgc
	 cjFLNM1Q9ApD9RTQlTQxSh4rzWHf96Pc1MDVI3LM1UwOE2ETTwSOOBVcHRXEORybH2
	 h4zpbJrZ2r6NSPpDsBxk4laAZHs2WcTStGXtHW/8qhXK30mjWDeCcP0Ym+7Rag49ml
	 Pwu8KpswqJYXnI8ck5P74xfIFY/oFFyZ1+BytzgFOYk8T0eanKwqW7QchKdKya9AFP
	 diD8PvPLbl9VLNUeE/0aXxhpQN4Ys7YLCkOa7KHDcHhb/U0t6TTEnKHG+mg7iOdQ4s
	 zyFkuuilq3O4ym7JuSwZM9N2fI9CIhSFPzJHcOlN8DALOFF7NXKWXll/lizCbQzA+v
	 W38QVOzU2xH0c6E3+8383Da4=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8A63840E016A;
	Sat,  8 Jun 2024 13:39:03 +0000 (UTC)
Date: Sat, 8 Jun 2024 15:38:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v3 1/2] cacheinfo: Add function to get cacheinfo for a
 given (cpu, cachelevel)
Message-ID: <20240608133853.GAZmRe7d3Q3IpXhD-l@fat_crate.local>
References: <20240606164047.318378-1-tony.luck@intel.com>
 <20240606164047.318378-2-tony.luck@intel.com>
 <SJ1PR11MB60830475F52F359E116B2274FCFA2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <SJ1PR11MB608331168096BFEBBB311EDCFCFA2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20240608121207.GEZmRKl3uwP9Bfrx8D@fat_crate.local>
 <SJ1PR11MB6083ED84B69CABBBD3ED9605FCC42@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083ED84B69CABBBD3ED9605FCC42@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Sat, Jun 08, 2024 at 01:27:30PM +0000, Luck, Tony wrote:
> Does this look like an OK direction?

Yap, actually pretty nice and straight-forward at a quick glance.

> Any better name for the new header?

Considering how we call that machinery "cpuhp" everywhere, I think it
actually fits perfectly.

> While I'm moving those declarations, should I zap the "extern " from the
> function ones to match current fashion for this (checkpatch barfs all over
> them)?

Yeah, you can ignore checkpatch or simply do another patch ontop which
does just that. Code movement should be only mechanical movement, with
no other changes for ease of review.

In any case, thanks for doing that, that looks real good to me.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
