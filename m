Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737EF2494F0
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 02:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760755389; cv=none; b=TOBHQhq2PyEXFCQt99MUr7n8xeYuYZPMFwUv5bjKH+5jdPkNj2ENe6ra2vikZsyGAAqI6jEvsKjNBk0vLuFvWyTwo324ksSk1LWlW3b8jB6Unjd+OZdWkT+zBpx6FZrFj8cOZD15AtSSYcvTpMZAaUt+xpmbPcmh3ruaGMJXeNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760755389; c=relaxed/simple;
	bh=+b2DvE7xTQ+YplYhEJssLncHPzlO3qrdo1+/WrFFXQQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vEnlYg074BKCSnc9SJsGxgAMCar7eZpKVn0uMt4J5PEuYEGFH0c8K0Yz8bPkmbCSfYtxyTz4Jq2jQt5XnnAnG+/VGxVPwL7q68VTWq2BNqe4GPqNO0WIgunaigV5Jwu+ePzSqBZDfpsCVZO+nZ+H8Wv5fsW5oHEbxBwrztTs5ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ADZ2jPDe; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ADZ2jPDe"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47103b6058fso18381765e9.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 19:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760755385; x=1761360185; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KedOym6ANAjmntB6MdnT69wUxSKMRmT+YO6XJ5I6B+A=;
        b=ADZ2jPDe76xNtXpUj+hBIEjhx81WlzKspJWaDug87gBg2SYQsaj/KOeMVEO6KYcBEW
         63D21gWryKxvNkZwP1eYtbud48OT5ZK+UsworRsDDiiGV7eOhA+Lj1uq19RAr8hKvEIR
         UfMHC/V22kn7hmrtoEYURs/jldnmlE8HeG1UH5hL19S+dCq5tFqHePeWWlBsDgyxIEeq
         o3wMZNQc1PbAnLNhq+q60koujQ7vVTTsZToUTe60VgMBT7Ts+GaJLsglCopB+apB9nVW
         vI7taE4lHtegQGM7+cehgzQdk1fJnUUYLUDV55qdifArNZ2JviTZgxnhTvVnz9DvVaWy
         Pb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760755385; x=1761360185;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KedOym6ANAjmntB6MdnT69wUxSKMRmT+YO6XJ5I6B+A=;
        b=WfrfS9CtFo7Nrfk2IRzW4tvGdPSC5ii1y4jPDJ3dIPb8dViupeovt52w2XphZCXRpL
         4cNevo0VnYdFzRXEbuZGPHHqyK0PMAhgQlDSURHS1oV7ERqMlbuaXXKMowaoh3wcsAMl
         NHrZZLRg5jPA1gQ5gmqoN/NsX5sneTh1RMhhL/X57vpIsOFhb3aQT6Q42UENYuywxjzn
         VN7BQaZKrQZ1QpxeQ8RTfe3l7tPJojbOM/bTl6t0Z4FBrb3/7UGi+a6mO/mOIACkfVOL
         qtFnvTicEvtx0nUQAlRMgVfQnatTXFkWxwjQ9AZmRR4AFtemAoMEs4qxbZyHxkbCNGtw
         ll9Q==
X-Gm-Message-State: AOJu0YyxVKyjicXliSpw3ebcHNLZ1DBgNsEA9HG8Ffy0D6IsWPcU16ut
	VWRzurS27jO7fFvZcLk1OPjp9AlrqVhh7MoF1JjB83Im0KgwOiahAiw=
X-Gm-Gg: ASbGnctzEpsBsIDjZem/YCYbW2yclQTsFZS63iM8JUaYRT7QIrGW1OJmIIvHQFBz9cH
	AHnjTr+Dbaper6s+hCjqtatAkuHErSAnPqeR1cYjGjO4A/MbWrnUGp5uRNSfytnUyZ4ehjiZrIe
	abdtE94H1yTpO5AoKcvN4SDNEIhpjuTMpZkLRyrzSmCG72bRcVYu1ixv69JyEzZlzxjEIoeSUp2
	MQuTdLYgolPAxr9+7Z5fbUBk++CrPtGJR/c5jqt/KLNdbAHbEMnvv7NwotwgJ3AiWkTEOzTjj10
	X+EM0eTMJh8ektuy/HnUq4ro7QYLbQtIOx9xO+qLKE5jXcKsQ5fdpddwEUzkUqb2QaJCgQ2JCKi
	UnADskT9CWQyFmSPND9MDWOMB04No/EiWV1qlNvPTurPmxXwYy4sfvllcT+EBiTc61kTjebUl/M
	M+apsqunsw4JzJ7MgO2EnllUPqEbZxrw80FmpvWdbiNIwxhImVcqJR
X-Google-Smtp-Source: AGHT+IHJCQEarLyt9R2soYu4NGJRlr1qtMl+VxBgaRp4vpWrXNohBal3V0rIJ/WL73KWrYBnM8te3g==
X-Received: by 2002:a05:600c:190f:b0:46e:3b58:1b40 with SMTP id 5b1f17b1804b1-4711721a479mr46610845e9.4.1760755384377;
        Fri, 17 Oct 2025 19:43:04 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b488a.dip0.t-ipconnect.de. [91.43.72.138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715257d916sm21954375e9.4.2025.10.17.19.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 19:43:04 -0700 (PDT)
Message-ID: <8cc5cdfa-e25a-492f-a75d-38fa14961ebd@googlemail.com>
Date: Sat, 18 Oct 2025 04:43:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/201] 6.6.113-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145134.710337454@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.10.2025 um 16:51 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.113 release.
> There are 201 patches in this series, all will be posted as a response
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
