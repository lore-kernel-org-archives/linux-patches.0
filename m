Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B4C1581F0;
	Wed, 17 Apr 2024 17:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713373265; cv=none; b=MBFrWYPIfzQExLIxSr7Y8svb/V1Stk368DQlwTQMADBl35MmsQL4zsris7izgzLkywUso1WUXKwlSXpSSTzS3G+PPV7DQBzYfeiuDTe0LhAszkV9TiXB0iJRrAfY7i2WwRqADi7p6YjSJuIbswR2Q5HTr2fOMSZyHuCzbimUMVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713373265; c=relaxed/simple;
	bh=7qwad6F14l5TuReDCaxKpdYeGsRIaVMPS5X5tPUMD5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TI4Uk5Gq51lutfS94klwsPv++TingUgpaAbjGMYLwMrSxzlsgUknhj/aVra1AoMoj37SVurlt4pRyHkM+H9QR6l5+jWPXLazjFBguOazHlAh/21VWX5q8wTBv3BbjhHZxVYlQ029eoIp8NSDvkAJlzQosbwNQjzKELXTWh2mo2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jHSrxlKg; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jHSrxlKg"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a555faf94fcso99670766b.0;
        Wed, 17 Apr 2024 10:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713373262; x=1713978062; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qwad6F14l5TuReDCaxKpdYeGsRIaVMPS5X5tPUMD5E=;
        b=jHSrxlKgCEZ7iGxkPJPBzP9iC2TvY78XumfTHSzbTjO8XTiNmulg8Mg29MjVJ/dGXP
         9d9ZwzBUb3zh6mu3L66VD1iDNLfehmrD2g5AcYsA0rmsj3MbwdUX26Gtd96tPVavqoo8
         P9saSKd4sHjVBaMtgpt4GLN442dcv3dliWu7wq4Yt+4L6RWDEgjhBToaxQc2eY/ptAVu
         MQt0DcB1aKztWoQ3PIZ6nKAs5OEDFQRJc5pWf2n2i6ilHmO+DzszIcsZhxDAmu6aW35k
         s2VZSc53C0qvnxgFoq2uIjDpnh0Q6Z6v5LyMy8rqBiQV7rqnhOtu4qJ1JlFJ93quEL6Q
         by1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713373262; x=1713978062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7qwad6F14l5TuReDCaxKpdYeGsRIaVMPS5X5tPUMD5E=;
        b=nmqtj9/xrz1q4eqZsTl0NNTnIhIYOaXNiKXBLPT9q4ue/YPLv2fqTxnucHonlCBWwi
         a9ft0GyiL9VmqcqujSP+g9nhD5Iu/WoONRjtS+rJTcXRX1NISqeu2PK3UNCeS93Y+Ysp
         0A+LOfpWRJrDHoQzZnLgpf39agNLXc1JehKF9UJTr/ZDILs9TZ/z09QczQOtuAYO9BkY
         vkjQSliD0AxzN/GU+brIDXDQBi/1Qa6jq38LgLJh3alwQdgnMYHBjDy2MxCckNeJG+Fw
         +PH5oUhuvF7l7RPqRaR0/wCoauIZT5HwkksnURV4s7Uv83mzkD7CcAiw1y81l/ntQ8fy
         ultA==
X-Forwarded-Encrypted: i=1; AJvYcCW2SCeZ1fGmJeFpaDtXn0gXnwzGjuGOohB8uH0t7pDPQPhxra1J5d43WYZTZ+3K+i7P9ByzKJwC0lwan04L4LJTQ3TK3LzeYpEfrjU0zGl9HJ72FQ8BvveIvzf2O5t4rtCOyqDDu2s=
X-Gm-Message-State: AOJu0YwCxmBCzyRm9j7ucXwpFbgy8BYAvvB2v6t5luPamtDn39mvb2AI
	/tNmn8DIJ+JAH+5YfTaBl+atbsr08c1NZ0094MPGxHiIXETND7NEhey1ePfjmpBz+vaev+CtkUO
	Ft9jHLAgDbO5udQe+bMln1VetrVk=
X-Google-Smtp-Source: AGHT+IHjqTDWZmtRPVFdbj0aG9crrmkL+pewqf6E+1PmO4tYLeDDlDuje0SMjWuIQbvH+KcEtnFkaReiKAfIoAQVBLE=
X-Received: by 2002:a17:906:b793:b0:a52:6d2b:e8f7 with SMTP id
 dt19-20020a170906b79300b00a526d2be8f7mr65234ejb.12.1713373261795; Wed, 17 Apr
 2024 10:01:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240416211941.9369-1-tony.luck@intel.com> <20240416212247.9949-1-tony.luck@intel.com>
 <CAHp75VcQvNqaTj6GTNmhoMbTj-qbn=WX7OSuRwiPaFO5pzPd9g@mail.gmail.com> <SJ1PR11MB608394505D03C51EC2583BFCFC0F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB608394505D03C51EC2583BFCFC0F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 17 Apr 2024 20:00:25 +0300
Message-ID: <CAHp75VcbtB=UEjBVM+C3_7Rbt9y1VSVkBOxjpyTA6TBYvtLqzw@mail.gmail.com>
Subject: Re: [PATCH v3 68/74] x86/cpu/vfm: Update drivers/staging/media/atomisp/include/linux/atomisp_platform.h
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Sakari Ailus <sakari.ailus@linux.intel.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, 
	"linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 7:24=E2=80=AFPM Luck, Tony <tony.luck@intel.com> wr=
ote:
>
> >> New CPU #defines encode vendor and family as well as model.
> >
> > Thanks, but I would rather see this using the following
> > https://elixir.bootlin.com/linux/v6.9-rc4/source/include/linux/platform=
_data/x86/soc.h
>
> Are you asking for drivers/staging/media/atomisp/include/linux/atomisp_pl=
atform.h
> to be refactored to use the new functions/macros in <linux/platform_data/=
x86/soc.h>?
>
> Maybe folks working on this staging driver can do that? I don't think I h=
ave the domain
> specific knowledge to make this update.
>
> Note that patch 69 in this series does update <linux/platform_data/x86/so=
c.h> to use
> the new vendor-family-model scheme.

So. maybe if this patch is placed after that one, it can be easily
seen how to amend it? I would help with the conversion as I know
something about AtomISP driver code (not as much as Hans de Goede,
though).


--=20
With Best Regards,
Andy Shevchenko
