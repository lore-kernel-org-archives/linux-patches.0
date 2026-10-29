Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793243379;
	b=JE0Klw/aj0Gc3fJT/5fKNp0lIJBAeNzvUJGsoY8hHEQdqR1jSOsVKWnpgU4qRSgW4aL9
	 T6dhZXTlV+m6C6AgvoRWZQKgDqaLSaCEb6enT0pt675pa2jO2/Zct8P/PHyVH4ZCOSrCm
	 XXKAhjdJmDwdVDMJdeA9RkwV+x5xaowRc9APgE0hTrlAci0hPOspk12EH5RtZ/pnjbGlE
	 iRBqrZT0+SwKXOT8BA/szjM4j0ViJBvwIjxkG/RLiJSt+rFSefdQ2V5bb9AqUKi4ytduc
	 4J4tlc0nbAP1nQvK5QTIo7Dy444y7YhKjLgJzQ0YPCE/58FXWTFaSJokVsn+54n5g8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793243379;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=CQ7TFwD1Lpl02yitbOOr/2bELAH5EFoPsdJfpMGK2e0=;
	b=wTW48iRdxjC28Q8v2SkE55J0NiTFf7l0Y2MRGAa3sH6LIOZQOwu+0zv6rEVOZGVRRC5n
	 ZLDkCLHWDJWxAN7BxKtHRNQSsJkzJ7d4cq+x7IzBZLh3jo7Gw8X+Cj1/jiQNSovwGNBu8
	 8GcPo+4Oezslh3B5JKwC5oApKbEO8ZjlKYCt2O674oCFDHS9Igau3rCZp2gxFU/sa7f6R
	 xZ2GzyGNicW+3TQwdYN5NTHdWcAfdHOXeNO7LK2u2Vr/23wrSVr1xyNaEBPStNwCj8hje
	 YtOzq9yaiqissV2o6MNKINmdPMvIMmtjJGoFfLEonJyEUoxKuF4ouOG3CRlF9wkbGfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=ppcM0C5q;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1F8606A31D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 03:09:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A1F8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=ppcM0C5q
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so12516495e9.3
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 20:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793243377; x=1793848177; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CQ7TFwD1Lpl02yitbOOr/2bELAH5EFoPsdJfpMGK2e0=;
        b=ppcM0C5qMJry+klwhN6HP4mFjTDS81PC63BDXv/q730dbENksR2IbIP/x5yrx7kaaV
         8QU5D9tzGzxXmph8RKbqhr4VYOTousugW159v9mqBoc0Ummi945VoY15SFpinNdtFc/+
         wVUMvuMV6Z6B8x1SG6AL8X+mXJvj/aYHxTGa0mCBovw9y7FDTWxjntqJBDyBcaKUFXjq
         nKyCP0cCDiYo3N0Ndw+8GnoDZ83Y3Z/DBQMGR+NTyHfGVYMWlTfx3KprdJrWFNdH1v2T
         Do+GvsOBZGuulN0W7NkOrnqiv9C8X0EVnXiL8fAmtmR1YFSK6M6vztZelreHq/9+bzbF
         ifjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793243377; x=1793848177;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CQ7TFwD1Lpl02yitbOOr/2bELAH5EFoPsdJfpMGK2e0=;
        b=nte629e0mLFmRLrywfDyk1NyRUYu3vqviD9E+LqVxZumKhe8EiHNSZwvuLmC0o+Fgd
         dMGWTKyCeW1v5j7QYZY+w3fmToKchi5EYfoXtRJf3H9DGMVmxBPd88K3ke6W+TnV0760
         pNgHsd3N+ILzJAgIcDaUYLczJc8Tybk2LUOFIHk2QKA7DzXYIkrWchfp0qDLkJnkSgTa
         ApJAGbiq+8wQjZtkFWR5zFYdWTmyfqQqF4pNG1JIZL/J1tyNTgT2VDMMnNcRKNTr5cuE
         Bxpy3GfKcJjbLPHh/nQhhpReTp3+9/VwPYzP/w1LCI2LOZSAfOJMvJc82ebOk0JalRBC
         w2KQ==
X-Gm-Message-State: AFq9FYL4aeb3gV0DMPyf40vE0TmkytUJ5euEAB2JZkMkhYTMDgCfOHwE
	prLTgTQbxz0jo03S73JG5uqC95ogvz9ErxSmhcfNMoQDtuqwYRSny1o=
X-Gm-Gg: AYBFou2nDz3v7RqJn3oeDJsZ+Vd6Ss3CU5A5S3D74cDvbaP8Ad+//8YH57vXlqTFvoq
	dtuuptH80nffVICDdVyTXzOJoicZtYAsEIGTZWDBmLsnw79gaNH6Ap1RYCL8sKg3C9YC+lX73DO
	3CHQTQ33YmM0WNaT5Bn0htjaiOi1GWNdxWmABChw31O3iB1BxcVMODpwiUQWsCvxU3gzqZmfHoQ
	sngoxO7OHTnYC6rVb/PhmbqML/mmH7u0qodi7YWlgYy2CdMuPae0CTeJM0H4tYrJ5A2U9yOQj2L
	hyZN8qIrxeZI1J9I0qoW0Pxzr8JCl+enawgN0NRFslb3NJ/rm0wonp0Z258q808MABAheVbliuy
	S55T9jztPx7+mUS40Yu5lEeJhRsmXd9tCckDBdtrl7aOOJ1FKjlYZb3rr5AkM+sPFpx48Sa1P6I
	X/sOhulFF/LJHgw/HAFm9AFwgztlD1i6bLx1rqyHVzzoch9ElwPZxojG2tZqIJJJeyYNp4z4ljo
	iRZb1NTvcpqEquF3viurCIK7CFM4toUthgPbsWQn1dgrUy7Y3HVwfY1lIQJfiPVsqtXo67vZpMQ
	ApDIh6teyRaeeHGYMVZVZEVoHsgC9762R/bEVPaz7wngQq/1CHP0YigdW2EXZ5UROcn8e/QuDLO
	IkVnlQFAl7CyDHmJqdh21zRuQyfk=
X-Received: by 2002:a05:600c:4593:b0:4a7:76fa:87e9 with SMTP id 5b1f17b1804b1-4a966d361dcmr93441975e9.21.1793243377152;
        Wed, 28 Oct 2026 20:09:37 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac3f1.dip0.t-ipconnect.de. [91.42.195.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f047bfsm31916595e9.3.2026.10.28.20.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 20:09:36 -0700 (PDT)
Message-ID: <fc3f6065-a3f8-4a4f-a7af-4c46ab58072d@googlemail.com>
Date: Thu, 29 Oct 2026 04:09:35 +0100
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
Subject: Re: [PATCH 6.18 000/109] 6.18.60-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261028165942.357251485@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.10.2026 um 17:59 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.60 release.
> There are 109 patches in this series, all will be posted as a response
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
