Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B366A329E79
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 23:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781133071; cv=none; b=h9MirrxTM8PgoeDcTz5SrySqHDlu+kFIClC/ZNHb8B0VraYA/7OdzgprP6E2S+bkIE3E36cfghK52xbARPSBgDLeKEYt5CQU59rKTzBADiPo7X3KvnQ1iKzu5mivlT9TzAbJPrMlQXq4Sw6rNMU0Xzk7A+LGPpF18itaVzkn7Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781133071; c=relaxed/simple;
	bh=inTAzxLqZX34n9Tvq6iKfb4ILuhdbk/5N5mLCrVn+wE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/l1JZA6mWsjkfXZxyXnmIWy8ew8cKzgyVlG3js7WWFj76ioU1o1VJbiDxjN65AQ7Z7HGPfBguM/AjtGzxMYfS8XH0BuvYYkxluILU1HmFDHXXQDvD/zMNzk7BXBZCszPdgFcZTehxHzvApF6B3WUz4oI8nZLgMvP8SclmZxrtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=AcutD3a6; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="AcutD3a6"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 139A040E0177;
	Wed, 10 Jun 2026 23:11:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qZd-Sf6ATiym; Wed, 10 Jun 2026 23:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1781133050; bh=dN2ND8W4jvGrSji/zkH/kM1MaBEXbJY99ENaCoanClU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AcutD3a6F9ZlWNYZkwDlioc2kgsZhOZbsg7fTzGtSSAtsw3t/xPiWIMlPFY7iY4AP
	 /r2+xqUlLtf6Pq6N0WgeIuK5moY/85lqdYDra/tUDdpEenohNtNmuXFU9rTNrFhMwk
	 shvLEl/rGCUaLkg8E/zTJCIGw1BbiiW9QxtRi+8LauYC40Vz1+Vt4QQvEhbs9j+hr+
	 m/45kOdHOC+NFUgY8kxbDGxJYA+W2vspfSDPR8VY6KXMasbmr2ZHA6urSy8M4E3A1g
	 Tg7F4yzwhS6W5J6npRzZgOzgcAWnM9+RK2WbLrDoQIkTEMEFoiQomsoefoZhChTmgr
	 smMi9ituxo9H8OCv8rtWcm5vAzLtjQLeGZ9V2JozcqQ8swKU9BV1cjyH6oVftqBtPF
	 khLBmekUr6mMkSsn/EQKWizX3ognewU/8qO+qE2HU9hHPCZXY4WVQaQJh7VdNTGU4Z
	 +wn9PyePnzPVJ8ciOeoh16maiZ17AT65lgikzZHPUYQQZP4H7YOoH7/O9A7pfJLsGr
	 zXDW1RusBPQWMETMyk8oVNW2N7HFesXMut1fCHEV+dgr0mRfIviP6lfNlWOqYiP2e9
	 ZIwaxcdTGpz9Z9098HxMH1gBh9CFkF3p5UqfWVeeUh84PnHf51YQ+6ZYIeYKo6F9ng
	 fI9CSV+cHDUhMbJDLtpmPy2s=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 572FA40E01B5;
	Wed, 10 Jun 2026 23:10:33 +0000 (UTC)
Date: Wed, 10 Jun 2026 16:10:28 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
Message-ID: <20260610231028.GFainu5IR4RLvZRg6X@fat_crate.local>
References: <cover.1781029125.git.reinette.chatre@intel.com>
 <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
 <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
 <5295a4a6-6652-4f9b-82a9-8310523636b9@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5295a4a6-6652-4f9b-82a9-8310523636b9@intel.com>

On Wed, Jun 10, 2026 at 01:34:43PM -0700, Reinette Chatre wrote:
> Thank you very much Boris. Apologies if I implied so but I really did not
> expect nor want this to make it into the upcoming merge window. Especially
> after learning about Linus's comment [1] about fixes for long-standing
> issues not being appropriate late in the cycle (with v5 already considered
> late).

Right. Nothing to worry about, we do pay attention to how critical the fixes
are we send during the stabilization phase.
 
> Considering the changes in locking I do instead hope that this work could
> percolate on x86/cache for a while before moving further. To support this
> I hope to get few more acks by the time x86/cache can accept new changes.
> I should have made this clear.

All good. I think in a couple of weeks, when we have -rc1, I can queue yours
and then they'll get the longest exposure in linux-next so that should be
good testing.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
