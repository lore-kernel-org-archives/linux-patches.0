Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1C82E5B08
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 17:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995621; cv=none; b=OMdGaT/h2k7dvpg74bNwECspj19hTRHKdh3LNdzVznmb+RNvAKDy7TaCvmIbs+K1UkHQBAg07BQ5q97DcHZkFZxSwAIZyj87Wx1XXTJa0y921YPmN4Us8jXm9yNPo3cBPtizUZTU3Rj7tDpg/Qe4A8LEIj6TWRzFX1POLwA0pcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995621; c=relaxed/simple;
	bh=aP/mRBWjQBJMx96i5jdeiSPcs1Fo3UqoRHciORi0Ir4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H1ZFTNY9P8kv7hY87FqwcjmZxpmkfyM1hVqkuVKwoozCB3E1ZzpnwcKWS/nAw/3KgIWpPVn5p//G+l3O8Wq7l5SDVQ+WozFzslyQ8Yjzl3tkyJzPRDi9GDoogyXV60Ns0frarSpakubWHA0XpeWpBi5mFNg59zd3W8O2+x1LQu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l1HMoskf; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l1HMoskf"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-31a93a4b399so126350a91.0
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 10:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751995619; x=1752600419; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8qqe29PKJbbQlxAbGgIvXL1kKmgnDPtfcexo6IK8E3Y=;
        b=l1HMoskfpPwZPNT4kxp5ldYW1Ygyxxb29p2OQyBrHxYvqut8qQYV+ntYIZe0geA3CA
         1hVoLfYIPWdmxNwLYRyU/Lrc/EmVyK02nLu4dE/6KpzGYIpTv7ExU0LEZeRuxwZ7IOGP
         UAz4HPU3FDC85linCHPtQn0A4ktLpu4bgzU8OV9kVjBcuY6IiD+ACO+s4XhiJGnxRK2w
         5gJ1qjBmkgBIrMlgFdHZnEdXLSae1u2CwFI2L5PgPHroHjQVZ8Nnf8bGCZ9Rs2ie8olp
         IXL9/N+MYwlutVE5yi33tdsxhBlmJtDk40GSSbYdx3KbGd17rQYlpCLwqYj1MZLIPb2O
         XLuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751995619; x=1752600419;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qqe29PKJbbQlxAbGgIvXL1kKmgnDPtfcexo6IK8E3Y=;
        b=IEdub1yz3FDWH4qnBJRKxWCWDhwiY5ULLs0hPZrtz53GreuuciHKG26AsW/wqP/nEY
         hpKxFhodbDfxJ0/+I7TWgF9J6R2AFcjQbDDtEE+FxebdXP5yUUCB1H+NMEBfYR2KEBOM
         9JQpbXPiYQoI8LM+/03aAu1a35CcK/6XVyJ0x0GMIqA9WsSrGmO3dQ5JPFdn682ee6jA
         6rVWtnj4UabeKRzWIN0ZRIOJfRG3Sm8mopBmdzw5TPLP+QDvFyAKmczVShGzDqDuA23a
         UHGm+sPzyYBRGBSxjmrNXA+PL5tzxbRx6Lzfdvj4Uhfeu+UGniwuB1G9hukiWIqfIEIs
         8aDw==
X-Forwarded-Encrypted: i=1; AJvYcCX9MFUvzlQiLgc3+n4M+Q8m8jgi1ghKTaUSbosjnsWo5O3cT+TyklJP+HFITtIWtHB3eYXFJ0NI@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0YUl93cnEF1IL+P7dgIxkn7rahATPRTEiQd4nIIx2fas5GYDY
	NKjhjAZ9XD6ocVavbYQAp1597DiqqSSgQ0c20EuH2Ay9sbT02O6sR2jr
X-Gm-Gg: ASbGncs40Dj6tAHx49TixmQi2GL9jO31qSecKwNIXLVMh8v42xjlZ/XzQlP3ddW1X89
	x1/01AblouJizyg1JPT6Ay/bKlDn5mXoIpULUmwmdWDb2wzK3Ij+enW9b/lEpNVhOMx5CeYRWMu
	nMZfrl5+KOWtmB6Xst1ynQf1vZnOkUlHoszAan85MUt+raSN2QOxz2Olx4Izmv/1bhgEucDpail
	gbVlTZYl0o9sHwtIEMIs9lkGTWBLqHic/tam6HoEAFb7Ss8tjA4huMhPJTC2+Q9eHM//L4EHiXF
	sPJVid9Hy67/TqSVNPljQc1hd9+dxkeB+VIaXk3m/UpIKOIRRYL5TPVfMpEQyDluqnHOhPCXUge
	LGcuKz+nnXRih0g==
X-Google-Smtp-Source: AGHT+IESQOThNvXIcC4DqFuwvAJfFP1OvmMh5FzVhkz0Sq39a8tV4J0QFYU6IUd5C/6X/J5JnBTERg==
X-Received: by 2002:a17:90b:5443:b0:315:f6d6:d29c with SMTP id 98e67ed59e1d1-31c2276a4efmr4557263a91.15.1751995619406;
        Tue, 08 Jul 2025 10:26:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8431a0eesm121138555ad.8.2025.07.08.10.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 10:26:58 -0700 (PDT)
Message-ID: <12b05333-69c2-42b7-89ea-d414ea14eca0@gmail.com>
Date: Tue, 8 Jul 2025 10:26:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/160] 5.15.187-rc1 review
To: Borislav Petkov <bp@alien8.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Kim Phillips <kim.phillips@amd.com>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250708162231.503362020@linuxfoundation.org>
 <2438aa80-091d-4668-90e0-fb75f3e0b699@gmail.com>
 <20250708172319.GEaG1UB5x3BffeL9VW@fat_crate.local>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250708172319.GEaG1UB5x3BffeL9VW@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/25 10:23, Borislav Petkov wrote:
> On Tue, Jul 08, 2025 at 10:20:01AM -0700, Florian Fainelli wrote:
>> The ARM 32-bit kernel fails to build with:
> 
> Can you give .config pls?
> 

Sure, here it is:

https://gist.github.com/ffainelli/2319e6857247796f0a9bd99c5fe6e211

FWIW, I also have the same build failure on 6.1.
-- 
Florian
