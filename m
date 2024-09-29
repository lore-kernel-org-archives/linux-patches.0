Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F6D1F951
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727583670; cv=none; b=sVAgWas+DyF25/yBjcmrC+OM6wOJqZoxE1oTIB2Lgceuco5Rqe6wvA4XNfOTDFRD/8mTKASGdERZnWpA8WZUPxroBN70fmcawHGKZsASnMP4r9w2TiMMhvufE9r6zFMZrm5aOJve1YK+ctgMbc5VFsAYNmjAUEvFmT+TUBRClHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727583670; c=relaxed/simple;
	bh=pHVoxB91LNUpLKS+bFIZR71Nc4XMjyS1YH9Of4Peg3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tunVKJY81p1xoSd3HQAKQyEpSxzJnUDnCrs4ogirhalFj3GtKBhj+/IxavzMUCCg+kWIkQB5iofVaiBdGGQ8fCajnL2NF8wKKNYTWkhfvsYMQvNTwr4+8QCPjPC33mCFEBzdJtVp7R5OibfURZGzpvaPlQCxrjD7tVRIxyibrFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=omUGi+o7; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="omUGi+o7"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6e25f3748e0so4521437b3.0
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727583668; x=1728188468; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pHVoxB91LNUpLKS+bFIZR71Nc4XMjyS1YH9Of4Peg3o=;
        b=omUGi+o72vFb/QJwD1tcgHQ/Cj/Sko+CoslolEwYlrLnQJQoGTsBJHVwbypGAjX0zn
         TJrpGQFr6OPOyxuJUrbAK90R+ttLbwLunxotNAyKjxMrH+XqihkzsHfPWL2AZEEXWFdx
         wPDD608rqk+S7A6uoKJuwGcgcn1Hhg9eVUdFLsGGCh5gBB9fnzD/2j02m+EaFUc3MQoY
         bQSQNWOxXUG96D+cpSgI7XDkboiwReM3sAx9XLDBHC1VRhSQoKOKNjZB4kVXkc5pd426
         kqezo52fMCZJ6VKnviUzKknPB85RMY44BNalLu6Ra86Xf1W7ktXkRIlVg8+AsBfcXgi3
         i39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727583668; x=1728188468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pHVoxB91LNUpLKS+bFIZR71Nc4XMjyS1YH9Of4Peg3o=;
        b=Oe7MyR0UYW31/WX3r+OHNeY3aIeC+hujGxlATDDiS7lWrwpsUTYcB4mndIqyoiLpdp
         dtXVEBVAm1yFX46KCTNbN+pqSCiPveEMPHr/O0tEC5qzbneeJGXU8fzaRl9GIDqKJUZK
         ipNCucHB6U2zXaQFhOL9YVTGKWrrln71p68g98eBkNlRj2jcmAx0+hT4H0RNslhuvhIi
         VGFWXej5hlfoCaptwGCtdOpJMNAlzxohIJEqxIt+VsLyYvTtR/qB5ETrkuuNSd/IY0Tw
         GaLBhNl1OT4gOzTSz5+SuGL8HFwjx/tE6289mCcVir/qGF9GrihuHIIsU1HBLvTdA49v
         gTnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCAOx7v2eaWqcwQZARFSR7GuJYFlyHvyjf32nrkD/M1bXJNRT4nK9GJuEUm7vdbYY9XWyxE+lt@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1IdX19xBX0/la+xlOMjz2nd4LqJO+WK0rl1rp4eQaj/ULcjrM
	yuM5KAYNGh2tm6p1nFbuiN15tfwA11QH9ufay42zP9lRijjVjfosdSX4TdaAW5tgwNO5K9vMTIv
	iTXgyrmzbpHgAbAwa7sDqk5FZeZxnYbRiLxfO9w==
X-Google-Smtp-Source: AGHT+IFcGTqHY7ozyyABT+lA6IrUxrrq8O1OudXtxS0Ccg/+2lxmPPRsG2ROBTXVmUmB9im75BbjPDh1s/kAip3anI0=
X-Received: by 2002:a05:690c:dc6:b0:6b7:a7b3:8d94 with SMTP id
 00721157ae682-6e2474f4703mr63064527b3.6.1727583667787; Sat, 28 Sep 2024
 21:21:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-4-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-4-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:20:57 -0400
Message-ID: <CALNs47sFE+mgkVL6_mXwuW_LRCT+UMO85ZDWdSYRkgqVk-QfPw@mail.gmail.com>
Subject: Re: [PATCH 03/19] rust: types: avoid repetition in `{As,From}Bytes` impls
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> In order to provide `// SAFETY` comments for every `unsafe impl`, we woul=
d
> need to repeat them, which is not very useful and would be harder to read=
.
>
> We could perhaps allow the lint (ideally within a small module), but we
> can take the chance to avoid the repetition of the `impl`s themselves
> too by using a small local macro, like in other places where we have
> had to do this sort of thing.
>
> Thus add the straightforward `impl_{from,as}bytes!` macros and use them
> to implement `FromBytes`.
>
> This, in turn, will allow us in the next patch to place a `// SAFETY`
> comment that defers to the actual invocation of the macro.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
