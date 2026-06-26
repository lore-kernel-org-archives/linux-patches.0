Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D51D2D8DD0
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 21:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782508640; cv=none; b=uDGjOa8ks3hCKPUtkdx3XqCv2Lpgf0fBmvVTC9aqjg+S9tk8w8who9vpRnjjX5+n4I7s2iHExB5YSVjZ7dOhSkhIHFU++GTJdToreQJOft2eQO0n8p0sR55/4v49h8jJ92zQuQoPVg7gWjx/1CIrJEmrA4oOEjY38fLOQEjXq5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782508640; c=relaxed/simple;
	bh=f8+P0j7bKuD7GBbgiceDtmS1hF48EPud963cenzQPP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KEJqyR4kHXBrboadOLuExQ+0XEMv5d9qXzTDRL1NNOWIkzJNpmVGt8OpbigktSxw3iCWIVaMkHgxtQWwCQ3Zikwf4+RQAZeLVCpJ8chC6Rvl5/Ydh6cOuSu3E3E1UYNUk5oJZnZE6yqvXk0VtL0Ykiclg/psCp6WzDXtQ9/kvRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C0xC0hD1; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C0xC0hD1"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-30c9c8c2697so1552445eec.1
        for <patches@lists.linux.dev>; Fri, 26 Jun 2026 14:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782508637; x=1783113437; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5FYxptaek7EQM9lggJzimluJgqrrJTIoBQ9J0q20K0I=;
        b=C0xC0hD1wrtmqn4m0hxtEia1BJHQGwRRG5Wis9F8kjQb4jZEh08xsxSOuSpak7TFjy
         7Tb3BpQKj58lSqwJgn1xw3lEbYQVAg9maq0AC8IAY+lOkwTVdS8NkGKP6eaagUsNkp0d
         vnXdQIeviygxNJ9E0rkz0f4Dl0+4UfMaGCtdBn2RjRHuyR/g0sLdbcrumMvkTODHddFg
         S48ol4tCdPRD9RIhAjuawh3Bf1V5QQOoPwqaCcrzLx8J+DTs0otpDXGSujaxgffVaQGH
         RN/8j7e+DRoQk5yaVpgFi29D6x9NYHe5EZq6cRVphIocvaHJgusBFyD7t/TUx9LvNc0g
         OlwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782508637; x=1783113437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5FYxptaek7EQM9lggJzimluJgqrrJTIoBQ9J0q20K0I=;
        b=nesbH/1XhEVnlPZ9toFgUn5H/OudZDGR6jN8rxDDs4dDM9N7FyoOEtpit9ERLdmC2P
         WpVwg2PCAPH0HxaxbSXIQLncNLVACocHi6oFpROCVFp+SfjK8qjo/U7yDC3+ejikujXF
         k/IhRhiQQVwbokjXlM/hd8GNeGpS3f/rXJc31fWm9slWb2VXzNP5D8JdnN1VpIsPN2lE
         QrnYDu0vHQBCyk3FNHICPEKJ4K9wczuAOE96J3RRkh46tbamhnRJ8u4lq5At/mOiVo9L
         YzwP43SjMY9zJGyAo3kojvBIysjs1QsSGG6lQXRXc8Ft3qaeyJdA7DodBMD4RkTpB15R
         b2RA==
X-Forwarded-Encrypted: i=1; AHgh+RrLxpriOZGInaPEnuKoGq5N8CT/nJYTQDXkoyqU1RyuVY4x3fli95/Tt/YJgjMgW+RmYGKIABBh@lists.linux.dev
X-Gm-Message-State: AOJu0YzCzlRiZybfgaccucwgKaH9cnOT0qVuix2FOIdod3r3qF+t05gC
	zkgKS5Xrek7u78Ily81wWpZ8RsRQM1MDSnPQj0Gi4ZDi9qHI7QzrS6CY
