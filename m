Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BDF19047C
	for <patches@lists.linux.dev>; Wed,  5 Jun 2024 08:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717575291; cv=none; b=QRMxBFRxGjluWGPJJKM2/9RgwK5MaLYZafENlQRFyEZi6B1tWiEllYe3JmCOtG2RBPB1iI+29ew9afCB+ONJSYIOMg1pG8FoMc/5hyvm1LXl3OAu9QOkI5TMJNE0BuWLcACV7frBer+w+GYXb9Mn6G2wDzhyOlxRpVSyrJNKXkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717575291; c=relaxed/simple;
	bh=v2XDA3ZoWyOGTGLSLEP1zNYWciHzqrD+dHeo/w19Jp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbIR+Z+b6N+aSVS6zGG3vE/3PfiEG4yhm3HI66OS1DXUWS58EmT4OvUd2AH9oLstWHkTS63uAwjr/a0AVOr6csaUjV8K/UkkpvzQPWe9+HrMEIlJDlxiiOnnTen/f2s91Lo2XcVz55e22eI+1jI2kfOyE1SbY28Ga7oUWJIpxvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CMRBzO2j; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CMRBzO2j"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B3DBD40E016E;
	Wed,  5 Jun 2024 08:14:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id yDb3jXoyHIFy; Wed,  5 Jun 2024 08:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1717575282; bh=6U/GXprGcZrLmb7A6yxfyPsoyksgl9r7Z8Je+V33Eps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CMRBzO2jW3We+JvQLsX0USdodO71IgX4oogAV+6orKgu6a4mvSwPPiN7WooQrl97Q
	 vGaLYqmV2YzTTYvnPLarsTqfRFasS52f5NyF/WTnyhBI7AMY5MsG/oXX+q8WRUXAni
	 VHFUHemo6iXCFy5bUf1qq78rRFxXrGYdXgOoPo5EptCYtulObYqlj/t3owKJQoih1y
	 djxdbIq00071YZ8uamfa8lKQOubVCqLq7bqOvNwUNi+Z2wHMlWpJ0pN+MK1jO0iFTc
	 NxsvV5CP+7KMeRYS/2Ib5+t5ODKKYASwS2Beivwf3GjczwWai3/z4QNgKku82GaNKg
	 F31tXT52J5cJPiSIO0MSxcs6FfYuv0SUZovQiPNdQxjtKeuAut8rzBb0Owcv34Z5cB
	 fd9C9yNaFdFBmpJhJXHPmnHUJ3z0Xx8F4/DBWb6+droeJkbSMqHJ3NeL9r0PqiDkes
	 zFiiX1YTA/Nzk5WHI7tW1P5qHQFiFppW0wnbnjqY/Vkc497BBKL5pO7PSdUKQPmJlh
	 Xws95U1Dy5S7mAbfY3OatWC5lY4zDmmCn6Gbi7tS9Btti+JuhAGwIr394gvy9j11u5
	 KSCVdX5TYjWKofKkEsBl8FKl4aBxp41v36u0xQSdzZfWaozYIhSJyDIeUCZXtqU2qy
	 RpVGuiV5R+jMuH+LCcPyWj0c=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9715840E0176;
	Wed,  5 Jun 2024 08:14:28 +0000 (UTC)
Date: Wed, 5 Jun 2024 10:14:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 0/3] Add and use get_cpu_cacheinfo_level()
Message-ID: <20240605081421.GBZmAeXaQMH35dBRHt@fat_crate.local>
References: <20240531195720.232561-1-tony.luck@intel.com>
 <22569491-1b29-4b3d-8e9c-a5d10b73b6ab@intel.com>
 <20240603170106.GHZl320tVKXp2HyUfb@fat_crate.local>
 <20240604192250.38295ab7ac9c8b01a434153e@linux-foundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240604192250.38295ab7ac9c8b01a434153e@linux-foundation.org>

On Tue, Jun 04, 2024 at 07:22:50PM -0700, Andrew Morton wrote:
> No probs.  If/when patches turn up in a different tree (or get
> convincingly nacked) I'll drop the mm.git copy.
> 
> I'll drop these now as things appear to be in hand.

Cool, thanks.

In general, you can safely ignore arch/x86/ patches. We're usually quick
to pick them up when ready. Getting them properly reviewed is a whole
another story... :-\

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
