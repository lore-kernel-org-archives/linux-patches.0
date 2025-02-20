Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB78A20DD43
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 16:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740070093; cv=none; b=UmbxUKyBhhnUtf/zAO4ZK9ShQu1oVRoaAsBp7ixWFTQ3pi0sNyDCVQp5SHELMie+Rwn/+5N4LYXrbp7VYdnucMil8v62L0X3zHh3TBWNN/sGFFNw6EFWW7Tkm1qWnru6R0E6NLUPanhThmmyTmWYmGBSVjD8ZMlzoqax84qtnQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740070093; c=relaxed/simple;
	bh=pbdR7nxvueo2TLaKE5sF10t2b+oN0pSH5FKcIBPg2yE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c8ago8pRuWnPu2QfKG/RJbEUEEDZqBxZOTU44+2X4vfNOOPet4r4C09z7u0tmjruHuJ+NLeHbXKDLi+gh3+ToUwIiVpQTMUhU1EMEOahmWmN0vIwvlkJ/EMDXoOUxf0b+qyLagEUvTCp0LHDhuj7UjjltQZ3IxLvtCCxXybE6ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=H/Y5QNnQ; dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b=DnvXtYNn; arc=none smtp.client-ip=148.163.129.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="H/Y5QNnQ";
	dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b="DnvXtYNn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.com;
 h=cc:cc:content-transfer-encoding:content-transfer-encoding:content-type:content-type:date:date:from:from:in-reply-to:in-reply-to:message-id:message-id:mime-version:mime-version:references:references:subject:subject:to:to;
 s=selector-1739986532; bh=UtFu/7rrHv4X5KOTvsXatoIKvP38Td4ByIZSHbNhxXM=;
 b=H/Y5QNnQSdKVkGKUBSTSBmttqgIjVEe22rsEDSKU8dDUSQA2Ftiza2zkwLPXL9vktGDaC2LrNl0/ph5AA31veXHm+rggUejAGdgcaxpupxnQimmgcg7b3da/nbKqbPcum2N8H+90iLmZyIqdQOWwQ3cNzzjleRgSi6F/2jU9DD8YEiSnxVS+8teeOG9aAZPmDofL2hk2yjPMcPAbylFakkwLqX1pgqMFyKgzjGViZnQtTTxv9cnMqkswVBQBfxN9m7hofdqlu7veQeunjTBF86TdA2Y0RgRHylX1Ib6O6dLIwycum0Qgvhvva3ilj1DMp3u3zbmsWsTGCcVDNmznWA==
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 59637B800F9
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 16:48:09 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38f2726c0faso1480296f8f.0
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 08:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=google; t=1740070088; x=1740674888; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UtFu/7rrHv4X5KOTvsXatoIKvP38Td4ByIZSHbNhxXM=;
        b=DnvXtYNnBpF29Sn6RfrP7YyNjVYrEXCUk4qb1CVdRlAHaOSifB1cZ/Jb/Iikjy/moU
         oWOglxlYJzDAYn4slI3GWpPgwyUmxYsb1erdlCnZeJ4RrtDHqklQIAjmr0S5rh7cpw6G
         DIxEGPrIURG1d1gby1jnVkouXOt6s1p0bmKjxwK9JGnEZchdr+WrQ4+cKhbWFgtb+1cK
         CO6zf6QBwndzLcPv0dPPv4cyTfsWhuTbS41ll3qAMRViPJiiYL2qMppCcKjcEwUAo69b
         9h3RpzR0KXnKstd+qF6CekBPwMq00Jaf5pXCJB0j1bCYtBhqPxLM+rii4hE0HyPPiubu
         XAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740070088; x=1740674888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UtFu/7rrHv4X5KOTvsXatoIKvP38Td4ByIZSHbNhxXM=;
        b=Fv0VXGXV6fGl622zwXZpwgdXQsgjHZhrHswq8eQ1ro4lhjZGEsgwUd/gdzza/Zw7+v
         JvAGs1XS5ONiJCGe6lBVDyR+SZOIbd2jQJUVZReYQzlW9d/G9GPU8OrWT89eZTKM4Ni8
         nsE093VJ0vMuNYSvWzr1SJ+GHvtHgjBUICx/ypG3rS/JTs8DFtJtakFL3I0+gidBTr8z
         ABwVCSn3ZRHrzJ79kZpekdRo8xscWrvMqJklgZswImuLlyP0lWOx6MdO+L2yhGi9Agm4
         EY6r0VK+IDClGkCu2vy86etO3d/c8OJnorriFHYLtjcIIF/1kWYDPk6Ys9mMRY+WRk6H
         K9hA==
X-Forwarded-Encrypted: i=1; AJvYcCXCS6AUQuDslQkX1ApEvA0Yi5M8D0p+iFg/5Suw24xVCYBM5E83sxvOH5EyDLGR3rJacQPr0LVb@lists.linux.dev
X-Gm-Message-State: AOJu0YxeDH6Rml9jL6QFU0lMBJbeDWfruaHVbHg5nhcuP+J+1SvKPuT5
	TFxo5pAatgVK7sqdllaaLjhBqyk4nArs4E9+J8PmfrCbZrBQGJBopX+KqKMRQv/w6JRMUX18GfC
	G4YqEUlYjWHRLRh0XnMlT2r4KbDNAn0976eYkhotb7+DziiJWXPbQHFXLVpkOK4v39SMs7GbaD2
	JaFVXwXXKUvWHzEMK1ASzgnZY1H7A0EFOf3C6CcjFHe8ixMXSSsyk=
X-Gm-Gg: ASbGnctTfirHicMiMdtJfpEl/Elmv9NKeDWX9S3uQQl6rlCjutHP4MndQlE/pkXiBsp
	bvHyYu8z/BbW8ttNURRrLlC/n9z5mEgiXnG7HfpW3X0zhc7uubc4Rs2kCoHIWJg==
X-Received: by 2002:adf:fa08:0:b0:38f:2a99:b377 with SMTP id ffacd0b85a97d-38f33f57459mr20939193f8f.53.1740070087963;
        Thu, 20 Feb 2025 08:48:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFFt+whvKVaXX4I4RkLMql6Zr2BmHhgEb6V9Rei8o5LVi/60bat3GQTyh1ZxROF61Yi6yE/rBBG1TCfUYx/5lc=
X-Received: by 2002:adf:fa08:0:b0:38f:2a99:b377 with SMTP id
 ffacd0b85a97d-38f33f57459mr20939161f8f.53.1740070087628; Thu, 20 Feb 2025
 08:48:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250219082550.014812078@linuxfoundation.org>
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Thu, 20 Feb 2025 11:47:55 -0500
X-Gm-Features: AWEUYZm2jJ2bUAqU74OstkcJ9PoKvhhiK-1kP45Z94_5LauCnETdKls3QCUt_rY
Message-ID: <CA+pv=HM3XK=ceOVcTQJPQp2SH0KhU9pT0LwrWBwjobeq36B3NA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/152] 6.6.79-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MDID: 1740070090-OOir4MGTeOSt
X-MDID-O:
 us5;ut7;1740070090;OOir4MGTeOSt;<slade@sladewatkins.com>;34a45300d431351f6eba03f8f221989b
X-PPE-TRUSTED: V=1;DIR=OUT;

On Wed, Feb 19, 2025 at 3:58=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.79 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,
No regressions or any sort of issues to speak of. Builds fine on my
x86_64 test machine.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