X-Gm-Gg: AfdE7clFRis1ln/wVwebFBojFJDntc0X9RIigzM/t/BocM6m2SjeQvOxzKI4syHVhaq
	LSbIvxPUIHj9sS5fg+2/toncz6JKs2DlbH52TLMa+2HP8WIFvI5mbj9yIMYMzeiELVO96KAu9+c
	ljdhMmhf67PnNOpRAGHflWhjJMhyvabkjTrJ3QJrgbZNA80oYZgSOi0DYBwiAxwaigdA2ROVZhl
	BIMhi3yIA5XFS3sMaf/o7uJAvEv2rDMz6YZWQyNOzcN6S77JQV2ZtmnZ+Chwb/DoVjWLDL5CRHl
	xNrUZyUUWGMIvrutxQnfLtbpRxw/PYGQT2hWLleiq1N5GLA62arFbbDkNeuE9QqwG9gr0+F+B/t
	HHpQI7xY5JaEV/Ng+e90/lz8Z4GJST8d5EExuAxRkwvF2YTblg5muh6A1KKYhxTmxbAbF40XwCt
	qLggtQs2DBi77Fw05jRmEXvlvivLURtGfrcETqON9niNqY9aTyGWdwSQ==
X-Received: by 2002:a05:7300:760a:b0:30b:f0c6:12c8 with SMTP id 5a478bee46e88-30c84ba31edmr8054304eec.9.1782508637000;
        Fri, 26 Jun 2026 14:17:17 -0700 (PDT)
Received: from google.com ([2a00:79e0:2ebe:8:a474:bf4a:4966:8d97])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c8b1a80sm20444292eec.18.2026.06.26.14.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:17:16 -0700 (PDT)
Date: Fri, 26 Jun 2026 14:17:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
Message-ID: <aj7r1Eqt2SEnWsMZ@google.com>
References: <20260625125613.243729608@linuxfoundation.org>
 <b7bd471b-e9da-4bfc-ad1d-24b378bd1e44@pobox.com>
 <aj7RmyBck8EkPn_s@google.com>
 <ab7df7bf-1b30-40c0-9463-a469abfa2bda@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab7df7bf-1b30-40c0-9463-a469abfa2bda@pobox.com>

On Fri, Jun 26, 2026 at 01:41:38PM -0700, Barry K. Nathan wrote:
> On 6/26/26 12:56 PM, Dmitry Torokhov wrote:
> > Hi Barry,
> > 
> > On Fri, Jun 26, 2026 at 10:56:21AM -0700, Barry K. Nathan wrote:
> > > (cc Dmitry Torokhov because this is related to two of your commits)
> > > 
> > > On 6/25/26 6:03 AM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 7.1.2 release.
> > > > There are 21 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.2-rc1.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > Unfortunately, 7.1.2-rc1 breaks the Synaptics touchpad on my Lenovo
> > > ThinkPad T14 Gen 1 -- the pointer no longer moves when I touch the
> > > touchpad. Potentially relevant line from dmesg:
> > > 
> > > rmi4_f01 rmi4-00.fn01: found RMI device, manufacturer: Synaptics, product: TM3471-020, fw id: 3972349
> > > 
> > > > Dmitry Torokhov<dmitry.torokhov@gmail.com>
> > > >       Input: rmi4 - refactor register descriptor parsing
> > > > 
> > > > Dmitry Torokhov<dmitry.torokhov@gmail.com>
> > > >       Input: rmi4 - fix register descriptor address calculation
> > > > > Both of these patches seem bad in my testing. Either one, individually,
> > > causes the pointer to no longer move when I touch the touchpad. If I
> > > revert both of them, then my touchpad works again.
> > > 
> > > I have not yet tested 7.0.14-rc1 or 6.18.37-rc1. However, the problem
> > > also reproduces on current mainline as of this writing (commit
> > > 51cb1aa1250c36269474b8b6ca6b6319e170f5a5).
> > 
> > Could you please try applying this debug patch and send me dmesg?
> 
> Sure, I applied the patch on top of mainline, and the dmesg output is
> below.

Thank you! So I messed up and "Input: rmi4 - fix register descriptor
address calculation" is totally wrong.

Can you please revert it (keeping the debug patch) and try booting again
and if the touchpad still does not work post the dmesg again.

Thanks!

-- 
Dmitry
