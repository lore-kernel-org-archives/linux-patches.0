Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10EA1A7045
	for <patches@lists.linux.dev>; Thu, 17 Apr 2025 23:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744933667; cv=none; b=Y5H0u+fSPSy0/fcRBvd0IeiuSDHUVnz6KOyXdOVdaD1+s58OBi+OVnwAD7VB8gs6XzdFL40SGPudGEr5MqPuPfD7H8bzl37EGlNhAk8v0BPFzDwH5nZqXlb/mJETEswNHbotc0jUPMddYgB4GZXzKLKfOtBnjCSqzOWG1p8Kmwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744933667; c=relaxed/simple;
	bh=Cp5E0MXQukVtmrDokjbo/0l23aWUE+cUw7t5IJRqou4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ll0e4HFBRQqVYjBx5vwJ9vhzL7yMeukfK+l+gUu9UQ4LV05mMy+fd1RrfCJhRuKjyjYMPCKbPFINHLMf/9sLsn+l5WY/031TKZ39Vcsl+vI2qI7th/5h6cgLTHoSp7MImNeEL9IA83aHKLc9Hfj7W+EvudSSLjxxHDZNq4k11jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ecV1EbBX; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ecV1EbBX"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cf3192f3bso13009355e9.1
        for <patches@lists.linux.dev>; Thu, 17 Apr 2025 16:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744933664; x=1745538464; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CmMvb+5lSp3wyOSxOTOWkXd7P/kI2rlXh2knPFYaNmQ=;
        b=ecV1EbBXRKR1hsVDW1q9ZWypi1Fo0sj5SvisBqCLFG4KmFF11iViynO2+EcHyH+5gw
         Ky/hMcciwsJScM4HAmZ3VaOOu9wPMl1YhxFhEPnt3xnp9CXXEL7fKHlZN5C8OOkql2Ky
         kuFkpbfasm9135B2a7UdieNsXgffFy4nDsmg9CYtLnnjD/y4RAtg9kdrVLQmgHaZXX7J
         SRWw9JW0AwNEZWA9M4ZpzFUynHHWLJ3mp3E3ZruDNeOyJW/WugUodqAIxYDoBX3mgXQk
         bme7hwmOjVIxQyYnHp5CS1EVC6JmWIW29/SQ7uZQfmWEe3tXnJg7XmhQaVAo4F59iQWr
         +1OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744933664; x=1745538464;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CmMvb+5lSp3wyOSxOTOWkXd7P/kI2rlXh2knPFYaNmQ=;
        b=rZyKtd6ZH7YBsPb/2OHFk8Ozoy5+znjzIFS1TQAqLr8gLKBTXqLB574af/0krUX92j
         gBK/w1aoGiFet26bi1wFj/FE3Hafp7Zra6Cjcwx3jretNNEu4BPApEgNJcuKU2YRc3N5
         yeMOv34oEjvt7H9qPNdMIx2RW2ZiFaykjueS67DvG7+BiIzal9i0ojwz33NCFRGHelkM
         KklzNZKWWFJ6JzE6t30FyDNmYW41ZQs48RZuU+fey15lvHmMQ+rpulVr7VxJwK1xJiTj
         ssYGTAT/i2ABYLUYCYEPeQaMiOnUkJnbBwsFlBfrEiX9OoITN5PfYgxcJoxjLfAi1eWZ
         g5XQ==
X-Gm-Message-State: AOJu0Yy945h51MiR4Gp8uhcL+VpNL2mldPSAnuixYh+VwSyWT3wHzabs
	4nfCG2MxKkeyQajup6PuNCXnW7o7PgeeCwNQBqsxifiXmSVG4RE=
X-Gm-Gg: ASbGncumgv7y26sKI4oPws1k+S8UQ5s3M0RjRLUbcIIuMjOhLIbubZPdfSfpRPtV7ms
	Ui5/4uTqJRH2Ji7k2jstja9AgvulTnmno5hsb45c5baKY8HZv+4wT/KKXteqmSmZLX48nq4BaiO
	xZvONJ/Ry8tF5qgetnYtw/KZIaKsQNnqUxFldX0VqZJ+Rr3I3wCESgfBczvCrfQOSbkRrWm9IXz
	D++Sx0OSCaWQFURaw8le9ePa58CdblLRWS40qM3LFlSQYkS4r7ChKUFAx5DPrSZJf4dNnHFSMNb
	U54AS1TOfKahyyynR9jPq1g6GjUKb0EoWeKLK5J9g7l6OqWbKADD766WtxZowoz+y5hWrC92nXg
	LHYOrAwJc567PNW9BxQ==
X-Google-Smtp-Source: AGHT+IGP3vlAWHSKVHCrAvIBNzVFbxGafZ2481P6x8p49cRaK9tDH8ty1Z35+MD2SKQAQPh4i92wEQ==
X-Received: by 2002:a05:600c:3d86:b0:43c:f6b0:e807 with SMTP id 5b1f17b1804b1-4406ac176dbmr5908785e9.31.1744933663954;
        Thu, 17 Apr 2025 16:47:43 -0700 (PDT)
Received: from [192.168.1.3] (p5b057cb5.dip0.t-ipconnect.de. [91.5.124.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa43be53sm1045282f8f.41.2025.04.17.16.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 16:47:42 -0700 (PDT)
Message-ID: <b1ca484d-3c10-4761-b367-417b8c2ffe32@googlemail.com>
Date: Fri, 18 Apr 2025 01:47:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/414] 6.13.12-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250417175111.386381660@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.04.2025 um 19:45 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.12 release.
> There are 414 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
