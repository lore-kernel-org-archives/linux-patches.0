Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A751E1A1D;
	Thu, 24 Oct 2024 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729784075; cv=none; b=EngjGLc9F84A6jWRYzmK0MzUG53uM99ZxtiEnhJf+/SoBzQFo/zcGt1UZKibly0x+qISkQRWh9yDlM29k1t17AXuWCFPaQQcA4qrhrf5SB4wPnfTjVMcEps/soaMBgPmUrV/tVDzc2xGEWN03v/LXE8bNrNcJ8XOb8TNOmvwiA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729784075; c=relaxed/simple;
	bh=r86jBE+8OoJgKUMUpwbaAODQYFEMIqxXdzxjdpA4+K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/FF2Y1I7SzhLHAmCvvLqOMpPbHeMoaVmihv5yJiv1QSRMKO2D7G8vxnd6HI3lhzUMqAN9KCM5EG7BMI19nHS1tqXPotH4fXk0kn0gli0BbFb36ziP9kS/Afr36wM/2fYpGwVtjoZHBNdX7obNSvGH82e28WajlWDIOdMvVPuI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/DEmRe2; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/DEmRe2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729784073; x=1761320073;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r86jBE+8OoJgKUMUpwbaAODQYFEMIqxXdzxjdpA4+K8=;
  b=j/DEmRe2uviGuFvbjSIt4bacHTkhmr8601mgdH5wa31M6oo4r7r4wbNh
   O7OTA2HP0FZO4bOHo8O9QxX7l1K68brOgHeTY3uSuCFF78ssl5joOYPxf
   nQafkmeiYUIWfRpEZN4AWcwng+mTpyRCeuzSr+ls9d5O2GYA5uKz1JMrL
   A+bocIoVDtizGZ0Q8tZJ+JW1xNWnHc/RIISaoCAPmRAIyoWGmX7hJUCsU
   HSZDP8w1taWu4K41/rNlJVHTs2UMWKge5jAitXKTQRmXAF51eWK76o1s2
   sSHIkdi8f3TpK31jdR89KV3pfbShIBDiYtCp43vVzV/ZN4A/dMfs9h2kO
   g==;
X-CSE-ConnectionGUID: H4UAWYrDQkaQ/Cx15d+WaQ==
X-CSE-MsgGUID: phCSOxIMQcCyqUTpnbp03w==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="29322804"
X-IronPort-AV: E=Sophos;i="6.11,229,1725346800"; 
   d="scan'208";a="29322804"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 08:34:07 -0700
X-CSE-ConnectionGUID: bDqK43xcSWaBDgv74YyBNg==
X-CSE-MsgGUID: /8c3sObzRfmInXX3ETIyBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,229,1725346800"; 
   d="scan'208";a="80916460"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa010.fm.intel.com with ESMTP; 24 Oct 2024 08:33:58 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id 95E83252; Thu, 24 Oct 2024 18:33:57 +0300 (EEST)
Date: Thu, 24 Oct 2024 18:33:57 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, jeffbai@aosc.io,
	gregkh@linuxfoundation.org, wangyuli@uniontech.com,
	torvalds@linux-foundation.org, aospan@netup.ru,
	conor.dooley@microchip.com, ddrokosov@sberdevices.ru,
	dmaengine@vger.kernel.org, dushistov@mail.ru,
	fancer.lancer@gmail.com, geert@linux-m68k.org,
	hoan@os.amperecomputing.com, ink@jurassic.park.msu.ru,
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-fpga@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-hwmon@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	linux-spi@vger.kernel.org, manivannan.sadhasivam@linaro.org,
	mattst88@gmail.com, netdev@vger.kernel.org, nikita@trvn.ru,
	ntb@lists.linux.dev, patches@lists.linux.dev,
	richard.henderson@linaro.org, s.shtylyov@omp.ru, serjk@netup.ru,
	shc_work@mail.ru, tsbogend@alpha.franken.de, v.georgiev@metrotek.ru,
	wsa+renesas@sang-engineering.com, xeb@mail.ru
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various
 compliance requirements."
Message-ID: <Zxpo5VMY56iMOTWi@black.fi.intel.com>
References: <a08dc31ab773604d8f206ba005dc4c7a@aosc.io>
 <20241023080935.2945-2-kexybiscuit@aosc.io>
 <64ef261c-82d0-4fad-ba8a-562f247340fb@metux.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64ef261c-82d0-4fad-ba8a-562f247340fb@metux.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Oct 24, 2024 at 05:05:13PM +0200, Enrico Weigelt, metux IT consult wrote:
> On 23.10.24 10:09, Kexy Biscuit wrote:

...

> I grew up in the GDR, which was factually Russian/Soviet-occupied for 40
> years. I grew up behind the iron curtain. And part of my family coming
> from near Mariuopol.

Interesting. Let's have a beer at some point and may be talk about this
(I'm from Donetsk, Ukraine).

> They also suffered from that horrible war (and many
> of the wider family fled to Germany).

...

> or maybe just having an .ru mail address

It's not about .ru if you read the original patch.

...

> Who's the only nation who used nuclear bombs against civilians ?
> The US.

Since you haven't defined _how_ it was used, you are mistaken.
In the 70-x Soviets did a lot of experiments with nuclear and
you may find an information about, e.g., the underground nuke
in the Donetsk (Donbass if speaking of coal mines) region in order
to see if it improves the efficiency of the coal mining. It didn't,
and as a consequences it becomes exactly the use against civilians.

-- 
With Best Regards,
Andy Shevchenko


