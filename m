Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F3213E40C
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717785650; cv=none; b=qnPV2oHJTxdakfxbbqB3zPIAYxn/vgfyYUySL/YUaoIfMjdr/9wp634iFI0D2GQle6DSw8qDrP6cK+yB93UndfOLR2o0+5+TNaQw64/FFfoZMD0hvDUkl61HkAmrQ3Ap0l2WRm+yFNh3uo6MwbTrO/79yXqTHPE2DcurSYhXTxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717785650; c=relaxed/simple;
	bh=nLT1CS3bAADtDvYR/iyCMdc1XfAIDAMUu13CcxexJ8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I5FduQwtYBOc7VzMMA9J1scM+lyL6A179AgVtV7Ofm3JMGL0CmYREpdwXLoNZY/loyN4WF8F0OxnnNtFy2TIXCm6QucbbWyWEbDeL9zDiqJQ9vxb+H53R24ax0ySCvVlTTbF7VIrB4B8D5APmdBAB7Fx6EFlYRiC+FOHgHnmDM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=CNmOWtBU; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="CNmOWtBU"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-25111b428adso1361745fac.3
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 11:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1717785648; x=1718390448; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWP3oVZEyR0+a+YIhKNFwQ+oDZLDTYUDKfQwa7N72nY=;
        b=CNmOWtBUTZFqjcsKvlpOAT1iAVDtgFF3baK+zGnB3zkUpb0IdkEdEjJQ6O2ouBp1lk
         DLj90c/cKTAR/IASXRSSnit3uVi6leDb9qfSGEbY1tjRuqtysw+w4f++MkNqMUIg1xOr
         fjpvgUSQp0oiham8jnAk8y96v0um+bmIWs/WWFEt4MpM24mzkrQWJ0PFtIUz6+ftKhhk
         PSaDBTtWQl8k1XzcOzLlfGWFKCUVPbknDI09uAyJPLinvmacvLicRzj5Xtf8hqbNPgj9
         70+8W2ael8EZHaDDMJnt1Mh72qS2tukgBQSUDpM9A8DxA2kOFJMn/UQfSJ/uBV4D52QM
         y0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717785648; x=1718390448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VWP3oVZEyR0+a+YIhKNFwQ+oDZLDTYUDKfQwa7N72nY=;
        b=lMSZiDMqAd2l1AlZ5tRM6h2tooGG4h3aVthyv+/nLUAFVaB/teNJo3nPZmjB8RFv6L
         zCE8/prIfe7QhFkOs+ZBOtKLhubfK5iQeT/hGr7GnoY7Y9L6UqrXTLfEh4ZsSuJWrnEC
         37ExXDGpI5d+1XSLaCCEtH96tKKRMzMkSCAa5sAyITGcbIsfzuYSrygPlXg16cL5iBfe
         Oi23OEXq/44uDI10xFRhChyFK0Er0kASA/fteJjyXROtxp7THfL5TOGvq4dhWb+8/ybx
         P8329MQPAUf1fYJv0tXpcdjxZkJBYSG441oCZ8ijmlInVhWhWojjpMEZZMhRr3VGPRq1
         6lAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLvw3ryT+U/DaCDn5Zif0wUot+uxDDI5cxkOvkdCEkI9Y+sky+tDfMO2ap+b3PA0qqIz5FizIDVHUOF6IuWZ7xNVNjd5aLOQ==
X-Gm-Message-State: AOJu0YzcQKn1YuFX5zRJQ/F6lBVEaWiZ6Jepkre7F74er6XEHlkAeaDl
	R+PC1vxGvtA5s0DLZSUTdvyrBsOh2otzjxbbSp5+B/tH90Q8B6km3tJgMPafuglkxv6y1YAGTbY
	j96rkf0yYTaxcLsCkn2cC0UsAs3pkONnIKjzY
X-Google-Smtp-Source: AGHT+IGM13uj3U+ARgcKJSVs/VmcSppJ4o+ZTjupN8yH80mNMzyyWgUWj/akZRB539Rs2Rn6cvM6cRncobvhndjrU8I=
X-Received: by 2002:a05:6871:e015:b0:250:7353:c8f2 with SMTP id
 586e51a60fabf-254647efd11mr3404898fac.43.1717785646594; Fri, 07 Jun 2024
 11:40:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-2-Jason@zx2c4.com>
In-Reply-To: <20240528122352.2485958-2-Jason@zx2c4.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 7 Jun 2024 11:40:33 -0700
Message-ID: <CALCETrVJFefyDT6U3QoHdZvNh=3nqk=3AK88eRuqdn4W4t8vsA@mail.gmail.com>
Subject: Re: [PATCH v16 1/5] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 5:24=E2=80=AFAM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
>
> The vDSO getrandom() implementation works with a buffer allocated with a
> new system call that has certain requirements:
>
> - It shouldn't be written to core dumps.
>   * Easy: VM_DONTDUMP.

I'll bite: why shouldn't it be written to core dumps?

The implementation is supposed to be forward-secret: an attacker who
gets the state can't predict prior outputs.  And a core-dumped process
is dead: there won't be future outputs.
