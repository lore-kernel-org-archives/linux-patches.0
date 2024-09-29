Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B253D96D
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727585853; cv=none; b=K/5BP8nubEK/0qGXAwkuPx5j/sRbp14KGma3txerOmkJ6NTFhHd+D4/fhk9Y5mg2AZ57oMkpqXBEOTo2Jjhv/yVXVoiirR+RHyikqY/YcqsI+LJSa+uko4qZM+PyJnkTJKGOs9jgQfekpeyUjW8+13OH9SVAj9slGyTELm9THL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727585853; c=relaxed/simple;
	bh=8JAXnDgwC0E96DmvB7UMxZsYbUOAqQTVFvH/v4Cfgew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q9oL3PyEkA+yRzFxs0sX942S6ZdBbXkEPHq2EruMWEDIwEvrCPBRj+CW/WGRe2qIti9Veyh2KxQ78YtbNCuwqQjSZKAJYx1qdan2EdPQShA8vOEzK/8zERLwYKWT2o8Awmtz0CADn0OEQT40QAv0AP6uyEcLo383GdUyf7mrYfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=QODyHcBQ; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="QODyHcBQ"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-6e2346f164cso24887627b3.3
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727585850; x=1728190650; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8JAXnDgwC0E96DmvB7UMxZsYbUOAqQTVFvH/v4Cfgew=;
        b=QODyHcBQTsUMVvt9TUfiRW6zFaz5EOOxj9uw0MQeRR/BmQARAWqMD69DZrUrn7nw+F
         I2eAx8W7eJLEAC5Zu7CvTRLMg2P0obUXnmqc0NWLhuz+pANOQCdqqhvEmvtd2AW0rXNE
         MW+y/byfE/peEmi2IzoAjPhYjG+dydZmPK+HCO1gbhid1/n4cJMC7oQTR2LA+1ld+nmB
         TSCl7fPUy2bPGHm5iOn6S8gmTessUelWW7VVP204AOUkT6+ltD/e7KzrslXfKL8UkM61
         +IgOq/0ATav8pgxUtnJ1pZ+QetpaadZM55pftWOFSZHmMlUcBSksY8lDl9SbiGJb23xs
         rQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727585850; x=1728190650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8JAXnDgwC0E96DmvB7UMxZsYbUOAqQTVFvH/v4Cfgew=;
        b=tl28FX/O+s6FPLT9V9ocU5OlypEnrl/ABxMN1PJHOsUdo3CHkpcQocxNtcVMUC97lx
         R8SV4U9FPKffuMVNf1EDnA8zykUY93jkpafdHrc0/hJRwZ6xb2ghNo2iTCDDfEJOEEfG
         wTQ4Uyiyd/QU3OdbMOQogMOHyOQ42jlNrPJT73Y0nKrR3N9KpiqIc/f6+pxt1ZPXz4UA
         mX2VFlRjdfPgptNLItd0VLURm6Kcmmhvb3MJTKQtICDSx9FfPQg8aZcbN23Z6rsfWMCv
         qPLWLGr1QR6yCS/8gUIT+iOPLyUZVCCqIfhd5yumD2ZvqMLn86naGoLCAJ/06tNu7yFf
         xF2A==
X-Forwarded-Encrypted: i=1; AJvYcCXqNCBRG/1skZJgRXV7oqeyokMR8AqujJPHwe7S8kdNBT9c4+YYiCQ/Vsu4HlZ64j15SRx8noOE@lists.linux.dev
X-Gm-Message-State: AOJu0YwvaOtqtahKPtvf/ppzXbEcSzBDaInE+DhFcNTNOVWkaG/D6T0c
	jJa2kP2kZ+ZoBxRNmnwK6ZpHl1KyJ/7w4Z9XDzvzwlP0xsVDUrFe2ciXyMD0VhqGErLT0+1R5zy
	Q15kW0Xahzt+XfgoJ3GChopoP26hywldC8/5Y0Q==
X-Google-Smtp-Source: AGHT+IE++v8Td22nI2Q3soyTzNnP0Aq5WWr6h1etnmJLmPLRDEcrld8EaVYYkChWaSBJSUid1U0hDsRreiPYOsW/qIg=
X-Received: by 2002:a05:690c:6788:b0:6d6:7c9a:bf58 with SMTP id
 00721157ae682-6e2475e6741mr63957807b3.28.1727585850530; Sat, 28 Sep 2024
 21:57:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-16-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-16-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:57:19 -0400
Message-ID: <CALNs47uSN723+vO9d+sTry7XRDZf1BS_pyA1iu57Yk4M0rtk0w@mail.gmail.com>
Subject: Re: [PATCH 15/19] rust: enable Clippy's `check-private-items`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> In Rust 1.76.0, Clippy added the `check-private-items` lint configuration
> option. When turned on (the default is off), it makes several lints
> check private items as well.
>
> In our case, it affects two lints we have enabled [1]:
> `missing_safety_doc` and `unnecessary_safety_doc`.
>
> It also seems to affect the new `too_long_first_doc_paragraph` lint [2],
> even though the documentation does not mention it.
>
> Thus allow the few instances remaining we currently hit and enable
> the lint.
>
> Link: https://doc.rust-lang.org/nightly/clippy/lint_configuration.html#ch=
eck-private-items [1]
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/too_long=
_first_doc_paragraph [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
