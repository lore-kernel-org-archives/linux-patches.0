Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E3B1A0726
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 19:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721158752; cv=none; b=tIkq/ttAMdjgV9BbYo/0Vyu+vK90C7znOx6zO1bi07zW3KRgC6mBvRk7HAXmKVrGOLc+oAH/2b1lrPJMOAZ8mbJcQN9NknVgrmXnwifVr20etgywqwKDnQUcIr4asHlg0QcKgODQxXsyCi+nReZJOU8tau1pEczFWT3lARtjdWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721158752; c=relaxed/simple;
	bh=SFnYNtOX/L1s2rt8W6yry0w/IYE9fQO8IYOkwAWeNOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oaXcyqC8IS4JD8KM7tU+sftky9+kyQtp9jaFMSOj8mkaExqPv0IWdTGNBZoKsnm6a0t/REJIID0NvDiJWfKxwStJ4gt/L49f9QM2JNTk9fAw/psnfS5/1zPfwaQvXtOKyittKDGeN72fc7nQofnrdsT7j8quIu7PpAtLJ5XHR7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BvfXFb3q; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BvfXFb3q"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6b5db7936b3so34503516d6.1
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 12:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721158750; x=1721763550; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kH9hMqX+74zTwKMOrS9BkiKcobiTryPKW197Iu7EZMQ=;
        b=BvfXFb3qBbcD2L8qVsejMWOsE/v+BDDSqFFoXka6+gOYu57s5dhZ0HD4JCt3JPD3FN
         9PSPJ5Vr+AdooWLgv3/CbEen3qksQYFUQ8ETp8AdzPCPSrbpVJ0z8x4gLc5mLUcaTpj1
         ktIKJaTL7Ibl4jY7c+Bv1MtbJn/Ru+p/tWPoWvIl+o+fT8IGEtzohw6JAuS3zUdZ7OMT
         LAq2iWfSRthceGr0HC29LqJdQV48H8W3k0alV2tPnr14o+7uKYT3/P6ZeLvNViceFW6a
         fzgTC5u02X22HmHy4MKNbgH8PacaGLoN4q8bbgWomBldydABtZl1oYT+A8kyEiMVCWiM
         WyFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721158750; x=1721763550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kH9hMqX+74zTwKMOrS9BkiKcobiTryPKW197Iu7EZMQ=;
        b=h69304RBWkDKIHDn05luvF/K2eb9HQCwcobSeUyFzHcuSc4YD9q9J7vPoKK88dt5T6
         tNCKLYHxo9SPtB6itNH+QZm9zudHBJ5LyWKCWTu6qxi9C0y0ShG5OXIrGujlxYMJUoyf
         RbPm306lFfqErTvRICfq8YkBnBN7xZ8dR7T3jb22x7jLN12u488+lNU2NMuqxJz312xx
         YhILtFVC6OH/LF/XdYw+ckfIRE/8n6sJwni1yHh2NuxTdlJzB08EVYlnqyaxwG9vuOyf
         KUDDSWv7FDolOmZ0SRjj2hR+l2Bw8MKT99eWAGF8zRsjZypc+Zyntu5X3cYjD+kghVTK
         sHgg==
X-Gm-Message-State: AOJu0YxXP8qoCGubrzlqbWCEYUvS8RRP9eYiJyYG/brlqWAeokwVCOxP
	RBXviz/qcnrkC/h7RPgqFApPZbNsJMw4F9DXFwyDCLLiKz6L7kmC
X-Google-Smtp-Source: AGHT+IHQ95V4tAwmAsKIqQ9hZLbfGvJSJJoxcNc2i/Kb5qb5MSj61OWqrm+sKX+DSRZD3H0MJBOQ6A==
X-Received: by 2002:a05:6214:3011:b0:6b5:da13:bf42 with SMTP id 6a1803df08f44-6b77f62d83dmr39168296d6.58.1721158749565;
        Tue, 16 Jul 2024 12:39:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6b76194f42dsm33958866d6.8.2024.07.16.12.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 12:39:08 -0700 (PDT)
Message-ID: <e93903e4-685e-4960-aa55-6cfe153992c4@gmail.com>
Date: Tue, 16 Jul 2024 12:39:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/143] 6.9.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240716152755.980289992@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 08:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

