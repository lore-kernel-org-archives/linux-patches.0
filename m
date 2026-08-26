Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66CA10F2
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 00:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787702709; cv=none; b=TX6dWdpsaNlBx1sKRcDktSzcO7k1bhvaSZUIUnV9l4S+95bVciESvpopZ3FyNk+e/vAuV5/y5LhTM7IxpKPHdzsoCpsV3/aA9ESzXF48KIOhK6I5fa0PyVlUuX+Ats4z5AYWZexdk7F26YhH/Tx2OKwIFtW3fZUayEHHXrXyQuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787702709; c=relaxed/simple;
	bh=6Ry5OlI3DAvR+ZQ5L+BY7qSCopLwoyQxpYMx6yvecJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s0RT+mJZqp+x7VNamfNWOYv4N594YrXP25usDFIEJj7JcamMwqXbW4nYSN5uSfx1GKD9jdT6cPvTl7C1IwnbFPH/dr+mmIXKfv7Varyh9poGszri1n8sCQW5t5645vY89udEREHJZ7I1SnpsqTBfA6aT0s2mxK5j6Acger+9t5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSJhQUCp; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSJhQUCp"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4a40bcc8d69so75078b6e.3
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 17:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787702705; x=1788307505; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ztvec6OqI2y+QcETTkAO5HD4apNeH1K67L5ttNvGvIY=;
        b=DSJhQUCptLaaZplN2UudK6ybP07p8cGukzv1Ib2M7wRjTtWDJJUq9hWjandC9xo38e
         3B1fN5CFCUMxKleEpixerDvaxzNUYgKMaZGhobsyIWkxGJ53W8ZdgA5NqWMTiOAAoFTx
         w3h0jSOllJQT5XaEreExP6duz8PYeW1IWDunc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787702705; x=1788307505;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ztvec6OqI2y+QcETTkAO5HD4apNeH1K67L5ttNvGvIY=;
        b=QKOqvVpbJYBHIhNEn/B9FogI0PFedbXTtAH1jLSbMXQ/YNUVFUeNEWSoR2TpgJvwfl
         DVFbafzRd2be/UDi56Rxp1dmDVozXxVa3fp5RMG4RS6dhac58/OptVh/+8LkRLBiKyRp
         kd1auDjgGsJwcR2Bk8Q1ABAS1bD9IkMTAfWzZg20LgWv5pZ9asl/eUCPpavMfCxcax3q
         btxfHmkSBg+d+ncAQT4AFxFgclMExqX5WaVjI3eH65MTI9Q9Ed+8VcTuwmM3NaWcCHQ8
         ElklGwJgtqIYO2g7H9K2g9Cfu2laL4+DfFQvUqGi+EvSrlrMLzrK2ZvbRK1xryPbMyO7
         DeyQ==
X-Gm-Message-State: AFuF++nzZdJIiQ6RslEI1ghJ3zYSw9psqxdcTEYV2BHyw5RCAPuDUBNq
	cW4+cnxU1w30cuZEy5u1xJMVlsT0W0ETGvUy33O+oyHSMofolW3QLX0AXwRd8sUF4Xg=
X-Gm-Gg: AR+sD13X/4K+3fkCAuppu5Eji1Cr1N1HxbCyznikDhwMp/eDlab8JqXpdsJpa1A3/qB
	FCbJ9XW/ixiadKCtTvDTBrpSwlDh6seqppEBWS/f/1+8aERAbloCcsroT79DE2D6WLqX+Mfmn3a
	fkTimT57/Vo1OnCVmEi5sJWLMFtuMUVFU69rZHVWev7dGVf+ezVfuyBvTsKE5/BA5VrWa9izIUX
	zspEIo26K3Iv0Tjjj4NGufBjDaNcUfrGxNuqtC/ltj/nEj6UQAagcwCmgKI+LWuX1/16WvGZPFj
	XTllueTrt1+ug88+1CgHAtjyzX7vq/g5K5101SgZNadgzQ/AORnK81jRS6iKBuZjEexbr5LuOfA
	eoCZ0j+w7rKHFuGpfXw7f6CKxv1z9TxBqeRtAY9edPuzS0UHXgAAewKpdiae+3mS0qztedOnQ2l
	6092SRQ1TSvhq3HqqcEJnDR+dEogQmxB/2mMACLaYWnTNzzRKkrXTZKhnpzr/SPPaM7zSY0emLg
	FA0KAtL
X-Received: by 2002:a05:6808:4fe5:b0:4b2:5529:ed3c with SMTP id 5614622812f47-4b3668b9c28mr3926595b6e.7.1787702705584;
        Tue, 25 Aug 2026 17:05:05 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b36a7506ddsm338061b6e.4.2026.08.25.17.05.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 17:05:04 -0700 (PDT)
Message-ID: <6c3bd5e4-218f-480f-9ec5-bf8565b33d4a@linuxfoundation.org>
Date: Tue, 25 Aug 2026 18:05:02 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/94] 6.18.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 07:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.47 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.47-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
