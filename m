Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86B9111E
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 00:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706573601; cv=none; b=F3zbkxvPtYSOyYjsfaVRtCNdlyvm7ry9TMYLWAiIgjenHDToAxbhFFb3e+O7tNqRuKdDUXf9LW0VOZ5SJP5rv0PWvtykWKsslgFIEnwI2xH5+eagO8t98dpPjZMRa9p5a/+kEJtM/wWgZvTqhtQBGaXoIuSYvQLwjNJ1krfPam4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706573601; c=relaxed/simple;
	bh=QyHmVHAC+TVUo1czRElW+MEYu+2WhF/0iDIr7Kq9EB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t2nttRFHwad6x1lnOeALNtvu2vO+TOC6KyivoRdJ7N/1vewO8PEWaBtdV7neCepM/xaHSVwe7XGbtWlhlkkQPQD14/+wajbvIz1ThX4fnrTI7qiI9OdXDI6oXfnWOKleTRAcqbIYt17naiA6oYvSsRceVtauPxgd7oyxBbAdbWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mpm+mVam; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mpm+mVam"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-7d5c7443956so689857241.0
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 16:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706573598; x=1707178398; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/fWsHVtzrmK6enBrWP1Xfl/r1UntvZqZVjVd83aREbo=;
        b=Mpm+mVamr7EUZD8xihlCwahxfItL4Do7LDU4zO/kQCvuhYtzJs9r9iatJfrPYsg2eK
         +JH+tTROneC585dWgfay2dfBpcgJePJ+zEYmZdQPF0MJUySQv7xsM+uz0Ogv3Y5CpKGM
         fAJSa8eKWqXTcMkEe+PK78g3jvgFbUoe8dLdmLs5UYT8636XUhii6GBWYq7P+pj+tceL
         8uOUyLTBoqL2NIIuGlgUj5ubdmdrMiN/GHGqd9y16EkAANUmRFvZCeKhu2jBqKYG+Tou
         ILbSGDeSJyxQ4FqYxTcDUdtURUPOHauPsovJS6kdWe/Jid4V/de71mhwQ/pzpNUrPVjh
         i1aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706573598; x=1707178398;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/fWsHVtzrmK6enBrWP1Xfl/r1UntvZqZVjVd83aREbo=;
        b=u7IDYtW1TyRI3rVzxglwVC+IfQKUCWOWVap6nXCPLd6aM+6lSJHgq/ZSYD+jZCpnlD
         y6YoV+d1aZK7VNUXLD1QIL18e+AZeX8/bwq/e1hEqZy8d/yhEm+rkGdhaZRMe2LW/6+a
         CTjKRHWCzohw+as30MC8HNo31mDXKE+VEL/Wa1lZnOdvGuoTjeN9+UkecH1evFMmyg40
         PtjgQRGzFQHn+vpfyosYKA4tnCNCa6ymoY/M4oqC+5BPKAU0XBCgtxwEo7Ogf0GkDIBO
         lbLb/IHHlHhQm1zuPNfhlV48b2GWr8B+DMZrgMXG0h2g6rJyO4YHMFw5fjY+hxPncV5l
         Xnvg==
X-Gm-Message-State: AOJu0YznD2wO9ranSj+WMSmvbmxR6/+I4z9BCyjnLIuFpoLhyjhEycOu
	pilwzMtJ8kLVJ4fOuqKwO+98La0Szc9M6Q8+gEcIX5QIPBBZbL9NsljGoDFOvj3yX2fglMl1/4h
	0gCP194U2tE+/h49p7Z2OENojHlM=
X-Google-Smtp-Source: AGHT+IH+1Y1YR5slTxNiShlCdeINyqEd3o3AwvXiOlyuarq/aHP544BQNXwdBe3II1geLtxR8QVLb2CAR+sB2ku7SE4=
X-Received: by 2002:a05:6102:a05:b0:468:2bf:6a91 with SMTP id
 t5-20020a0561020a0500b0046802bf6a91mr3722735vsa.35.1706573598609; Mon, 29 Jan
 2024 16:13:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240129165958.589924174@linuxfoundation.org>
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 29 Jan 2024 16:13:07 -0800
Message-ID: <CAOMdWSKCKXW5ho5PrRmMQJh_qk0hsSt=S7qSBS6pWZ3hrCfV=Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/185] 6.1.76-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.76 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Jan 2024 16:59:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.76-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
