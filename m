Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79723466B12
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 16:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784738552; cv=pass; b=sWiHyGlAypf4i6Yh4LqM4VCoqSW+op9PgTIY7FcFNdig+47v/Gzv9sUpY6KW8gumbmYHsyu57mNXAIWLb3MuhM6zjcqasRPzBVhL2tcgTBSdw26EP2NfQDEzY0fF0i6K+12q+cMjCiHSO6+aZz5G0HFbOb13LVrbL+y0Ae6pc2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784738552; c=relaxed/simple;
	bh=1Sy316CYHaDxJapnwSy0hGoppwS0YvpDnjfnWEhoBWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OA4811id+MffwGaDSOeFMVKk6lsbK5IO9BKeRs2iZQwePnEU1p4CC2ahmxqd7I1atl4kIMXe09AlKcZ7Y3n6u3JFftNSBlGeH3q2Z3DFbj+NgS82rjQYLGzbBppjAyL/HyOVgjNW+L/B1gPyW59DgkCWvqF4cClodWlT0UYxqk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=xKlMwtqn; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="xKlMwtqn"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c167aa9500dso1063688166b.3
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 09:42:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784738540; cv=none;
        d=google.com; s=arc-20260327;
        b=qkbAJ02nJz/KGnwxO6cJFsB+Ou6YqrRzrg061Y9xXepzhAtVNdbPZWkUVNIJLtiQ9M
         GUNX5JX/cs4VRXxVzX6CyWeNffUBG9vqeduNEUCJNISg+81N7qesaXXw9J2vO4swdObA
         sitB6zwRuLuGWPUzhs7iHNhm+0mRQr/Xe/l93bU+e37Ff5Gnjg8zdJKC2wq0NSs3H0FL
         w7a6YT7hSSpNo4xghLZIbuSDM9zzVJc5PUEysWf+vhyIHNbsFAFjCyoQ1bvLr1ee57Bj
         eMEJlBSgmhDA85JP15hY/qAn0Qw7iIa6XhTdZZzJTYdLjcciiQLg26UOmJs5V99EUFbK
         G20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7TP0pyi3l+8y5BA5jYpU9YfSpNIUhzsn3PMr/1sHd6g=;
        fh=jC4ilqle7AbkxeDwEb4XZpOZ5jc9trp57EScygGeLU0=;
        b=Fltwc8m/Jr8UV5fDy4fkOqH2zaNryztpKamqbQu0b+Z/4XWqlVsAWWdaKMGvahswdF
         urDWfCIibc/HqpvwplaHC9hZ6juOVpLKN9AOheGTFOy5qADqrtXE0OOaamWvgPHgNi0c
         y3cQr/PX7/3Ra7cu9cHCqxsrCVbbqPkylcULBnXlmR/6rlB7wjA6rNnIPwvswyB3HRoz
         yptK+m59Ej1Da+ty3MN1l6FAMTeRGEI3Y7xGzBJkRvUahZhnnpvClXJRwFS4Ykuw4srM
         +qGvEfMwTqSRRy4kMDR9l7hxUkSAxMib2yEdb+mycJsozZmJwBP6KIECurQ5NU5gLic0
         g5qg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1784738540; x=1785343340; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7TP0pyi3l+8y5BA5jYpU9YfSpNIUhzsn3PMr/1sHd6g=;
        b=xKlMwtqnj/Jcx08H0FV7MRufnAg2pdvZrFW3lBMc8vffuXaR9zj6mjr/Oiu7BJeHmY
         pzR+MJAO8TxG5rYHHXX6V5NUV+t8P16dwINanX1lfwUr/v9Roibx7GdUsf6jsSfpmHw0
         WUdM7ErcrQ5FO0G0j/oPm06zePMygCCm0GjUhseeWicILAbsouu78dTahAM6RnHzB9NS
         QC7NPeVzkjUBB+VX7XQgoQSvLo1FvoXbFQWNLy7FHGS6jnJ6aE15tEullybSuAprW2c/
         NFVBElMGThQpcUkImOwOeezITVLIiEJc0hPgS5WMJmVEIvpFRYEkljUxZfsw5OuZ6Sw9
         xgiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784738540; x=1785343340;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7TP0pyi3l+8y5BA5jYpU9YfSpNIUhzsn3PMr/1sHd6g=;
        b=gs8I/kcT+q4i53IcbSR/EkvqVrC8Zjgipl8KQ2VxxxKrdmow1gnUBkux2GziQggZQN
         9x10UsveY9iWpFjEUBiAi9ZRwi2xZhg/gsWeV0ICRwE3gImcoZxEmR6qLcm42OPtrBcY
         VTD8YbEnD5BYANChHHeDHYj00TzrjqUne5C2KSjd9D3WeOdLWhThUc1v3MHGLYBLnPLv
         DPKMU9G/wJGxljqyc4jszs43JK8Gyad5tZtWoCM2GBtQQb3TK53W+w5O7Fo2b264XnMU
         WOcxOraCNoYLvpCE/DPldMdU1Rg74KscDDpfL6p0ftdZB0QkJrguZm9ivgIt2BYOqwnR
         9jtA==
X-Forwarded-Encrypted: i=1; AHgh+RroVwQP9TAqBu7ukH11DjONUuXoKNZFlqbOUVdYLHo3NXni0WzTddEOtGCavDitJryeqKx0Xl8J@lists.linux.dev
X-Gm-Message-State: AOJu0YwbArREXnX4mkgXXnUUBVlZmGUZIF2sk+nk8TyNArsxHsxfosAT
	+Qw777hbc7OEYZ/dVF+/zTz6CgiVXCm9mx6cXGRlZv1LhwmgUCaRLnpfVc2lhKSZND7I4u0DNtv
	W2Q/F7z4xDzanvHAvuRnwOK7oLaP5+NWe25qWhLmEfA==
X-Gm-Gg: AR+sD10i/c0NwtnNez+wgNV3+ktS3t9sosMT7R43mx7L3Mlh1NkMPmb3CsQ4hMSnSWx
	cIk1CzSlqELJdjg7GIeYGKF8ybBlp9qNCXMLj4m6KjwohzcF16z3XlJ5czFC0ZM8z9ZYvuJTlMI
	5s8kV1sl9D5TqUpgUiOD94s/mfi0YNxDqvBr4bv6lAUutIKJ62IX0SlheOapBrV9YakLdS59op+
	JGjT67t/9KwjXw2K1yfsb/9Bn1n9U1h10wEriuQIiernrg8eGMpePfNs+gCZxOpFBHXKFBOt3Ps
	ZpDbioqVb6bF6Aeo1eGbAB0nsaE0e6/oyZuimB3YzIeI6SyD32to9vxbrznIa1VIB7C++crdKTJ
	Ng+lS89sQ+eNEcY5n70PknKuusci7
X-Received: by 2002:a17:907:1b27:b0:c12:6201:c4c6 with SMTP id
 a640c23a62f3a-c16b45811d3mr1056277466b.11.1784738540044; Wed, 22 Jul 2026
 09:42:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260722142947.085426486@linuxfoundation.org>
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 22 Jul 2026 22:11:41 +0530
X-Gm-Features: AUfX_mxBtH5GVg3yrhg2sh75RiE344YAAmxUpZm1eBbaFsnz3VfaofWya5rMV8s
Message-ID: <CAG=yYwmHmtD8p+mNMTasDdhG+V=0ByoBgoY78BgYKf3981hw1g@mail.gmail.com>
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
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

 Compiled and booted  7.1.5-rc2 (using qemu-system-amd64)

No new typical dmesg regressions .

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
