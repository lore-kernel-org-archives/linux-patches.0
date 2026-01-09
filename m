Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7534E32AAB5
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 12:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961004; cv=none; b=edCGqV0actRbBbnkNi3+sRkZmn0v78y1fiUbzT5DDz7HT+ONa3Ip5cGF7xy6nz8+sizm2uKiX++i/PPBkyEXGi8obI7l2VSHEn5wDHD2nclITQ+JTdaCttyrDMW+u/kmT6M7Q1vu8WHAdnL+3IQ2Jn00wMPIIOIpLcJ9Id4ZfwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961004; c=relaxed/simple;
	bh=jTHUV6fRTSTplP0cGbAt1lgoK/jUri89iQSXMsp77dE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YgDqTFj7U2E+p/gAX9hOeC4NrwBi45lImsPVZSGQtXgdvdS3hsKTBPPoI3rd0qjBK6ZwDf0SOEWDx9CZ0hCU+GifWfw7RA5uH15pDZYMyGMTuETkM35DgACQRKc0rZNlKrdW3xz9Axw/7pF9LwHoq7wU3/jmNnHRjYO3NGy8MK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=TNOqSDdc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="TNOqSDdc"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 197E740E0028;
	Fri,  9 Jan 2026 12:16:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NR9lmZ4QDcbm; Fri,  9 Jan 2026 12:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1767960996; bh=a8xCz826EKiF/7IA9kRCtlsPiiXHoYRO0MEfG2t7Hik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TNOqSDdcf2RPzTBFb4EoqGyT37qwzU1xJJzrpB8vXTG/3Y2Y7Q+e77+NH87kCtiwB
	 1azVstQfz+0QNF4oMUepAFF2UxACpB5MzG+5UEfCYXfWzQlxgsp5bHxB7NkaY9oNfO
	 oX2hnRHIsP7HPQseTxf+JC70no5JW9MwVAKUDjG8rOmMW0wA14B83sXfhIkTDkLdQ4
	 ywXshIL3l9g8+wjBy1rsC1Jd8H1p0CDdySYbqZD+b4rheQq8uKnr2A3iktHKFzoxoW
	 xzA9aAFx3xsCaEMKTM+HaRfFkw8Z60qQil2Pk8jlDFTqzNcaZVYKa+Ff2RHA0/9DOS
	 P0EozsrELy5uTPWRnoj+zHrzrUPto0Lev79yv9RiknCT+R9beOQYwn9UVQfbvYFX4O
	 nawkJrSzMOprfve/nbpdaSXEiGvwhIiYhjXnCagVIKkTp4/uzqWjQWJYGmqeZfl8Oe
	 og0JCrwfsKcsVvhEc3IaVmE1rUgqxxD/xleAC2+gzahgwDYv2BxLBdipSdkMXSTNPg
	 CsTJuXqJb+qOdEJi8l8MkeYyou9M2Oq0bRNjCQz7QxsLlQdM5LKhlEaLexoC8TDlCv
	 nJu2v6yh8ums6DKkp1SyJujyPIj4RLB6xW7g0F+8gYyeC4Vz4pZ4gofiLdc0Z1fb6q
	 isXU2CBx7+OnqwTEkMTqDAHM=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 406D240E01B0;
	Fri,  9 Jan 2026 12:16:23 +0000 (UTC)
Date: Fri, 9 Jan 2026 13:16:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v17 19/32] x86/resctrl: Find and enable usable telemetry
 events
Message-ID: <20260109121616.GBaWDxkGvgJ6sd133q@fat_crate.local>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-20-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251217172121.12030-20-tony.luck@intel.com>

On Wed, Dec 17, 2025 at 09:21:06AM -0800, Tony Luck wrote:
> -static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +/*
> + * Clear the address field of regions that did not pass the checks in
> + * skip_telem_region() so they will not be used by intel_aet_read_event().
> + * This is safe to do because intel_pmt_get_regions_by_feature() allocates
> + * a new pmt_feature_group structure to return to each caller and only makes
> + * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
> + * returns the structure.
> + */
> +static void mark_telem_region_unusable(struct telemetry_region *tr)
>  {
> +	tr->addr = NULL;
> +}

We probably don't really need such a silly helper which is used only once and,
AFAICT, doesn't grow any other functionality by the end of the patchset:

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 4074fd43830e..7d0bd7b070a7 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -112,19 +112,6 @@ static struct event_group *known_event_groups[] = {
 	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
 	     _peg++)
 
-/*
- * Clear the address field of regions that did not pass the checks in
- * skip_telem_region() so they will not be used by intel_aet_read_event().
- * This is safe to do because intel_pmt_get_regions_by_feature() allocates
- * a new pmt_feature_group structure to return to each caller and only makes
- * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
- * returns the structure.
- */
-static void mark_telem_region_unusable(struct telemetry_region *tr)
-{
-	tr->addr = NULL;
-}
-
 static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
 {
 	if (tr->guid != e->guid)
@@ -149,7 +136,16 @@ static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_g
 
 	for (int i = 0; i < p->count; i++) {
 		if (skip_telem_region(&p->regions[i], e)) {
-			mark_telem_region_unusable(&p->regions[i]);
+			/*
+			 * Clear the address field of regions that did not pass the checks in
+			 * skip_telem_region() so they will not be used by intel_aet_read_event().
+			 * This is safe to do because intel_pmt_get_regions_by_feature() allocates
+			 * a new pmt_feature_group structure to return to each caller and only makes
+			 * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
+			 * returns the structure.
+			 */
+			p->regions[i].addr = NULL;
+
 			continue;
 		}
 		usable_regions = true;


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
