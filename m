Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65581171655
	for <patches@lists.linux.dev>; Mon,  1 Jul 2024 21:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719871096; cv=none; b=AA+Xob+znm7UJIOv95Wqqm9vJsW5wjwofc6AhuoEAuMjF7cb1maFYqrN8xg8wZk4fg522E1tlitdBQR/s/7wzvXzpPpRPC4I0uB7K2JIMJdAJdjVLRIlGZVri2Xr0TJiEowrIJMcChUNyDuK/xtJSAdHV37MRbXI+5J419jt6NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719871096; c=relaxed/simple;
	bh=PYgsuVyYvkn+AqFLpRd88UBBXKZnKbAdz2lU4GdaAz4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gcIU6yqW4FCLyRuYCJrbHU+hZq8gytoj6FUEU1N4lFmrBxnJQDEH6E+fpqNbheXI/ZamGNK09Ze9nwyixKCJSh7S1ObHormLoi4pBLjbz6hy9E+WCljRhzzHGTHSfu5hhd0rp5kQG26MZGo0P7q3xSP+XTQCc/RmR/VVEzziwIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aIu3NrSq; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aIu3NrSq"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2c70c372755so2310331a91.1
        for <patches@lists.linux.dev>; Mon, 01 Jul 2024 14:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719871095; x=1720475895; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PYgsuVyYvkn+AqFLpRd88UBBXKZnKbAdz2lU4GdaAz4=;
        b=aIu3NrSqZ3iCSxNtb+FO5YJ21KUQxEanICSb0PCrOiswxLZa0nlFoXr1do/0J/PJOs
         stndyaK+86ZDKQaSl7GnngmF9ls49950WTGPlHHEr4GppqQG1YH0Vop/MPazjnMUZtEr
         w//qNBJ8G8qPr7l0iZYdkdSPeSeF5Egb/fJp6AUemIkFArVuDbbDKm87r4pnxtLf0Gg2
         PtTkOSWtCdcm+gi0NJqYQ4p2ojotQhtUDd/7BMttnkVJ6L/o/9B9z4IDIVglFNmrk1gD
         zDHn2K3W/+WpOjfC2KmyMCfsKuyW/9dXUWlhfjdf9GJSsgVb99LJ0IvDdHLSbmoRa9C+
         XJtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719871095; x=1720475895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYgsuVyYvkn+AqFLpRd88UBBXKZnKbAdz2lU4GdaAz4=;
        b=UTL1la3zld1BlqfMSIoRMQi7Azn+cMRtNYGGVQk/OStC+XsQdcs9WeAJYwyroc2Y/L
         1QQlvvZA0MeJk5xOCkWdc3MqG+0sOjY8t1bl6v+Nx/OvJWoL1fgRRx/4XFl3nGxvIn0d
         Pw236pqtnjSC+v7M4SDvJ5JaolcHtNJzRgW1RC0yfQw8Ufl/urQ+cXOc000CXXWyFf1G
         Yq6wyTw+3CEgqZux/jTbqgHZeDgYDooW+74bxs63bVwkVWywvg4LYkoR42sTNbNC0cy5
         WA9HZGovbRflaw6W/HY7azep3Ke4aANaNhBHCsn2XKLQYzTERE8PCR/Afm821IjXE5Z+
         mWqg==
X-Forwarded-Encrypted: i=1; AJvYcCX2s1qnXdZ2dQQCXT7XN3ND7gjOS6RmqGeWxT4sQhDnLN4z8qslH1SaZmHwOfuiREXFY1EgX+jaRAZDNZm0XdAgivHc6y88vA==
X-Gm-Message-State: AOJu0YyTam12pQTyNYth/EWJcxCTDfjm+u48TqVsGS59J5wsQ7fwyE3b
	J5Lubxjedl9YKQD9FEqiBgrv2TxESpu5u+IJca36rPkQzFlfzB3D+060UZ+JVVL+DSoysj1n6+j
	iD/ZzuP9NfaVlt7OxxSLsnNrbQLk=
X-Google-Smtp-Source: AGHT+IGKpBsvB7xlkrEGXyjToca9aZ2muSAK+blJa2KJ4Fw+Akc1Xvvtwh2hiQRXNfmE84QKngmHExcKXXuRbb0D4HA=
X-Received: by 2002:a17:90b:3143:b0:2c8:dc6e:ec4c with SMTP id
 98e67ed59e1d1-2c93d72a15dmr3766653a91.2.1719871094631; Mon, 01 Jul 2024
 14:58:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240701183625.665574-1-ojeda@kernel.org> <20240701183625.665574-5-ojeda@kernel.org>
 <WGFMwMlEU5xZ0Gz_9eqp_ATSk4UiloYSjxQi3JpxZsPQK_HU5S0RYxvLO9KXJEkADsKWKmtDfRYdpAkLrUpprgS2tbo-vIKfAW6Inc-Lhxc=@protonmail.com>
In-Reply-To: <WGFMwMlEU5xZ0Gz_9eqp_ATSk4UiloYSjxQi3JpxZsPQK_HU5S0RYxvLO9KXJEkADsKWKmtDfRYdpAkLrUpprgS2tbo-vIKfAW6Inc-Lhxc=@protonmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 1 Jul 2024 23:58:02 +0200
Message-ID: <CANiq72kQSmbnb7h=Brq3Kr=ffnbxNG-Rwmh=Zr37BHAFB+2mGQ@mail.gmail.com>
Subject: Re: [PATCH 04/13] rust: relax most deny-level lints to warnings
To: =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 1, 2024 at 9:49=E2=80=AFPM Bj=C3=B6rn Roy Baron <bjorn3_gh@prot=
onmail.com> wrote:
>
> Maybe also keep non_ascii_idents as error? It shouldn't have any false po=
sitives.

I was on the fence for that one too. It is also unlikely that having
it as `-W` helps "productivity", i.e. I don't expect anybody to be
helped by being able to type non-ASCII identifiers during development.
:)

Happy either way.

Thanks for the quick review, too!

Cheers,
Miguel
