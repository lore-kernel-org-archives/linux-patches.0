Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F248195962
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 09:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729588464; cv=none; b=lPRy8CfmB2r4Wb+Pu8nvsztFusR3wHq1WFmPxT40sIq6WazOISbV8xYsHkmDp/Njn4X5DnvF3Ii21CYABYVjtRMTL7qvn/Y5grTZzupERbun9SEERsUiYKpd1m3z7f6lOd6ydNyss8cwNxZtjpvLYz2r0HTqyr57SYKHX+uOPqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729588464; c=relaxed/simple;
	bh=VWR7aDOgmN2xrx7wH5+Qcz22KucfK3CVPxBBWEremGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ji2w1ajJjbedrlcfFjGwkdMIHslxS60uo+p4DxZLkUc8xH3mji/HhzLZrrjzrFao3leiO2LtTCJDk5Xg7xtW4drDzNsGuB1PXrDt4pPw1FjiS+OQ7lBhBsrgpLQl4ar9pOY78nZDfSeVyPVnf789wRp7Am/ckCcEA7V+2GUbiu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J5FT5nKZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hdfPUyzI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Zel8JAhy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fI66crsR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J5FT5nKZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hdfPUyzI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Zel8JAhy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fI66crsR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 47ED01F8BF;
	Tue, 22 Oct 2024 09:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1729588460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2+9g73mgOTVYRL+S85Co8Hk2zFfU/RJePZEI0E88Al4=;
	b=J5FT5nKZzFTx6zukYTUHvbdZdpdbYXOwcXLSroGBHv+3hE1jdvt2WaIn4MxS4kg/tn1nMN
	jYBf+hK8uA9A5kQwpuCj5p5mba2puaXv4nhZSZvipDgC9KSvdH+dEaCo8S3tYMjjf/QixU
	FxG9eY4KNg0SHhnlaiuIznXD7Om7gfg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1729588460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2+9g73mgOTVYRL+S85Co8Hk2zFfU/RJePZEI0E88Al4=;
	b=hdfPUyzI93m0WbMP8xUggr8ck5NAV0kLWwfFBnvbCVq36sX/zGupblqRDniAiOr9ur20zE
	PvXOJ8p0EyVM7qDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Zel8JAhy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fI66crsR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1729588459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2+9g73mgOTVYRL+S85Co8Hk2zFfU/RJePZEI0E88Al4=;
	b=Zel8JAhyRP1dDMyGWokKoADFB+fbkt28OTuqWl16URsA0VThFW149tImEruZ7QKovmJzMc
	ByFQeLJiqNf8nTJXPk/t4r+6a+vLuIORDGHQsONiZcNByMWZCnObst/9gwWM8n1AeYcn9S
	x6oe0Rx379wBTmDI8RuRvy96jTyzJak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1729588459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2+9g73mgOTVYRL+S85Co8Hk2zFfU/RJePZEI0E88Al4=;
	b=fI66crsRQgeHMM5B5KeqsnmirR5BItToiL4ELRrg5DS9BpP3sG7desc+FgZbyXPRob3cj5
	ACBlxW/5v4PeX+Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 39FA713AC9;
	Tue, 22 Oct 2024 09:14:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fNchDutsF2c3CwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Oct 2024 09:14:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E73F8A086F; Tue, 22 Oct 2024 11:14:18 +0200 (CEST)
Date: Tue, 22 Oct 2024 11:14:18 +0200
From: Jan Kara <jack@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
Message-ID: <20241022091418.tbmk3sswlzsv7azu@quack3>
References: <20241021102249.791942892@linuxfoundation.org>
 <CA+G9fYtXZfLYbFFpj25GqFRbX5mVQvLSoafM1pT7Xff6HRMeaA@mail.gmail.com>
 <2024102216-buckskin-swimmable-a99d@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024102216-buckskin-swimmable-a99d@gregkh>
X-Rspamd-Queue-Id: 47ED01F8BF
X-Spam-Score: -2.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	FREEMAIL_CC(0.00)[linaro.org,vger.kernel.org,lists.linux.dev,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,denx.de,nvidia.com,gmail.com,sladewatkins.net,gmx.de,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,linaro.org:email,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Tue 22-10-24 10:56:34, Greg Kroah-Hartman wrote:
> On Tue, Oct 22, 2024 at 01:38:59AM +0530, Naresh Kamboju wrote:
> > On Mon, 21 Oct 2024 at 16:11, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.1.114 release.
> > > There are 91 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > The arm allmodconfig build failed due to following warnings / errors with
> > toolchain clang-19.
> > For all other 32-bit arch builds it is noticed as a warning.
> > 
> > * arm, build
> >   - clang-19-allmodconfig
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > Build warning / error:
> > -----------
> > fs/udf/namei.c:747:12: error: stack frame size (1560) exceeds limit
> > (1280) in 'udf_rename' [-Werror,-Wframe-larger-than]
> >   747 | static int udf_rename(struct user_namespace *mnt_userns,
> > struct inode *old_dir,
> >       |            ^
> > 1 error generated.
> 
> Odd that this isn't seen in newer kernels, any chance you can bisect?

Glancing over the commits in stable-rc it seems the series is missing
commit 0aba4860b0d021 ("udf: Allocate name buffer in directory iterator on
heap").

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
