Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A5B37DE84
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 12:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788266389; cv=none; b=RwlQxjcHzzJP9Rcquzv4ptbYVQz6AsibR5ty5n6Hax1W/TP1fe24ptY9daGGhTBgKIS1kuvWcF1HWTEEc2qUkXEe+Q7vgGx1r2RRxODNpuVYEuNgRs9kI88wfVeN3uHtky1uqylCeUwH4an8zsizvuNQzieUfaTJzcg3VCepsOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788266389; c=relaxed/simple;
	bh=R6OTu3ZLedqJvq4H6JK1yo9FBxwZF+raP0p8sBoRneM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l1gpBQC8NpsZlyVNFU3O/Rbf4dlrmmoyOmiWXQsWzAeXjx1lknOBlPQCYMXA4nNgaPYVXvHR5HP6U+rOmvi7kT2F0pX+hDnOpVagPjr9uW3U4X3fv76oopCxfNJvr9EcdZOtM3D47KE4U7mFhHhOdimT4BNCywNJuYcxC6pn1gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RgJRO4aG; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RgJRO4aG"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49b8e527d63so9309555e9.2
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 05:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1788266386; x=1788871186; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U7Q7YynkXMl4i7Q6YSpnO6DndhGuxWYKw0DWUs4lEJo=;
        b=RgJRO4aGAVbuF0KvXWOJrQEsAMWLJ8adIW9x9Zcs2ypGeSPQm6GVpryVJtwpceIlsa
         7vrNW98c5NHsetlg1GQgoV5mX9Im4w1Wxi3LidSPAgrgGRtXUjx72lb2E4+ckLqxcYWk
         5Ae0HMWhd062mk1ukDNVSL7aDrAUQTyBEiho8Le9qRS3BCGTVdjNCmzSXLQCtI6xLTOP
         k7WyG2qJ1YigqD+cu9wqw4runWH+Ze2JwR7unCRyGVOd9SIsxBLVOqUvqOW5h8NiAl97
         fE46o1Goe7AAJ+ll+Gy98Zb/wBJa4v0XfYzjljHM1iRuZNsO1hOgQRItVuO4J502j0F4
         a6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788266386; x=1788871186;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U7Q7YynkXMl4i7Q6YSpnO6DndhGuxWYKw0DWUs4lEJo=;
        b=IM7BnuPF9Sr0DX2wA25QPfjV2WBHljvZJ9XbpeOfXyncKQOwgsKgZZ5ZR54Rho4VSc
         4B8VXr6wGxu2AJfbPy8BX/zuU+SyYLTfAUauO48pjYcvW8+TEeMALAQeFwdNp2B4cCVM
         SkGCmCbJVJ/ATvY1Ij8UQTIhoLWP2Ka8AJ+t3Mf0sFdyz/VqfaM4g5ygINq696KYGgIp
         2gHSvUMX438vjD12DmwQgu3JkAzhvUK/vVwJylydZ8guPWh2hezv8kwbti7e2uOcnFSF
         4bIk7SbVhcDncFb29jWke6otbTbFGPGmI0B2h89qbQONv26izgzW3Q1LCd0vIGjjbtAX
         Kv3A==
X-Gm-Message-State: AFuF++l9dUtp5DdYxQaF8Jj83/0+MzgOQX2T8NxtY8awCIUZRBaVPupG
	y4aByQgkrZFkh37niL1iQmgiHRyokO3XHxA2cMp+ir5LVka01ubaUwP/eR32
X-Gm-Gg: AR+sD121URxCT/xkC7KeNctL0TSjdyr4ZHsTBfQEstf1qV+8F4qWwq8BBXI/Lyy+TBg
	ynBBUC6t5c3Iq6m3QRJDaH6wO5dB1VJgqBPB8Nt5yrY1d461HjdLWH1L8LCt2u+H0i+OWpg3psF
	xq9EhkPr4Q/ZuK2i3THzNTJ0/UGtbUAC4cJUNLY1hgLMA6CCAJNOTwVXWiztXmLIcpgqKE+hQEY
	H0iyRQQIdtzn898DR0nrqOUod//4jeUSlK+HM04QfsTEGEGP7XGLjsXAYBhDkWEomu4X/21Q5Cj
	yycpBEUKo8WQ+manRCBhsJM9cLfugI/ooMVAmnSD1+nlcQ3BJUTWuirJ+wQCnvhO2iQVuxsahp4
	QGWgSQnNG84aDo/qOFkS132PuJcn025ZgJX9LU54rzjC+z8rJKb5ZejCP9SqBNDnO0X9FEBs8Qg
	2Nv+hkuksA0KIkq+fmQZdunUEVGlHJFOgjOFNPEQwORCCqV81rvIuXxdYZ8Y9RVLiRRJ7PJ08xx
	ir79vPHkOWakO++4xZN7FcrM5iR2beXlYfqSlif2AANMhxm7Y4=
X-Received: by 2002:a05:600c:4fcb:b0:499:db27:7b1 with SMTP id 5b1f17b1804b1-49b91c62d9bmr508038395e9.15.1788266385542;
        Tue, 01 Sep 2026 05:39:45 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac7f5.dip0.t-ipconnect.de. [91.42.199.245])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48442d3b86dsm4584243f8f.11.2026.09.01.05.39.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 05:39:45 -0700 (PDT)
Message-ID: <e2926b70-c2cb-4a7b-a02e-b027f731b968@googlemail.com>
Date: Tue, 1 Sep 2026 14:39:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 00/71] 7.2.3-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.055927882@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.08.2026 um 15:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.3 release.
> There are 71 patches in this series, all will be posted as a response
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
