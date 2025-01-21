Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486951F8674
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 21:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737496635; cv=none; b=ZJoarKyTI0cOgciw/G7YLTaZBCCPFHyPuzb9OIJoMpmwBCNPf0pXAD2l3BpUltjWmYsXHzBL9oicEQlVW0mPFoyYBCuOK5LchihGI7i6QYmbrTzpAjzi5U6FgHLZylBNL0wEttS+fJkSbZV/013UUgfK58YIaFV2y/psf7gHetA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737496635; c=relaxed/simple;
	bh=GOHjZrdx+5J3OV+KNYZN9SaSqHV7RronhTFCYvpWXfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUIRK1t6NukJOn6V4XgTz/kzMh8nkgmOjUBMXzOlmx4U0hchdkY48hGuVvfjTuQ1ohQj1e/TIII3NM+nyW/k/gM0BlWK/KXK82NqFirFa8TAzWhMXDEXt7KW4nxP2w3iKy/x8FMhq4k8bNrvb4MuArxK3x5YW2KCpQ0bVIsvgpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SUxeCJAs; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SUxeCJAs"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa6a92f863cso1155347766b.1
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 13:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737496631; x=1738101431; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n5YOtinlKIQcBOdKFHM/q6wdfeRS3f/aMXRUpTGEphI=;
        b=SUxeCJAs1i+616ur+Dy7QzFukigrQVXNZkwJGkiQ4LSUBRTEPYR0Q/o0HgwSaFy2XL
         6SSXcA64XW/NBxh6GPUgwwJMDfLelkCzaLumEvvuNTcu0OmEiK7jzgov2c+HQtK1bZjy
         vtONQ7rNgyXr58KaidjESJFNMaguZIgfLDmrmWlOxw1SOp7YLfjSDdZGMZ5SbFoBTeas
         WdBxgjDraFiJAGq0tDUW+V7jXyrSxT/IZYerBAbr5yfXCjAqG+vHOgsX37e2Giz/h/ih
         Ft00n8VD2B1Umo6DjuJGX/bu1xBp6pnCYteXhWewybfgkIXJpxVJA+NbDAyelff4umZb
         +uNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737496631; x=1738101431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n5YOtinlKIQcBOdKFHM/q6wdfeRS3f/aMXRUpTGEphI=;
        b=OThGRCUMVOUprLCdI3QJKuHumcX9kL52CSCakcDcW+44CRreJVxPSdjvSoqTL9Zs3Q
         BVvmJ4FQx1McaN62l6Wjhu7/j2JO5HBeNqmuCI3jkZZxX3vXu8KIlIynxtqLC8TFiw27
         YfXfWcKsHmO/koMYpEasDPgonIZ4KSYbRKOkxBYvJ89qy4IT0rQWQmpc7SArOMVklOmN
         x2P4c6S38Hn7LXJsNhfkQd9NJbxVjARcuJW9R0YjjCopRIPJ+jRJYO23b67/hyroU4oB
         UU7T0Gkyf/TAYZPv89tDZx309q8W3GZbPW5RKW9F4jhIiv35fyp56EWmyL2GET8DmWaK
         m/wg==
X-Forwarded-Encrypted: i=1; AJvYcCWKjMxzFlCCcUR+ybf/QRCgAGdjTdgE+vzgCS1D2I/saG+WOfYfKGj+6+pDQOwtrVbXQeFiJaA1@lists.linux.dev
X-Gm-Message-State: AOJu0YyIZE23MOfVV8BUoUQev02F/oM4RTz4yKODIYRlHG62CdMzz7l9
	DHugxFRP3bDeNgHdzkjXSyMlTV45hE6N2TcCHRCy38jVLUAa9bhE
X-Gm-Gg: ASbGncun4jnYbD6bWqVUlWFR8QmNXaqAV4QKmFlDAkmvCFrw6odlYaFDZAjOifG4buO
	xbkFxoCLVHwzUqWgzAu0T0QWfr7XHM80NpTeB3HlvGwS7EaqxfR6sTupSuHLVmZwX6c3P+In5gc
	d89xCSowJCKBRYCEQ7HPriwHd914pEfxyVCs9RflwVV4Nx4bJzT7uoqSqrMYRPQVJLIwNygXDCc
	vF7aLj4qYYhEX8dUcSTW7p8ZXas2RwFguqzN9Q90Uy5pTsgPMctr4EXvvIgBqjDo+LMpTkeJ95f
	lEzKhT69+8G+nQT8mJAVw7CMZHs=
X-Google-Smtp-Source: AGHT+IE4LJkfhcAMnZo3rroqxamUV2ROsiauNTWDdyhouPCMGma/ueNsQqxJypcf1fu2I0NSj8qkdg==
X-Received: by 2002:a17:907:969f:b0:aa6:18b6:310e with SMTP id a640c23a62f3a-ab38b429787mr1999288066b.38.1737496631424;
        Tue, 21 Jan 2025 13:57:11 -0800 (PST)
Received: from eldamar.lan (c-82-192-244-13.customer.ggaweb.ch. [82.192.244.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f1e404sm815579266b.98.2025.01.21.13.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 13:57:10 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id BABC6BE2EE7; Tue, 21 Jan 2025 22:57:09 +0100 (CET)
Date: Tue, 21 Jan 2025 22:57:09 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/64] 6.1.127-rc1 review
Message-ID: <Z5AYNaxIm-SwmUHb@eldamar.lan>
References: <20250121174521.568417761@linuxfoundation.org>
 <b5f7b88a-0f6a-4815-8344-bf6bf941bc91@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5f7b88a-0f6a-4815-8344-bf6bf941bc91@googlemail.com>

Hi,

On Tue, Jan 21, 2025 at 08:32:01PM +0100, Peter Schneider wrote:
> Am 21.01.2025 um 18:51 schrieb Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 6.1.127 release.
> > There are 64 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> 
> On my 2-socket Ivy Bridge Xeon E5-2697 v2 server, I get a build error:
> 
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn303.o
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn31.o
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn314.o
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn315.o
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn316.o
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn32.o
>   LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
>   AR      drivers/gpu/built-in.a
>   AR      drivers/built-in.a
>   AR      built-in.a
>   AR      vmlinux.a
>   LD      vmlinux.o
>   OBJCOPY modules.builtin.modinfo
>   GEN     modules.builtin
>   GEN     .vmlinux.objs
>   MODPOST Module.symvers
> ERROR: modpost: module inv-icm42600-spi uses symbol
> inv_icm42600_spi_regmap_config from namespace IIO_ICM42600, but does not
> import it.
> make[1]: *** [scripts/Makefile.modpost:127: Module.symvers] Fehler 1
> make: *** [Makefile:1961: modpost] Fehler 2
> root@linus:/usr/src/linux-stable-rc#
> 
> I have attached my .config file.

Reverting c0f866de4ce447bca3191b9cefac60c4b36a7922 would solve the
problem, but then maybe the other icm42600 related commits are
incorrect? Guess it's a missing prequisite for that commit missing in
6.1.y.

Can confirm the failure as well in a test build for Debian.

Regards,
Salvatore
