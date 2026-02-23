Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535833783D8
	for <patches@lists.linux.dev>; Mon, 23 Feb 2026 20:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771880375; cv=pass; b=dQG0SsKWNrH4AfcfacoBToFzhRANoUv/pIBWh7BqMC1nGX5HoBVtHZMMQ8St4oJf5UeCHW3Shgmc2ph0oYldbYkJVFA0tGopREg72HhSCSd0c/lfUKWe/Sux61lsNP/6QqGMl/7Q3Vg4fYUw6/aB+Lr5JNubeE5GfksdU+lQlQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771880375; c=relaxed/simple;
	bh=ZGWxl/dhdATLUFkTP4bDg4Eh/JPLgT7DDIEuEfXiY7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i4hhF/3RfhdNWQyAN9EzFyIDyf5UgSCy4/VyMHxIwFmIvH2Y2xRoz3jaiDGDCKAnUDLWzvE1ZDPA8HRGedSF7Rlv+CaewQes216KNu3RmdXn5mkUGz6sWyjTn6zTXrTMGrBeINppsJ8aYbpUt7cz2AVEDdLjISnoy8P+VIg2HH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOQftl0o; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOQftl0o"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-64adabaafd6so3896117d50.0
        for <patches@lists.linux.dev>; Mon, 23 Feb 2026 12:59:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771880373; cv=none;
        d=google.com; s=arc-20240605;
        b=gVZgu3OElinU4KWEjnbAwJmr4xudD1bxF5Ibyb2qfFVDIT6/Hf7wZx/5OCCuVUBL5r
         jrkS2lHOcztcxWDKv2c+Mqlmp/3b/d9RDNVkldCwAnYOPZKEBQuom4tN4+iNeQhu88ql
         RwvuFva7A5/zhHoxQH4+GKO7Insd16yToyL7oRyPlcVtycAJFCCB4VdqYzPvScF9RCKm
         kHYLUbA/y/0nBSCeFgBaUXypF70+9GoHmMpUukxhFjDmG1jSiSV0veyB9digRJZWwaQy
         2zYduRrUKOJmlL1w7I2nSg7ef5oDplehh5brv4FtuwNbczPFLu5jwbVDpxdP+7wUJyPB
         vCxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZGWxl/dhdATLUFkTP4bDg4Eh/JPLgT7DDIEuEfXiY7U=;
        fh=KSJZEk0y2qJB7+IG7PIoKbAWv+4w6uR9LqQrzbb+7kk=;
        b=DduDs1wbgeGGAgduPszMVaWXvJe4fm5DGLXbSOrH/ekbDvKkv9mgLFO608nUBmGW2o
         lQbYLQ8amuLbAFeGvcESDlkKJBUU+lZYUE1jx1XEgfVkLuB24RiWh/EJo6P+IAVI6ICL
         kItAd2A/h5QiH7FNxkAe9OEmz+vuQppSYMBDWh8WUls5Q6hooY6MiZvDQ6OrjAoPY340
         EhsCk6bQR439fJNYEDvx2hGQmQGuwgXmAJ3kAMJxMO8louSgdOrjpX+89VIafUGbj+Wt
         ALhFcYptnNCorKIazQ0NrYlXPu2v2uw2GIBT408Kxc1fO0Fc/wp9h/qXfmtt0M+Fgv/t
         BHRw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771880373; x=1772485173; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZGWxl/dhdATLUFkTP4bDg4Eh/JPLgT7DDIEuEfXiY7U=;
        b=QOQftl0ovWl79wE8DNmzOD7utGH0+XjuU/9PL8vZ12A846XS0Sy3jcrB+6m9kaLEK7
         q15lo3S6qFtjnCvE7X1x3/p86KxyDdzM0CqtRsU6WANVREZ7hjJ516iwbzYmyIKmNH8F
         egRTy1vtIg5btn3VcUAg5x6TUAlIgOsYj2pZvzbS2Y9i9Mdvs+70zMDa2fDHC7XbJLAt
         PaZhJ1mUqoKtF2O0ndtqTYKNwBDPLO2nETN1DK2VI9AMKfRCvRc8/Sp1xDHJK+D77luK
         9UlJf4MKAD1HQZK9Ihe2VYUHAP6vI4oBlnRB3+vwRjzVa22c9bZUC6ErX/pB6z+frZo4
         gzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771880373; x=1772485173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZGWxl/dhdATLUFkTP4bDg4Eh/JPLgT7DDIEuEfXiY7U=;
        b=gjFVJwuJFunM2k9oOK62aSiZWiRgi3R+qEY/kETvxObddRAvPqOdOl7/0n+AoTRcQX
         C4C9JVDAonbbc11sHHzOw+LA+5fScu8iEAFPN1zyVlhpQFrRBvAZi+Ex+Jz01MARO1Gp
         YYld1MJMVMYjgIrynRBLP2C0QX/HhvVbpOjXCF5wkBfUgwmYJ6NVi9yiUudVrKksjV4O
         4fwPNkG+KLbaZWtEel3sBXc01BiPKeL5lUEHhc6oaLGaErXUv39UwjT/hxwzmdCMlQAQ
         FGO8KgD/e4uazHVsiznIFEZO4hGxAoOxJiBzPm8EElHs6ibeUhdW07EptOZ4wwWJrb6z
         MBTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUh1JTn65++LfbYbdhiW7NCwmUheQQltNZrTUB+EINPKQarRNDYvDt8PIr+cxFOCMxrQbs++q5o@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0XNrphnEIXH04ekh489pS2HeFJ/kv1kRXvy3MTo1GdezgpUa9
	8Rw6JWZ/Jv6kC5QnmahtecEthTA1dNLstTBHindDqRWvfPJFDjM/p0+t6VSoZU2bWk/S645srY7
	HiEmvtg94ejVTjc9GDahze9dhFCy1xGM=
