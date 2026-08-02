Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD27372B50
	for <patches@lists.linux.dev>; Sun,  2 Aug 2026 09:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785664298; cv=pass; b=Xz+3dkde+J9leTsdJeDZXTb2jSg1Gakm9R90GmC4Ugji4C1T/5i6X6/DRAee3APRfop9wgQkw8yz309At0cvdXQ9A7pCIwAlr0Th/F/BhnqnizmH/Hzb2vWrg2/K1LrHR12pYNbHS5uDaGvYLRQ31x09o2LLUA0GgMVz9YK3DBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785664298; c=relaxed/simple;
	bh=OnBlFg9ufxfV2JABgX9cENM8/Nk7zlR3/f+76HcDBLw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XstGklxvo+dgR+tPstKBhLtwkIvOCrYhmxMRlIOT9s+xEHCDlOTLUSOMn4gUgkmMHxdoxdcHJ/XGQ2xBAgq3dEYBvqxZ4hapVaZAQkkTO5OvAesLpcpUmiT9s1jjFOZls6UAMwaxo58bK0G2iBQEFuDEk/9WyAKUNIi5a8EVni8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=T+wJutWY; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="T+wJutWY"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c169ae1cb26so618944066b.1
        for <patches@lists.linux.dev>; Sun, 02 Aug 2026 02:51:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785664295; cv=none;
        d=google.com; s=arc-20260327;
        b=f5AzFf1DULtb6l3uc3Cv+HI7sS/q6S3KoZcbUhpt/kM7BNYMEALpsK6Y27dfsiCTOE
         1daHQAesH/5oddhZpSRSU/8Dfo+/m6Mk8m38WBEGQ+/4H9sa68DU+aS1A/xNHY5jPnQ0
         Eh0zoRQe5GHzAaQ788I5zMScKE6omuEY+5OfLoJBVwpTSU18VnqY8upXGjuOV3E/kyXK
         DYysVFRSMHJIkGJtX/JH2jSISMOh3tYJQNairpX37L+zlllNh0H0l2H6kqa1XzlXcnqh
         F9dKjYnddV1az+51w1QGjOVJeZLoPFo/iuX8atxkIDtb0APH/EUpkYtFOY1Eh2t4cOjA
         KWKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RcY18fUTe+GvrWML3QSCdOQefdsNdfa3eTybs7JUMoM=;
        fh=o3C/yZjzQViGgcsPwywxo8El1YSdQDnHiCOxoI5abaM=;
        b=caOs3MdXkSwX+QpSVoTna7MAwEf2T0IsyHc5RyMoCn2IbsjpKwvGxQrPRn2rS+LcTi
         W3oCD9gZpS9pc4MDvnl0QXGVrVHGbLIVJ05Py0bkMAh1Gk+xjC7IPXUFUcJe8rxKZRt5
         DTAIoGfSQ0fjLnnjYWuE6OhMWKCXBJTVYqG6frpMe7B9CvioWrNkvh4wjGMTWDc1U3Ox
         u87bb8iBtQCie2MU7IUOcl2zDmGtgasg9CsyV689xff8rGUzNeaq3znrZMF2PjA0BrkX
         9DHelZZovntb0RI77nv6/QazzuJTYBjWImTtkdNixC9RF+fWk2eCADxv/Ckn9sAOrhfl
         TdeQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1785664295; x=1786269095; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RcY18fUTe+GvrWML3QSCdOQefdsNdfa3eTybs7JUMoM=;
        b=T+wJutWYfpMCVDqOLq2KMtkS/EjB0BDjwozgi0BPAbP2UP+ydS95Q9kaAsH0ynXWV2
         6fbkYMr/Be0D15cTsUKnUdR5sezwzK4Js2JivaSmpnEL7kIzgo32Eq9Q6QQ5BNItEzI7
         Pe8Nir9+hdS4AjCdMCRRiF5Z1vD4hy4oZmQmVR++xRkBDdaUSmoFoVHhT5OLnLD0rkIz
         U907T5g6pwyYEHVc+zFfo3myTF+k42wdrt9MRlBocY0NohIZqmXaK0SXfx6vdygaOeD0
         dy4ttISy1Tg3bbbBhEWmEP9WS9Bvc4p791QLZLgc9/oMm7vXeqpmQ+mI6qlF7pkjpz8/
         0ZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785664295; x=1786269095;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RcY18fUTe+GvrWML3QSCdOQefdsNdfa3eTybs7JUMoM=;
        b=B9vUWjJY80zE6bb+TmS0IP8NLGFSwEKGBYMzgbjBly3GBwJ3VipBQPf3zk0Zq0y40u
         Nl1qW/CwMWRgtPY1i1p0tz7cZcEQ6L07EWri0Wr4pzjUiDqS4T+VdZS3h/2XARNvmkKX
         iM3FGOvwKX6WvFiN8n/9V/Bl/G1/yDI6a6tAMn67NJBc7fia7VYFrfmNE6rV5NGzQjGC
         yN9AHxIKEcwMG8eSGSRGr1UDSYbfn2i75RULgcaeT8U91xIiQlg/qwoA57iH/ELNJqjT
         85r1IDO3Ho5gflBNFoJ1OaloXurttO6qbvqb0dso4LY6F0xSQ9Kds0ppt8hKdVqJ0JPT
         Ukwg==
