Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFD727453
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 02:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741229342; cv=none; b=bZJwxKhJQfn+jVwmGSbNfgvt2LNeVSKxPIoULQQFBeKro9IKF7u6sX3TqfX2J/aD06Ay/bb+8/W0d0xyuyqf/sf4AITFSeNCZbVDJbGDc8+/6o2jc+RTOAErDvBCBFd7O0tSrIUoGOu348Rtlehzy4aLkxOK6X8EvE+IJ9VKQPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741229342; c=relaxed/simple;
	bh=q09dzrvDNqDre9BdwFglDOULg8CNdCE5thazNvCmvmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G4lkZHnUL5YgBSA88mStsNXU+X1AvarbgcIwdtjeICBzE8KVLlMS9oiYzisSpwogHPEbhMpWzopZMbEXtzeAyf5GV1a5QASuT4/QVptRZ+0DUjy8rTVSaYGA0RqbYmLVQ0tL9q1hK+c6a5s1Mj4bs96upB7JA8aV8zQqwgmmpdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RtSB1rnQ; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RtSB1rnQ"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-38a25d4b9d4so77305f8f.0
        for <patches@lists.linux.dev>; Wed, 05 Mar 2025 18:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741229339; x=1741834139; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7fJgV3u0zRIRDXCJ2t67tMuU1im7ntmeMqtmUfsLE9Q=;
        b=RtSB1rnQvrtRhQQ0JaTlVkpbJqZR7k8dpYZrg9RPKeskCcq1FYYYu2RbroAMgZhDfe
         KDQcL4EhwVa/qpHHwwLV2zMBVbBLy4mJQz6oDBP2drtV9NM6aD37/1BRk7mMPY8jVxcD
         6W1h5Ud1BeIUuT3ZzHdr5k/b6ErxZCgDrOdJmykhrCsab6yvROEiNQl3kkd+jixnlf/4
         9cvLUnQK/lirdjN0TGH4mpHjmyvElaTkVif/U/bL2ggMjKnA63zTP4aiDGVI8hDknbTy
         PqxXbCaE250GtHzEgVHDPrhgZz4lkuX/kr8oB9QEGZuO6zq8fU6z3yy1FC+P4NS1gOSR
         Eihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741229339; x=1741834139;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7fJgV3u0zRIRDXCJ2t67tMuU1im7ntmeMqtmUfsLE9Q=;
        b=aQJ3PPnQjLVF2ZB98mCyYQE9l6BUUHnC83vTGZ1IWayKoWpHFhPhsVfMgfReD+IR2o
         DttmvBNp79XXboJzUS3al5BBFb1B1vX/AVw4ZDqCeDI9/BjbnxHGafIiHAl+z/2BROOm
         URt0RS/Dz4j+M8pR/KBfx05J8oFoipSZlfOXxLITYd94C1rbhwfFf8V6oJ3to17tm3lY
         Xvr08EWgAXXdzbm0h9oYvIBEPyCoon6Pd8b54toYuCpZGMTLwvh0vJH6Me6JbrGeZy0A
         1xIzu+/imuxaxnYt+atLPEWu11YwLRLVtzc7fcfAFwQxIqaP0POaV3a9zX2i/qKxa4Nl
         tEIw==
X-Gm-Message-State: AOJu0Ywgdp+huhdL7rJqBS05c5kZPEumSkQEytJoWHW5aVGDwpY8dAZz
	GfAxqllj+FtHsZoAb5rZgdqfiw7OX744D7VN0IVlT7rrR0mSdas=
X-Gm-Gg: ASbGncsYzhIKnbl8SqJkCI0vP/ilPCWcCXh+NfUCweB6KPjg4ynprS83YvVBd2V/N3Q
	QOY6sIfyopYNNdKWR6zqwR2w84SzToSk9wYjb/wzWxAoKEqr/zK4IfGmifePAGf7i9fpPi96IEO
	FpTrWAaqlUhXOigqN/3Harx0c4LO3Xvoz1NBGNI2wYfR/iIi06SbbjsSdelaswMRbMxid7mkH2N
	BHe0f9UwJXL8rE+HGCvUPHpqpMayF+sdD0p4GpQdgFnpvLSrLmdPgM9vIHA+U/Nt94NvNoLvry/
	3ZMVcw/MW2RiDD8WUtxxRKVN3llIwZ0ohNQm+7mN/S8bO5VPxjG/cbIsLVmBR6a23WF+nXkPnrq
	Go+KsT6J2DwrBH0l2ac5h
X-Google-Smtp-Source: AGHT+IGJ01RBPjWDQPo0JGFvHQlsX3CBjkc5BgX5rqx+ZQPPwRlCHKwOAyyCvWAN81xVHFx/C7ywRg==
X-Received: by 2002:a05:6000:156f:b0:390:f734:13b1 with SMTP id ffacd0b85a97d-3911f756fdfmr4543795f8f.23.1741229339380;
        Wed, 05 Mar 2025 18:48:59 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4217.dip0.t-ipconnect.de. [91.43.66.23])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8c314asm5007745e9.10.2025.03.05.18.48.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 18:48:58 -0800 (PST)
Message-ID: <51d1ef38-c754-459e-862e-015b44b9ea31@googlemail.com>
Date: Thu, 6 Mar 2025 03:48:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/150] 6.12.18-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250305174503.801402104@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.03.2025 um 18:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.18 release.
> There are 150 patches in this series, all will be posted as a response
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
