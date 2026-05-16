Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE2423ABA7
	for <patches@lists.linux.dev>; Sat, 16 May 2026 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778945698; cv=pass; b=hZozxBSUPdLTWLII4594B0geJ7Q8DJ1NU9j1K5ngHLpa1FE95Ri7oI1PhtV5aC+k3bT95cd8ahXjPdCtx3uZgIlENqHKBF5g6I2YtUtCqhiGVrjqdhq3+TSs9L0dc451zxCt+LqfCr+eMcSkTDEWwCBVJXch7z4nfbSM4n2Na78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778945698; c=relaxed/simple;
	bh=+cugz3qcHJXf52vovJvqfaEyama6rYc8M5HfmSSwDl4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AjgWMr0GXut9kUQCWe+MJynfNHnuC3pgP/GSLWl2tIzbMtVCCYfSYGouu2eqWv2xfQQnwCb6uDv3+KctSTgGIsnIGnXVuv1z+PtzzHwMVzfCfe7J2nLE7QQ1h8YGAxcxFZEFxqAv+4cKHK4Zh7VB834IpktFeIkDCLDLCMzbTmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=lElfg4Jk; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="lElfg4Jk"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bd36614d329so133010066b.3
        for <patches@lists.linux.dev>; Sat, 16 May 2026 08:34:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778945695; cv=none;
        d=google.com; s=arc-20240605;
        b=jTGTqoANPrJZWThEDu8SnCO98TpCM3fot26BsXRck5gPTmZ2qVnG5qFm6UC2vFVZUQ
         S6Wvgq0PXlO1MssCjl2Nc8Mr/OzIdcrciOI+fdJvB2w7Jl4qWCHSCKF9ZO/VJRZaUSqa
         cxhzeJO5mwoIq+ic/fhz44Ujarf0Dwe4cn1V627mvj8rmgmhBDOO12etuKebEACVp0GG
         QOAGWgxTxiGrKv8N7wxSJcrmAHQQqnoixOZzYqMfBWoKyPJyBA9BW8PnOZQQ2CHeGUSo
         h6Lrp8qrR/DHWfvXbyIjFMw2QNjt8JqqjYEWwIW2WTCxTc6VUgjqH1J1LF6CQrxCZ+MA
         eIkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UWadtITEJG72qphLj6NIaywE2y89Me6+CuOxpH5iaJE=;
        fh=tVuWWedfml+BmInwnW0OHZJx4OC83ZF6EUJqN4tBX3M=;
        b=AvXXLgk4cTtWXo4LtjS6hSxGRLasswgPur9KKnssWiOXd6eF+fRXDB3DNiwCxlZOn4
         xXqNarkekZrtx6pDO1+Z8MpPGpGEPfJYEml0AU6EPdMs2952R8NU9z39wdjsGlEWbrEX
         dud06+xpTJRQp+Xywoh2pzc6DjI6Y+2HPwRAqhTqLrn7mcl2lYjMxZTPGxCvfn+jfk75
         KmC7aaZCaHI9nrbc6cp3CaqVSGbCnONjeaZtrvk5gwlC0gRBS6V35C514PLxrlTFPm+y
         nVK4/NccRsf7ZLCzkY+Dw26/nE37V5qGURZ59oad3poySkqn4ZdCl+NNY/L4NpwZPP65
         +PeQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1778945695; x=1779550495; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UWadtITEJG72qphLj6NIaywE2y89Me6+CuOxpH5iaJE=;
        b=lElfg4JkI7fcKOruJSWYlzXc9NfV8l+n6GK8d7VPJyTMvJni1JFTzDUTppr1Mz6sGV
         JGuWFUndP3VpxuiPoxj5Lkq+BrYXLBZjedJdcly0D68wGeUjCjxDbK0PUVCPfwNlnOci
         5VqIaYC90eLzRCVnCvhvSpQ5W6mnPR3qrEzzShE4z+1hyLwLhPEjGmjC4ssICHpbCBOP
         10oSjLZLtYKrh2dvl11BSjyJzMmrh2GHnRuU2YvrrCyhYK5ZTgEAd1M1MyGaW9/uq3ah
         wc9DV5fxtvcUM1341sLTmO9v6rkdbUyrPTt2i0DVWxqQ82Ix3WIAKCAOsG9VgXaROtvh
         m+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778945695; x=1779550495;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UWadtITEJG72qphLj6NIaywE2y89Me6+CuOxpH5iaJE=;
        b=n7cl4gvm512GZ77lN2hOIXelnlg56WNxlAZczQGmslGL8IhiyUJwF2UhBIIYnOpy/d
         Rj8ZnQoT/O6gNoQ+oZDJTJKkuH+VmesAzD9YnkdXrG6Mn/40UC+jNbNi71BX2+UoeAbn
         VWAbCBee1Wkprx464b5qYGP4Y2RRs/AYRrpVLlmzaNa77+bWjhUzEkXskZUTFJlZkm2A
         x5h293LxwiQ2puOj91Iz/62HCNXsfl1zHRWVh0lMBsVvYLTi36Lm+RIVhGfTju8KT12F
         I2jxyqRU/Efz+DLC4c2Gmbz8cb8EA8ojSbsBmsF3wy6OYrcxWQWakG7LJvOrTXBP2i+R
         0Syw==
X-Forwarded-Encrypted: i=1; AFNElJ+D6opnAhlYDb7FEDPN7kGpqjtDh5pzsyU0r6kExYWc3a88JmMEw/RqCFewsrF9T5xUa8o8wtEN@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9/I2t0VDEu/qaVH4SxussHS1zEPxHD9s1eHypWGSW9SQK5++O
	2Wi3e6C/iV17pwW5oDHTKwheQM4ifiTurujxXhn4h/r3X+fidzU1UqdgfXItsvs7jjZUkjHYhAt
	jRvFIZZ4um8oEk1p2JWq62pSldVss4ObKucE3MaR1ow==
X-Gm-Gg: Acq92OGaZM0AKiWjZXKEOgfqK/wDlk2cfeE3bmamsrxfjs3k1wVjUnEy1rnOJOMZEcB
	m7XKGXBUXxSANXiaV2po9dsTVif5y3i5ai7CVSx34QoChA6VcUIIQCmasAq2Ll37c5bXcc5nuiz
	0KDDpvlqxw5Mlr0wBrrkbVx6SYlVscCf6IERhQDLsO1XnkpTKDOtXHeoML5NUgVLvaWDBuJbnaW
	jdBASysmA9iu9Npoql4e3Ym+kn+by3FqWMjtP+7bYzfffyD606c7f7POZgzZYgY7halNInYJUNi
	gz+5rRzXcZjE4wSx8fYHOwrUc+e+memlCc9kKRzmo+hUOxAAQyh0xseMCWKvRqvS9uStyQ==
X-Received: by 2002:a17:907:c291:b0:bd5:ca8:768c with SMTP id
 a640c23a62f3a-bd517964d14mr460137966b.31.1778945695567; Sat, 16 May 2026
 08:34:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260515154658.538039039@linuxfoundation.org>
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sat, 16 May 2026 21:04:18 +0530
X-Gm-Features: AVHnY4LxnAOQvRzxfJokyUUI_OqBa3SgxbMFiyrzHazI8zU1j4uq9ZNPwPn0kP4
Message-ID: <CAG=yYwmKrTrJAFTrP4aFFLov_XS7tJMeU2AoX8Ed6Vw1mnfBXg@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/201] 7.0.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello.

 Compiled and booted  7.0.9-rc1+
No new typical dmesg regressions
.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
