Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362852;
	b=BFL73IWOXcN8tKrtSOs648q+mF5+ePB6DGjufJaxSQ8L27nNtrcdrQ+LATdqFrSw59SR
	 oFOoxHYRhn5h0j9z1SPb7faM8Gm68XecwIlrfVY65ucW16AfUsZBXZMT0KjIXi9AWchV8
	 rAjIiTKvPqIMdXHjm39bp22IMVrZMqZ6JZ68NKdRqwmAzXXo05HXhdmTzF2r2Q+AFAh1k
	 9fZadXoGx9TFaXsQe9F3CXocXaXzqUklwhZ5FfngI3Gtfg0+TDygWawu8/3n78aRDiH58
	 jU/hLc/y4C7lebt6xpXJ43T9cZudwX3xOOTEao4MeVa7+DBLkylLXKTRlSD5pDvnMeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362852;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Xv0rjomnreEwJ3awHfgoaSBNl+BwH7nZQZWEX3r6cz4=;
	b=PT5Pwopf0K79gFC8WVYqrzsskkVjTeO3mhDLYBbnttHbkbgAsKSMf2iHroVeznkdDnRE
	 IWXUCKhSMvKMQEke/bZxAGr0e8TbsU2lvthW9q3zsjF2xtpOqVCStFnKXou2+Q5f4xVwZ
	 ViuqUQztnStu80i0Q3CJOcICRrDN5Ze6hteRkV20ld4aJdRtOhPzF688fq+bU3LBPSs4K
	 /5A1b4jCGCgKI6CiEKUj4IsRQgHV4ez4/lq0C+WcRyGIQodPeINglPgN2HtrNRfyuWyz2
	 RIiykMpundGhCo0ymVxJX6ZaabVH0FnzyfII4BLAP1i1cnKl0ssA7dyQnmp0mrCnn9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b="zk8pN/6M";
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C82606A31E
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 12:20:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66C82606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=zk8pN/6M
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so3484405e9.1
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 05:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793362851; x=1793967651; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xv0rjomnreEwJ3awHfgoaSBNl+BwH7nZQZWEX3r6cz4=;
        b=zk8pN/6M/sNk4Spf6Y2Yn9zbI0y4s03pNFeOnXa+/iL97SXcA1Er4s8X0cDGANIpSw
         shyhBhJMM24b3esJqkg+E/ICeWBKRyvKfd0dbH1VsRBYdKWhofHjORj/o0eYrU5o86jJ
         mmRzoFCEOvUwGfx9dShrCBaT4Unhsfl/GjceyqVq881z2PNwvBxoBjnU3CcAvvtQdgAC
         a8dtoYZMoLYqU/ju+sdwmLpyuewunZBT1uxH5sBM+RIeNxEu8sfEG2OQHyYiWXXDp7KD
         46qo0N9l5ZuszF+0KLZHr2u9KWw1eziD5f3qq0CiPrAg3EsPr6wnHmUXW1/9Qhh6Lc6d
         kzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793362851; x=1793967651;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xv0rjomnreEwJ3awHfgoaSBNl+BwH7nZQZWEX3r6cz4=;
        b=XYSowjoxJxHYJrATNuQRhysgiM50DWGalcJKOS6q5tDTJJatyHd8wa2rPC2mlIP8T7
         KICZDIuFegiozdxPGtouiSegcbfC0SQFNFGoiGHm89sgF9a3CfsAf7LvJoSIHlYTt7qv
         NZ+Mqqcj4tYBQDqJOPmVGmdVdF1+zEfTmQuhDgcbF7qnwjblDllyOz2b7pmL/Tw6PQM1
         qQTVhNDQtdiWEWQPLk+Wt/1CKK+/Y36GRHkj+vZeCug46GMlLRkoubwyiqyBLneVFNRB
         BTpmeZjawcFIoY97k8QptNHS0r9zTT5oOutS1GLfkwMyFhdk0GD2jTTW2WUSGTwJLx6R
         0udg==
X-Gm-Message-State: AFq9FYLwu+ESdfX2vo7gBfYIFuUN0M4vPYbS81PFS07bIYhtLbC7ohfc
	Z6/R8Z30kLpRVBo3xHdUdWWrmgQag8c9WhuwDRJAJ06k3AZyYGIH5JnqcUuz
X-Gm-Gg: AYBFou3sK2uFZBLqbEesZut/uIVt1FtgykOViEaIe2Avhtk5Yy0H82JUiHMowmAUyeC
	kGXiT4I80ULHzN5sZpRyTZYXMH3JPPe6O5eeRL5JfU2/04PS3ADl0ebZ95ry+O0GjJS3fD/vtMb
	2PNFWr2tvZDXC6ll3HeHNnVC8VxkmRGHRcCd21hBrWLUQRazTfy1mGAXWY0Ve4Q5+5hIUwxANqN
	33ov3C3fhexhcZuEBKkhpbAS/dCo8dPNeCVOxrjpvTNhDLBfWQbm9LDsbNp/ZWbp73Jv6B0Fmyn
	GEEkp/Bs0dFGrMH6N9fZPdy5KCpUmXB5d6ULiDBclidH+0onAzsHPSAaTuUCTHFQxQ456ldhbTB
	jSJJqz1hhPzC7EC4ODqQt0wxMi6oznCY5rFLOGERqazGwmxl53BpwrKw8/ATZZWOOlUTTX40/RA
	PbIRNu+cdo7jbq0KKKbsDpqrM+c3p95DNnBTGlCzHw0BY0Vu4+rPXbdYuVyGSeVC9jgFFTTjFV/
	1zEVM9DQsNrYJv70JxfeA+YGzfc+Ml8wHRbiTlVkiHe4gECgiv/RHsSxtUCn88UWr3CE+BcOsJ/
	HJStG8cu4db1FlhbC1RTHov4yQvE7K49rn/gVHFR+1Q4tV7VV8Mtl+MOjbgSfvSDilaDhd6R9i2
	UN0Y=
X-Received: by 2002:a05:600c:8b55:b0:4a1:ddca:8b66 with SMTP id 5b1f17b1804b1-4ac19234a06mr43869145e9.31.1793362850528;
        Fri, 30 Oct 2026 05:20:50 -0700 (PDT)
Received: from [192.168.1.3] (p5b057761.dip0.t-ipconnect.de. [91.5.119.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77c132sm41033045e9.1.2026.10.30.05.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 05:20:50 -0700 (PDT)
Message-ID: <e24362cb-bce4-4a9f-b9f5-040aaa2823e0@googlemail.com>
Date: Fri, 30 Oct 2026 13:20:49 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 00/10] 7.2.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261030121255.257615100@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.10.2026 um 13:15 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.15 release.

Three minutes after the release of 7.2.14? Really? That's, well... ambitious.


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
