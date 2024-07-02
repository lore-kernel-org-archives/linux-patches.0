Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F27148303
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 08:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719910781; cv=none; b=tPaeyHf90ULaLWf5fLjChjHQfgRkWNS6g5MiYWYgJSEZLi6cOgtyB3es0MjN8eQ6PajKlHZ61pNAMKU9n59qendXTinbzeFTZznMXYhsY9gx230OKrpgGzfzmg/mVNa6YsuF9HotoBME6PU+Bn0EnktKzF3ZvTvZ1h8YgWHedTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719910781; c=relaxed/simple;
	bh=XqFM1KWiBlZkSaXakx0pXUCwN1NvGH+2XFV2KajMJvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDAiUDz4yYoOfm5GOBKf1DAvX+gvuaGEK90fKPsd3JnKw5Wpik4IOncqIxG1dI+P52babGKr1UCq2xdBp0K7BXPAQ14yBEH65TW6Cw/Nb2h2ps11Vc1QWGsfnG9xjYPyWind8uRE4abrZwM2Grf7GVZimpThMRWQR4LNUw2IVUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VS2fjaIA; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VS2fjaIA"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8C4F240E0187;
	Tue,  2 Jul 2024 08:59:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id wd1lQBb4DG1n; Tue,  2 Jul 2024 08:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719910774; bh=knK52wuCs+Ob82T1MKWyxTneJjQEnIgx33EFZthlZBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VS2fjaIASr8GrH4vf4BOBqTYuz685l0fb2VccymAVCC7nPiaGkcH2LINBrPt9t2sH
	 WT+2e99CMwkQJ1QHcco3YXxx4qp7UJtQRAO3870MTIE1nHDlmF75C9FrIqJyW/hnHf
	 U8/5jBLK6k9kGHFj1poZiI62crN/TBCplZYz/I92sUkyuBBzMhxxenRmy3VBJAM+8r
	 C1hUO47dkDP3IycyIVzEmFoeFEJHilffX5NMmdVhe/vDHj9ZlqYc0AhXg6UbCNTQJE
	 R8loQJnZp4yBF4NPsAUZBgYFSL4EHcVZyhpMm/5hiZg3E3K80gc/ZIAcy4LT9PEFzu
	 Jq3yhs2hgftUAt+AVzNJOSGE74wqJzAcHjHx5Acw3vt2moTI5KwE44w4jJ1mcVcyNx
	 YU4j9iqEcE1bUbGCLASe1d8vtQv+lXz5zDWw820ypogqEHOEJaZZTJ/MXJrr9nlxQ1
	 gpqyZRRzeywKMhibmY2CyAsG7Yk+4gYpKmV9/+5fKvEf9WZri9DdGmgeu5kIKPfRRt
	 pSF6Qu0CTS/wsgcLj5SmccIn30hnyZ2P11vLGhxFHPBKPzYwhksPO4+JVDGZDgULeR
	 UZ+UNTe4JqI94SSMRvN2CNDaaUiO1aY3aUjddprhc7PCY25CKbieKASrKreOnKNDQR
	 ZmezV+tApA/qbhA7IRSm4Ws8=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E6F9540E0192;
	Tue,  2 Jul 2024 08:59:21 +0000 (UTC)
Date: Tue, 2 Jul 2024 10:59:21 +0200
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
Subject: Re: [PATCH v23 17/19] x86/resctrl: Enable shared RMID mode on
 Sub-NUMA Cluster (SNC) systems
Message-ID: <20240702085921.GBZoPBadgHD8wD4wXf@fat_crate.local>
References: <20240628215619.76401-1-tony.luck@intel.com>
 <20240628215619.76401-18-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240628215619.76401-18-tony.luck@intel.com>

On Fri, Jun 28, 2024 at 02:56:17PM -0700, Tony Luck wrote:
> +	rdmsrl(MSR_RMID_SNC_CONFIG, val);
> +	val &= ~BIT_ULL(0);
> +	wrmsrl(MSR_RMID_SNC_CONFIG, val);

msr_clear_bit

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
