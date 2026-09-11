Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC6C44F566
	for <patches@lists.linux.dev>; Fri, 11 Sep 2026 08:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789115074; cv=none; b=u2mwfNBtz3lWgA5MT/J69gkzOwSaGAYvFWgxFTOm0Bi4z4e0ASYnoErzL4kGn3cIeMsrCPiD4HqPj/EcOZp0sJItBzjSEjoHQ+06kSkTSFWRyClzsCz5Uqw2RtUqm2uGknhVhfR1DQJlAhkGxRphMdBIUxUZtq4OiAXwZX09bls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789115074; c=relaxed/simple;
	bh=Iq+fpSyK4ILX+urSkwlTvDb34gQ3oxCb6Di9PgY+GDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bDuZDKlGVm+44DxlCZQWR5nB/1ZxMuU0I7AEso6fsm/C2/wVGfyaXONw/lEu93EVTD+uUDd0TqPXGnVg/IBYfYb/BGkyNkn0+Q1NVl8zLIBgMkLFoVM2VZ2/i6AMYhQIT19ZwnZL6l5/NyvhqkWyClfal5JBVO8uqf0sGPBBNRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kvAvNzl/; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kvAvNzl/"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49b965570d7so7813895e9.0
        for <patches@lists.linux.dev>; Fri, 11 Sep 2026 01:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789115071; x=1789719871; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2WWeljkn3dRICBmDHnyIQXWg+zBlpnH6+buSyxyqyJI=;
        b=kvAvNzl/6aEBTouQtVwU5vOpp69NDBn13Pa7Wtb/cuZtUMT4gwVyO+7ri//IklWNWw
         ygO7hTsNP+P2sGsXfVFe5QPUaw4D2O23j5mXslhNMgT2ORjQOt19ihl6Zes1YfOcShKN
         NxozVfYkZla5J20pDJm0A4WQ/QqogY9fa6r57LwLdgyL6LkUAuWsNt0uKzL5AHB990H7
         qLESmRxEjucRr8SsAK8Y5F6UzCJ1CSISPAgCnPIq+f3WRPf00KWcR0fY44qVCJkrgKe6
         6DaOf96YyEZO6/KUU3HW1Tb8Yonb/2iS+zS9jAxfTXd1+78UaRaGn8xgMV+Ttez8tyW3
         lGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789115071; x=1789719871;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2WWeljkn3dRICBmDHnyIQXWg+zBlpnH6+buSyxyqyJI=;
        b=Y2HiOv0DDEL9uyInIBc2rCRtGFdT2D/REy0O79CUU2WPsAtowSjQvs/ReDIGgkeVvm
         fCUf2lagJgrLww08f03ZVSqZ4xJQ2eQ0+cE9SyhUNbWPWyZpnP3YpvpTEgjNLwAh94DG
         8yR5S49gU8b7VdX9pk22ufcWXKbPv6UiU2fl7OGL+M0apj6Ov3LPNNGR/DNi8hbqMqbj
         kvSZN6O3MeDSjJuocOr344KUAUJ1voPrMn7y7VVrHa2MF1AEz2LjyQdfmycCkUYs5vse
         SRj/JN+7cHcWOa4cD7yPL8QnDYAfB6R2y68/f5T7pk4ZrTtWFln5XnGaOCS1HQZc2ILb
         C+eg==
X-Gm-Message-State: AFuF++k6E4thEfFhfL6Hjma8KJmG95nyet6yzC4fc+69mYzE22kBMALo
	of+k3BlQHct4m+El4mNOpSYBjBg1LOSFRs5HXvFC4rc8u9ImvYtAtd8=
X-Gm-Gg: AYBFou0lvOZleAFe/CApit/XR2Ce97yb/p05IFQzkvHn5pkK++pq+p+/GnNuue8sZqK
	W3qJwdy+OmobsdYqNaRnfXty83kTK/85dsSmTMGpWaafGpVIDzHYSWtJwkmy1N90JtOm0MlcK3V
	HIqua7dqWsY0/NzGhlV3BCL9DK3P1WoytkOXhW2OFoGvHooawt0VJMSEueOmHI1I/PbvynN9FvA
	VhxxtPrkUUdAeq7t7C7fmJP5+6r5oQCKuO0b4aSvR0WDZrPhJFvjkP+7tKJDEht2dZa5FdCa6d1
	pnuauq7lNFjxNM7mpYOT9g0h31Y/31H6GB1x6wP5KqSZNwGWJlsDVuhs9WOI1AMNOEhi8TCvpiA
	G/bShjPKXbh0+JEm0ioE6z039Unesek44SJgp2WxfHF9ldPeb10o2JVddGSeXUno4Gga5yULvEI
	+UPn/lcHohmIoVwtNlEyYvS7YvhPfLa+tRdoQE5g6Wgtj2DpmDdvinvhnq0+NPqiElHN73oB97W
	KCEQ0Y8ZojJWiLNA9+t8bAD6stGQUEvNLG/Mx7hZi4EjKSsye4=
X-Received: by 2002:a05:600d:4453:20b0:49c:fed6:cd3f with SMTP id 5b1f17b1804b1-49e619c4d59mr22948105e9.23.1789115070582;
        Fri, 11 Sep 2026 01:24:30 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace69.dip0.t-ipconnect.de. [91.42.206.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e5765152asm88890415e9.11.2026.09.11.01.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 01:24:30 -0700 (PDT)
Message-ID: <4a5a443d-28b3-4da5-8749-447ea5b009f2@googlemail.com>
Date: Fri, 11 Sep 2026 10:24:29 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260909134230.441546314@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.09.2026 um 15:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.5 release.
> There are 556 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
