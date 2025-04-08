Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C643252904
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 20:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744145449; cv=none; b=Kk1pRNzJdFTrZQEdPwPNKfn/53dGA6V+Y0scAYs5K78IRHRJO7I43hZnn9fqb2NeNLjl7g0E0J0aTMB5ysJMguC2PJT7v8mt1P0gDCyGxcyZlZayawp/+9a6UWxNQ7nFeW+HXxqPB7TrIDvPxJvM3ggBc09HKMBXY6iDGNq0+pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744145449; c=relaxed/simple;
	bh=BGo9KiR+dEgj65BI8ow4Kqtwa0jSt9YNIHwpxshAqrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BGP8iMgb6QyGgyk+iG6gBbGYgAEZk5VKjVXuHxCF1ewV8nsXkIBmGnXL2FRV0NSZh+bvqM4EF41nJhLo+Ecj4aL2lgGQKNVUcDjMYNGJY0b/KI+1LUbKSj6QSdQvVJZCpq/YFscYLjJwygHEnhC07MVQsWIV1fZtcwFpayW006I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=HqawJnFa; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="HqawJnFa"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cfecdd8b2so47196235e9.2
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 13:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744145446; x=1744750246; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XEbZgIwzpCbB+LN4qifjQaUH6u72AT7P05Hk+XIeZ74=;
        b=HqawJnFae0N+eHh/I9TkEJT7DlT4XAkbp/qRmwBMGoWzpkMzIOuLe+MDaE2sFMihHu
         iY1HKc44rB4Uu1Ks6+skpRXs/EGIgLrQKe7+e6JDmv5Bp/fKoL41LTsCj+Xi5T7OeG0r
         vfMIAn/8/jm9fM5xahFzTEv4RUH0YeMtdWbRq3R5XrZIL3Q3/UOVk27N7sqQ/BpCI2hd
         ayb3SwgIAPwizuVyfJ2LgW8QNN56trnBkWWLQp0SXTm9/BZA5ENSITJr7Zt565y5t3dC
         C6P8/IMndRz141x/I1PCAMLUl5A2VO/A9lAs0Cv2n1QR4/yWCvsj84XzsseoKAeR9kM7
         38kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744145446; x=1744750246;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XEbZgIwzpCbB+LN4qifjQaUH6u72AT7P05Hk+XIeZ74=;
        b=AIPCC77szRgCiy4CsrhqLHY/8UugIIV9a5Flvic4zYPWNsP9sD0sL88dGLXJl/nTmm
         nSmYmlq7CzHdI+3gIvGzyLZEEuixNiWPCn+4qHIffymnHIZH/G7/LYaUHWJL5uqksl3v
         QaOW9wkwmbAotnDoHVFyUFL6h54uzW/AmIUnhgL9SBf2CKyfqp4FGMD7cyhkWo3ulu2N
         GRReUSCzpjJzRE0nay/8oU6Xr4SOrFeOO3BdQtV7xJv5V18QcXHVa+Mh1VpV0w3l5HRi
         E+TEZNCekQTVFcxLktRomg2IsqvW/+ssqf0ov4FssCIw184fL4LXNwTzQovykdeIq+1e
         61/g==
X-Gm-Message-State: AOJu0Yy9S4xJdltewd7K7i6LrxJIMmsGguZWs4khVGK2e3ZUYTqH8yqy
	2k1Gx8BQkc1NP8fRmghRkAjyYraXUj/h4vETfqPGjbPs94E1L0I=
X-Gm-Gg: ASbGncv3Oamq7muKR3/4zIon6FMkZhXNJ3bEv7fgW0LV1iSn/eMhv5PxFD2qJ/p0ERh
	HLQ5dOAByqQ5sMxWDMvZY1esUuBuQLXCsUCX6Wmd1jhjFiL2yZoJC2Gc002EaULzYLKofOLoK45
	2Ad8iC/HrcJbEd3pF2DFWBCbKnUis7h3ilopf5ZZPLc7JSG5BeJJ4PbjxZHSajxjjeSpBlyEt9j
	bbGnxiqWXV5al5jajQfY+sAxYHw0X7UKhgai7NODkhMRJ8IW+fU5jNHIE0YDO4zBmL5WEzlWYvv
	9wmp2p+0qegj6Mnpx24Nwn3jsIO7X+JephGHP2+yVcZfuw2r3LcKsPEy+5kFt4It1UxbWTjzkku
	GviCZ9vlBmY7FtWhQJCQBaD7QEgKzHvtj
X-Google-Smtp-Source: AGHT+IFStHlYZcT+1NvXOJ+pEycIkbHFTdModnjqwJXeSbK2/ncchMYR0+AALkvYB58kmUyOyoOXnA==
X-Received: by 2002:a05:600c:1f11:b0:43d:98e7:38dc with SMTP id 5b1f17b1804b1-43f1ec8cf09mr4233525e9.5.1744145445703;
        Tue, 08 Apr 2025 13:50:45 -0700 (PDT)
Received: from [192.168.1.3] (p5b057de8.dip0.t-ipconnect.de. [91.5.125.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34af0e6sm175193195e9.16.2025.04.08.13.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 13:50:45 -0700 (PDT)
Message-ID: <72890654-f927-4a6a-873d-c89d0ee1542a@googlemail.com>
Date: Tue, 8 Apr 2025 22:50:43 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408154121.378213016@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250408154121.378213016@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.04.2025 um 17:53 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 423 patches in this series, all will be posted as a response
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
