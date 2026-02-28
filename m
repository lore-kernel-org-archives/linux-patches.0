Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF6939449C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 22:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772316842; cv=none; b=nbgi1TizwREPGqkdf01FEyda5PwmrsDY6aftCDIzFU9Lo64lZFH6uidyLPMM6nxST/sH/nvl6fipKJ2v0SULLo/dOjJTIX21RX2lK+uv6mHCbTWgCYVyjgYd5DS4vZm1qRrMqbT1iUagZb6jfIUxWr5ibSrr/qWLiOmzjvA7DBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772316842; c=relaxed/simple;
	bh=YmaOwhLufLLr2rHqj3svb39rppAI7BngrthP8I4DUSE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=N9tXTsG5v086fAMgnyZv6JDBSUZgZQ4kVoPpuTN+0AUVRNSjOED2JLJkclrNs/eZ4uQ7A3fOshzxsNAYTT7dhx/vGAR0laPaDvyYrHo6XW0hmMcLwPro/MbFLnQl541bAXuUAVpJo1P93+KBlSvmD9dFZOTmQZhIPkQsn/6J9xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GwHx8FxT; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GwHx8FxT"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8c9f6b78ca4so435037485a.0
        for <patches@lists.linux.dev>; Sat, 28 Feb 2026 14:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772316840; x=1772921640; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nr1P/0C2nV683CJOfzLd7UkpSzK419t46a/I54eghlk=;
        b=GwHx8FxTAfUGvxT1XvmYurjc4F5gDXwTajPeI+XPDNy3aVbQixXsQxI3uM4a2ejnaQ
         6LBgBWiIc6kWr6Ohbfc0lzLEz0fWKkrYlOdlRXoik3u8XKyl0c9Cj9SHgH8e43/zaz+q
         LjQbTY8B0KBImaasvtoTtkaCzRlrU89dwmUgMtrMCF/gLPeMOftjH16SgnAUXe+F4GfM
         DivzUN/LRpTRMD6vJjF0/bSHoLbDZVufnh04gpfiO+6hKKQny7pXKVdAKTkn4H3iUgw0
         pasbC0sHJ0Gzh/+8DkKtUwJDU8IuqzxL83Y6RjPr44GejVQXNy3JqwhTbXOzp6fTJG1x
         3+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772316840; x=1772921640;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nr1P/0C2nV683CJOfzLd7UkpSzK419t46a/I54eghlk=;
        b=ez0m9r8QdpK6w4xtK+A2MyKTGHF+GH6RQr/I5xMIUTC5/KNOnoSGBze+yy2Gmrx2BA
         Uuf/0fYGoTr49/5MAOU+D7RReE0wPjYlPaBRCNzvy4nvb4mngGSVs7gtSDx+b+ccxcRH
         UAoiiBgTsl/HLQb1ky66T00aauJDWCCaNCyYw3wX3vJ587C4isZOcyCtpFKjGouTagGw
         LI9UEODCBuVDPAWU7mk9xGg7vWBSfXkTQolN62pbmpw40FbLIBZemE8N2Cqa5eALhG5u
         kCpugIROTuidSAZIUQUYiPW5j5yfUhgLIdIxhsRWGXap6h0TiQxr1lZ9RxyYThvm6C5B
         ALPQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8/VVzigQ2rm4APcyxHx0lj+bB+2p3vhM6e1wreYD5WCQjv1QevFqW6YJ7Wj0yI6Ah8qxVOBkK@lists.linux.dev
X-Gm-Message-State: AOJu0YxDMxFzLKOwlgdByf2eYum+LdNdMLs/nuxGnWu8aU5O5vVBYm1w
	uJ4hVHkoydGKFcxNUAT3vAmcPNpEKQmobOwfr16R8xhmLq0PJm6jGFE=
X-Gm-Gg: ATEYQzw2Jw88dXlQ9F6sZEmtJBsHtrCvyIlrJOgwn87+A+u+UWvO+8t+ZC4pHjte6zJ
	PmTnjPTaAuzNeYHVaFj6VT9ks6mDkAGM9MPoYC+yVJJjX68dF63eolCy9GEiOytiQIrzE7IpTem
	ijfO6Cw7PxTa7yXFLmsm0BD+ZG88wCOfFuZOoHB0mTcnJrWZRg0FJMk0qix0kAucCmKT5M7jS7W
	MH2QSrfOExHRzAf7eh5Cg3X3Y2oYi0sYBYgaeWjCOUCgGU2RLGA2W1gi0GnH1chaTiCCzaKijfn
	eiid/hnRcbiFRfMigNbNfst3hm+pGjmmsLyIgX28lVOpeIiCD6WcTGfYttwhnLgDwYJLgILLlSV
	0yEJbr3G6ok9X1Y1GyffFckRt8vVWe4Kx64dt6qxg87da/hTCMOKVX2VDA2RxGCrRe7OzjW6OG1
	bsv+VvrUd6xHp7+IM+O/9YazFR7I7yfL2X4aRfnBMlwN53r+3YRUg=
X-Received: by 2002:a05:620a:7118:b0:8cb:4059:a90d with SMTP id af79cd13be357-8cbc8e50bf3mr964752285a.38.1772316839779;
        Sat, 28 Feb 2026 14:13:59 -0800 (PST)
Received: from [120.7.1.23] (135-23-93-252.cpe.pppoe.ca. [135.23.93.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf68a0fbsm778891485a.22.2026.02.28.14.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 14:13:59 -0800 (PST)
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
To: Ronald Warsow <rwarsow@gmx.de>, Sasha Levin <sashal@kernel.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260228173244.1509663-1-sashal@kernel.org>
 <601576c7-970a-4e9d-af5e-c818740be8e8@gmx.de>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <879487cc-c667-8cc6-4775-02c7de3b8c27@gmail.com>
Date: Sat, 28 Feb 2026 17:13:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101
 Firefox/128.0 SeaMonkey/2.53.23
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <601576c7-970a-4e9d-af5e-c818740be8e8@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Ronald Warsow wrote:
> On 28.02.26 18:18, Sasha Levin wrote:
>>
>> This is the start of the stable review cycle for the 6.19.6 release.
>> There are 844 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Mon Mar  2 05:32:25 PM UTC 2026.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5
>> or in the git tree and branch at:
>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>> linux-6.19.y
>> and the diffstat can be found below.
>>
>
> It would be nice to have a download link to an patch-*.gz what Greg 
> usually provides.
>
> ron
>
I second this request. Trying to setup a build for  5.10.252-rc1 was 
tricky...
We need something similar to

https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.251-rc1.gz

Thanks, Woody

