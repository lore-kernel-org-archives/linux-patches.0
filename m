Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA8871ECB
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709145914; cv=none; b=Rc2qLyeIp4A2ZhiWAYNzbI0vMtfG27E2qaIz8sWa+oy1KOwld0AegdIgq+2JvzQi34PXo/wDQ+LVkDcgZPlE7k7WvSrme4+T0QcErfpPwfD3DAvmf7iMxkM+65+mzfobpRE0Ua+oAbOgdwa/blPiw2QH/k/gdsfvz6S/50Z8cmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709145914; c=relaxed/simple;
	bh=JtRdfLpzL/ZV8ADjgH1+r8boDnPhsaWyXxdUuNrJxxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyWIdjsOMbiZlLEG8YxklU5w3vqh2O8LFayhe67tLde4LVRPEa/QbgpL334RI2FZNeXIn9Ngz6l2GTsucmSwr9Dc//ujguLFpz1Ag4zdFNe2T35VFL0byPWa8mAi/vWZhgG4/PsqXqPSpeQ+MNjT5vEJdlmL+h1OSvqbrxzYu64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=BOt0vmp6; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="BOt0vmp6"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6e4bbd7314eso5770a34.2
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 10:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1709145911; x=1709750711; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WYSW/dDZJk0AWK1P14MQeXGDy5+2acJ2m/1QBAbC748=;
        b=BOt0vmp6RlNNMmrpg3Nrblvhp/203of/VCSyGMOxhdF5WCFwJZYQm6iEpiti1DK13L
         xzAW0lKT5eT0btLdnWTWYR7F6t+O4IO4W5iA1XgvFyGMiPQOr2imSEwrVVVZaKDyzeoV
         eh1z6Cu9F3GfT2Itrc4XfI552fkDwma2NZNhE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709145911; x=1709750711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WYSW/dDZJk0AWK1P14MQeXGDy5+2acJ2m/1QBAbC748=;
        b=wkJnDQRUlSnbI9x2Uunye6PWYrfeyBSexgUcNw/pY4GkMZ8KQ2EWiKKOAqO93me17V
         4dkIP206ohjfEs/4MrMGjpvPJNTonHW2bUdCV20n3hQ6iS3chJgDwBO2oPw2mxHc0NSY
         fqcsaw60M4lBEydzelgJWwqnk/uE3AhhGJodCuahZVcVnjRryQgdRBQpdMGOotAg6gbd
         c1B5oAX3gsSsrVJms33RoBXF5nUaeCWl4PFWNXdeI+F2yZX6RlpGOlctaFEArtuOsU0b
         sfIuoggGsltiWKSMSfHcHpO6lLuKU4rKu7M5K8JLIkWUNW+I358BbPmlLs/mHsN2wMW0
         2iEw==
X-Forwarded-Encrypted: i=1; AJvYcCX7VQPDmLkcRX2UyxtRXt/BU9cIiigBxJzvCBt65458cFdpgjUvpCbwkjjoVKhhk/pFOoPT2rdZayoNioCaHZEz4LE8zhQQfQ==
X-Gm-Message-State: AOJu0YwQCoBt7O+Oc8+czqGElo+lDsqJzjDjIEt4CKj7GwXiviNYbvcK
	o0qV6/tmhTHSGepm2uW+I8SUDo37dO8cbRwk4ZpUfQG/oZz14CWweobeF925bw==
X-Google-Smtp-Source: AGHT+IHwJyaRoEm/YQfCjyx+WogJ05QIwcidCk3H5iKaBfOekKEk67mfRLlcJEz6WQoDdGUJrI9xmQ==
X-Received: by 2002:a05:6871:750c:b0:21f:aa57:4637 with SMTP id ny12-20020a056871750c00b0021faa574637mr546894oac.58.1709145911442;
        Wed, 28 Feb 2024 10:45:11 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id nf3-20020a056871460300b0022027f66c2csm12942oab.24.2024.02.28.10.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 10:45:11 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 28 Feb 2024 12:45:09 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/334] 6.7.7-rc1 review
Message-ID: <Zd9_NbbahAGDqscb@fedora64.linuxtx.org>
References: <20240227131630.636392135@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>

On Tue, Feb 27, 2024 at 02:17:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.7 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
