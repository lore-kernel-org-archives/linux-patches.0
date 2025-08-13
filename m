Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96A3189F43
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 01:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755049670; cv=none; b=f5xUBZY+Q5z+poZBjdpU4CiHWAyhBChx53/gatg0vmg5G1Pias5R0Ngao19az9LcuGuR9+q/hfM01Dr3qOV+zSI/EYogn4flWh4sZgr7gzRavFpaGUlS2PCKQVehhlO6dkzkUNIq63+165MpM9vWM4lxkA61JomvR2RdtJs9knY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755049670; c=relaxed/simple;
	bh=b/66eFoOJUGYGtvk3i6mg43Rz6p27tLfngWYdwITtCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j0KpPE7w/hbNZrLiIJDkJwuJjVCtF7YeLL0T2iaWGv2nvwXQneFtbC3Nnrw3HCQ04KQ595eYnSQZ02mWLWzB8VcTW49OAIFjrU+LLDKGpPLfHkxA+MHN4zA7s60QVuYHeWQsxXOXbQ8H560lf1k54xk0M1Q67aOUZ3y2rH5frns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=GhpjQ+f4; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="GhpjQ+f4"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b78b2c6ecfso3236576f8f.0
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 18:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1755049667; x=1755654467; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uFH+WA4WMIkgA/NoGfISBdvyTY+rxVB25tf1bF3uJSw=;
        b=GhpjQ+f4JCurre59hTxesF6N6+PFI1SlPElnWUHXTiExJDQecnQKS46GgSvFydC/zN
         Rxt6KjnlkixZ3bdR2rALNeY8J7jilawIZr74D/HO3wclh1q14EmX8n7nPZQIflBTz7Fd
         D2cga5qSzjshERJFGlNNa6vU39dcyqnx+IQXsUK/CbIEcR2+E1THhTw1ZO7pr0doiQLl
         outi8LP5HFWB9TKCHlCFfvr2TXwGJIXOmTC+qFgFDE3cUmmjRJk3RsDTTQsOu7S9tVm2
         gmL6z+0+0DBlD9GSFpB2GcotoEh+n8nFWS+1FKDqoU4ni+Ozhxq8Xrm9cvOHFMiIu05v
         LESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755049667; x=1755654467;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uFH+WA4WMIkgA/NoGfISBdvyTY+rxVB25tf1bF3uJSw=;
        b=Y9MENDh7AnrFQAUecUP5KITi6YuDiTBW9/b0rUdPlZoVs2iaCmeZ4qDDoV9ukh5/sO
         Fs0JeWaWbAw58XFfIKGayouPBKfzzWSXNeERvPbCsI+bkYKotBx9MLrRJFBvZoqtcAdH
         XYKdVwe90z1+wROWYIMXpuXpZ5c00/3fHbuNXHeYlIl2mgDBT+rCo8b5dlC9gs5+GxVZ
         Dv/YrnYx5o8Tjpg3aMbwyu2AwVhwMpRxeh2qFl3ANCMEejYTP9mLoyE8UOxeuX/FXPlt
         hKQ9/s1nRDmogtz/vtf+igfb09fp9qSGU5WZoUR9oXoPGlrrDfJUJBQOKIg9cgVIrkrz
         BxSQ==
X-Gm-Message-State: AOJu0YyywC0gQfkFCRHQ06l87Ln+99vyQMPRwhFSLZYT7hvcW/NwQsHk
	LOHu/AgLy3iyy9XbbLqFIo7Kau7KnjSwmdPQruCo15cat16IjWhvDFw=
X-Gm-Gg: ASbGncvlWU+4Ua1wqQN9ELKu98GbK14yUmflj9ttpZNTRV5F5HZe9K8yNq7oFuHwZpE
	3REjstp0e8tznRXOkXS5C8TISyGY+O/oE6Q+VJ9Ca/vT/wC35pFBYB+695CowIMypu8tVl7Qnx7
	YCm+uWAn4c61+0my4ViLo5Ei9we/ColWukotfbC8QeLCEQ36Czk82taOTWitZsN6yuYwY/HkWWu
	x14YW9DwXtmHhonXOCHd7RfAG1KYgE0VPzm5xf1M1662mIuIV1/1Cy7YvT1tnXxAdld3JN5Dmeg
	KUC3gVOb6jW5tav0PEIlIJqHweOURpgBA/NTHnMf6vDKiyvSRxFYxoBynuNwj0kzNZyZ/Di6hVr
	nJ4AAM5WpwuRlqNj8UZ9TaNYaUzdcI1TjCabS1bae/MWr8CHiWpBZef6KvOiKU8p28T5zzc402K
	HAVCfdaL6dMA==
X-Google-Smtp-Source: AGHT+IHmPuk+3akgOK9C3VBI5YtMXx/eKKXYjDGkGxA4cJGwDRwr627rYjCbKUHzpizbCBCspkj97w==
X-Received: by 2002:a05:6000:2304:b0:3b8:d337:cc16 with SMTP id ffacd0b85a97d-3b917ea804amr640607f8f.41.1755049666911;
        Tue, 12 Aug 2025 18:47:46 -0700 (PDT)
Received: from [192.168.1.3] (p5b0570d7.dip0.t-ipconnect.de. [91.5.112.215])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a16ddd23fsm8522385e9.11.2025.08.12.18.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 18:47:46 -0700 (PDT)
Message-ID: <b9e685f9-97d0-4b79-9058-3db13b46db5c@googlemail.com>
Date: Wed, 13 Aug 2025 03:47:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/262] 6.6.102-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250812172952.959106058@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.08.2025 um 19:26 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.102 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. Built with GCC 14.2 on Debian Trixie.
No dmesg oddities or regressions found. I did not see any of the Python warning messages here which I did see in the 
6.1.148-rc1 build.

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
