Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFFE30AAA9
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 22:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775600380; cv=none; b=ZEzdPdTFpd1+ejgsOeGc9oycYmGUxb3ED60ZVyh/4RPDhs7cUdAT0Ga4c9XF5lOzSUP4tPj4t+xBENcpcHIYRKsBXNY4qCt0WGJdJ9ZZYIeXrwavbBuCwufMdyJ7kswnk1e1Zs6GQS4StP9DkLKP/dWve0GyOeNyeF22vbWgi8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775600380; c=relaxed/simple;
	bh=ADMgP0NQ4x3M1ecpoPbaBA7QjNklkXpLTW+V8wgw024=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PEh98MTWbPDrUHL4FWw6mY2sfaEuy56gZMY2Sfkxqf//JnBKgE3dKYlVofcGbC+jhyyNZFNIabJQhzBzw8JJzKuGSfvE9RrEaXbf79RBA4yRk4BcjV6vV4SY3lI7Pk9PCon3MlOn2KvnSPhYH7YFPakhJeEnJD9W6b4dYNuym08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=P7XrYkIG; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="P7XrYkIG"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CF63640E015B;
	Tue,  7 Apr 2026 22:19:35 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 85YSneJNpinh; Tue,  7 Apr 2026 22:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1775600371; bh=xMofMqUnqp1cv59Kvwpg0QirhM+I6PVPVqwDp09cEbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P7XrYkIGqe+9xUev5X/02nCwXOB3qakGCkdP/EQqd81VVh3ROg0T78yXXY9IwAxBN
	 RtSoD9ybJQylVuwfoXajw5SVqpFmo+CX34WSfVXgaqSIiAiQLAanSc887lXTWFtnh2
	 PxJxqN6MF3XAjqFAf+QgZMKIF1SMZp0OYyCfm2g6QeQiXtPSN3q14isLCI9MUAeMQH
	 5X70MazwQbaNQcilUqPvOEZtSvXW7frAevKNPhG9UyCVi0M7R5SxvsaLMyqqx/IOQC
	 3Lz8PG6txfm5DwCT/tICza2hnpm+kZN2kvITA8qN1gb2LY54zUqExJ/beGYD6RH/ab
	 +ZHHzXfRwk90Z4e49RTaRfWn/jAKdegIBFYLF1r2KI+boRGegvJiRv07Jn0Tqyx5Ih
	 zutQdl47PhbQiUM4krZU9SNxe9aaLzkE1RbtSadIc37FtilrNxcASKazeOSqyNNAEP
	 WhNHZ5Aoc0VD1WMuPqL+km/1pyLPknMO9LOwcQLM2iCODuqfSvafKaFNGHSsD9V7W4
	 eWeN6BQZGo5nbJUBiynRfI4RrQc791EOYWUCECboQPA6PUQrDwIg/9Ej/PpKAOHaoH
	 bQ/3fuq0vOVWkWBuXL+0WxO74pgkZk0OKlHsm1PjiZvSpq8O6kcc9C3JZHvaAVI523
	 hk7IfIiEcHkOPa/JDnRu1nLc=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id BFA4D40E0176;
	Tue,  7 Apr 2026 22:19:15 +0000 (UTC)
Date: Wed, 8 Apr 2026 00:19:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v3 03/13] fs/resctrl: Avoid "may be used uninitialized"
 warning
Message-ID: <20260407221908.GGadWC3BaUzStnu9Z5@fat_crate.local>
References: <cover.1775576382.git.reinette.chatre@intel.com>
 <56fa3b5937ec6fda4eec162393463d8dbfc1abe4.1775576382.git.reinette.chatre@intel.com>
 <20260407185543.GFadVTLy82sBzT3eej@fat_crate.local>
 <e89edbdb-b6a4-453f-99da-41991ad25712@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e89edbdb-b6a4-453f-99da-41991ad25712@intel.com>

On Tue, Apr 07, 2026 at 01:50:50PM -0700, Reinette Chatre wrote:
> Indeed. This patch is for developer and maintenance convenience and not required for
> resctrl health. No problem from me if you find it not to be appropriate. I will just
> continue to parse the warning out of the logs.

Oh, your call. I just think it is unnecessary especially because those
warnings are not really worth to care for as they produce a bunch of false
positives and that's why they're not enabled by default.

IOW, I take them with a grain of salt.

In this particular case, I would care about the code not doing any unnecessary
work if it can be helped. And the warning can take a hike... :-)

But I can apply the patch if you prefer.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
