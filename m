Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0977624E4A8
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 17:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776186518; cv=none; b=dFx6mtZ/gam4FJUNfxRuMycDF4XgElcmitlbhXLokHoqtSGl3F8f2LXOSt3TlDHDSxZTArNoBiulfA342J5q2Cd3MtboQgQGFhMl/4hjx8rdPQbiIHyMV1wNV0QDEZlc4oNRY25/Lh9V6EV7fUMWP70cIHOaVw8fp9NiOCbSYPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776186518; c=relaxed/simple;
	bh=OP/OVI7CpjABgfPZIm/5UIMSYTQVF56moQLOB3pRF+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ehs3AY3BYiTjWt+eVjhncs2DAGAwtBkBjAccan92OpV8RTq86wRdAZ8soISMjJ/7hiuY848UDLTOxnllrjYIi/nezf0xKHqeX/VQSQhk4Pc+7wsbN8MRR3l5hHYFpZzaB0SitpXivTD06kyulZbQdkG1iBCUVUSIxXxnvOoVBuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ppq9Y11O; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ppq9Y11O"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43d70b3e159so1238164f8f.0
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 10:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1776186515; x=1776791315; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ClnSBgyPlKTv0h1k+yhtne+Q9CmigaF9v1JIRJbgCE0=;
        b=ppq9Y11OM+1xeHZr3hvAX0pFjyicXPlbRCmg/SzhqoMfVWtO7E1ySDXfJh0kDB5JzS
         RzpQY/qMGvZeDmH+1fmd/jcYtsRLtUKr321QDrjv7sAruMqPRGLyPOUU7xJf02qjItNF
         pNQeflndexPVAsvQZpObSRKQsRBTIGhjMjct6qvxlAk5Yq8QfBtX5L0gIkDDg/kLVSTz
         cdVc3wdZ7tYTMPA+HN+ZPVbx5lW3u2PT9G9zhKMGFuOrPfGqeRteyLGn7OFyhgjziAoI
         0kFqLD5Euz6ffviOhQZD8SNg6mujODTrbmE2JrlV4i3HW9C+KD1CzfjwpTVzvO/H+ZES
         +HWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776186515; x=1776791315;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ClnSBgyPlKTv0h1k+yhtne+Q9CmigaF9v1JIRJbgCE0=;
        b=VWPWQvlsemXoNSEsx/stDVPfbkSGpecHFBMrBDld8DNLi8cvlaeiMSeYVuS82u30yY
         qqnd9ZDp/+ToJqkotIKRLklTRGKxiPOfbK1NlNLafSdu/wmRH0+IgoDWuHJXxbAgRvkO
         LOz5gYxf21pnYwY93Y5yE9pO2mICa6EPIvO6L0HtZRG3PoOBqD4VvXjhNQlDT45zQlIS
         28J1rgscw6h+o4v6SmkiYAuq/n9c0hYXldvysc6tiCuqDe8OHUrpxnzTT55cU6yhgR+o
         PaXpxNKStnljPsNZkRBBcqiYmdzYQ9aP+kGuqSmyQbOGQInjvCkzl4gY60Pa1SWWkbCX
         qZdQ==
X-Gm-Message-State: AOJu0YzO00jBUoOdNJu/YqhDCXeO8HscaUogt8iHq0hZS74q86pEAXQF
	ZGLaVhtwPas9FtDVVvSSaSeyhZDqOVv+n8CaUScCPJQXQPcLp9VfLaQ=
X-Gm-Gg: AeBDiets8wZlMDucd+rqhI87EvInpeHJITVWnJIlaKfabYyU2MpaZ2zgEINkkCgqZoZ
	5farE20xYg5hYeYeSuipvwTT2leDAYN0tqFzxEqOgr+yBS9cx8XFsJU+yxkypGlRIZ4+ElDSA7d
	dIwgS4a2YTmtTRCJPhWxnJJZjq5QkAppYIPXrw0TWVHrIvvc9DYnS+7BJgWA4v6aL9YJna5PDWt
	A8jTA1Sd44EzXAuhRQeOia/bTzDXIk5WESYm6ave2v9p4EUKVa17lfMnJ/fv0KVMJnpzNyB6TNK
	VCl3wA/XiR9Q25Jv7+Ut23tpiiX0Y5j19kN/6ek5g3J0GTn2BR6Le/x13EKvPYhGdxNdzbB51sc
	JTJ49l9hQQ3VqbZ0/7hMJOhXgGGixLHu73xAiDAr/Fzu2V0WHecqKtDMfrMGZ0oK7m1BIZtBzjx
	T6Tpw290pjFlAVOwOF2HaxxK6KEjZgVumBqrBpuICxtK/RsxNUTLjFJ6VOYwUUx28V3HMf2u2tK
	Uc=
X-Received: by 2002:a5d:5d83:0:b0:43d:50c:6f18 with SMTP id ffacd0b85a97d-43d64270334mr26098011f8f.11.1776186515163;
        Tue, 14 Apr 2026 10:08:35 -0700 (PDT)
Received: from [192.168.1.3] (p5b05757c.dip0.t-ipconnect.de. [91.5.117.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63e5061fsm44756685f8f.30.2026.04.14.10.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 10:08:34 -0700 (PDT)
Message-ID: <93076064-0987-4b5a-b151-f77880f43db1@googlemail.com>
Date: Tue, 14 Apr 2026 19:08:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155728.181580293@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.04.2026 um 17:59 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
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
