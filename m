Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0B817B51A
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 16:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712768035; cv=none; b=mOuoIrxj9hJIoa80n5mHFdg89BcozAInEDPmnDOptfj8rBzvLbdZZJTH53u7Yso32II6SJvEet3oe2K8DBp/6vkh63VgrPdJCT/c4HbsJ2+sl4hszwV4Kx8yMNhI6MZK5uXiwF119qZEfzOHOeM5L3u0q8XvBbByTxfINEbDlT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712768035; c=relaxed/simple;
	bh=AWrncjZwDA68NvWmjk2SeXSJBylgB9tyJoK1qiZjZZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NZLeOowYD/oBSX73Zy6qprXaFy1mpev1VSgtJbVRmtC1RxQ+VN119Y9G2aWFXNWxAoA6xBhqg0oLrVlauqxyoy+WhL3AS3CZuXdasIrixFYYI2hWDusUzccv6D5Q0oS5djs+XmnQFqzxp09WDCdQji1zu0tgrpi+kT/b+0sjPow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q/Ruor4+; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q/Ruor4+"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4dac19aa9b5so1477560e0c.2
        for <patches@lists.linux.dev>; Wed, 10 Apr 2024 09:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712768033; x=1713372833; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IAc/j38UGOp/hftDBPjpYs8Fj3EV6hztR3MkDnZUkeA=;
        b=Q/Ruor4+0TI0FQCDxmARvoqBMeiBupbvq8HNwZS51v3XLKmEhikzXXf2qS5EfMKA46
         HmNHnlDTwaURNPlZztVuDZRAdCjrmi1SG4dCUEXch+ENO9OUVTWSMDTDYRvh4VVrh1k9
         eH21ndU5XmdJqqZLvU9XANokWZl4ilO/Bb2yGsgcYpT8w2ziD97yUYyE/mBD8folf1u3
         Y27fzB1Uj45yEE/JImMGKlwjY0u14GFvT9s/9Q52MmG7BwyAVVzCL6fJqQs+x/ei4ubM
         6QI/41eeeDacK1KVQO/hFi9dK6WfT9UAHPhu4RfhD1N20r9aBdydZy+080yJ70DVgfne
         p7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712768033; x=1713372833;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IAc/j38UGOp/hftDBPjpYs8Fj3EV6hztR3MkDnZUkeA=;
        b=mXTrtyd4aT0xMo6z2yNuukbvtJLqPsD60S2MMOmjD2LJPWiHRyPRPfP7Dfy9TRFIKo
         exOZV3U0VGQ/RTpuZ3/D+aUxJp6dcKCDRSiELsAjlzW3oLu5gdJ60IRviXV+peeP+NlS
         +49VmqrwjJvHDoE19dWYjFzWiN2kZqOMmDxihuFz2IWXqg6JkvLP2alw383GqPrWr/OH
         wroNh2MVBgBHvXqEbAsp3BJMZBavR+gfqwvzKdxnizdYz54mkIqzeMzKqaCSOLyGVcto
         QUqUdHvQGQWberKoBl1DD3qA6EIp1yDSDIJrLz7hgjq9d6Zfs8/hESGdPoLxcFvdTyvW
         dx5g==
X-Forwarded-Encrypted: i=1; AJvYcCWgsJ/9W4htNol2jtGPGKks4nPrO/OreEHsA3jg6wAvYYozvYCHiviRgkliGg+Pv3pBaAFpXrPMYvkjiZROGwN4mVPz53pLeA==
X-Gm-Message-State: AOJu0Yz0tqxTnLHfrHD+6ulEQSw6DTEuhA9frkqu69aQqQl5cdbntbfX
	uSUG16mggne3B9IzHxLCrwGC/tXeMxNGDpx1oE9sGsUljA+Q7mdMeyqMkkgwEC9VmvANbYuVJaA
	miAT+AcNrvVWhpdmkY2LJXZ6zOzc=
X-Google-Smtp-Source: AGHT+IGr8TxVhMECHrTQdn0cbBNVJDXnFxELEO4vBuVLIbvK2lfh+vnOleOLJi3YUu6CE9zii1McOfPlpD+j+pkIQsc=
X-Received: by 2002:a05:6122:708:b0:4d8:7339:4c35 with SMTP id
 8-20020a056122070800b004d873394c35mr3263912vki.13.1712768033207; Wed, 10 Apr
 2024 09:53:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240409173628.028890390@linuxfoundation.org>
In-Reply-To: <20240409173628.028890390@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 10 Apr 2024 09:53:41 -0700
Message-ID: <CAOMdWS+ctWUtRdE+rYTmRGVqqmykcYsiSD0+rg6Y6nzEaGOprg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/697] 5.15.154-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.154 release.
> There are 697 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Apr 2024 17:35:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.154-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
