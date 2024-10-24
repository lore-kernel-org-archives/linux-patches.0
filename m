Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988B61F5825;
	Thu, 24 Oct 2024 15:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729784491; cv=none; b=V03/1+q42jR4hdg6mPEoThmBRavLwAgHbFlqVBHNfYFmpKblvRpNeR2BgRHPFVgJKlpGk/sxZ8vV/3bHOBXF+0uHqyl0U/yPc+FSV/D/xIEv+eu9XCH/KieHsqTI9tQ5V8xwnKMEZXPfHteetaFkJKTXlbPqj4BVAbXrNzj8ov4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729784491; c=relaxed/simple;
	bh=pldgdaG5MLkDB2a4oyN8yKvYJku+F7JY2MI4zp+PqSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NLcXDkP+56PwsHbxXHVKASzBvVVe7gnfFGOdWZem0cY0lcmzX+mpjuzuKNno5peC8WmXMm5L1KsD5oTu0kcsCp3EhCzFheUGi2w61FJzyPmCJPRkMCGyFh6VPAyjfoCW7oEhtFbBPSqBQJU9pov2NhfMTRi12e4syIKy2I5Cp+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T5SX16Mt; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T5SX16Mt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729784489; x=1761320489;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pldgdaG5MLkDB2a4oyN8yKvYJku+F7JY2MI4zp+PqSM=;
  b=T5SX16Mt34GUYTuvPFty+opRlNBLcb2yKBBYZhAAK6D4ilBepCqs68rL
   d3gs6NxCaIO0/dsGGgmiVwIbFkBoYXI+9aOVvILu30HaOgvaGenLCTbdc
   BMOf8xSZHKTRmirKn9xybXsgsBGdcHcassZ9AfKz5wDYHT4EfpTGdf/QR
   L6xA5e6m8ByFIZPnVDIyDTq2iNW680zxlxXenf9TuNfUeyt0X18gxZs7J
   ZS/GRt6clGmxYU/JF21u4+hj26GSJFNoWLCEya05oWo0FZ1qWAkSi3X/D
   +VnhTKZd+tzX1bi6Fuln1HLIh6koJDy/4UopcoHqOTILAdDg3OQQ6aIwi
   g==;
X-CSE-ConnectionGUID: ir79NkTKSty0nKtNXA6p7Q==
X-CSE-MsgGUID: UJs5hDP9S+G1KfdF0l1RlQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="29641132"
X-IronPort-AV: E=Sophos;i="6.11,229,1725346800"; 
   d="scan'208";a="29641132"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 08:41:28 -0700
X-CSE-ConnectionGUID: 6VCIzl9NTYSCGVZmLeyxaQ==
X-CSE-MsgGUID: NAmPtL4bRVi0gWH+HPOjZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,229,1725346800"; 
   d="scan'208";a="85734765"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa004.jf.intel.com with ESMTP; 24 Oct 2024 08:41:19 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id 0FD9B252; Thu, 24 Oct 2024 18:41:17 +0300 (EEST)
Date: Thu, 24 Oct 2024 18:41:17 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Ivan Epifanov <isage.dna@gmail.com>
Cc: torvalds@linux-foundation.org, aospan@netup.ru,
	conor.dooley@microchip.com, ddrokosov@sberdevices.ru,
	dmaengine@vger.kernel.org, dushistov@mail.ru,
	fancer.lancer@gmail.com, geert@linux-m68k.org,
	gregkh@linuxfoundation.org, hoan@os.amperecomputing.com,
	ink@jurassic.park.msu.ru, jeffbai@aosc.io, kexybiscuit@aosc.io,
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-fpga@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-hwmon@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	linux-spi@vger.kernel.org, manivannan.sadhasivam@linaro.org,
	mattst88@gmail.com, netdev@vger.kernel.org, nikita@trvn.ru,
	ntb@lists.linux.dev, patches@lists.linux.dev,
	richard.henderson@linaro.org, s.shtylyov@omp.ru, serjk@netup.ru,
	shc_work@mail.ru, torvic9@mailbox.org, tsbogend@alpha.franken.de,
	v.georgiev@metrotek.ru, wangyuli@uniontech.com,
	wsa+renesas@sang-engineering.com, xeb@mail.ru
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various
 compliance requirements."
Message-ID: <Zxpqnf1M8rPTB4DN@black.fi.intel.com>
References: <CAHk-=whNGNVnYHHSXUAsWds_MoZ-iEgRMQMxZZ0z-jY4uHT+Gg@mail.gmail.com>
 <20241024095708.189649-1-isage.dna@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024095708.189649-1-isage.dna@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Oct 24, 2024 at 12:57:08PM +0300, Ivan Epifanov wrote:
> 
> > I'm Finnish. Did you think I'd be *supporting* Russian
> > aggression? Apparently it's not just lack of real news, it's lack of
> > history knowledge too.
> 
> As an avid history lover, you've seem to forgot, that Finland fought on Nazi side.
> So yeah, we're well aware you don't like Russians, unless they're in concentration camps.
> Which is exactly what you do now: segragate, based on nationality. Strip of credits and names.
> Once a nazi - always a nazi. So, fuck you.

$ git log --author="isage.dna@gmail.com"
(no results given)

Q.E.D.

-- 
With Best Regards,
Andy Shevchenko


