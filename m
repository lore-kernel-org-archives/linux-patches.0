Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE87DE57D
	for <patches@lists.linux.dev>; Sat,  8 Jun 2024 12:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717848762; cv=none; b=shTOQJ8nOUa9SVq1Ke6humajWLh0wMFl6nmcyfliDYDlTG0eHyYCzFNpPYDRd4MEaIFBtFTr6CsD6qM6wE4pPrl0CHt55xREhCl2eBBLyTyMIbXrIeCGSxCaM+tw3YMWczcy9D4JdmiaTzqa+XapqmjjHdz9SN+CgMm5oD7KeGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717848762; c=relaxed/simple;
	bh=lJHyYs6KFngB9tGOh1CCfS9tiB1H7RIYFnBeJvDaXDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dec/kIf43JcZaDLPZgGRbAbMkBPGQ1Vk8g+ICjxCb4jdjsmwDlP9ZTdTgubaCMMJr0RumQOUkTdd36AVX6w2glRrenQ+alnWRHyrSE73roNmdPryOYuZERPTF/35OmMk8EqyGO7KIKUT1TKvb2fma45Wryhznp/TlbMcLHt1m0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=M4NepYWc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="M4NepYWc"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 60DF340E0081;
	Sat,  8 Jun 2024 12:12:31 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rxVnFuEr4exZ; Sat,  8 Jun 2024 12:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1717848747; bh=fTOv5bq5ICWZ/LQ/EFA61DsEKzHcUTrH0VvURF8uw6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M4NepYWcD/mU6d/KBK3pDSEdy4KRjBxsaoy+82oHYtI7NzN+KmY3W7CKxvfKxEGxc
	 uC06ePNbcJPa3Jw+7Je8gV7ONg1eB034sHQg2sWwq0njG4m4PwZFMUotGBiVG31iLk
	 M8HiEFT7+0Xs1UbmmlYdLBDOvvHfvWOgdknjQdtTO5c5+xw341QWQPrldQ/BTyOVBV
	 DVfugZc+ascJneDOKhi68OrYhifgETkU6Ga75bPf2e3Ilho92Z8JkYxoyQJ1vki8jk
	 VIKovRtaSar2GhO+Yxe72ksr5G4vXe4ZXp3OhZL+353h6wXW+3kxSt/7bpX3yqdHkZ
	 9cGRcsYkWWbmb1kA14Q0OlOCgncYoWx/rs5wPuUM9GqHvKwPWvXzlH7eJ9s59CK+nx
	 rVE36NUQW3Sne1f/A7R7CIeNtK9QBW5nC0eQ1LQB/+hmAZli+2QRMO3vKBW2B0c6pC
	 kVzxINIkELyDwVOKV7BUquKFSZyy03GFvYmNVr1tADnF4f9esu5aiJUr+5whAiy5ec
	 pPZxaMkTye2GEGwCx+5h6xe4PpyLaTrUfTcuqbPXG1a0V9gJEaZKhKkQFsr9Q3mAyE
	 2CJ/f1dA1SemRDLbSKuRLh6dxd5HyqF9TW2eSyJLwWtW83gpypxhYA0j168s2myUHt
	 O0aFIDjTmMuuvHIWcyo98dU4=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5D9B540E00C9;
	Sat,  8 Jun 2024 12:12:15 +0000 (UTC)
Date: Sat, 8 Jun 2024 14:12:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v3 1/2] cacheinfo: Add function to get cacheinfo for a
 given (cpu, cachelevel)
Message-ID: <20240608121207.GEZmRKl3uwP9Bfrx8D@fat_crate.local>
References: <20240606164047.318378-1-tony.luck@intel.com>
 <20240606164047.318378-2-tony.luck@intel.com>
 <SJ1PR11MB60830475F52F359E116B2274FCFA2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <SJ1PR11MB608331168096BFEBBB311EDCFCFA2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB608331168096BFEBBB311EDCFCFA2@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Thu, Jun 06, 2024 at 07:58:29PM +0000, Luck, Tony wrote:
> So this is #include hell that many others have complained about.

Starts much earlier:

In file included from ./include/linux/cpu.h:17,
                 from ./include/linux/cacheinfo.h:6,
                 from ./arch/riscv/include/asm/cacheinfo.h:9,
                 from ./arch/riscv/include/asm/elf.h:16,
                 from ./include/linux/elf.h:6,
                 from ./include/linux/module.h:19,
                 from ./include/linux/device/driver.h:21,
                 from ./include/linux/device.h:32,
                 from ./include/linux/acpi.h:14,
                 from drivers/irqchip/irqchip.c:11:
./include/linux/node.h:96:25: error: field 'dev' has incomplete type
   96 |         struct device   dev;
      |

And yeah, this is an abomination.

> How much do you *REALLY* want that lockdep_assert_cpus_held() to be in <linux/cacheinfo.h>

If we had an easy fix sure but this really is a nightmare after trying
it a bit here too.

Oh well, some other time.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
