Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25ED1BE842
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941329; cv=none; b=ti/dbqO+TTvE5gQ37r3lJKsm6M3HR4J29HJlUTWUrrZrhB+aa6qEprCuHvSScoL5xmnQ4RqNql7TCwLC0bs29cUI4rjH55yy5AAZ4stuSG4zd0nekfYtae1oiHlvbaaS+L7ZRyuWd8lLeD/I32Jq//2SiJrN9u+r+jH8MPq1NIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941329; c=relaxed/simple;
	bh=jYeWnTV95BPaOOrj5p1AkHVGYGcZWkWIYQfSGVcLzm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lj/Iq0NMwS3yKeB4GUEnTVefAsuPVuE4KoM05E24r7CEsBy9BjoIam3WjkBl6K2UtoF4V4VSV+KGDULJZD2f5LDc/h6lOpZJ2bNa+KgcRqUe09hv/RrFERwXGROtFZbDGf5C15TvtXL+5cMYD8xzdzSSk37kHRaDI7dvVo3ADQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=c8YB6Dpf; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="c8YB6Dpf"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7E06540E0185;
	Tue,  2 Jul 2024 17:28:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id QGawDHv-E1CW; Tue,  2 Jul 2024 17:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719941314; bh=JXRnBEz8iHQChbdVPhfaSsanLqGse6ktf9ce0Vm9MNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c8YB6DpfF7+kNM0Y6AVrfahVRUPo+56UPmTO8MdmnwMwiKhwpPqtmmCIBDywghbjI
	 Fh/SULqXlIKobZA+9MSI8N+MQeQ8tenRkJzLG+ULN3Xq3KRQXnOrOpttXSIHOHvPsZ
	 249rxhD8VmiFjYzGz4mw1FTL7rHAf9HWTUd/6Ec7Pord2rdtZde1LzgKr2eIM2TWJv
	 ujnhusJUSYHO80GPewfI+BB0kq2LCv3iZ/ONJtcsurc1AZD8kQNflF67SMbX4HmgNn
	 TRGAidYLH6fGYBDsBUfp7yLzaJHbJO0KS+JoNUisFnKMwQ+o3T9IKyMw4EK2CMI7Ec
	 P3m6sTwgLH9LuHgNTWaJkJOcDS1nYdBzMrj2VNpCge2hLF65Ph+GtNt3Fb5juHgTNt
	 eKL3IJhVRp/ou+RYMxeVo8sjnu2vnVjjm5EmP/HSbJlB5Z6gVfddOjSajH/0LeV6Dy
	 NYDpn8NYzKXQSUEChv+RKB5lcaTyHQ9EZNQHlu4JIr8iJScgsetopZKwOex2kux3mu
	 eL7VLR/SaBv7gExdXf3z+QYKaO4tzB+Z85tewXeI234Er33PV6VDKkQz0qO2OBNpbN
	 kISpECB6LBBWKEwtFn9dm3xgCvUb9a7tRaJPqYQbS88alg3O8j2vm3BlvYXYoXtwEY
	 93pxbCimogN+7mZoyu8zYIj4=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 75A5440E0187;
	Tue,  2 Jul 2024 17:28:22 +0000 (UTC)
Date: Tue, 2 Jul 2024 19:28:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v23 14/19] x86/resctrl: Handle removing directories in
 Sub-NUMA Cluster (SNC) mode
Message-ID: <20240702172809.GGZoQ4qW6OOkL0bQQ7@fat_crate.local>
References: <20240628215619.76401-1-tony.luck@intel.com>
 <20240628215619.76401-15-tony.luck@intel.com>
 <20240702085337.GAZoPAEaEBtT18iD3V@fat_crate.local>
 <ZoQ1937ntIdMNQwL@agluck-desk3.sc.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZoQ1937ntIdMNQwL@agluck-desk3.sc.intel.com>

On Tue, Jul 02, 2024 at 10:16:39AM -0700, Tony Luck wrote:
> A helper will avoid this duplication. Draft below. Is this
> what you want?

Yap, looks good.

> Is the function name OK. I wasn't sure if the
> "mon" looked better at the beginning. Or as rmdir_one_mon_subdir()

It's a static function so the namespace doesn't matter that much, I'd say.

> I've also fixed up part 17 to use msr_clear_bit()

Good.

> Are you still digging through the patches?

Yap, and you can send me only those two which you've modified and I'll
integrate them with the rest and queue them.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
