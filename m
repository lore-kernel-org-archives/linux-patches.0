Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DC5156257
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 23:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723158053; cv=none; b=tZTs+i9sE+6Q5cHfRrDQgX9/EpRiWp+FmR7fmMXFOETGJooPnPvPwJlBfOIqFYzck7CRirkqK4y9DgeMrh0FpjoOSGAloSfhmZaXysaRCPMmbvxhM8vVgTYT7Eb1roqb2hbaGKODNFUkmD21rfL7v7S4uETGs6EP377IHnVAHwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723158053; c=relaxed/simple;
	bh=HDwdkZfKg669WzeK8RdP0XkDkLGs2IT1MuZVSIU56Zw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VyItlKiojLWOg/wb8irBkeDUpg8tIOy6p+0ojISBUB3TmeNNHQete9L5YNj4X/cHY01qf2KJZIFI3zeGBKnsE4mynuay3pJ+uVDOvadABqNkD7I+LkxD5Zvt6P0vWaaN3ZqtNO3pyhlZa6AvPPIu4C+VNm0T6qUQbMholDdHYcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GHJrMPAI; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GHJrMPAI"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4f6ac477ff4so880933e0c.3
        for <patches@lists.linux.dev>; Thu, 08 Aug 2024 16:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723158051; x=1723762851; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dlGNe+kQiQq+j1tPjYRl+U7qon1kCBS85kse1myrA0o=;
        b=GHJrMPAIFLdz5g1y4zQnGIeYE8G6FQxAbWYgIEHEw7+X1IV9UwCyxDLEI8lqv0ni2L
         NYhz5P5BXbF0JjKu077bPnQvFqP0+1dynHLZa38xXyDwluDPNcWnuvnKut/MheM3GWj0
         r5JKJ6z/wsr9w5Wn46Er6pfGwKzKjXM0UjhEDkjoeTOWJAGaI3X1yW0QBTJhr1jM94hJ
         z8FlcOjj9oLwjDh9FH5cEvFtZWhzVJyJ7ywJcSrwKzWb8RgiD2N3jfKeKxcuuhRC+NN9
         q7Ky0MKJZkNAJVu+6C8cBiR8JkuiCdMsfr4xC7dMCLtLoe5722TvJpOIroSM7WKlxYLD
         4oEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723158051; x=1723762851;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dlGNe+kQiQq+j1tPjYRl+U7qon1kCBS85kse1myrA0o=;
        b=SnfqQV0jZNujDE0BWkb00GBBkKe0l+ChF+xQjMeHrJgKLmAp3JD3cHP6mqyHV2NKbA
         HFRRI0Welzs8XQQjrDNzQmttCkjAi4AAvIvkT5hi3x+AfRpkQ1WtivVvv/65YgH4AmTf
         kG9nFysIeipUYqVrh6UumNXo+sR6nWC7pBmVDbGh4P99nSCYPYzO3KuNUBUTdJ7wdUih
         yOljQkwwXlpyIWV6zTfgrufwz95GUCxOVWIL7oufxaXWkM+i+Ao3a5DKZ05blQlGuwBP
         ZVenY8BRXu5M90ec9r8cBwSY/rZB1++yuRAKnL6sjyHGQc674mvz5TsYueJYQSXhaYwk
         HGXg==
X-Forwarded-Encrypted: i=1; AJvYcCWDfn590/p8DbMygtxV+HTpC3w8aURTC9bJ3f9QNacWvTnK8XRYz5fUUxYjS0crQUcOtEkpBzF3EiIcM9DS9cttLFH+heXyLQ==
X-Gm-Message-State: AOJu0YwrsL0USPcWD3jAKiOWHl557dmMh1Cun4Mk+zHSsvUbaI84Hyud
	S64uf3d9UjibwUhlw+sqyTNSOUrl5nKnf09P1oHg9gUlPYoZBsmiVNm9VwdU9Wgg9Ps4L5QRWdy
	vJztWe24CfgUhtRZXcZLa/c50n14=
X-Google-Smtp-Source: AGHT+IHaXz0XGhbgdMz6ZETiBjPaaWJ6Y6jGZviOb118NgDdF5UhbWcuWjSTpTp0tnBE0o2xV3kNYHYP3zL/M6bomrk=
X-Received: by 2002:a05:6122:459f:b0:4eb:5cb9:f219 with SMTP id
 71dfb90a1353d-4f90217049dmr4594541e0c.0.1723158051328; Thu, 08 Aug 2024
 16:00:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240807150019.412911622@linuxfoundation.org>
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 8 Aug 2024 16:00:40 -0700
Message-ID: <CAOMdWSLk8jU2Ea6EpjX8bQo37xJU8pp46TTmejOG0Cc=SMW82g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/121] 6.6.45-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.45 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Aug 2024 14:59:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.45-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
