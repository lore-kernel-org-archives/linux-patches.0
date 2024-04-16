Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12BD1E889
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 22:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713306894; cv=none; b=JBLMfePmwb3M/9xRGO/hCIr6zrgqtceta8M3NDn44fepi7LRa/+Hw/G9HE/chyHZq+HBvToLK6U9nwqCciqreLP/2fJzVpf6ClqTCFWgZ1ov4+XEG4rQv4vw33yjL5WmF+mePuBng4q4RfY17kF8v1h4LczvF+QL6OqSei/VnW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713306894; c=relaxed/simple;
	bh=TIppXwoyy7JCBAG2mGLWtbBQ6zU3Bx81FBr226GDJ+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmHN7sMVkPP1hbUQTtfwNBovHBtlgm7SAB2PKwhtYzywnfK269TSKuZRWCPipw5GCJcXHfip2l0hkAt/by03Y4jNoVN3V28T3yNqIVUDUPNX7o+mC5NttNUyS1pAECa3XLg9aWDVrhrsoPZE01jjnKlZy0atc50zNcwKkY/9HZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jh0i3bfw; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jh0i3bfw"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6eaf9565e6bso3109085b3a.2
        for <patches@lists.linux.dev>; Tue, 16 Apr 2024 15:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713306892; x=1713911692; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gYEBHSAYBc3ncttOdz1OGEIHHb3oWxG6brf944qm+EY=;
        b=Jh0i3bfwk6swnhIXEqPl3UQN9cQVzeCQz4V56l9WZ021M3G6ue5BibM2As12/3Y8MP
         w25egyk4JmfEA4Q72rYtzyMeWszpL0/YqrHDYZcGZfc6xT+T3zuQ2qdioiIyEZXYSfR6
         ZAy2vYXwz+w7ZIPRsb23M4hRaJYdZQxOYn0CwHWphCqjskgiRmgryUfHr2mvlCB5qIdQ
         aL3ELXQ7TUdIOmqZqjxbN2l6MjgGLUJ5p2OFvJ/T06AJ746Px2nKb5m0yv01t3Tq5R9n
         DRdYw4IBFB1R/o9gJ3J4hOeviDC85tPXduzFS3GUl+vnzWs8FHxloKgRJ+jbWhJMTcyn
         BWAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713306892; x=1713911692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYEBHSAYBc3ncttOdz1OGEIHHb3oWxG6brf944qm+EY=;
        b=taYGHMFJSCciJTa3X1gwzuJLfx4q/Ca7lT8Hb2R9tpz0ZfU1FshD/qCQuaOIhYN+R/
         MO0fK/NimoVR4wxi8SWNv73Cdu+Q0ZFEUABqHonEJJ8Emf9XbI8+6Em8zfSqgfLGnRpB
         jnSWILPyRyOs7EF0+CLAcPOLEtYGENDpvA1KpOuGBfH7R9WiKjfGtI0pNgI/rkINCSNE
         AJpijDuJekvOaz4EvunEaeenPZt9goc0kP1OHkmru+Q2hGrwJxO71nUxyLpldL4wB9GB
         AAgEu6OEsT7D12ZWo6i2RsYhHIULsVid890qXO+NfGOEbpGIJmErC9RdHy7J/x072jl7
         WGhA==
X-Forwarded-Encrypted: i=1; AJvYcCWFHETPDyJsHCnjL3bKaSbOVPuY3W7JrWo/DTbflsq1s8Ms+jQMsdoE3+Qx6LSA98QgykE7cDHqn7K/JDhMRs/cQvn4Lzn37w==
X-Gm-Message-State: AOJu0YwU4kIPsINXHYzOcz/iCG3Oc3hXL5HDnWz8sI2qQ0y8b+ei3xmS
	rcjwxE8Z65BHJ1VNkFW34t+kMZ/ORWRdHl9aSYTAszsMn3lTHOU6
X-Google-Smtp-Source: AGHT+IFh/zIfLrwa77zo+Wv6gz7XzJ//wE0dD/DGVm2QVPsw21WOGIkW96K3P/dBgSNVdt8rRN1gYQ==
X-Received: by 2002:a05:6a21:498a:b0:1a7:56d2:66c1 with SMTP id ax10-20020a056a21498a00b001a756d266c1mr13935301pzc.29.1713306892189;
        Tue, 16 Apr 2024 15:34:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q14-20020a62ae0e000000b006ecde91bb6esm9413744pff.183.2024.04.16.15.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 15:34:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 16 Apr 2024 15:34:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Tony Luck <tony.luck@intel.com>
Cc: Jean Delvare <jdelvare@suse.com>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v3 50/74] x86/cpu/vfm: Update drivers/hwmon/peci/cputemp.c
Message-ID: <5869d164-25c4-42e5-bf87-c4aeeac57388@roeck-us.net>
References: <20240416211941.9369-1-tony.luck@intel.com>
 <20240416212216.9605-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416212216.9605-1-tony.luck@intel.com>

On Tue, Apr 16, 2024 at 02:22:16PM -0700, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/hwmon/peci/cputemp.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/peci/cputemp.c b/drivers/hwmon/peci/cputemp.c
> index a812c15948d9..28cec5c318d4 100644
> --- a/drivers/hwmon/peci/cputemp.c
> +++ b/drivers/hwmon/peci/cputemp.c
> @@ -11,6 +11,7 @@
>  #include <linux/peci-cpu.h>
>  #include <linux/units.h>
>  
> +#include <asm/cpu_device_id.h>
>  #include "common.h"
>  
>  #define CORE_NUMS_MAX		64
> @@ -361,9 +362,9 @@ static int init_core_mask(struct peci_cputemp *priv)
>  
>  	/* Get the RESOLVED_CORES register value */
>  	switch (peci_dev->info.model) {
> -	case INTEL_FAM6_ICELAKE_X:
> -	case INTEL_FAM6_ICELAKE_D:
> -	case INTEL_FAM6_SAPPHIRERAPIDS_X:
> +	case VFM_MODEL(INTEL_ICELAKE_X):
> +	case VFM_MODEL(INTEL_ICELAKE_D):
> +	case VFM_MODEL(INTEL_SAPPHIRERAPIDS_X):

$ git describe
v6.9-rc4-31-g96fca68c4fbf
$ git grep VFM_MODEL
$

So I guess this depends on some other patch ?
That might be worth mentioning, especially since

$ git describe
next-20240416
$ git grep VFM_MODEL
$

doesn't find it either.

On top of that, it looks like

#include <asm/cpu_device_id.h>

introduces a dependency on X86 which is not currently the case.
CONFIG_PECI is typically used on BMCs. Many of those do not use
Intel CPUs. It does not seem appropriate to make support for PECI
based hardware monitoring dependent on it running on an Intel CPU.

Thanks,
Guenter
