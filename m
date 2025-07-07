Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B7C8488
	for <patches@lists.linux.dev>; Mon,  7 Jul 2025 20:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751921295; cv=none; b=jn6UVFp91R4wd1Fde7HXc5YVMCkyjkMLH1Cie/2hWy/WRBdUcNd+I3GBUl+fG1ylVDtKK8qncyH0ut+6vzTOBioDyJlguU7GFfGT3PpIRaJPUVh1to9oargdMzA0rcHFD3Z/b4QYNFZ4brRr7afCwjCR2o/cXoY5rX/o42344sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751921295; c=relaxed/simple;
	bh=0LyE35m8eGiFlVySwAeG7x+SezPWKMVGpHRDKOL3s2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HdVfuReo1w8jjuPQD890oIyn+DX8xWTXhjrm72S8w3aCD8hTpU6mGmLHXXQpJKrufiRxKkxmL5h2Y0nn5dyltdEavRQgvnwPXmTzJfDLOWnpkJalCu/Tk+U9/uuwrx0gnCuMGjnqHDb1mU+CD8kta3amUbLzCfXFK7oIc245n1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mt7pO8Jy; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mt7pO8Jy"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-311da0bef4aso3888984a91.3
        for <patches@lists.linux.dev>; Mon, 07 Jul 2025 13:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751921293; x=1752526093; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XF8yJPEDjiuHbqKfKD0xRU3CXXpK0mf7JKANzcAD7fw=;
        b=mt7pO8JyQGgJqOYbLDxXsmnQ3J5HE9MehQ92/U+/W22Z7bMzpiQMNUmfrxnl7BGorD
         UarTHNxT6OGe3py/zs2qah+uXfjOGXcEt7eFykfBGVpMpaU1FUwQB3bqlkEFxEpREtQw
         oV4FZxu6K8EJv2DlJq6oq8qIGpGIsm1LtA8Et2iJs69C+mfH+zO5FeVT6ka5alKUlDU9
         NkPeofYx0tBPpxXd7rs0/pMRH6V8McgN2lE6zjwxgX0bxLx5l3J8sJOBECSp8ipys5wU
         3bZK4Okq4z+SmU5GaegczDSc8L8hMYzP0+hF87ratCrbfMwAmBhBdAQo1EpYxKXB7QGa
         2bTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751921293; x=1752526093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XF8yJPEDjiuHbqKfKD0xRU3CXXpK0mf7JKANzcAD7fw=;
        b=WY9nKu3MUX2t6trCs7mIJQqE4hOGW6Ph7B9cShslxRQ3H8udcUKj4sMQQmi8REWiC1
         328fur9eYi883PQz0CRbd+X0R5h30SBfVl4DGUiXdbnblHEpVDVDozfSL1GeXFPLEtOt
         Bb/3K+h+xHZIB0ulDfVYk6eoOINpgCAGoz50xuih2WmVuP+zygtldwQG+UV/HajPP1QK
         nbQPhCnXBq9VWrEOWCpJRYlY8pzGFLJcoudPABglN104jISIx7NB++yaqs5Nw/mJxqu/
         nnm2fbt5+bvPBkU+lfWQn3WtGzBB1r1HDNUs3QsC5mBVRDnVLdpXJ+RgZ1FCJlv7/W7k
         hhbw==
X-Forwarded-Encrypted: i=1; AJvYcCXB1mkegK9e/QJtFSqdrjUC7h/5IpmDlYv9KAftIH1863WgrV3tIzzxvjjyN8Rj9x9TGNUIfr2V@lists.linux.dev
X-Gm-Message-State: AOJu0YzBop4g7A3LqIHSzP/cT7tjf18jD9NnaJ2BW/OwS93wnbBsFfkG
	ND6+mOqCbrUaeqZh9U3k5xQGrcrsRp4HAWTeYeXO9H7WXlTwdOYvsaVo
X-Gm-Gg: ASbGncvqOlNleq1uZQm1s2ZgFUjBST6BmP7yt8GSZe0ab2Iljb8/956HIHUNw5K8ZJg
	RKlF7qSeeW1h33xW450atpEpJ1oS0214UChktFp3lGpfzAJHwhFCvfcamK1nFrgMR3+zE5WQxYH
	Q1yMtXXmQM7hDKceqOOlzI/lEHRBjcP/gJcbf+YEGyKB3FQmd7dS7kKYDCMK1/L3FT/sVlwUWaU
	2+UvA8wNtSx7qIRGdQRGLE3e9YysMSEaOYW8u6dnXgBfH6TXvBHsT+ZDr8l9l1ALkVFiJkHuqNq
	FF1cMF3pkJj56snGP2LoCmKuv5cWHkeLnAI+0BkqEkPs+b3Ssr+kvbFWgLnnIbUekIm/FhEg/Xe
	Kaq5j7EnGwA==
X-Google-Smtp-Source: AGHT+IFnGPopEwxi19+AVmddL6Q79QsAwXX8s12yZFjnSUGbziH4oWCaeqZ0smSWjCzluneBrcJuwA==
X-Received: by 2002:a17:90b:51d1:b0:312:eaea:afa1 with SMTP id 98e67ed59e1d1-31aaddb4b02mr21412268a91.29.1751921293142;
        Mon, 07 Jul 2025 13:48:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c21d67b7dsm210122a91.11.2025.07.07.13.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 13:48:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 7 Jul 2025 13:48:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/413] 6.12.35-rc2 review
Message-ID: <6bd90403-d7ed-4683-90a8-98f945a3ae36@roeck-us.net>
References: <20250624121426.466976226@linuxfoundation.org>
 <3037c3e6-558b-4824-8c78-a36990f4e4d6@roeck-us.net>
 <2025070613-escalate-action-761d@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025070613-escalate-action-761d@gregkh>

On Sun, Jul 06, 2025 at 08:03:56AM +0200, Greg Kroah-Hartman wrote:
> On Sat, Jul 05, 2025 at 12:37:52PM -0700, Guenter Roeck wrote:
> > Hi Greg,
> > 
> > On Tue, Jun 24, 2025 at 01:29:53PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.12.35 release.
> > > There are 413 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Some subsequent fixes are missing:
> > 
> > > Tzung-Bi Shih <tzungbi@kernel.org>
> > >     drm/i915/pmu: Fix build error with GCOV and AutoFDO enabled
> > > 
> > 
> > Fixed by commit d02b2103a08b ("drm/i915: fix build error some more").
> 
> How did you check?  This is already in the queues for 6.6, 6.12, and
> 6.15.
> 
...
> 
> They are going to be in THIS release, with one exception as noted above.
> I think something went really wrong with your checking scripts :(
> 
Frankly, I have no clue what I did ;-). I _thought_ I pulled the branch
and checked, but apparently I didn't. Maybe I was dreaming.

Sorry for the noise.

Guenter
