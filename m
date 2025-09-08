Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA942EBDE3
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 22:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757371017; cv=none; b=Xo6sFcfUd7vRH00rVVOi2KSiMyKH/2UrOsbntRgXMv3tVxJPRS/3SwrFv6Fe2roIi2iVs73OH8CtBvWPOYIWej1hLPgF0RinX+p1RgVZVxSSQ+LToEwLd0OQBK8fyB914Rnio3jzFwcgv8Oz68BWd6ibgsan0cxGpXMMQsa5RU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757371017; c=relaxed/simple;
	bh=T9P/K6SEcXRuUJUXzSA5TYU5bmqcQ8N7GHQaxFjMhXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LySW7nEjQ0FkBVRyOO06HOU2TXWMcEessyusboGjfTHiqm05JGFQSk5aHK0yipWgoc0sitB56pHQ+fOu6ULsvYscIQvcm39MQWDFbbTBtKKhzBLq0U4BquMk0e2gXAFKr/nquy7ffyv4gHaOHGnwMorQwTVhMxTeHaX7lkNayPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNebkdHc; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNebkdHc"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3f663c571e2so47393545ab.0
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 15:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1757371014; x=1757975814; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lhYf+Oj/7EuAlJsyRI1kl4nGXkiLJ1sdDKDHJYLWFpc=;
        b=bNebkdHcyfkyaM6czdK5mcEShnNxSRSI9DJ+5NQxkp6LhcJXCMWIw8HbecbDo+404I
         DhdIHrpaN3AvW8z3AgyAybzDn6ycHOd8emLereRXa4RRT3t1fpU9wRxyI1kWHp2Fb7aZ
         H9YBnws7bVpKU+p9TZOnbSy2hlUz/QGHeIYSs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757371014; x=1757975814;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lhYf+Oj/7EuAlJsyRI1kl4nGXkiLJ1sdDKDHJYLWFpc=;
        b=abMaeTkdjXXsY3BNm2K9GXHImxKvak93yPQGgJXxHizg9e8sOXxZOXIC0eI6Cefm7n
         /R/ivgfRTuj6jH+tiwBgk/YOloTkLwR0YITyPHU82MsjR5BX4Rk+aqj/xagVttEK+1s6
         tbuGmysm6LDBapC/bhvW+n0TWwT3QTv0pBKds8qOvY+3S4Sf1IcIkUy/kKt40VanzhrU
         5tLe7RVFdwB1iJ3llSGndXpe+lLy7k+vaSDJtCiNC8n0/ZGLlkNhBRwwi1E7DbCW0V//
         atVcB1+zU8uvY1zaKEcgruGzDlQM95q6INEXE2VIFiC0kmy0+RfXiTVMG/3jpGBrKSSe
         jlxQ==
X-Gm-Message-State: AOJu0Yz8yO+2uRqnghnNxlbg305fkOCb9wEboCkyksaOLOousfMuLTNl
	yt8aRoqbEwwskDqcoCFkfue7HzLARFqDD3Ug8xbhlKpFcub4wBrzIEekaAjwuyH1fVU=
X-Gm-Gg: ASbGncuzmsHf8rbRfcC0+YJhp6/Zre7tDKIkrKxNTSW5Qep14JKYzX5XWSnVi4/h8gb
	LhR2hkUGTcvGc8jRuTPYrzcy3gVxztjPxZY40kRWD6sBz/PkOa+0j+OWIVmFbxE8oT+lHeOKgHq
	QXQO2HZRj884WP1QMDKwzJAkrUg95YntCkuqe+cShBoBI8tpunwzFs52m59BbPkMSTwR4P8pXU2
	jQL6GljllRNziv6Toqhwf3wzrpQJ24lM1b5StLum28i3GOJbtX+FhSUlO3pSHMkyLlSfygsqHmm
	+GqtkToCX77Bhg54n0AAP8hCmXDEzKFripG2gUDB6uO0zl6qt6Ivx8ZLVtL16x90AP4wqJaz993
	FWs8VdXrhItJ474IlO/9hZr4eUqrQmgIMzYI=
X-Google-Smtp-Source: AGHT+IGWCoQv8jgv0YHriek8VPPsKGGZClBOcgF0YLzARTTz5XIpyx2mZHmSef9NietX+UdPwGY8Wg==
X-Received: by 2002:a05:6e02:932:b0:404:5e3a:292f with SMTP id e9e14a558f8ab-4045e3a2c31mr66923635ab.13.1757371014127;
        Mon, 08 Sep 2025 15:36:54 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f31c926sm9214471173.53.2025.09.08.15.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 15:36:53 -0700 (PDT)
Message-ID: <b4878e9f-7f22-4d73-9a98-ac26b2aa6cb2@linuxfoundation.org>
Date: Mon, 8 Sep 2025 16:36:52 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/175] 6.12.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/25 13:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.46 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.46-rc1.gz
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
