Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB9A337B87
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094412; cv=pass; b=icg+xU6nRnpFt601hb4gZqo6ZFvej7+8M1ga2EbOqcjgan6jIgJLlwQYjKu8fKCCvNl01/AoqRjHLDiWiBL1SChNlcLcVHhxVmKw/WIqF0QFzFP5xxeESzBSdpm6cHb+1xvq8Pzhl8YjhZc7Dxxm8A2FIjJSWrRxxr7Xf6oSwOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094412; c=relaxed/simple;
	bh=zChY9g9QiZ2j/L6PoeholoqDqkO3cn0KCtgYtxidmEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LmPLQmIpwN5VgqJ0onTs5LnLInWbQx5RryYRm9ISCFh7SRCus8euiws+KhX0TjNHBLdS9CHyQ3848zdPya1iotgtfmqDMDRh0rWpRpqQHvhrv23El7H0EwX8Ry8lZBndF/XGb/t3UzEgD5RSG147pBo+IzxknuXwcTMbmHtob4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=T0yJe1ah; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="T0yJe1ah"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8946e0884afso17625946d6.1
        for <patches@lists.linux.dev>; Thu, 22 Jan 2026 07:06:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769094409; cv=none;
        d=google.com; s=arc-20240605;
        b=Cl6aNY9VyV4ljvXUINyGPqciG3j1mPSXM6/RZzlW1dLG0ehfjcBWtv0E7vnLGRRw9e
         MPuggEfCxamK1zbIIv8B+06ZuKxbP4eaCcdnoYQ0GYrIpz4SbxO/8dd71dO+0pxKOgwW
         O9f2D3PzY2iU/gj5jmYz/T55Hg/w38HrrYJ7nTvG717uqAcTTxRyBwal7ywn8w/hAxTk
         bhzI51MxEzgHAoFetyv5exvV6MEWqhQuL3chBEPm/s9uSxqFl0DgQUpFRSX0nQb2GUjg
         U8QCRT7wQiLs2ESePqQmew2kqs2Z8Yv0Yih9qnYHeFbPCUYW0vcLlhewhoRGwCF873gS
         BuzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ygDx271Y0S0OopKEObkAzsR5sQdsbflGYcm3pyskm28=;
        fh=gfaI2E2zMqSZEWdTtLrj7a27Binp0gTeNUoRO3y0HNE=;
        b=fu2ZYnJqdeuNDNZiCuJSFCesQWBLF9ZNM4FdplS12G2hK1zzBxAw4OroZ+DZbWv50H
         Kg/fpuXKc0m8xhi6jpfnebIFc6bZK7ZvjGVzbkg3jK5VEXWud0wpUxD4O7Uqlu/v1EmD
         WIlvhJbfbDGwQw23lPbO53cEtiFp5VE/HK+fdKBQucv90hFdup8uBYN4AZuItOi86xSb
         +aNR29enzXJl56UagIGACWLZpCm7O43Ivk8IohnlDrkN+f2j89axx3DPZnxh/gGrPXBb
         BgxMzq/W/xoIrJxH93a6cVa6IGmmQEkok3wND3m7nTrZo17hyaby+gY/3WXKvfWTkyjc
         b3Ww==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1769094409; x=1769699209; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ygDx271Y0S0OopKEObkAzsR5sQdsbflGYcm3pyskm28=;
        b=T0yJe1ahIOqTBd194A4rwjOb+QgrQE4B4sn7qoc88eo9up0eS1UMQUCIsshEk0iW1K
         THIfbN7VlsS/vCRQVlgatcDrMYFxPlx9JIalojPQDlD/uGSmpyWqrgbOmPAjhuHr2/yS
         cu2nMWbVCpX0WfYxUr4MQrd530QE4EifZcgy9bxt9KXn7YKlX97fJ1jfYdoV/BEcj5Dn
         omSUtVkTT1jr82VkXa/Ou+f9qPomMze6gjXS9rbsesSFveqW8DikVtL1EIimXjucqii6
         PnF/3Oj0/9Lam07L9SLoPHFSpTAVzGD8R6TIqCLxDeFzcFl9pJySdHvb6rSH0xfe3FJh
         8P/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769094409; x=1769699209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ygDx271Y0S0OopKEObkAzsR5sQdsbflGYcm3pyskm28=;
        b=S1y6CvrI4fYJPPlfIRa7yB17VLrkzuQ2Dc6VEgz9gMFSGPOgECcSVhriMWpav1bGXM
         U0GbjLix5ZrGc7J8nP5//01V0iV5G2iu6+blyN4HkCEkzJFs9mPjdTMntbwvIgK+NDWO
         zF5+Uo0iEIJsJUn4p+NEU8YcCuCHo0jJeot7ROrTVmqBeZSdX41s/uAh4slnBIN/h0qD
         c1sHThNczRLYxtgrKuPH7XhbT+GddsatR9eq2aBYhZmcubO9oBRRUsmw8vrGPI+fi57w
         KpeGM+37OhksZEwLmaTZvTWYdPInFQRcMHmJiHnS8EUpNp1rm6xuPrQreaWFbWPV+SdK
         Rqfg==
X-Forwarded-Encrypted: i=1; AJvYcCXZtM8qnjdiom/be8XV0Rg+F/0Gvaw2almxrGztqFN+lR0lxhUPxgzU4uNK4UzqzEjVDWJ65Yub@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0O66bLYXKNqrCciuMuCvbMVKNTEBGYTuBmrOaXE/mvyVd22Os
	pDXnck8cQ9w8giJ9x36gabCz9YM6Z6yWvhejTVnkVmIcjB7+2EV2NZbGJTYdUKNHGxobyA0Ly8j
	KL4KY80Mp3Dp79kcTSd4i3DIZm+4AlYMoYPpzLoQLoA==
X-Gm-Gg: AZuq6aKJQM+dFF+cUH5wDJ/RAL5dXw9nPUX6IBgjhA4o2Wtpj3QuruKdmZdDfG56Sk7
	ia18dJeC3Nqx1WHKw484C/Q3oUFNevR4C6I15984x2gPquZY5n7rwmc5ywDwijHxgQWknema3d1
	kdCRny4sizGBANjdKwrHz2g2hcVDwOyYSVgHvZ5EGKbillZ7vhOBeSKIZBozI6pYSfP/+EbL6h0
	Axz5SbFIecHsjQMoRzTkimI4fCp2WH5Q3GwZU5R3FYbMwIZdWS3CHb5g3zoEXdYtBsAJwJK
X-Received: by 2002:a05:620a:1794:b0:8b8:dd7f:f032 with SMTP id
 af79cd13be357-8c6a6979c1fmr2837675985a.78.1769094409009; Thu, 22 Jan 2026
 07:06:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121181411.452263583@linuxfoundation.org>
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Thu, 22 Jan 2026 10:06:37 -0500
X-Gm-Features: AZwV_QhMiQHqhJbB72TePco8pls6ayYvyPgeqKVZdDBP2ASsrAS5S8VEPOBSX9E
Message-ID: <CAOBMUvjtyWdRSR3dON18mN74uO2kLdhBB9b2V=Zm2qpJ-GQOJA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/139] 6.12.67-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2026 at 2:02=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.67 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Jan 2026 18:13:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.67-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
