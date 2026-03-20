Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC303D8110
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774029133; cv=none; b=hQlZZWxyED8J5NISC8U8AZlHylj65WVrOX8gXaGPT/CjrDssU7VG/umGxEoNRNya0sIDywp5xxp2KGbyDZxeeDVA6zCCGJ8iq+xNqA5Lzwj5q0QYl3W8CYxjU4KcMnuIA3fDhhNyRY57WICy3DDEy5nUV7tios9ZaTEpSZ7RufQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774029133; c=relaxed/simple;
	bh=FBAp7QXTdTxIcK1n7ZRiKy+2vN0cuhF+4SCsdQX1Lbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WgK6iAGyM/Uoj4oYeSRKCkG1AmO7aKe06rumCg8mDm3Rx87iDxDFTd0/sR9suojOpGGXntwB4LWC2HSDHvCPCV+V0/qY2dRCNOtNVb5trZaC/s6Y63Ifn/Cb3fv67imINktKG9qA7THH3kbW3JzBYMVPSk3rpkPsylartQtlbAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eq9iuzu/; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eq9iuzu/"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-89c5d795248so28919346d6.2
        for <patches@lists.linux.dev>; Fri, 20 Mar 2026 10:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774029127; x=1774633927; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5p/eh4c0iTvoIkHEi65nOWI9t/D4H6eibwcW0anhep4=;
        b=Eq9iuzu/yIkpVg9A1UyeED/rR4wM24X7JCsFzduzlNbOfHDNgp8QBIHusebkic97Sd
         Hb2OLH+P2tvONMDq37iV6jwTHFMz6yXvlGKmz/qQvTMcn/vK6cmhjVNmezt7/gAtFa/k
         oK6Hi5VvUd5aMeP7SV3k3UfjHkOM91dRNFy/IWlvaMeJXx9xIwecQD3H7N1yq95tfbT5
         2LJm8OIpv/hvdPqv2rW7PTFTL345wAaDFo03x3qtkx3G9aiEpUAGV9mD6ZeSKZeS818x
         HiTyLxKPMEGRkC1OGoihKbBhlxOarbqgvnSyi+b3zI/lK9kIkqZ3qay/cIEiLWdCvCzk
         7QKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774029127; x=1774633927;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5p/eh4c0iTvoIkHEi65nOWI9t/D4H6eibwcW0anhep4=;
        b=WRxh8Xe/h87fuqc4+ofuZiwINYaelBpSN315tt/pSKy3LuZC+FuVApu1EqCqeGyVCM
         dzChOZbAFiXyfkokysekIZsoCrCtTlvRbEcjJfZnJtIsIxCf+przxnUOutIF4P0ojnd2
         GsHaRLAwDnJq+Pk0JyrYmdgK8DbiW9jkI7nXngC25kClfUxoe9WhZSKEpTnfwOH/901s
         oLx2s0jOz7vZ63t7Qi94AkqsOE01lRZUjkOFc2B3j9X0GKgG+6axe0uuTzBDSCvzcWdP
         JW7dTErmGpwAohRMappMWD/NzrpofJYF3/oWz1A5RH5ie8YeLvG0ygFOYLIq3yVPWEhH
         1mWg==
X-Gm-Message-State: AOJu0YxW3hef19MOdBq8ykMg//NFP71Rnb4y0CL1QZ69TztjRG5NJB9x
	n9FPQYBNwjTwAcUkEzdVluDvv1u2CJgKr+V4EM4jCtjEED6gREtVvr1p
X-Gm-Gg: ATEYQzwaRXB5C4Xl0z0Bv4eumxZehTJnobh+YYyxtovTEBuIP75fn61ewg7MP4iysZ6
	PlKj4m/dULC9A6r6BQnhS0wp2mqGT/Ar+tMCumcIWfHbJTFlzxmNnEiofA1Em4ln31KU0t7tekS
	P8z3Vpd/win8QtGAcvzi5cFh04kVjNPSCLuAeVvjiHvFBntCeLvAGCp0vQ60srvmzEsAYgZmLlp
	fxdmcbB9wz9/Wo0TJwg7DnEpefZJPmPpDzHBLxZnJYd2nI4kieMZCvvAUSKkPNY/BdHsPHW6Fxl
	7Ji837X+hFb0KvL9Czn1RjbI5e7POV6ImfDzSaVEAwY6GzUhY1hDFjb4OOgzgxbZcZW0h4dnG5I
	C4tvXYGzQQYRFbMURMEYWG/SSHCLvl3cvz6C61j8YBKIP/2cPBWeMPX8xi+h3O1XFCG08dbE3dm
	6zJSRcdsZvEBHHF0mzPesfaj/d79vkPvOqp5sqxGejqvLHjKNblA==
X-Received: by 2002:a05:6214:5c47:b0:899:e567:f04d with SMTP id 6a1803df08f44-89c859d08cfmr62371766d6.11.1774029127597;
        Fri, 20 Mar 2026 10:52:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c85335771sm23656696d6.30.2026.03.20.10.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 10:52:06 -0700 (PDT)
Message-ID: <d3fd0282-da59-474c-bc42-0497d87e67ec@gmail.com>
Date: Fri, 20 Mar 2026 10:52:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/335] 6.18.19-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260318122621.714862892@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260318122621.714862892@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/26 05:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 335 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Mar 2026 12:25:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
