Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A6B30506A
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 13:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781301; cv=none; b=qUvQgwy4qHv4rbkYYw+T8MY3w0U6rUwS5FNOlgGApyrqvNFkCzub5JjzQeVawcWkBXRfpJdICR0g66C+ixWKVWzenq1xIHIseIR8uL5zkVezyxTBJwMS46pSE0pOJEvGUjsUrm23T3VdDIiB6t+affnUN22wd5okDbNIJDL/MdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781301; c=relaxed/simple;
	bh=bjfTI5/MNKD9oHiCRC+m1AgyC5/Ghs09FtZxTOpiKMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WyLp25AZkfdKfseqvkif7RVZM7LDVhHnWvV33u32b0ttkSfpnj8PjyxFp5KhKjSAO1BgM+8vFZTDN2H1qIJ+UuHCOmUj8auSNMJ6BltAPnFMovFwDcAscC4GQMktPYFBUynr1RMmU9GejQv1ooeWNtV2UvZYsHmLWDTRANbYp1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Le1Xl0mG; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Le1Xl0mG"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b9a5f4435adso240856a12.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 05:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762781299; x=1763386099; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bjfTI5/MNKD9oHiCRC+m1AgyC5/Ghs09FtZxTOpiKMo=;
        b=Le1Xl0mGgiqt5Ykdbuxb8BlAChI9Dix8tZF5QueOlYW/AjGix78wkN9UkFLeAVtSAt
         I60GMR/tfHau21T8fpnKWReiscOp20T5rg5Vn3zoWiUgWS1MVzuoejx0wsRJq99zdZkc
         I5lZbuyN18FB+oSwk4RxtAz5ymiL60WcGm3t49zmBMNszoz1pzO0/mEDIJXqZAfs6w5c
         j5ZA3QTnInsaPRaIZx6rq5UfZwjJ5UvDnfccuVzNsJpzm9C6ercjLD9pgENg1flRBI+C
         KFF22tq94q2pDUtD/QN6FA5P5tNUNCeJ//j0d7lDH9Ow9QfMDlNcM0Zl5sWbfDVDCCkn
         yzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762781299; x=1763386099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bjfTI5/MNKD9oHiCRC+m1AgyC5/Ghs09FtZxTOpiKMo=;
        b=wn74UWSGBJrVnA9juQYpKCtUBB75+oJjRcH4aIAqI6HPKocsk2NjLvcNEYBlR9WEWx
         3cVHURptXgk2EDUEF9MVZJzXF/VU7i82sqwm6YwH+8UpRFoyMrliwoKSTI57WCIpusRR
         uGrF6lI7b5dKzYU41Skylgnj7mowoApC+9OLLhgKl8Ge3xyp7WxmjkBzJVsymj6HtFJc
         uoyyOrG558L0acvvenqnBu5/OX/CQReyjJtOz70/58az/gIO7QOMfheRdpjWgBumB+lO
         MgeCKxwT031B18GUlZBAR6+4Oezv5+LdUDDzK/dBTrlII/8ai6IQ3LR0igRIeEryhzJ9
         Avlw==
X-Forwarded-Encrypted: i=1; AJvYcCVFywzUUg78RGzveun2Zy6JlJSfEjzaT/xNFhIJP3GAb+B9GLQgoQ8nVvWltsjeUywEONBYXyTx@lists.linux.dev
X-Gm-Message-State: AOJu0YwzpwW61XRDgBgvZbjp4mR17Di4+nnwghaQ6LQyiILLp+9K9f1b
	LdW7Ho4Z139kRgF1QUHWXYq0sc1bOkID2/SJUrFZphflTlRJTi8UAPbG5DI3DqDac/FW4OgFxF6
	kGboCoxfjHid9Xox6yXvehOaNHjWLzgQ=
X-Gm-Gg: ASbGncsU2DLHyLIi2TuKSFBchxx2MsUJvVP24Es67tTbPPwnEo6hTqyOAus0+/Ka1xW
	vm5KkxL7fk2kLl8FyUtKB3LCvKdi2rA39aNiQkUAPexapDcwsi+TPkTOFMjnx68l5XJu8Wu7PNz
	7bKE9qwUzCwSNIuSwnQkRd96rSB1tIWBS4LMAtVq9B1W2gzQP1FElpHobJSbAZWA9WTqP1Mcqi9
	4ooB3dyNIOU3rOI9MrzzBEv7AzP14BhG/bAjgIbuLLf++yVUjzYFE8GGpWoB1qtk2Sh4Pyj/uvD
	TFzzwiCPvWPKKhM75TmgSIPTc0FeyxLQXWgBvoUx7iK1ELDjDWkqy0rjfrW+Ig4WyAXam81zQbh
	lAhFJbeLKLs//ehHqWGnLqX+y
X-Google-Smtp-Source: AGHT+IEyNd/CIr3oQh1rXjWGYDIzhBKFEX331S9clDMfX3PRs9JtaBsmWUbizR9ZvdnMVpJ2wUh49e65b06MdwUpBx0=
X-Received: by 2002:a17:902:d4cd:b0:26b:1871:1f70 with SMTP id
 d9443c01a7336-297e567be2amr59101785ad.5.1762781299138; Mon, 10 Nov 2025
 05:28:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-10-ojeda@kernel.org>
 <aRHOnGyLx-bEVqcY@google.com> <20251110131049.18e2f5c9@eugeo>
In-Reply-To: <20251110131049.18e2f5c9@eugeo>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 10 Nov 2025 14:28:06 +0100
X-Gm-Features: AWmQ_bmiU7DKmjn-tBgMdy06u7eyya-M3TMlTQsJq9SC-BFptX9Vc5y9iKMzXvs
Message-ID: <CANiq72mGYKYZmQ8g5AbXCsRS+WPxbeaSyngR69jsEpY8akouog@mail.gmail.com>
Subject: Re: [PATCH 09/18] rust: proc-macro2: enable support in kbuild
To: Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 2:10=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>
> So I think the implementation here is sensible. I believe Miguel's
> patch is also pretty much replicating the logic in proc-macro2's
> build.rs.

Exactly, I was essentially following what upstream does for stable compiler=
s.

(More generally, even if a feature may work, if upstream doesn't
usually test "older nightlies", then I wonder if we should enable such
combinations/setups anyway, unless we need them for a particular
reason).

Cheers,
Miguel
