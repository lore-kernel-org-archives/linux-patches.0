Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A242F18642
	for <patches@lists.linux.dev>; Sat, 30 Sep 2023 18:11:22 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-570a432468bso1280490a12.0
        for <patches@lists.linux.dev>; Sat, 30 Sep 2023 11:11:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696097482; x=1696702282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TXn5EVj6LatWgiRJOE6Q8kenZuC5VUG7hu5Ruisxfw=;
        b=wcwjaA0tvrl3YZ/mZzN6xo9O0kOkv6YF6r/Wrn5vHSTUbxIvgNUOsCnAXpmlj82KPP
         372B5ExLDyyNpvTd6tyyxn7LbljsbVPexBOH2LEOk0ZjuwhOanUF0zYa16FFRN8/R0+0
         jW0tfSjsSrMF+tVikYkCxD9PuUihmSJSreJ/y++wb7edbfwZUfAWDHBiOGz1zSt8iDsv
         HJNYrMPMXvi9SDyN1i8+csA03ynG2GuGHzfZqvwH4J+9+bYAYKemvO4YSdWjgxlfh0TI
         nXp3JPTMwnOoZdmw7txx2jQp6ZS5VKn/B4M2O0njS9ICs1dPPH7u353qXTrhoTCAlxJ/
         p7YQ==
X-Gm-Message-State: AOJu0YwGJ1hn8A62J41eDpl+lr43/caEBANpot7CrN12zTiU3sddKzFJ
	Wz1gPaUMYsjXqWhqK/PvEJE=
X-Google-Smtp-Source: AGHT+IG8yfBEc/mvB02AlNeuIWF5R6nONr+MMMVd7OPW+QTH0f19znw98ZuhkzsbdpNX71Nf57LDPg==
X-Received: by 2002:a17:90b:1982:b0:279:dae:2d3f with SMTP id mv2-20020a17090b198200b002790dae2d3fmr11586365pjb.22.1696097481748;
        Sat, 30 Sep 2023 11:11:21 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id mu13-20020a17090b388d00b00256799877ffsm3398075pjb.47.2023.09.30.11.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Sep 2023 11:11:21 -0700 (PDT)
Date: Sat, 30 Sep 2023 18:11:19 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, patches@lists.linux.dev,
	mikelley@microsoft.com, kys@microsoft.com, wei.liu@kernel.org,
	haiyangz@microsoft.com, decui@microsoft.com,
	apais@linux.microsoft.com, Tianyu.Lan@microsoft.com,
	ssengar@linux.microsoft.com, mukeshrathor@microsoft.com,
	stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com,
	vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	will@kernel.org, catalin.marinas@arm.com
Subject: Re: [PATCH v4 15/15] Drivers: hv: Add modules to expose /dev/mshv to
 VMMs running on Hyper-V
Message-ID: <ZRhkxxBbxkeM4whg@liuwe-devbox-debian-v2>
References: <1696010501-24584-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1696010501-24584-16-git-send-email-nunodasneves@linux.microsoft.com>
 <2023093004-evoke-snowbird-363b@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023093004-evoke-snowbird-363b@gregkh>

On Sat, Sep 30, 2023 at 08:11:37AM +0200, Greg KH wrote:
> On Fri, Sep 29, 2023 at 11:01:41AM -0700, Nuno Das Neves wrote:
> > --- /dev/null
> > +++ b/include/uapi/linux/mshv.h
> > @@ -0,0 +1,306 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> 
> Much better.
> 
> > +#ifndef _UAPI_LINUX_MSHV_H
> > +#define _UAPI_LINUX_MSHV_H
> > +
> > +/*
> > + * Userspace interface for /dev/mshv
> > + * Microsoft Hypervisor root partition APIs
> > + * NOTE: This API is not yet stable!
> 
> Sorry, that will not work for obvious reasons.

This can be removed. For practical purposes, the API has been stable for
the past three years.

Thanks,
Wei.

> 
> greg k-h
