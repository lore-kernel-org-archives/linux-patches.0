Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793240119;
	b=SxRUJdQU7uTjtxZoS3JwwTeqNJvFayCTK4gSnDKaEv8sm2CqOe2Ve84iduXccFV1kUOZ
	 02KhPmRGchmz6bSLuGhQwFFisfsJIkmjyTU2H0TeK0NSpelKlJBK+WBCSUQYM/U9UThX9
	 qyczU5Nd6IgmuP2C9O/boZpywtK91UIbC1pjZufn2/XSXImkpdeKV/NZ7ZiuwKc2kgBMx
	 xye1ZChmC2mohAlrOn1AB69QJfpfohWxMugnRb3psR02by3bgKRpg2Xl14cGNYxsMHhpb
	 86/IMO/Wcf22bpaS66s1V9XY/uFjQlIIHUNXEPxyul8pcDUBbdlFOHtL8zwOFVq3TsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240119;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=dhqqpxGxhV+d9yusyc+fq0FJI6GkW6OrpwpzJ7OfA8I=;
	b=lyvlx1Hy5rAYa9lF5k/xo6DcrOeNhWun+GjPgkuCq771S1YyeCLfTnHeq+rCsTcM76QQ
	 foaJhH2eN2igcUQBK3hxghx0FFBQm1fpY0ZPlOw88IErXg4+Q/wwcWTa7a9KvQImaRm5/
	 f/soBN2D2QmwvmEQZKs/Db5+3gFrqbOKs0SNqKkEv9E/mZVw/pz4VPRTVL7fTTQxdZj5h
	 5DHEXEOxfBKYoqyr0Rht/87ljzOXTklh7OtHjsDcXOiEJWiOkQ6qxChZQfZ3kadXgryMd
	 2IXj6FpxEF68FgStPwxtjJq5fM5jWESol3+WopANpnLSjLsdA82nJW1s07eU0bn7UbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=Bwaxbw6Y;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BCC606A31F
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 02:15:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86BCC606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=Bwaxbw6Y
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a7992e2f7dso13917475e9.3
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 19:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793240118; x=1793844918; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dhqqpxGxhV+d9yusyc+fq0FJI6GkW6OrpwpzJ7OfA8I=;
        b=Bwaxbw6YtiHG/lLYthDfZYV0ZRijXMZmo0hbEPV+xtQLm4iUqYMS0buprDLCabzJIx
         pvlRlxviFSHJUTEGOnfIAn5690XcsOybFjkT+OpTxec2+IMaoGAptn+IIiOUHvjDkw0t
         P0ftt2fS8VctxA59Bkey3XsMCdopZ4Vn38PuY7IZTBZV3LrCE7fnojEAhjkpqXQC2g04
         s9aaFSBj4FONyo80WIvwjFPHNw7ltFlfMIRfdyFXxc9vzUmwrVX7Oc+4zdI7vxYbHouK
         V4xrTuBGA9dYMFgFId8hAEC7biW6OdZjKBgYFEZdpR2tgIUlQClANdYaFqDu1Q3ek94g
         dwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793240118; x=1793844918;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dhqqpxGxhV+d9yusyc+fq0FJI6GkW6OrpwpzJ7OfA8I=;
        b=B+pXECO8/9Rgm8aENObv0WkPo7pc0u+Ul78PVN5Hod74hCeKr6xAZhjpY+I7N72c7V
         8I3AaW5F0FUVHpGeFnmHLoZSjmj+rDuol8XHmQT3Ff13roJF/i8c2dDv6tuOil7C1PXx
         HjUpL2jq95yX5BWu4OR7IWKAgRAbT/Jq3JjJaEuA2R8r4Yn8kL/C5XRAjDRnNSCbAaWl
         qQudVm7vmVfAKYcMHPGHOCDyWn5KWUTKjXKb6+fFSVQBBgOw8VfrPFWpcjRCqnzoSojv
         0N1VaV9zzuzEQoe3fQFMoxV0W+nZ3iYH0Gt6uDZQWRpx+0qLdktfuvgtTfg+Xp86a78Y
         iUww==
X-Gm-Message-State: AFq9FYLTU9R+DuB4WajDUqW947Wt0fcf7UL5/CPVaCqApCcCsNoc2Ftv
	i0b2S4/Kuv4MnSZ3WlEZPc5S8IAx9XwrzV9Aq+Eyy6xgBpr/135AMZI=
X-Gm-Gg: AYBFou2wXCzziFa9WFUU7+f9riqPekauDPuFVMDrYTh7SMXflfliBEjzBoeZXOVMPU2
	kHOFIdNAE+pNE48XU+PhxA6DqJ18Yxxp5wOTbnW/JQHzODTGgykiMx4kACBKRs2S9e1dYMTrr3x
	XMY63m2vVu/XyTOGIvxpC3RXLNays7eCFaRE2cgLE6WxVFS2W8HyDssqVY/vjEwgagVhAnzJQFd
	pvxM6Wk1FMfnH1aI8QJl8vaZeb6x23UB6QsaLHcT6wu8Ky7A507Ff6srZOiRH6MDNgcnqx+cMJf
	qTLqzF9f35e42DycthSRWcOo9f4u+L03VszwGt60gNx+35njqCAI73DCTfY4EX1JLIYHI71gISs
	IcCAuZg4kiPqaN25VUYL1JHtqML8FyRfGCqsPV4lS5JlUAADAPmhE6d4jLzQxosq7VIymP+X9Pp
	ySeta/RKhHjsTbWqGAVgEpFPiSkHqDWxSjbc1KzXUIFsA2zoJv/JZFhzVCu2wohr9a/Vu/g3Ig6
	ZhPA+Rs8M/rqX3KkkgyGyM92JDhxH84QLCKRX7CQa3uFLeyS4NpbKkCUbxUSRxbMHRt1zUBDyyG
	rIooSw1EX2kEODK6EXSEdct2a0PV8V04VQEXiHncgc9G0WC6MTMxW+AsOVCY0H8DvkhcDGMOEG/
	3Wky9xaaP6TvpMm9m9OH0xHUavyE=
X-Received: by 2002:a05:600d:11:b0:4a0:b6:4619 with SMTP id 5b1f17b1804b1-4a974528f91mr69963645e9.0.1793240117667;
        Wed, 28 Oct 2026 19:15:17 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acd9f.dip0.t-ipconnect.de. [91.42.205.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f7f50d3sm46337915e9.8.2026.10.28.19.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 19:15:17 -0700 (PDT)
Message-ID: <054aab03-ce22-4beb-9d7e-b6d8264fadb3@googlemail.com>
Date: Thu, 29 Oct 2026 03:15:13 +0100
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
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261028165947.349197979@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.10.2026 um 17:56 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.115 release.
> There are 247 patches in this series, all will be posted as a response
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
