Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9467F1635C7
	for <patches@lists.linux.dev>; Thu, 18 Apr 2024 13:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713448378; cv=none; b=UsucGsiZkFPBLoE8a+xLWX4flqiJ9iVtnr1A2MAg+ODKftWAW2td5AC4R61U2VNqzDegUIshOjMFVPP2h+NpwMpghp/+m/eWHTLydqc8dmBXC8ImRRuOll2RMNrCLAyqJcOSieVJJiMhalJu97e3AQEQQrnBMXa7IwXxZqQz48o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713448378; c=relaxed/simple;
	bh=OOfclcgBJP4rjtOQmlOeafKYzgvn9V5QPUbGwmpD9H0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKFC7pO0qrUH4TVvRcQBVwm/Ej9FU/DWTpbX173XTEgXM/2NyKCopnMsRkHy1wEdKSh/PosFnGVwrZ7SV+U3CBKzIZqovFr5CoNX6BBijrFOu27Hg4aca6vzBgE3q1qwPLFzgy2Kgom9xS9MzpHWI6LZJKLAxs4lq/ZkjUsr0Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2gUycX8; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2gUycX8"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6ecf406551aso795698b3a.2
        for <patches@lists.linux.dev>; Thu, 18 Apr 2024 06:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713448376; x=1714053176; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QyA3fzOku9oWwA8R0hs2Mphvf99QfjgFFiLxSpYNLQc=;
        b=R2gUycX8Mi75YPHmYxB5bA9z4A6REeljLVxCw95jWIISqGrbk9qvsgVAmMPOXht9Zz
         M5V7L/KL/OteP+Ff7oEGUrCH+RcsKuaMCeZ4YoMrk6uXYO9ovtoN0tPPP2oCfS3VsUgR
         n05il/0C71fidDjyWFyvRMcOFWhFJ2+hYipVvkhk4CU4Y/FntSudT2/Ev6/p7RcBx8Qq
         u5G5WBdBMIyqt4REf9uatrMMiPjH9DEzSz2UIUaum/sRmq82XloaY9Q4bRCx1A3R24YB
         ijTpin0xtHe3HBdpMRP1kmnbxVoI5tquVrP/kJGYwiW8FtD+CSqiMT7xotuKCEDpmkH4
         sTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713448376; x=1714053176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QyA3fzOku9oWwA8R0hs2Mphvf99QfjgFFiLxSpYNLQc=;
        b=idseIffuGhqPIsNY1nQKNAPmwNK9C5dIp/1Xvi7JawzeltyDOKl9RGbMm3R1sBMBTw
         ZlMa7T1psPUHxwJUsw5kZUyGo4Ok22G/edsn74opkliWg6u5qY2HZ4yA4JV9uOuPb8Hz
         vJtPfkuDIMi3kH1uLStcnyTMyKx9AeeZvOMwd3ChkWGQylOccHHVAYgmUfdiMq3yIV43
         GSrFZvmjbgqptF9baC0CRTQvWwFTJRHe8BhOabyPwYLcJ35VJoO8RdkR17mzIPQIgQMy
         LL6V6lI5xDqCQzQ5RZbSrgG+cELXeRwtgeYn5lnRRNYG4DF+9OkO9HWtLhzUE0KnK4ar
         4a7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUn3bdY3LgZg+NMRdBJY6UYk8bGo3GWdpGPfEaOHyYcD2ecE60w24Oz53GNE8e0fVKgZbkzp+WcE1aVZt3XhakdkALDv5av6Q==
X-Gm-Message-State: AOJu0YwiGVDLclmf9vZ04nMe97S36FProuqTMXnOgb4NFz3iAhZsBptP
	hpXScX83dWs5bbD4sOCXtYaj+y9u3lelrLxR+EVYBR68L3DTnFCsrv9q1w==
X-Google-Smtp-Source: AGHT+IFKjXEU0yszXeRAs3pRq6UlLYqDpFbI6NzJmKcNmljEtyYAhAhxpmnGaPhWktOFaXkyMjn/2w==
X-Received: by 2002:a05:6a20:841b:b0:1a9:ccf8:6ea5 with SMTP id c27-20020a056a20841b00b001a9ccf86ea5mr3873023pzd.8.1713448375740;
        Thu, 18 Apr 2024 06:52:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id kg15-20020a170903060f00b001e28d7329e6sm1530208plb.91.2024.04.18.06.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 06:52:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 18 Apr 2024 06:52:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Winiarska, Iwona" <iwona.winiarska@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jdelvare@suse.com" <jdelvare@suse.com>
Subject: Re: [PATCH v3 50/74] x86/cpu/vfm: Update drivers/hwmon/peci/cputemp.c
Message-ID: <f1d02e4f-a947-4af1-a7c0-9f7c12c57b3e@roeck-us.net>
References: <20240416211941.9369-1-tony.luck@intel.com>
 <20240416212216.9605-1-tony.luck@intel.com>
 <5869d164-25c4-42e5-bf87-c4aeeac57388@roeck-us.net>
 <SJ1PR11MB6083D0DFBC7DE286F986A453FC082@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <8690bcea-3ff4-49f1-a671-16583b8d241e@roeck-us.net>
 <SJ1PR11MB6083C8D12885057BF3A0A6AAFC082@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <7cb09d67409c94284928243d8ffb1f8a3128d849.camel@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cb09d67409c94284928243d8ffb1f8a3128d849.camel@intel.com>

On Thu, Apr 18, 2024 at 01:32:15PM +0000, Winiarska, Iwona wrote:
> On Tue, 2024-04-16 at 23:57 +0000, Luck, Tony wrote:
> > > If the CPU defines and the new macro are to be kept in architecture code,
> > > maybe include arch/x86/include/asm/cpu_device_id.h from linux/peci.cpu.h.
> > > That would not be worse than today's include of intel-family.h.
> > 
> > Guenter,
> > 
> > Looks like I did that to resolve one of the other peci problems. Because I
> > already have:
> > 
> > #include "../../arch/x86/include/asm/cpu_device_id.h"
> > #include "../../arch/x86/include/asm/intel-family.h"
> > 
> > in <linux/peci_cpu.h>
> > 
> > Simply deleting the include from cputemp.c builds OK in the
> > context of all the other changes in my patch series.
> 
> Hi Tony,
> 
> It won't build on non-x86, as cpu_device_id.h includes <asm/intel-family.h>.
> I think the simplest way to solve the issue is to provide a copy of VFM_* macros
> and X86_VENDOR_INTEL in include/linux/peci-cpu.h.
> 

I think the proper fix would really be to move the include files to a
generic directory, such as include/linux/x86/ or include/linux/cpu/x86/.
After all, they _are_ now needed in non-Intel code.

Guenter
