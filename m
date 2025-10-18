Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CEB20E030
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 02:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760753040; cv=none; b=mza8BK0L/QVQguYOwzHYN9b24kpRgzooi661epNB8Oxz4nEZSszi/ZcbqJmMTIdyjDgBCVpDV1PsLHBNj++CYlDj6LwirJQ8/pJuqrtPAQuDepUu9A5BlSMGXq2wf4D5tmi2hK+FMndf8GBGcK8NOtfi4kHK7DGZRLJKuFuQTDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760753040; c=relaxed/simple;
	bh=9QaYv7+eLxmlZymzm9dDED5562G0eINYVtnrbZbU4q0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rr6zrnR9CJjsJGdN3ININM7ygAvlOhevqdXc4sum65vSvC+2WLRWVQOo8O9G/D3ZxTtFfTv99qTvZGuwx4VOoOrPZaZvKxRU6HjqiDN05wNwfJsIiHkrxs+zcEq635eg+0l5bCyk2EolHNGPVabE8pB3+7x7cvBcqy8aTojBwQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=dig+V7pu; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="dig+V7pu"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3ee15b5435bso1878470f8f.0
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 19:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760753037; x=1761357837; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xc59SxJSZGImXKCMLgUW84zLp4qIeFDtzUIiilJXAVs=;
        b=dig+V7puAEC2pCOjgsYrBK+v1K73JERskm203b5ziKgXT9ilHYbScQfzGLOHyYcbMa
         Oj6EdWquqLkhDT87F9U6RO6fWsIg9l/7FiK74RIhflz1tebFFMMzaVyUjJLxpahMQ75L
         wlRzXdIzgFATHteopM/ic6+2/x0SRH6+vNvlRuDwV7it+3kg3eeZVJtpX7LxwbHw/E1c
         zYksr89qP2WlyA69en0WZttkcSIdvfQXWxwfI8VDo22frAZ4CgUAEZsMYaw79HDhdYWu
         k6XOjtZr/QqSpOPUiFsnJ29tamX7DRoHaq6ex9KSwkwU+6VrMhUsJqUwhOVvoScN88/K
         JQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760753037; x=1761357837;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xc59SxJSZGImXKCMLgUW84zLp4qIeFDtzUIiilJXAVs=;
        b=QgDf/ujGGFRM2AX/mpXpTKib8b150Q8poXVl5VEZJ+8TqUTWUqWNMENxRR0S+oSogl
         Od1NigmmcwSxn5YkvG1tvrOBWdggUtnHt0+n1z3RXrVr4Dn9fFOZw3Basdd9smcYCcgm
         U28Np81nj+vj+2EB1TlSFJdqzMPd/wY7KF1wV9y/5LasBI1HkMl1BgcilnrguYkirLu6
         LhsDWZJPTMKTHt2M6lLsC4eaYAMUdmWy2Qtn+r9m7APlONy9NB/z0Eowa7XIZZEcO3t6
         RO2GNG/ilB9VZam0cG11RDFyIKWuVzXSZyCswGTiZhUnj+AmNecJEVOwrGzKVgafs6UD
         tnJg==
X-Gm-Message-State: AOJu0Yw1MNP0TjqGja6O9/sykTF8Sa12L1faL1jomJw0bgehSW3vOxOV
	qxbGS53pU4fi3J7pD3iy9e6ftQVfJwp94d4Whg/B0s+r7ACkwAVi9pA=
X-Gm-Gg: ASbGncuXx/e5tO/LmHYaXNoAw7P52qXMFr5h5JXssBMiU76yywGX56KUrdXOSbabZHr
	IX26kEioa4fPVePWdyyTDc5Kl7cM2c2irkESI0kklHe2cE/sXi2CYRJ+Td/lbA/x+NsFNEFjxwl
	iP7YHUUMd9dcSE4WzG1O9vkpn+9g6mwPmrVUQqfzFOHr9Mk5o7RwR60h38asWWcJedwK9N4Je0L
	CMOlAWIoKeNBno+uehXZseCq3F7ib+1nGrCfr2iJby2F7ntf37pBICKWAo5QzSIQ2i087Bye4Uk
	djeRybetiC/eZ4q0J21s7x101Y+al1akhej15QZcSYlzqDEHt/xXrZfT+l2ooX0ndWxJK6SIV15
	YJ29szh5vQVVifUlJiPhM7vjXMavA37DV9juk7nVHhR3A1XnPkgzfv9JU78ct2dA1EFenoDdVfN
	nqCn/uYlSF4gJZlDj5JLzrPvVIb4cNYeUOpfWEYXqn/5wpRzyb0WJoOXDjA7E7G3A=
X-Google-Smtp-Source: AGHT+IEdZrPytaqi4hsbKrC4Mclfmgk8aPsP0EiVqGb4uh1/ZCwHou20C/wosOjacHYe/E03wW1x7g==
X-Received: by 2002:a05:600c:3b05:b0:46e:32dd:1b1a with SMTP id 5b1f17b1804b1-47117874689mr44730065e9.7.1760753037144;
        Fri, 17 Oct 2025 19:03:57 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b488a.dip0.t-ipconnect.de. [91.43.72.138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47152b42911sm20918505e9.8.2025.10.17.19.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 19:03:56 -0700 (PDT)
Message-ID: <a8f56754-ec53-43fa-b4c3-d1db97e68221@googlemail.com>
Date: Sat, 18 Oct 2025 04:03:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/168] 6.1.157-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145129.000176255@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.10.2025 um 16:51 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.157 release.
> There are 168 patches in this series, all will be posted as a response
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
