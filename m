Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74895839E0
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708535267; cv=none; b=Q+xwTtyTnrjZoj45XgDB3xmGs4V/GL6lXQe1zJmO8ZulKGFH0dt52WBFRrlnvo/CyPvH5oFIwdg8V1rgRY2AqE2JDiESKWSSQ9t+US6mSMTk75cirE9yCPNapHe/355YA/gwo9r6vPy/x/QqyG+8II1/du75yJ5mXpshNgxMdkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708535267; c=relaxed/simple;
	bh=zd3T8ygLSvLGtEjsLVelXVpLdVIjZK05NYGk2La0QAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oah9WvdiGdLBN5LW573kxZrCkcJZag0kqyvWFJnfonUQdYvEq/1s6jWLEdU2QT3HQGiIEfAMNBMNwz9XfcFweI9o0icqbdBy27BMsqdpj6EGLmc0Biyt9J/wEKNamadBzQquleIa9HKVNcC5XtUpblQEpIcw8Zs+Y/hasDbBRUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M5LNg/A1; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M5LNg/A1"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6e2e5824687so2394711a34.0
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 09:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708535265; x=1709140065; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dB/pV20cS6BwXBNQs60qJ05fA+DDKBXbgz6n38a3jQ4=;
        b=M5LNg/A1vEnJD2Xe4sJwSZCexhgGw6Th4+wwtgJPs7CXjRUSXR9L5m0GYwM/AzpIjZ
         48TJ+IA9LuXNil01KIMDTJYHDaIzZX77s+IFu4P1MWubmCrJKK0D/MB3UfH9GPNWtcjv
         zp1KPMUwcz5TmXjn2K9/vOXKzkXP9XSVnDpqSRtCKmPyXNKwjscMobq4DzI2fiq6B1DM
         7COk1BfTvNL78MsCk037Ua1C0jnbsev7VUu1FbU6fs4bcP5mhbg5S8VN+3FkjgjL+XJN
         0nfFvp5bmfFnFIqfkTkd23RFyyKG1Ayvaw/U6k1HT9MXOWf4flsJ53PdCo14OnLXLYLo
         pRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708535265; x=1709140065;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dB/pV20cS6BwXBNQs60qJ05fA+DDKBXbgz6n38a3jQ4=;
        b=TVM3uuTxaguiJVviOc4WnhG7FgLsjGrT6gCnLmSkYt3g+ZJuXakjXqXoT1KitgS/G6
         kliVri00J3Ob17H6bXiINvxVYqyHfR4ZP2rqreg4FRjRCHhhg4OZlm34q09sDmOrnz4u
         A+4Uhdb0VLXA6Rd7i9MtCgobYgtrlAyknkRDnCKgPTjk0aVn4wtiDOBOEY13UjufhFzG
         NAqJJ9v7sGjeVS/QUYc9Okkm9D+bALICfU+2ts9jyhnfzMSgMKQl6fgH16EFxH0FuLQZ
         kPp9VJxiwEr5sZjvHtzpMCMHoDO11GU6yGejrFxoU4BRRZZ9PJ6mIRWGwIqJZ5s/Zx/P
         LobQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMFN2x0hZu7HdFyCn05Ioa4ZWodhHAekAAeXQH11E/w7hfgsb1IiF1IBxLtnUjto/p7npotFC1BDGIXexoKqKyMn3g8gG/lg==
X-Gm-Message-State: AOJu0YwB31HtKevzqYdx8FMHBeKXy1moLYusb7pZlmL33QPietw/kCxZ
	ooyCPf5Wp/I+tgKP+i96ZjeS7X8vbjbQZFwZLFijuzJeCNtDc0kvJaneNb2KJc7DGuJPVyksuUO
	UEFwMTyESKiX5muh1GF6bm/093ok=
X-Google-Smtp-Source: AGHT+IFziaSIzRa6OEQTNjCaJ6MLpRnGpfMmEz3aVeBRK3owzTgtB5MeKyrr3qQ2cSif9s160uBUoplw/CvlOKpvpdU=
X-Received: by 2002:a05:6871:713:b0:21e:6670:b84a with SMTP id
 f19-20020a056871071300b0021e6670b84amr15666263oap.5.1708535265580; Wed, 21
 Feb 2024 09:07:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221130223.073542172@linuxfoundation.org>
In-Reply-To: <20240221130223.073542172@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 21 Feb 2024 09:07:28 -0800
Message-ID: <CAOMdWS++_6+L4bzcB8-ZWZ6ZwRV=Fc9cuU+U=h9Pv_Y1LQF-WQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/206] 6.1.79-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.79 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 13:01:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.79-rc2.gz
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
