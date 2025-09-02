Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635D4310654
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 17:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756833065; cv=none; b=KNPxatmXUuWr9M41beA/u7+nY0mfrqKEEm4x3SkBHoWB4wiKY8mA250qKMMqZTbEPEQWsTQqnfddwrUo89n9miixx21HBRB2BKFwIhXJqjbZ1o68OvjC7+zLH6xSZA0lyXKMXWpfY3BBrctb1nGxTIhJw3O8I6sfH53Fd1z+c+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756833065; c=relaxed/simple;
	bh=DrCyuQEf6glI7LfRJAuaKNwC1GTQke6K7aTulwZMIX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ErhfFOCYq2jnLkacduX+TLvuRdP+NH+W4iLaccMnpOusrybjc1JPjPRFUorZS2BZQs1oOUEczh82evFIOsCPcziXD4j7/+NHZT3/O0WLe7EdsoEY9Fx3keU6iyNc2tTmzjh9JID2kAaTlslhR5KveEr4lSRyT8wiQxsryafnRlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXc2H9hd; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXc2H9hd"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7f8ea864d63so544697085a.0
        for <patches@lists.linux.dev>; Tue, 02 Sep 2025 10:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756833063; x=1757437863; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oBHtVSFw10dHsem95fb/g6IdGjhm6pmkppakycR4TZE=;
        b=nXc2H9hdrFIJRGTF16nU8iy7BzZo3wQjfDD94Du05tIzU+VxN8J26nZfL2Xh+g2lvY
         MFvH8FZZVcA2jcS9luyJGaiJSy+C1CXGE83v4DCYtqwElwE5UsVNs3XG/xQrKD9nI6wr
         RplQ8IewOXBf0y93gGpljUoFUeIX9xUbg9kSaevLbIJRFcXccHqOlJRagE5AFe1hCDVV
         Ssrw/+eao6utYQrRCUoEWUZJJsahbvgQ8Swio3uGzOO8+K938BLwSYWfUIYZaidzXhYe
         gBV75k7seKtfABVpz6RtzlUPhwhkW8Ek/UIUScBEaGqd8vq4vusCe+OSbTYkFQB0FSiH
         3xNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756833063; x=1757437863;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oBHtVSFw10dHsem95fb/g6IdGjhm6pmkppakycR4TZE=;
        b=PI7y8yGcBuASiS4cLZEG/KHFwdufiQFx1T9cBbE4XDKAEsp55fxlYZ9gZbrOFNnfRE
         QtAFSZmsCndoFYWNSzZEvBoNBKQ1wjGZda8cMSsJmXtMigHJHbn9FlFPm6MdHkzbPYqm
         l3X/SFfUZPounpgrn7h/lz4abLP2mV1S/fwSL8wGYSm/8Cqf7CmleDoz4/6hylhDgDmO
         LhK6rctZZxpkWAYbkAU76o9fQsw9+V9BovBHNyknfwov77MwokyKYrtxtrqayBiw3r1r
         juRJdckjotNexfBsjJ9k3SRoqVpkJF4pyM/r+pvQxSr3tk3/fi7mtRUROM2VDLIzFVZE
         My2w==
X-Gm-Message-State: AOJu0YwYW0BKHPo90gqFvrDCndxV0OPhoewx3uYmQ5T9UA0voorS6whH
	p0B4U3BV4NfaNZi/CwKaV/KyCSqIKFR8NpuOcUHg0/fv13GxqhNhir+t
X-Gm-Gg: ASbGncu+c3dymiQ79PBQHyqPJ6Qj60ATx1Ac0LqyOORYRHzfKnkBOSoav6XSqcoveJ1
	8cr3RVQZSTG/Q45zfWJMzIayo4mno9KyWgEzG6hvj0PrCvwszp/f7fsgxZ19q5kBAlqzapWN1HD
	OXJC9yXy8RfyyJlq0rzfnlAS5NhUyutQZzkpBoRwhFOKm3D/bJj8H08L7o69XmiunNqWLqP8U0P
	zn+wKmFppToHyWzWtV8W9DZ2Lr2lResVGLD8aSwpBUD5scRLQHjwgRNXIrFpfdPlCTtF+KNR0Yl
	9m4rg8UT1D7vnEPTVrYuI+ZFL/2ytawqd4SESWbMv14GONsfcA9Xr4S/qGpfG1xefB/o8CyNugc
	BrHxnvMYGXYIU28zaffCz8jIcvm+LQZzUbAcQ5u6u6UgN9gXzrA==
X-Google-Smtp-Source: AGHT+IHnCSeufqhOHInLwoqV6gJLxiDNg3lrNlsEFOrhrs3RYhLLhW7CKfH3dJjBuOOkx+9jhFc8EA==
X-Received: by 2002:a05:620a:1710:b0:809:db70:b415 with SMTP id af79cd13be357-809db70b47dmr80053485a.24.1756833062936;
        Tue, 02 Sep 2025 10:11:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8069d6b056dsm167152785a.68.2025.09.02.10.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 10:11:01 -0700 (PDT)
Message-ID: <109893d0-2df3-4a60-b77b-2be47ac605ae@gmail.com>
Date: Tue, 2 Sep 2025 10:10:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/23] 5.4.298-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250902131924.720400762@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/25 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.298 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.298-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
