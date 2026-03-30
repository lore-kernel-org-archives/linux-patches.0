Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E35299923
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 09:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774861357; cv=none; b=mcQ4+NGVA9DcGCg4lGQw2PplBKDwk0AWd0IQmo1VYkeCUdeeeiJp3pHwzyfokSedkckkTvvYKi4mS3dTRO/Dr5WOf/hZLIM05qL3UmQaA8Jr6098w8OFYMs/om6XtPE/U3v1dvqzaPCkVsUTf/RWMVlN1lU/9QtgOpt36fk+Ku0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774861357; c=relaxed/simple;
	bh=GODCm1B/1it3SFB2y34gcqgyDxFXc//xAtjl4Hm8+1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OG7fljygAWbaBr7W5kMA1C/gk01F70qjX9T/jAbZ1M65Yh5HPhWhNaq3RL91H2fPYWfBAjpNBUOZgjelWiirnwpTM2CibJQSD2Il8xv9xNARyU7IycbhNXGndIrfzlHqHPOCz3h8QZ7iOBaFVyE0sXaqogpxe+e+roINGHx71DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fimaHl7u; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fimaHl7u"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ab39b111b9so17948115ad.1
        for <patches@lists.linux.dev>; Mon, 30 Mar 2026 02:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774861355; x=1775466155; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=mpQILeXGrITAWA4MGQhQMWcX5qZm/qyaNH9J5RX59CY=;
        b=fimaHl7ua94RMJqFHVzUBUvFzbYoLyuiSFDPYZzIx8ieCUsQg61zwZfNJX/KzfIzAj
         VLjQgAv+8e2TUPhGLRbPFFgJpn8oUW4/bNliMfs9F5h04VoDt/ZdxwBZlp/ImuIFHOag
         rX5Q0WArSQgy3QpX9chNXVjjQ/soS+/7xd8Oi7ebngoQwtzIN2XeVTgWquWoPxB4U7Fl
         6ivNSHXrCH4otK5Z7sNgYsdqjF8/KRualp1k37W8OCSaFaPREmWDPXV9pY+GLEnBuyR0
         k4HZ9AEN6gLXDkh/YVVavqNo34/xCgtImhZPyrLR1IZtY3ghHD3eJTzPX4Z86Z2wfsK6
         Ck1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774861355; x=1775466155;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mpQILeXGrITAWA4MGQhQMWcX5qZm/qyaNH9J5RX59CY=;
        b=eEyNOcLXcLgrPxjoUaWU7lJYHWrD+zMowZaiDwoC9l1wdOjkqAnvngYiay10Jrd3em
         TExsbsoo1uk06MMwbzOPnaWKkrmlKJrdefc5SXH1hgoMHLQqy1eaVfDTbffpYl86y22B
         SrKjXHTDq8vtEDfLagbbmV+lPgRpyXTYv3izdz7MGPT2+UTs3+U7U/TyHCK0rHLb6Zz/
         z9RJ4y3HOaf8IzRau6ey0w/lhw6m0tpyzXQvLNmTFtPVVDWvvGwmakGRVBqL0WdwRuHz
         76GBIQizFuxHPRLaoV4MDq/BliGQttZXhmBzkAGTsk6ZFoKFQ1DGZgrPoEdLQMTQ+aog
         m3uQ==
X-Gm-Message-State: AOJu0YyKmZHLkqlnazqcEpsPeBFSrLnz2jlZZWoS3jbB0mpGRyvGqT7K
	bSN26BIPsBNzXCIeoF7tyj+bFojVl/tLhwaFaxj+2CV+9drfUGs2l2Y2GisixQ==
X-Gm-Gg: ATEYQzxNsH08lK9lNVMiGMHJisQ5iFBOuaXNoaJL0BlOwD+/b3w5bsDjtM7ePIhza1A
	Kw2Cu0jKXHXS36FGUwiuaBm040zmiVpxLBWWd+MFAaEw45W3XD21Fa9ficMSpQpROJp5KnUkyN5
	MxwgxzaQ3tXWhwGjQl/RzIHcocOYoTc0FddzTZuI9xQfvCSdvAg0Uwk6u2t5MXLcWITe4+E+SWf
	rasyctefXiNaMQTeH2Vif+e0UCFSf/qX1Ux245SRP3nk3mXq85bq3eF0/A2fQSld7jhebMDT2dj
	iB6R0dUQoQIWdhUhTSDmir3/mshHwQMjr3pbNJeKK250cUbf0Ncx1BJt9HKKNnIZRcyfqYVQZJl
	9QRhyDUP6X9axC3evToLKb/7UyS7VZdZ6tL0Tv2/5t9Cn495xdC1AO75bni5V8s/VJcqzSbx782
	r5kri5kkM3pupIjzUmJk5fllRjORshaKlPKXQvMjO3R105rJf8seR1QguxgWQcBF2/60bIfAoP
X-Received: by 2002:a17:902:d511:b0:2ae:6259:5aff with SMTP id d9443c01a7336-2b0cdc0f665mr124190895ad.6.1774861355428;
        Mon, 30 Mar 2026 02:02:35 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24278501esm75368605ad.58.2026.03.30.02.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 02:02:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8aa3ace8-33ba-4914-b615-c165fbd146af@roeck-us.net>
Date: Mon, 30 Mar 2026 02:02:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134526.647552166@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 3/23/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 

Since v6.12.64, various architecture/image combinations fail to build
with the following error.

Error log:
sound/soc/codecs/ak4458.c:631:13: error: 'ak4458_reset' defined but not used [-Werror=unused-function]
   631 | static void ak4458_reset(struct ak4458_priv *ak4458, bool active)

This is seen if the driver is built with CONFIG_PM=n.

Problem is that ak4458_reset() is only called from inside code
protected with CONFIG_PM, but declared outside it. This was
introduced with commit 47c4976513f1 ("ASoC: ak4458: remove the
reset operation in probe and remove").

The problem is not seen in later kernels which also have commit
9f9c8e9064ea ("ASoC: ak4458: Convert to RUNTIME_PM_OPS() & co").
That commit has not been backported to v6.12.y.

Thanks,
Guenter

