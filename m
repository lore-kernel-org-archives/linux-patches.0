Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E7741228C
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782934860; cv=none; b=KpqJndXBjxGXGFumHGykXJkla9bmwRdd8ltt8zwMteKDHFo7qbKKqhMIfzl0Qnom6R42tY5Bd1iuFTudK0sEb3OInkiZh6JcFz3LOUilKB/0hgoQHnGeq17Fuc9x/u3JOt5ifzSzXU5f8KLd8dHJE6g2XdpLgtsvUEAUs2VOd40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782934860; c=relaxed/simple;
	bh=Rd4bI4fCK8qvYK8s51YMvbQsMueWE4oxhMFs1BXFhIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uj3/hj6KWb/n5CtnWhAeKV799C7ALINNI68ICrzY+yC4P/xkcHQfy1xWv5pEXD0q10ms5tQtKLx3ctZr61JjgDLn5I//mvIJngt+hviXRW8JXLu4/aiF2IM6vlleq9a/fBce/K3YrCmrD4JY04ZE34m1F1EyOJB7G4QlVgNHynE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=PIO65gF4; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="PIO65gF4"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AEC7440E01B4;
	Wed,  1 Jul 2026 19:40:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id VHJlQu4_6hSx; Wed,  1 Jul 2026 19:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1782934846; bh=LCESpBfMaai0VDCOE5QT7zsw0fKQVLyZcbMmCnFxXD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PIO65gF4b0utjxv0pZslCS+nCJTVA9902fRPAlRR6d+KGAN4wbAG/TWQlR6ALBibF
	 nwXGQS6nQ2T3TJYVWsoFQr/8T3+8TF4vKDcZxYkOhGklD6FH+Z6qnItGvyKguZvoVn
	 QUEXdS8hF2sFUQjlQzECBhv3moKLsWuJZQxVeQjkxgMh+hozeUqO5hys0evpau56Ir
	 DBb6QEt1DW4yvee4yvi8dLcakZq0WpSuksZhOBIc8ihrQfd8Yzn8lP5cGzVBGClSf+
	 rJpx5mtsyTondTGdeULInLA/cbcDQ6zaIrzOYHE5uXFzytJs1+Ynt34arRy7P47/QJ
	 ntBNLfFw4pMJxfMraqeqcJjQrRES32hNf6uqLdYPimHEWPo5UGxl539xXLOEjCngvA
	 aap2t/r6SNfmbkM/XMggZsm8CfjZi473hBYplDCZcvFrub3g0p2SXRqNkAr6qPcFuh
	 PbXbKcSufmjRppsIQKEEkdJ65nYWZ8AS9umhn4+wxLiLJ18s2iNupFExZzKVVCLOGs
	 jS3X5nsbDmPEYxMz4xu9Sw3DFfZmBYX+jkeW+736O8MgqvnPfn7SyAzHzv/otnROTi
	 1MeFTQYEFth3dhsHjeAiEL3ISJAlAskqUFEM/ecAxZBK+ozAp4sgWDBfykC7jEhBNy
	 xxv8bog0jUT0x/RPvp7mX0qw=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 24A5540E00C0;
	Wed,  1 Jul 2026 19:40:29 +0000 (UTC)
Date: Wed, 1 Jul 2026 12:40:27 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
Message-ID: <20260701194027.GBakVtK7d4XKEeCZ2g@fat_crate.local>
References: <cover.1781029125.git.reinette.chatre@intel.com>
 <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
 <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
 <b58d51c1-67f1-4640-b00a-1a99dc93ccef@intel.com>
 <20260630225759.GDakRJ93cg21As0xnf@fat_crate.local>
 <20260701170917.GCakVJvegWA9R9liDV@fat_crate.local>
 <4ba1c1b2-325f-477c-b7de-c12bf72990e8@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4ba1c1b2-325f-477c-b7de-c12bf72990e8@intel.com>

On Wed, Jul 01, 2026 at 10:55:38AM -0700, Reinette Chatre wrote:
> I agree there are serious issues here. What prevents me from advocating for them
> all to go to stable is that the fixes to the intricate races required changes to
> resctrl's core locking flows. I absolutely tested and scrutinized these changes but
> having them go straight to all the stable kernels feels like a big jump to me.

Makes sense to me.

> The fixes that do not involve locking changes are below. They could be considered
> for stable.
> 1/11: x86,fs/resctrl: Prevent out-of-bounds access while offlining CPU when SNC enabled
> 4/11: fs/resctrl: Free mon_data structures on rdt_get_tree() failure
> 5/11: fs/resctrl: Fix use-after-free during unmount
> 8/11: fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list

Ok, lemme hoist those up into urgent first.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
