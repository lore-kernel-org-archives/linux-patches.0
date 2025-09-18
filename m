Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAAF302CD6
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 13:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758200932; cv=none; b=iFp0ScRdhijNM6qF8HFGvqrTC4sMKJKxSAR4ltRWCo2AyImsjnhb4aTutjniqTNA0pFCLBSVFbdkg12m6ujUH/szE8BqTqusH975bVY5qPuMII/9T3vp10gw9lJMMtmzT6bcEhboSpmvufcoCtCrpdSTedRWJvUMDzMdXKJS9qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758200932; c=relaxed/simple;
	bh=MiPOtFlUbt8t5mkkoOEMpCXHDPi78OTH6xbWfZ7DGRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XZtoGrgx14o1Ucz2tJNclg2wtji6bQ0hi1BOzbSLq8xX471q1bIizUmNU5YcFQ8rPn5ufuCvn17RspQZoTsAaCGhbavBTjEQ9hToKufG8sg6FXe9DoIK5GzXolxZ1Z70NWstTNNHVjf9VC4qPcGY0xy/v5FkAMKWRyDa/CFBhpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=RzRTEVvy; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="RzRTEVvy"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-82a334e379eso60630785a.3
        for <patches@lists.linux.dev>; Thu, 18 Sep 2025 06:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1758200929; x=1758805729; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PGbQKBDEp65TUh3jBVAZzg6GKFTf8pj7WLSq9aZrdY8=;
        b=RzRTEVvy1mrUX3wStOo1qiuiT6IuHHp12gEOGnD86d2IYsk5GqA1WeiRQ+kivdYARA
         dCLzdPUZ2Csger/QLhihZeDU7i82+K+2K4B/rr9bGDvKvX/KqpvnebwjQYDBpw/znfI9
         Xq1guEbIrMOlLnYYNbCphk1tuJ1ZZsg8Rxq5rJKzP0/5uCRze0s8C7sA/TCGtM0zUfg5
         fmKOOXibtUm3IhA0sG6bc2MOMeZs9qgk+gY1/TNjjaXSmAzUS28slhDxPgzFy0l72LKF
         gei30/3+35HKL+YG+ZL7Nmf5lohImVlFptJ6kzLVptWcxbEezEe/er59KW3wi5f6opxT
         UdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758200929; x=1758805729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PGbQKBDEp65TUh3jBVAZzg6GKFTf8pj7WLSq9aZrdY8=;
        b=fIuNj5WS7VWU81mZczDjxtWFACd5bblNPsxcTk5/UNwaye+O79s2zzVVRJrlcg3CdH
         izJtfMBy1PsYIBqEXPT7+ClieZYU/i/XR/CwzarM5tSkj9+AeZrtg5fKyF1w2xIWwb3E
         v+SJfYHI9x14NdYbJImy/BBc5YblSBV290iEBHg2qbSe9QwjwN3fcEVHYc+GRC5qye3f
         S10mivCmRZOSBhH4FixLRFYAHVJeNad5qEevEx/zw3HJjTbWTsWbv8g0xlr8u64bTPQa
         Pf/w0kztC/XaUUB0rIj3OoN4hY5ksGqtNK28ZnlLuJUGIB3E8l6pvbJCFqT5OIrVGw1M
         l0VA==
X-Forwarded-Encrypted: i=1; AJvYcCU5lm9kej7STCA3ZcYNxMIezsJ8PvXgPkPmMcOc/SDd4vflztB6s384wvaQ/wZk8gSW/aWQqKqX@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3tC3WBbpBdy5iJ0JV/QdE+Vzn8xy0BTn73X2Ojpbc5i44Lvcp
	/wyNwg01ObKlFFADE2r+gz7GG5xLubgDnUK2KU+LzW8oSZ927yLaBtuIcZcBMiBrSWdLC2YtgaR
	2XTtHg+2wdVXu/g4teIEf15MmfprHBPg9vbN9WVCriA==
X-Gm-Gg: ASbGnct9QmVQPYgWhVMIMMJmP/Wjbq3lWYlZreQnouKRPDrfZlylosksAR1EcFy79YL
	4VvZhJz7QlkQn8PSgCdBB+JFU1HF3rf4el7uTJxfzWXHUzHSxFYdAZnkxmHQmJu3EEvFEUyDrxM
	FyF7CYfrdstIKEZCdYvuY8GVo6O5CdH0gA+ZkG7cm7uxNjanOhL88BV3b7jnTt/Bx4zfqe8LDbl
	87c2z9f6sNf2UL7/2l12kA8gho=
X-Google-Smtp-Source: AGHT+IHelxpl1f80CJWLjoVJmEHYdJGPILPJ9Om10uXhQBYkh+errVXpSNl2QIO11FjsrjCy/TZGGAjpjeDzf/ykliQ=
X-Received: by 2002:a05:620a:29c9:b0:828:47e2:f407 with SMTP id
 af79cd13be357-83110afbe1amr582735985a.60.1758200929182; Thu, 18 Sep 2025
 06:08:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250917123344.315037637@linuxfoundation.org>
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Thu, 18 Sep 2025 09:08:37 -0400
X-Gm-Features: AS18NWAnVFAbN7cGEMPi5uSP6yfieOtzy8GuF5GwV4ANGOF8knGeTQaKAOU9C1U
Message-ID: <CAOBMUvhwfizZxP-YT9LsOwxEJuasazs=JHhh44EkLzoE8q33Xg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/140] 6.12.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 8:52=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.48 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.48-rc1.gz
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
