Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D5B372
	for <patches@lists.linux.dev>; Thu, 15 May 2025 12:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747312347; cv=none; b=IedzJm3ICMPCQVmitxzA4wgK4XcKPZ0Xzq+tgskzb0wZ8xnHzUCM5NstKWwjq0gDZ6pP/eO2L7MSKavIAVp5hNjv+uqrDy7PCug82/OGmLEp6LDkxweb3CQtF/V1tGgn270st9ocs5tWyr0qC/fLHntopzPy5PWvw/dmnWAWLg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747312347; c=relaxed/simple;
	bh=mXtV/p3tpIeC0QGepjYirCNduEcmDED53SaEZc2lIx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jU3mdX6yG5g8UCUpOs+fDrNaymNhqeCzu7CnJ93fifZPtpEFDt9lpAExRXW86n4MnRYQKZetPAyWwMFvr9pm/l2aa+3k8VgisXAL21Ta4ITCW6I9ThejVGP6xePBUZuFK3WrNuuSppsWeApKwwYtqE7KuW1AUf0FUV5mYal0d1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gCMaDhn7; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gCMaDhn7"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-3a0ac853894so683285f8f.3
        for <patches@lists.linux.dev>; Thu, 15 May 2025 05:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1747312343; x=1747917143; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0DHCqe2ELkkc+UlPf3xD1LiX/49qcNMEoSzXRssIhGY=;
        b=gCMaDhn7lug9j0evODkc7PpY+01CwyW2JKhi70eaRPtUtGNpHhL3T9CWWTxAXNsEgS
         pNgtfjW8Qd8kFnsbXcrQBK2votLYVHoJxTrSKIDOOjcZUEKOzKsMV88Igec9HeUkrQoJ
         KDeQWXMpTuv5mTdlYplGdXCfLVJV3WZMmwZicHsdtkdeJvncIX7icsqaGbFN3TYGeoP8
         m0sN0d2eIxCiAKJ2rQwkmXJarAb+eidekyHlQhevYnxQnySCy35TPiAdMVMeYmTdGWYw
         pUhTDWiEgFvG2singNdOHm++8RDsEadopCHPunbBcB2lFhmZqJextndkO+vQ90nxdkzQ
         L00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747312343; x=1747917143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0DHCqe2ELkkc+UlPf3xD1LiX/49qcNMEoSzXRssIhGY=;
        b=cQCW7wtTdU6Mw2BGGbQQM8M3J+a3tZh1O2vAiBW8S0SIIQlIZLRebm+VwIBsk9M7ZE
         /yvBkeCQraXOCHOijYRTW8ULLeMcaM+KRymcwTAJw1Z/8vu0QsI5/phrBRa6+83NDNkH
         kwAoWVIBgpZatqnpt4UK/AlS2TOP52b3x9FmcWU8xz3GKT7UyAKD3YMp/bE0ewq8b/U+
         h9UWPZ+Uc+39jXEhGReb1Ho+i70tZ/L0cQiXKRqcI5ClmUyPvZAN/ncVIDFOGfgWNiYG
         rKCw09yGxlzRUEqqUdNrnSlMSobR1ax6/8+1OimTmTMiQ3U+3tDjiYCdUA3Iy/iSiCLT
         jM7g==
X-Forwarded-Encrypted: i=1; AJvYcCVXDHb9a2m2A4FrTUPZnSjdwUkLKuYlQt5qIiXaVULOWFafwF2RyXHGNpen0GKS/B16H5/8E/oZ@lists.linux.dev
X-Gm-Message-State: AOJu0YwLcKzCDbsK/EOry7j+z9vSEwkK5DZPB3vumlu+am985JMs2/d2
	5Ilffiof6hryGWsDTn7xhy81djvxUmjlvDAHueXmPzOlYA1nqy8r8IG0OGhJMCo=
X-Gm-Gg: ASbGncvYThr5yFPx+OrRNuJJxiqO8T8ZGKMlofij0brR6q3y4+KyOUxTmUYH1gyfp8V
	RkmiTGlLnl018/4wM67NhQNhk802m0tx3NwfiHnaIG0bf5LHBwECIk+UgJKknnSXfS2SyzF48hz
	jiEOXMAjGpZNcR7OEfqqKnPfmVWJXER3FlpD5LiuO0u44u7Nz0ohn8LKNU6TUB4uXQ3iRPRUMEq
	JLY23t7rbLQ4md+eZ4fre+zwLzRK3qF69wap+hMB5pl/IxbTQDFaGS/LWBfP6Gl8fpph/SydY9n
	IvUrPVFSFy2u32rBYFrNWnsa1rj8AySnvR4velI9zKvmgJxq6ieu8nRCO+gTGanWGKazUqvt8Wl
	5hxsAWnkE0Q==
X-Google-Smtp-Source: AGHT+IHsBfMKfF7WyoADO+426AhNanVPeH/8DogvNYGecOtbesvKzwVwHUFljsLKdXD2rqKBnqJh+g==
X-Received: by 2002:a05:6000:250d:b0:39e:cc5e:147 with SMTP id ffacd0b85a97d-3a34994ef3dmr6026464f8f.55.1747312343270;
        Thu, 15 May 2025 05:32:23 -0700 (PDT)
Received: from u94a (1-174-3-124.dynamic-ip.hinet.net. [1.174.3.124])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-4dfa297ee11sm195636137.12.2025.05.15.05.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 05:32:22 -0700 (PDT)
Date: Thu, 15 May 2025 20:32:08 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, kees@kernel.org
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc2 review
Message-ID: <2rlf4aoqeekjwcupepf6zkdkthhfwneeobiqeb3ujyz7ami5zb@eg5litfe4a7n>
References: <20250514125625.496402993@linuxfoundation.org>
 <vrvefaimjqkseuoyuhgg6omt2ypgp5v6xwwuxihj2t5jidizyr@ir5w67k4kl36>
 <2025051529-mulled-cubicle-b1cd@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025051529-mulled-cubicle-b1cd@gregkh>

On Thu, May 15, 2025 at 02:25:50PM +0200, Greg Kroah-Hartman wrote:
> On Thu, May 15, 2025 at 08:15:32PM +0800, Shung-Hsi Yu wrote:
> > On Wed, May 14, 2025 at 03:04:16PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.14.7 release.
> > > There are 197 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > ...
> > > Kees Cook <kees@kernel.org>
> > >     mm: vmalloc: support more granular vrealloc() sizing
> > 
> > The above is causing a slow down in BPF verifier[1]. Assuming BPF
> > selftests are somewhat representing of real world BPF programs, the slow
> > down would be around 2x on average, but for an unrealistic worth-case it
> > could go as high as 40x[2].
> > 
> > 1: https://lore.kernel.org/stable/20250515041659.smhllyarxdwp7cav@desk/
> > 2: https://lore.kernel.org/stable/g4fpslyse2s6hnprgkbp23ykxn67q5wabbkpivuc3rro5bivo4@sj2o3nd5vwwm/
> 
> Is this slowdown also in 6.15-rc right now?

Yes

> If so, let's work on fixing
> it there first.

Okay, will send out a regression report shortly.

Shung-Hsi

> thanks,
> 
> greg k-h
