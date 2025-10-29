Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4023396E6
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 11:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761738678; cv=none; b=kEiiT5Y+lCrBdpIlAr1XlfXiw9YjEGs+f0UACy4MoMc894LqJeICFZ+CG14NGeoy/aeXJkCBi3IerI1gESCmulSQF8jXqkELBx9t6LZd27tnJc+8MHjZJp7mMLDKBDcgP/IVERqhU5jk3sXEg67M/ZAMlEudF3Khgfn0XdB3PcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761738678; c=relaxed/simple;
	bh=4eAuxRdra6xYn2AEu5URxIFLv0U3aPRV4JUn3Rr/2D0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jih1vmgMncmX2Jslr6sKVYirlGqIgofdrSMHYeX2u+NRKCGfDpsBCe2OAUWtJRnI452eRndxEDIvrZIjcc0ZDZ73OZqQtVsnzcTZLfow4lmUzfkANH7EbVjewsbmsUMCyScW0aEG77rhbRBXQkZp3k4rO6/W56okEwcdPh8nmrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KoSwqCIp; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KoSwqCIp"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-26808b24a00so9844595ad.1
        for <patches@lists.linux.dev>; Wed, 29 Oct 2025 04:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761738676; x=1762343476; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4eAuxRdra6xYn2AEu5URxIFLv0U3aPRV4JUn3Rr/2D0=;
        b=KoSwqCIpP/UWJRfCdkyPZZiHsqBJu+YAr3PIH4bLrInUazGjSMX3UA1iZJmbnW+kxJ
         muNXVXe1l+qi4BsyjRMW5ul/oYskPEFZdDG0B0mLdblnG9jRc8WjfimaxuTxrF0iI2cU
         1ffNgboH+qnHBfZf0AVLvRV5q10y1O4+zEB+p1EYwUD7tR3lL32meQ5t9yAxacEOIIbb
         8qQHO6oS9MB1/wFwZLBFeoPjSq8XIgRCF6emfiFp3BhV+3yWaNiyNsuHOJ8gfTmBgRh4
         j/iYk1YIz+ansPZevqcCfM6W36ZmNMd/g9RjVtcnBuB2D+zsUJ/tlS8bSY4aKdOtTQqI
         5N6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761738676; x=1762343476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4eAuxRdra6xYn2AEu5URxIFLv0U3aPRV4JUn3Rr/2D0=;
        b=Or9g53gIAnVvW2GrelTzLiFB1LAnK6cw/fUzigwTglHYPgzFM2oxiWM7NaY1wndeic
         BIwOdACmrJLtlP0pNhrpf0wXP8+rRGQn43gxUs62YbnJlRG9y6FysxwZVTQga+DfTbmp
         43obBG/LDsB5O2d1tlhuCrwYtuoZeMCvRxLhwHU/UrYsQIWTtvaeKe3VqBnyv7PK0j3J
         04yrytJicFFbEOwwHMlBhxJozkFho+XBJxZI58tmMAYnP3R/rW54sokej5x/o8D7lHbK
         oiGOv/i0pmUUv1ENK7WO2jsFGYsvjsq04yTCtDffecVyQ5ogRlkvlzHXLx24rol7sNf1
         6ofA==
X-Forwarded-Encrypted: i=1; AJvYcCXRLfpm6dNHGJh95L+3jExvwuaULNVoCb3Fp5tNK795eBUIlv4REEDevSznfsv0SdnIBx2c3JPK@lists.linux.dev
X-Gm-Message-State: AOJu0YxDOBqCfzhZPEuQBYKsEh8066inGpIzJv/4zr6xdrlE+Zr7F47I
	WYFETCfE/yndQn9cTBmkrhznua6M58c8QadGun8WO5XggNKVYw2i6kfw0rBp3aOw0CoANEHvFSK
	2QtNOKAOFV4cWsP/7fDz0PwoLskA0kpk=
X-Gm-Gg: ASbGncu0jfXftlosBPi3miDBTLtWzXWkwfgOc/Fy7D0lQeMRXDq8nboUS3QZjUQy62o
	pocVg92Sxk5aVVSBNMuQRFeGV5SLODydknCtMeZyXNlkaShW7VhiQ3KyB4Uvpqa37cU/EWb/5As
	FD4Gk27j+nit+SgNG0eqj0rdnzg6/4TZii9BfrG1VfB6GIdj6VckJh38jMAKnnIm7Ss9C3WwLEW
	pfeULPqwLiJN1kxN2GeeVxl2rVwJPCMHKJpB9AUkTLr8UFEW2rBWh4Y6dInPePkG6iba/LxFu3G
	eDw7F0ohWIcT7lF0aqbOnuFmtY0GRPMgg4+K5aMv17+fhT1MCxLQZJlXRMObVf6kUyGvhRLAeub
	OvUs=
X-Google-Smtp-Source: AGHT+IHydl5eW0/Dx2EkVGLSZgmAKiTuqfAbgJdkgdsRFye8YTtzwH3XYU7OFAr/IP3WtWR2QZHXmGbjwyn2fqhtndQ=
X-Received: by 2002:a17:902:d4c4:b0:290:bde0:bffa with SMTP id
 d9443c01a7336-294dedef47amr16261185ad.1.1761738676328; Wed, 29 Oct 2025
 04:51:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251029071406.324511-1-ojeda@kernel.org> <DDURZLGB2VRJ.28Y4AP92FNFPS@kernel.org>
In-Reply-To: <DDURZLGB2VRJ.28Y4AP92FNFPS@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 29 Oct 2025 12:51:03 +0100
X-Gm-Features: AWmQ_bmrmooyzWnmY9GxFiFIfc56zKAyCS5p4B1qi25Pm2Uzdfv_Hs5RDQeg1vo
Message-ID: <CANiq72=HhDQP1ucccLzZj0mtb5Qa8u-1oorRwCqNv+aEJfZh7g@mail.gmail.com>
Subject: Re: [PATCH] rust: devres: fix private intra-doc link
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2025 at 12:39=E2=80=AFPM Danilo Krummrich <dakr@kernel.org>=
 wrote:
>
> Given that, do you want to take this one through your tree? If so, please=
 do,
> otherwise please let me know.
>
> Acked-by: Danilo Krummrich <dakr@kernel.org>

Yeah, I sent it independently in case I take it as a fix earlier;
otherwise, I will put it before the `syn` series that will go via
rust-next since it is not an urgent fix anyway.

Thanks for the quick Acked-by!

Cheers,
Miguel
