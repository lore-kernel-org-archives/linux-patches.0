Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E1875818;
	Wed, 24 Apr 2024 19:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713987118; cv=none; b=Q6ExkuWXfZm911W/rZ/moTzUSEuqq0b3oiVCtS8CrU4mR3o10LmZe/HxKasl/iRjOcjOVQXsXyoE+BmmENquH0pyX6KqsviaHEFuIrvhRBVs0moofbSqShShu7Aa011sCjPMG2aRs4fOXacFxqoaSBEairZS/K792ju6/L89Xpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713987118; c=relaxed/simple;
	bh=mQ/+d3gWAOcD9KnX2wfP3u+ftFZAlpcW1F7JU92hcsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TasILrE3z+GERj+53Ezy9OP/D5vqJ/hPqoU4WQWdqKU7TkUDHG+2MeEaRAC3wC5U0O1UvAZy/Zq+A63n7rW6HT2YmrycJVippVOr533/wqholFCPKeLVDmi+4il6lTK67jijow+LWZc7BKDwJIpn7cP/ugmzI9obxgByTXjQHqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kno2zZIW; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kno2zZIW"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-51bafbe7509so226731e87.1;
        Wed, 24 Apr 2024 12:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713987114; x=1714591914; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZ0TpkzmYZr6hTX7MZ3GhreDMH2peuAcdL3k38EcDhs=;
        b=Kno2zZIWFv+voAe0hgZ7GOtxqm2x2ACw708hnSEXrwdx+yy8OndMh9kN2usC2XUqtR
         AxSfryPdSXcs/33QY2UnQ0MpcArA2rZ2YFVqH4fdjZXb5QA4mywcf2EJvgVsN81rfFLh
         dimkl/jhKiRg44Tyf6bE/sGE5ftxh5iBBQfkr/96o/aC7a5znGzqKuuhBNcyFWAzmM2f
         bKvFgdj//A0OjmHFGhLhFzSjs5tiJxnUQT55rKrRTKk/0JdCd55Jp6uxU4bDA70F1ar4
         iWIxapme5dXJ3ugD731akp+IdtKNz2Kigz5oaW802HtEAqWlyXbzPVeNQqoo+A+Ze+GB
         15sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713987114; x=1714591914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IZ0TpkzmYZr6hTX7MZ3GhreDMH2peuAcdL3k38EcDhs=;
        b=U5GoQHXAbnwxTfI8jxtaTZav/qsCaMSN9o0odK6bPRD+h/xl6hRL15AlxxbzUTkxLv
         sk97FjtYFQ3NOrWHlH55UEwaelFFihqcK21i3UuveKvRjvct0uhffE3vrq+u9Xtn2JeY
         KROp18eapD/odtYRV/yblfERqzRBhn7poE0Z51hNVknlstqj8Z8BiMkb0uHComqzT+3B
         z7JabW/EW8awb5rXVW9Y/cjpsYuNozCMcdYKZXyf2/b//ey+hfZFoYmdl5oRyRzw13UM
         OUinatDgPoY2CR2eVsCwtItIpRxL3Pa3cFW2U9knSGrPxwWJ6ixPHA+q7oSkesL9bF84
         PxGw==
X-Forwarded-Encrypted: i=1; AJvYcCX86WYaX0hpURVzrd1JQ7/RSXLRhF3/iN7j0n9XHmiLTA3sQhGvow8LB5zSpcNgmz6BHe+CXDmG/QUqrtmt3Osvzo38CnDEPFRQStvxlmot78FqqnoeC2PPWBgeHrBx8fbbTW3lFb4=
X-Gm-Message-State: AOJu0YwVjNOW+bY/DBigq0ywlAyp9kQQjyiThHqSiPUE67wynqOCuRRE
	qwpbXYGMrNq4I8VsUALKYb8B8foVukr4XGgS1RhUFJwVnavrUkDs13cUCB0rRvEjfI+5UEt0kW9
	baGXH7Y/H+WexPpeyBKtg7cNrsRg=
X-Google-Smtp-Source: AGHT+IHIaGYAxKkGvJ35yj7ZqMlmMinua0HY7IEEpin7dNCuHY4Mh1cMERg/mBPHCSACXd8sTXQWUXRgQWVjYKKxamo=
X-Received: by 2002:a05:6512:39ca:b0:51c:9d2:f440 with SMTP id
 k10-20020a05651239ca00b0051c09d2f440mr2034502lfu.38.1713987113376; Wed, 24
 Apr 2024 12:31:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240424181245.41141-1-tony.luck@intel.com> <20240424181546.42446-1-tony.luck@intel.com>
In-Reply-To: <20240424181546.42446-1-tony.luck@intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 24 Apr 2024 22:31:17 +0300
Message-ID: <CAHp75Ve_vX=J9wKd5iEP4m7foGpjCQGWepMaSfwhewbPJA=1XA@mail.gmail.com>
Subject: Re: [PATCH v4 67/71] media: atomisp: Switch to new Intel CPU model defines
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Hans de Goede <hdegoede@redhat.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Sakari Ailus <sakari.ailus@linux.intel.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-media@vger.kernel.org, 
	linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2024 at 9:15=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
>
> New CPU #defines encode vendor and family as well as model.

Got less LoCs, so good change,
Reviewed-by: Andy Shevchenko <andy@kernel.org>
See also one nit-pick below.

...

>  /* Both CHT and MOFD come with ISP2401 */

> +#define IS_ISP2401 __IS_SOCS(INTEL_ATOM_AIRMONT, \
> +                            INTEL_ATOM_AIRMONT_MID)

I would make it one line.

--=20
With Best Regards,
Andy Shevchenko
