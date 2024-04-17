Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBB56BFA9;
	Wed, 17 Apr 2024 08:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713341283; cv=none; b=iwXxsmS9t62FbluUUfmccRWjpcplCwJtJpIRTy70oF280ncMX3Zf3L5hwxqheNgJ0jvjPd8dIBFgV94mQWAYxGsvYOsW8FMzYBg5TFGkzjreIBBJ6LfOWRGQ8dq3vfiZevehOZKStWYCSnleEzNwzAeYS72M0xOkh/3wMbWMUsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713341283; c=relaxed/simple;
	bh=DHm8Ps55G9Fj9QrWrNjR73du8vQp5pj8qoxp4e93/lA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IInerFekIqBJNUnysbHwV739Bb5YgcrNHEtolPOwAYdaoWW76YpcRiB4jDuqYg5+IEjhAgYGBhzc0YV+OdpLQ6F2j2OYVGu+ggat/ZI8aWzVh33dyJFfzDpZfjS+uaJct4jmouOtv0ew2UVl1UY7Tr2N3cL323kuQrWhJYQ85Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MfHfTqRE; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MfHfTqRE"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a555faf94fcso24085866b.0;
        Wed, 17 Apr 2024 01:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713341279; x=1713946079; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHm8Ps55G9Fj9QrWrNjR73du8vQp5pj8qoxp4e93/lA=;
        b=MfHfTqREzMANo5HVD3f7aY9qcD6bCC/ZGFGhfOJAhtYUAIJ1zMeX2DUCR6LPMTuVwi
         F34HDdaZkbof8a1CZEl4WtpFg80/yAIYXL6IdzRiYBjxLqK51g8YxFDKSjcW29wROr6z
         RphEb6RinakUGYSpUFDHCc3nnRbkuF30wyzhNe7zC6KM+WKHqxrFw5/WbF4exeOQFGLu
         sLVl0EAPcLwRBzJsbVy3AwqX9XhH3S3fX7m6p3XNHYmDHdvHhWVLmsHFLFvDGV10rac3
         Omn25cfe78lQyJ1KPvWeu92KdGozKz6Bzt9f1U+/pb4Qt0QWwk+gyrj/NV4a0WVDxcag
         M5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713341279; x=1713946079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHm8Ps55G9Fj9QrWrNjR73du8vQp5pj8qoxp4e93/lA=;
        b=Nsx96wBwcvF8fErTfxuW52BAYqF2TbMIGFdAWyubUmEcWDHGpWpzmff4txVYEu+dbN
         S7kD2PXSrsd77f+zm4KpQ+59rB6xwzVOqG0HcVOx5yfnfIPozD1z+nuYhsTtTGkySt16
         gl+3JQUzh2CZnt8AU6QgNr/7UA/9kpY3dqYjnMAmMRwNEwxxTFhRvT3VD3V6ZgMqoyyc
         lGM818IKesEwYSt30spk1NPYJpCNU3/XLmm7cLgzsp57P6Dp5tYxwKMnJ4K9Fhgtej3m
         hjnDxt4Al4OwhGA2WQ0d9n8zWilR5xS4E/INX7xHtVYW/9rgfEXcsHXN4WfYbyYveL64
         idLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUt6yfPAA1hfYcuz7mYylqs6fgv2wmC7FfpGh7mgQRFkCw1xR7Vk9UZNpGrT+ffttrcPlpiufq/EuhBMWRqs8ZJ4kX+mNDPsFeKRXD4Tbmx5CAXFZJwe+ls5kRnpR6LrZeQdylVFu0=
X-Gm-Message-State: AOJu0YyY2EEKXisjDN8O4cSdlztO5qiu0sS/2cmmOnenJRKwrxtgeode
	6dtbnqXVTy5InWQcQjU9zkGV7g+qjDCUPOOiteGzfjEXez3cF2FSEpmTVGYaptmEnjYQfhyhSZK
	F5bPu1WWZNqOtUw+4Pm8vz1opyYU=
X-Google-Smtp-Source: AGHT+IEynMUl5J9HloIF7Lmmtb9Np+ui5Xjtf47XvRiYkRJSWfelm64saMncMNCznjQRG+iBvCfWr77dG8JoXMd7AzU=
X-Received: by 2002:a17:906:b358:b0:a53:4cae:e40 with SMTP id
 cd24-20020a170906b35800b00a534cae0e40mr4590024ejb.25.1713341279014; Wed, 17
 Apr 2024 01:07:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240416211941.9369-1-tony.luck@intel.com> <20240416212247.9949-1-tony.luck@intel.com>
In-Reply-To: <20240416212247.9949-1-tony.luck@intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 17 Apr 2024 11:07:23 +0300
Message-ID: <CAHp75VcQvNqaTj6GTNmhoMbTj-qbn=WX7OSuRwiPaFO5pzPd9g@mail.gmail.com>
Subject: Re: [PATCH v3 68/74] x86/cpu/vfm: Update drivers/staging/media/atomisp/include/linux/atomisp_platform.h
To: Tony Luck <tony.luck@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Sakari Ailus <sakari.ailus@linux.intel.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-media@vger.kernel.org, 
	linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 12:22=E2=80=AFAM Tony Luck <tony.luck@intel.com> wr=
ote:
>
> New CPU #defines encode vendor and family as well as model.

Thanks, but I would rather see this using the following
https://elixir.bootlin.com/linux/v6.9-rc4/source/include/linux/platform_dat=
a/x86/soc.h


--=20
With Best Regards,
Andy Shevchenko
