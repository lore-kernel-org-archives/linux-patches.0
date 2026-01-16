Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E7F361DD7
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 10:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768561049; cv=none; b=NsqWXLeXcq0GsD86AhvOLTQYjNjr0P4QondmSEktWDLXkpJqP7jXITBzdXG3yPefKsH5C9lXiEORvLywtZ5fwzQ6dB/LNY3Suu13o9YfzsqWfgtA1BNkcT92V7DO3mzpfAcjKsbb5jTYJ+PmLnLUKc1h+TX46ypfb4bOvccb/ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768561049; c=relaxed/simple;
	bh=Q6KPtS8bMf1oIQyxx4s284r/Pyia3SrLlRaC8p0pSyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R5TbIltgaiiYChTfihl9/2QSbv/a1gKrYuifxVzqFCvPT4J2eZChrmyMqWMql1si3d6vfaezfE4WP8PDEUSe5JTd1J/hN3oot4W4JDaF8PghnEoBFoc0HdPmoOxHmSQFGCFcPWcGkziHKt3f/dp/Q+4aJT/dqhpEdM3qwSz6Ukw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ZRr+BJtK; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ZRr+BJtK"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47ee807a4c5so13958835e9.2
        for <patches@lists.linux.dev>; Fri, 16 Jan 2026 02:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1768561030; x=1769165830; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e9CJ5lCqudHPL16t4ANvhZIDowXgIqEc1GchaTXvUDg=;
        b=ZRr+BJtK7W0bdsvjsUHypoll7em1vpKz6SiPwPNqrq7zWwZCS9iMaLlg5xdXSt1JSI
         u2fXKBUg6ZzQxZ6DQpMlmi7D+lhGK0HgGWhU7meUCcVFmWHZQ+Ai1xIAZuV2VtMXdqSj
         n/NSTCIL08l73fwRWwuFm4ojyevr/q7SAy25HpKIGHqi6makPjI0Gwabk54dXXkh8F4W
         ubIYqfFfpRP31IAJ2+10bLoGHAaizPQv9OGv9GYHazy/5e3tiESK6i3kyDU/i6YG/Tix
         E6Fofc9G6rMe7fncoOeDKHWASu4h8K8zbFaE273BxhVY/Duhws6tS/iQT1j8Wpn0/KQw
         TErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768561030; x=1769165830;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e9CJ5lCqudHPL16t4ANvhZIDowXgIqEc1GchaTXvUDg=;
        b=fOGX08Vu8pTYbakCX2twCQyoF4wPo+TLjQJ2IS6hoI6r9HvD3lrUT6VMdw4//NZDr+
         SPzMBA0XtW+L2NytFLD6SJPJxcr0godUGltzV3ooZ7yo2grSG1dsJQu401WJAlNlYYmo
         +28VrCaIOeGN61wwsvtsFai2Yv5rf/dto6ZF1fIzZDVl/aosm/cu2GxUUvEn2JdrmeLB
         Hs7c7qo1KgycXY5RYQoNJE47O2zFfJPPu1PLbGbFdVxTjH8A59OyZY0WniY44hbDkOKn
         c+tZuvGB29QquoFJxYznuoBI7JdTiubJfF+C2GbkeQ9TdM1IyP0phN470YSMv95qtj6o
         9i4Q==
X-Gm-Message-State: AOJu0Ywcf2JbBefhnyjbS3LFqjwrUKHLTM0bkcVx4DbH4DC/y44GhM1n
	zdKGCZZi0p1hGMmmUYyopkS/wT6dhLPQFzv4hfGTMSAMRrIIBNq22sQ=
X-Gm-Gg: AY/fxX6TrkOUDhhiOdJqUntXK8VsN61SJflhAtZdugDICImBTT4V9hjdzOcxoE5OBRh
	tk1fuit7HAXyVqjeBCqU0vhFz/3Ri9UmF9+BcpEMwClOeU1l+HMVlaZuBmDwGTkLjV7c9oxcAbL
	pbSzTU02xGKgea75f6usnky1BR/gqdYlLCuAdzZa8UPlrvdsi9x5ZV8LH3BGUBcZUj8Zhmce6OW
	qzWfTAr1KIqQeV3wbSDHtpVGHxbT+FNV4pdarGKl/jmbxlzttPWRsnssx4tW7xu2D1foFTzOFzu
	eVBj4qJIRntVw9Y2svohaSAkAotp5NkNgNlW2P7DhLve79rIoks7gGvZJQ8o/KTTB+F+nHMG4e7
	5F1qg7vyTZ73iX/GgHWtwVHl806k/hqErG+XM/pPLfzgOzpdzlmxzvNGo7Gq7Gm9oTLAZkvVV5f
	AwzDDnVp42JMJlV/WyFg577fwxDldFGzrFo0HRpJVMwHBmN6kZB/KLTe2HbTnlWyMn
X-Received: by 2002:a05:600c:3acf:b0:47d:403e:4eaf with SMTP id 5b1f17b1804b1-4801eabef96mr22225685e9.10.1768561029680;
        Fri, 16 Jan 2026 02:57:09 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac8bd.dip0.t-ipconnect.de. [91.42.200.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e9432cdsm15436715e9.0.2026.01.16.02.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 02:57:09 -0800 (PST)
Message-ID: <5a12b63f-d518-4cb9-8ced-e3f70965e90d@googlemail.com>
Date: Fri, 16 Jan 2026 11:57:08 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/88] 6.6.121-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260115164146.312481509@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.01.2026 um 17:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.121 release.
> There are 88 patches in this series, all will be posted as a response
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
