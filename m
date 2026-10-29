Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793288405;
	b=vKw9uiUSxlR4BsY1Jlb7KA/JT4684FSHWO1ca9tyj7UZSU77ivbDO13xUHrBpLS+YIOf
	 ilNZ3H9GQ5q2lE3tuWfREjrRipdnVzSUET+msLF0UVpqPWSlzPZk7Xq6dNyAWczVdWSDV
	 IbDJ67dyrJJxEYe3q0tM3xZzbIpD32n0qEJ1yO4uqUluScvvKjluKW6cpIwBd5Ez2YUgx
	 blef/nVd6NJM17GGxzrhsGQhmjJ167rfB0TMXiRbkA4QO+hV8tH8IrihuFo7SwX7/XaIf
	 V5scW2VfCd+l5so9+ZuCVnyPpgQBhFVaMOYAy7IFtyJQyKHan4XfaVyr8Z4ujwnCo2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793288405;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=p3YvkGpbJ75egK6OsWORSXS1tksyIAY2QOnekRB2s34=;
	b=SrEefT2Xxj1KSlEvbXJzCb2vIXuiUmZBBGxCTrGFx/hixvAV4I8+aa4u0TqjFET6p1Je
	 PfGzotn+cwYLiAeXMqjztFTrci+FP8B442vuV0wSZUNGepMTeyT2S++/G9NQoaP1U7Vq8
	 9QTN9zmNz4Mpe9E6sCkyE+Yhb6pU/KFAK31GX29SPyaY+g8Yfylg6p2qY9Y2j6r2YxUK8
	 8wbMHYS1FWw0aU5/GDw1JZmlACe8sAG70UuToB+ewxYNmvxWaQMbp6Lhb+MAMI+migevn
	 Fw5abja9O3s4ASUSrBOKrC543BuydBa9vgRqhA9V72b5VCmItCeHqD1Ps3ZcrqsK/uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=aFWACsWT;
	arc=none smtp.remote-ip=209.85.210.54
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE3E606A321
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 15:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDE3E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=aFWACsWT
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-8446af403b5so1421533a34.2
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 08:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793288402; x=1793893202; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p3YvkGpbJ75egK6OsWORSXS1tksyIAY2QOnekRB2s34=;
        b=aFWACsWTJts2xsmfhkHifiv37vHM074Zek+tFVvxoJE7+V9BGnMMxYwO13I1YEiMo/
         T3oFk115uqGoABtPl74eTkjlM0BPMNwiZ0XpQocxBKrrMbbctpiB9bZ//Qb8+BbYBumR
         CAAbM7GlDRdtiq1TLO21IUhXoepeg6s29vNmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793288402; x=1793893202;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p3YvkGpbJ75egK6OsWORSXS1tksyIAY2QOnekRB2s34=;
        b=JJz7xtOYjGuWhZ7WoRQ0r7eOmAuJ++bcwt1EXtTmwJ1TS92PdeRd5lfR8HOBm/Etk4
         4DDFImWvxCV6HoVxdKnRRsvHlp+dDyKAUE1fT4xO8WV7p2car8Bwx0R8qk60oBRNrZPo
         pkxgadZL+jxi0H2ONG5rGozM/jBVevh/hN2ykOX2vc/awXt3lCOnElPvGEKCuyTSjUxf
         q/CEv62bY7NmcuEiV/2fO3A8tRFcacOz5MuoxKQF+LQq3fl4TAeep0GaskeNzI0NVzqP
         dSanWbK5SWqsHlEkYqyVdtrP9ehp3/xXx/PzL5PqSIuqoZEqpNd5Q2Ccw0gxA9TEQBxQ
         hMvA==
X-Gm-Message-State: AFq9FYLkCinfvhb5FB1730YYEH+odAgtZt2Q+b7BvhkcHthab/DWuab7
	J5l/pw81i56mfSMf6DwYEBauoNxw/+HoDS6EKPW0oAFOAdMpwxE75gujohCB7/6M0JQ=
X-Gm-Gg: AYBFou1xiIFT5uyvfedmoBj+SeN6uZGXg+Y+8bpSE3iOa9XOqpEuVLOtAl5ijd4H2Gx
	TtENDhZ4fmnis13RU7901b2NtRsAe6iR1NwpHes17Xf25J10ZkmVcR/0cIxypWaMzIl/EMaxJ1j
	Xcu/Qh+BHIyOgcCfB93tRVnddDZoeum14AdZi6Uxeq0UxyrhuTYpH2urZqd3waVJOcno/MX0imZ
	85woDuj4OHeyRfoj8/WARimkk2bQryZUAOyQuMXSRR5AYnZDSetcp+dhgkK5yVUX+EyYYdVEh4B
	CJOK+h8f6Nc417bzVcvYHUiTUWTLKSni/owUTQ0F3EventQm0dYwFsoKrEsTN+V5udysDA7+9v9
	8FGT1tMU98PGSgBa4igG4L+uiZLNJUHY1BWkaK7uZSsIP3HCyLMjxxMtI4MY8EGTTSX64/+UQnT
	PG8OzstaqceLcgqBLwS+inyC58ORq17fBmaZSpMn0Q6ui0CfN+UlQhLMvuDzBIazwA77XfitffX
	qX87kWnG4gwl28ib6rdTB68Bil7PHM9nekbEneUWuwnQ8cFaadxChXQC3aIMXHIAXJQKHs/JJei
	27oF4tV+h5gtXvFWkGkVukFTFZb8QZYCYoEgO82P0oWtjiS6991rneIIJTw=
X-Received: by 2002:a05:6830:b16:b0:845:3cfe:601 with SMTP id 46e09a7af769-85ab2504c5bmr5675751a34.0.1793288402519;
        Thu, 29 Oct 2026 08:40:02 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85d33e3696dsm135839a34.1.2026.10.29.08.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:40:01 -0700 (PDT)
Message-ID: <c0500cba-eb48-4421-82ec-b276b1c9453e@linuxfoundation.org>
Date: Thu, 29 Oct 2026 09:39:55 -0600
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
Subject: Re: [PATCH 5.15 000/571] 5.15.224-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 10:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.224 release.
> There are 571 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.224-rc1.gz
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
