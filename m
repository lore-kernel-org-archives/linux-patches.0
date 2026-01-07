Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD9D2417C3
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 12:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767789168; cv=none; b=bF+uayhUArm+3MlwbGd4jTOl8fChaW2uM+n8GAvdZR8Pqrv540t/r0liREkaH6c983SatFPvIo8A8UskZZEI+UBYME6d1JV4yJOm2jh7SBDnCmeIxuIoF8quC9ZnYaMwt9rPq7nF31Aqr/j2PiaWulbrmaCOeeeXqsqSEGRthF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767789168; c=relaxed/simple;
	bh=9NXl5W0MfOCi2j4t6/RiSQyQHxX4Vd0WKOB2kfY6gGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J4YxQgRFTt5Gfol9f8kHnot5hoRAP/1o413tTfk0lg9HedQW4Pv1ELeTWU+WoTjQ2h2lOFbQwJF7Ykep34Er4/UrofYXfLe2AQoUvDvyMLPyxVn/wsEYGEP5D7xIlrQawCbtcbRNUcCb7igKRCR8lVDCK9e69vwKokBjgCHVK8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=1zNATdt4; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="1zNATdt4"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b7ce5d6627dso407443566b.2
        for <patches@lists.linux.dev>; Wed, 07 Jan 2026 04:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1767789165; x=1768393965; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BfkBO33x57aujCCNZ/7YzXNkZ4PGmA1hAlSEDo65Z7Y=;
        b=1zNATdt4YoRIVt5O56DiI6HthYFEhQHPUSk+Z3yOCPLQ7npFNm20CVJyCXSR9C0t0R
         7+CyzWNlHoUg3Ii7jDdTOEizjUFY5oY/yG8UUzX/YOQqzC0rxDZ8WruKIazmHVqht9wZ
         tXc3twxyBo3y3ERF9ghqUrVyIULC2waVHFwgm7wb18K1DKkxEv0nGrGGWiQmT11gNI4e
         Rr90n4N0F5Cc0SdhSxYMnnN6N/vzSDJuy9V3/UrV+LNIvpeX2PZxzc9fnEn/JjVhp0FV
         bM0mnYdABPnIwfE9N8c88KMfJnzKXnXbjPRb9TDKRMXGyEiAWX/1Hk+rBRPOdmm/KF8y
         3tqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767789165; x=1768393965;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BfkBO33x57aujCCNZ/7YzXNkZ4PGmA1hAlSEDo65Z7Y=;
        b=wjSfPAcfCCdSvsDB/0XdjBYgRZbvCQn8I4JQyD1wA6nIRWjUm3gsdZBBnynexO0Yaa
         y9m5C5hUHX8gU/uZKO7uDsRzxJuJpvL2eHa9+ObuLcFpCxRS5c5WsjLXCQPlNLMWNq+4
         sIdKjBTCF0rCCDahvAV9jI+hMTjhde+BCkI0llyG7CgwbZSbMnU1ODDEas76fDYK1EFG
         UDrQkOQKXwtuKf9G3+b+2iF06MshhVP2G/n9MZr+iq5WrvdYST5W3TAU6r9XrMynOmzD
         HEHsOnv/lgoSscx+0/yH0claIcg4qbaWKhKbOdt7palckF7FbVWlDzHFiJidvIMu49BO
         NBtw==
X-Forwarded-Encrypted: i=1; AJvYcCVPRQ4mN3mZnnTqedV4hylOtQXP9dApitak2wqwYQPMjTW97Iqofdl/eqFW0wI+eqMk7+QrbjI3@lists.linux.dev
X-Gm-Message-State: AOJu0YzJipya1/hrVf5vXJ2v+xyhtNS5jwSPRpHvPKZWN+fWy9OqM5eG
	8gHfS8u0ADdNsSd6cs2hyExKsIOfK0wXKHjAXRod96kIoGbB8afplprb5QZSkmJvwyZEtTPzFol
	98yYkwmQUU6yJprBfGdqC9yaCaQgC48+A45JtyP+xUQ==
X-Gm-Gg: AY/fxX45TJeeKeWZJXOjVyWkpEi86nAddehMNiTJ5nTBdhClG4uoioaxeQcSUJwnX2R
	FAmnzREC/2J0+lK224cwrO/vssbO8sUWFWBehhKCi+pBWARGzPpK5m+YlI56RAiNe5MiN2jkQfN
	eJSt9mlly29L5wKCz43jJAtwRWKMSuuaDMssUkKw6dzGw63UafaL67xM6ZwMkpxEvvATRalMJSO
	m/xxWVsFZ9qsxH1vrspnxr5Qv6rLPzuzSpOz++4YldTYnkhjUns/y/uVVmBoh7cDnu4dU7S
X-Google-Smtp-Source: AGHT+IHOxw9JvjRlizzPnfcQvbzMAkTiKS4EzbomLsx7MmU0gtG8jz2QlCt0LHS/Sxtw6ccg2YGGblRmBWQol9MxulE=
X-Received: by 2002:a17:907:9483:b0:b80:3101:cd13 with SMTP id
 a640c23a62f3a-b8444d4eb13mr283995066b.10.1767789165164; Wed, 07 Jan 2026
 04:32:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260106170451.332875001@linuxfoundation.org>
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 7 Jan 2026 18:02:08 +0530
X-Gm-Features: AQt7F2prbfkT_CozKxUycCxd-okzJWwXa7sMgEQ4M_QD7UVD0WzEQqSKL-Pk25I
Message-ID: <CAG=yYwkR-VoXihnmhd_YtUsgV6AYH2noy+cOUop+yuWroCC9Sg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello

Compiled and booted  6.12.64-rc1+

No  typical new regressions   from dmesg.

As per the dmidecode command.
Version: AMD Ryzen 3 3250U with Radeon Graphics

Processor Information
        Socket Designation: FP5
        Type: Central Processor
        Family: Zen
        Manufacturer: Advanced Micro Devices, Inc.
        ID: 81 0F 81 00 FF FB 8B 17
        Signature: Family 23, Model 24, Stepping 1

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
