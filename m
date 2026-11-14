Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794674688;
	b=cXDf4R9fWaGW8poBpeS2MO2ej2+pM7LhJ8QIwv1QiJzicOI3/G0VP37jVcM9jDyCtuC3
	 9f4V2au7CbUWbk+4jmYlGh7lwqsxjncdcUfYixsy9pM++dLjEIVrT0lh0+uMXmTjilew7
	 0h5oBCCr0lniD5/3GMnHp+GpEEfNMbnAEPmgzuzsS3C9jC7JMpa/TGY7BeIasxtamSoMx
	 35aE+narYTp3i7LiKAR0AkdpdDqSXj4BUvm835tuxllnvQtkoEvNI4g8uTrXpQw0/kN6Q
	 PfbIIcNwsXFn6DYGhjeVb+k67TLLXboFnTTWCCoNB1YA7SJGs3h8fosnk55VLQUcaxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794674688;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=h4axWdmxX9gtDkNwklTEbzWCcmvgV4kr9k9kh9hjp2s=;
	b=h2Aa9Ij3AuivX38RK8qxuY94WAfVOxY9XSTxZb/XFyJLrYy7Xhq6zm39DcJWVIfeRyeo
	 SOgpm+h74ggK0Amp2JhIywSTQwKSq7wPw8ud8Br4GF8g9nkcgQHmBC3LfQLSizznO4pi2
	 btvdNwzd3toWBcSnbLBEPgYfcAzBT5TSyZOFua58K/1uWYX+Pc3l1chyzoALmYu5eS58G
	 U9HiYuQijqbzbJGlFPvsyDJOD+hBxOl6p+PoR9PmjIXRZ3wknmKy4UoaL3ZbVv0Jq4Nju
	 Id/KTXb5s6g9NoW1kfXJYQuNCwfYWZ4h753wTsUxZfsYRj/TM/szfAYvmLibijDmzfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=gmWNWpKx;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79591606A323
	for <patches@lists.linux.dev>; Sat, 14 Nov 2026 16:44:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79591606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=gmWNWpKx
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-490a0e72588so864564f8f.3
        for <patches@lists.linux.dev>; Sat, 14 Nov 2026 08:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1794674687; x=1795279487; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h4axWdmxX9gtDkNwklTEbzWCcmvgV4kr9k9kh9hjp2s=;
        b=gmWNWpKxSkysfZRdFtfBnN6FtdTys8ilxDp5x7ls6oRjAX3jcS+MqwOyBkiyOMyaza
         kt5MHe2/LffbISZm8vZ17APagt01+E51kfPRBaJT0yRkN9dyxwnGRb21otHsxAnK/Y+X
         IOexG/aq9f6B2cyJWnG5THcBH197MrY4QpdSCEWZMyCFR8/j/pcyQl/pJYhuOav+M+xa
         ME3IDs6EYbyvplxV4IGn4urIuhW53dfWutepP7qqWjBRHyOqaXPZ2dg9I3+jdiiUQv4R
         F7m90dR5VOQijYl9VUvp/MTHw0ych9DTWXWMOIfOls6iVLVQEQQKEchrg+fOhfiBc9cl
         +OPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794674687; x=1795279487;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h4axWdmxX9gtDkNwklTEbzWCcmvgV4kr9k9kh9hjp2s=;
        b=xof8wTV7lKj4ivb6NUFqj9sMyiwqczGQTSirexwGvCc1CkMknNiRLLb0rPRaQCHCLh
         yHW4PhOWH2okJuEGnmOpupcsabrpBy7Bds12RxPrOqDX7iA+lskDyum9UksOYRSz6ote
         0o2eCNhxBeMRSTjjw4yJFubyWtcEnXKcamAQegA8C0lnm5KzpmSFxsygkn01/Dt9zZE5
         aavUu3+qBOEvNlx3pH+SNsY80k76ipKnEli5A17MbCecLY1QdlSECgUNi6PM5haAkACA
         g3IbF6q69i07U0BBVAqliLCYi46cW347tJwXkxkuV6f4XKV/PTOj1Bd23fs4K1WGO6KG
         88YA==
X-Gm-Message-State: APuU4Z9je9ozDF27vZ7fGGOrnW6I0abrT+HxFH16Ovg5nSBdU77gFsl5
	0lWi1CzoZA5TQACAncUWwC3hEbXEQQJZtRgI9AZDWnYZui4r1ZT9TN4=
X-Gm-Gg: AYBFou34zyL2XSovDoemnTloqcEbY9ciNhtEWLxOxUKE+z3v/DMjQLJriPw8y0bCb/C
	Pl/V+J5qLtLB1/rDx1jStAenAsP5xVxULhOfSeG1Wdz+UG3fjCbaXa33YoUDsvCF4iND57zIFy7
	A/TIvtg5296DqIeynIBPsseWK+tPoyFomxdNCtgn66dHK700/LVcsrAR0Aiaf7qcCtcqFahFDq1
	uJwz9PG+VANNda2E8rQOjiDyoLTI+q4c/odiWv3aV0L5ZPmF+/gC+ZYktKteGN2iC+sU11VhFR+
	T+Ce14oRyATccocBPSvttYVo2wzB4ros/4HlpCq1e5rLfHUyxXQNG+rCPLHil0Bmu8ALA/BKLby
	jwGJuJ2p61BUsYAqTzj0RrfzJl08JCU53uSMvnEAMyVKtQneF7Ua825m0qHVozTGaB22vCxMrHQ
	5BudMsj3LXKha4j2fhmlW+4TvqBegsBgxflukzmKzE4HodZr7/t/Tj0vaeXBap60lojelvpGlUQ
	jb4W8NI9zVQn2JAT52piIrLADTYrVohF9Y9fUbdIAvZt97/Hg7RsD6nQ6pE2X4Z23mdvi6aKzT2
	+P9OFmrtL75AVhMLea8Te0mxSvMA4elQNK2gCtZCfJA+FazqyzBWyr6Jz75DUobH6f3qYqlm+l8
	ICos6ew==
X-Received: by 2002:a05:6000:2007:b0:491:7ab7:81a1 with SMTP id ffacd0b85a97d-49c72c9be63mr11913231f8f.46.1794674686748;
        Sat, 14 Nov 2026 08:44:46 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac4c4.dip0.t-ipconnect.de. [91.42.196.196])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8e794sm11806540f8f.59.2026.11.14.08.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 08:44:46 -0800 (PST)
Message-ID: <6bd63228-03f5-42e8-a7b1-367007d8dcc0@googlemail.com>
Date: Sat, 14 Nov 2026 17:44:44 +0100
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
Subject: Re: [PATCH 6.18 000/686] 6.18.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261113153820.902362109@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.11.2026 um 16:42 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.64 release.
> There are 686 patches in this series, all will be posted as a response
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
