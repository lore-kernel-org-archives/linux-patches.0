Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ED04252AF
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787324110; cv=none; b=V0BzfXGX8t/afze4ibmRrhClbGBCU5XgzOUmpfdjFuBLYc6QWrkT+fS1bMAlVmyAvyQz+56B8GrbKukacOpdH/HVt66y/e4JvPtKFPtBT6ceHKhJ9Lb33Wge6PwNWQqX2gul++BMEC+h/S1ojgkddA4W2tS9LB9t2XBUUt02ICQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787324110; c=relaxed/simple;
	bh=WlII++3uV9xkwc7N++Z05mAds6dpc2dOKTEgBDqPksw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PXgl3eJo9pgpY4Q4O77s7+33tdVaqELJXs0TgaPSQg3vz77o/4asgczpOEDO4Tv2Ts6sFOrSqKqEdZ1I8jBsfmLf7hDpRVKSRXI6TFcbBhPA2h8x2tQwlCKIjeu954GXrVR27JP5/DoyK9yCQqr/6GS3EFrJSPvY99joWzPaOmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LM1MkWk9; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LM1MkWk9"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7e9ecb1e13cso1700676a34.3
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 07:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787324107; x=1787928907; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wAvKZiD5KByJeDCeOU37FeBtAgTWUBB1aLiIutgJAhU=;
        b=LM1MkWk9nBs+Ux/vDi/4tglrpjYteQO7Moobb0pQW5s0WPHayQE2MAZUQAykxLI8Qn
         8BMoLmbSi5G/cEnOIe+05svx5WEOwwn6IAy6i3PnWDvrI47r/k1yZZn5ft3ilgpcu+9Z
         vIXd7AOVzmT1TRETajgei2pDslznGU+wxqrF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787324107; x=1787928907;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wAvKZiD5KByJeDCeOU37FeBtAgTWUBB1aLiIutgJAhU=;
        b=PJOZqJEqSOag2RzcBAs4rUob4geOp9YKGzqR5810OXsKdh0ttBWdhQseknZqRReINj
         86oKHadAZWC3wwEQn9DP6xLcHac5U00998iWdcV0RMsracxTCqfz4ZCiH7kjy4WmCUX1
         FBQjJV7Vufd2eujUFAEIBq6n8QndZubvOkYp67d4emAzW5ivH6rpCaFOkzFwC7EbawSy
         kvtK58jVat6o9S17vfoMQlxHE1Uy3SB3nc/JM8ZSb832MDG9Uy56nkgwP13QQPBj3JaZ
         9pdFTZG1rp31GsBDh31BNHmzOKVzRJ9+bNbWFm78wsxWyiyTLloeqvxTQo2Bz4g7DcV8
         vqfw==
X-Gm-Message-State: AOJu0YzywYm1p4X0VsOUH9iOt75r5JiQXlFPpRIRvzjcnHPNxmvlOyLZ
	ZZkE31gNLB9RkBtxVe9wq4RbtWOc9oOu9TnAZWxWhc+zyc92M0463uvrzj+JQzHrWk8w6tvA7MT
	SdaM9Q8E=
X-Gm-Gg: AR+sD11V4RkgjA9Lp+IJdCwLYEa8SOiBlwPmaecmwrVHsdlURfHT+t/I2QF7HrDIIHn
	voB+vI71EIZ2kP8AueOmNDRa9xKnSHsdPTcxo9W5LPwBoQbrqhpYSqdjPp7CqvkT+twbUDejjKU
	8QRV76FsSgW2Cto/9SIWdbIQTuVD09Pfdjjn+N2kDUWxehLZtnV5W8j9NeETZz7ekuBGWZsyJ9/
	wqnbwE9oGRXHexRS9AOFkm6MSKopbQizJi5l1VeBVFYn88UGMQvEXaEMg52c1VncEyoFJ7De0YQ
	N56cI0+SomhMlQ64RiY4mEMZSSKKNDd9lwBMl1jlBiDzOgLcC/h6j0zVXDtIuCX2E2JjKowvu9a
	lUOLk7D6b1G2uGkhpr4XgWOBantVOgybgyg5gXXdCYxchYFPLHEFUOtut0Ng6r+9wvxI9YAbxya
	Qwx/PLfaVAfbMm24ZCbewIqjuejUOhs+408+COHQdZe3ZU/dqhmCHj0w/LTAtM47LJjXVzoQ==
X-Received: by 2002:a05:6830:370f:b0:7dc:c4ae:a679 with SMTP id 46e09a7af769-7f461408acdmr8596894a34.9.1787324107685;
        Fri, 21 Aug 2026 07:55:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f43fe70786sm8005724a34.4.2026.08.21.07.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 07:55:06 -0700 (PDT)
Message-ID: <c1034097-fedf-4c3e-80a4-ea0d29b72cdb@linuxfoundation.org>
Date: Fri, 21 Aug 2026 08:55:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/272] 5.15.217-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 08:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.217 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.217-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
