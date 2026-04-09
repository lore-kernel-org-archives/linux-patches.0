Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C553C1969
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 11:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775734288; cv=pass; b=LUs5PQULp/WPoqn7D/hPMBQEY1I09zPGCm9qgCzg6B0Z306aIAfpn9Lxq1UOX4rDNXfGI5My2Q1pnNAVezbFz7lEQAutYkv/XtT0O4aV97O4sq+3h+9+KPaMzb9VBq+Swst5zTmJIc5ar9CUIYpJiVGQ00YeMKZJW8tGc+IgIBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775734288; c=relaxed/simple;
	bh=wV74ewI1AhRdJklJxevMEZCQNqPAxKMh+kZTlh12Gm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=syj54whulSF+T/9jBtgtzCdN+lh72fjo+OUhDdCrtE984bahigkE8ha6g5z18ns2XOToTuIr5f8Dj6J9DBi/mZQxCdJWYptXRI5s9K7DZ0Bcy26bTd/KSCmneyl3kVWeCRUUyNCjoIu8IDk38nC6J3jxJBCjjOwcFqbOpCRaVYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=osl+SSYR; arc=pass smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="osl+SSYR"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2c15849aa2cso759618eec.0
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 04:31:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775734284; cv=none;
        d=google.com; s=arc-20240605;
        b=kNB3sOHFOrgkW6U53Sh1/7D3hEor/VaRR8iKFgIzcuTmTaztnMfclSO+Cx1/q/9cba
         esbmLNwzWDPcovOat7A26EMpaRjBxd96AfMBnRXLNn5p0cr+z4Ly6E21gl2xqE7r/Dyq
         Gc0qH8+6FcutJ0LHkLFs34ZVgRHUNK3Xz4U2nv7PpRGUfR8YCfc0jZOhjuTbXO21H3UD
         WKMc4+OLL862gRYvg5VeOQnVZiF+AnkxutJ9OabILeIAE2IIkNZzBEvAjozASb/jOjwn
         XL3YRcmJkbhNXjVlySah1gYfwP+0LO6hFGYcLRWUwxR5HV7rNsBjOzAauK4q8Kg7q5Wv
         C/Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wV74ewI1AhRdJklJxevMEZCQNqPAxKMh+kZTlh12Gm8=;
        fh=Q/DStXTc6RzRJr8mlKI7k7rJ9TMQIKzG8pMBN3zdbq8=;
        b=IdNiyuXhGNJ7VgQ5IUkscNVoJ4JTqCzV4FWrEXAXGkBP9xQV46UmkaQgockqVq0dZ3
         WQobgUM2lgUA0FCMGJ3gj1sfWm5fj0BiEO0QRVUwVwkB/rKJJiFtPmqWn8EW90CgpG7c
         Q79zMWWH8pxM1/f70ljKeDHSwK0R3IJzIX5fqVWq5YZKDW9D+ZS2tXOTUFsHCF7FzqvK
         zF60U6CMeR0KIwJ0QqFX+mD8DqxM8N1b1jL0ujVULEn8O6Esft5ZjXKWPa3lUIYsWO99
         1O+Rc8oUtVJLp05481qHt6q0A8/e8IPy5fu4lVC097W5Npsnct0mJPFtph8YDXCszHls
         2Pzw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775734284; x=1776339084; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wV74ewI1AhRdJklJxevMEZCQNqPAxKMh+kZTlh12Gm8=;
        b=osl+SSYRe+1drH5izWThKn4L3VPGTxMIFHqxvu+z0frRDpbYbw54ft0uLI3EWe3txL
         rQ+JYo/vvDgBjlTHRQXch71W5haVQ6UFcJP15ID/1svUgC7Vm2Ij/4B1P5fqU1KnC/Bs
         fDMEsPiLrDS7rH0jejpMREZQIWfSmw9ziOjCPg/LAvfIV1Pk2svnAoPskZKpVvqLB7+X
         pinSFZdxqr3MakIqv6ewsaQZGFRBg73Je3WsO3NoWJacr5bAtaW64ZRnzsU9kEo3mNHU
         TOIPdHly7bOImEBL/W3qet8UdVb39Aoy+1r06Nlt5QLPtvXLIzijY2M4S3XFpX9RsmpZ
         SONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775734284; x=1776339084;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wV74ewI1AhRdJklJxevMEZCQNqPAxKMh+kZTlh12Gm8=;
        b=QmwyxOg8YzhcKXC6ycTrNPr5glngNrvEZn13uIhOpyjruWue9yjOH9lhVPysFbuYSM
         c/W8Oc21PiVEjv01rtg7GJPPfgGapOLRU9rAClnWVMk61tG+mG/rir1w+63IlYUrauJq
         dH++oFCQ+7mE5bEXu0u7tA9qbSQH2Bghdt0zeHpjLmqF28Ro0rFV5/ltw31Aq4j8b4CI
         xNBwxGwIMIORd+Ff19ght5YnFb77dVZaUHtX6dYdy9R0TC+0BwmLxCIozGUzvNINzvJ2
         FI/iiL3hZeGFbvSN/DcGiO1u4lm4wDGJEAA2ROa8Qk6LvhkMgdggiq85ii12c9810F/t
         WoBw==
