Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0372326D58
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 13:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758634946; cv=none; b=O9e0OuuciJGGoKEC4KseNQeHh2r8anibw2ITS21MLuSNYX3j0jCrOFUSeGQ6OZOITYBQpeHoNSCHxiN/eS32cgZL77HBK6hjEMwfXRuW5aVIwHnrrrdu6P1aK1Qro9KfRFDtgwli/RC4psO/1ww1410TYwTEMhWp+77oPh8oNbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758634946; c=relaxed/simple;
	bh=HS9NBcbYrfF6iVaTRVwQjnuNP9ZIEYwzdwsQ7rWcF6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VEz6bBvcBxrJrwWqhYIYuYps2wpi/OQ0/hY20UfMy9A75mEp+fVNtxuBzFPSiRVEgdXxQJ1fwaud3hSCRb6+S4dYq3xplAGA6vBoEpZ31NfwYIOlK9cnDX3x50apw/EOr81ya5XxodLyCWgYWt/bJAy6Hg7hRRaxdNm8EDH4WjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=bH7F3aa7; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="bH7F3aa7"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b5ed9d7e20so54396341cf.0
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 06:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1758634944; x=1759239744; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJZq8+MPLRJ3ip5LcrsBDiUfLaLP/BnDgi1MJHXazU8=;
        b=bH7F3aa7dCqwQdXRuvC6M8kPRyj96QsOxLwUcCdXBjWymM8XV9yv18GEuBegY8/qfR
         1aPsY9SejDyf2KPG+bKceDj6/sSDNlxoZ30OYzAqUpAy52noA1buLUZK3eqwwcvat7cB
         +dSYLmOlV83A4/OKHRZg+uZywoJQqt5F1cub0qHimTryp/sKVlvJQuX2CIaOiQCtYjzC
         25r65TWLpsKAbieevziuq3/U5MpMONcTv1ipG6xa/llhJRBOBpA6wlMfC+NDrduHJyBr
         XPHwZ24aHr6ClNBR9Iie0whgwx14JfPwnzodq/CgSa6OQecLoxCVz0Eb6pNic4Csfl4g
         CIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758634944; x=1759239744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJZq8+MPLRJ3ip5LcrsBDiUfLaLP/BnDgi1MJHXazU8=;
        b=ViNYJzivaXzdoGt07s3Aw75eIFlk10gjydpnSuA50v1EKI4sYe1+dUscjZXZ9W3YHZ
         e9nhvaGe+pesNrdnZOJxeeiZiRNsahvh7LNBfe+nJ1bNCNWrJm3LXwMGIS+uOwmcAkR4
         QN48L5atnNujhhqVGIagxhE+knKqM6hKEJrFXHrHHtH3J9JYBiSl0zaCi9CVTiMjYW8J
         8LPmXIqCreyTIXffZGdUKSkArV7cieD45IHeCV19DL7/KGNNDbnjGqXBgKmnV9M0jtST
         kF9y+tam53Ma8lWpv13ALSbOdD0f5b6/rDfZ/7llBtIsF3yrymRhEcmPpxBsmAtU3zqn
         3k9g==
X-Forwarded-Encrypted: i=1; AJvYcCX7RuBS3pAvilg+l7vP2Vbe/rS4Ly42l1k3Gq/YZwsZOFUmJ459I2MLia4HQHjjIWMiqwsBQAC+@lists.linux.dev
X-Gm-Message-State: AOJu0YzpA1jI32hmCqW4avDniRHi0Tqsbmf4Vo36VPBffWzWusbPJ48f
	1gFd8a+xt7v3nFnUZPC75rs1/ou1p85g3V9S4mQFLCJppXJ3ut6SofPsQotad7lpjFffeCZghaW
	/ALUpKGJfMPyMXPjxVO00gkSZp1QoXhNMJNrNAIybDA==
X-Gm-Gg: ASbGncuT+cUbrAi9GuXYwHc6TsCdh96u7/HqLNWZBSdSwCin2nTlqINKA3Qq/+PXhfJ
	VnQZ+JNcwXwP6CCb9cw0YqV/4AeGk7qk2j+7LuEHc4j5LWA24rNNQbVLWm6dgTstjnRGjAO4Ocx
	ytHlLKyKwnNgUvpKkE4H39aW2VyH/xSEbg/ybxUBPsnLj/Qlk9nABX0atnMT9jhqy7Q3ITyFbiD
	cIAdxxE
X-Google-Smtp-Source: AGHT+IEqCByMJIyOisFneYcEhg1XccZAqMYXIft+cqIQMRrJVBiZ/D9q5dXHkPruO+JLDBqSs2MuwjOhSz0Yq99OO8o=
X-Received: by 2002:a05:622a:4a18:b0:4d2:6ecf:9123 with SMTP id
 d75a77b69052e-4d36a18d5c2mr26501131cf.34.1758634943106; Tue, 23 Sep 2025
 06:42:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250922192408.913556629@linuxfoundation.org>
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Tue, 23 Sep 2025 09:42:12 -0400
X-Gm-Features: AS18NWDivHJSj_z1iQ5jwb40ouc0fUOHoSfttu2yx42awG0vFzK1u2_FMqUyWE0
Message-ID: <CAOBMUvhU3VMwD2OnmR3zewO=MQhT0o6WbE=4rEbZiC=xTn_xcQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/105] 6.12.49-rc1 review
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

On Mon, Sep 22, 2025 at 3:37=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.49 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.49-rc1.gz
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
