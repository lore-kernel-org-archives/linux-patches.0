Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A09215DBB3
	for <patches@lists.linux.dev>; Thu,  1 Feb 2024 12:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706790041; cv=none; b=pq91IjWw+PQ++oOTaf3tSG3ix9vxm7kkPqb3/VJLEfK+vk3qmrH0bmqWeG1H+n5Jhc0DRzKHEy2SSGYqt0Ni4cRLUURWZuPfKYr4GBoIFOjNuWe5wC/e45AQGFF1MARHLMXBYHPxqgSYKyGnWsU+LXQQWkngfVQhE6DTx+Ue5PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706790041; c=relaxed/simple;
	bh=/jxye04Ja1kmxTM6waNv/teRs+6hI5TXVj2SmVgSeDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFwIf3o+oAvtluLsoApK5gOWzLBi+yU5yrudAPfZuKNYVLFaJeDYcjq4V6hXzf8bkWhFHK2zDEgmguz3vWScKi5z2t4bbljxfPmz3knvqRAMcOnG36LgdWwKdNGvFJPLNfQMmSYrn5I/bWXy4o564LlplC38Td/QOu958xKjU3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AsX4FPoT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Cfv3qXyK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=m9U0TIpl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DoOQj4k/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AsX4FPoT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Cfv3qXyK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="m9U0TIpl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DoOQj4k/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A3B8121A85;
	Thu,  1 Feb 2024 12:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706790037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMf/ueH98XO58PF9QnRzaA+uA5ttyXbJbTb6WXMA/24=;
	b=AsX4FPoTyQF/yzkdJ/WFAa5qe0a4IVP20zalhrtU1cSXZ6lAzUSrSLZ97Mzb07AueJxQM8
	/rybyED31opoV5NAceMiwcvgBzfI9AWOlpGyjPyyk4U655YLjYXkupgTOwbuc814iTwPEA
	+/vOQkJ/trjLgU5Ezb4nxhPT/99nzUg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706790037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMf/ueH98XO58PF9QnRzaA+uA5ttyXbJbTb6WXMA/24=;
	b=Cfv3qXyKrtQXFjmpXnUh++6X6GEpQsTegF/pBozDEElPWauNGJM7ZRQyv081ynjLRWUQ8C
	e5zcWIaDnK1otkDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706790036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMf/ueH98XO58PF9QnRzaA+uA5ttyXbJbTb6WXMA/24=;
	b=m9U0TIplEeX4/5rfQ7kb8MAn1M+eqr7Cs4mJOD1CkAiByKpvuV2kZF8In06KEr+v4JB+Jl
	2OLfyjtrFWG2KjsefckwcX3ojEEwBFhYphQi/VByECFAF5kHhYuhyd723nWu9syYgbte+W
	5W6q9OypNwgb5C+CnBfeu8R6y056+84=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706790036;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMf/ueH98XO58PF9QnRzaA+uA5ttyXbJbTb6WXMA/24=;
	b=DoOQj4k/ckvfclvgTcJrxWhfPzpFJC7GyVyNe+lMc160ZcXlHjnnAts9sVW1GWeQ8W+Csx
	yf1BCX555Ptto6CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B13E13672;
	Thu,  1 Feb 2024 12:20:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1HYwDZSMu2W/MwAAD6G6ig
	(envelope-from <jroedel@suse.de>); Thu, 01 Feb 2024 12:20:36 +0000
Date: Thu, 1 Feb 2024 13:20:34 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	Jonathan Hunter <jonathanh@nvidia.com>, linux-tegra@vger.kernel.org,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, diogo.ivo@tecnico.ulisboa.pt,
	Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] drm/tegra: Do not assume that a NULL domain means no
 DMA IOMMU
Message-ID: <ZbuMkm1ngn4uaSwW@suse.de>
References: <0-v1-3049f92c4812+16691-host1x_def_dom_fix_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0-v1-3049f92c4812+16691-host1x_def_dom_fix_jgg@nvidia.com>
X-Spam-Level: 
X-Spamd-Bar: /
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m9U0TIpl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="DoOQj4k/"
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-0.01 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 MID_RHS_MATCH_FROM(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 BAYES_HAM(-0.00)[27.57%];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_TWELVE(0.00)[12];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FREEMAIL_CC(0.00)[gmail.com,ffwll.ch,lists.freedesktop.org,nvidia.com,vger.kernel.org,linux.intel.com,tecnico.ulisboa.pt,redhat.com,lists.linux.dev];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Score: -0.01
X-Rspamd-Queue-Id: A3B8121A85
X-Spam-Flag: NO

On Tue, Jan 30, 2024 at 12:14:54PM -0400, Jason Gunthorpe wrote:
> Previously with tegra-smmu, even with CONFIG_IOMMU_DMA, the default domain
> could have been left as NULL. The NULL domain is specially recognized by
> host1x_client_iommu_attach() as meaning it is not the DMA domain and
> should be replaced with the special shared domain.
> 
> This happened prior to the below commit because tegra-smmu was using the
> NULL domain to mean IDENTITY.
> 
> Now that the domain is properly labled the test in DRM doesn't see NULL.
> Check for IDENTITY as well to enable the special domains.
> 
> Fixes: c8cc2655cc6c ("iommu/tegra-smmu: Implement an IDENTITY domain")
> Reported-by: diogo.ivo@tecnico.ulisboa.pt
> Closes: https://lore.kernel.org/all/bbmhcoghrprmbdibnjum6lefix2eoquxrde7wyqeulm4xabmlm@b6jy32saugqh/
> Tested-by: diogo.ivo@tecnico.ulisboa.pt
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/gpu/drm/tegra/drm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Frankenstraße 146
90461 Nürnberg
Germany
https://www.suse.com/

Geschäftsführer: Ivo Totev, Andrew McDonald, Werner Knoblich
(HRB 36809, AG Nürnberg)
