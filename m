Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B514436B061
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 02:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786156612; cv=none; b=ccf8cr5opbKNaXO1B2RRcs4hAbexo8aY3Zg8UNl1GfQ6v8lB/8EbfJ4rxAB+LMA3r9Pw81z2rxIasyhAJlkh/m65isAR1hwxQW3LhWXThiDKNRM4DcLsaSzDYHufwUzg94OKP2LC1hsC7rU5CDkult1DNWrgJYqb0Sgxg9WcIfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786156612; c=relaxed/simple;
	bh=ayl39V9jsQDthU7IaTZneV4r/w49CMyZM2LysxNqjZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ugeOBIu9rFU3jjEwhyKDj25p3PTqAeISPeD5SEaOnkcv/KN6lPgALQOumfk10ZhLE9R7xPwY2q9bXadgfNhV/nN67Es8uTl3TqL9/f712x2ys1576A3Bc0+a1SzGXQ37PC49nN78KxCU77wXbEmanRFPs8xk8YbHrmB+ygGhvq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=KiTa5vQi; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="KiTa5vQi"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4954afac04bso1545645e9.0
        for <patches@lists.linux.dev>; Fri, 07 Aug 2026 19:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786156602; x=1786761402; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6wWRjzPoteH1nOSgNqvE8hQzRiTcCSs1CVRLNPvnqLg=;
        b=KiTa5vQiZwcM1/3+0f3wufA3vZQwmdIVO+Evmezi9ixY45zPGSf/noZCeDh6/BjW5d
         MyVbIo4JwG+OZuy0gOVlWZNrCrH/r4yNDPbN3CAlrDRXhsiSQeT86x4chwnKPpyH+ItH
         KAkR2gmaStrA3DbdbvM0psrgu7LAGxfrobTYJw4JqV+90uZxylBmRGk+vM7KuNvEpMnS
         LWHihFqLMWqim7jgiL7FUh+KVEHu7L8t5vP5jp6yayzbPnvEqCLoImlp72tfIM98TXMI
         vUY+t3bRyRRZmwwOsJ8e7njtJI/ZKDdrzwDqyMSbK51bLPNlmIKRyK5O54qFhwNrZgMw
         ramw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786156602; x=1786761402;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6wWRjzPoteH1nOSgNqvE8hQzRiTcCSs1CVRLNPvnqLg=;
        b=mOQVBrGjNj8a53/rn6zSVDT2jLZQ99aIIRBsbnj2wj3FgSApzWPQlSvUrPP7I0h1tz
         PhLCHcSpZAtUZbcq8AADQydZsevi53EPV2sYRxzoWrw3Rhnrglm8a5mZlCn2w0hsUT1i
         s4QKrtN9VL3XTsNPs2KOLWc80XJkAUltXFTeVaFUDExyGDnM81Mj5k1iNv77knNxNNTo
         wQ3Ba287PIFTu/7fxeI6aOcFmXyTuhpr6zIPabfNTHf/sgayeulMwDPEllOippTYGjAC
         0XOOivJlZiu3XpD4sV7ERMYSs0PrD4yVuO0iVMEy7Dfymcavc16qS5/9KddKZg4k8sdq
         2Tbw==
X-Gm-Message-State: AOJu0YxhoTP7LNB8AG7bhv2FrlFAy1Deat6F0DomiqlWba6/VCexNfFT
	6J8DjwGOR9L41gBqNIw0H2btfV5WPEAFz1prWb7ud7um4q80NkBk/Ec=
X-Gm-Gg: AR+sD12lg4Y/ob535Z4n6SHRzKOZTGnY6KvFUlu0+FnrNg0IY/CYFrPQCd/BDGHkS6p
	8YzP6ekgBvHfFfRrMpFPFTLKTblcMcESXzf569/y0J6gPpxUohKoIxA/FWOAfbIYb9MdS98O1tz
	aWi9YBcs0DhawzNkCTvgmBv91jx5v1U+IwWAedyKTJaCaJLfaGLcXKUU6LsgfECRHD7Jb+i4IUb
	FzzB/Zk7N/zOLyp3yo82gfWroJ8epkYzWchS6zr2XrA7XDSMnw3Npi4nHuhgHg+Cg8sW15y7i+d
	Yvfx0AVo8O6n076/14jRP8yU4uqsibxSyVLdwbfVesDzD4fmfIs68LG0EYvV9IJbjD557faBpNP
	4uZccffMTGziivXOVNZe6/PfMITLbt3DnNlslKyVyjpzDu/zTA7eRZqHJPB4fALE3vS7DMBLIhE
	S9/PhK9Crhwx1bv5tKHA5nNTeaALH5ZcB1ulqCpboVXn/OHAv9x7zlB1uJTOUZuy8LjPbjPHdIa
	cnI2VKRcrMM2Z2qxImzLMqEy3y+sceZN0dB4aMg+g==
X-Received: by 2002:a05:600c:3153:b0:493:f0f5:f2d7 with SMTP id 5b1f17b1804b1-49961960a21mr53227935e9.7.1786156601796;
        Fri, 07 Aug 2026 19:36:41 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4d93.dip0.t-ipconnect.de. [91.43.77.147])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995ea27ec7sm88291985e9.10.2026.08.07.19.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 19:36:41 -0700 (PDT)
Message-ID: <f720b5a5-5595-416c-bf4d-d1e760cf0efb@googlemail.com>
Date: Sat, 8 Aug 2026 04:36:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/337] 6.12.103-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, Ilya Maximets <i.maximets@ovn.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Sasha Levin <sashal@kernel.org>
References: <20260807143418.516897842@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.08.2026 um 16:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.103 release.
> There are 337 patches in this series, all will be posted as a response
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
