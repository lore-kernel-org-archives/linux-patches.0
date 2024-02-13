Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A612962808
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 22:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707864442; cv=none; b=bBtvVMv9MnbZHvMyaIwPAgJvRgK38a1WWtz0+TcMYreKO74VhM1hzv5BiQheyo+zcwLlM45IAlsibcvTKwmLzEIqlS9MVwC8WA7BhDDAaSaJfXVIVYl2baLjTTY1TFblctTtX+152R0gob1xpM2sVwkMoz3CuR8OvKlSWpTmDsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707864442; c=relaxed/simple;
	bh=eVPe262KL5txyrbYMbLzXbUU9gV7aFN2qZYYl4ixgqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wul6aTVX+ySygFxwOjCS7NU8XcPm5k4meC6xl51jBv6prF0nRWPofvcE4hOV6kqp+9hSdhd/2XZyzh85mR6BXznHeoA08f+fkYXShB2KIbgGSgVvABoDklYI9ygXKuGuXgQ/iafqJ/80hXZ14Dvcb24D48B++GhCAzfTXIPRPOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a5EHdIhd; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a5EHdIhd"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-46eb801f6beso614333137.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 14:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707864439; x=1708469239; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uZJa89RJq9/rdjHSYfpi6Y6tb6r1nGRmowAt4bkZ1HA=;
        b=a5EHdIhdH93nLjFHMlF5U08w3iqHEDiwFZyDi4MOtPcZwZwL1cuS8RGlB6HldPwFva
         ntccLNJc59W+Vx1PP7HRAPa2yFRGe/2nydglTRGT9dRfltedfU2eqJT+mbMFEQkgzOzV
         zQ9y+p4g7eCOkzImZoXoaD6Ti99iwrCso3HErqXiKy4pksb+2oUusdxsZi3PiVa3XOLJ
         /mp1owPK/csbQV9AGFwcoR4YkFjvskhH8NkUfTRCZCvoAh3y7MJg3go391W3K2SAya7t
         r55k+v+lkU1lrzj/vOd7KZz8IbuMiLxFNZo16z4cPOtkflHvvIko5iGWitUIqiTrrnU7
         Q7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707864439; x=1708469239;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uZJa89RJq9/rdjHSYfpi6Y6tb6r1nGRmowAt4bkZ1HA=;
        b=HStzbRazKP4PtxiuScbCSGUm28GVPzjAP2h1e/DypgGC0aImjACtGtlkTDr1OLHg4H
         /zeNUsQYrEXhthanH76TLUmVRmp8laohcsZPjrnFdYLGO4wVkfMbqxMw7Z4RLVIL3GVe
         kLCmWqe7FU8Y0rdIExOmSuYg5wlZaomdqRrpZD+dFXPRg5eAzyxAcmoTTrIFezPvGzWB
         CRDPEnuGOhaeIQ1G7ZrrAuujFMpeRSmHbf3nJN3tUEPSAAOK8TpphAjTyChwnBjn9/bS
         Cg+LZD+wzRLJy8etTLWUFpCqRN/BcoE+rrWuSU5NSXqXKxe6f8FbIjnZEbxbCN4DegJ6
         gjrA==
X-Forwarded-Encrypted: i=1; AJvYcCWm07NepihkzB1HC8Aed2WgYA52pY4ZKSNZ0S42CKRrC7LOVfoJCiXRbKSlNvp66aQSlioVl5U35B1GJyewthXO2PwOwxkoGg==
X-Gm-Message-State: AOJu0YyiW9WNI/0oA9fF2Q9YWxFbmsg35QQUGSc/Cju/4Lhd58aBRP3o
	B9r2JfBbaIZh/PbzVjicmFWOGAJYQMHN1S94Imzesk5UzrQ07NsKSyZmH34fRBYPJp3bkcPcWO0
	JtiP/8x/CeWDP/RM5+5WIu4ax9Zk=
X-Google-Smtp-Source: AGHT+IGA2ihD/EaOdHXgEiURlNYNvqcTKKdt6GmT3qrNYNzY+WvIxYeVQDikGToQCdDavXOeirGl2Dg5u4UhYDldlKk=
X-Received: by 2002:a05:6102:742:b0:46d:1785:426c with SMTP id
 v2-20020a056102074200b0046d1785426cmr1014648vsg.0.1707864439577; Tue, 13 Feb
 2024 14:47:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240213171853.722912593@linuxfoundation.org>
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 13 Feb 2024 14:47:08 -0800
Message-ID: <CAOMdWS+0uKLqpPjJFvk0Dgufq8ih391bpbKzDcyFWt-GL_ib7Q@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/124] 6.7.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.7.5 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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
