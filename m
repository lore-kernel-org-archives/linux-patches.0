Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E16D81ABB
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 18:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708540754; cv=none; b=INLIEru19xIvzhIX+7QzcFbQHdBRCe8LDgBRoFZdt3bTpuQQ9GHBhhGPxi5hmkCZ8zxFzQxTamTaN+scmMPoYSr8RQdLrT1pVeDZB7cZ6ulKt6WsqMyLFPvzTq/AJ1qlU9lwSXPrGY9G/le/S1uqZWgvpBY0HNeraGik746pAGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708540754; c=relaxed/simple;
	bh=wORu2VHuAnw935+Cv0QQr5ove+ncqd8zeKB3hAAfA0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PeUwgLkVnthnuwqqguw1/AvgZDyVp1o305brw8Rq9a7hksPfcyE8PFYjP9Q2lPPunKkodRwb3eeJIPpzTLv+2Z36h64fpaCINTRxfiP0RcTYENSPEKm8xyo3ZWj0RhG4HXSsqCRzBZHqIzsqmlHXOMUK7sC56gb/xl+8R8E9tjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=M2QsL3r0; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="M2QsL3r0"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6e0f43074edso585289a34.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 10:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1708540751; x=1709145551; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=epfXkFMvEj+O6RQTqhcuu/VpNn7r6C+NR5UDG63CzB0=;
        b=M2QsL3r0q/XvtDDay92c+2t4rvFg0GU35GA2hfqyt8e/KTL9c9tdXE76WHo/nxfqO1
         dHr/a6u1oAWBI2zf3o4YzI2/WqDZa/QSpNrvFRWJ6TvqS597sclSks7dEYEpOlPBrKjD
         uKMvA/DQdx73IdgQVxUiLg+4Z5wsm1r4qCyE8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708540751; x=1709145551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=epfXkFMvEj+O6RQTqhcuu/VpNn7r6C+NR5UDG63CzB0=;
        b=bg8UddxRuOrzfqem0oo1EI1FE1SSR5rlaeh74lrsAi+V0cWQiVw6FsC0XJcGEBK6fq
         5p8J5r7EGSeIFr86meleyGn9X1T2kTGEXwqGeidd6g6+jzHFBdu+mrsbn2RdAfjDrbPu
         3dyu7x1Z1hoRmnhjfGB6vCPgkRAd6MoPwFLucIuF1ttXZ0KbBqVbsY3aEdeRqXcW000Q
         7A4kmm7etOIrEB8ooRexmOsAce1G3NSKhs8G/Pjgvj9Ej09LJ+lsp3TaA7oPj9+eqGP6
         ex6H+whsg/kcXzidMtx1NMS048jm67fNv2j3ybLgU57NLXNUIupHPsZ4FYyFLyyZGXKU
         y8qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCk1N5SOALy/pUHYXfGab53535Eo4543dGTjSfq6f9pENpb3qYYWqCoK4kq+aJbP9juFLf1Iu4iX9yO0XI3XbROsvb6XMROQ==
X-Gm-Message-State: AOJu0YyZ6kSveUQgWxD9b7NjEbaHsR8VDonfgux8NZ9u3YW1pouvgQq8
	X2VUHqOF9Zn4fF2F/67dZhaYeaKkq/x3iQPCHRnEmIvfRYNMoqbDOh/vTrbC6A==
X-Google-Smtp-Source: AGHT+IE6vQu9Ee36mA2Xebhws5M+r7A1PWQ4d3zqpqI9AXKlri0chGThzivmD6usVGdGBqrmBaAwIw==
X-Received: by 2002:a05:6830:454:b0:6e2:e526:b0d9 with SMTP id d20-20020a056830045400b006e2e526b0d9mr17898788otc.16.1708540751121;
        Wed, 21 Feb 2024 10:39:11 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id a23-20020a9d4717000000b006e43c2c4381sm1673596otf.74.2024.02.21.10.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Feb 2024 10:39:10 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 21 Feb 2024 12:39:09 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/313] 6.7.6-rc2 review
Message-ID: <ZdZDTZQDspSCagGj@fedora64.linuxtx.org>
References: <20240221125951.434262489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221125951.434262489@linuxfoundation.org>

On Wed, Feb 21, 2024 at 02:01:12PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.6 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
