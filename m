Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11C01C5489
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 07:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745998791; cv=none; b=Qf4rf/xYAyCQdSMjRtQ++k/JIfOWSsoTsYjl09o2iK+eVT/9oMKY6cvpX0Cfr6zsGetPfZWrtnxo7pfP2LjPiIN534TDJ5jkV1ZZrZ1Fxue6gN2IakV38dO3n+PARdBmBW3FRqGN4g7R+DeP+ipZ9LABlzyPSGo7ofYIn1qwdzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745998791; c=relaxed/simple;
	bh=RYF5rT5SGXiuiOMM3oZfVuad7Ga744mi0LsZrurPLlo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=krMdjZHC3dYeH6AixTLO37hwDwG+n0lcwMajyWWMOIbs/osJ9wIlOx1CeQ6Id+OGjtjF4+iMW61/CzGqECZjlXIH9mwhxQYzbqwC2I+9bekFK+/Xy6EPkg+1CXU+EmWaOgxdzdSMYnTLDAw3Zq/VYRpCnBeB4gjrfLlrAdWJmjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SBDSP98y; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SBDSP98y"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cebe06e9eso46053235e9.3
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 00:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745998788; x=1746603588; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5U9OMJXkSPz8hKC+syIhe+oLvZq6aylg9p+TfyNHAYs=;
        b=SBDSP98y7wPtreg0PrPo0l7MO074IspczXlLPkcB+7cmrxAn3WVFzl4Zpljg8sJY//
         E1ycbss39GrCjMgvB5u8EzTUCju7Dp71XBPxluCvnJhPf9232J2c55ZJmSGjEHW/4NDJ
         XswhTERZKbPq0eYSL1wXG3ucH8SZL8VTj00uGRIAnnnYwKThrUBVz0A7eT3XKhvis6pT
         acVymTsKgDYrHAVnF7Lnt1u0YqB4lxlx0tx7ld4r+OPG5LvV8EIXQXEnehA1kTFlylF9
         j3EbaD5r6N+WU+qRRYjxncv3mFlF9H4QTXex1dXNRqs867aWDzY/kC1kGsSjeoKoLruX
         76ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745998788; x=1746603588;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5U9OMJXkSPz8hKC+syIhe+oLvZq6aylg9p+TfyNHAYs=;
        b=Ud8ZM/c87+N9LmRvdbt1M+WLdwcvD4EdTxh7X/s+hZYsEkGStxXr1D+TRfy+EWLi0S
         64YE0sKT7CSBD2Kru5u1C9vCWldxdFml+wrE7aVSjUgdVCE0GnEVkL2lSTZAz/G35+Wm
         IOFJ98/nzxFiBgKP7A8hYke2fydcKR3iRpTj5dswJizuKDQ+QKDiDovjdw/dgB+mgaH4
         8PcKh0CYGjlDYMYwN/Jj7kOEP+wBQ8utfrr9qR7Suqa7LlIFg5E+I36UaRbfz34HihM5
         Jiqi/orm4hjiJ3+BKsKm4uxKyzAkgfWmzyQvvnlq2lE01fXgkdVx+tYEyLoWb2CR3t6V
         RxYw==
X-Forwarded-Encrypted: i=1; AJvYcCU3tACs8n4LdmdZoUKEuexdXBCUkzvgJ4XHc+/U3vPShPzWgpivdYQ3RaHezNGPcpvpuAtbGdJU@lists.linux.dev
X-Gm-Message-State: AOJu0YxhhYLNuznhEkiNl9jaNPtoxG7C+51SHdSV+OUkZP9OzDguMz12
	G9o+zvVufJvlbrTIEe7154zEkUVthTwItbmwZ5Cu6jr63lHN2ht+UH6pdGLjo/rvGrOc7L3zc4T
	qiSY=
X-Gm-Gg: ASbGncvCWljBfbgB0vDx6OlPiSeBXd0P0TlwsVIfQ1UZU8B/A0hRdWwroguZdGm5DPA
	u252ohKGACBWG1RzaYzTZK0E/QeA60B/YsfUlrSIpIWE9vWJ2fWUKgduFyuBvdCUW6Sa/kyndzA
	DOp+xJVWrWRtutxzTqIQx+GO+vjhWI8zA14Xs14YG+brSGS5K6GKyWsYJfBf2UGBFWPCPNOuv4M
	8vqxElkfvUHzB6LxPRfO+JZW9lzljWx+P0AH4IRBXEgZ62Vi4NuWn5yW6rCmgtuXDtQ3Li2QYUd
	69Pr8Ohs8ca78/+KIXkHBLGaTTMVlEMhJ2GnxYgfhSfkGy6sj6dnKD5hfu6he7qGZdSU/sHIvX2
	L5tBLb7s=
X-Google-Smtp-Source: AGHT+IE8jp0ZjUVoh7f9msS1Shj+zFFjpix/VROzqHbjQs2YUPeE4capqjHRAxR03y+nyYOapSyDRw==
X-Received: by 2002:a05:600c:500a:b0:43b:d0fe:b8ac with SMTP id 5b1f17b1804b1-441b2695e64mr12959955e9.30.1745998788203;
        Wed, 30 Apr 2025 00:39:48 -0700 (PDT)
Received: from ?IPV6:2001:a61:13c6:eb01:e359:8d71:4b9a:921f? ([2001:a61:13c6:eb01:e359:8d71:4b9a:921f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2ba4b10sm14125645e9.16.2025.04.30.00.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 00:39:47 -0700 (PDT)
Message-ID: <41bc286e-6e6b-4ae8-ad6a-3bdf56cd172b@suse.com>
Date: Wed, 30 Apr 2025 09:39:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: dc395x: Remove leftover if statement in reselect()
To: Finn Thain <fthain@linux-m68k.org>, Nathan Chancellor <nathan@kernel.org>
Cc: Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Colin Ian King <colin.i.king@gmail.com>, linux-scsi@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
References: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org>
 <91ba6cf2-ca95-1ebe-837f-ecc89f547ea2@linux-m68k.org>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <91ba6cf2-ca95-1ebe-837f-ecc89f547ea2@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 30.04.25 03:36, Finn Thain wrote:
> 
> On Tue, 29 Apr 2025, Nathan Chancellor wrote:
> 
>> This if statement only existed for a debugging print but it was not
>> removed with the debugging print in a recent cleanup
> 
> The patch you called "cleanup" has a "fixes" tag. Strange.
> 
> I think it's unreasonable to refer to a patch which alters object code as
> "cleanup".

Hi,

yes, I was unsure about terminology used for code that is by default not
compiled, but would not compile if the attempt is made to compile it.

	Regards
		Oliver

