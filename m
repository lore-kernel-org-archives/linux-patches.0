Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9511E4BE
	for <patches@lists.linux.dev>; Thu,  8 May 2025 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746712679; cv=none; b=O6pJJEEtbamBQjVzis47CMTK36gSuxjrOcz/kIZ71HFZ1vxyXxBthK6eoh9FOnvVP8OqICpNq40iT9xos8K85ykcgMq78yMitUXA67JwIJhBdYvi6eFWqEwV+eyMqHM78Ytg6kwaRtgWK/3olcMlXq3lGz8XWFyzzBUUcCv+fnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746712679; c=relaxed/simple;
	bh=pnK7j3iLlDUxLcmldCg7AjEszg5umwAWmK3mTEYqYbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=co5lghNXa37Xt9xsxBeapacbQiJ15LMbeD4ykWDrxzi4OHJ9RtxL0MvEKSoV85LNFyc+j177+YUTnrZLemZ46OsOiY33n8UA7CSZScQ0AWlNRZJX+BLPNgZwZlWLHtOJJ2BH975urnpVWh0Kfr3Ovcivo+t4zzB0boFpvTtlU3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Ui6ROKuX; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Ui6ROKuX"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so7530345e9.1
        for <patches@lists.linux.dev>; Thu, 08 May 2025 06:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1746712676; x=1747317476; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bc/Hb+NUmb+r3dEJSpV1YEeQoXiOiyGyh7KJhLgdWwA=;
        b=Ui6ROKuXyMO7IV/KPvkWdt+QZ7L3xoqq+o8c6+OddPEoyGOCW0nbtxeVk7fSU976aQ
         Ry2wlQoZjg4vBlYAkNLoTD+7CozuQaA89/uqU01O7q7JVy4DOY1wdUrSJ8wvpJyjiy40
         CU7Xua7VPYaLDQDvw2yOhMHizYjuFHYalcUI/sMH0ouWgdxNR8WE1xVvMVJDUS/YlLGL
         LQES2QzrTEU9QdYyElJmEcpgRV9kX0FqGrW/xkbJedKuPHBOHjFVYmRYznGuo92EeJSc
         3ofdH39ERiv4SGspq2rbKsZ0E/7Oo8NGK5uAVz6aThK8pLqhZyVy6SQLb2JIzcU0liDW
         B76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746712676; x=1747317476;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bc/Hb+NUmb+r3dEJSpV1YEeQoXiOiyGyh7KJhLgdWwA=;
        b=T1rXQ1THrJiwpM533UrLAWEM6d9qEk9b93iVg+ppEw/1bVemv78FxKRD3d3bWzBBa7
         vjeAlfWcffUDHi93Z0GyZ+gpGUwCdX8vqIPs8w8vyWTlGc5q3jp050AMiBwWAuhLTA/M
         K6YegInDndxZXug0cJqTx7cNWnxLoOzYxwWHwVjQnI3B2oxIr49eAbMiwoLJfOBvXIlv
         I8rjxekOCqyfExNNt013woXFC+hxfM/PNFi4ug7tNlRJS5Ri6XSswyQ7f8mOOurZGFyt
         OXwFxfDl283hOWf6BXnk6HnAW1VEEbW3WhdVDl2zB6fwv+mr1Y+dUKEwB/GoPdP0IwO9
         xumQ==
X-Gm-Message-State: AOJu0YwfgJHFISAWuq/wf2UbPSteLwDNugApYwqBt+5hLmkVNoy/lnoe
	0NFyyGxappgKNX3EcJnpizBHLN38LQoiArtBPP+VVKoTOGjVak4=
X-Gm-Gg: ASbGncu/9wRo/xgr/AYgBHYQZ6mv9YXfAjxGW+OO1GgAElZpfAqubOxuQo1aaUwD5bx
	+0Cdn68QoZEa3b94cjFu39EHKGyZFWzoMk11qak5saBSeWVwt/VA2qvPgN5l8A8Vb8p38E6hckL
	9tPdNOT/lClIwZInXGUSQ6kAaTiYF9wNDKXVft7O7RPHQ3xupNSPZ1hoh8gphZJR73x6Npcrrba
	9s2ovtRIGFbYFNFtSgSXH8BNg2f5rMmw66SN33zeX/fHpQLny8YmH8bbRGnkD7bzLQmbIrAeTbY
	+qO5yu+nRv2Ld5+GcVMD14LJ625K76qgxnHqUg1o2LA5WFk79D0J/ZO9/iMBA8AsFtfpspc9uIR
	v70YRsSlLZzt//oQv9Q==
X-Google-Smtp-Source: AGHT+IFFwJcze1T7lgw6hr8b0Ua/t9GIVv5voSi0/3NVOHk7byZ6lTzScE2jwlR1wJYTPP5qB2k0sA==
X-Received: by 2002:a5d:5f96:0:b0:3a0:b565:f1ea with SMTP id ffacd0b85a97d-3a0ba0991a3mr2435294f8f.5.1746712676210;
        Thu, 08 May 2025 06:57:56 -0700 (PDT)
Received: from [192.168.1.3] (p5b05727d.dip0.t-ipconnect.de. [91.5.114.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58ecccbsm59313f8f.32.2025.05.08.06.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 06:57:55 -0700 (PDT)
Message-ID: <afebad90-097a-4728-ac16-5081225f8cc7@googlemail.com>
Date: Thu, 8 May 2025 15:57:54 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250508112618.875786933@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250508112618.875786933@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.05.2025 um 13:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.90 release.
> There are 129 patches in this series, all will be posted as a response
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
