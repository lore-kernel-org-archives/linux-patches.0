Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B2A181334
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 00:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772325246; cv=none; b=jYKVt1CBxDeCqa7/PdtlSnAy8hA/RZP6aBAanrhxLlOLmVELxkEmcRCckPl+VcU3u1H2YvVPRsFiRCgR+PFu6/SnZVYa2nP+fgsNca6zTUiYV25zcziGae79b7J90ZyZyZdLBkSsxqJguMMRS3E/Rev8MS/BKc36Qp2kQvBIRYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772325246; c=relaxed/simple;
	bh=1LEcsRNj6W7QfKGXFVyJg3sKSKg0hTbKkMXJwv8VOqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BKSEYE4cNwzvxC+SgPl1g1c0tNrJ8NcS9NZpiDRZ5cMeZI50Ml2R7+O2la/odW8WNBsTRxORtF27K5HRZ2WR2Hqwnh11jQs53KPVhdpj8DaWyaSNkKDa7HUwQmgxTI/RVVzOkQuby4cuNXTyI7vDZiRN5Xb4GaG8fPoTAi+o/Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=at5IU73Z; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="at5IU73Z"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso28495505e9.3
        for <patches@lists.linux.dev>; Sat, 28 Feb 2026 16:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772325243; x=1772930043; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OTKmHwe7U0QcTuk12cC2ddvY6qmz96Jk447O+dG9kOw=;
        b=at5IU73Z2/n9t3i1crsX/84sCGzEb7vU1L2+ptLOsSvpfwvN+JARHGv9fPPMvc5S5H
         3gwf0k8kkJvlpCLzNWtx107iB0eIo+GQuPH91pzvgIaH35OMNzH+yEqwReWd/giLLU9w
         kkkPmpEqvi5I9+SFqDIF3BsJN4pXlR3eObsJItapZDJeI9n2lceVdIZiufT4fN4nfKhs
         3/jKzOm2WlWpGAQAGRzr/xFAWLiXGJd+q4q/2zw1NASi9rfTziAFQnA95bti+GW4mSC7
         S/jkwQrrVY0DnelJCrXP1/qwrpnup5hGumgnf+7LNrHv38F1+DYbf39QDZOZ4E0/iZYk
         1dig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772325243; x=1772930043;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OTKmHwe7U0QcTuk12cC2ddvY6qmz96Jk447O+dG9kOw=;
        b=uvUD5w0ICTMq7mHTPK1pV5svHtn0OiiRI0d7vh64ebAK68j0CHnkzlwz+XFR4syhFU
         /OJB+JmcP74ndwEJY8juX1eu1HFqHecy5NZubaJskvxAr8yiWN2N8GF63IRTTGGFOObh
         +TLdNIVrfFMoM54b27PV2IgFDC7HJDb3biJC2EvKpgxUkESKW9yiZckSqDCN8o6310u1
         Dcj5M6OTVLgRJN8tkKCrAxffRrWRHjXuAA+elMJ6VpjVl9Z4PSVMEFqElJg6tW+ZXji+
         IscqgIyWtZyYWAw1d8wwD/AxGMKylQO/gXtSpGGl2Fbab6uSEGPeQlT/lV6JjxnQOQgL
         DVZQ==
X-Forwarded-Encrypted: i=1; AJvYcCURWV14njbBf+kfvrHukR2c6QTqVliYBNxjhgh/COwh8hPugQJNNjFZdxhel3wWRr9rIjCvqniV@lists.linux.dev
X-Gm-Message-State: AOJu0YxcVqCj4XnVgxrt/Enw1jJAx6Wtroav+691bUBP8qY/GsE2FB3p
	nORDNDXPo7vY/uhhiJaqpm+xTzi3gy+SHDndyHKnAt5brwX8j3jCn88=
X-Gm-Gg: ATEYQzxLg5JQ51b2MEt/+JPFzam7sUw8I9lIVFLKssLha+cWhul0AIF3EQ1bYdL97/O
	8PGpq9+6xQv3kG2ZOaR+4YmH1+pcLCupGUC4+3d5QTUmaZS8TmEbE9hQle72TQUUJM1UY40+Azs
	4OpRBK3cPbHflKptx7x8TVt8UgrFW4lA37sa7PkUdNhBlJWSOY3ftQQtLyYod14OrX192i634HB
	9HLBoHUBOAa+lbPZmIXSTmUCpU6pFiF6D8L6ilmSPmSN79Qqxf1cRAWrClp33UcFnmzBgfihvtE
	48Hls2WN2klkzVYktMeH+wR0cajr75Y6flSGJQyltjHac/eLxFAl3rquXCFAOXeA5tTCTfJxChf
	O/dJnZE64VqQBJS+F8e4PP3dLTW4WV3CCn4xSNKClTE0LRZ5HIkb9/k+ZFa+36XceuzIBo9L/tg
	TAh4axk/+V3mKRFZJcAGgdk7N6vII0a6Dn3y1j4fR8uE7K8JYkPR+xaHcuxjf+96YRE3+i8/7Ns
	Y2S
X-Received: by 2002:a05:600c:444d:b0:482:eec4:772 with SMTP id 5b1f17b1804b1-483c9c2d742mr116402265e9.32.1772325243270;
        Sat, 28 Feb 2026 16:34:03 -0800 (PST)
Received: from [192.168.1.3] (p5b2acadf.dip0.t-ipconnect.de. [91.42.202.223])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfcbf5fbsm94449025e9.18.2026.02.28.16.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 16:34:02 -0800 (PST)
Message-ID: <04f01795-bf36-4fb5-ae6b-c6a551ccf518@googlemail.com>
Date: Sun, 1 Mar 2026 01:33:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
Content-Language: de-DE
To: Woody Suwalski <terraluna977@gmail.com>, Ronald Warsow <rwarsow@gmx.de>,
 Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260228173244.1509663-1-sashal@kernel.org>
 <601576c7-970a-4e9d-af5e-c818740be8e8@gmx.de>
 <879487cc-c667-8cc6-4775-02c7de3b8c27@gmail.com>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <879487cc-c667-8cc6-4775-02c7de3b8c27@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.02.2026 um 23:13 schrieb Woody Suwalski:
> Ronald Warsow wrote:
>> On 28.02.26 18:18, Sasha Levin wrote:
>>>
>>> This is the start of the stable review cycle for the 6.19.6 release.
>>> There are 844 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Mon Mar  2 05:32:25 PM UTC 2026.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5
>>> or in the git tree and branch at:
>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
>>> and the diffstat can be found below.
>>>
>>
>> It would be nice to have a download link to an patch-*.gz what Greg usually provides.
>>
>> ron
>>
> I second this request. Trying to setup a build for  5.10.252-rc1 was tricky...
> We need something similar to
> 
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.251-rc1.gz
> 
> Thanks, Woody
> 

Do you guys really still use tarballs and patches instead of just git pulling stable RCs for testing? I'm in shock...

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