X-Forwarded-Encrypted: i=1; AHgh+Rp+jyNEHU+q5cnUKgByA+2I16T2d+/gurVVtA9tVvr6HWnI5RR79yOnNEZtdH1L/YYcH7YVjDC4@lists.linux.dev
X-Gm-Message-State: AOJu0YzPlFUuIf496xBZrIQV6uZmi/SylSETTTIBHsG5wBSIxujlPmMV
	PqzRQLleEZA13i1IU0r2MGF+kzJdkWBaLOi1ROrg+6T7GRizqv/1hQsPc7s5SRazJ19gzIQBEyw
	uYt1t5viWQ5mvGQZHu887TXZ/+GSFXsGakLxlN8Oofw==
X-Gm-Gg: AR+sD12g10O/bkA+weKRijijFO0LiI4M28EwX6bEmR9HPasp/CffX7jzipNKdJieGFS
	TzNnhy6YzJUH7nhi6MK4/rmvar/QPu7j2UMvEjP6v8u92oMBeGLDCiv7r3qYR6Wr6XVBQ7V1PA4
	EqtRc+WDdx9aaz7OtOxO6v1mKWcmM9U/40nqAHWpZf5yPe2Q4ZblBqSuZ+I2Lqt3b/4zYF5612V
	HvRtTw/DIFIpr3frbG1YnUojzY7GmoZayqE25WiuX51BedOG2Zykp/UFnlEBJtuJ3xxESrdGkTy
	wEXthbBduZ/6tE6b1RBgfO2+GX44vD5BFHVm/RAlvU9LdBJsldKLYG5Vd/qllsE5oQ8n5xd8MWQ
	c7XQswNB69nOpa3M7KXLZGkTSEz2aogFikyaiiodyVUDo7x5VhRaNVsThjF60BX5wEHBNO3tLiu
	5qHPKwx/+1OiPilg==
X-Received: by 2002:a17:907:a0d1:b0:c12:8a:7d7b with SMTP id
 a640c23a62f3a-c1fd316d285mr518464466b.1.1785664295560; Sun, 02 Aug 2026
 02:51:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260730141444.267951807@linuxfoundation.org>
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sun, 2 Aug 2026 15:20:56 +0530
X-Gm-Features: AUfX_myz9-eUDDINqT5CeYLvoi6DlvCjBCaBzgzbdugbcSsyHgfc2JTSiDnOjXQ
Message-ID: <CAG=yYwmMa0RAFUPkTDC1zOMNCMS0oiJ7n6B1Q0Xx1X-0VYWhQg@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello,

 Compiled and booted  7.1.6-rc1 (using qemu-system-amd64)

No new typical dmesg regressions .

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
