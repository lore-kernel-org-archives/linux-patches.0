Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCCF8633F
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 16:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749401899; cv=none; b=jxYcszX5WNi+ZJbyQBb8Zris5uwx8nVCa9X+j0Sj0d6XkD1CEDWahuWoXwfa4nWV2F9QdycBxktrWhAeYweIXptmEfIhJ0OjhklsD1CioRjdd9UnY6k/83nGXpBFzpgwEJsUT6H0ik+PUsv+2tctCrpV9K2ovIU7aFObqoiJKkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749401899; c=relaxed/simple;
	bh=ES1nmazJC3eHPE4Dm72aaF6T8bwJef75vhIHbVci3TE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PZDKiQaiUF7iNqUyKKn3veX0r9uBQ9xpFLVTDKTj0C9WpNHWbSpe6hEsbcFwFusM0bG+jvX3jDLWk4x1jX6N2KV4Gu3DbH8EQ3NfST+TKWZqtUKVuKf1SE+PQDrRLAk3O3vBNcGkTTV2K2gaxG+78JKIsW7+VMZrT2i4CGKSSrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cotOyylj; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cotOyylj"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-234949fd425so5643465ad.2
        for <patches@lists.linux.dev>; Sun, 08 Jun 2025 09:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749401897; x=1750006697; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ES1nmazJC3eHPE4Dm72aaF6T8bwJef75vhIHbVci3TE=;
        b=cotOyyljmuoslv7fdQIneEyAkGGoMLn8C3afAYMmzqvaag0sMEWrCFkWroDrhOPAcJ
         cPoq/6CtM3ZYQv+QHU8t1ZOqUm5715Z/Y9zM8TQhb/r7DPXxPH0RDwuyU26VFCpkiLDm
         PW82l8BDWC7WHYzGTHoL1lXNctIEqUTgSGwtNmGM6OmG21JD5i+GQVUEI0/6ituvffB2
         uGkTrap9LjDQllJELe8ZkhnmQFkmMtUAewcI0VuKZZiuv70CqzJOhbvqzr/wZzsSbQt1
         wxilm9sadNxIf4dOy3bsfGjfdEQJ64TSNum1wh1QFW2gfxhOuZOeXtGBa3b7GWmP3Hjr
         e3ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749401897; x=1750006697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ES1nmazJC3eHPE4Dm72aaF6T8bwJef75vhIHbVci3TE=;
        b=gp8bTG44kUdeYb/A0b9HTl50KpFskwqF7QoMsiD4n2BYjChS8KgKtVJxoY5dlFLRzc
         JzOm6RA5hVMdF0e5XEm080036Ndw4p22b73x9MS7BccKTkNsk5Q3GMMIzsDtquzi85O/
         5TrqyK/tXOERlUE/qtQjaOXrxIuN7mY73oZMb5k0I3nl1Vn3F0Y5Kh8BS/KjWQsHGm9P
         XhzVfqqXWqy4cxF20mTYBNiEDBG/aHRTHzNb+sXvDKCTKZMV2aivBxWDsHFFtOxbK16n
         irpLqLE1topEsyYy2fn26wAIY/yoFEQAisciPIlIRn6QGD8P8Qzt4wmGMVMKuz/bLIux
         zjYA==
X-Gm-Message-State: AOJu0YxDQlr8hjTX/UEuP0ujZ/BeplG0cZtjDxLB8v9ZcfI1AIiLFZ3x
	GNCeFFqW7LpsQjC6uedm9VyHZqVGJNaOemJieowxfCOBg8Jm/MCmv44NNGvi2ZCLl3XlDXr2cQl
	n2+Zcog7z440k5Qy/YI16ZLHKTkv8U8I=
X-Gm-Gg: ASbGncsTKG4CLns+sEmG3iBUv4ZKiR7trj9pxI9k+K64U0yGTUjucirWsqjFEOJywOQ
	aeNJUmQL+6KU9qwt+SYZJdogykpqbIg4gDI6IR6CFKvNm94qlvcQBXMXn72MdzbyPxUcLimRBbB
	CO2dox8bMgbtUAjOlnuB2rKD2y6mVm99lx
X-Google-Smtp-Source: AGHT+IHc9krOpM5WexDVkHYBds+VEhCjzZygfB71gm4bGafsCOVjq+AnZZljwFNAqrP6GYyN178LCDCabGr9gE2vf4U=
X-Received: by 2002:a17:90b:350f:b0:312:639:a06d with SMTP id
 98e67ed59e1d1-3134e413149mr5680859a91.5.1749401897584; Sun, 08 Jun 2025
 09:58:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250608125447.933686-1-sashal@kernel.org> <20250608125447.933686-3-sashal@kernel.org>
In-Reply-To: <20250608125447.933686-3-sashal@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 8 Jun 2025 18:58:03 +0200
X-Gm-Features: AX0GCFvZAeGmWU_hALb_8QuNqIlLnjRr8v5cZM9foJ-4o1tCZgAMz6lnNnKkYK0
Message-ID: <CANiq72nVAUMK0z7tN4-uS_LNNgJstf6Foufe8OfpjfVvg1ahPA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.14 03/10] rust: module: place cleanup_module()
 in .exit.text section
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, alex.gaynor@gmail.com, lossin@kernel.org, 
	aliceryhl@google.com, gary@garyguo.net, dakr@kernel.org, boqun.feng@gmail.com, 
	walmeida@microsoft.com, igor.korotin.linux@gmail.com, anisse@astier.eu, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 8, 2025 at 2:54=E2=80=AFPM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> **YES**

Same as: https://lore.kernel.org/rust-for-linux/CANiq72kEoavu3UOxBxjYx3XwnO=
StPkUmVaeKRrLSRgghar3L5w@mail.gmail.com/

Cheers,
Miguel