X-Forwarded-Encrypted: i=1; AJvYcCVmKKZEdClGjg6h/pjHIJ9angdxfKU/xU+Fv3UHTlN4Emk/zDKLncDfPhw6fhP12eT7MPsgLaGk@lists.linux.dev
X-Gm-Message-State: AOJu0Yxj/gy0P+LtXdqr7JiGdLdlWQcBmSj78v/KSgo+DB9I6+CbrEfu
	er7wHnYV3/+gXtg8i2tm3Xrz9eLNsDLkC/l10SkuGp/D8M9rKtq1Kf7eUi7//G5a+feDvbNq6in
	dOx3TEtTzr7S4rADtzns6zTin60U9O/4=
X-Gm-Gg: AeBDietXTzPBWOvyHu1l13UbWESzZrCjOiXfBfFFwbpKYW/j8tv3g+CzcibFKLlaxR2
	6tDEvEJGIjn1o7DJDozt3uNjJdC2EXbb5lhZV8xOfoRTpLN3UL0gJ81QlM853fY6m6V34q2a4PL
	3uT9hs9HvSdFKX6rpas7iV4fr8E+ejgvOZFFi2uzw8D1/rEf9UWIO6HjQPVzUrMUPR630KtUyTO
	abXlwgNdtOufUsorpFwSe7r6TAQjGmAel+ACGWAyKs7M8yxBnYqLmp75DV+3zFZFru7VrzOj5d4
	B7KnB50576RhxSVtmf8ondc6I4viQLb2ppwkMfuzCBYCYDYXdUZLgTRJJAVKhaA8n2SEU4i32V6
	R4DXxnFcIKMJ17uwpL/FtzQ03Am+o+o893NKI8ft8XYZyN9iZ7H650fQx6u6H/JeDvSmBXTRskl
	P5r1bwtQ6lmS/DBGuyCfs=
X-Received: by 2002:a05:7300:c01b:10b0:2d4:94cc:eebb with SMTP id
 5a478bee46e88-2d494ccf578mr627616eec.13.1775734283480; Thu, 09 Apr 2026
 04:31:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260409091742.514769762@linuxfoundation.org> <730e7298-6f6d-4247-bc92-e0cd13cf725c@gmx.de>
In-Reply-To: <730e7298-6f6d-4247-bc92-e0cd13cf725c@gmx.de>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 9 Apr 2026 13:31:10 +0200
X-Gm-Features: AQROBzDXiQ8uJ66Y2fn0dPowu8wZs_w69umFSn694qikBRlmA5wCFnGzCFIwabo
Message-ID: <CADo9pHgh6_sFzjS-fAYfhzWzf3BM7ujmAGQFpbNU7LJQ5+VZWg@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc2 review
To: Ronald Warsow <rwarsow@gmx.de>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den tors 9 apr. 2026 kl 12:55 skrev Ronald Warsow <rwarsow@gmx.de>:
>
> Hi
>
> no regressions here on x86_64 (Intel 11th Gen. CPU)
>
> Thanks
>
> Tested-by: Ronald Warsow <rwarsow@gmx.de>
>
