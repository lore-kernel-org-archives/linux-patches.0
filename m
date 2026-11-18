Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028986;
	b=AqM98zqXnY0lR6IdA6q3UwvJLtQU1Gep1HDzyCgQ57AGkKUXAnKu6j9H4b+gQpCquIQX
	 VBnJcHJJQkLGfMEzNuPTq+fTLnRpghW0KbVVKUVUCAnj6mfiCqkWWcjZJKq5BlBhvC7q2
	 wlB6nM/JFTauGz3kvbDy3mHTqyiUEZg8B16IeFjpsAme14RH5Iy/rg5/PGvLZXKoTiRNi
	 814tD2CDJPkHxadoZecZiQAHjIHI8x0usoe0mbhtFIxj3Prga5ur3kVPT5RMUPwd8sMDn
	 X/QibakegUhrwObKQbXyFJODtL3nC/vSsXkNTZ7uj+8AFuVmW9fELXVhc6npmrJpIZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028986;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=brrMobb22TVB7XAlElAFp7KL45XZpi3Q5Uug9IjkUY8=;
	b=JaPxyz15R9CFJWkdt3WYbE3jnj7W3u+iXeIvxa0BKwXdPXfzwdHSeEGKJvH1PKaMqaZv
	 oZpoFZ4rsVruciwWkjCJGMwdcAzOC5DXOZQF4em5hb8cwyVV7rb8G/ptorccI4AaY6zJW
	 rWOFxIpKbLKWq3rJ5IOEM1dZW1xi7hZcnf+JwD3JL2Cea4FOoXLjR6PG8cIXyiX3W/PJp
	 zNPjZ1/HZIkmW1sHkO31d13NfyP6XT29XFOmhj6J8oL0zkbByBy+Eu9Q+aP8jWC6AmKAz
	 J6ESiFQ740PVCzcFI0P3iNBcp2cVBMThRtTZaDW26sVylO1SI+28UJjeH/Wj6huL6lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rNDOo1ox;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AE9606A31C
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81AE9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rNDOo1ox
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a070781f63so787959b3a.1
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 11:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795028986; x=1795633786; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=brrMobb22TVB7XAlElAFp7KL45XZpi3Q5Uug9IjkUY8=;
        b=rNDOo1ox4PCzvagK6n+7N2NKYXhWJxSPjbCe56KcfVk7QEH3GZ3pteBrqTUa9rCY4o
         xp+QrTmzd5do/KjvsCWVTohy78LSNm7bAdV4VGIHsfX3NtDrM4WWaI4Dt5cSyzQobSpf
         BbYyRLryDeWFd/sOaThefA7NH9hbJK1nscxVlNWi2aNRnYaiaV5EsB66a/ZR2fiaFSHn
         amMnK0i4Qht9cHZBDMI1UXPjcn1oXvpoiN4IAr6dUbBATfQab20hJGu9UTGxZOgwVqQv
         HMWc2Ii2++LKWC3Vq7d8E4F6nMCTF0an+8PQZbTY0l5IKXGgYNmPrZqpOEHo+szXB5S3
         nEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795028986; x=1795633786;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=brrMobb22TVB7XAlElAFp7KL45XZpi3Q5Uug9IjkUY8=;
        b=bIww7F0sCzf+k3EOvdmaO/hN9B72yN+dkF8BhK0tmWkyChQd6B3OKT8t2Ze/Wqx8XT
         hjsK7+MBqp25X2k7nbIwLLxLqXOvWqj9OjyJrIYaC+tGYQ6IpeYGi1Ilinmc7hfeZzI/
         QalzaO3PmD6/pI+8+qm+9Z0XwpgEi/8lYwUe5usIJxIRHrh6ZL28Jz74NSuAEmV7a0sN
         eCdpek+bHQGX7/s14TncLxM39md8aVsWQ3E+XOP/9nm5K++Ne/0JpPXpq2eQqoOxUZH5
         2WotlgffWdrv3qDUwfobmLMmInMRGPYOI362AsMNOSUCe87fgpnpTZsDJEAUe7jvQ6DX
         wC/A==
X-Gm-Message-State: APuU4Z+1YwFwWvBkd5YsqZkDSvBJboKqj220OwzDk+12gqEKZQ+Ku8At
	E5QeBQ7lv/SBfj6atn1od6rT5pVRk/FVwcShxR7rGnmc9mNCo5M+ZN+N
X-Gm-Gg: AYBFou19EHWv1zeKU3Cx6/GESI0IzNr1msn6xLSKLG5A/uHc1n8H+tyOIjJfkbUfPcf
	K0kIhRQvsd+Y1tQCsvjURQ43zpRZVzqxsiF/wguh+7R8nrr+D+W4lrB5UOHkHlQR76B/xExon/L
	jEYMjwhI9XUmbg/JqujgZSZQxh9XEGTFJRYfPgiKcm4DADxN8TRtty4QmEcQvwtu9GhN/j444/I
	mcWvgF+fy550xrWH+vbUPeZ18SP681DhfS0J0H/vclUYv6nUdrZ1E4Ex2nzPJAi84hSLJf8/jD2
	poSb9/hwyfpTafIaGs77VxjlUh2kUi7N3zgU62Q2ECzCXlCM+acp5nzYZ5HTMjFcGrH8Fom8pww
	KOXV3Q4qpOJf+uBwvur8Nqklw+E1ksh3YYzWQlQJihYtlRbN+UQpUyIeo3HZiFUvUU3Vhud4OQO
	ASDFqu9Av5Cslx1BCGVGMt2+OWLgKRJfuh6bcasuDgt3rz0tzBVxTlFD2marsnblQU71CaRmB0d
	xLO6yMo4aQPqAnr84bb5Vncu0O0YTj9V+2Daa5ByVSGQ6ErDDF3g03Vszk7R2j2IgIt3PjiI1pB
	r0C2/u4vWo9jpBjB/jGj1qjvidUsVZUVL17GtuYZ1/zcGZ8TalG/xJyz
X-Received: by 2002:a05:6a21:32a0:b0:3f5:ef59:3aaa with SMTP id adf61e73a8af0-3fe970fafc7mr3891623637.16.1795028985604;
        Wed, 18 Nov 2026 11:09:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde53462820sm453966a12.10.2026.11.18.11.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 11:09:44 -0800 (PST)
Message-ID: <42cce255-f459-4386-a763-ff46e77d5f6f@gmail.com>
Date: Wed, 18 Nov 2026 11:09:42 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 0000/1848] 5.10.275-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261118145911.150052362@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 06:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.275 release.
> There are 1848 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.275-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

util/jitdump.c: In function 'jr_entry_pid':
util/jitdump.c:416:31: error: 'struct nsinfo' has no member named 'in_pidns'
   416 |         if (jd->nsi && jd->nsi->in_pidns)
       |                               ^~
util/jitdump.c: In function 'jr_entry_tid':
util/jitdump.c:423:31: error: 'struct nsinfo' has no member named 'in_pidns'
   423 |         if (jd->nsi && jd->nsi->in_pidns)
       |                               ^~

which is coming from 428d7a722786 ("perf inject jit: Add namespaces 
support") we need to also back port 2b51c71be599 ("perf namespaces: Add 
'in_pidns' to nsinfo struct") as a dependency.
-- 
Florian
