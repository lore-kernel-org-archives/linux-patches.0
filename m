Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.175.24.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932886;
	b=uIrq2Ybqn8ZUQHYz+OlsCfdaSmLWz4JprMRX7nXHu6unBJfc9zhPu1UZ1pmdfThJn0rW
	 XkFx+/24RwBZ70HEMUcYN5hR45ixrnZkhG+zDAVYfvuZ3rq238mp1E1jAhk9+V62gqnlJ
	 uPDm3C1wRs86JrPF76brLQUB2qMW4E0b41C5nrrKJCi3LmaWn7sS4mZT00XiJTN6LdsMl
	 7dM4Ci1H4DvyHtRPBrNFtDMbs5bzYN1Ro1ECj6n9Lr3o/1nEE/gGus6CqkF2i2ANjf2ky
	 nwg+6pH0IfD+Dtdpz+84mWEYeDcjldoysO9sL+p2d6764qTwfxfWI6Z98lhe6yuT2yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932886;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=lOHdMF483gNPLEccoazumJHj5iVpfna/T2PvfkvuNkY=;
	b=KC8oqLgq0RIOo3w77FRp5gVjSS3fq5BevqbbbYzj9kc+gBQlAZ2lzKUsvrU8evUgCcew
	 y55+ihwfzX6ulWiEmF0f2Pyq0mQcxHCVDbHHKVZS5BIMvttnoTFzDKJ8hAL9yycZmkWJt
	 mzgdic/n+2WsIVGO4/+oJirLxOpZ1C2Em8u67XP6rSpBiy0LSnSTsmtHCWXFv/7rdsfR+
	 feO/JdH9odASz4Tb0O+d15nJ9e8SorMq+PMT9fO8G/IuKct/TGNR1FQSyULnMEcDG0dP8
	 PjqghxMx8N8EbFLzU3UfvvxuJ9NTPsMUeHAyCT63YOATLZoPHTg/ewHzCBLFMY0jvqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=alpha.franken.de;
	spf=pass smtp.mailfrom=alpha.franken.de;
	arc=none smtp.remote-ip=193.175.24.41
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 578A1606A31C;
	Tue, 17 Nov 2026 16:28:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 578A1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alpha.franken.de
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1xTM2N-0004s3-00; Tue, 17 Nov 2026 17:28:03 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
	id F2DE4C01A0; Tue, 17 Nov 2026 17:09:16 +0100 (CET)
Date: Tue, 17 Nov 2026 17:09:16 +0100
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: patches@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2 0/8] MIPS: Octeon: fix missing function prototype
 warnings
Message-ID: <avx8LNi5O5926c_W@alpha.franken.de>
References: <20261101234657.1820661-1-rdunlap@infradead.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261101234657.1820661-1-rdunlap@infradead.org>

On Sun, Nov 01, 2026 at 03:46:49PM -0800, Randy Dunlap wrote:
> Add missing function prototypes to header files in most cases;
> use the header files in the C source files.
> In 2 cases, make the functions static so that no prototype is
> needed.
> 
> v2 changes:
>  [PATCH v2 1/8] add more cache prototypes to fix mm/c-octeon build warnings
> 
> series:
>  [PATCH v2 1/8] MIPS: mm/c-octeon: fix missing function prototype warnings
>  [PATCH v2 2/8] MIPS: Octeon: cvmx-helper: fix missing function prototype warning
>  [PATCH v2 3/8] MIPS: Octeon: cvmx-interrupt: fix missing function prototype warning
>  [PATCH v2 4/8] MIPS: c-octeon: fix missing function prototype warning
>  [PATCH v2 5/8] MIPS: Octeon: octeon-platform: fix missing function prototype warning
>  [PATCH v2 6/8] MIPS: msi-octeon: fix missing function prototype warning
>  [PATCH v2 7/8] MIPS: Octeon: pci: fix missing function prototype warnings
>  [PATCH v2 8/8] MIPS: Octeon: octeon.h: fix missing function prototype warning
> 
> 
>  arch/mips/cavium-octeon/executive/cvmx-helper-errata.c |    1 +
>  arch/mips/cavium-octeon/executive/cvmx-helper.c        |    1 +
>  arch/mips/cavium-octeon/executive/cvmx-interrupt-rsl.c |    2 --
>  arch/mips/cavium-octeon/setup.c                        |    2 --
>  arch/mips/include/asm/octeon/cvmx-gmxx-defs.h          |    1 +
>  arch/mips/include/asm/octeon/octeon.h                  |    3 +++
>  arch/mips/include/asm/r4kcache.h                       |    5 +++++
>  arch/mips/mm/c-octeon.c                                |    1 -
>  arch/mips/pci/msi-octeon.c                             |    2 +-
>  arch/mips/pci/pci-octeon.c                             |    2 +-
>  arch/mips/pci/pcie-octeon.c                            |    2 +-
>  drivers/edac/octeon_edac-pc.c                          |    4 +---
>  12 files changed, 15 insertions(+), 11 deletions(-)
> 
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: linux-mips@vger.kernel.org
> Cc: linux-edac@vger.kernel.org
> Cc: linux-watchdog@vger.kernel.org

series applied to mips-next

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
