Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795210387;
	b=EShRaCC0RmXdBAt5s75vxNO4JdSQctO4eLgpPzjw5TNIk/3R8hGIq7JQKb1iutfLG9/T
	 yzJY2cLSLoaNwamBJoxTauFb4djvg9RShNWs2knRtQNY5aQRw/9znHyENgUWltp3fHNtP
	 rmO0PpBfzcDbac0GiT+c19IACuCLFkj8usZv767xmsYiLupKtT0sHQv/n0DGFJ4jvm7gJ
	 D2nv/QqOGMco8P+jleBp6KyJuBhkOkVQz7TYokZp3pDEljmWAdCFyvMK63Cgqk075M58d
	 P0hPUxVg1RP5wHUtHyvYeIokwHA+KNiY0mryvUnfBMvuAwkkn2n9QudDz4pCbWVzK0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795210387;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=yPxtvilWekrlhitAc6HbDf16H9GXc7cY0OGz5zHiX+8=;
	b=RhYEm6hzGXLaE52T4D5C6MKC5pwtCxPPMt6uJ7wwawnHsA8KhQt1hX3vRkeNc2SNXzg9
	 uwg6LhWM93qpSxOgqSPmugyBONVIkFg17p9ejzwWukj4PQh8XgEF6mHQJ5uOgzyguP9QC
	 IT8pofXg+mi9AlSOTCmBzQu12V45q5zNa9gXbpIdIPnDjXqEWgxEUimwxrGt9wC7fTq+T
	 Os4tIgxAdAfnzof5zp/WWLCfPyEw7mHJ5DSu5n0IkNoeA7fZ7N5uGA+fhzb/zZIVpsjiV
	 H01Gx5bNkelMtRlFr6tgFcenle6KzvPKtayBSi6qZWk7sX0DE9MxsrT/NgwNpKnbKdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ea2UIMQ7;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92642606A68B
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 21:32:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92642606A68B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ea2UIMQ7
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-38644aedba1so1288610eec.0
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 13:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795210377; x=1795815177; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yPxtvilWekrlhitAc6HbDf16H9GXc7cY0OGz5zHiX+8=;
        b=ea2UIMQ7376uocjSFx0d5Yw+Bq+vNCS86B8iXMSbJaQ8Sf3OpmUYS4QGVCfbVyym2I
         XxVw2mcLizDYt8pW0m7VJWNGhvOpGE0kwTtpDrI7qLCX76g0Up/wVXGsIRry9rsMCPlJ
         rE68+XD1/FS/OkaoH10ypvA6ZT/FvosVXwYeE/5dYJ6NNkEmilI3afxTj0yBI8/weVQq
         tdc8cyTNX73wrY38eqfNZS8YmbDjQ3dLXxDkrWHPIoIetyupx6PVyvxGMWCqSfMGBhwc
         Qk5tigWNpyuNmTfLKrbuoTFfeosKsUNPL+LYZn6cAoyD+CWo3/syVFJqk6IOLAHFRO1Z
         LN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795210377; x=1795815177;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yPxtvilWekrlhitAc6HbDf16H9GXc7cY0OGz5zHiX+8=;
        b=F75K/WnHFWmMB10cmxzvU7Ys6XYQA6aReLoY68d6sN1fiBG1hC8N9rIOrmWDhMcu7K
         tGzbbyUje0BDdc+W2aW36OaUwq/gnuj0m/dlnrYi6pJRKR4xolkQqOeXDDHBfgITD0vp
         wbKTexb16QdPLxsU7ESsc9rwdCDmeiTHD7iuY4ToRf2h1EwEgTWzD3jcvXn0/G56RaWU
         ouOR+FZXBk4IFovxUkGwkCee8LiD5bwKkxf+BMJzYDvx5eTLeg332wVw8dIJoQxRIYdf
         XOmQahGogFdXn1CmO5cUpL52+MIQjubGg5rUDKbDiV8WPqWObiZzzZFJaA0MwBD38bb2
         jMYw==
X-Gm-Message-State: APuU4Z9crCgj1MIOPkOJgs8t7UqGP0oQ9Q9utjUnvujdeU4a1zB8YwnK
	1cQle4mcn/576FN1HRiHt5Ml9XN8WpG4AkdjV5A+LYBAHyFaFkzpuFXj
X-Gm-Gg: AZFdTZeMLeFw6OAh3LIdK37BF+VJIKuGs7zPtFbu/buaX057z6Wj6tBCvNQo1bRSd+v
	hrjDRE2r7Q5B9Db/9yYyqQdq2fDt33HEhXgR0qkwXI0hnPTdCLdCB0ldJRe5r4hw8RJvgqT16Ku
	5r/z3Cha29w5NHl0f8s6dIgVNQcOFNzacW9E0C/9EU8VYvj57X5Rv+o8+8RFGU6BsijAk9/2XoD
	pEZ7VRFZwo0gryGiqzg0CbcB328o3R7Nq3UWZrz61mIjD0ecFAggiJ4uj1WhGlRLOzmJaA517vF
	M9pMuSbyZRbvuGv0GlSYWuFn0HkzH6Zy44ASNgpjofU+QeyhoOOlIdKdZTCk9ygJ7hZg7RTtn/z
	Mr0XpValiPHlAtB7wFXd1hbGk28aghkYTjIubMgTR2JUeltaUKu1v1DHkeGtNoVhSdse29T4w8O
	hn7Tv9zIvekGBKWAMCWYAJCTR22OiE5Dl2oOJ9FQiL/UXYboU+3pNgxBOzoeP3cjze92UxPlREh
	2tggAFHmBPA/iDYHbKhwmnf3SKrRnTA7kfuTpVGCAwASJkXtEBBjM//UUr/Sq/iWu+bpQ9F1Oqg
	SvWUIdwRo8zf7vH4EtsClLfGppfTkV/SVthhmwx3ipRWN4SaVFrN9iTA
X-Received: by 2002:a05:693c:4015:b0:383:5eb8:d284 with SMTP id 5a478bee46e88-38570845980mr4272504eec.33.1795210376751;
        Fri, 20 Nov 2026 13:32:56 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e96bdsm10283664eec.7.2026.11.20.13.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 13:32:55 -0800 (PST)
Message-ID: <b4ad1591-28bb-4431-a206-de8069b30b00@gmail.com>
Date: Fri, 20 Nov 2026 13:32:53 -0800
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
Subject: Re: [PATCH 6.1 0000/2812] 6.1.193-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261120055200.707545519@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261120055200.707545519@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 21:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.193 release.
> There are 2812 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.193-rc2.gz
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
