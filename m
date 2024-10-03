Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254DC2E859
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 20:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727985648; cv=none; b=AmY6QmbTB7xWGk+1yyz6vD7X8iFpdx6N5Ob7XKXYvxj96dbwaapXolJagr7LdtqpteKYUinzw4tkJJsBuq1lUHeyuRgTEo+rz54ViU+aLy0+KVwsxgBnGo4UDC5lS6MxDK+MwNnZOTe2iiDuGCF00Q0457O18qat43ThsYJjAHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727985648; c=relaxed/simple;
	bh=UoqoaM05vPymb1NNs21LPer58Axo7gfGhV1eH+OdShk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EbJ6VOVSbvWNnUMSK3IJK1YI8JeTjHXW51WxbvhcmrwMQYBm5nGYMm09GD1Qi5yRpIcAGVaI5j3EFsR55w1wUkCfwhTyKLrCfsIQfWOa+eYjvPWf0Z0uqnbu00BrpE58ilHbSiWcGq+mImV46uMfIphWgZy/j8IzblKEmOGKaAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bic7/E0G; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bic7/E0G"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7e9cbd25337so164158a12.3
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 13:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727985646; x=1728590446; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UoqoaM05vPymb1NNs21LPer58Axo7gfGhV1eH+OdShk=;
        b=Bic7/E0GsZX70j+FiNQhcS7BrfIDs0UExpY0o/ZvQNAuy7pp4FtDciR/p/8PVZX49m
         2lreHH6ibSa5qa0Cv1gyAJ0j2uWHTzOj+juEEbxHwbv0sZxpUKjVkhgUpnkmcBM7kPF8
         Hh2E1Ozn/0W8AApwuxpurtI/Z4B598PiNi1S6fLCK/Quulq19YAwuHwlUKaC4/B3uZxw
         XRmd76lp0OB7FAkzGAS1eGA3/ryveogfyzC4vJi6zkCmxULpxmG4dMXjDVdMh+2Qylnv
         O6iT14af1rPDUH3yDKUf/oxvwtZFSJf3H3/mnacjZKbIXTUYWlG53pb+Amv6PKNzbs3O
         IX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727985646; x=1728590446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UoqoaM05vPymb1NNs21LPer58Axo7gfGhV1eH+OdShk=;
        b=pnQVtbbun2qrK5k1PE0e7flmnCaNt0lzQgKogljfY1LHgIYOVjIqL17GgCcx2Q4mnd
         2VtGSAPxiPoonUyFdw2juXvQpDDnH7jtC1SAm7HllBMF1H+8MH9LXSWw3SV5Wc2MM64W
         6EfJJ4PajFjC00AFeJOe2GBJQ0PxPb+thqb09k+T/oMm9GI5vY47ZnSVQeFyKiRxT4QG
         13GWsGwNVtfeKjWN5sJkDyAGyAgvsnOwj2eSRLrVun6Tvc/4OjLCm1AAMMdzbzrC92kF
         f21EBIoRmHCBj7/Hi1WeseBDfmMTwl6n0kBFtIqEeS3RnvNtKgr89efogp6Wl8nnkNuU
         ieRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdIq4QGjih1tXbJiUAv8WxI8kTo/ZFpt/vuGFNr9A3MQ9RcDMl/xqbrlSFGgocc0q0N74X+jVY@lists.linux.dev
X-Gm-Message-State: AOJu0YyIz2yOWlvO0qtCP9N/VRN2Jg9iEB29axd8/YIh72rCnE3GU9sK
	oXrGSc803erU2owS8Zt/MsSq0FVt8DYWqEzFHdqlInRPvGOzLkeyE8/2859jOG9vdlwaoybri6O
	xv4rQXS+99j0Zuv5tR3slSsfUNJY=
X-Google-Smtp-Source: AGHT+IEtGHvRvHryQjF+XZtgO8rnb0QvpIG7ocNvoG1PV4Ddkccy+WuG+Izs2kC+TqBFpa725+tx18EmNaJMcPLXZwM=
X-Received: by 2002:a05:6a20:12c1:b0:1cf:4edd:e6f7 with SMTP id
 adf61e73a8af0-1d6df7307c8mr286029637.0.1727985646416; Thu, 03 Oct 2024
 13:00:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-17-ojeda@kernel.org>
 <CAH5fLgg20kDCJfD_6+fTSogOnpqK0x3a6eKaTahgSvdgfFzSEw@mail.gmail.com> <CANiq72ktnMSfMfGEhN1kO0F+C5O_KsUY1y_eb7ZL+qzzSkg9bw@mail.gmail.com>
In-Reply-To: <CANiq72ktnMSfMfGEhN1kO0F+C5O_KsUY1y_eb7ZL+qzzSkg9bw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 3 Oct 2024 22:00:32 +0200
Message-ID: <CANiq72knpbKByDZt5F-fNEqrOHUJvqcHdWwLVRO=v7b8eSAgrg@mail.gmail.com>
Subject: Re: [PATCH 16/19] Documentation: rust: add coding guidelines on lints
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 11:45=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> example in that sense -- I will think of a better one (it was nice to
> use the same as in the other examples I wrote for `expect` later on,
> which is why I used it).

I added a footnote in the version I am applying to be able to keep
using the same example (lint) everywhere.

Cheers,
Miguel
