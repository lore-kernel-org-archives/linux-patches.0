Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F883CE4B5
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 21:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787692458; cv=none; b=IQZotZE+p8QwfpQNI5ffcUmsdkeLfHKJ7QlZKDRmZf75y/cc/oov0sK5nSGyiysFEjEldbXtWlP20rvTrU01kY0EN60/QFmCCBH/BY7bfxMWf6n0ZagPSMhhSCojADwKK7eigc4ISit/wTa00lsTaTwB9ELNeyLDaob1uHcxWVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787692458; c=relaxed/simple;
	bh=yfjHf3oacadvrlyyDrTgxD7NIYF+FYS1f4+hS2zmuFA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gVND2QsDQ9kc5V0BZkHfAEsw6Jc8J4aokGAp4CT3pOBmBozNklUgz2hyopILvXb/KDlz/M9gIYPdoaxw37Xw6wL6bMCAENuRPKHWSfz0RgZMdkzrsZNM4W6Vx1V43D8D1tVyHxpTrqpYxiAZMJQ59htPOFR/P8dADIwrpBauXmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H4MyotXs; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H4MyotXs"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92edb12cdf2so13207285a.3
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 14:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787692455; x=1788297255; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FQ4W8vFJosNYzvgFRlXUoBjGheIiHAM48+78JXM8Oqs=;
        b=H4MyotXs+n121srhqpbkkOBFgCzkJAA4ia5j8GmxFXIb1Oaqo2HzEmqyL+hsYr47fl
         7tvfxo3WqV2GxvvHqS9z5ibSZY3Zp/WElGZBk/sktQ87XHMcyoGNvit0DALUZkOSQf4B
         HdJ+xYrRM7uAkzjSW23Hg8kgvBmlEdaDFGdnG2zWuj3/wGxEvihegz/Hpd4lX5X3tAP/
         xJj6YGSmAsyZBs6rE6oqlObEewb05qcW1I5ai0Z+4NRS9/sDnh2TSxxjL0YHCpBdlFJO
         bIvOpvcTYgfZrb2oVO9kQBbDkOIhMSbUc3w250ItEYRPRAQU//mau3mIUwu/0mU6f7ZF
         60EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787692455; x=1788297255;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FQ4W8vFJosNYzvgFRlXUoBjGheIiHAM48+78JXM8Oqs=;
        b=oeJQc6nO41gEAAyNi/3en+K9uMeS8V/hwD4v3cIn4p0iA67WWD1Uyt5NXRHspgCrK6
         jPc6Rz1esm9RF0aNFGj/dnaHPrxI8ypue+LokLb18oS5E7jZosMWr9HqL7fJ7gNjeVwY
         v6r9yqzxGe0XyEg4p6i4xkT5G9vv+55PfVORHRXjo2xukCy46UoAkAjY9mPsmeyoD3xl
         m3cj9MY+HSvofJd2CYXgj6wRAC53o2SaoZbRMupwyQpBXZQOCGSUL/tQddPNBNwe1iWv
         sL/n0cOvE778ltjPzgTN7A1KMt7oBFcTnYAOm+S8Y+KJbpC2V3+u/4IWCTRARvgfGo8w
         qhEg==
X-Gm-Message-State: AFuF++lV3RwRUSoamXC3LKbUNrcyOKLNVRGFkZqexSvLm02jSsvaFg7G
	UqbjKf/RI/pwKr8Eeor5ODt4v78SfRV3uC0ldC6zT1wabiWZJe8dA3A=
X-Gm-Gg: AR+sD11CMdQVkPBDNG0L2WhRliSU5ZcqXk0YMnyE1bK8pBrDbaOKhAZDWpBIetTzhAl
	Ex7bwkV2ZeDdbipKg60yGGq8VLCAQzr3VoSyWRdCZutU5vVN2mI1FDpuvQr5t/rye7pRdIkprsb
	R+suLTiueeQMeYeP19+csLdW4G4vy8zTkGt398GLHNRsYv/1NViMCyMP1TW3rcScITNTOP3WZi7
	y0sDXI8tqdMbQcIeB1hs+Di7ZsAzB9uppKyzeTR+SJi285TCs2YJA1pfYIURDGKMvxiE0OqDYjY
	yASSpKoFYKk09PQDgUjntltaTvKVJpt2f9csYHl6TLY941NC7yB4bH2h1DGxXktOUxVLl+WT2CW
	8jUtddJ3qCqdfZJHHoAsyOKjOt6q61CvKVVJsIeGArCe7x+KMnyU/zC1bZhpSBboEodB77SP7dV
	2meiw1oaTgvzd53uCm0+0qsJ5ed7n+VdXNemDFlozTy8+0WG8rJiOmD0uPi/NogQt4x7NlDeGgK
	pxLSOz4HxTzKpVT
X-Received: by 2002:a05:620a:2945:b0:936:695a:185a with SMTP id af79cd13be357-9378046b550mr129776085a.44.1787692455455;
        Tue, 25 Aug 2026 14:14:15 -0700 (PDT)
Received: from [120.7.1.23] (135-23-94-154.cpe.pppoe.ca. [135.23.94.154])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377e30ed19sm69914685a.8.2026.08.25.14.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 14:14:15 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/57] 5.10.267-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.342390421@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <cc27b74f-b7ba-7004-27f9-16aeb3a6577d@gmail.com>
Date: Tue, 25 Aug 2026 17:14:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101
 Firefox/140.0 SeaMonkey/2.53.24
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.267 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
>
Build for i386 and installed / booted on 32-bit EeePC. No problems noticed.

Tested-by: Woody Suwalski <terraluna977@gmail.com>

