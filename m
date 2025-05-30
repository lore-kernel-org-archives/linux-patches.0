Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CA322D782
	for <patches@lists.linux.dev>; Fri, 30 May 2025 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748616992; cv=none; b=L0ZStgtNFmdf6TVcX5BebR5nHRXqitEVWbTgnNfKqLweM2G3DeDP0WvrhJzysnd0lLuWNc1cfHSwBIRSoEgiDmaj9B+PLCygDbTUdWfgg9PRIhnAN/8etBDArpvn79iDJyzWz98E6Vd2u7j7cTX3bA8aeUBvRBHFu9iodzYfens=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748616992; c=relaxed/simple;
	bh=LTp7lIqfQh55xPN/ENH3XGry16Fnb9YghufAXHC+wUQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aEfyyDUTq2YyNpweJsILdRaarSN42nf2Bq5R22dUoINIJcWsERelVI6TyHhfAvlusDbvyrBUvLI6y2ok5KWhJNATO1FWk+sZHIkPfPl9pV2wEtb3zPQAeFjc6huh9IxSA0ZATL/0AhhG9B81ZfK5OvK4ynkoDK/FUo+3Z8qkwdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E1tK4pYQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E1tK4pYQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748616989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1bil3lvHjPWj2/Ob+Z4Dy2CVxQVJIH6BL2k8tkwHFaw=;
	b=E1tK4pYQdSTfQROfn9aRaUGzOLkuItrzC5J7BsktRYH8b7oGONDuUEOjBjNVtc19bm8s2b
	UTycu95gRKoCZjgI/+dBwTdV3lnC67kaQgPJqw9xEX0eXaOSECYMEDGq6TJKSusxSEhB/0
	IW3qG8bHASK9scgacnd7zdrpaPHY2fs=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-RMKBOsNkOYa9ePpCQ5o6Dw-1; Fri, 30 May 2025 10:56:28 -0400
X-MC-Unique: RMKBOsNkOYa9ePpCQ5o6Dw-1
X-Mimecast-MFC-AGG-ID: RMKBOsNkOYa9ePpCQ5o6Dw_1748616988
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-2e926f54767so616101fac.0
        for <patches@lists.linux.dev>; Fri, 30 May 2025 07:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748616988; x=1749221788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1bil3lvHjPWj2/Ob+Z4Dy2CVxQVJIH6BL2k8tkwHFaw=;
        b=wUKFeD8+k6hThKNYDm/DSWoHMahI5VnamfTfndw9JJvFqTuMavmPptueSlXgUBSYwQ
         VtykmB3CmVhsAeeoIqao88RzZFC13yebjLV+SHde//4tAOp07M5z6kwkGb6B3/E5J+aq
         6H29TQ3qiXlCOxZ8VUw53yoUXHw9M7ZuUF5Eh/ecwsrIqdWnox9Rn15z0NaDxVH2r85v
         dBAh5FOwMf0BLgSVWM13tYy+Zawe9Vn7tesRz03zWDBi7jeG0NrGSBQ4xGJWdDvjFc11
         gVn7XyAfwE9nt/UdH4VpcJu0klwv6Ja6L6Ws0EsEHDhuQrD6EYawX7WX/T+0faLJR2Aj
         sXHg==
X-Forwarded-Encrypted: i=1; AJvYcCWy996gk20RRuWCGrtt/vOuLXemywAXJj2tsq6v7WxlrvRhdJ0/0xx4Iip5fmn+abYIGeMn3kue@lists.linux.dev
X-Gm-Message-State: AOJu0YxfhW+uYpqOcloojcOJlsYhjmW8PhnO25vulp/h9GUvoB4uLvDR
	X0Y7W1URL2zEllRWH4j2jp3OuZoHFCd+ZXK8givFls/qC52TxlslEdcjMAMYbZrXjOAFmXDUyW0
	RlNAWhsDVmKLKgR+G8MAqmaO8QeqseXd7YgSrIh69nsMFlULgDOvYXjet87gQ5i72AEU3EDdBwY
	FkDiPwO8NlAKzObU4+g37/rZHAuMyLyeV/bQ==
X-Gm-Gg: ASbGnctbtUciiT0Y92y5OOqdGjmT8gSXOGYc2FcyvLMTuEWNgfSR7r9ZeyStyGn+Da3
	qAkBi84DreoDOJ0XVHAGxcoPj0t/PAwIN9v4FzAml71uRWk1cM+/yosijoYbPmO7Kos45OZtIE1
	vHy+Xz
