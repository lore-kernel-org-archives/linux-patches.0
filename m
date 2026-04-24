Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66BE3CF68E
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777048144; cv=none; b=Z6Nt3sinSiXf9njzxP+GrYLga1Xjxbo8SJdVXxtFa/yZ/iQjkB31Pks2y1Q8JBJZ5IMNAn0mkkqkO2BTrcMdcn+1khYiN9c9OqZ9NMWvUjW1IY5VJ0T1Zg6Wh2ElxsZs+JYhNppnJAma3VaKFAkZ2lfmSbODTRuO+vB5pi3fop4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777048144; c=relaxed/simple;
	bh=1nKL2oUmGdFElAVXOdfIRhy2LrbQY9k/pqlm6N4/zcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kDCKPlo7bvZ5qInFMLtV3U9AMhyZeQbi6hSIyP5gco+JIUvyz7HHZqTP/pHqutCSjRQmI3RxhDmJEW+b4o9NPTlZMmM1/e/1Mjgw+h/zh4oRsZoPpZnBw3wEY+QYip/OjxQFN7GRfAeYKRzDxc8cGwFDRVDIZVzl9cNul5h1G88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=q1ZWHlqb; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="q1ZWHlqb"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so75032845e9.0
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 09:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1777048141; x=1777652941; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tOpTivbmVnXoG3/nyUEuEllGt1YnW5sq2zo7Y2LrDJM=;
        b=q1ZWHlqbkogh9KP2VmuQBDj4fGOgv9gEJ0wcRkOOZN/04nKD5MQzhD5/+/vaeHmOQ3
         eUl2jxR2d+M+n7/SD47cLO6Px50QsmdBuSar0Y8Am+8dNjxEUgvhCYvHt7ScdKRwyLKP
         M3ggclsRrj0OdtOHElu8gugtnPXb6srl2iuzBZsSeZt302QistphSqHa9q2I3vdsSiio
         7vuSwvhkL+a+ELcd6plv0YCwOSOxCB19Zi0sh3Jh1xs5lERtk5DOJNBaqxAyJgADhM52
         dbNevwFdc4XqeX1QrGsuJB1IwOYjGHqTEpVyA1T14VFw9oeivQ1zyT1tZaBIgOIIWsKW
         FgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777048141; x=1777652941;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tOpTivbmVnXoG3/nyUEuEllGt1YnW5sq2zo7Y2LrDJM=;
        b=mnJfkSHm0rPA/l5zeKOLifjTlRAFUIR3l/QI6YfDxuBYV04t/eBthFLG4ujrSZH+F0
         MgBCgIV4GwjCUaltueXBko65GMtjAxcx3UwG85Dfj0vYDtw2Fix73GGi/O++c/p54W6A
         xWQ9YmemFZ3dgMdhl16x4Kppbcj3eRmu90tZ6lrMG4x4uWDa/NZYd4tTmxswzVkSWn06
         SHK5H16xgpN6yuF1vQQGxKZmNl0706STAk1wU85co2+WnGRBtUuiK95XDRaLJmIii/uG
         XCXXSczFrxjKxbeDpK2GEjyCujbWy8166/jjKgDhsvxUv/lAqHkkof4oj6VUTicz12SG
         3n3Q==
X-Gm-Message-State: AOJu0Yx8DVkAkthlX1tFiMnGh3NRNwv4wXZS9e8snTizVfSsDGROx1yT
	AL3+degEV0i4meNnlYJbZMRE8c3GWVpYWkShxQxvEFs34aHCV7x5AKI=
X-Gm-Gg: AeBDiesHm4tnshCvXlMnBNvpB3FAUHzGUPJM+knz/twt4gQmUreS3AQtUoikdkSVme2
	mZ/JIWTba0VBeUtaeyACEMd2RGzzJWduKRtuTOp8870AjNmGaw51332vlFE6i+d0sGhxakqQQPY
	mqXIbrVwZB/muDCRvkfiiVDvMPUqwNXmfYwVcqmpSDEaSFCuVo8U/fUtHmil0eaol9qMAnt+nHT
	dqA8j/G3IsqdvgbJMKnpRxcbvrLH1rb8MdS8Hh+wAxxonEO7FXl8AOxjNVr5gbrLxOqrd2JbGd+
	Sg0AeLsbzW9mpJ1IOqXKDcH638WzQxnGtTSTRjilGgWLSNoXePIIj3NrEbhEss+5EzQ2mc9C5bD
	m+vsi4w0U9y9K4Hw8IT9lccn7/A0HzlCNSQpD3HSRL1HQBkSSoTPwCLbuiVqXkgWPqWZRXiKjED
	suooxJRzrovt5Tcc8DRj5W4TL7UqWbRlbV10yJLby2obOJWXttgi966mTJoCFcwbLGSS1HqAgRk
	Ofvxv1OR3XK
X-Received: by 2002:a05:600c:c085:b0:488:c530:48a0 with SMTP id 5b1f17b1804b1-488fb784843mr368224975e9.24.1777048140999;
        Fri, 24 Apr 2026 09:29:00 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4e21.dip0.t-ipconnect.de. [91.43.78.33])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc0f8188sm636115995e9.2.2026.04.24.09.29.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 09:29:00 -0700 (PDT)
Message-ID: <c9aa22f3-addd-49c5-acc9-309c24fd6677@googlemail.com>
Date: Fri, 24 Apr 2026 18:29:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/35] 6.12.84-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260424132411.427029259@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.04.2026 um 15:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.84 release.
> There are 35 patches in this series, all will be posted as a response
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
