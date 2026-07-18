Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFC4227B94
	for <patches@lists.linux.dev>; Sat, 18 Jul 2026 02:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784341855; cv=none; b=l/XTOYX3aodUbYYjIcCrlbIsU+++CI89ztjzdkv4gkp4uq1PRRI5WRRVT16WrAVotEdzmq1pKwYrqyLgke4IU/VEUJC5txOtCwp717LQs6XlJhmfDl7JyM5icqjTDgAwVA2hW/s7LXGh0oxkU9HmL0xu4M+2otO/89fMoxVpcxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784341855; c=relaxed/simple;
	bh=96/NQgMuIUiAM5aW34TsMs8aBBGwn9GuUhMJ3ssBv+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e7Ygql1xyRO0dlXlln4pD9CwZWkjN6ssiZHqt/zhiAwIUwpV+yOZvdPmOTrQasUAHVFU1vOItJGPdPuEk846ssWM54Pk1DIK8q1Qy8/bMLgiXzaeFpqQ+lgoJP3O6eBwUSRDy56EdenOxUxKyR2WT+m9h2RJ+kUXab1A79xSt9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=h0QJo/SI; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="h0QJo/SI"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so59023105e9.1
        for <patches@lists.linux.dev>; Fri, 17 Jul 2026 19:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784341852; x=1784946652; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XxbtHvBwUB79Nj/7A4PM53e9/+EatJfE3PuQhJ7yn6M=;
        b=h0QJo/SI7onBrhgOXO5E5j658qk6FlenMAe1Q9TgVM+ggxYFtjjjFiqFgwzQv+X7dI
         dzr04CqHsU4ATaNR3yIt1ldqJNqD3IXl5vo4VmPWkr6NwU0h62BI6ihbhTLmmdp9z6x4
         YDsgXGFg/bhE1U0D0X7Qvzhexl1+jrRIpMQj7e9cfpOlo6iUgBUUi82jLrYi8Iwdv6H6
         3JCMyQCQpbNaE8XKzSCu9FW2pZSqMuceAvX2dKki+mGFbRIpOL1GDcEl0fQ46myG/dXs
         X38gnN/4X+sTiv8ICigvZ9sWNvlRPcKVHW1J9WeHrj7F2lmzJvKgvlhXk/n/6x3A9xVi
         wY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784341852; x=1784946652;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XxbtHvBwUB79Nj/7A4PM53e9/+EatJfE3PuQhJ7yn6M=;
        b=LYdSXKupC2z6/f6BJNCyInjqX3srLAfs2nEpZDebtI2rblvdz43sPBti2nXfZVfyqn
         U/sJrgJEQ0MI+V9mOxq5hWDNcH0Bxo52e/bcRhfbOnDCSklTmGHHGklDoaQnOxX4lhVX
         RZm2x7dmH/CiNeRV3UY49ZEg87NrmXCRcvSj7c3bAKNl81Z25eoLe1mAvQM9ZwqEsE9r
         3JRiOmyhg5Pk0OBMzBMTq6+Hml2h7AitbWOHukrp8HsS9UGTBVK+QbJrMnGmbmxmFvu2
         vTP8fL/war9Rj7cTNR+ep4m52+B3qcHcxW30IPjpgHstPqBzthL2WD5351Nl1oiuKyyX
         PfYw==
X-Gm-Message-State: AOJu0YxHZhsrnLsjpiBJCL9Er1mMxLutJsq3OH7xK8lKxHBwbFz9Btaq
	VxskQv4sPmVB1AzZcstUIDBc/0DP44YqfAWSGEUH5IfTq4TGwMgHvcg=
X-Gm-Gg: AfdE7cmNeUUXfyIrC6xgkmDwooePyJWyEb/rI54bRRrS1L38r4lUCZ1JXn8/hIOZXuW
	bp3rfCvZmFquSc/XGFQqVGHlND24xQWIDSPvRbLdn5q9uyviZSRIN/sc3Ud4W57T1cv+XiAiBoN
	c7AqgSPTtPSvUBqs9bShfKfd9sIrBQAy3yJsCcldragmnm90VZo2hx6VHqXR3txlSnSaPWVbkeU
	vuU147ApeZOGGhnWLJ0poygqAOBa+4IWa/yHL8msUWE17z0jNHUR8cpNFDRSBAYpGtnzzrOrEHJ
	Dt6frpHVDIm9R1UhiiGc1rzf53WG2tu82fcAcvfpwxKmvwZQVOkE4sB0h3AoYvceIOXqWnQuJoN
	WsHSNIAs8oEsMnJup/Jrqub4uyxpnztMgCvhLBriMSSfkiFW6SnaN09MGvO+tavJLw4qYxctaQj
	H91o9875otX9JennpaoHt/2NSzXKv9fhIxkE2eLfuR7bhZN4D8H4OnyQ==
X-Received: by 2002:a05:600c:45d3:b0:495:503f:cf9a with SMTP id 5b1f17b1804b1-495503fd2a0mr10440885e9.9.1784341851853;
        Fri, 17 Jul 2026 19:30:51 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4ae2.dip0.t-ipconnect.de. [91.43.74.226])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e496ffsm8993154f8f.3.2026.07.17.19.30.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 19:30:51 -0700 (PDT)
Message-ID: <119d2276-71d5-43a0-bded-a0a79ab68abd@googlemail.com>
Date: Sat, 18 Jul 2026 04:30:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/495] 6.18.39-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260717101904.922623678@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260717101904.922623678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.07.2026 um 12:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.39 release.
> There are 495 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