X-Received: by 2002:a05:6870:2102:b0:2cb:d32f:2f18 with SMTP id 586e51a60fabf-2e8fcd73861mr4178701fac.16.1748616987654;
        Fri, 30 May 2025 07:56:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjDldO4DEE5sDuI0x6wv46KBif/kfVeE/30t28RPxEGxsSSnwx4qpsVPGsZMcbEDnLW2Nk0Gb5ebxw5BaVAhc=
X-Received: by 2002:a05:6870:2102:b0:2cb:d32f:2f18 with SMTP id
 586e51a60fabf-2e8fcd73861mr4178686fac.16.1748616987237; Fri, 30 May 2025
 07:56:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250527162513.035720581@linuxfoundation.org> <20250527162539.405868106@linuxfoundation.org>
 <27b9765e-c757-41c7-9cbe-fe1c915fdf2b@web.de> <2025053022-crudeness-coasting-4a35@gregkh>
 <2025053000-theatrics-sleep-5c2e@gregkh> <f2e2eb44-ea55-46ef-83b4-207b5906f887@web.de>
In-Reply-To: <f2e2eb44-ea55-46ef-83b4-207b5906f887@web.de>
From: Kate Hsuan <hpa@redhat.com>
Date: Fri, 30 May 2025 22:56:15 +0800
X-Gm-Features: AX0GCFuIsJ_Vm1uE0Qy0ABJULNUjgXu9xtVUwHzinhKa6eO-F60MAs17PM-i5y8
Message-ID: <CAEth8oFU8Kn_RWDe84MLi8s-kQfTWYBk2knsxZx8mrKo6uooYw@mail.gmail.com>
Subject: Re: [PATCH 6.14 645/783] HID: Kconfig: Add LEDS_CLASS_MULTICOLOR
 dependency to HID_LOGITECH
To: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>, Jiri Kosina <jkosina@suse.com>, 
	Sasha Levin <sashal@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 233sjrpPQztMaz-PZ5jSbyMun33D8RSJHeaqhuaCLFA_1748616988
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2025 at 10:51=E2=80=AFPM J=C3=B6rg-Volker Peetz <jvpeetz@we=
b.de> wrote:
>
> Thanks for looking into this.
> I should have asked more specific:
>
> Greg Kroah-Hartman wrote on 30/05/2025 16:09:
> > On Fri, May 30, 2025 at 04:08:40PM +0200, Greg Kroah-Hartman wrote:
> >> On Fri, May 30, 2025 at 03:44:22PM +0200, J=C3=B6rg-Volker Peetz wrote=
:
> >>> With 6.14.9 (maybe patch "HID: Kconfig: Add LEDS_CLASS_MULTICOLOR dep=
endency
> >>> to HID_LOGITECH") something with the configuration of "Special HID dr=
ivers"
> >>> for "Logitech devices" goes wrong:
> >>>
> >>> using the attached kernel config from 6.14.8 an doing a `make oldconf=
ig` all
> >>> configuration for Logitech devices is removed from the new `.config`.=
 Also,
> >>> in `make nconfig` the entry "Logitech devices" vanished from `Device =
Drivers
> >>> -> HID bus support -> Special HID drivers`.
> >>
> >> Did you enable LEDS_CLASS and LEDS_CLASS_MULTICOLOR?
> >
> > To answer my own question, based on the .config file, no:
> >       # CONFIG_LEDS_CLASS_MULTICOLOR is not set
> >
> > Try changing that.
>
> Yes, enabling these makes the "Logitech devices" entry appear again.
>
> My concern is more about the selection logic. The "Logitech devices" entr=
y
> should not vanish.
> How would one know that "LEDS_CLASS_MULTICOLOR" is required to configure
> Logitech devices, e.g., a wireless keyboard?
> I think, it should be possible to select a Logitech device which in turn
> automatically selects LEDS_CLASS_MULTICOLOR.
>
> Regards,
> J=C3=B6rg.
> >
> > thanks,
> >
> > greg k-h
> >
> >
>

Hi,

I switched the driver to use the standard multicolour LED APIs to
manage the keyboard backlight color, for example Logitech G510
keyboard.
So, LEDS_CLASS_MULTICOLOR is required.
Should I submit a fix patch to switch to using "selects LEDS_CLASS_MULTICOL=
OR" ?

Thank you :)


--=20
BR,
Kate

