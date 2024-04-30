Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3607172BA5
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495506; cv=none; b=j/WwvTAoiUhShAI5knnar3CVy2wl0dQfjoGwGYOU4h7BqU7T2iVT+iVF/3tN24deMzHbSaUeSh/ffe8GZrPqLWwCjrzXsHqZkicTmwsi7Ers10MYaDw8gKuecALmiyy+zMMSQvyYUXY7QuBpdeigoZmvvQV+9JtM5W7xVjdU380=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495506; c=relaxed/simple;
	bh=69YzY+oNz0oBhurbxY/U32Ep8blappIwZ3ROTALilHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YV0tdgEa6uc10gSM0sZ5l7PTQrbmGhURQorY3M7MsRNGCWTUSCS9TIlt9a94zDgcvFlOGKHtwqjpX7xRyUqAxdewk7bAY+4UPO8i3G4suOLPxCpO4dddHlJc3U2AlJdC+dybxd4CtJa2qUz6SG441sDJw2Dy7sOQlO1IkCBHYUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K5ePppGD; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K5ePppGD"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-434d0f63c31so37457071cf.1
        for <patches@lists.linux.dev>; Tue, 30 Apr 2024 09:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714495504; x=1715100304; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NELBX3OSntfqIge688LAqdr7KW7zfbH4yVTfJ/9yBM0=;
        b=K5ePppGDJE4rUy7H2ByxZVqsem5kOGB2Lpy5KyCKfUCxrlSpESxYtBxb40GttQrh74
         626mtYO28N6TkyllFTCPfBxmsfE9HAbNa4Qna3HCpGnVJGjwqIaGhKPyz54GHGdXth+h
         MI0ZPnFVnTbUHzlvLYztAEnDhl2O9lDTSvenDq7pnuFl+MFQvESURLXJ87Mjo40hMS/S
         R79561PrhlO0RypLfKkq/ATwc1KD/TxxcbuwbFJpZchv/s2+zfqTKiJyc6Dxar62072/
         HWknoH93fO6aZ+ph/lae22ANrXIV70OcGz8o49xpB8WHGSqJcA6G0aBZO6HXMI8nSSz0
         ZZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714495504; x=1715100304;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NELBX3OSntfqIge688LAqdr7KW7zfbH4yVTfJ/9yBM0=;
        b=mJwagEVA2g5+gQYyEreFFlQ/63FhYU7/gpUdCnYZd004x4Huew6pEHF43xOWW9o957
         obUVjjThSc2WP7wjl2g18GZAy3SvfKBBtTaQ/0jNiuzuv0DYYqkhgGyyAh4AL2/qXAPS
         0SZpGeHEuJUKyBjVtJ8nUCvbsB7NP4svJdo/K8foNm17E76FLAQKRJasW8AC/RKXHEJP
         9fie0APhssBS38kjc8t9ufVlWZWt6THrk7QCLihgMzp+wNIHg4ue47i0yJKEHiZZCriP
         cnGwgteFcj4HHU0PBQ+Hw3xWpWwL+I5HzWcf/0NsNiZ87LKl9q295mNyBbPCJmvQxkX1
         WqQg==
X-Gm-Message-State: AOJu0Yx6CsefeS63l1DyRPAzrc8w9iyZavcXhsKhmy+Ko3VVm5VP+egr
	FrGE7MJdBO2DhQIMblB022k0k39LTXVx+p3KYHx56XtrfUtjNA38
X-Google-Smtp-Source: AGHT+IHO2tKl6jwReUrfC/rUmUzmIxXqPqCEPnAY+LYFQy06Tz7wjy+uU7qdDtw6UfY7bjt1sCmwrQ==
X-Received: by 2002:ac8:57d5:0:b0:43a:fa90:edb6 with SMTP id w21-20020ac857d5000000b0043afa90edb6mr4111926qta.60.1714495503545;
        Tue, 30 Apr 2024 09:45:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bp19-20020a05622a1b9300b0043c6c361ca4sm296153qtb.77.2024.04.30.09.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 09:45:02 -0700 (PDT)
Message-ID: <d9c5df85-3af9-4301-8dcd-a2a26c4d8121@gmail.com>
Date: Tue, 30 Apr 2024 09:44:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/106] 5.4.275-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240430134021.555330198@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240430134021.555330198@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 06:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.275 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 13:40:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.275-rc2.gz
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

