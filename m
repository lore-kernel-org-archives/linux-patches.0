Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB6F23C507
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 19:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752004793; cv=none; b=rgcsNycoSI1BbQwgelSKZudQl3KRBnVVRt0METIi55WGW+7VpLlgVbZccdu8OdGm5eoy4KLcXi05w3ebHyoLpNcNJ9nXR6WoYD11TSNpXKXbDqvRVxMStIdN9Ijw4QcWOwltolGh/gHQ6aSRAl73MIwowVjBwugPBq4e6QTypLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752004793; c=relaxed/simple;
	bh=sKuB8RQnIfm8FxftIf3X0GOfjjaSkos0VBJiEDTBxlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WYl7tSXB16bUmhTC3ptv8gmDbAgGzezfbgAelE4M8aL2xcq6svpqmizPYVDBkkTuPpvEFV8t8aSStP8x9d/Mz7wfLisa35fi2kT3gtw0GWx6MlT6IFjCd0AkiNkjMXpKVOEJEeGUsNDoxTxFbcD5k5JFgVVKD8wbYdaG/kCvb/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=g/U2DZel; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="g/U2DZel"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-611f48c6e30so2729400eaf.0
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 12:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1752004789; x=1752609589; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SB9GNWWsPYQTrcDwgkvbanghflj6Omk2OsXB5XCpSp8=;
        b=g/U2DZelgxYE/JbjymKPifDSP/QA1g9lCSANOFz3AZ+AqE6tn0IuTF7j5K7FrjBl8g
         49RPhOjN86nov8EXHBCnUT2Wu4u11tOWTfIuXemQ7xFBmABsia0X8xX9o9sk0WwtdspL
         W2t/OT3pN/c0n8pEET5lpPbYgty5hoJDcj4LE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752004789; x=1752609589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SB9GNWWsPYQTrcDwgkvbanghflj6Omk2OsXB5XCpSp8=;
        b=xTh94yYDIuPsKNq8hxIfpCfpD7zAzvgmmWbr+ySeHBoqGibsCo/vLRMc3jDXWoexLi
         FIoWNUddfZ+Rw/pyPI7HzYv+0O2f3gLcdikUboWIvsGVysNWQWm4hWHMX1e45NimtrZJ
         ddnaC0ucRFG93QP3/CVqUMBIb0UWYgNvRPWmFmt+lP3JJ66kKbulwVdmu2+OM+iwAduP
         SWYlE/i8bCYrPbtPjmRsCrBXIvEZ8KiaUE7aptDXY0Q3B7/yMWvzwQo2Ql/jVl54CRFO
         +wZVp23BWDQ2LkjeUV3S7JLIgBBTeeOT5yqJW03DJ+q9YwMSY7obpojWYtGF1IXY7syS
         1eXA==
X-Forwarded-Encrypted: i=1; AJvYcCWa7KFL5jfNkLiSwPmpz35/gtCYLADHYV8x8kk6wx0RFieHqvshIuVGS62FJSC2oq6KuEG+dI5H@lists.linux.dev
X-Gm-Message-State: AOJu0YwHyN5Lr68jchQZypyf0OE6orJDCKeNmeGHmhfEjarDNV/9lMqo
	ZcSVH4sjufFULSs/D23aZmIOExII8kjip8S1sYv2tmypTWGSbYYWGQlm4f6GfCNvQg==
X-Gm-Gg: ASbGncvIqIjSjWrNp6TrFTImuRF9B3jmN54u5r0TQy8kgCdy087NQtVeQ8zzbYSQcLM
	O4rjFWidIujYOZm+vsVsg1GP6nA4scTj7eUrxQnCyDDplpkMRYUGeTvIByOdDvQb+duomnojEfS
	9AzvyxQS2mZAgiILwRhzae+Eovnjpvai/RR8sAS2sEoF6/fFYIFrwkSyynPcLltY70Qqz7qQUmj
	QkUuQjwpCAqQwRigVipkMy9sAFe4fX4kyir2r8wnNRWY5iS/EWsG8FZ8STI8XI8hjRg9keOyBKY
	5PFr+70XC4GyL81z07YUH6wOiBjpqAXrK7RLxMb70l6cTTX3lghax10FQEPsvj2+BqIXfqXi9gl
	jn7eV6HNAK4qUKw==
X-Google-Smtp-Source: AGHT+IEtr03NSkK6ECFSDZy0Tth+9Bq9hzDGfXM4PYpkiHw9hwDD0Kxv/StPhidCcUjve7ewHnoJDw==
X-Received: by 2002:a05:6820:210e:b0:611:e30a:fa1c with SMTP id 006d021491bc7-613ca6b5916mr758011eaf.1.1752004789129;
        Tue, 08 Jul 2025 12:59:49 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6138e590c86sm1790207eaf.20.2025.07.08.12.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 12:59:48 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 8 Jul 2025 13:59:43 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
Message-ID: <aG14r1ZicqU4GNbI@fedora64.linuxtx.org>
References: <20250708162236.549307806@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>

On Tue, Jul 08, 2025 at 06:20:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.6 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
