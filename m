Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E5545BD5F
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 22:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774995504; cv=none; b=NnVTDUa0h9jyYVjEb0sdL9A7R/16QIINuaGigAXpm7dbVZ4Jb0cAYILCEhsWJ7nMAKkQkd7tRaAGCq9NglGJEDX2g0DNTeuW3jEhArHlAycS96LKmuZwBtOowEwU00pJghMc8FJPf4fYLoUUYZdgn3TXN2jPmV+TtP6cUBDJ+6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774995504; c=relaxed/simple;
	bh=RqMy7hc4oJQyN/p3kXm3qtwJtVNL3ksJsayaFO/NtSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t8KfmyTY/13plnAxmaCQqiA85Hus9836HLUye81+Csdgm7+avI8i/W/HH+MW+U1DjDvBwY++yaNRzYirzuwJce+CItp2+ApkfgqrWkDvxfxi0kRgHk/pyfGASdrt9IwOLS+dnlaqkbuCEEC6jmCX5nfiTfTN952epng+WQpQA4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sGRf6472; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sGRf6472"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2bdd40d3c61so5028255eec.1
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 15:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774995502; x=1775600302; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RB8nQ5tFjE9rzgP0R+hOL7agBJY75yKnaHcF1wxXdsk=;
        b=sGRf6472bp3XZ7mBQ8Z+dGI53nhHXQHFN7rPuda+fcGZ08XwaeHTjt/8cdLRMnR0Kp
         svLwQz9wte4Wg9mVBZfx68qGi4UHh9CF/TYwhhiSw9WUsl/1EQH/fyH4Te9V/skIXiE/
         /sFFqKUfBNsSPADo1QVk+af8xvf1bBEpUo26hHv5uICCgn62PqDAUnMxgc7M0D3HiGBA
         OL6+0rwNNJ1rCIfBg+RpFHCYyu2S7TuYqOco3waOsdaOMDYIw2rEo8uzec0HS4EMC+6q
         v39h2q46SoKf8agMAj7ffcoluLNfwGRUV7NY98h0YWYhA6VAWXpJtE+NK7Gef7xljZuE
         JWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774995502; x=1775600302;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RB8nQ5tFjE9rzgP0R+hOL7agBJY75yKnaHcF1wxXdsk=;
        b=fTHxbOtQITgQ2X2hDCKKdT25nb+7mt9miUycBeuV5fgxo2fCBqLtPzYXGOgshRaOQd
         diUERrYkvf1Nmbj/BHLQMznTRj/XvqHzfph0qT99E6TaOFIVg5/rVLnN5W/erOx7/sCz
         bzEy8ZVhIT48MlsC3q2kPQ9vXYvKSPdXCz4xx4oQACc86ULLyHnB5VZB52UQbsRH33NO
         rlKcHtfiTLNTwn/rY2jePay8+PlAFCKNg3Izw7fGCPgKIptRKBkDNqOIF4vT+KNmbuDg
         tQEF+M8Vbj9xZgEt5YZsk898daepmLqUEG+VR4wJPwMCu7UbQnD6wco6vv0ex7uuBYqq
         LHpA==
X-Gm-Message-State: AOJu0YwgYuwS8wmT/g+uYqYqr8ZBx4vRtVnM7P6dO/mMTfZ5Fmzn1RiQ
	Z1zzctZQ5Ljge7nBoklpjbHnTpoNkPoE5zidCLy62tNGLRrbo65p5ClU
X-Gm-Gg: ATEYQzwzJd1NSpC57SrnHtJLd1PzpXlyaY5NUvzpSPDv8Q6y+tD1zm5mGQFgnSnNE5u
	3Bv3aCZsCAMKdfyNp/KQxvjBJzy7leG18cvwjAQlwD98jOPrAmNjm3ULNVqK+5RRma2Iv+eej9t
	TQqtJEVDCG78rpTXz6dsQgTTlgQf613Mf9M7AaLH9g6BV44SPl/pW9drIhJdfxMEP4jHOHy1Cdz
	kFz2FLPeUrj/zkFgEE6rklGbeETLAdVHZ8juIQauZ/NMaNrSiSkvnmrk0oOGWETLXH6+qGsfr6x
	4R6yWqEadjFdqDclOiWYMVIJlm/5A/df34zNglTJOdHZIHI6j+DzZvKbofzeXaffTGozEKa3kG2
	u53QVYoHWiKRlCb5uBXvDQlLBGHmQajout4hjBUU0ctAabOhbWkMe7wfUSYpT1zo4rHlJxLau31
	aRoRU/tgxKVVNRlNtlQkHkkdlI3glHDW5NOlL1bEC0BNngoBwnGQ==
X-Received: by 2002:a05:7300:7252:b0:2c1:2706:b41c with SMTP id 5a478bee46e88-2c9307905efmr590526eec.6.1774995502149;
        Tue, 31 Mar 2026 15:18:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c3c68b2c57sm11894891eec.16.2026.03.31.15.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 15:18:21 -0700 (PDT)
Message-ID: <200019ee-d40a-414f-9dfb-c3fcbdbed969@gmail.com>
Date: Tue, 31 Mar 2026 15:18:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260331161758.909578033@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/26 09:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.11 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf still fails to build for arm64 this was reported bck in 6.19.7. Can 
you revert b56111d7a4642ea7ef776ae97ecb1dd2724a1503 ("perf jevents: 
Handle deleted JSONS in out of source builds")?

Thanks!
-- 
Florian
