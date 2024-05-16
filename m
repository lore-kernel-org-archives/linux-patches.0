Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6AA14D71A
	for <patches@lists.linux.dev>; Thu, 16 May 2024 16:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715876823; cv=none; b=G4AWmI4dKhxDtn+uVjW26Yn86pvqlktl7yYzZ6caisB2tSIeiRdx3skz8XfM+KlpMrgDmSxPz6cfH2qm11Oym48Kc3irnsuUF1pdWiQ7AdKOWBtoQNn4YBF96kKntmpWZi1gIZmCOPfOE8YFryaUXWnzbsV/MWLCKfXG4ULTk7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715876823; c=relaxed/simple;
	bh=TWuCOrwRfsE/7sgVxnRfNWS8mwZphX3KUBtRSNprbzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iPYf6kyBZn6CXb1f/LsnKA6oYcQUzyzRyYjaKXtP7vd2y5cqmIF2MHfN9Up2PtZYNXNL27tp8mtZYTmkxlqtF6kokHBAg9xPgAavslPQ9fSCl/OnRD5lgMq9tJdnJiycm0TNSXQEt3Zpe5ks3khmxdaUr9HIRDg5Vmn7gsfiR9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LtM8yRYT; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LtM8yRYT"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5b2ed25b337so314534eaf.0
        for <patches@lists.linux.dev>; Thu, 16 May 2024 09:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715876821; x=1716481621; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4PkpXYOeMxPez0BVFDxZmvaRNFBBosJL15zaQ2tgikE=;
        b=LtM8yRYTguouotDHKMf2D66++AQ6vX5QTram9yC10WQAl3JV31KXK9fKfEDMy0n3Uz
         rpy1I1cqbwZdpnBIYYBHxbagQxFJVbsaSfnR0xEIhnaVhgrlpetRvG0EVkTfvrAyrVSA
         58rcYCjt8PBAofpAkZoLwF+8TLzmGpHoAylRtLmCEVRqVLxIggDe3OWYAmT2cPNVJnMY
         gu7/mIdYnJO4uQdJa55IBvrd53JFEVe97qmJ6gwtxD+habPoRzSMVQ64EKfeF+JvxQE1
         v2lpsCEUqH1L+9qv4+wyHKiASoqy3WLnHA5GJwJliANTtDF8yp0c8L/HfzpfP0Pc4o4R
         Uk2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715876821; x=1716481621;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4PkpXYOeMxPez0BVFDxZmvaRNFBBosJL15zaQ2tgikE=;
        b=klcnp0hyRiWAwf6F3MunM8VUPNXHiSQKa9S52sTiO+w62KvxIYSuWv2MZWt62NDezu
         ezeEKc5+hR4ffGfY4Q4zsuK0g/uohezHR4m2jZFx1EJYGMX+sDNGomPHEHSbddEzNnPj
         msxBpg5uJFTrBTRiN5SXSrEKoak2+AUHW/Wz0PFCn/B/SWIMmboqRdRU/vgc1sjdOfeG
         BGDfs/2o1sUtsG60IN6Zq8c5vNPu06Lxsy/bygssGX/2t1FZJWVLWYfQFZmN8doBKnXE
         BiDYxJJ8/qOBRlX9qr7jSMm3A4VXZt6EM/TYy1HmzXZt7V0ObEawpKKj6uX2w2qHGcoy
         whPw==
X-Gm-Message-State: AOJu0YwlN+pTVmF+048FvGTi1+XD9x1a76+Da/gFnaYV1ODogHQII9LS
	H3lYAgvMeIzcwP/XXLcYRTnX+200XfV5VvJmC7DvnwK+jPR+VGb6
X-Google-Smtp-Source: AGHT+IHvj2AgQ12I86jA52pef5ba8vJfLez/dY+rnEyOErhv3j6oahEuM7HfVkV8VBZQ/uVrNuQLGg==
X-Received: by 2002:a05:6870:a985:b0:22e:7390:da7 with SMTP id 586e51a60fabf-2417287ba81mr22782982fac.21.1715876820835;
        Thu, 16 May 2024 09:27:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-792bf31171esm812657285a.116.2024.05.16.09.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 May 2024 09:27:00 -0700 (PDT)
Message-ID: <7e8306a7-c32e-40a1-9f99-78cfd5a49835@gmail.com>
Date: Thu, 16 May 2024 09:26:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/308] 6.6.31-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240516121335.906510573@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240516121335.906510573@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/24 05:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 308 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 May 2024 12:12:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.31-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

