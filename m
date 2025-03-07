Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC7829408
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 01:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741310806; cv=none; b=QNSCGWUMNO3KVO/3qnczOCv2RULZwNTer0de3Hjxz+amGSxFNUnq1NTqgb61n8ZQsywp5beM4zP2qbYuQjlqeZ2rCdcAdFVgQSH4IFEAF6ktoukWUFoMqDeBFETzOAuZQuToGIpmLQwViYGJQj7Xjh+DRqY0alZ2bBKxvzmTCps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741310806; c=relaxed/simple;
	bh=WaKsnKv62GEUgnh49NOpZFJt/lqW92ABA9XWVmhU2oU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fd/zw5Mr6Wk2HxnKa9+exM3ev4S3/zD7CPatxH24yWLjnMBX0wzDuH2O++xk6n4Ip82yLztSLoDIYdNMmDnIOW4xeB2alSt/3uoLYa+yBVRtwcg9A+YszRZD7/BFOna7TTc3AJhmbJBj43FXzBxJI0t+kaPo+RGldNhuucf4Iew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=YAstNZJl; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="YAstNZJl"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-38a8b17d7a7so710075f8f.2
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 17:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741310803; x=1741915603; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IzAe6BCnu8dMT1QibRWlPYxwJFiqy0HpiikS58YVRo8=;
        b=YAstNZJlI1U2O5oRYCfjbC2pGg3CFoFlpaH++RFKLAjBPUmfOuQNImSrKzzFtQMth6
         IGQW4Nvgp1bBdmMwFrF0Jigui5RRLvrwm9XWNOGqApwj5wBeZHV59/oaeW2Oq5dSkh4L
         rPWPVEy0oVsUwGFuS5b77bbBccr3VyDwG2xYyopb23SjNjEvLZwcM0INglGQ9H+OcuEy
         ce4MaSBXmdRu03Anqb5OGvOS1P+2Yp2nMkOAgOyiPxqRbxJsAvsfdJEekg+j/M++3l3E
         qpE55MXgwT4unlRi+nDtxD1fKJMt8UwUs9wwNp8udmXz7Cfe+Ywtkq6fgtE4Xi3xXUve
         g6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741310803; x=1741915603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IzAe6BCnu8dMT1QibRWlPYxwJFiqy0HpiikS58YVRo8=;
        b=SpTZm9ccXmE+G3TfSpQ0vdCTH/sDrBy0DWKIPg94nevCYUdUaBN5NbnEJvmsU8wNSy
         IDj2JODnzGAZhgTgP+X05hAAalhMiXQkAriBwG39kBqpsf2a/TljZhNbD1AN+CLzfzKc
         Sx5hTcqvFVwRGPvZVqKzWJfPnsY+M6D/jKfF508EbIwJHWBVFKUIDPXT1M05yPEQ0q1T
         4wZPmnhIM8aIPW0S1lCGntsQy45Adz9B97+RUV3eeh8VuFZa3KyOUilxZTUHJyPfwn/Q
         xnRde1rsHr4smtjq/RF2LhfBObCuFyVJAQBX2ZNbw+CYtOfKO27Kd8zwMHfDmpRAk7LS
         +sfA==
X-Gm-Message-State: AOJu0Yw/1rJcCNU7r6Fy3+Y/GEhETyx/1CxPeNmR2jr9OtWGgCX8W9Hf
	yoisKB0maAvtTwmP27c3Sj4uCNm1C3XSH8pr12DEev0uqA3pKYQKPKjU
X-Gm-Gg: ASbGncsN4x1YxePCz2bYp4RI/njG3nk9pkTZqLOMVWCbghpHtDSvqyzVKmb9EKgnZml
	Y7W3v5IwkrG/t1/ogXuJvnAPDaRRMcvWtb+URpWQF9rcfcfGsHqcZNJIpBIoPtE6GM5TR6DF3an
	NM1Yb0Hy88UD0vDRtJ7Ie0sBOGQR6iQajmB7+aDMMCAJP8ANURl1zoQrSu1TtgE5p/7jmPA8mn8
	vDG+melSuYyEXSKmzHDqjz+yOCb5kjlN4QiBtmRYNTJXxCU3sS+LXSo9xMZ+/e3mxUERVqFVaEO
	OOCRxLdpqvlPtoGfMnB2u6rjPyMvdT0HbM2wNt4FW/B+rb5csJWW35mx3pq4uaYzicMjcXuTqBF
	PvJoTtjIsybzvyoHgn/Ob
X-Google-Smtp-Source: AGHT+IHFoUP63tnjiZj2HPn04qVjNBUg6jSXQlAGaY27VGgqn/b9aJRQPxBIeV6aadYlzEkhCjUN0Q==
X-Received: by 2002:a05:6000:144d:b0:391:2e58:f085 with SMTP id ffacd0b85a97d-39132dab192mr832676f8f.54.1741310803136;
        Thu, 06 Mar 2025 17:26:43 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4f54.dip0.t-ipconnect.de. [91.43.79.84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd6530f26sm61732585e9.4.2025.03.06.17.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 17:26:41 -0800 (PST)
Message-ID: <e79334b4-4bde-4995-8416-e2742f36cf47@googlemail.com>
Date: Fri, 7 Mar 2025 02:26:40 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/161] 6.1.130-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250306151414.484343862@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250306151414.484343862@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.03.2025 um 16:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.130 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 
server. No dmesg oddities or regressions found.

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
