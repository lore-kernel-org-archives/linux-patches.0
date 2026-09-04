Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63EE3B71AD
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 21:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788556328; cv=none; b=PlFMTWDfqpDKBTuLw2AY7RtnMVPE/RLAYX5SPTj8J3Qf5/JLJ7sB3YgPvaskKCUhqXSAX0FWmwHYy/W6qtoLOvRkh7Ux09aul4/K8eqCz9wKQdAriC/3OrLNNmr2ahp7HvPWMTLyAoAjK/KYrLRIpYani+mQ8RpA7xio8zlDHDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788556328; c=relaxed/simple;
	bh=XZ2O6+CuggsNKjJUiXGcVa4gfM4JZiv3nmeSny7FCe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BzRL+NwMUF8mEulTctfs9SsMq4Wr9yfGFiX2ZLk2EpgDfwNuq0tcOBTgyAIVOad289P3aNGOpX2WmP/GacsdY+qg6o7RfrBCcdKKzz9rizUOduW+3FDwyjLsH2wFhLGkAtjvBbAfcw/tcTHnSIP3z4+Dhwy2EC1VSZGKSjABgkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXsh94vW; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXsh94vW"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7f4f3683fbcso1670226a34.0
        for <patches@lists.linux.dev>; Fri, 04 Sep 2026 14:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788556323; x=1789161123; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5AT5dBqnr/v+Pip1Q+2K4mDw2hDT4rcmlPRVl1ccW1U=;
        b=OXsh94vWTbeuoEUSD5TLEDkWVU9f9o/Z+S884mkEJdBNZVZOaow3ZBcN+ZfpyL71c1
         1SKwjPw2wKglx3z6wKqbwW0wnfmhV9Cd9iYKLjVnko6YAsLiDMWaYSBsoDSxkAhrSL2W
         RxYPV/fmceAGV8ypExsjEUz2l1cFOw291MdCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788556323; x=1789161123;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5AT5dBqnr/v+Pip1Q+2K4mDw2hDT4rcmlPRVl1ccW1U=;
        b=Lb4Bb3NqBYLjd/twu/E3Ttn/N+bO5EEdCt4EtOZxSNs6Xr5k1awXzOLsMNfFOupJko
         ey5FGqzsxzjrYxsz0Qb5a/7gj3LRJn1yHnUfliEFDDlR4gHGInx18bwuWU5Lzwsor/07
         u/EbiLyw4QcFGbgd+j97ftEg/QfwMgfcf8f2dHbZpph+1KekjZ8hLWuYRY2qSJCRq1sz
         tVs6RAS7Ta1WKmu+v4gtHPf37QUB7KVZ6QxxzuXXoRorO9sG8fDw5Ls2T15L+LVn97tr
         lc5GlPg3Ua8Xoi/VitZbf4MLrCaXTTzmbY8bD32U+Y5bH1inSe3xHfjIPMxxRcKRmenk
         tu+w==
X-Gm-Message-State: AFuF++moB8n2GwCo0WyW3uEAjhSBxPni+4Xk60X7+Y1dcUy05+s4fyi8
	zeDChUj7XS8EORTwvEocyODX+qBe75eDs4CM3+FUsSHZZ9LgO3lyBKeYiMZFrJ/ywZ0=
X-Gm-Gg: AYBFou08cOOTDt5nO534GfrVuCeCqZ93Fjl44LbFk3a1n43JVkMTnDjTHcKJNSA1F4f
	pDsR8oGRV15Xuuis6kjwxmZCdjeThQLT5DhK0w/IZBA0g6EIcBFuOAKVYbEdgYsS8W85G8DYn+k
	LSQpMl/U+Amt/atd6RW/WVzL8TZHafzEQbCZFQW4Pqs1MpyVicrcw5VS+5R8c/ygRlsyObPdaRH
	ig+7gMyWIRHj4pWn/D2/YIVFVVg5ALKCkX9u4wryeYN7ybYxKQym4TWC7iQ1QsvmSOrOyaWFfNB
	QkZJ+d3mlT12j1izPZj71384tx7pv54SVDGWAz08N3DQ++Sntfwi15kcbVj6ASOZwVuDor1SZCS
	OkXGt0nsR+GDiqQ0XztxkorA/9BKHS2/Y3TIZe1DcNomB1YH20JZb94M4gQDaXMx+t/LA1ZjmCU
	6sWXIQELboYXWMSlGoQPgKsny0U/Cs2oNswOsjV4K0VXZ0VMvj0dYU6FLQFU8AIE/dfkxnOQ==
X-Received: by 2002:a05:6830:4392:b0:7f1:e04d:fc4e with SMTP id 46e09a7af769-7f899a8aa7amr8040035a34.2.1788556323643;
        Fri, 04 Sep 2026 14:12:03 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f9f7aeac18sm4031241a34.25.2026.09.04.14.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 14:12:03 -0700 (PDT)
Message-ID: <82febd53-023f-48e0-a0b2-c5da95f069e2@linuxfoundation.org>
Date: Fri, 4 Sep 2026 15:11:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/403] 6.12.109-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/26 22:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.109 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Sep 2026 04:56:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.109-rc1.gz
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
