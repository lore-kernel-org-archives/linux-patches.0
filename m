Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F08D340A5A
	for <patches@lists.linux.dev>; Mon,  5 Jan 2026 19:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767640667; cv=none; b=L5niUP5M1BsivsIMLNJn+TClQLNQqBYNm6Ep8vSu8meE0FOSnbzZQTUD571ytuawzRPnleVpgn6GLJBB5fL85zjUACliLg/j/yVD/aLMpqD0B2TYOVzFYS+4brraQV97IoS+IE4653hPly4sGry3BnC0eAX+sEM3UaWvz5iWMCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767640667; c=relaxed/simple;
	bh=lAKhXzVp2GAv/+6aTbFvhSjJlyr6Tag68mn+xEQ9W2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0fi1gnG+ruooSDDID0RSIVeYOWEIyGEd2IM/nRpNvfJhOFMqB6VEP3Q/FuOwWljktzrMrm/2zysV0Q2FXjEqqETUY/qvVylfdFBqKG7LtyVKQ2hg6gZ6Up8aTT0ygP17ULxWFgRtGRX6O223zVw7G8NCakIk4E3d7F1kJPuFeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=XVBXATJo; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="XVBXATJo"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5590240E01B0;
	Mon,  5 Jan 2026 19:17:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qHVC-u-DJ0LN; Mon,  5 Jan 2026 19:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1767640650; bh=47MK75gxg4TXrx4T9Tne/nBEdFMbMsw6wLCN83iIX4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XVBXATJoRRRhwZWmRRymW2x0DcdvqxEfy5zDxLzN+CA11w9TzUc3HZp4pCs/zySue
	 GCirq083E4oNH96s6YLAbboF8SQdavGPTKhFbfDHKjtlBEUwVN1GQ/ue1IBKxweFoy
	 8z0mhx7Uo2+LSvPmurjt4Qv8D1ZWE73IkP8eiT6rqE8yZKbRYp0ggB8xqrR8VbdF4l
	 kfwknA7GRSTh7QqMjnkl60Uqbkslnp1N/b9V5Cyq9I/QJpisRuB4XCEcP7PaZd2DDG
	 fRYtaX/Xij99B212/2S4L6nXWEnyWDHu+8LUn+Alwf3+z3ATcsN53gVzkyqNp1g984
	 i4W5UehMQrsapoT37fzT5G7u7vPK/bTgVQHTIxhwmfoeKZo9NNFxQp2Euw1z0tIDy9
	 flfnz8vfxLC9IxSVODzRAcOZS/FzRU64yiua6PAhOUnOpwhkSCHV+cmrQTPOMK1NPJ
	 BOel1/JR7AosFDoFCfZg8AzBntlB61If5DOttAcDDMKmITBL+5L59tIeQD6OLhBMMu
	 veojzyZJ78tFdBhcGoMsjZGbMBGIK9Qse9bTpuelfWiW0fPnz0ND5+luQ61QLv5mJc
	 Y6zMUtkJ9ORSp7TFtMuE80kElYENfy/ew0JwZwHDXYY3ZTweYlC3C8MkR0GsY8Vrcn
	 OAZSIU5sF6oCiQiqw69uTq1k=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 73C5540E0280;
	Mon,  5 Jan 2026 19:17:17 +0000 (UTC)
Date: Mon, 5 Jan 2026 20:17:11 +0100
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
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
Message-ID: <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-14-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251217172121.12030-14-tony.luck@intel.com>

On Wed, Dec 17, 2025 at 09:21:00AM -0800, Tony Luck wrote:
> +void resctrl_arch_pre_mount(void)
> +{
> +	static atomic_t only_once = ATOMIC_INIT(0);
> +	int old = 0;
> +
> +	if (!atomic_try_cmpxchg(&only_once, &old, 1))
> +		return;
> +}

There's

#define DO_ONCE(func, ...)

Can't use that?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
