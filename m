Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569EC197A92
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 09:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529305; cv=none; b=XMiQoDhr+w6KOfZT/RxdBeDliGNEtZQLej+pp6ok5APpvB596f5NcgqapDcSfDGiSsPyEtoXm0wIStxCXFgI1X8aoon6vxx8UCWJtB7u4jtncS0nHAJL4xd/xe16duI6e3VNJKk5pB+CAuvL5mUoZ4EKhLF9aY5DN8UjgD7pVog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529305; c=relaxed/simple;
	bh=1zkNgUAM/QwmJuwVc3NX3CSZZoP5SUWIgiCl+DR8w6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RQxXywvph7dAcpDfiZx9/WoU06v7lLOuub/Hq57fRejSzPrKI1zC0v3OGgGWT+m32hb6kfvlfKAiiKiB/84t7hjp1h6QrtGCTbnfSFcTGCHTSC5aEKI6Mt4Es+e5vTAgPZkQulgfHaBuFZTx43KXDGQKhDLy0iV+M74sg+nlqtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sqTRGFib; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sqTRGFib"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42bbbff40bbso4035835e9.2
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 02:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725529302; x=1726134102; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zkNgUAM/QwmJuwVc3NX3CSZZoP5SUWIgiCl+DR8w6U=;
        b=sqTRGFibqj2m0b7cgs2FjJq+Vmp1B3xzhsSYcY3f3WO3aHK84VqGwQhXLEckb22Zqb
         OuRNHJW4KwWqgvLWZKQ6lHqLDbt4sCrd4pJb2+8Hdj84oYhXHI5xfXixtVAgg6S6EWAg
         Nv5uU3rovZ3KdpsD7clNaOpgRIBnxP9s7hYhxws2FINAwhKi0/t9DKnqswqRZ8nJOeFs
         q2eGzTJX0xHvHTecOB0Dchk7QekXsQH+PUBj72O9UmpG0t9gaYQuvv7ZeGJQ7IFG95Na
         unAVtBqF/kxuowJXWR3rjkRNtj6qJjHMmnVQdZAu6pmxqbIJbxr/tOKdnP9wLPO84Mcd
         hj9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725529302; x=1726134102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zkNgUAM/QwmJuwVc3NX3CSZZoP5SUWIgiCl+DR8w6U=;
        b=hXENpYoaxp9rJ/A+OsbutQfq1pnsNLvOKUG31uetPMsnWrZjxJSkJRjT24O19nw+GR
         lNtFig5bBLQvA9f858mnRd3CzSmyPpFVI6ACdtxhMY1CrEM0hv+oJOEphXz6nU5y1sqc
         aJDrQsF4XlG4qtkaM5JQHRf2mBqGrIPDfj568d3s+z+OzEPP3D0udvp9iWHMBWahIKTV
         31OuyZVCIkdqKGtZS5RDxz33DlLITzSJ/ssNfF43m5V4Vb6vYRFLtEqOBOmAhR5yxKK8
         Y+3dta6oJ2uSMu+N+zIYCHoyQuIs90QQHzIhpijGwbL2F3sFwC5oF558D1tUh9tNJojO
         Noqg==
X-Forwarded-Encrypted: i=1; AJvYcCW5n2aG6+sJdxusNIYFG5ZwSasSPU3r5QFHrwoQZPYHr8iwjjsGi6FpN4R99mEc5L3wVsM8pf3c@lists.linux.dev
X-Gm-Message-State: AOJu0YwGJehwo/o2wuopkAEFW64mRX5AYO/7+e2wBKsY0jhaAnvPoYcA
	uAcrxVgJFGZofve7kPRG1VDpTvZjPaWuvYhltVTRKoHK1IHan9FXfhQvFzMy8dhzsFzA4VVpbGs
	P9XmOsmQG+nj683toqjWE6jT3pYIM48FRLIH4
X-Google-Smtp-Source: AGHT+IHJPny+Snwd0y0fa0gKoADQLjpbyUkOKURoPb20rbDcDh68aZg+DCflOGtgw2LNVd0/14snpmMwRHGXhfR7Vww=
X-Received: by 2002:adf:f0ca:0:b0:374:c847:86d with SMTP id
 ffacd0b85a97d-374c8470b7cmr8594180f8f.16.1725529301228; Thu, 05 Sep 2024
 02:41:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-20-ojeda@kernel.org>
 <CAH5fLgjfxSOmnPsk_673qNdnpVoj1W11LD+qgKqBG8J7sm-u3g@mail.gmail.com> <CANiq72m9y6agZyca0dhchr64xJYjuNL3G-NVSKO6=wyU=skJ=g@mail.gmail.com>
In-Reply-To: <CANiq72m9y6agZyca0dhchr64xJYjuNL3G-NVSKO6=wyU=skJ=g@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 11:41:29 +0200
Message-ID: <CAH5fLgg8KSNLrAUsFHTceVA0Zp3gUCP5yjawXN_3SuOR5Y4Gig@mail.gmail.com>
Subject: Re: [PATCH 19/19] rust: std_vendor: simplify `{ .. macro! .. }` with
 inner attributes
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 11:27=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Thu, Sep 5, 2024 at 10:19=E2=80=AFAM Alice Ryhl <aliceryhl@google.com>=
 wrote:
> >
> > Are we ok with changing std_vendor?
>
> Yeah, to some degree, i.e. the code is already adapted slightly (it is
> not intended to be a 1:1 copy). As long as we keep it more or less in
> sync with upstream, it should be fine.
>
> Even if we had to diverge, it should not be a big deal, but it would
> be nice to be able to pick up improvements if any, e.g. there is `let
> else` being used now upstream, which we could replicate (I will create
> a "good first issue" for that).
>
> (These allows/expects are not there in the original anyway, for that reas=
on)
>
> Cheers,
> Miguel

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
