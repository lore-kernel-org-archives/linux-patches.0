Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0DA15DBA3;
	Thu,  1 Feb 2024 12:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706790017; cv=none; b=ggRHrTjVCdo/iuNKKznZ25RgZtheLO0+If9lx4gd4E1WCe4s6eSgjHp/JPPqZjT/WSnZtZWrR/8xnKn3WNxKZvHmmjPq+VI3/jKwY6D3queQ/Pi+9azExDu5fqrFQHj+ntyrc6bFmxhELNMXEYthNWzjKXLPR5ARF+l6IzOceNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706790017; c=relaxed/simple;
	bh=4Ie/Xg9QQEqyC2kxqWucXLJeiNGuC9Hw4zqNth8MMjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeofF81mhBZMCSYCiOMVPvkyJggGpi/3byf16ILgqLP5P8winilac7HrfuEuuuCM/qiPQcQ9R7dU1Mtp2CiuU/CaH3FvCiZtVLQn/JCzUQ3gt1iqRYOz/TeFac9fVla76pnO5GUo6I9KK4oa2mVxjTVJd8dWUakZs2pCBm9LZAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VWloXmoR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KZTJza10; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VWloXmoR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KZTJza10; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VWloXmoR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KZTJza10";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VWloXmoR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KZTJza10"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BC3061F385;
	Thu,  1 Feb 2024 12:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706790013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JssJGLbLgFS02T1cBcMNp6vFTJ8g7xVb7dNEyUQ0OIU=;
	b=VWloXmoRKF3dAKUVIquLVO+zZeyZV5UaT9BzycDvRR+1QWft8UjmxOH6BfRGq9mlPW5bj5
	OdQa5nxlAICAU6bibkp9BmMTkkcdlRzdqOOgUFtf7YSVClNCQs2ECTER+szNKFJ+PB8Jm6
	re0IIAA5G83+vDNlNcoGlfVfhfyOabc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706790013;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JssJGLbLgFS02T1cBcMNp6vFTJ8g7xVb7dNEyUQ0OIU=;
	b=KZTJza10mdB8bGuc9v33q5ogfMs3YhfX8edGzaRFnLN8g73mQ0sa3QSvf+lQTrUirQZuOy
	ySQ7hLZK0+WBcbDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706790013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JssJGLbLgFS02T1cBcMNp6vFTJ8g7xVb7dNEyUQ0OIU=;
	b=VWloXmoRKF3dAKUVIquLVO+zZeyZV5UaT9BzycDvRR+1QWft8UjmxOH6BfRGq9mlPW5bj5
	OdQa5nxlAICAU6bibkp9BmMTkkcdlRzdqOOgUFtf7YSVClNCQs2ECTER+szNKFJ+PB8Jm6
	re0IIAA5G83+vDNlNcoGlfVfhfyOabc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706790013;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JssJGLbLgFS02T1cBcMNp6vFTJ8g7xVb7dNEyUQ0OIU=;
	b=KZTJza10mdB8bGuc9v33q5ogfMs3YhfX8edGzaRFnLN8g73mQ0sa3QSvf+lQTrUirQZuOy
	ySQ7hLZK0+WBcbDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5783D13672;
	Thu,  1 Feb 2024 12:20:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qVwbFH2Mu2WRMwAAD6G6ig
	(envelope-from <jroedel@suse.de>); Thu, 01 Feb 2024 12:20:13 +0000
Date: Thu, 1 Feb 2024 13:20:12 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	patches@lists.linux.dev, Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Steven Price <steven.price@arm.com>
Subject: Re: [PATCH rc] iommu: Allow ops->default_domain to work when
 !CONFIG_IOMMU_DMA
Message-ID: <ZbuMfDOuZwTQsm4r@suse.de>
References: <0-v1-755bd21c4a64+525b8-iommu_def_dom_fix_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0-v1-755bd21c4a64+525b8-iommu_def_dom_fix_jgg@nvidia.com>
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [-1.07 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-0.97)[86.87%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SUBJECT_HAS_EXCLAIM(0.00)[];
	 RCPT_COUNT_TWELVE(0.00)[16];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -1.07

On Tue, Jan 30, 2024 at 12:12:53PM -0400, Jason Gunthorpe wrote:
> The ops->default_domain flow used a 0 req_type to select the default
> domain and this was enforced by iommu_group_alloc_default_domain().
> 
> When !CONFIG_IOMMU_DMA started forcing the old ARM32 drivers into IDENTITY
> it also overroad the 0 req_type of the ops->default_domain drivers to
> IDENTITY which ends up causing failures during device probe.
> 
> Make iommu_group_alloc_default_domain() accept a req_type that matches the
> ops->default_domain and have iommu_group_alloc_default_domain() generate a
> req_type that matches the default_domain.
> 
> This way the req_type always describes what kind of domain should be
> attached and ops->default_domain overrides all other mechanisms to choose
> the default domain.
> 
> Fixes: 2ad56efa80db ("powerpc/iommu: Setup a default domain and remove set_platform_dma_ops")
> Fixes: 0f6a90436a57 ("iommu: Do not use IOMMU_DOMAIN_DMA if CONFIG_IOMMU_DMA is not enabled")
> Reported-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> Closes: https://lore.kernel.org/linux-iommu/20240123165829.630276-1-ovidiu.panait@windriver.com/
> Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Closes: https://lore.kernel.org/linux-iommu/170618452753.3805.4425669653666211728.stgit@ltcd48-lp2.aus.stglab.ibm.com/
> Tested-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> Tested-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommu.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)

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
