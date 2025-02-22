Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FAA13E02D
	for <patches@lists.linux.dev>; Sat, 22 Feb 2025 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740236397; cv=none; b=cYJirbb6IRMoOGhKrpA03IqhUKF9KavBidkYijBxGzBVmcRSdjlLm/c05825uC3Wbo8Vj3en95udQJWja7iZD/QTGF+EM8WnXq84XBnB06qDhvZtx4A8gLWTXBQOcH3iPYsXCbaViyCJkFKE0+KiJucghB1OlBPz576vokJm5dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740236397; c=relaxed/simple;
	bh=VjnDEUpI50B8j+EaVwNlYhHX3dUMnKarGWgaalKx2RY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LxpotApMPcU/+/sFIdRBxDdoSWCC8UsXPyiACwG6ge97viIWlodDDQdyS6KXc12oQLI+vgjoKDGlKSXX48UgGhey8XIPXj9mLGR6bkhZIPmloUw7yp+bE61VlWc5suifJj2zd9+6aHjoM+K3qZcbEyTpIBX3b42A/MXsWG/IY/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Hb5V3k3+; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Hb5V3k3+"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 94C0B40E01AD;
	Sat, 22 Feb 2025 14:59:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id sFmrAaU8KnI6; Sat, 22 Feb 2025 14:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1740236377; bh=5R0WADrQg8bqPwjVBB/2HLDDApoeccQEOfvzUI25W7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hb5V3k3+kPvrHHkNkUUtsVTECjLLdTaXcvLLc/gmD3pTW4abqkbgFW0WldSjKJxOz
	 xj8GM+ELjei5zeyLx/rZeE8ZolqXW3atcJ9RUL5XMICEeNU1jUEoijV74qRoj2bTR7
	 jWqTtx1nJFpV1F64h4A+wWA+6Sb/XHH3kg6G8hRhKtvMQz5Bl7LzSKOm6Mqt+H3Q5Q
	 eFGoPLnST7v5P5H6+5KYICrhZhjYsZOw6LK/KRJwLQX7CwPWXGcuLasiWLKu3bXGtG
	 iWvQpe3+QyQvsI+NMHNPjS2LjidqBIBE7UdVmYny71G6sA54jKWT476BdPOf50Efe5
	 bMA71oHzYJFr4KqagTLNbbTBbrmIL3tu0Lgx9RGkjEv2oxgQdlzGIEiao+tIawVxRV
	 qISMlgyuMDHqAI89NLDt1gifyEgNBOccl5+mohuT421/m5amwln/M6igLnJJQlIzGY
	 nXqI2AIyxjz87aLhA39Mr8r4O2+HaqIppqIKicG5SmgwGE0A4XqfmEYOKOM7oAwWLG
	 HXdWleikAD0gPVPMUBA1T0h41RhlSV0ok805lZBM5fgnj76cTRBoIWZcNhQ3xwCwou
	 lO2ycIfVCMnVvhGAZB+6pg5lWZvJ/8D4uTHjXaZTC389LjnOKatB8f8Y9zoyDj5zU5
	 0md/7Wsl5T2P4sZNqpsCKyvg=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9E7E640E0177;
	Sat, 22 Feb 2025 14:59:31 +0000 (UTC)
Date: Sat, 22 Feb 2025 15:59:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Patrick Bellasi <derkling@google.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH 6.6] x86/cpu/kvm: SRSO: Fix possible missing IBPB on
 VM-Exit
Message-ID: <20250222145922.GCZ7nmSqJqslFxalIC@fat_crate.local>
References: <20250221142002.4136456-1-derkling@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250221142002.4136456-1-derkling@google.com>

On Fri, Feb 21, 2025 at 02:20:02PM +0000, Patrick Bellasi wrote:
> commit 318e8c339c9a0891c389298bb328ed0762a9935e upstream.
> 
> In [1] the meaning of the synthetic IBPB flags has been redefined for a
> better separation of concerns:
>  - ENTRY_IBPB     -- issue IBPB on entry only
>  - IBPB_ON_VMEXIT -- issue IBPB on VM-Exit only
> and the Retbleed mitigations have been updated to match this new
> semantics.

All 4 backports by Patrick:

Feb 21           Patrick Bellasi ( : 148|) [PATCH 6.6] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit
Feb 21           Patrick Bellasi ( : 147|) [PATCH 6.1] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit
Feb 21           Patrick Bellasi ( : 147|) [PATCH 5.15] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit
Feb 21           Patrick Bellasi ( : 147|) [PATCH 5.10] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit

LGTM.

Thanks!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
