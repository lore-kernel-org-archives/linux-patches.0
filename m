Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF6A411F95
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 20:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784750624; cv=none; b=bZMKsmJyJEkTzXhDkdqCx8hm2dttS2stWbQk1UjBrO5Y+LrZLLnDbmLre090lk0cpnhs73XDKWBQUkxE/9kVqmaHiSX08gJE1CdtVpmFWphaCXm3Yn5V0kEsC/OxgbluLA8FZuGwTAPIFaOkwh8iOzEdM1ljzKigmEUrEW+KSt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784750624; c=relaxed/simple;
	bh=oPSXjqq3wWNvVSIxWB5S7W9Y5v24IfVn7cukTb3ZNdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9MKmySiR5AG8qAhhxcOOtIjOvT5uYOuBeaZA2cegwVC9eW7JJWR3cHSj0V5FXA+wOF+PQ8bs0roxuXtJBpK64VJl5vR4HK4RAPAH4hiHp9weECi91e7myUww+c1UlFwoBrk+yNALFeZl+JIoLuNZ4ioeMhJsjdiFLfP/ZV0crs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Yqw0Ad0G; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Yqw0Ad0G"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E8CA940E00C4;
	Wed, 22 Jul 2026 20:03:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2pOR38P4nB0J; Wed, 22 Jul 2026 20:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784750611; bh=qFurLyUe/bk7QNUyZDDGpqoGWoHl5zVo+PKCfH8S98U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yqw0Ad0GkgmcT/PUocshKvhsiFOMeNRa1Bd0h50cuLEV3uMR8cAFzaWeOViqE62P+
	 pWvNQG3syrgjPJoMX5WO+R8mU+eGUBNRIa9y+D4LI/+vt8Yr333AP4MKvRTnCRACiW
	 ro20VztLMMmTUXei/xEbCSMRSNGO5hxxtkRWma3tZABTs3QZ76/0m2Wolb6RM2ZN3w
	 Tl5zbg/78DXjKYLLpMD2CKKNwp18PYiy/EjtZpkTs0CGKFUVewKN6Q1XQmsgYZIVt8
	 3ZWLf0gS5B5A0MCXTAFN5viDWPj1QPWXIsXgm1ffaAZuXAaT3MjKVTDxdrLurjgxDg
	 0OlRenK1Z+vNQ195WZ+VSfMfnKMGaaIm15Pt03zBMBek92QkeQFzQpcYm7wQ2XNhYT
	 XYyQfiKUc4SWWVNud74S96rHcd6yMZThiwdcV1w3Yl48jFKMxqyAggM3PwlzeFWBOs
	 qCbXPbpsrq3KJq97l842xtNquB5jMpuNY/HGlQwpSM3EFVMYEkl7H34p3Mn8/ksY/H
	 OgD1hLpxRByJhTnJuQUSH3WeIL0d5aEcwJKFhFCHHdQVVqLHiXqlo3aO3XzJ+bXUi5
	 xUH4dw7paz4jF1DqlPHvQBjp/qzDzjJ88BIjRcF47O/zNEWnev1HMuIqWM7Yn1b3FT
	 oHThqSc9UueQjTKowRZuYz5Q=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 706CB40E00DC;
	Wed, 22 Jul 2026 20:03:14 +0000 (UTC)
Date: Wed, 22 Jul 2026 13:03:11 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v5 02/10] x86/resctrl: Protect against bad shift
Message-ID: <20260722200311.GFamEh_2Z6p3MrXpVr@fat_crate.local>
References: <cover.1782857711.git.reinette.chatre@intel.com>
 <bc6ec5102227b4617265e015ce84335a8e902bc6.1782857711.git.reinette.chatre@intel.com>
 <20260721015959.GEal7SnxxR8D3801cr@fat_crate.local>
 <2184678d-1b67-4d2f-94a3-c4bb22823cd6@intel.com>
 <20260721231502.GGal_9dvrdG9NdUkA4@fat_crate.local>
 <86f26d3c-92a7-4365-b6b9-2b31da15ce1b@intel.com>
 <20260722005015.GKamATx-zEYGcRs2X4@fat_crate.local>
 <ae04714b-566e-4b21-ba6c-2f42c6400e87@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ae04714b-566e-4b21-ba6c-2f42c6400e87@intel.com>

On Wed, Jul 22, 2026 at 08:59:39AM -0700, Reinette Chatre wrote:
> I am trying to help with bigger things in resctrl and find it easier to do so when
> working on a baseline that is without implicit assumptions.

Ofc.

> I plan to use changelog below that aims to address the items you highlighted and also
> changed the math to make the bandwidth boundary where resctrl stop working clear:

LGTM.

You can send me an updated patch now and I can integrate it into the pile.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
