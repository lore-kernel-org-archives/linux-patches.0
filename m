Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5023845BC
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 17:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776706197; cv=none; b=o59KpTUbGlxXrf9CDt43Sr8HUQ3+yy1YtqrM0KY6CR/Yo9maef3QqQWnxbCWThAl8M+bPewOFzW3yQURsdr85+rpbJTPVmCz0MqMscNHfomu9SbAx9w0D2fsWofhZqvH6jyBu8GDjpeqmerJ4slgVgwkrz9/y2RBbtsNnFM/BSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776706197; c=relaxed/simple;
	bh=+zMHH1OuUVOyg54abTRiUwV+WqcpKPdJm1dryC2JxVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6DbFG1VoRgf28TQupb3l/eEzzYXErxAwejzwzG2g1M/y4qXfQ1gssxNPZmkAIAOPV9zvzeUhxtPpacB9G3P+DmHxFvBefWvbZbl4Fwtbj99gTeRMlza5PFvxvRjrVdMiVHumbhmZAMyj936Qu2M/uPl6SWWyN00MStKoGsjaUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xz+D/szw; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xz+D/szw"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8d4f78fc9f6so364214785a.3
        for <patches@lists.linux.dev>; Mon, 20 Apr 2026 10:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776706195; x=1777310995; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fO+bBXRTOtxPea508BmdvaXLzqp4fRXR45rPWVIOwn4=;
        b=Xz+D/szwjVu42bryl4SzqjeYHnJaF0LPMHdajqAHpOpU3wpXjN+Wcd6caPLReIvxP0
         xjC21JjN59rJXMzHxOeO0VWuv6cbOf/FiODjHlhYWS07eP8zEyRrVWe8DClGvLS+yaqe
         xNFwuAy5mdp7CKT82sryKLH6ycgPDKn108NZ2roFwIiqveSbrpS/+dJzU2o7CYOfzlsf
         a2V++usIM+4JyT2Q1nQpEqUqZ6g6ar1jNRo360X3S+rRQNXaUnpBT7qaAw1mHe4F/tyi
         AyFT549TkdzE8LgtepaTpKFFTUSxVe4FK6B+IG6cb+kwU+6aNOgYFcP17aivUHS+IBPF
         f34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776706195; x=1777310995;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fO+bBXRTOtxPea508BmdvaXLzqp4fRXR45rPWVIOwn4=;
        b=dUy9NE6vMPOPx3tCryga+F7DnjAsCSJoa45w0pD1dEBTnGdn8nJ+dLWx4X9s9PYXGA
         OHIS9I/CEy5H9Zv5BKcj/tPZlqJTayNDu/bLpSKJmzwi6liLrMtcPrt5gTU5jMctWjDw
         bcfl9EKhzkCAFhSy10TLTo7KIVSUtlGPvalQ1OAU1axyfOncqNH7ytFxaKsDnYzPynQB
         MAn3cuMUHRszcOhykZDUIbtq1YFOH1+W2mzKC3wHTy8Mc853bN7TlWirN5zy7fXtPFQv
         Yir0Nzm4VTAcGeM4FTGAXAIZaaAXNAZbHRYqUikdOuwxwMO3le2UssmU9ttSl9jObGBf
         G+fw==
X-Gm-Message-State: AOJu0YzWVdhameTqrBQvqE15ranYDimYEek3ezQ0lsN3iQLHHeqj4P5S
	ii4bVStFsaK3ucbOBxFmy9TFU5L9GRqnhhqUgbIz7T2P/V4EZD2E1+dI
X-Gm-Gg: AeBDieuEi3gQ1yxsC2h3Vd3U/bApX2g5lC2t321aAkkVN3VbuguAsprhuX7cxH52vEi
	ojeyvvDiQa0jt0tajEj/6ZpB1TVAYMxBf6mxTbsvKA0IZGcGfvXBT+hWdOM3XxY5379gEIvRPEg
	A387Nzb0QWxfEd+/pyg93ot5r7DWgy3qCtmpBxqLGoptuhLlnhz4ufBent0+TJlaFiNZE+zXTAV
	xf4/iuzPd08tL/KBhX7gs1HUgkrGWGniMIGaq7Q+KvGPJUIcaSPdaT8CSGt18JDIJiwwxuUcLBS
	D+OEEWp4Ftpp9O27eBoUmppe5rQ2TubDJdFXZDvUXgxE5G33dnfy2YEB3JCWPyj6nVA5V4bb+jP
	o3AimbTl2yeeNwnaswGYaHkJ2L9F4wW3MszBgXHq7DPkPclI0n54pCg8aqcJ0JShp8vpuSBGZkJ
	eDCAy1FtdVeGKVjC0uuBUUcqE/5b3buqVopfdmVH2mQCg/hqflfu5Jp4oT+SdK
X-Received: by 2002:a05:620a:4623:b0:8cb:62c3:3690 with SMTP id af79cd13be357-8e78f443268mr2041220285a.13.1776706195110;
        Mon, 20 Apr 2026 10:29:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d64caf37sm836657085a.11.2026.04.20.10.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 10:29:54 -0700 (PDT)
Message-ID: <044e7684-2522-404d-8516-63ebb73046e2@gmail.com>
Date: Mon, 20 Apr 2026 10:29:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/198] 6.18.24-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260420153935.605963767@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 08:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.24 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
