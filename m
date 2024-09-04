Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29371DB94D
	for <patches@lists.linux.dev>; Wed,  4 Sep 2024 14:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725461519; cv=none; b=cf2ir+tFoKivL9vmJ0yGvLDlklRfUP0U22O7MHyLD9NI5FZSCgwlBvbWwyhqxvyUl7adtKER6TMpBP2iae8d68mNnfM+WXq2+HtPoSIXAbh9+5jcB2KBXf91Of2p6kjZaNVhhKAF1EotNtQ0Vbptl0LEPiDh+MjCEBLMJS6d5AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725461519; c=relaxed/simple;
	bh=fTcMzEM3kY2M4Wu7inQydguZGW3DdMh82Z4JBMmoWbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oemNxjAJthektz9wZX7H7dmJezkUlAOPh1YePEx2fllOvv7qFDXL2+I1HsHbmkfy2IaWMboONHKSY0fCIFjaTC2kGSpChC7uR7f6c/hzvTfSulNv8opD3mpvzdusTjODZcIX4dJMM1u3vh+m1BeeKkSsd3wzeqy1eTFPz3Hb9JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M6dCAjw9; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M6dCAjw9"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-374c8cef906so2407408f8f.2
        for <patches@lists.linux.dev>; Wed, 04 Sep 2024 07:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725461516; x=1726066316; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTcMzEM3kY2M4Wu7inQydguZGW3DdMh82Z4JBMmoWbs=;
        b=M6dCAjw9fIv8iv/iJbvXThTCF4nxMKXTac5yrt7//yYOiSgKeMxe2b1l1vQD77VXzg
         /cS6+otZaLE1imDdazZtem5HBfSPW1sbkocNyTOzvySgFAiwoUuz+ynp56B5PvAw1m6t
         o6Ny9OKXlnJ57Md5Hfg9gMv21iAcoFzINYYIRSQJtNxcsVT+RhWBYyf/s7OB5bsEcpIE
         DOVS3I4SUImc2clzy/SzM+/GkTkWxT2lqhuVdAHeY+SMxj77mQWtkLC01siY/NrRHuVW
         kDYeTy/KpzaGa8+mI1F/8TWvtYeD5NrWfBEkn8ovuJDQnThEoeMEMHr51E3pHxkliW+8
         Zweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725461516; x=1726066316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fTcMzEM3kY2M4Wu7inQydguZGW3DdMh82Z4JBMmoWbs=;
        b=TA22EqH3x1jCGZlI598uNweJQkxbPX9K+0U2aTSXeIEQ6unHjPYDLoXUxqibfAD9aA
         r/ArF+596yVCDodDSfSK0WXe7g39dNAgWwc6cmPcolnSnjrhiaXBYiPKP0sMBu0yZQn8
         qMpN04t7K9ONvlWQ2L5Sn/o+nP12fBu9skwVWnakvFHq8IF7Gop+czxIotskONB2HAiJ
         qUoSFDcjMCWKZuYP5+KedyrVcezDr8P6mEnKuVv7axM0yJ6t9dIPSIN8W3aA5/kyMNtZ
         cfskO6uJJzUkM8Gk0QqDYzIY6uuFG3RFG4Twq8lcjVsFixqEuFuCe1eFfzzFIERwK+sG
         RYkA==
X-Forwarded-Encrypted: i=1; AJvYcCWqZhY835M9H31KVFxVaYNTnodSAIlZ2GykQE2eAQv+TxPE/Ow1gGZDwrxXRastkkGea/7OchUo@lists.linux.dev
X-Gm-Message-State: AOJu0YxGq5Bd+l7yT9rL/BmWIUJjeXSFu+imRwXWwHe9NxbL7hlrKUPA
	KLsdSzktv49qJR7p1/ljp6sjreanz8TJfd87pvelcJo435ORKWID5+j05vO/7CTbXPM+lMqpe+E
	5yAAkTSxR+fcMzlDF8gBC+VkyzK0hWkWKe1ar
X-Google-Smtp-Source: AGHT+IFXPAh2KSM2xuEfDScmUTQ5Z1aIkAVoWtDzFq1bPY0Emcyx6SFJqfvHty1VlGwlCi7nvRts08h8nqWzteKFlg4=
X-Received: by 2002:a5d:514c:0:b0:374:bdd7:f848 with SMTP id
 ffacd0b85a97d-376df0055acmr3106240f8f.59.1725461515451; Wed, 04 Sep 2024
 07:51:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904144229.18592-1-ojeda@kernel.org>
In-Reply-To: <20240904144229.18592-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 4 Sep 2024 16:51:42 +0200
Message-ID: <CAH5fLgizixTZ8nytkSzSLA67+f=zWZZKt8xTJ2BQg5K0ivAAmQ@mail.gmail.com>
Subject: Re: [PATCH] rust: avoid `box_uninit_write` feature
To: Miguel Ojeda <ojeda@kernel.org>, Matt Gilbride <mattgilbride@google.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:43=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Like commit 0903b9e2a46c ("rust: alloc: eschew
> `Box<MaybeUninit<T>>::write`"), but for the new `rbtree` and `alloc` code=
.
>
> That is, `feature(new_uninit)` [1] got partially stabilized [2]
> for Rust 1.82.0 (expected to be released on 2024-10-17), but it
> did not include `Box<MaybeUninit<T>>::write`, which got split into
> `feature(box_uninit_write)` [3].
>
> To avoid relying on a new unstable feature, rewrite the `write` +
> `assume_init` pair manually.
>
> Link: https://github.com/rust-lang/rust/issues/63291 [1]
> Link: https://github.com/rust-lang/rust/pull/129401 [2]
> Link: https://github.com/rust-lang/rust/issues/129397 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Good catch!

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
