Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B43A248F73
	for <patches@lists.linux.dev>; Fri, 19 Sep 2025 02:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758249970; cv=none; b=o/+zGpHeawVY51rpwNj14vU9wcwa/EfymbYjjtTyP2Y5//D9eVRp4dsz5JQqvYBDqbizGHmyPPsaoJ0cdOGCLgif/fniHTuv+JUeXdDC2g2qtCY/IoZD51CtAGWVX13Y9q89Svv8wM/es5YbikP85QemutbZsxCGEgg6CWRSM90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758249970; c=relaxed/simple;
	bh=C3rJlPeakNHxNeSRxvndvY3Bl2Okug10Y6PTrK8S7+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XJp0t9v6DUIKKQXePiaRQEc4H/N2/JMzwsnaTfSbq1OeSO1wrnSREejWmCJFlZhXIHjLVe+PxnlIbzdzw1rXi59m7jIpYGk14dePUnZ+5HErqSkFGEB0VMqOvNM4LYHyJzdWR7SO5ij6haAmFI2g8/H2NuJAG7J6FWGUWwS6R+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lPciq69B; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lPciq69B"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45df7dc1b98so9468495e9.1
        for <patches@lists.linux.dev>; Thu, 18 Sep 2025 19:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1758249966; x=1758854766; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RV82iQeoL7J45auwt67Jr/9GlmlJe4+A69CPPiwNB4U=;
        b=lPciq69BXlw50ZF41aRUTL+lQoipH76Pw9g0KRhSMvL8TcNBZl1EZlJRr26L4rePpG
         VxVEt+jIoGa6lyvFFbIstwlYvcOeiDxPPfpO51nNGfl5HMpDaoZNfvtO3wbB+wV1X0DE
         +LVf/w0Tj0pSepZ8t2lLNj1iKfF/x5RJrrbhA2aNQukMu9VrXz6MorX/CU3vj5sDV/aq
         2k4PQlnOOnqZB3Fl3SwT8A24SWWKA/RM33kKUfw55SUp8tv9BHWcm/6FjtXEzWwG4WgQ
         I77Fc6qZUfVG1Wnzm5hhkFD85F0/fL3GGD+s+sZIRI5EwBSLNfKXqpJGVjeTPtNOHBkl
         uAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758249966; x=1758854766;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RV82iQeoL7J45auwt67Jr/9GlmlJe4+A69CPPiwNB4U=;
        b=tGWgFq/Z9EUfS0xjiGl/3V882aPfGNaqgFmxWjk2x8zcFkADkPuLIczK3WpzwjIrKI
         /kedJXwdrCBuMzF6e2qYoH3Lo0m6nFxkkTROO1gJvNmVPJmqRW7s3yNogbQO8FPg3rJC
         RAP4ebQPz/3oI+NDTrMubQJMXm9Z4U+8UFjqgwRQPVbaPPi363xVA4OR4hLrSrnKzVZN
         VIStSngPsbYyvMZxcCGD+5bBtK2eEaDfmbA814BN3VrhVn6ASzt1IaF94a2BO4aYpyPJ
         3XDzgYHMFA9JOp8l/7+7hSWy9D24yjKNZaVgPIht3Op7ZYA8bhhK+ic4va3HdnnlefZq
         GL0A==
X-Gm-Message-State: AOJu0YyW68nZBeacM7QMHvwVHFy5Hd/4fNPfbDPM4t4LpV4UDAct8LyC
	ouTMnk3rZQXKa+yBpiyettjIRrCcKabDtrnrEBV1XDBGr0V+pJqPWWg=
X-Gm-Gg: ASbGncvdGPVL8YjZ3TQjoG0OSFv/aHnuYbFe6WiQCGIMxACsxZFf8cqIfHdyLy15CwO
	DMp86xScDPw3Izv9MTAK8H2gk3jV1YrvqvCikbTbyzuOe/gbLrxzhW7/uVUf8NpPlu576XHCUXJ
	gBPAKT0APUMh45uvcBCCJ1C+uNr0Rq3RG4lNiSBpBY2g+js60HcOjzMHQ7hMikCvqQx8PPWcNIW
	4ODaUEpKOQOSkzu2fYcE6l3k7Uhpk53XkX1ut0/ZjAbx84GXdz4gNpxnG4FIjteM23e21m6tLj7
	+Tk58gKuLJqy47WP3zdgGEgUK4xagp4uyvlWwZr/8GzKaHDQik9bCoCqiZbhRwBHNPXaNg1D4S/
	RAR4MfNk5sf6/Mveg0BLkMxvncQnBEgM9sFQMZu956bd0yyP8wXOAaddj/qGoaiRA/ch5r+Zfr+
	I=
X-Google-Smtp-Source: AGHT+IGgQuGA3pdRA6O9frETa1wvqCMUipxJgFmb0Z1HCL/sLjXWcSHn9dqNe7Zf38rm77aViWLBYg==
X-Received: by 2002:a05:600c:1910:b0:459:dde3:1a55 with SMTP id 5b1f17b1804b1-467eb0454f8mr10603065e9.24.1758249966425;
        Thu, 18 Sep 2025 19:46:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac915.dip0.t-ipconnect.de. [91.42.201.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-461391232e7sm103225465e9.6.2025.09.18.19.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 19:46:06 -0700 (PDT)
Message-ID: <f7a654dc-aac0-4898-b07d-c6b46bd4dc1c@googlemail.com>
Date: Fri, 19 Sep 2025 04:46:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/140] 6.12.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250917123344.315037637@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.09.2025 um 14:32 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.48 release.
> There are 140 patches in this series, all will be posted as a response
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
