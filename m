Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52102EC0A9
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 05:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761111281; cv=none; b=MYo4NLTb5f+zBasmjCS57jNb0o8m66rMIeXcCJ/sF2p71bMqwovrpR/YHqkOSDC1kSZTWAKGwjpPC0g8kStnzqsgXyL6gQ5P/aCYSp49UKTCxdwaIB7q1j8ihMPh52rdpESut25mA+bYsWlqoEGhCVokWSIt6eGNJmhP13zi50c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761111281; c=relaxed/simple;
	bh=ldk5TdLLZTFBYkEv1AWBaAyL2fYJtBrRgt1mL1omDZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tCxlAI6cH7J+CZLiaYGL2mGonySgB650RK8g3F7KDDjPHy0KPp6QeFET1jK8FhQIyx2o34X7HgM2LQpZt532sc4zYnrc1vaBUqXHiDLgpJVe2LLuqZ9bqeZwFQg3dszxENoqR6oZAmrvukAc6YeaZuQch2CMKvJ/hNFm38CV3lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=g8Ukm/+4; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="g8Ukm/+4"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-426ed6f4db5so288962f8f.0
        for <patches@lists.linux.dev>; Tue, 21 Oct 2025 22:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761111278; x=1761716078; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6mMeiaEiXQbpugBOlm80cBlO+udw+z23IitsqxhIG+U=;
        b=g8Ukm/+4jXySLTcuIcRE5zZYIIZ73mv+j8H7F4F+Llxu/e3IJ3HOQq4ttw64SQG3Vg
         w+y+5VB6TQw6ukjiE+GDDYxg/8qUsm73yCNamRijDH3W07d5rec9LFoYI9NjY7ZGaoBY
         hWjWeeTTTOloEHT/sdHO8fAsN/bhFdAeBfMhXRIHMA8BYG+8Eb+HYGTiLImdOi0df6r2
         35R5zXB6/KJdXMpgRGo2mEXyzb8yhU2FaSr2zuteGRJ59O40wEOiyyE/tkwIFoMmE22+
         gbcoKiIBniQWxyEvh1hDCkBHw6UjDzSZmtwNCGAdZ9MrJOXgACO/JcfyfiOm/s+snSGh
         m1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761111278; x=1761716078;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6mMeiaEiXQbpugBOlm80cBlO+udw+z23IitsqxhIG+U=;
        b=FW3+T8d4/T1WuGaEv505AVrggH8kgMxLFh3cG+SOA4mdmxxdLIjev+437qKao7Uq+B
         qiU6KeL31Aj6w8b4AfUBWwLLLMQLwy2PnyOLR8f5HV//mVTxnjYlisjcVs2WBHaGlBew
         rzP/3WV6WFuF5ZQO5WjdY8ZbAWLXTL1Y5IqyYalnW/njMrZrq7yjQnrusyi8BJb/fP+P
         cAgwGixZxufZgMEgA9pINTvd6AOQpmXQRN40O8WfDTOm2iA1R6dF+HRFFMP3Qg8bX+sG
         OuqsoRGJTzpvLtC6XA4JcH0/3cYtxREypKAkj/aoHq55mRgIFuahkYg3S3/wglAOXosa
         1BrQ==
X-Gm-Message-State: AOJu0YxyFg7Go/Q2UKPyp1MECXO4n8y8Aak53oJo06Z4+e8aRX9ZaSXc
	0UyhO8C392Qf2+FtX7VwhXYdU1Krebej1m7RtkN3lWhHtMNPqSDDuUU=
X-Gm-Gg: ASbGncuQ9gmQS5c4a+4HyG0oiywtly8nNX7E69rJ2BOdZV6EMxeNMGpMVO/5Zv/a/WP
	cOjwkis+HJlXR/myOd/2Van6DGYUwkh98pHn9Ucz3rv9HATkF19qlzG8ui3WGe7K9eUNBbZXFNz
	TEZysatgPxdVdU5SL7LlsbcECqMw3gI1rtbPAtWK2ZmzXykrj8lTiaTH1xcunEX3Uqwk6dgwTcu
	EMKdJJU3k9EDKISPcUXEKPeqFmdKensuxNdwG90bIu2GvouoYY3TJVyVYE+lrWQPCH1BXLeDO/w
	uMt3CD9n8X3DUHdV3n81SWqD4yhraH0/f2UBwtHbsWLuRs8ozyV0jtJ5eaO6QVy2KgBdr4RNGw+
	WzDjHBMEJoLE37soV5VuIF8NU29QnOG6LChCCU8mIX+qjDpt+e2GQPe3eklxDPPdHfnwbcEIjPz
	UIQbnbh1SRCOv5kVG7Cjw9SSq+6J5xIOw7+4QSm4/DZVu83QcXJ1cnguqCmtRfYg==
X-Google-Smtp-Source: AGHT+IElpJnBAYZBYn/zxT+dS12Du9jHuFU7OnELD9ztkVKohPHBRk6At/TgGOKVDvcl+og5FLyKYQ==
X-Received: by 2002:a05:6000:1843:b0:401:8707:8a4b with SMTP id ffacd0b85a97d-42856a47036mr132326f8f.13.1761111277947;
        Tue, 21 Oct 2025 22:34:37 -0700 (PDT)
Received: from [192.168.1.3] (p5b057850.dip0.t-ipconnect.de. [91.5.120.80])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c42b567dsm25916565e9.16.2025.10.21.22.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 22:34:37 -0700 (PDT)
Message-ID: <2f03d1d3-8eb1-4585-bc84-d270c4875419@googlemail.com>
Date: Wed, 22 Oct 2025 07:34:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/105] 6.6.114-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251021195021.492915002@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.10.2025 um 21:50 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.114 release.
> There are 105 patches in this series, all will be posted as a response
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
