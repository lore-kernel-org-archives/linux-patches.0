Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795698289;
	b=Uv0pg+DPniBrzwE7/c2Yt+tK/H2A/cLowYz6zRVHPMYEPCPsHWy4LYH/Oomer6xmD/uF
	 NBWJxcKQQNbjGC8vRk2pzB8AUgpeSnQ6EGViIR4L3AEK5u2cWEEVSgprXLL83zeH06pS7
	 E8GBCTEo2zIdGU9rnmzm0YoZHiqo43LEJyUEo9n8dXuLlDcGxNYRf0dk1IBBhpju7nmvr
	 I4a1Fo9iayag4qJPY3aK3SSJO5Wf8LRwfnw9uoqKL7cxFVSZiu9tJIQimqAf0k6ICdae6
	 05QHGRAjhv1xP/VWPr3x9rrX8L3yWoMPYD3Ic0I6REKJDK+b+UwmpYqbaHbcZkJLVUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795698289;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=6vl//TEiVujCr0d0TeVQNkynM+ywZsLPCxfyBJsTqY8=;
	b=cjM+692mg+hfySRUCRUPPa1+mLiP+8SwcJztNoTDN9dLBxFJ9vhKGDXEqeA6jkrVOP3h
	 f8fBbAilJsCSkpKY550riDCAiz+QE7gD1PrWPJPA6KvBo/vuTo7c4RjVjwgR/JQXZFZlX
	 fLcCx+Nbk7BbtrvY/WEDB88AKsLgSrlmTIzumUqQA4CLd5psK0rZZ1ZW20avRBVJNFd/A
	 E2t2V32rkyRxDtuImxeDzHO2P2eYbi9YZUjNMfOnHLAmYK61QP0TVFCKzFpFWaxT4iXEB
	 5xrAP1gAUmQHVUU9vwDEd5IFt1vEYOL4x4B5XbDTKLJhVxXSvHTnoyShDVQgVstg/lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=sN05nz2m;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B909606A31E
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 13:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B909606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=sN05nz2m
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4aa5833c263so6728773f8f.2
        for <patches@lists.linux.dev>; Thu, 26 Nov 2026 05:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795698287; x=1796303087; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6vl//TEiVujCr0d0TeVQNkynM+ywZsLPCxfyBJsTqY8=;
        b=sN05nz2mDL+G3I3srJTl9xDc3xB3Eo9gsxoYFUBbW583hTx6DcGWLK1RxEGtc1QZPO
         F0OL4abP5mMz4vLdIjAZHMQJrQtjR1MZg6pa4EmPp6skzp2F3xnLT6rO0RZDBHQIUhCV
         y3HKraJIUl3WIAb/K5eCl8cH5x+aiPSKG/OcpeXgtvy/Yrh9qPkGqmUsbG1WhjF+owHW
         kXF5eJ8sP+VWhe3e2v/Y16Inki1AqIvxQGjtDguR1qoTYoyAdxvpBwJkYJaiWe78TDE3
         TXVggB9nM5vD5xlvZW9zo2GITk2712ROmJ+4V8tLpW7gOrc/ok3y61z7jaarsEhgxakJ
         tuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795698287; x=1796303087;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6vl//TEiVujCr0d0TeVQNkynM+ywZsLPCxfyBJsTqY8=;
        b=WGZvKAmKtRJI3sQnxJ7lPcvrpU/XPiRR26ARKR7rTltluZece/k6k/a8ptqT8kYRmJ
         TUJOGBUEbITpR7gpg7Tj+VMX05Q41TaL98+R6VGCq/kv6rFR+dAZv8luoG55kfZHRO/0
         m3BlU8Tg+SPPTwAql+MX0e0/XTTuV3O0oWkQp7cKi9a3Bt4tFI3a+nRheKrI3g3vAkLg
         00SlNTKhr+W7hwdwMPkeNq9NNeb+WqjoCopjLBlgos6QfnNbokP9DCOgqGcKpDc7p/0S
         eGjhjKQBrxvpG4vMsU/GRQrTArD8YwBRrEYiwS0szeoeS5lCPVjth0tWuniR0FfBbmWJ
         feig==
X-Gm-Message-State: APuU4Z/laQ3/ry0DUq35dnEOu/h/NYJs8TGFqm4dwCkmYXvLyZOm+77y
	LY4Pt0LIelWe1ozwLDk1IYk2bHGYxNMYA9qUIGRFkdBe0DQGgcQ5bZo=
X-Gm-Gg: AZFdTZfv6mP3jpLkyhT2VNWEw6MWD9LquOeEzPefQszIeZqt7rjX/VJCyuO8AwucxK3
	mZznzIGVd21qNMSuXDG6db+z0YfnnOPI5to81s2t4u+fhrhRDYR2sezUnqL3uqlYw8yeAjQnJkO
	J/IQ7Wzm2erMUlzVe7znCKrF0RD3g2D2Ozkr06gEq3bqjFvCcNj7zi9m9LcIbUTNJKffI9vN+Wq
	kmxu7JhQVK2SVCkqWbHQjWFZWFTTH5rlmd64DMSG0A58UM5IZDVtUJ6+W9PXHVr79tMSkkpHIV3
	5ZgCB4MHb3fPOzDdaSyqK3BGQ90lYqyTGaG+j9drEDDwE6hyoSVIGanw98sunT8LZEttib2dQQo
	e0jcGJwRouzwnm7NZp4j4GYYCinf6E+hE3oHdx7nCWH60FZeybtSOvP8GRRRIuEr1w8+uos+AIX
	ur1h8uV/NNHvFzGwQJErH2lsZxvADV7NFEDrfTxbGJNlXfIS5Nmnjuydj6hINz4tYCRBYK+yXKS
	5j9gG38Cje2NSkf4IRf6qeJSlZesuwu5ypB67Md9Dk/TyRgnvaUtxFgXRTAmnmt+eLhoyLzcET3
	MMdpeez1/GGPdzmYYPhayA/Ug1vUi4yA/AsArMWzMdRI2vEnuHExjR6ZhmhOBHnpo5ivmzTUgUs
	f+U21
X-Received: by 2002:a05:600c:64c9:b0:4bb:8701:bb14 with SMTP id 5b1f17b1804b1-4bb88804d1cmr454203995e9.5.1795698287307;
        Thu, 26 Nov 2026 05:04:47 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac210.dip0.t-ipconnect.de. [91.42.194.16])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6bc8ce06sm39148222f8f.47.2026.11.26.05.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 05:04:47 -0800 (PST)
Message-ID: <ca369fe5-dbb0-43b0-8f2c-74a971e1770b@googlemail.com>
Date: Thu, 26 Nov 2026 14:04:46 +0100
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
Subject: Re: [PATCH 7.3 0000/1002] 7.3.7-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Christian Brauner <brauner@kernel.org>
References: <20261126105729.110697432@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261126105729.110697432@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.11.2026 um 11:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.3.7 release.
> There are 1002 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

I don't see the warning message in the dmesg output here which I reported against 6.18.66-rc1 
("WARNING: CPU: 19 PID: 454 at fs/libfs.c:495 offset_readdir+0x1ae/0x1d0"). This 7.3 RC seems to be fine in this regard.

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
