Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5E5415F18
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 17:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656464; cv=none; b=EsPut4Xsjkx9xnkB+BqRPepf8eBzM8ecs06W1s3nKvo/VdojZevcLtVusWkKhG+y/9qTARk1Snnf75YHT1nTkPBn2+A56rDbgFvfgUjWO5Dn4kkMB9i4SCjT3yJFqL0cCDZQI9+9VySSyUNl7seFsyw+V77y2Fcz53XHe31K0hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656464; c=relaxed/simple;
	bh=d8T2drburGT8ZRqsnjGbeWFfC1IVmLbpFKZf5s8uS18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tU463uVy0I6feYA+wrTmaniYjxe0xLnmY/bhaWZujotzOUlbiYNw5G15PZA5IiZ0H7awQpFuOX27qKb/DFEz/FIU9OpbHNfA4NAS8StUFNQmcDFFwyzyG1updAPXQom+dt5CkktFGBsTVWMUKPePO77M/ur0v1XvV1Kuecub9A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jTO1feRO; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTO1feRO"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e602d2c0fso473945985a.0
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 10:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784656462; x=1785261262; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CahcOb8/acligSm7Jfk6afmhEu+yqZFrtttA/Gjj7RI=;
        b=jTO1feROICeG4sad57isJF50FUeEIBf5QVmUXdRP955mh92BgX8u0IBdDRaroM0jUP
         gFlgsI1HrjUVaCZkHoWDcCEuIMO4oG2uWCzxuNnFvNBvi2ZkMr2IFGZyQNUSfWGCReng
         hi2/LY6rTJ8ctF+fuiDGLfpE5AdDKyqmld1jbHEiiL2p55oqIyqtm3wpCQImieegHSBS
         pWqAG9b90xsiUeiUtuavtf+J+gkxjwmz+Srn1MxcYz/Qj/0CbL6ycWEksThjiic0JMCg
         dqGrOqQRhijY7cAJ8LB7aTK3ZQEZcdlEGsJlS1ZZXSgoIn4nfn0ZtM6SChbx8HlOE36f
         HEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656462; x=1785261262;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CahcOb8/acligSm7Jfk6afmhEu+yqZFrtttA/Gjj7RI=;
        b=tJzasnrmWBvdX6bpM0Zdfzy+V0aDWVle1MqnaRQtZ530fpHb2mTr5o04wL5sRUPSXa
         /TLc8sm/uV72uILBmqTc9I4Nwp2+dlFEDlZPmkiutkVz3YJFc+WcRLbZX9C8ksSOjDJN
         1OMewJacRuUo6CaPI88DuRKl10jeqIRQTzDtP05tH4r62Hx/mPNpJL2Lt+AOu2CCB+sI
         Kumy61ArO2TjFMW2WNI0ikm+ROC8uxnluYiXc/JXI1A1ysRvD5XCPalqxhEfV3RUpZ+Q
         xwvFjQn6GchuHmMOa6xAHIle//LlcHXv0C/2ZxBaQg/sHuP5MZBHu93FSecktGVeVuGN
         Pc3g==
X-Gm-Message-State: AOJu0Yxun/kaHkuqRHVqI5OCm1esdeOuGwVfplDVcoJIu1pw1YoSe6ss
	XO7x8Fm3pa8oyPqWuoxWId9Z2UfJTK7q9W6k1wSvLMMc1KTEnqLzc0C4
X-Gm-Gg: AfdE7cnzWSOlWp+DMN6SSbhvsMkOEb5NKhmyVcg1cn5Xz9F6LxnvFtK6TIyqPjyPtGm
	SulhG9J2O4BqeFK2ntfL7yRmi7lWZcmfnO1WT24vuXKy9DAwMFZpJhBPlyuaO338yOpSpc+/tec
	pe5whjtsm+BUZYFoihUd+IPa/AbseqwLnFwN/KYHUItYwhv73TouqYBCffdP00XhLddl+AYZkKm
	hqEZB3SsyMg7NxV/gP3sa7yOygD1tJTRiayXg7VNqIivYNMGgnmWWtUJ3/FtBp4f3Wm6vOa+dnQ
	eoWL8Zidmg/5UkwhNTk7oG70wA5Jgx9ozRY5vw/3NQC5+mwbE9WCc1RRcqhD+KeivtBbaaTwjOF
	CQbbqVKXAwp0ABcf+a+OVWksCEIurnYVF0IYr5KjPJIVBQcxaPPxWaWHt/I6lxHJFnT/amgeQsI
	UnHm63AlLASPlye7MqPS6ebrV2KpGn
X-Received: by 2002:a05:620a:8130:b0:92e:c0ac:aeb7 with SMTP id af79cd13be357-930f3021f9fmr64808985a.41.1784656462322;
        Tue, 21 Jul 2026 10:54:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b5493cb0sm1171228585a.42.2026.07.21.10.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 10:54:21 -0700 (PDT)
Message-ID: <b7e241f0-2604-4609-ac21-483b95757e10@gmail.com>
Date: Tue, 21 Jul 2026 10:54:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260721152552.646164743@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 07:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2077 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

In file included from builtin-sched.c:28:
builtin-sched.c: In function 'latency_switch_event':
builtin-sched.c:1196:34: error: 'struct perf_sample' has no member named 
'file_offset'
  1196 |                            sample->file_offset, cpu);
       |                                  ^~


which is due to 6018a2a9ff1baa45426f7a52f8ec4f7d32fedfce ("perf sched: 
Replace BUG_ON on invalid CPU with graceful skip"), we need to backport 
a490187f22b4bfae7ef752edbe3fb13017ca11c ("perf sample: Add file_offset 
field to struct perf_sample")
-- 
Florian
