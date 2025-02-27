Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56E22563
	for <patches@lists.linux.dev>; Thu, 27 Feb 2025 00:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740615604; cv=none; b=CKCxptY7IHCnWUwbeGS3ebkMELSTV9NTr/tJ08yZaTPYxplhbFTZvCwjRJ63u6VweeayiHn0RregLPy3X31xuOBWR8Ilkt0bUr3/+nDR9VEyERcKgT36lhLkJE1ls9hZTmm56cD6d1hPZGJzngHbXDl8RhVKUgJ0zh/abVk5kG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740615604; c=relaxed/simple;
	bh=/Uv2ZSNL0GBBewIm+5nlyMexuc3dwuC1Fvb/0p08ebU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UajhjceaErIq7FSvwsikHk+pwCS8+3V+MqQGXNlKEw8dIndKGkV1Wq5ZJw2FQxJfTBR9my0Ca4tNknEUSgTFg6nB1iCb5pSMOl3OIF20Es4sbL8ho/T4K5luz1Z3qfFyFiWCY8HRYUWk94oAvv0p5SAP2iKcsH7jcq/u665tYls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=bo8z3Vxr; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="bo8z3Vxr"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-855183fdcafso45353339f.1
        for <patches@lists.linux.dev>; Wed, 26 Feb 2025 16:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1740615602; x=1741220402; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x8wC1L3gj87WwcLGHPjzIsYmr9ioVfbKFSRwg/VgMwU=;
        b=bo8z3VxrrEhc1SxfiWDkD3XtzyiAVM631AuFv+a/LoQXNxlsvgIOxxKm3y5kAP7BS7
         Vy1kK3bITvvrE1FR32mJ9Xy+RQbkEaLQwurA8Z3ZzCNa2RhyL/oTGPwh82RkS5CcQJD1
         bXmJ8l73DQzhZ69kYWx+5I3Wj/fHoPY/ja5GM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740615602; x=1741220402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x8wC1L3gj87WwcLGHPjzIsYmr9ioVfbKFSRwg/VgMwU=;
        b=BToccZD6kYoV5G9pctLRkF12vqOWtu7yA+E7Nw0aIhNNDrChWqOTvr6bL9XI1RWnAZ
         B6tsPgqRNDnS/aGzZcmOkfbaxY1bXNuK04EpxWGtBDFuXL6p+MLu9cHbmEq9o1bstLPC
         VNQPs5Fi5UOcV//WgrLXoHZoTJLxQgKyzL7lzRvOOBVv84l/SHdntP5YMUi5a2Ly/VZp
         M7Z8Urg1VXvZ+GB+KYKGpiAT5nbFOzKTzfS7mpIfvRh115iwUlPDGu69z1jOw0aFR7Vc
         s5pI1epUseJJO1ZvoKNknO2WcEhsl2DINlkN9Lmzbws8UO6kb74yH1V0JuTRtG3TT0b4
         ORtA==
X-Forwarded-Encrypted: i=1; AJvYcCVcqE0QcP9x9yj+lGc1S+bBJK9j968CdhoyytwHL7/lEFYBRqtbuw+ie0ll04fUxNjeDEKkUvwr@lists.linux.dev
X-Gm-Message-State: AOJu0YyX84bgb62QPIf9TxPKLIl/BS7i+TpiXsNz7MSoyWhKFwhLL0Xr
	YNiF+ZJifQ6wsqak4WoYBK3VxXDc6GrfXAk9nP9CT/f0kGFLsGwhvQaMmSpy7w==
X-Gm-Gg: ASbGncs+PujNJHJEC1ov/r5gs2G3fBWIKHlDbBCtpU6Mimz79pBLAT5hGRBQgkhcxpR
	ZtY6kq3FataYhytJF4964qZ8T5j/lt9c0WSALlU49Pbbhqux320++EfaocJ/Y4Ek9896MtRbBd8
	JSxBH52QAZ0grRg2o7m6bDWzrJaBFMSYhP7qRsQ+1Py0uSSEKR8NaMU3gNr6fVnTIYkTNJ4x+QR
	Omxw7RMLmbNh9YKlQo4I5Yyy7tzyMF1CcppifMugYP3l0mMZCiLVeHMbwOEs1WVi1WI2IZZoHn+
	2/hTepL3OLDLv6s9+2+xnyhlEQk82Sp7Ez9COqOqE+0=
X-Google-Smtp-Source: AGHT+IFeShw3DzaW8FTTd4sEqD29fXvWlqwVnm5ezdkhi0VJ/bgUsO778wJVEgo8LhzCUlbtIxXpxw==
X-Received: by 2002:a6b:7e4d:0:b0:841:99cb:776f with SMTP id ca18e2360f4ac-85870eee265mr151794739f.6.1740615601682;
        Wed, 26 Feb 2025 16:20:01 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f061c0bafcsm98732173.24.2025.02.26.16.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 16:20:01 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 26 Feb 2025 17:19:59 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
Message-ID: <Z7-vr9gSWIsBuSZ6@fedora64.linuxtx.org>
References: <20250225064750.953124108@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225064750.953124108@linuxfoundation.org>

On Tue, Feb 25, 2025 at 07:49:18AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Feb 2025 06:47:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
