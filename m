Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F39919DF49
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 13:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734527020; cv=none; b=rXFdRmb2TNaoAPqFrr8qlR0VUir9mQJj5s0A5oT/jfvyRJsyB5GTwupRGEOPeJLLajnI/sCUvmdI+D+EFEegoi3h3ED4uZ0eIuQT0RKixJdBa1ZoOqOK6NpnAOBD09l9Dv3TkPfZf6leASiVDXw8phuZp0jmw/KFBHawqSDbJ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734527020; c=relaxed/simple;
	bh=2Q11by8Eyqqk22xtjTbwVSKRj/gLhnmQuflq5gu16io=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JWOOpw0cUBQIQBKfYQ4h/uSKdJrxug+ECQNjQdaLt2ge0vvL1jvLU0hcOA7AzOD4WUAINuLPQVIC2q8cMBhCuxlfqy4+kCs9a2Oa2cyaJrYvLLppFrpohXnjQVb8HytWUjlUd/8xOY5WlAnLUd6kOA+JbjvmKl/Jpki6TMtPKjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Tabl+9Rn; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Tabl+9Rn"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4361d5dcf5bso69540115e9.3
        for <patches@lists.linux.dev>; Wed, 18 Dec 2024 05:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1734527017; x=1735131817; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CzfU29FRUWWPESoiLcy7OK/RM7Kv3I87gaQYkF8dmuU=;
        b=Tabl+9RndzHIFRCt4AZTYHK2cjfPzOm+AEKV6Jfvmf7tEyIVZobEQiAZX418STYSWQ
         wrzOPXalx0ErHzP25ihLqpoWlHEdfXVwEDOCjCNOmdDUe53ko07EKhD9p6/qINrqRVP8
         Vaq5emtt0Pce1OTIf1TszZX/TUCibTjKUPLSb+sg9nhnxkb968leejgoIIKSqEKclAXv
         MdeCZU+jqXC02XDoN+XZxC2LnhyjNqUOunSmfF0WMzIxJHRYGbYDIDzUMUOHpo/bSaV8
         2uWgYKUp+RTah6BzxWAJx+JW3++XI90cTJuyZ5wzDVFYfW3AWYaG591gQFEKYyL293RB
         Qo1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734527017; x=1735131817;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CzfU29FRUWWPESoiLcy7OK/RM7Kv3I87gaQYkF8dmuU=;
        b=Xqw1gZzQYQGmBUYYo8rCrq3JzsKC2zM2yebW5SslAOHGQkAVf3Z9SRhqWnjT9FEke5
         ZJiL5Py7iSmN5yqzPHN7qCEYWnFjb4Jhk/xx77OmfZU9q5GTnwvJGGCNxkFqPlyq0J86
         Yl+rwuCF2E8g0UIYtwSbIhjlnRWhffcajVGHHJ+oEKTxLDDXVaJUPrKXQVvBimJjdIi8
         /NXmQO+dBCOTjBVHSgRPPtD/9fzYihXhHa7QfmSa+bpruWrrZx9g8BS7FM9Fhr7EoHNa
         xtBaVRohJT0t+wN417FIga/aznp+fkL1FJsQDAKErCf13BQ8V45cZjRtEqgFwPdT5ov4
         EWIA==
X-Gm-Message-State: AOJu0Yzx8ZfjPB4g/v8j9dmLmX8zVQKcZS5r9SVdQkNMYv1Au7NoAv3G
	iD/uEsQaQG2x8X/SXbH/1i3C3Su1/W7d2hEvkYY0uTqWFlzvj8E=
X-Gm-Gg: ASbGncvgZ/fbu5bKXjnBURPhzSNPZJykzfdZtR9pW6FXJ0+2B0IbKffwBkoie3cXPMw
	A4Vt3WwZr5H8D/PcWKQ3vHz1FJIL3rFMFr5+GneLXaWsy/qiUbZf0M8komqns7+F/cW7PA6EzsB
	t2nTF1kcj7KJcEM9EiMgPLAsAUXdFloQ8m0sPrFM3JjED7JvTUlMaBw8EjzPkT+C1D9qNkbIx/9
	nlNHuFxD+EEMp8fReMONTzHdXvBXpnV13akFzDcMfln8De6pr06PWeZw64eD2NPc44gcB/Z3UNI
	tm/V3XELz2kpu7GL4vEX3ihd/70ZGFnCHg==
X-Google-Smtp-Source: AGHT+IEgh/fetkIoNzePBdFjZBzARmIDvBkSuvRxUEdO9TVyaoAPJt71/E1wg4AFqsLLuMkWiYu4fg==
X-Received: by 2002:a05:600c:4f4d:b0:434:f9c4:a850 with SMTP id 5b1f17b1804b1-4365535b592mr31375295e9.10.1734527016421;
        Wed, 18 Dec 2024 05:03:36 -0800 (PST)
Received: from [192.168.1.3] (p5b057eb9.dip0.t-ipconnect.de. [91.5.126.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656af6c25sm19852355e9.8.2024.12.18.05.03.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 05:03:35 -0800 (PST)
Message-ID: <c06fe553-2583-4ec9-8a10-155ee086ddb5@googlemail.com>
Date: Wed, 18 Dec 2024 14:03:33 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170546.209657098@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.12.2024 um 18:05 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.6 release.
> There are 172 patches in this series, all will be posted as a response
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
