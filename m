Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DEB36E466
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 23:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788217411; cv=none; b=iCH0GyogGUzlTEp61BJvKrJAVi5LnFvD/fLWBVYmDMtR27QthYoUP2sm+8Twus4onmlfnvUjZb3zIYnDYqrp7IY/re6DLdowD4iTBdy2IbJn7hEyzEN0I2qucJsfqt/U0ZgNs4WsCnAUoatID7uXh9LO33JLG4xzhY9lkb4dSlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788217411; c=relaxed/simple;
	bh=bMygoBzo7zb8McpuYeDordv+b6crymIVPjEpvtSxkRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ezyu3DFRH559HEOqN2z4mEnA+L1jwVwKVIvFyBkfNmlg1XhsBWocwQF6GPfLAB//nPIruvJKh7r/OY3wtNc+9E4WWlUgsBzRi/fVz1F7pB15cuxzeIptp4/n3ZaCuKK6TnuDVS9AYJMQ54tTDMG+bPEqINOo2cnwMQpVS3Gu9/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=BvA/ZtXo; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="BvA/ZtXo"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49b0d78a801so32150665e9.2
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 16:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1788217408; x=1788822208; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gHSzoevZ1MFID9XrLurw2Vtq2FQQH1mFe/gQnt2xYdc=;
        b=BvA/ZtXoaAqt2dBfR5cjKHq+fktri4GHBNBjk4jrNzmKIcis7Om5RYCBwgb7Br4a9x
         Lkeon8UtEA+R63b8ozIOqao9hKvdVzdTVVTvL2lPbKEij6FwN5BKQP4tSO9pLqmSCHqG
         zRJV2z10FOecZMS0JmiQ7ys+uksrvzlT5h2btDoDFaBfrLEWWiv5kPmpaZV4ZmEicZtW
         FazDQ5lB3ciN0BVrefoL2FzNOK5rfP/RP78kOlQ1sM3GxfENFTcXxuGpjvM0VJbRLwKa
         Vknu+3Wd6rkgZJD5IHsvlDWRksB008Yq6A6rN+3LDNbbQGzWT96w2OSTi23Ss6J61Mun
         FE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788217408; x=1788822208;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gHSzoevZ1MFID9XrLurw2Vtq2FQQH1mFe/gQnt2xYdc=;
        b=FVO8U5NnjVeClCQIUO80t1qpVjG5L+SDZra2LMHDLfHousQDm4ePb3Ac2o1NPD7YDl
         PKyZWIfOf5oM3fscu0V+39s6cOe231KbY0pAsoAc6ZmoRsN3wWR51oM0InfEBv60Dodb
         LiZU8Mq4ydUACUqG3GI2cMVheV/ZfFRrKnhyBLe4LPii45BFlD3FTqc3XBQSG9VVnVZt
         qdzacR7vyVcA5HDV1Xv18qaLaeFwBG/qlOH6Ll9+adFHdTeB89SoKZY38krKX9CjJ7P7
         A5wQqRebw/2nteH2P4vtBAPBSpsAyz+J/hwod+hSk/z0Z1f2Kl+pbAy+a9NGNLUQCPwq
         Hqgw==
X-Gm-Message-State: AFuF++mXqlM0u0+sz0PUX1qDeqfyebEThrkOMVfzfFqd6EWg9Hybi/Jb
	DamM5Ovi+lFkgwBM1fkqQq+yqXn677ErdBLGp1nZQe4+68cV+NeJ4WU=
X-Gm-Gg: AR+sD10RDy2gpvq1vYTAgzYXmrBIQnahr6AB0ZbgB1uLT3OAeEGazCId5yKl8/LY+6g
	rRso8UegzrqIp6yCqrbhQth+g2ibTdXV/ss8yVVeqvkj8uuo+mWSudjHYyCYgZIeLMNxWJHmI+k
	qy44cF6DhNQK9jx44et+ybVPVM6XokEd9SSLwPzUw6pHL1/xBGmaewuXa6O90WY2K9c2yQw3V7q
	H3QPCBi3dppY+xMcpSf0xN708Lpbfm4Jd564epRF5nbPZKEt+tVGGyvm8CFlFMcS//ZVG0aSttq
	MYT0Zy0zZkXSRiUjLfSKg0mHolFdsEQhzinTRqqZykHWcZc8krk9ogapDwvneMFhh0xiUhB1FJg
	ujk//SsbddQcGtZU9J4riN6KmHCMbLEQKTMlzerdhU/VGn/fSxfM9VvFcfAAgvWMNZJxIt0JskH
	+Ks5txMt7ZLZT3gvcMjEnf/n2U2f0CAh3+NC3gJ64SDYddXC+Ald90HgM5qFLPKu7jwItZuvqs0
	OOn0vBnp6VlbILbv3GddCYZ3ba3xqIK66P2/ZA=
X-Received: by 2002:a05:600c:c4ac:b0:499:a5fc:2087 with SMTP id 5b1f17b1804b1-49b91c20e36mr437781415e9.6.1788217407897;
        Mon, 31 Aug 2026 16:03:27 -0700 (PDT)
Received: from [192.168.1.3] (p5b057bfe.dip0.t-ipconnect.de. [91.5.123.254])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cd8b9a2efsm118147125e9.3.2026.08.31.16.03.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 16:03:27 -0700 (PDT)
Message-ID: <6496880e-6d1b-451b-b374-209f856883d9@googlemail.com>
Date: Tue, 1 Sep 2026 01:03:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 00/83] 6.18.49-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.207714926@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.08.2026 um 15:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.49 release.
> There are 83 patches in this series, all will be posted as a response
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