X-Gm-Gg: ATEYQzw+qoCzTUvk8Hk8YzPb8OVyfxiPHXAD1lrb6RdowD5vrMjLEpyRJds/Qdvk62o
	FCOXNbGqBiEqlF3GZik1TDqoxviBkpIIt16Dmrb9qz2w7/b0yYTMSUGavWgojXM6MJq2FJ4deTS
	aot0newxDwmLpX8a/UDHVQQggBapE+GwenQRok1HWkgM0g0WyXvZ1SHOWKQT1Msdkl6tJDh2pnA
	A/3XR5GN/c8aob5Spu3xn1dJl+FfKPAQ0ILWuMEaZvquTLUNwwD93O4dKedIpzT/AbtIEhjkq+6
	O4jus6c=
X-Received: by 2002:a05:690e:d47:b0:64a:e799:1d84 with SMTP id
 956f58d0204a3-64c78e3ed37mr10186762d50.49.1771880373230; Mon, 23 Feb 2026
 12:59:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260219210312.3468980-1-safinaskar@gmail.com> <a7cb199d-928d-4158-8f16-db7ae5309082@landley.net>
In-Reply-To: <a7cb199d-928d-4158-8f16-db7ae5309082@landley.net>
From: Askar Safin <safinaskar@gmail.com>
Date: Mon, 23 Feb 2026 23:58:57 +0300
X-Gm-Features: AaiRm52qRcNRr0w0juOjbrF6MNkTC6Cm6dik1IbLPWbMt5sbBgSggwUmnjLgJPQ
Message-ID: <CAPnZJGAw9o8BetWs_wO2B6YD7mYuOopP0CwD=KCfOJXw2QU4Gg@mail.gmail.com>
Subject: Re: [PATCH 0/2] init: ensure that /dev/console and /dev/null are
 (nearly) always available in initramfs
To: Rob Landley <rob@landley.net>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, initramfs@vger.kernel.org, 
	David Disseldorp <ddiss@suse.de>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 3:17=E2=80=AFAM Rob Landley <rob@landley.net> wrote=
:
> FYI I've been using (and occasionally posting) variants of
> https://landley.net/bin/mkroot/0.8.13/linux-patches/0003-Wire-up-CONFIG_D=
EVTMPFS_MOUNT-to-initramfs.patch
> since 2017.

drivers/base/Kconfig says on CONFIG_DEVTMPFS_MOUNT:
> This option does not affect initramfs based booting

So CONFIG_DEVTMPFS_MOUNT works as documented.

(But I am not against your CONFIG_DEVTMPFS_MOUNT approach
if it helps you fix your problem.)

--
Askar Safin
