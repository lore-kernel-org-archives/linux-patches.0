Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794067128;
	b=zHtUu062avKefnDGARAzF6+35oSPsmXc+aAiUDli98GlHtPuqRgvLx4T5diEa3uWeEaH
	 8pr9wk01b6ewynopy+C5OT7kDKPNLiywCEXr89Gf3yEuOf8EESbEvtmUqtaB37H5jUX/3
	 by461C0B2LWuc1xXDgoP5T+MzS55wZJsaDkKjivPfV6wI844ekuwXHXCGOZ2rljmrGvzy
	 dNexyQl6wG/h0YMGwKmsUkHZjITsKSxOyZj5/J2r2xe9lf5jyvoKDu+jctyXxFHzm1s9W
	 wci0yAfQGqJu5CjBtLidfx0qiI41AVw5QcWdVFgf3hE2bGISErBDylZq76wGoWkJHXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067128;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=8bVkydg8cUTlVFBihjSzL0/TYhvgRpZwbeYZE1sq6Y8=;
	b=WBsoWmNKGmdNySTy+ak6/1Oi98aeh2c9Bj7Vzteb0l/USWFkPQUlGjOkbQEP85xodAfW
	 Q9p+2OphBS1D+d4aOzDy68PXUS0jqk/WMOkZktcbwPUZyC9tc6g9wS9yr54BgjOLfSaD2
	 ZyhCciYupeOpOqNnuyoVAtQ0TLePdyQM0kSXOfPgx4E3S914p+odaumpZp0KLKaX6Bhfj
	 5JOmb5bkOfia4r2I3vybjIl0xsV9WGUSaQ3sCvEJLoHY1j3ono3PaBXYnb7Z4RXzS0W6n
	 9c/OjF4Gar1635GwubRwebBSp/YOjnrdM9LGZXIzBpzKtnKsrqmPdlCge9SuM+R1RAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=KFTd5jCO;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F5A606A32C
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 15:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61F5A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=KFTd5jCO
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so14918955e9.1
        for <patches@lists.linux.dev>; Sat, 07 Nov 2026 07:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1794067127; x=1794671927; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8bVkydg8cUTlVFBihjSzL0/TYhvgRpZwbeYZE1sq6Y8=;
        b=KFTd5jCO9tIajGJz9qwBu2iUehEUj+TWMlc0kuBuyGFbQB9P39yPkKrgwiuc0Ki933
         dclZSKc2YsZrl2wjwhdn4q9RS+z4e2l/EqYA774cp4kqvlGj5nerDIeuDPT44Olpzypw
         f0TFeX1OnLdBQSidccgfyNi4Qe2e/bx9Iz7bkovVdLb9RFSBJxg161CHPmeIEENg2FZl
         /u70joV5KZIIVBDLhq2oh+j4HuC1ZA3HGkaH/5CyifUeNxKVBUQZNIS0T1do0ahcmemv
         o3OuV2wiXV+ho8D0JAHtWN5BuXqrWxXZ490IC4kMFrQkOmlGTMCrp/bzRTDOSLR4dNJM
         QzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794067127; x=1794671927;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8bVkydg8cUTlVFBihjSzL0/TYhvgRpZwbeYZE1sq6Y8=;
        b=pL+Ee2T3srk6LQ4EQglTRZgXy18nDvCPt5LCW5OtVBcrIhHPrl6fKMkjsn59gnjjr9
         /IeBJpQK3SIK0XRtyDglAazrxKHwfND6ykr1xmn7z5vMbb0FetmsfvkeFR9Owc5XEwrC
         RxA41CeTSiMrDgs8kr/RZcWQNgGQD2OIl++Mwoy2vLSnRAF/vhiFsFGmgOcyGcV7YzTN
         dTIUkmzpZfrNtP+P3SmcrtqqrW711rUtcM+4z+5Mhdhs+8CcVAweOCt2v3+qBKyszvfR
         3Uj0872yrxi3zgKPEHyTUli1xBkk3/3ZHsP0MOpEn7O9bxuUoaPo5I5goKyf3VWPm+gy
         36JQ==
X-Gm-Message-State: APuU4Z/uvNnPEH9yrm5U7fHFoudi7uP35V9m4ThWNru3s6TBWLwMjaAu
	zhCIu9r8IjaTyPtV+6V4Lt6EotYVJNLalEVj5i0sCGxY17jFCm/2kQ0=
X-Gm-Gg: AYBFou137BNrGupjxWEwG+YiJlxo4WfqyXGu0e0Rwew+wV8VR+jT8X85PzsmwFrCVy1
	tHJCij8Yifw/20yYLJ5/fESZWyOIJNSyNG/MQPuRmvsNq7L7QIzHRb/RKylwygdl4eSEFYAPPfF
	z+zfCkInUmYXRa1TOy8hivq8v2zgCswO6cVoF6Z0OcdhVmPe/o5RCjPASPFM/FVT4wtdvr4jWkq
	TREg5zOZvH5TyrFCVxEU+yZKEtlIybWXJ+AXImSdBAEX/uV6eolOM9AfMhJBgyKhgHIe9e9AtXL
	EpAG2dCOz5PtAtA1AFcEeWfSXSnjKcmLW1xn9sclKblHAZDSCiXkm39tHP9fM9wwvK1f3QT6Qrl
	ypw2g7IbscVbLRK0tkRCSM+3lng++cN5btYu0JmKfZQLhfVpR6t751ZjSDmOHmdxYpXB4kdI0B4
	RlvLlaWOaJ1UmqZJrLJDZV69Z6TRvlff8mwIxCd9UEaAk9GUR7C2P6SgTElI6FS+B8/zqnUdHWR
	SGPfBKSRFOSAGDioe+JIruNeBBQlvQa4ZY7WKh1W9qtw8Y9EWOlLsRhsOF8uNEVb52TKhRSBCZ0
	7RRjWyCw8UYI3P4+Gi1EL71yZSa3ySRZp1jK8TQuncxIGz1hhNSDr+t0pu+Y2G+KI7YiCs05Aqx
	sLIU=
X-Received: by 2002:a05:600c:528f:b0:4a1:de8a:603a with SMTP id 5b1f17b1804b1-4b6de4a7684mr101920815e9.6.1794067126529;
        Sat, 07 Nov 2026 07:58:46 -0800 (PST)
Received: from [192.168.1.3] (p5b2acf48.dip0.t-ipconnect.de. [91.42.207.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7e3291531sm80634195e9.15.2026.11.07.07.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2026 07:58:46 -0800 (PST)
Message-ID: <bbf68dc0-8c55-4dcf-b5e9-70d3c31593f5@googlemail.com>
Date: Sat, 7 Nov 2026 16:58:45 +0100
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
Subject: Re: [PATCH 6.12 0000/1536] 6.12.117-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261107134957.653319350@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.11.2026 um 14:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.117 release.
> There are 1536 patches in this series, all will be posted as a response
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
