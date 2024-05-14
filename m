Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE392AF09
	for <patches@lists.linux.dev>; Tue, 14 May 2024 20:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715717689; cv=none; b=sbX/CEtoi1FomvN6U2so0OlZsOIb7EedJQemU6vcECH8G4CJhg2Cx50ycaLZLHZHVVC+SQBIWAUZr1zJ59+61ADkZD21zAiJG5i8/EEK5w3rOGJqUHe59st6uj7cgGtCbFs/XKzcbI+L9HRljRggRMt5cNi6la0OV9KWO0ydwIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715717689; c=relaxed/simple;
	bh=qoYnJ6lUUZzta4RRGTWdO73OSuJNHfyk4iZIX7hypxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kvVueyZ1P/GzXPMwog7majiHT6xYvnqEbdhat75OuSZlr7WhuSfZgWChK1rlWoxTcQTVHr9evIKkiKWMDtGJz4G4eqlOEkZPOrv8HxMNOJ/rj6p8tYRHMgn/Y0j9KRltKuEfXoFvHxp7kQtqqCtgKKML55L1z+D5zYwVWmRIzD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CChVV+/e; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CChVV+/e"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a5a5c930cf6so61830266b.0
        for <patches@lists.linux.dev>; Tue, 14 May 2024 13:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715717686; x=1716322486; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bc4sGc3qRAwdao+8DdkMbvvomRi+vAtNgNPeosj6N2I=;
        b=CChVV+/eNFi0ejVgjLU4zTUTzOaZsWn6CmIxfTRImpcee1bnkKu5MU3+MLee29Ab0H
         6jMfFczmYlHIgdmzU4Vt++0z+K0+uCXptMdWs5Y9rVFoWNmH8YAOxtnz04AXlheHDgCW
         X8p82xcYImmTqEJpKPmmIyE7ggoAErJVZIFR2tZa5D5J6P6X2JxPOcq+uZ8hN2moI4eb
         lmOSOK3+Lhce+WX6Q2Zq6qLIrRnS8v2StuVt0hvjv8/tuoWCY5q4DbMC8pnrYzcas/17
         QKWo2ycyJfzOX57bZikBCkWvy63/b/UhG4uTUAxM5HfH4t79lbuj2Eermk1VjeXQORZU
         yM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715717686; x=1716322486;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bc4sGc3qRAwdao+8DdkMbvvomRi+vAtNgNPeosj6N2I=;
        b=t2o3f1tCbb7ouo5DhNIAiDT1oqP2ldJYjnZ9Xnjd2S1TJmRbEDSmf+0EkXh5kwv0QM
         op1dTccgXcYTM3MxDpTrat8aZ+04TGxkKiDMvL9B7DhJgkHQLxBQzL2K8cbldJGAnVG5
         6P5iX+1lskejZHpXBc7ZN9q/8FN1lQfynR75Qena5iG3Fsxz4KV0jXK/I87q2P7IFO8r
         ApS+IKkH6y9SumxKBAMSjUjRTEo8XOK8BByXfsLCSFs5PkyJ5kaYtticUJLQzIY1C1Dq
         7V0vxfnxkAqWSY3bzUP0vZ4UqBKxkA5P9L4V21xOXuuW2PxSooTXRRN+AH9mwx8O1Gl8
         NvoQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5l8zveRsClc7ZFsHg9RDJ3v9BH2A7qb7dnAtIeBhUrkHJyYF8KhX1ZDPpygjAyXIR/GNjhjk0nJZKyxieTb4schec0SW07g==
X-Gm-Message-State: AOJu0YzCR39yU8d7raJO6ySXxGkvJccPxJX1eII4S3+VzevsguU89Tr0
	dqyx4oklZObL+BcrDAYaVQH2EYdEQ5KzIF0T8mfUc7VbqcDeXoAU8H7DIH78AOl7sLZtCvhVGh5
	K6CdsGYocUz73QGWwotGiN128NUw=
X-Google-Smtp-Source: AGHT+IFZQpyq/hBgNv523DGpBPGSrC757nSkUJYg1HKA/tgjfNnA2n+ypdhVxgI1eO0Ho/p+Z1a2vMJOK3A4TPyx7TI=
X-Received: by 2002:a17:906:4f15:b0:a5a:89a3:323d with SMTP id
 a640c23a62f3a-a5a89a333a9mr182147066b.72.1715717686153; Tue, 14 May 2024
 13:14:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240514101032.219857983@linuxfoundation.org>
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 14 May 2024 13:14:33 -0700
Message-ID: <CAOMdWSLrThZj8SLZNBu-mnnyX_A19FswC5_P49bJ5Y9mMcOuXA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/301] 6.6.31-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 301 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.31-rc1.gz
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
