Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E521DC9B5
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 02:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758163042; cv=none; b=rk6z1///3HkexTryJcpUOXxNYXUErT5GANQ0lHRs3Zpvge/iIxPRdDtlr5Pco/nPoT9dsNc05EUOXT6qFuvWe50V3CtdgQVfXnd+8JxfKAsPeErqMN6WXSM40Z6NEN56fTfwQ8y4qKOE+EWkm70R4NXxYjwiOwE1xRU9IHnNfJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758163042; c=relaxed/simple;
	bh=/RmeVzKahHtJo2SWCXkMHvjzkXNAmF+g49TikYNX4e0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MzYJ/cCNz5cKh9e71oCU57EXd/LqWOFZZ0GPxu/qvuBACQbrOHMyfrXknkugemXQz/05yZP+ji7PKTu7qfHgyWS49OxxblO/q4MTcbvBvk4vB3OvgHHfo9BLg4wIM/liyMc7bvxpEOeEa6hNwZVv+4KHYmHcfZST8/++jxZhiSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=VLc3qSSS; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="VLc3qSSS"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45cb6428c46so3538975e9.1
        for <patches@lists.linux.dev>; Wed, 17 Sep 2025 19:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1758163039; x=1758767839; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fjmfvrARMUerFTF/Av0OXp1QJYcVrIvm8qLnxUg6tnU=;
        b=VLc3qSSSfrGcSTXioGEz9J1MWZP15luHqpQMzv6y8CoTdf9xyjjI/2kCcIzwa2T8Tw
         b/Tg662HIYo94WVqSvB36AVCSs9FerxFWtc9jLXs8WiZFAPSIqnihGKC9Sli9tgI3Il7
         cBcGJRlZfQXuFVKoJmn4Cj9uKmQL+FYW2E8PydVMb34wzJuTpEDsaXN+yZKBFyTowBbz
         PjTqQalZbWwD1TPkJESCTqCDiPXxSXASySAkOQx0CWr3Ib+fiZARIo22FFvcgzn9dGDI
         NFWm7d25IiSN1QIpE4b7sno0FEmE65yCrBVombwSqTSpPkGfXPHrXjLm/444E1Kp68OX
         NEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758163039; x=1758767839;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fjmfvrARMUerFTF/Av0OXp1QJYcVrIvm8qLnxUg6tnU=;
        b=OC3meUup+i20zx7zQTKd+YZx9QBhDf0/vsIijJqALlWunBo0zZTBl5iiijMN5VU0my
         AHXcr25RyObIv1JMx9J2jQRr96mW6F3bU+Q0u69jMhpAFP3TAH1qR6qwwooaJSyCVH6Y
         qcC7hoUQygUZa3ho2ZzSzI5o/4MCLczOBQVssUhoWIEKF3sU32HrVGZbeEqdX/O5o4tF
         Nx08xEP9oq6n6G3pcpRj9qzZ2xzfpdcxAltLFmkKgbxhRvPm0y9BFKNut7B3mvmpXJT+
         kVBVKtjNXR2n0rIzldJQTtoNzUEyAEgXyhsnfcS4zqFEKxaWUvR1YUW+Z51V/aNZl4MM
         CzJQ==
X-Gm-Message-State: AOJu0Yw8APl9gyibNl/1rkYi2VKMQdLdJc74pr7FWdihb+rdqElOBMFn
	3CK+NEgEuFVTE+82VUT2lqYWDYNQhM9y58RMISYan9Hao1rsrHqIYPE=
X-Gm-Gg: ASbGncuSdVddSKpcQGeomP/I/iGybwqKer3q8SBtPN5oVXWhE9TP/HHI00CH8iShKl0
	kjpfyntdIJLzqRXz76rXxDDpEekJs71Na7VWIq2KDLmYNjexTO+xcAZJefBN/KLSSzkGs9gtrAt
	e9oWEGn6ZJIY5Bx8K/uQuFznkdJnBylO7Kao3nKZ1xIKqiUsFBBgPCNfeyZKlLXIp1+nCiBXajc
	e0ixH2l4cTZI3HuOW7rtlWeQI1EkM4VIcL6Bxawyi2QJzsiFtSEkG0ezNHvr0DNzkJQbPlEaHzk
	YzJPD4NrtRm0AdjpL+aCgKAK0DvNvQq7zVuCzMOShUnNfYHzuhiG5XYVvBoX1yvcvI5i6Lzc7f0
	len5totDJOagBwrgjoN/KBc6VnekAZKO+Wvaf2TmwoTP2OpZvIO+9Ay+9w4qlV1Y90//pOLMh6n
	IoA8bRBdqJRKtidLR5iw==
X-Google-Smtp-Source: AGHT+IGn6j1aWgeloupj38mFaiQ67C35ZVmcCQIAnn87KrIGpYLIopHIpRfJigBwx5QOkKjktWdsDA==
X-Received: by 2002:a05:600c:4686:b0:45f:27de:cd22 with SMTP id 5b1f17b1804b1-46206099d94mr45865045e9.17.1758163038940;
        Wed, 17 Sep 2025 19:37:18 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b40d8.dip0.t-ipconnect.de. [91.43.64.216])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f64ad30csm19916375e9.23.2025.09.17.19.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 19:37:18 -0700 (PDT)
Message-ID: <4ec95f82-da65-4764-9a06-b2de6f06ec00@googlemail.com>
Date: Thu, 18 Sep 2025 04:37:17 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.16 000/189] 6.16.8-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250917123351.839989757@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.09.2025 um 14:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.8 release.
> There are 189 patches in this series, all will be posted as a response
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
