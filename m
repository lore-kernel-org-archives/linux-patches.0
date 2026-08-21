Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC713488DA0
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 13:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787318521; cv=none; b=tmB2bWJ6YSsLxj1sZsjturUHbZBgKpbTit7QXhGpMe6hsw6WdPUBSDhSPy54oMIsfZ30Oz9qJRBGyVOtHT+ZZTNfykf8scpVgjuI6N9WrIRvY3bg7uKsBh+8xzgJ/AvXroRi66DjRG0enggQAB0OHjvmhz1KUlA6/0EWBfDi6Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787318521; c=relaxed/simple;
	bh=RQg3xA6rwb9np995dLqi+teIPepo7EW4N1UEpxqVX14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NafHpoy8Wl3btOLJSxGtkD8Lfwj+SevSgYlQHSlPuB6Jqwcb1jsMqQQsA+cobnXTasnzKuPO53Q89J+kGE5tLRzUsgcn0lIV42X4V9bLEomr/Obv1/iD7i+sFixstHryiXnficBf7ct81qf/avr0N4iq6Sap2uIv0IMFggUZJ3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=l1jfZYaY; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="l1jfZYaY"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c1c52d920b8so143298266b.2
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 06:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787318512; x=1787923312; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G3lUMoCTXIuvo/lvc/TnhyCBtsYQ1ZJf5IigNILfKr8=;
        b=l1jfZYaYIsru4u8P0Hr95CMrm+WJKmMkgY7CCm+yTWtG6HqWdJ8OWn4BRQqTalXE+U
         pCqMGvDUnxJqD/KTNONVPx0uPwESK5ytvrw57d+wBxV1pwnoTEyK56jAL5XL5hNGFpmA
         WV2Jv/QHazsX6pFh+5fBt1vxCBH/E5F9J4KT0m3Li12Ol7VVQpSu801RONnwkue41fYU
         xyDh1MxtPqT9/KtOJmY3HMQ8XTFL12Q4s944aaJt1fvjejFrtPSscSW/aQKVaF8w5nHT
         AQhkPWxG+BbpKjISHXeTTi/IAA5d96QnQchR8okX48fNcmNwtB/53kS2/2bNpgZ1iZHk
         ByKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787318512; x=1787923312;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G3lUMoCTXIuvo/lvc/TnhyCBtsYQ1ZJf5IigNILfKr8=;
        b=P7OG5j86O3SOHPhsEQTBUPJmWRLWqfEhQO/9b8RoN9Xu5xTIxmpr+J4raLinnvEmBC
         9X3vSgLDO2V5IKQvxfGIMbn3W7NG692ZB7BMh+OuErTn38VmdtZSVAM7xrhtf763NAxn
         4GhnSsyhe1AC93bEng3BjtaCM5ZbLh8FcWEXHtJ7eKdRb9YyiTJO5OxOYLF5728x+VSS
         B4TdvIemdIWjU4aqpI94WvO/33Vh0jb7vtwUWtaM0m7OgWoMflj205veSwcsxD5ZQZto
         2n8oIYDtYGZODOApxa29oJLXGwcPpTf+PTRnHDVZ0K46W6ersTEQyhBQ59bK9Wpzv+eF
         MLKQ==
X-Gm-Message-State: AFuF++lMuxp8oU5OXYlIZf2KMcqvxLwRW4VQRsqYHXOkld0MteA/qXh5
	AZQogERZnKuw+yxPQ/iBmkF5mjmVCLkj4EBjvrNJUlmmT2CFdxq9Knk=
X-Gm-Gg: AR+sD10wC2jY0Y7XThlFukD/VmaYlxfm+E9BzVVgFgDz/vJbOfdgF3aKJtLBpBo3mt9
	UThyP85rh4NydUlL2o1Yv0a1T7MDDf/t79FrJ7HInq2tXamVqhmz4b2rHvLXPu5vSp1ThGmTkmN
	HvL0GKho8LzLyh224v3TNcG2j9PU5l1aps0Xmo94ls9BBqjgg/MZ8qemRrWq08mJJigQ0oG7Fi8
	BZuHM0+sALT8eGcO4ucr8bps8wB1WmjaF3+tDYXudKVkX0RASiije8h+yISIzRyLKSCYdEgsPC3
	cwA7BYMrjagzwLV70Nnmg7wYfrBqov7c7cI5Zean9t8pGEBr8X2TIebiaLZ0hU0P6nCAo7BICYv
	k3drTM4uXMy0cMyARLUc3DV9OwM1YPGC3WQ6b2ZPC8lsveqET7pEIK6qoh+7Hf70jo3ym1l9koT
	49uLdRITri0nePP0fhMLr0Bnfcz2uBHvmYk8UO3cGSh+ppm+7+jjU7irFdhHBq4rGY1uhZ8pr6e
	hA1s+uDACm+rwivM+vhbkQqV+CXVAhESYpv7R8qnw==
X-Received: by 2002:a17:907:6d26:b0:c15:dcc6:d06d with SMTP id a640c23a62f3a-c2469f9cbb0mr613567566b.0.1787318512095;
        Fri, 21 Aug 2026 06:21:52 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac6d4.dip0.t-ipconnect.de. [91.42.198.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2458b09349sm465679566b.19.2026.08.21.06.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 06:21:51 -0700 (PDT)
Message-ID: <3a42c3c7-cd23-46d4-bec5-ad54e74028ae@googlemail.com>
Date: Fri, 21 Aug 2026 15:21:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/217] 6.18.46-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145237.531699751@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.08.2026 um 16:52 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.46 release.
> There are 217 patches in this series, all will be posted as a response
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
