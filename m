Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5785392C25
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 18:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789410686; cv=none; b=r8i/ZEWBGJH58OuVI0CIJAm99NU+yShFpXv+W0oSenfoisWVb4XmBX6OGS53muJ2dWhTFRNf4NmrYXtG1QdwGP43YeDCRfX73Anav74wtwTU0a8BSlJ1IZFkfIRpUhru2LSzrBVUS9z1jdaLT/sl4IhHauOnddGD2b6yEn3ZZMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789410686; c=relaxed/simple;
	bh=ZRTmTgpXAIHI5PwDlZl3mxTARuuSCtuzR8f+OYUlUCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qWmfIEKNLUkOWzzQjYaMArfl81F4UJMUqnoEZhXlUjQHaeEqgQxJLNycTBB6LJQMiCfecyCVJRMDq3E4vYhkd7FznrrzxAJ2abkkIdEPFyVodgx1jUsdrDmrXhD0xkfrhI67Vr9D75jtR6F9fcUWwArNOjRubhdfWbYoy0uAu/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mIJI7Tgi; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mIJI7Tgi"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93a00298c53so173427785a.1
        for <patches@lists.linux.dev>; Mon, 14 Sep 2026 11:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789410681; x=1790015481; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qkJteh6h5Gfo3xV7o+rs+ZpT2JdE1CQXCwGXk9wGX2g=;
        b=mIJI7Tgi/HtUzr2mx2L/f7CAL/F4pKlh3AwuONNXamJj4UKqFaj2ZqDZ36as+mQTH6
         fJco4jKKO3uuilrVjgrc6r0sx41/mgEdhOJ9gqka0aUAJkRyNV/xriwzbb9m037/KSid
         BJqVTYippRCLGehIiUR5dJrF9nEfg9Bo+P1cz3FtEAw0ZIieiV1Xx1wpzqaYgzBN/vJZ
         sotSmbC+JzR8V7ZMVoebLmZmaq9Ru82zONXRndcHLApOCUaXRwovcbgioTpO11z7cn97
         QiR+dGCAq+zAZm7BddbF1rqInk22LDGn5LahuVz1cXQ4krl3PFExXcEWkBGKFfapFgdV
         kdlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789410681; x=1790015481;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qkJteh6h5Gfo3xV7o+rs+ZpT2JdE1CQXCwGXk9wGX2g=;
        b=H6GXa9gE84aFVfcCD0Zf6RDON2RWvGdqsuUyOCU5SMR4BvpTW39HHHOQP94gZ7wNCe
         nUfGJIA4GS5EqEz5bj9TrIrx/CZGE31+8hKGSq4AVnv429VwaMtXe27Qqx/e5iOGoU1r
         9XskS0wXOpiEAvPoff5/xs5ZAkZ8C2bxeTcWl2fPpEyFoJMWU31aspHJPrRiefwU4UDf
         gJF9/v5fgdSb50LBbCddBBAls5DY1O8gtMTOjG/EEbAMDlNUGTTki8GU+PvdOLtoFM+J
         LLF5N2qyD8RleJD1FBkmobjh7l8+uNRDw3uNOFIfZTXqapgSWUvF5053Y1IS/Z4pI8nv
         y7mQ==
X-Gm-Message-State: AFuF++kr9Bb+FGAh5VCNGJUuHvKTW8yLmUiH5SWm/01tSmhCqa24d6Bl
	TeOiUJNnG7GXakf/0ucYcKKb6yuGp0cCyLJ91WbMO4EY7t8tlqvIvfdz
X-Gm-Gg: AYBFou2ProRDxVf9TgaqMwHg6V3i4+qVB9o6kPsuY+YTYPlZq+Pt/1TZLiuGjfcY0JR
	zocJLMp5xN/fy21ilYYki2twbuxdYcqtXwXCdWZ0+PnM81srLbVh0JrVmOVCiLpzwuRatbpboI1
	L/Y1xhqamdKv2pRHxdjOmRPe+QUsl+v8cK/L+3tlvZJ/GjhmTz+C6wkGnyWeN8jr5OfZfCl7MKC
	QoYth7CcWs6kZ8iNJsZcafqApmIkMUMA7q/B4ilR8LwlHdwFRT4o6G9dgI+q8jgffokd2tRxLvY
	1xE2jptiC1WNPd6Fe/7CrPLLvvb0+vr2xRtFKjKGpe4fUP4OrCRvu1chlbkZI56U/twMnoCYyxJ
	Cw7EgU91f43UzyTZvj+Mku4voN/5xEkWEUMfZV4cEptMUfbqWqj9ZDCcj8XXtINGJs6T1mTq2Zq
	NWSZJg33CMiLFY/TLuanVwWdAhjHscKGdEZSMOvNsa/buvnt8AWlVel/h23CYm9pQkIsMcTfujw
	I2aFVmoBjURSTob27bSwSFPtQ==
X-Received: by 2002:a05:620a:268d:b0:939:993e:bffb with SMTP id af79cd13be357-93a29804240mr566801385a.22.1789410681357;
        Mon, 14 Sep 2026 11:31:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939ed67a93dsm960651085a.43.2026.09.14.11.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 11:31:20 -0700 (PDT)
Message-ID: <f687d3d9-b4da-4549-a40f-fd9254e7fda0@gmail.com>
Date: Mon, 14 Sep 2026 11:31:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260912065648.999753832@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 23:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.6 release.
> There are 1815 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with arm/arm64/mips:

ui/browsers/hists.c: In function 'evsel__hists_browse':
ui/browsers/hists.c:3191:41: error: 'hotkey_act' undeclared (first use 
in this function)
  3191 |                                 memset(&hotkey_act, 0, 
sizeof(hotkey_act));
       |                                         ^~~~~~~~~~
ui/browsers/hists.c:3191:41: note: each undeclared identifier is 
reported only once for each function it appears in
   CC 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/trace/beauty/clone.o
make[7]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:95: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/ui/browsers/hists.o] 
Error 1
make[7]: *** Waiting for unfinished jobs....

this is caused by b8ad2bfb11e0868b595b4cd9dfcb9e80f174b2d5 ("perf ui 
hists: In report UI ensure thread is set with reference counting")
-- 
Florian
