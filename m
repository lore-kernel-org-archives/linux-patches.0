Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049506;
	b=PScNPMfRuDzCC1xKTg12iNhAofEutkOS/Qoo6qjCiNBGl0IA6LyiBhCecoaqJOdYvjBz
	 ju1aRhQRCZYvET2hkDl9Q9TevSYKBSC1+h27w0C1F9ij7B00SSziWaCxs17b5IWG1zGGH
	 LgTv/o9MfvDC5xSfwH+CO8aD7gosC+kfnhWSmFGl2j74BxTjhrFswPhZqhMvmbi7ABpd+
	 YNsEWVGOJeSJBpP3oIlkSd/hkpiloOp6ogzZxGCW+stK9fh127VlX0eFnXUsc+t4KqX+B
	 eNvx8vNpdWaqZg9uAFetbly3TMcEYCLam97yZY9eNlAoPY4t1OmPB10UmwHDVfSuvAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049506;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ya32YBMmsW8Ze+/UEBRzxYHvc+64tNFlziG219hEuQ0=;
	b=pk+YVFBxHxF/65EYqYYRpNNsN3HG6X0eoNbRKYObr8J0RDbQdRGxmIK5d/+0CZhlE+FF
	 VYBZSHFypkVHEhcNrY4LNL6wsVjZmc05IiQK4Sy9qvJcHZ0Lpb4ljFFcwdkomu6YI76Bb
	 ZxfPmUT0omA1yVT+XHqqrkiRylvBy3gAc5/23ZDfWBDzZ7FKT5HPwMQI+7uB3k8ysYnXp
	 Zz5+KM1Fr5SCOnJPS1Jta4H55ITTqz2UG1VcX/Nl6cv0fFI+QjFNJFxTSvtSqsUSQcjk6
	 bQnnCogBw2rJI8mYhAfdGJ3n9ePXrAXOwgN7gUxSKvG0z11KhPv08mA6CL+9n7O2bUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=kdZKqPN9;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EBB606A332
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 00:51:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75EBB606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=kdZKqPN9
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so12437625e9.3
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 16:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795049505; x=1795654305; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ya32YBMmsW8Ze+/UEBRzxYHvc+64tNFlziG219hEuQ0=;
        b=kdZKqPN94/Z9vyeB9TFeHl10e9OlwuJZNzU9IKLKnOKf2+ZrjfBSvbI8G2svjZhbVe
         YetcyXY3p0CUO7RqvaboV4nY0jYGTsYNpGT1aCI9J2qXnVrpDmAGCTw814P1fuUeJgL8
         tRYxvWocVC0kKvU4Br+Oh5LBkAe6NpBrdR/KJ5tuAKoSdCulaG1uCzRZ5a6zmAVrgp5X
         EJCOJDUtCb5lFUDw2wFtxReECZydv+cw5hxfZLabkcvlPJSF7cZcaGaBqKk07yI7cTAK
         Rfnk2UeDUOSm0U5KZxF8mewjpDnQsMWLOazMf1qWeUrc/86WDaV3aO68MxTVVuEQrVVX
         UwdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795049505; x=1795654305;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ya32YBMmsW8Ze+/UEBRzxYHvc+64tNFlziG219hEuQ0=;
        b=mCTo09trGBmRnqs2yzhLAm4GH3KbWL/CEm/58DyBJ9HOE9i7LoukwcjUD8repRyT6A
         jAd/AQKbFqd4+uNsurc8kx713v8YJLY5ujkZvZXvCN/ZdmyQov9FdOth2Oa7/mIqPfMI
         gBoCmo8PEG7V1wu9+k3JV1Nq3GZs7pMbyXoEfifgtLnovCaYt7d7V8ErAF6+XFfpwLb+
         iAXJz19G9/z8LCIkQBHu2zVIE78beupDF4h66AoODJYvfbJIu5BhjmtEJ0U2UE4ZVr2T
         fwqj2RRF4VyMJd95bRqbMiFYxkCvx/eAdLVnfJYDwpW4chD6Q/QhH5OZuTGLddV2s4Ph
         hmnA==
X-Gm-Message-State: APuU4Z9oChmQuoVsTfZhHLvPiISI+rzehPnCZzsQtsbVuF071otXJBgJ
	rxz6jdYFqjI2PeYm6Q+CpnnUzPDvF2dnhgH7piNOmCh8V+TDHKog9fw=
X-Gm-Gg: AYBFou10fyM8eTzwSWTfO0mHFkbqU+TgrpjaGsKx4eZdfk6VK5z/aFS7vNPqTwDORi5
	sL/0p0FjbzuQnIO8DRE7ICfuF5ZdlusNVMWzBJKfjsJ2OX1hvcL2fS1+mFycr9WJShIk1MYPTHA
	jZjBNvWPZf1x2zS7vM+sDB0Tt5ABQyAXUrSha6R0NNsAC8G0kl4M2KUpPoXjQJYYWIeCo8RSOCb
	v4h5KhRTIptXdMVa/PpWfYOMrKgBwamE3XWEKdr2GVn+MKW3qMJHzRv36z5cZLc3gvKNpvTRPdY
	OiOKrBdIgKIRtT6bpl5tO0l0si/zODZ5G2e4wn8RCJNhuDeB85O+gW3YTNapgSX9tG421uSNvFB
	fzHrol296MGvMVlym+Ya9UvbwvDbmbQynHUxArzWRMktHZgW1JIkjgi/8U/gXJnl6Z0cshZ6Mj1
	HX6uxkibvUA2ajt0X5tiFty8LNyExNuME+13t+xUcx9Gy1OIs7oCess0/9b29x1EGV134/Hbsli
	RQ+ll8c7W5ooC6v/KtU5x2rBt42lgiOrKHQTQozffMcVrHS9gTqBabNiesovVedaeM7aH+m++B/
	sbvW3oBaDwUd9ENb/1q6aPCDeeXeEsGCnqUFq0xNJx6l2JqVJbLpLvj3iAm14vieaXyBFu/6Mdt
	3Pt/3PQ==
X-Received: by 2002:a05:600c:4504:b0:4ba:7e6:53d6 with SMTP id 5b1f17b1804b1-4bb7da52ad6mr78902545e9.33.1795049504793;
        Wed, 18 Nov 2026 16:51:44 -0800 (PST)
Received: from [192.168.1.3] (p5b2acb64.dip0.t-ipconnect.de. [91.42.203.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb842f9348sm10626015e9.8.2026.11.18.16.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 16:51:44 -0800 (PST)
Message-ID: <a67ab2fd-505a-47d2-9689-fb4086377da2@googlemail.com>
Date: Thu, 19 Nov 2026 01:51:43 +0100
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
Subject: Re: [PATCH 6.12 0000/1756] 6.12.119-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150007.957976754@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 18.11.2026 um 15:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1756 patches in this series, all will be posted as a response
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
