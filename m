Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFA4198E77
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523825; cv=none; b=rmJNkrmeas0MxkrH0iN/buo9pW4Y2Ba6H5b/tggf6hWJCTINhYQpeRJ3YQOi1I7lN8igMysJy9+u2MJaezjZ3m1vG32hAOEfz2odN6lCOQSQdcO08PGco+tv/2pxSpxW1zBQPBWcB8bUG/lRpOaqC9EDbV1gSLVbRCLU3T2TXQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523825; c=relaxed/simple;
	bh=JB5nCSkw0VLqFnfOIc9MMDc29SMicRFbGInFV1poK6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tOdVoi1hW13H3xcaAh04y0lreMHnff2Kwk7N7U1SXKNwc90H+FuzeaV99OOQFxCT3qbsNwXZ5++Vf6saRZKvrmNDvYL2/ir0e1l4cXZJKO9m5yEnHAN4NTNrixxOiO84yZ7zVNt+Anw9xYHBeKMfwLC3UuBtM4v7O6uNoE1mFl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ay/jd3kF; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ay/jd3kF"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4280ca0791bso3277575e9.1
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725523822; x=1726128622; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JB5nCSkw0VLqFnfOIc9MMDc29SMicRFbGInFV1poK6A=;
        b=Ay/jd3kFV57EE54owTsHLXThJRX3Hp8dEdsyoVPTd76ENT1WFEd6OKBQp6s2gPGDHP
         Im29/5FwwnsobX2cAVnm1uY5wHfqw5sTU+7/o4hksc7tL89n/dNeZRne58Gt+HwuCyCL
         E6WQMnPQPU3Ta+5r1+suc45fhTxsKHgU+nAjP//lea8aVPMnPv2RCawPjYC4AENMGYN+
         7Bos2VMCkrg/gGaTz8cO2z/TUkeTVSjrKJ20FJwIflX7XAoIh2jsKd3aJtzd/3vrRf7w
         srcodOMR4zG9SC3m9SHI7qV3VuNfgvF3Xt6e3tFo7OTPWOfqTaUQPYOArreiSHcPI+Zy
         S8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523822; x=1726128622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JB5nCSkw0VLqFnfOIc9MMDc29SMicRFbGInFV1poK6A=;
        b=iKE0xVeQfL6gw310R3f3dXQ5NFuTDJ7d+RK5OJQVIXPMKbCEYKdYlo/bzn92Kdq/Ej
         SA+WmBti32WU/Kia+Au9sPr9MqPrKdHSmEnGzjAB38PpyoqmXs+QskKphbntXMuVLjRq
         QAEFlX1bmdfbbCRCmVVz6fhzcR59jqkYVxLouUrBjIezxWWfCEMHZ5aKP/uCZMkyn8lk
         ZQvdMTCPwzDw33+exeFjH8PbUCZWAbqgvhX2khauyDzwf/QT061Ido48gNDcYF1TlYlC
         Gd9535d+BpSiI94R+KssOARA4gwczL7x9DC4KOgOMKlXvKHOja5y2b57FnBYYTCvx39v
         dwJg==
X-Forwarded-Encrypted: i=1; AJvYcCXxOYBzPAyTIc3ne3mxRs0ce5KNYls7IhKMwDL9I3jaAdITNNK6lkvlPgcx71YayKr8XSSQ8lcN@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5dYHcwYtM42hJpUDszY5ZTPDAwieo2XyfzF5o4lYSuWuMvsEv
	DJKZLtHBGb4DbHxFyeOEsI5cMg9/SGLp8p9DizyU8RGzX2SjkFAtxNZt5wPUOVcWvFqto7vpals
	Y1Y3fDapzYj/p5fxkFt9jMYmqZeAINLsdOllD
X-Google-Smtp-Source: AGHT+IG5SvREPeks+5Y7psAEInexv/HWsATpKYx1bJ7JKzDl7CMR7KRa4EjS5aLBH9sf9IJsCJ9dojHZYM4rrKw+PIo=
X-Received: by 2002:a5d:5269:0:b0:368:420e:b790 with SMTP id
 ffacd0b85a97d-376dd15a8cemr4182916f8f.14.1725523821561; Thu, 05 Sep 2024
 01:10:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-10-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-10-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:10:09 +0200
Message-ID: <CAH5fLgi4rVuS-uYdV9hqV7u17qgFVtaAXa0YkW=uhbca5Dwxeg@mail.gmail.com>
Subject: Re: [PATCH 09/19] rust: init: remove unneeded `#[allow(clippy::disallowed_names)]`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> These few cases, unlike others in the same file, did not need the `allow`=
.
>
> Thus clean them up.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
