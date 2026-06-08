Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE77F3AE6F3
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 21:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780955605; cv=none; b=Q7kSZbJ1H4fSinElCK9s3OlQL33fU7ZejIZ4kn85A175aLD261lN+DQVzBdghRKw5tyu53e4mdj5qE3Pi50kBl/0MTGhnVvTZ2ums+igODm9cqcL5XBcn9FQfpGRceV4bnl1sdja6AoJOhHa8Z6ZwKh/9ZG8fOv1AhGUHKPX42I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780955605; c=relaxed/simple;
	bh=Juxb26ldXOFarDgZU/fCdttEflHVZH3q1oRndyT2/q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WK8GTdIUIK+4825T7WO8yz+Df8znGe5FUrWQpT1W6CsYLC6SuEbVVqmpTelLhde9rm/HnDy18xG8NPuwdh+9eIqZbwVXGM1XZQK+yxGgftf5tsg4NVUA3KTqmzb6xv5itE0CE9ev+lLW2coEe+wq6FKq0Vz4gVvq5+cSlcpLhls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Zm7t2TR1; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Zm7t2TR1"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-304f590dd91so5259335eec.0
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 14:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1780955602; x=1781560402; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EoYFOw7ak7HsB04OfAmg+EGUR7pul8Hb3G9gCGfENs8=;
        b=Zm7t2TR12Ew6yNRX3jbnXSOVQ9FWZ16vyNpCARVj++1VFklKdSRXdcw6PsBEKu5MuD
         KD1Jw7xEI5RD6SYpl5NogqU3Hf4oL2zjJEkYoIbKLp2UMc8aLFftODp5fZjVmSuN6QiO
         Np20b8s6wP8WhveN1otAHQODI7i1kAM/dHyFs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780955602; x=1781560402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EoYFOw7ak7HsB04OfAmg+EGUR7pul8Hb3G9gCGfENs8=;
        b=lvqqlguvJkINYAngwTMJ5KFTcu0eSufbIIdeVgwZRZCuA18pbTUfe1wcn2zsQnaxpi
         rev1eHR4Y7xMym5Uqh5bveciwft+B0uZTSvectO6kHlWKzSkpqpgFfXu+M7aIh8O4jDJ
         G/ldFbgNMX8uAwcyl35YvRPa5lM3YOIKTjSNwkj28SI+oJb768Oh4Gywfxqf8BYZG/Hz
         prXbdeuSC/vKMr64McQvvUyjgjNWSRaF8cLk+Z04vYSVzDdYDgZCNLOq5Gb0d0Qnigau
         y2p/7oCuAvmSV+j5kpCO14bdWqgJPqANFebgvPbwoIhfAY94LcFYMyElDYLrQmjzMM/y
         lY/g==
X-Forwarded-Encrypted: i=1; AFNElJ/NQHeUJmdcrdSqfjIicPBFwBsjWHa+ujikRQAeddTcKO79j+EzsRlWsm80lPtmcpxpSNoane3g@lists.linux.dev
X-Gm-Message-State: AOJu0YwwqBWzbDe+PzkvNXQHoOm7mMBEIEiRVHlnrbEdZHBLKxKvR53y
	5wGAUafu0nBN/Q9LQQ/vOne5QqNCRoFaIF6/MVgioBqKwZGb0UViHLloZrQ/J3kT7g==
X-Gm-Gg: Acq92OEt9vZsgwtglKHZs/9ZBJuZLo0BoMqa3GzKaDO11asoNq0iI9AcwU3mJQD9YzH
	D5KlFZ69Ahb7XGE3o71nXwI/8Giez9GehRf8XjOUvWYoxCcfghAROeCJ6Z04rHNaD6eju1YPDqL
	2B/RjVwwyHUmVyDpiT4gujSsybzXPzSczIvUJGCoQGrx7UZnDzNDs9tZbQM7E/3lwrRUdAcCqpo
	WOjB5kzlRsDxAFubdokPRGkYx/tAAKkG1ZA/nYiidyZy/5vJdpsk+xN/a+wYMPHg/wkHh3/595+
	ICIYaXpRzLRMjiaf2KshCrEgaJhqN2mjjXMaAqQJ85giwaBc2d1H/z7aTy2FVTHeldmzNK6QRnt
	L85+gC1ycmhKCB7zzslAOuAEvqe+RR5NTbsYsYo2eXmggeP8oEr/OfFmzcyKS44bVZsos4D5JPr
	zOc45+vS7uqshKzRQFy8ZJvs/+V4SG1amvBW4BkCAR9EZZZ3ykZxJx
X-Received: by 2002:a05:7300:2327:b0:304:5db8:da95 with SMTP id 5a478bee46e88-3077b7855c1mr9162330eec.23.1780955601933;
        Mon, 08 Jun 2026 14:53:21 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.105.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db528dcsm22171093eec.3.2026.06.08.14.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:53:20 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 8 Jun 2026 15:53:17 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.0 000/332] 7.0.12-rc1 review
Message-ID: <aic5zUJBp3i6jCin@fedora64.linuxtx.org>
References: <20260607095728.031258202@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>

On Sun, Jun 07, 2026 at 11:56:09AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.12 release.
> There are 332 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Jun 2026 09:56:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
