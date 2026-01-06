Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADFB2E091B
	for <patches@lists.linux.dev>; Tue,  6 Jan 2026 22:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767738531; cv=none; b=kHW06pANtQRwG+V17H3rgp1iScv5hECAjb0Jd662om2TAox2mILzBZPBxtv35+m43g+W8z+j7P077LFJofwpQhv3eXdNscaLTcJ1e+krjWUbelTX7SGToQpknkirBaZEbmxfM3W/cf8ejw45uCnBDByCm16zVRLPgcW/ivbIkSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767738531; c=relaxed/simple;
	bh=fiUa9+4ah9DWIuIkyw4v3FPI+9MXlGa6tQTBT2A34Ks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iQCnsObwxEKT9DPmP59UtrACHrEfUaaJrX32F9/OdZkWk3jc6bDrfgvBjvEBrpbIbrmNKIgXAkXqPB9f2gLPHGu7GTiIzf7fP/oKL6+sLKgo4pZ96i3LuCOw3JtRb6FvGlnHvjVQSzXxdbU0OVIkTnbh3pXs9v6Zd7xlWkyfndc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=P6q9E9nH; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="P6q9E9nH"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so15043105e9.1
        for <patches@lists.linux.dev>; Tue, 06 Jan 2026 14:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1767738528; x=1768343328; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BhKQiAgmpaUu7Pmj+SphJI1wQQ/oieAC9N/LlUuuh2E=;
        b=P6q9E9nHbWt5aIC48ZoBaUkYu3MgsZ5zHXo90FwS7VWlkXPUkl9FtkqBGOFaLdIPlx
         nQKtZWsSRygC+wYAGjfYr8madrTZwO/GxQDejjmrBnS6y4+MkGEJJrdU/Tl+n1NH3GdS
         jzWmVBzPotN8XOXlDmiySo7aVNhoigJrDwJNkW44I5McGFQDp0OiKi0Mu8SgWVIIdPaa
         MFeOVKWNroNzcNmIw8SZAePnQPFZtJKvhEBxo157hnO7FZPKN6nkhZWfMUTQCM2clRxy
         Rf7UUDdFeyl1Hcb70ugGn+s9qixv/PjPwgj0wn1TDK7OkMkEic99ZBF5cp+ZVO8TgiR7
         0PLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767738528; x=1768343328;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BhKQiAgmpaUu7Pmj+SphJI1wQQ/oieAC9N/LlUuuh2E=;
        b=SHKvYbrRE4A5cedbhGQ4OJWo+7eT/BOiw6KVEHss9HOzQGpbNlGOSFmmkoWp9Od5oT
         RFOh4XorskaUgWtlKmdJxHExJD0pCToEfBSNpTCq+ENdVtcViTXYBIGgpWX2bcz8YHhp
         C36mLFz5b1PFYzhZvDcEWNsaO+E6HNhbPVkFEX6USEkm5VWtYwr9F9hMhyOHHVq3eeSR
         ZYfzH4CADfaCg4OyrHb4GTUOvleKKMXHnGVEo235et828wK0Vt5U1AA8wQ8slLYtzFrT
         aPFj1zQSfR82dJmPCFRu7ah/vA1KHpDteRh/vtzhf8aQ91yUfjv3Ca1SjZGnJj1cL0dY
         RR9A==
X-Gm-Message-State: AOJu0YzCHmvThQ/YbNgNaKUDHZumXu2jliCbDixEw4pAycqZc2fQenca
	dRiV+Tc7a9F0t09pu5Afs2H3ZLH9Rz4GPaxRFz9an52rV/8grn0q5qk=
X-Gm-Gg: AY/fxX7AMTraVgmZl0792rOZSSgcnPo/oMbVPCLfk+j28KYjCQPWMh6AOj2yWRBhpuu
	toRp8KzNAMkyDO21UmSHUFbbyyF7PRYHhwCetwi86CxdTJE/s3YP3AbBaHTdp5cbMkkT9k/lBCw
	TxX+587Fm6e1gPAWkC2grJVPTGv/HtuuM2FFZw0KBEY/TkiCquh++dbzXDRtSJempqX5kffH4au
	Wj4/0Q94rlyCDszs6v/h6tzGdB9hOBvWtlyBzyJYDVVxJ6XtOLMkXicB4z83R/Lz9SXScBsDbM2
	8+WtCMu0/nYATiV5qmMsFcjyScZsXUX6HVIPOUvBDIqoFO5MQ8SJi6HdOBDsCn1bIb4mqAhHsR7
	mayqhtynAqLdgLFciY41s/iu9uvzmiep/yMgCLSU0v9gFpgzAzlHIoHICUTbWPMKE0tSe59mqNN
	oBUzEUau2ESqWe9p6tR2s+/0Cy/LcMfzRfvneT7hdMt12DMJt9cAfXq8/4Slrz8A==
X-Google-Smtp-Source: AGHT+IFTg58Hc67yxrabF4gmXSpJwCzyINMfF68sQMqsId1Bexf2elW3nlgqMdXccABqdGrOZ1P6DA==
X-Received: by 2002:a05:600c:8b0d:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-47d84b17a7fmr5479495e9.16.1767738527515;
        Tue, 06 Jan 2026 14:28:47 -0800 (PST)
Received: from [192.168.1.3] (p5b05725e.dip0.t-ipconnect.de. [91.5.114.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7fb4c451sm29545485e9.5.2026.01.06.14.28.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 14:28:47 -0800 (PST)
Message-ID: <d008868b-3db1-4d7c-b488-51d46c69abb7@googlemail.com>
Date: Tue, 6 Jan 2026 23:28:46 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260106170547.832845344@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.01.2026 um 18:01 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.4 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
