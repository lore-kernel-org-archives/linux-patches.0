Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3E821D3DD
	for <patches@lists.linux.dev>; Thu, 20 Mar 2025 23:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742512256; cv=none; b=lkBHnETtQBVHCjwnjVFbz46EE4FbY8dBSK0t6ZKE+BzCQiE6HTvBkrhSCJPDOJjr4sSvWgOjPqhInUPVbHJ6eQVe5++j6fa0XH9ZDzf3vQy2U0GNkhRUznuCX3Zday3VrAAvg+ow0op+QjnhXClC/eeLfja4iVEGS1ktAXrc8XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742512256; c=relaxed/simple;
	bh=LeuFxJWRVErEEIX1icP+0d9XKI181Pws7o9XD4Gd2yQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hKVMfkgAJT/xQksTFLJAMEK0E53P7x7jvE5PI5v7pq29kIri9MwiTFnhkovDh7LAgNwWA3t/+1XHxLuMTn8nLXtTsJ9olkHtpFfKbijbqanws00e9JIkkiAFOArf0DtsUuykD0LfqxH98tBsIAaNvWgvm54n67y3U/7fIF1tXIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=JJEKZjC3; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="JJEKZjC3"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cec5cd73bso8901615e9.3
        for <patches@lists.linux.dev>; Thu, 20 Mar 2025 16:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1742512252; x=1743117052; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wgGFGfd5rkD2ZyLqsgWmDoGcBUZ8fPi78OPp2DjmGO0=;
        b=JJEKZjC3RBQbx87Fw1ACOx47rXDLPV9cTXLeEV3XbAlp+g3aO9LuMTVFNHQ4LfVTD5
         MbdlxaQb5HY3/bbN+xkokRHaMA3J1TmGUh9kQGa/PO4KdoBWtC4HEBy3kqcCxECPUyaj
         AZ+yzLTCvnKd18XIRLvAsRDJV+vRjfn1qoawf3YWTE/zvBygfnaRvkI1n4/M4iH4WwB0
         VNzmJIQaCXNzrnZu+GtCNo+4KUwQcVlg9ggEp6h6dA4joZTnS3P7XuSsdFHdzfQCllh9
         Q7oOFFLkehLXMeBYgU6q3XzTExRZP/F8YmRRkF6aLUlJ8YO4DtaPh/heAUn5qxvjwXyU
         7LVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742512252; x=1743117052;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wgGFGfd5rkD2ZyLqsgWmDoGcBUZ8fPi78OPp2DjmGO0=;
        b=CuUQiXfythUgYt6gIvotDEjCaozx+igT/xrHl5qb7Cpbxi/PwqEe7s0k2K9vn3bWax
         ZJeH4qOUVIKX+29KyfHW+FVDTNk49E1cY74tZ0qTVdTakmG+kqpLOEteWwCLrJvVdYWy
         g0/INKrNzhXoHUh7F3zTqpWXAXtnUbBOoT7uCljT4O52mtWOK7U4oYMn0MyMLUEozOVI
         zgpwlXGwDdq16YKe9x1mRnSCo34RA6kGHAelSOcRRAJFv9csbQiBmazFhl56vepwyLHW
         FrxZBZg5USBFLQceZif9AG8Loy6B+z3YVWvQx1tSJhBINFtIic8T9B/ghm6zH6wlPnFh
         topw==
X-Gm-Message-State: AOJu0Ywi7rmUp0CvoAHlUCILOxMJ6KCYm/5G4U4JEpzajH8dVblc5UoA
	raifqtkM3zJjWq1POmMb1Z7Pre409MgD12gfg44gRmlJqbmpnFaAehQz
X-Gm-Gg: ASbGncvZsZ87oe0srV7zMXniwKMe8x0BnJ0irz/00JWahLlZttaVxn8U6RXr2+Mec5I
	ouNH9yJAM0PWMbYsPExbGgrbhGyv1xERxH1EsgNW++q7qHllWoMWjM+ggvpIw/Il70w9g1KvvTk
	lVG5ibacSk5o9Dl5PGWbPiim2qLkbKyp6hzXf5+32TgwjiB5+GSWPLcGnuQrLUV9j+uGo4j4bCu
	t1lENtQ600aAwbn1DQ1QsbOTNKQjrCumL/yz64XT6k1mJ/E5M/59AIeJXtzkIl9VJs+HJ55YN7Q
	xrm9pVMpTCfxdhc8yKS8mW0vf9boYNiW61ThnZyYPN+EuVC+hmMJ9AcOlXiylBnCWYPh0UbG2yz
	AgXZgGlnPY/bns21VbmGW0qCNKpUP6ToJ
X-Google-Smtp-Source: AGHT+IHgSRQNc9Qig38LT9KP4KQaN7lHZBWnBjgmc1hZ2ApMjKgOtzBU6StHvQDTzfRESNBqk3CHVQ==
X-Received: by 2002:a05:600c:83c4:b0:43d:5ec:b2f4 with SMTP id 5b1f17b1804b1-43d509eb097mr10300395e9.10.1742512252096;
        Thu, 20 Mar 2025 16:10:52 -0700 (PDT)
Received: from [192.168.1.3] (p5b0579be.dip0.t-ipconnect.de. [91.5.121.190])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a3b4bsm779372f8f.25.2025.03.20.16.10.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 16:10:51 -0700 (PDT)
Message-ID: <4ce78955-a2b2-4084-b2af-5917a1d13d04@googlemail.com>
Date: Fri, 21 Mar 2025 00:10:49 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/231] 6.12.20-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250319143026.865956961@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.03.2025 um 15:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.20 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
