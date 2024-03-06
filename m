Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF02D531
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 02:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709693715; cv=none; b=Vr0uiYHAesK45oemHKNCpDQzzAZFeNbkfmP1M05z3xpS5Q1Vbe7rzLBeb37gPtwU50THAWfBKmPtxA/k5GJg74LfLK4yEHhU7e2t5eVFmShU+MryB8ALGvAS1Pdw9icnw+QqZzT8MrvDlR25xa5wN6rI3ZqE8YA8OPsOTq6T21c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709693715; c=relaxed/simple;
	bh=GsRdJoaN6E/LLUOYDglle0uztnU6Sis59Fl7J6wutgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ah0EzAlEKZ5qq1E8JVSjzUKz+gukx2SmePJfVSOxK7shkW8NRRYZBTAtGbENzpOQ6w31yVYAxEHUlYqI45jPos5O4VQeckPVj6WQYlcRqnPkPM8lMXTOXi8uHB12CxNDnSVQuzKzXea8S70qv23mApkpyB5iJE+YUVP5Kj9askY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Ma8su69M; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Ma8su69M"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5a14dfa68eeso781280eaf.1
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 18:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1709693711; x=1710298511; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xRMkuI014AzS1zR02MZc4IRf3TGjXINu42gGkCfeGs0=;
        b=Ma8su69MZQq1jEV3Ivn/VWuojmDF8ry0UtGvxf9v3dnfS7/yNE/zrXRNMWzkCWn5Fj
         4Xo8qlUtnKZcS3eVpW0DQY8C2mETVFBym1OgaiJDXy+zi8MQuocm/unwmHOEg1Y60I9S
         W4suIVkKNi3FvsfL0mLNWy8iUMyUFaaKp8ZSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709693711; x=1710298511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xRMkuI014AzS1zR02MZc4IRf3TGjXINu42gGkCfeGs0=;
        b=lthmjKR6t7xoz2FMxkZKlwaDs3tnJGkuNdlw4d+Lz60qcKUJ0xcxZaAfR/B3cOAIRu
         zhtQS4jOYEbbiUJSrXUO6aPBWS09/2mMC8WId5jP3Yy2BInYFfjowCJGZDRhSP+Pu2LX
         Z5rE1hDxfc+UZxX6aa1dyIFA9BStFQB1Tsd6DLP+3lwfFn8YlajnzXU6tlT7gQBnHglP
         aFIepFJa+opgaYFS6evy9QrHZMGOf7pud+F1C7Juh+B0pMFQYLdKM5tBftQrehdF9LIr
         yBTnDUNtdMBDTvU8ikR9hvAFgt1R1NZMjnAsU7tFuKv1oFW7Do4LEdTMa7xISt2c3mz4
         7BKw==
X-Forwarded-Encrypted: i=1; AJvYcCU8YrN9xwcTWOW9O0wKt5MvgwzFnwlcFpR0Z5DrxNnCBLxU7EgPSWeWMjfp7yQ00rLiAsNtjmDXTbujrd0vdKBVWIqQAhdJoA==
X-Gm-Message-State: AOJu0YzsYApxaRZ5BgG5j26+6lEqOko8EiZb2K+0SrWWAE4+x0Nh8ztw
	Q3xVQc7IiZS/Qyehxt0j18wJIeKaTfhPj/Hxu4kbSpNcb3ivuDPqB1uBiPQUwA==
X-Google-Smtp-Source: AGHT+IGVQj4drpeLlqZu0UGH7MJF2dKwPJG+QIfz4rVWUgG8ZqQMiN4a2/ohEToFBsdf7vzvg14fqw==
X-Received: by 2002:a05:6870:63a7:b0:21f:17b4:3842 with SMTP id t39-20020a05687063a700b0021f17b43842mr3820887oap.45.1709693711394;
        Tue, 05 Mar 2024 18:55:11 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id qh10-20020a056870bf0a00b002208ea2347asm3245084oab.11.2024.03.05.18.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 18:55:11 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 5 Mar 2024 20:55:09 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/161] 6.7.9-rc3 review
Message-ID: <ZefbDbzbLpiIR-0J@fedora64.linuxtx.org>
References: <20240305112824.448003471@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305112824.448003471@linuxfoundation.org>

On Tue, Mar 05, 2024 at 11:28:47AM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.9 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Mar 2024 11:27:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.9-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc3 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
