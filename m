Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4B8274671
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 16:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762792087; cv=none; b=EPMonoFPnXIWYHaDtO2x1/2MvYIS7z8DFLMRnxuLj1uJdl5BVviAYkW/nvJoYUx+BPMWR0cMjlKZtkpkn7W767ZZiVPQpGQlzbYJBDuruaHvNnDZAqzE5lsBllma7qqDFtTn6Mcgl4/fN43oMWEE4c3tTjodKvlfO6LcxL95gCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762792087; c=relaxed/simple;
	bh=7KIXK0iuY9HU2BwzT2hpkkZ4LNFZPjAGMbfebt1Gwss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=afXhH4L2r4pUUmxg0sGNUOyqHQu6CGDDvj8DmfI/bLeTvd1MxsLi0V7ZhZg/8iFZFiHLTLeH7LVJI9uVb+1aACJeyiLlpK2lZKWuW//ZPQZQeu/siUf8I2jlG6P2xvo9mx/ge3PKe0I8m9xCgFja1mg6hf8di7IrLJGislS299g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hWKyVH3C; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hWKyVH3C"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2960771ec71so3572815ad.0
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 08:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792083; x=1763396883; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KIXK0iuY9HU2BwzT2hpkkZ4LNFZPjAGMbfebt1Gwss=;
        b=hWKyVH3CPJ7JMmgtWEbdFgmOuQ3UWrfE+EMlS89lcasfVQkmK2ywIPs3N/wp/SkqmA
         Wp0E6lEr440Nd7qTT3Pn+VUXj1yA1+uF1k1Z1O/jgity0IB/RnwK2KzWebQ+grtNFmn9
         DjPLX8WiOtEjtiT/0SJ7sso9wF+xStw60WE3HIPPByqH16aM3DfTKB5o/rwDDCS3qIdr
         FLHGjfWT0GOZ7TtN/fTw1M/meYu5bvydWnfn++nzF7si6wT7zjDo6V3POUoP3uIqj3rX
         mPGRcl61Kujan9HK3DGP3+KR7BC4ZQumC4tIS6tkGawJLRFF17vopoHkufcZjbuzlzjK
         ZWxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792083; x=1763396883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7KIXK0iuY9HU2BwzT2hpkkZ4LNFZPjAGMbfebt1Gwss=;
        b=nY5orvVebriokKQ+JUaLMOFu++wFmbs8M2dEqpbCh4EEMd+e9/NTg9TrNicQrF7pJ6
         1hLoITvfzfqy9ZhvSomHlSBkxornIKMj7+XHbPfN+iElqaW/t4iPBWb7JpMpo+CTXxkZ
         3pM1mM7pU+ukZVfkh6AYs4y5aFoot5YEsy1BPNN+LXIwU2dnFSSUAJlr+U2V8F4q9Myi
         XCycHJ3onBK1x2OOOBiwNkEwggv6VAvUQPtib0fKzLQSd22aOrBwN+Dbeu1Ub2yQYAuZ
         uKJOSrNIEGIyRx/qvIGaSNCOYs9V2bc5tA0eGs0OieT+2fK8Yi8VBB00USuCF+pcSWFM
         Xa4g==
X-Forwarded-Encrypted: i=1; AJvYcCVQWVA1YmLvB/1feBFVIWwCG7kVsuZNjLWom9Gnr01kxm68ph9vq/1JgSfOfhOi1Dvax3drkvOK@lists.linux.dev
X-Gm-Message-State: AOJu0YwJgxsJ9sF/24DC12YA7QL77mz8n7ek79K9LfxVUTktRdP1OFBc
	+NmD4+8pmLGv53oirG5uoThZVXWOsmCeOa+RLczIBfO9nYdAku4aONOL+OJ1ivrF7oLuMxo0+fR
	AtQN5z/lxmSsHY7uocgB42fsqwoFQP3M=
X-Gm-Gg: ASbGnctNU9OedQvAWNpfwwXi4IQfmEeIvWMrmTsJSKWtRlq+k0YAaEVLk1SDvAKKbWx
	PS8elmf4tYYp+L6hxDmCi27lSywPvlSNJfv+QfzhH2Us1XykmtRE4VK5fbIZIpLty8dionakGx/
	Sn97NUmBlaNJ3BtBcUluWaRvRnhedPb2e0DNcciv+BG2f3FW3sNWVYv5NAXBMonrbKBRbfbH8Si
	TYU3OQuhNb0ep4X+cuxPt0B1Eum3uRQ03076IASC7EaszfsEr1MXTIsfB/eLdl4IUbRowkcxdw4
	V14lrfs2+pjn3WQaxXo3MfUsRM4YXwlMLC+KVenltmWrOS+m5wp3adGgrqYVd7y385Md8xvBKc9
	QgQXkjXm4d2sHRQ==
X-Google-Smtp-Source: AGHT+IGEBFmVPMI5NICewEorUkL0ds7+z3bi+UEi4xsWzIwL5kT2S2mSCMP/63srdW6rOxPPTGD2icUW9ucKWI0bRKE=
X-Received: by 2002:a17:902:d48f:b0:295:54cd:d2e2 with SMTP id
 d9443c01a7336-297e4d096a4mr65754305ad.0.1762792082779; Mon, 10 Nov 2025
 08:28:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <874ir1zxng.fsf@trenco.lwn.net>
In-Reply-To: <874ir1zxng.fsf@trenco.lwn.net>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 10 Nov 2025 17:27:48 +0100
X-Gm-Features: AWmQ_bkGZ7lpasgtIBPX75wmrrnwpcmnoNKRPRgat20Oz33yBel4ISwgnlmOOUc
Message-ID: <CANiq72==SimzoQARA5uprXs0-iKnBNS+EiKCz1L9V3K6LO1ftw@mail.gmail.com>
Subject: Re: [PATCH 00/18] `syn` support
To: Jonathan Corbet <corbet@lwn.net>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 4:59=E2=80=AFPM Jonathan Corbet <corbet@lwn.net> wr=
ote:
>
> Just in case I'm not the only ignorant person who didn't immediately
> know what "syn" is and why we might want 57,000 lines of it in the
> kernel... :)

Thanks -- I will add something like that.

It has been such a long and recurrent topic in our discussions that I
guess I was writing from inside the Rust for Linux's bubble.

Just to give a bit more context, it is the most downloaded Rust crate
(according to crates.io). It (or something like it) is essentially a
necessity for writing complex macros without too much pain.

Cheers,
Miguel
