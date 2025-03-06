Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699FA25D53F
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 18:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741284271; cv=none; b=TxVSAUP9F3jf4inieXrAs2StC4KO+LdA7HxIWYKeUzrN6gi8WOyn/q33nGnQWfWeiLwqH7aQN+NvAu5pgGtmZJ4GqwSnZfMSDgTXC0hKcLz4zzK6QAKX1WOnxSVInZ17FJmwFbpQ1lAgCMohPBfFI3pBvknvvA4zxdhLrMmYUmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741284271; c=relaxed/simple;
	bh=4YSM/EJdFgswIm6yxDCr+/iyOSjb1lnmdeFlJsPCDmY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZmnwpRbS+4XoOWZD3Mkr18rmY//Te69ZGxIME1FwG5YaOte31kEhZaA0IcZqJ85E+UGvL4iVHhMGZvEU68Ea8n7AdPUyB0hdGKmPUy0hVYXw+HtZjD1842onQDPmi7HGbpqyNJG7XxZ2Vjjw4kG6HJ8XRp3eXRhq+XQe/d1CR+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fEMqm378; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fEMqm378"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-2bcdf5ea8faso592988fac.2
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 10:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741284269; x=1741889069; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=z2u4ZrmShZSJJKEHUFNA9BhL2Usd8rm+GOTZPlUQHBs=;
        b=fEMqm378Qtv4+c8oGlze/zJtp0Xk3XvfvwruaVX/Aqf809KgxMSgXgXE2BW1t/GAw0
         QDQJyFruXfLnS7dj2Kf1IMF0+p9EzUgJpS+RcHPUQDjEYY9DPK+i5ayxHzEVqvr5KNdU
         vS6LICm9CxozXWNpshSh/8htwUQW/pkRvc8J1qt3/gLcn2i9PZ8PkHOLXldjgawDRA/d
         qSXBEFV1N3eBVdG+fBRrbagcpnrzeomTV/6uNNpoZOOsRh51eKFSe72OUCkUqwB0/cgO
         tOapiy5k8CLr06aNDzX2nGOV1oTJuBVEpBg4ToNiNjkpcCG2MlCekJbDn/wkAwIhEsl3
         1HXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741284269; x=1741889069;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z2u4ZrmShZSJJKEHUFNA9BhL2Usd8rm+GOTZPlUQHBs=;
        b=q5xIkh7l9Kv9I0yZz06DqpbvJMYLlW/7Sa06ehJFa+HlaVxLjrowcZ2wfE40zUBUcR
         y1xqL3SNLQqbZrQ3GO+qdHM+BH7UeWV6eXzlNs4zwpawlWufyakGRstmKFVSSBjYQZtd
         oiOZalIrL1oAYji3n+a8TyQf9REgNrUZVQEBwtLdkzzU8Fezct72xcVJ9UpYcPfTrCIT
         GzWp7lryCnOJflYqjbPAf9yZ5x4wvhfDqJEc1vyCKsAxS6pLm6lnBPf9+DK9HlT6yFgZ
         HFIGsEce6f1365Zcv7GbuwHQRZQLaq1PGxdUxa9G1xG6oB4rjWFwtGBQXKnueiOUcGyT
         AIYA==
X-Gm-Message-State: AOJu0YyEXjIndQFdZPl0hlvqwgng//kTBzSLFYteUNpxRnFxyLKegpFx
	nlm3tltwzVfnRULiO5YJ9BJWEYwzXScFn+BRSnHApPtFhvmqcs3u
X-Gm-Gg: ASbGnctn2gfQ84i1XLenDmb+U1E9xApwX1Le53XHel9okeM51YL4Tx73+ElkipBkti2
	iXfXug00zUOdrRemsieBj7DM8xPHAvrRRxCXtgqythzCRmkYdzjwnBi0rNVgBQLHKk2xrupG/i5
	tJzgRDFMBlLYtrn4KPwDm6JLS3yPFJzSME02xXK8WheC47nMVhIkgSDf1uaJ6OszBEOmwwsIgXn
	tfg5+7/6WFmGfWQRZl8UpfDuYgSTzcoBHnwO9hD2anJCghOsBOw8fg1tBuDISLEo+jtMeFmKZXs
	21H6IJLFVTF+VzW7Tr2/fT6e4657+n1b4ZkhmeV9L++bt7AyawcEjKOk3mLjOs/qs0h93gsS
X-Google-Smtp-Source: AGHT+IG2UfKn9ZmqXgVtJDba3qPnm26iC89ikqVa+58/kExfueQz/E47yQKnZht2YekA823NpG6jGA==
X-Received: by 2002:a05:6871:8005:b0:29e:3921:b1ea with SMTP id 586e51a60fabf-2c26142a194mr115079fac.30.1741284269317;
        Thu, 06 Mar 2025 10:04:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72a2dbc3457sm337298a34.60.2025.03.06.10.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 10:04:28 -0800 (PST)
Message-ID: <7d3401cf-403f-4e9c-b30c-6da462ed8b6f@gmail.com>
Date: Thu, 6 Mar 2025 10:04:22 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/161] 6.1.130-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250306151414.484343862@linuxfoundation.org>
Content-Language: en-US
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250306151414.484343862@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/6/2025 7:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.130 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.130-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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


