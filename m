Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643FB3375D5
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 20:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784232579; cv=none; b=XnDs+tFXjyiXZGFUDa6uuQFMu6AFQUmUTGqtzLSRGomtbhppnHQL/xY9e1b/KDjjfQwFFWp+XE8EMaFfrS9Zvmak79aWJU3v43Y3Qe4uXBBw5zwJMH9dGwpv3ogrRJIb0ncpXTWU+dPUs2yOuAA420G0cHuMtfiCi7hlogBiwv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784232579; c=relaxed/simple;
	bh=H+KIRhNgThMTsLA0M+cuXqY7CDX08Fk7i5sOfIkrzEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pPZbVkfDUUdiZgoIjpoyHimr6PMrq1Bb8EDiwU/rhzQoURfcrdAfdQ/sfl0yBRiEzOSkeBXNcMXEVvca8mZ3SwG3A/D+ceXgfh8zcF1Xd/NHWzL1RYPsAAPd613Qrde/yQ3QyQlfgN1/Vn7w57YjoZbVABd5M2CcH4wgmLOzPSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=eWe/6kSC; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="eWe/6kSC"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47dec32798aso7220618f8f.1
        for <patches@lists.linux.dev>; Thu, 16 Jul 2026 13:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784232576; x=1784837376; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H9J0UGoE+FEdlPHZ2PqItoZRXJEq8jYYBebyY842C4o=;
        b=eWe/6kSC0uzylyXRwRXrvJDX5ZRTRHBimxvwcMXQp5SXkJeLuiX0NV+e7mVdYOuR+Q
         x38FrAmRd2NX1I4NW3wdSJDz9ffFto1jRjIq8tZVwDn9GnSr9h9DlkwDVbjQKiNMaxkU
         UeY62j4UAqoIXu3ocneTIHIOLh9LlpnvUCSEen6PNGqhF1Xn6+vrgUxYVVXHhpaU8CgN
         2I1SiBO6gajIjChkzIySJyWdn4Fl5P9n1Gq2zCgOi9A/0utqQlHVFdmj6V6DDZyGfVpB
         AQ/4F1d1jsM2ka4rUqWBu71QOFnABXaYK1OfXioY/4LEKx7SxyO7qKc2BE9oTR0UjYpa
         2Zgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784232576; x=1784837376;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H9J0UGoE+FEdlPHZ2PqItoZRXJEq8jYYBebyY842C4o=;
        b=b/5wioDVQ8IjL3ZmF+EllrdSnFhAakVxjV0dH4G5XbdXpIKqwqz312UCesak1ANwJh
         +Lx3TTT4aCKBAZ5zuRtO+ov3MBkrGtCs2ZsJPpR/MwcmOItwq0Wcf0r6ighn5eo+KzQX
         Wl/TW20ZYxxIDtA+qa6R880JMyYoSLkrOcKqjdBhnhtRtfZx2ZsqYHhi3LbVouWuynIr
         r3/74eDE6R8MMRe/4smUNHDyqpxvlT2X1W5iGps26Vxy0qpaRoNIVb6GgdWUXPgNYRcN
         xwbihkKJxfzWZSYt3F984xGinKUHCDm2J3SU3shX5/tvbWQCCmfAek0OdqxAjlouYUc9
         TdhQ==
X-Gm-Message-State: AOJu0YwYcRo7I3ytMTIGquvqeks4bxsxhmzATA2P+KD06ZTNznqLGskO
	XpO+YicRPZ4m7nNn0PwrM9cOa99QmvMqElvqIHkQ4XVH8kngfjg+4B4=
X-Gm-Gg: AfdE7ck24nzfwfF+RcGxeUzWkh1VTdQZ0x+KtznZTzNbJHS17Z1ZvXtNqsVMbz67e8l
	FMG90UGvQyxBbNFiLveAc1RdCc8RLQQ2Ouequ6snEbh9hKgX3KyhSVfUP2JlJdViMv2z6oyWrIl
	LXZBroVuKf546VrRLG1OzpZf/m5n6hnp8OPdOd2ICoET6e9XEfpai7cpeJv+V48OwFF82oH/cg2
	mmcXD5B9YbNhFk5rWX/fqLbAH2uDpd/WBg0xNa8Qdhj5/PhHrs7uqJP2WeTGV4cNe3lOFNMc1sc
	pYuH3TMNCqsjEDJkQefkViYj9AjEBYfWhQ459a3TdhBBDnuxrTP5Wo13A5AWKZTvJXvao1DiQE7
	FkwhfZO933A6qllIBRqi6KwNZFbKqGMmqYKUudUMQf9cMsrDPR1yzpWoLidOmk1vgdnDBdnRSs0
	c8hN5W7fC9pJzVZf9oWsprFMUzpbYh16yrWupd+TFkcdYsGsCMkxcZCA1L7cXBCbD2
X-Received: by 2002:a05:6000:18af:b0:46f:7d90:8128 with SMTP id ffacd0b85a97d-47f4885669dmr16323760f8f.14.1784232576301;
        Thu, 16 Jul 2026 13:09:36 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b44d3.dip0.t-ipconnect.de. [91.43.68.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635c86csm27192504f8f.16.2026.07.16.13.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 13:09:36 -0700 (PDT)
Message-ID: <8b127459-4aa1-4887-9920-7debecf2658b@googlemail.com>
Date: Thu, 16 Jul 2026 22:09:34 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/349] 6.12.96-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260716133033.287196923@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.07.2026 um 15:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.96 release.
> There are 349 patches in this series, all will be posted as a response
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
