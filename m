Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700052E64A
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 18:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723744887; cv=none; b=sXkSxa6m/lyeeQgw1ifLLVI8fl5TOmi+UEysu30bHuebX5hutBd5cK58wx3+bwdtjE+kyt+yF/rQfOjZDKwbbdJUXmRnsU8Mnx4jMsTk15pb16YUxk3+UY3HtWAIEaJD3/9uU/1543s7vOkxvPXuukBiTzvzVSpMX57ddZkIElA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723744887; c=relaxed/simple;
	bh=p5CFD/hz48mXaQtx+PagRNm416H5ts4dtuVJW5kR9Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RdTaf6rkQ0tKyl7VTwXqJlhruANafw/dKHNpSxFsdLg6CgkKFwJcIAVL8cuDfTpQHczWEdCPY7/9K9jStGz/Iljgd+zaUCXdZWB6R5O0P02bPKZLFltGn01jQZFX03Z1HUsx5vpdLC3XmZgdocRtd0nXfp16Iv4/NUMF02bA9vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Zx+W3cnB; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Zx+W3cnB"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-81f921c40f2so43629039f.0
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 11:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1723744884; x=1724349684; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7p/I1Ifd1C+sbOJNrkMm3G9GQ4/rpO39owsvu2wqEY0=;
        b=Zx+W3cnBCY5/DYQuk4YwUPWgy2AxVyGerOV2Lw9XZA55rxgwfS3+Ap0NFVuCstG0kC
         Y5HfVDgShaQvzMEIOUfw//xc4BF9nxt0YT0F2v7ijBWqWRCsm1ZtEd7YyQR5ghK7/E7n
         B8U6yfd2WSTV9WbhbUxXRedn3bSDt0MXvSXUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723744884; x=1724349684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7p/I1Ifd1C+sbOJNrkMm3G9GQ4/rpO39owsvu2wqEY0=;
        b=b6l08bWklMSJN6nAy5YhhnmULkGjRJ4ja4VO/jJhJsWnma+J45KdtjFvCA6vFu8U1d
         PBAUPlcvYt9j7G4IBysLQfeDBMHbnovfJAyUPxXap44ooDFZ9iTR7g0MxoHNAx0YSSQP
         dQ5gLtz9bv84CGHxuXbApPliT5YFDhVtQCDpXtXKGcalju7vwoBmQh/3BRSn+wQ+ZM/Z
         awhFnCcbKDZD4b/k9ZJ5GMpNBpV/g7TmgnkaUeUM8/AcldmP/2E9dTj2PO+GwkYpRV4A
         NY1zjBEmdgAMHvciR4G1UO5fcqixN4Gi+Dy2Xj3CgG0+FjoU2ywXuRye2iTOVFz1Rqyk
         eQzg==
X-Forwarded-Encrypted: i=1; AJvYcCVNmQZTWQKW+SDZoRDZVkhoAEyZwedKsqo3t9vHcOJ3bd3v+b7DcOI2R+5tCYECfrYxwwAnfnw3DNJl3kj3fBB7jA+RmTZJuw==
X-Gm-Message-State: AOJu0Yzd6I+lDE/CO4VNLgtU2KRxxwgoknHsonTTXKy0AQ74/+h7X/4x
	IJnxvaFTq1XsFugJrLZHMWv9h6PnlCEyBZINOniINNucKeszAy6jcjNCC377xg==
X-Google-Smtp-Source: AGHT+IG1BCFoeSQYyuZLRltaAhHPgxyHK54Z6wNBqWVndWOortWFbIRyHExDA0GIirWvVECf9j2goQ==
X-Received: by 2002:a05:6e02:12c7:b0:39d:1cef:2f49 with SMTP id e9e14a558f8ab-39d26d7c847mr7678215ab.27.1723744884267;
        Thu, 15 Aug 2024 11:01:24 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39d1ed76533sm7152115ab.83.2024.08.15.11.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 11:01:23 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 15 Aug 2024 12:01:20 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 00/22] 6.10.6-rc1 review
Message-ID: <Zr5CcFhTtIHgtj_Z@fedora64.linuxtx.org>
References: <20240815131831.265729493@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>

On Thu, Aug 15, 2024 at 03:25:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.6 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
