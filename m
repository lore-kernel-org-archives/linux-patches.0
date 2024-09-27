Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74783EEA6
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 17:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727456891; cv=none; b=R9XoDazB5ul9n/oMAH3oDJP0cx0vPLkpIMLeRrzU9WUOTP8lAEVcTcuh4M4UVudsFMgYIB1U/VsgUqCYmC8p2d+Pdu8kKrDMoMuIeOVaD9qIw9tZJbyuTOIG6vF8kk4JURWMrapMuJjYIIjVNarFxXK8Eg7mchjfhyZvirFhniU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727456891; c=relaxed/simple;
	bh=gHzlo4cOS28cjIM/reymBy1+bVdXWtgnUI4/EktNPJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=joZ5POMT2xcAenYLYhZmoP7oDh52FzK3AGjU1C/f+TXalC1AvMkyP2KTOJrNcHL9DAm/L3ZHw2Q0KQHXZX+lMp4WadNxUfK0HLo/lOWj+JPAxWFo0clUQVu8C+SyJq7VKTNdZIQdJ2D8/+OSXgcZScumIwQ15rozAocRBoZnrw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bEPc3W4b; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bEPc3W4b"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20b2093f1cbso3155595ad.0
        for <patches@lists.linux.dev>; Fri, 27 Sep 2024 10:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727456890; x=1728061690; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHzlo4cOS28cjIM/reymBy1+bVdXWtgnUI4/EktNPJA=;
        b=bEPc3W4bE6TIwdXWjB3e5GiLRf9C+c/bnCezPM2CkBmyovcB9CTR4MR2xf6J0PmEbC
         yGz/SbLvSwvGqV5Hhlidat6Hgn4y1pZ7dDuWZTyPA1bnNGt6Z1rBSSi8Jlx8ftsa4o6N
         UfIWHMrUAkQ9yyzqH+jp2SzoBDFlIsedkIlL6gtdLObCFBJX0XDe+yl1UG4TFJ/lYoa8
         d7QuFHNJGrDeFe6OzXK1zrOtB/OfUU40wrUWGH/Y0Tq5l3f2MRoVdnLSza4xw44FJLmT
         lhYc9OOCP2KgOptozs6GfkB0Srn+/2BFQpuvvzpZduHvEYf9GqhJ2SrYlZkDam1xxgLW
         JL0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727456890; x=1728061690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gHzlo4cOS28cjIM/reymBy1+bVdXWtgnUI4/EktNPJA=;
        b=Ns16uaBsLoIZoaFrhpbrPIBvPxFeSarx9MpTcSm+meqfAVSuIpfK0ZnAzln2Bxf5Be
         BNDH4SrkOjDjEUt4WfSMfOo1YblRtFosJK6qNPwV9GpemUbtNolYpt08o7GMKUrws190
         LpxALVbgg+y/y39v1VTbxVvEOZtqytF0A+Y/W4ysz66YIsVLe8M9VQlZ1R9vidKXZ0c7
         CdKaJJ0FPhBH5l6d3+cUv9egdMPzyw4ZC3JOIhZY/jYruLvDP+zs9rP2fr9YtliSkU9c
         87thn/pYGwsRKSZVz0KwRoOz8kpk9XtE4wOi7LsZYubbnfCZRJx3FnruvC7X/oTq+M3P
         gwmg==
X-Forwarded-Encrypted: i=1; AJvYcCVUQcMYMyhPAoYiruOWVL9rlKcwNye3stsvo9mHnKaCJ0GIA2NJGsQ/psODaL4sJjgMuymuo+he@lists.linux.dev
X-Gm-Message-State: AOJu0YwTyDk62+cPeeN1om1c/WBWeYQbk7CaQmT/ObKGYh/BCImSKHsy
	EVj4KCEkCPrgKEud5ynwHoYJ/Tvl19bTCUjETrUmOs97uVeWI8rS7syGkh0LUISqlWijhzJBj4a
	+V0ygI9cWJyKNj49lHHGwhN/J2hY=
X-Google-Smtp-Source: AGHT+IE76Yj2hnfFIu8kAGW66X93Xu9YW4uSsE7JdNgXmMsRkX5C3b0gcgeZlmhZc91bxmg1tmB5fMbsrwV0gFj2Bfo=
X-Received: by 2002:a17:90a:a78a:b0:2e0:876c:8cbe with SMTP id
 98e67ed59e1d1-2e0b8ee52a2mr1924596a91.7.1727456889778; Fri, 27 Sep 2024
 10:08:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927164414.560906-1-ojeda@kernel.org> <d8d610d0-5cea-40de-868e-8c80954daa27@proton.me>
In-Reply-To: <d8d610d0-5cea-40de-868e-8c80954daa27@proton.me>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 27 Sep 2024 19:07:56 +0200
Message-ID: <CANiq72kMEyGWFf0gh+oi0TdnSq8fTcDS-PTsA4j7X_s4=wz3pQ@mail.gmail.com>
Subject: Re: [PATCH] rust: kunit: use C-string literals to clean warning
To: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2024 at 7:06=E2=80=AFPM Benno Lossin <benno.lossin@proton.m=
e> wrote:
>
> I thought our minimal version is 1.78.0, or am I misunderstanding the
> wording here (I interpret higher as "1.77 > min-version").

Yeah, sorry, I meant that our minimum is higher and thus we can use
the feature in mainline, but not in LTSs -- rewording artifact :)

Cheers,
Miguel
