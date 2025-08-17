Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4772A219302
	for <patches@lists.linux.dev>; Sun, 17 Aug 2025 08:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755419588; cv=none; b=CGF4ccPj1vSgEW4tYuVrVOMnVNyJzLdrz6oE3o/zxPrjL+MK5lBAvey1YHdszLlIcz7221XzWYkdKsHMXS51OC/LS1u54FVhHPcgBxShwd6rO5YF9LoW8pn7ZkjdAas7Gr7c//pr9pP8dhHJU51btaw3b+kJS7OuFg1iII9jcwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755419588; c=relaxed/simple;
	bh=9F4kZCt6EM418SfE71rTAkC9O6+5xOXqnezhdzokRY8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ckIavdWXgBeecmN2trOL4gEykG31Ym8FJr/SjskoGd0qRDkEmfycpNedDnAJ2LE2JXU4j44piwGqvOdT3k+jmZVURPn9T7jQTVNLlKFlTgcgmCXbnTCsudLIuEZCFyoDNDAbwLECnxQv0LwVtG+YAD//EgRctJVniGmoeaQLoLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=siFp4lM1; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="siFp4lM1"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b9e415a68fso3146047f8f.2
        for <patches@lists.linux.dev>; Sun, 17 Aug 2025 01:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755419585; x=1756024385; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTwTOtGwt6cJGY41AEmiyutI55TEpKyzi4qJ2ueIWhw=;
        b=siFp4lM1Mj6vUxaB9Z+ho+PUN4W/nEHsKkbOf+JWBhI1gCJV/7sEUS+SNSqqP9dHAj
         ZY7N0kJUVy4j2RNBXGLGpHOTVnp6ikvsoWKje9cBHNzQ5ADPCPhwFwZi6BvceS7JSt2F
         FLmJmiqW83JhIm6wtBDtnM72/pqWMx1oXeptoX+KwrIliZAtaJxBYirIcatHfS9JE3uT
         ZkZMfiVNRQhtXjysjdThtUXg7MUkq5GugJlVfKnqOFCJv6tlwWvTSI6KimZfkwNmN03V
         79UqUy5VbkiQ8DIAEhTXOHW6RlPSRrR2GJN+tV+WlqhcWGoTB/84BuT+Pq9vgefrLBbt
         SsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755419585; x=1756024385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hTwTOtGwt6cJGY41AEmiyutI55TEpKyzi4qJ2ueIWhw=;
        b=opbMz5cDmMIgd9CxZSeMg0uKywLeI3TcsPdtusGm+foHRepsDmBMJzhqivp+f4+J6K
         u0p42hKqGblalF0AV0ebSHK9vqj9g4UyjSQ4BbSgfpLxSsZ84e/wXre61IcRwEYiD9pe
         hdjRaB6FDXEDxCFiVEOZoXrVgkIRlot/uylI2wgFE37CtomXNuVcMWWtShfdMmt2lP87
         0w0+/2NRt0IbmyDkUL6MvVvcr54DsBxuDam0LU9R+6aXhKNmGKAetePewIMPx147qozn
         2oYH4fQpySIGc0sNEMeLRJFNiqf0i9aiAgczfm/yJnid1I8OlRZo25hUx7wr/Kty2UZQ
         pTbA==
X-Forwarded-Encrypted: i=1; AJvYcCUHb0PwGKMzehzZblOh8ewDjGdRPsg4RBYc1tc1edY9EFTXDmhYDX6OWZa8za0GZiyFT/VBWcF2@lists.linux.dev
X-Gm-Message-State: AOJu0YxUuIEmzbALS8PkSD8zS9ceilffo0wrhETPrWC5KN2l8JkGVi21
	JDEoRMLrt21AMxsDV7oCl7iPFhYvh2rhLQRVQjL8GcAzSHdauYlWXioCos5hgbcLusuFc3oi8NO
	xOxT1DfBnUQNEYGZ1XxcvvGbBv7iSp3bu55KUCAxr
X-Gm-Gg: ASbGncvoyYOVhKeg6IAeSa8odTyHaMS7RkT4LlzbqQLRuNhTquHyHOgHbS5oTF47dH3
	uLrD3rrVenNNbGOlfBNDPino6jPNPCzCzRkTGqYBPNsOvegJ7m/S/uEFYJxvMmayw9Azb/os3yR
	KK6tUDZd/DCVu/HGlxrdS8tpDyrc91K210BlAyBBDtiz42Z1kv1D+wixcPbg8EGv9ZecYcwDnSR
	P0OouvvNjiKaN+WeqEdfBGIE3NDJrTd0Ue2
X-Google-Smtp-Source: AGHT+IGoRb1xdrYrj6kHKejvqdDcCa7iTaEaP7TOTbmewwBY/XYltNC5+vB1zPlq8+D3PhMalwZdmY0KcTb1ScHU0tU=
X-Received: by 2002:a05:6000:430b:b0:3b7:9589:1fd1 with SMTP id
 ffacd0b85a97d-3bb68fdc587mr6365788f8f.44.1755419585362; Sun, 17 Aug 2025
 01:33:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250816210214.2729269-1-ojeda@kernel.org>
In-Reply-To: <20250816210214.2729269-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sun, 17 Aug 2025 10:32:53 +0200
X-Gm-Features: Ac12FXzhd2iFnnKjyXBfrCIdB6O_r4X05qYMnlTOhhEd7NQgiE9g9rzOlA9OUao
Message-ID: <CAH5fLggYHJg+PmLD=Fg2a=pO7JRmM+AqppwBqOBpp6+179YcVg@mail.gmail.com>
Subject: Re: [PATCH] rust: alloc: fix missing import needed for `rusttest`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vitaly Wool <vitaly.wool@konsulko.se>, 
	Danilo Krummrich <dakr@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Uladzislau Rezki <urezki@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 16, 2025 at 11:02=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> There is a missing import of `NumaNode` that is used in the `rusttest`
> target:
>
>     error[E0412]: cannot find type `NumaNode` in this scope
>       --> rust/kernel/alloc/allocator_test.rs:43:15
>        |
>     43 |         _nid: NumaNode,
>        |               ^^^^^^^^ not found in this scope
>        |
>     help: consider importing this struct
>        |
>     12 + use crate::alloc::NumaNode;
>        |
>
> Thus fix it by adding it.
>
> Fixes: 8405eafa6e94 ("rust: add support for NUMA ids in allocations")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Acked-by: Alice Ryhl <aliceryhl@google.com>
