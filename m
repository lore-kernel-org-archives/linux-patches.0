Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795103073;
	b=ZEyPqPySAl9x9gCgLGBd1nliJFA2VsDoKPWyIHfPFiuXoUlW0B1rvpeUeb2JyPtuCF7s
	 5/UMMsyq5t6eC9P9FpUJCB70K5Rr5IRYrQCJP+sqFskN/UzXpyc694ibKPb8OXzi5qfpv
	 6O6XCZKEgW//I1OVJ3DXxDo0JP8d+wCM+qmp5riaVZbvgDcdoC5hRAa443Knfd46yBXIv
	 qJynkx/bf2qZHOpzxO0aks7+JRnrE5keiONla98uFsCa5VEAJDyOdtJYmh7gWvrWS91d4
	 hQS/Dtq4ER6KRBu7ychhW2aSSs0fPAmQSdW1eiSVj/FOVML7pyXes1YEJsFClnoPvFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795103073;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=8zz110iQMhXJ1p3ftg+9uhn6MYhCBFktVfT0q9rAKSU=;
	b=CQvTxzj1VgjIsBLzsShINzPr8G6UJL5r8wnW/TLrlsoGSISolQox2G9q6Eo3ixhCvuew
	 00sz2ndZDl28Bm/JOqsB9mkXdqZjIdKkhwMuKt9D2DjT6sIlTSpag7WhOX87vaQ42Z58I
	 W3hS/088Afz1NxtDz5mfkvLwfzHtZFeUoBrBnP0T8g0nYYj9v7BSYN0k/54h0ZioP55Dk
	 keleIlNTijpXKXJXo/VKAl38mpDwwU807q9Dg2U/45wqjInJucbyBz/6l8ZPsEq3XPDkv
	 9LVirAY8bzQkGAfP+2moeQHeL9mHKM4cK+yc4NzSjYDTH0+vN2QHXSw+VuItTKjpGnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=IxAouRc+;
	arc=none smtp.remote-ip=209.85.161.51
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D01606A32C
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 15:44:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3D01606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=IxAouRc+
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-71ad2c6491fso615932eaf.0
        for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1795103072; x=1795707872; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8zz110iQMhXJ1p3ftg+9uhn6MYhCBFktVfT0q9rAKSU=;
        b=IxAouRc+YtVFeZFYuos0Gw+6zYBCntktEIIaLKfCpeYudpRogzBbqQi+QtfwDMKRUt
         iN2ki5AQZj+UQAHDaK+R6yIUQr4q/CTAXRAI4Muv4lQvlBNsVJY6T70k95EwYgFe0E7e
         9LzQEwXiGtXRi6oSoMfsC1whDcdUfzrdzS+5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795103072; x=1795707872;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8zz110iQMhXJ1p3ftg+9uhn6MYhCBFktVfT0q9rAKSU=;
        b=BChBsq/RV4s6sF0FjWOUO3R/hpSA/sjVTXUz+J+COJ+TmWz9KC5peMz3l8oaa7I6hJ
         TQqP7n49EpiAYqWfNCgPnUOF3ZrAZltpsq95ub424jTFaBbADYecy7jWTQImGL8c+2M3
         xy9pFvkcf0CZy05go38V+fABK3Fu8lZ4R6RUOciJ3Ck9b3Z1KGEvIZA/IL4kW87d1K3x
         yYd4EC8tRAJmys5Vm/MY5u8XqGjAqIyzzM4TBlNBWGj4X2bR2H07S7bykazZrUOvC6wj
         YSflDbGtcPelW1nwXJy4oGaNO2XUy5GgLFG3MXNtA/ie2L5M8/Thg3dnZL8HVyMe4qvz
         DrVQ==
X-Gm-Message-State: APuU4Z9utQDYvKzNteZ+QNWD96dp2wkCYsNJ/ckgdVZnpUz7dbmfr4OA
	E9U/sRfT6nHAiKiFLZZlOQNQlaGV76s58F5kzdGVsUvy14DQmWAHzkS7TnSi8sBx7yM=
X-Gm-Gg: AYBFou18HlzcBfdXbJHewn1+itvkydMxLsOmlYi/+LBWtP8u6slEYl2LTt9hr52OOr1
	kuW/ByDQRds6F7sYt9w/w2My+Fum9a+Vu6w1227hkk+bSvFJxKgolZ/NYVqmwsb4M4fIE9W31LB
	B9NqYS05cP49lrHsMtCfWLf8vYBhsMkGgD2db5CjM6kO/P1IrBwyA+DtmnHISEqWotf0Sfhxfqv
	fEZ4cGTY/NQV+w+K08FCfkZRoUXhmZxOuH2Kg3PVdHGzIhZrZsi9tx36GtFKwWPcvYyNMtPTElt
	sUOPqBe2qczv9sw0hb5cSnKPBkDagt99LmXSy5HqS5d9ZUJ/O2D3rukep1fGR4diI1IFFe/I8H5
	IhnW6+aFtDHbgQ51+jMJagoQfdh8RtS1sQD1KswrBfog6DCYckc97dMiKI5uaBJAWki2xOH3krl
	IqSwLjJ0sNX35L8mrCAWCxb95Y/vGsL7MS3yM/M06IGjkmL6txucB81/MZHme2A7/ckchBDXrAW
	0+otwHwXqOTDZzpwURYr53MoVfJuJPMv6jAA8DSK45EPtttzbgl7c9hGFNodbqlv1yBfAoCpSZI
	fnHCEoVJF9SMfSrFRv5hMWXyda/2NlmnyJKZRPs=
X-Received: by 2002:a05:6820:55d0:20b0:71a:f98b:3be7 with SMTP id 006d021491bc7-71b325f7287mr642104eaf.26.1795103071796;
        Thu, 19 Nov 2026 07:44:31 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-71b380b6f82sm182937eaf.10.2026.11.19.07.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 07:44:31 -0800 (PST)
Message-ID: <7d2bb21c-f8a1-45c4-91ac-55c77112a8ee@linuxfoundation.org>
Date: Thu, 19 Nov 2026 08:44:27 -0700
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
Subject: Re: [PATCH 6.12 0000/1756] 6.12.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 07:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1756 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
