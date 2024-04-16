Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9E56EB44
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 23:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713310631; cv=none; b=c/ppNioEP71SCnbz0Xj++9yz+xFh+AE+nq3xPyzQUo2aZ7wJJoeXATnFAmgNfyc7gBSeX+eMN3w7AdmV7HsPvMRcRfEJL3X5M/hd70F4foU9PGBhQc83FmNUNN3NAIt//ef9COavW0M12Ksa9j17BhjlHjlVOPgeQFVfEZO3G3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713310631; c=relaxed/simple;
	bh=5U6nMna7SZk/DJ9T0/T/d7oFo7eqY6+bP8se+cova7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QBTXDvyceSB1+XF0q1eR01ql2Ut2/8aRnS4pVklQRTNXXm+4XzZ39R6UioVwjxsVJ5xa56Lrhb5tKOriQW8AEQf0InEMiGGQznKqT8IZGs8nQLLMmXKrKgMUpf+tGdmT3etEEgIFZjLkqKzfGk0v2j9lJAdXjsRO32jvNeb/fao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CyRhY7oW; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CyRhY7oW"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2a614b0391dso3424241a91.1
        for <patches@lists.linux.dev>; Tue, 16 Apr 2024 16:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713310629; x=1713915429; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hTfwUoX6e0yKJZCWswKlfqOpaMBvbmr2XuMgc00p1Zw=;
        b=CyRhY7oWPSF60IFV9iDJanZx5OX2iWYO4a1WdgAHaAjxOToJgSkwN2KHG1aFBZr4PX
         jDROv3qUQRCRAO7yNpVaNZeWMI/Xem2aGZ2L/qHLrJC/gWyewZNxrwZLNVys0oBkbZH1
         p9h8NX8I4v71oGOIPPqFzY37uEvXh+eb4cE6bjA/crZ1Fi+4cetQMeXHFzIjgRYdNy4Y
         yTtucbBbYY5swyt5Svc1/HZbYNZMzr+mYb0mnoqrarHmCk4X3m7L9X6SOWr5Eu4IRdPf
         DcFiOEJeBCGp+7H35eYNo21EaeRy5CBouLFPJnzSa4XoW7dEaAafo/K2TGVmcLt1pwU9
         DMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713310629; x=1713915429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hTfwUoX6e0yKJZCWswKlfqOpaMBvbmr2XuMgc00p1Zw=;
        b=lG8/seprjzSooMapVLCXeQiNIyACbSf2ddHG3FEthgM2ZPnIVqXar9q8h8j7Te90z6
         Wu89WfPNM/+lBc9NxqJGdsMFB4OewOE/qrh27fjyx4jyJjkP+XVyh4wHRZjxVo0tZYvq
         jVHMg3hdo9rvHowLTeHZKy7SEZAwU2hLg8E+YaMQz9Xc0JbTowCotDvbla3jZbXEdJHP
         HgdTVsoe8s8uCJM93qqMKCNON8TRwZ49GJOR7S3tPszaF/vj1FtMDPEpjsLJaE24Oy3p
         iAq94QnaAfkTJKvbr6XsRIiCA7eoVjpnR+nulA07ILVGVXrhrfvGlDB7jObzQpX3TAHX
         5jzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGmzQXEmj6hsQKgyv5mOHkYIEp2gCqu+dVPQ9EEuWPVsLtVhjtD38MhdGOyUPV/7/siek2nY4EicCgRWlh0rPeFRqP7W6Pyw==
X-Gm-Message-State: AOJu0Yx/8J4CPbhRZE7sjKm4+/8keW0Z8DWd8LehP+jIxAjd8AliBK7h
	XFeIcJWOeS5H+tj70+z8M283Ap+7Dvq7w+XgOA6rYvrjRoTl1KXm
X-Google-Smtp-Source: AGHT+IGDyd586AvicCSraj2ozwB3Hcl1DlgfR2cmkHRXes+QFZ70g/SypQBB2aoQnfjNs8dRBr0OJA==
X-Received: by 2002:a17:90b:33cd:b0:2a8:5968:449d with SMTP id lk13-20020a17090b33cd00b002a85968449dmr6682233pjb.32.1713310627938;
        Tue, 16 Apr 2024 16:37:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090ad50d00b002a5dbfca370sm152661pju.48.2024.04.16.16.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 16:37:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 16 Apr 2024 16:37:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jean Delvare <jdelvare@suse.com>,
	"Winiarska, Iwona" <iwona.winiarska@intel.com>,
	"linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v3 50/74] x86/cpu/vfm: Update drivers/hwmon/peci/cputemp.c
Message-ID: <8690bcea-3ff4-49f1-a671-16583b8d241e@roeck-us.net>
References: <20240416211941.9369-1-tony.luck@intel.com>
 <20240416212216.9605-1-tony.luck@intel.com>
 <5869d164-25c4-42e5-bf87-c4aeeac57388@roeck-us.net>
 <SJ1PR11MB6083D0DFBC7DE286F986A453FC082@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083D0DFBC7DE286F986A453FC082@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Tue, Apr 16, 2024 at 11:05:15PM +0000, Luck, Tony wrote:
> Guenter,
> 
> Thanks for taking a look at this patch.
> 
> > > +   case VFM_MODEL(INTEL_ICELAKE_X):
> > > +   case VFM_MODEL(INTEL_ICELAKE_D):
> > > +   case VFM_MODEL(INTEL_SAPPHIRERAPIDS_X):
> >
> > $ git describe
> > v6.9-rc4-31-g96fca68c4fbf
> > $ git grep VFM_MODEL
> > $
> >
> > So I guess this depends on some other patch ?
> > That might be worth mentioning, especially since
> >
> > $ git describe
> > next-20240416
> > $ git grep VFM_MODEL
> > $
> >
> > doesn't find it either.
> 
> 
> Yes. This depends on parts 1,2,3 of this series. I should have added
> that to the "---" meta comment part of these patches that I'm spraying
> out to maintainers of random subsystems that use INTEL_FAM6 defines.
> 
> > On top of that, it looks like
> >
> > #include <asm/cpu_device_id.h>
> >
> > introduces a dependency on X86 which is not currently the case.
> > CONFIG_PECI is typically used on BMCs. Many of those do not use
> > Intel CPUs. It does not seem appropriate to make support for PECI
> > based hardware monitoring dependent on it running on an Intel CPU.
> 
> It seems that some use (or need to know about) Icelake and Sapphire Rapids.
> 
> How does this code get the value "peci_dev->info.model" used in this switch?
> 

My understanding is that the PECI protocol provides that information.

> Given that it is doing some magic just for some recent Intel CPUs, it seems
> plausible that when non-family 6 CPUs appear in the market, it might have
> to grab both the family and the model to reliably determine what to do?
> 
> Simple options to avoid including <asm/cpu_device_id.h> would be
> to either:
> 
> 1) provide a copy of the VFM_MODEL macro here.
> 
> or
> 
> 2) Keep using the old INTEL_FAM6_* #define names, but define those for
> the three CPU models peci needs locally instead of getting them from
> <asm/intel-family.h>. It looks like there is a somewhat convoluted path to
> include that. I see in <linux/peci.cpu.h>
> 
>   #include "../../arch/x86/include/asm/intel-family.h"
> 
> 
> Or maybe some better option?
> 

If the CPU defines and the new macro are to be kept in architecture code,
maybe include arch/x86/include/asm/cpu_device_id.h from linux/peci.cpu.h.
That would not be worse than today's include of intel-family.h.

Guenter
