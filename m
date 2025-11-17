Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A4734C9AF
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 21:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763413382; cv=none; b=oX1AKM5Ytht8BbpzZDgvjqNSwKKSF1mD3u4Vq5q1S5CkQXRA8twD7v2kTYLEtLwPxhSj9Sju3ESPpVEU1TMrNvxwdcL2OwYKDyQ9bqR1ChRIyakKO7CqZZ7Xe9PpccfbGTtvsLK4+UWDjVxuvv9f4SVPy8Tf0YsyM09xk3np8Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763413382; c=relaxed/simple;
	bh=iP6TspFv6C7dt+qkcsFWTPUOXmBMAp/00Ut2BHL86o4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LT6YWauqpeOFJDbWbj5RAkdwuhmhYEcnVh+vjvTSig9CnrgtyFroUycuLGYfIaD3wHA2oXOPkMv491vq8aBEeZtB9F0DHcmncVHfXDTVHzw4ldPuPOmn2ihaQFEtkicQdZrVXEJrC37L39fwsyiX2oQU/WDJZgwuKSJYWy0yMQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BqWR0805; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BqWR0805"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34384760ce1so889939a91.0
        for <patches@lists.linux.dev>; Mon, 17 Nov 2025 13:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763413380; x=1764018180; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iP6TspFv6C7dt+qkcsFWTPUOXmBMAp/00Ut2BHL86o4=;
        b=BqWR08052RdVtO5V5imKdcennJ5GuCCsB/Kajto6A2no1uG+UEuiWw4ZBc7UTMuFuv
         BnJJAsKafsdR08oeN56+3naFe/tNvkrls2EoELz05BTl3atnYroYRw0boIzd0IxFeVJC
         JH25UrmaHV+YvZHWL3Ci//0NuhqMbA1b2IpGrjBBroWXVIkLTfQ4xoNMinoXRcU17o5N
         BSuJDoq3nJ7qBhmVCZeHl4ELvKn1vLXmxcYF0aufzW7SLeiVtmLBHkKbsdIE09NZn8OB
         EVcbn3tYmVQQQUFjngSZ1HjJA+nFvYIAvyKpI560E08qJ54ugwdRH2Ke1+3BuI9joP8D
         Rhgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763413380; x=1764018180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iP6TspFv6C7dt+qkcsFWTPUOXmBMAp/00Ut2BHL86o4=;
        b=dLMxQ+dOqyA8i/SepSm8Gza31bPwADVb5lxlC4sCWW/X8VQxnWgVcTEOsV0X3Fauh5
         yEFwsNDVqWP/ZKJhBp0YX1hy9pq9xmEXFYd4QrRQniaa2PT6JviKksKzQMHGzTxo8bta
         aLYbcUHrhd7/O1NyEQJ8ypgQCCxaaqQY/hxcswLDhAsH5LVG5rM5NEQE76uI4rVc29R0
         sggJwomltJpcawZnFqZPiH04mOJv6vLFUmLQUbqXhEXARpA58oEMNK7buqoyphBVcYI8
         FJG/ZL+BQZslH5aaWNz5sBJ4PUfLeD0CP/IM9tTJKOvJm4p7WdRDctjgusGG4Dy8HfIz
         qjZA==
X-Forwarded-Encrypted: i=1; AJvYcCXLd2tUoIN6a32Zw22VYKECfowmBMINWFDSEimji7LSyqocqXxTGuVzDdCN4X5rBvHdqQQSvZaX@lists.linux.dev
X-Gm-Message-State: AOJu0YzfJc87hX4anLFjw3cNsb8IumbPEnakOl7bHtbWuIXcLPBh+JzR
	9Bp0ZW6ZYX4F0TOV1yszJZHXePSG4VTYhIfGgsOauBRJypc0wzexhLQIBv2hQgdDLhw2krrA/Ge
	+Et+Fu7wuQ5BpMfY1dxoMV3hfRh5DxnI=
X-Gm-Gg: ASbGncs/spQ16vZiHq24WMO1/hCqSJGuqTQGqyUsAStoE972BS/BZd37eQdF3CGi0IJ
	gK4uO2u4T2yvNolW76DSmWo4E9W9DvGpGSi8At0aVNaiZYEBsFzwtBJgLJVnFflDd/AuGd2177O
	IggysmQVMw0eIXqEwJnR94pp68IvlNPZQEZdm5VAw/frOWJ321Yqu0F4fx7TpFaMIufHoSZ+kdd
	LwpfGo6XJXCgCg0H5QM3isYzRrw1eNe4eLk15K9uTqI0Ce+FsC1V5cD7ux4DpNhQq+TiPLwfSEn
	KFaxAzatBZFoKhKsEjRKFU3+Y+XD9TZe2g8LnWS1qSU+q3pp8Ww38Iw+km2fVnqnmKYmPRGkWe+
	/kurGLINIgwoNLw==
X-Google-Smtp-Source: AGHT+IGlfQGUdtSox02ATWkbxSbcf1jC5YZXySUNyLmlrEZvBMimdky+/XqX+bymvXPFrGG75BWC3U7j6V3cT8HAU7U=
X-Received: by 2002:a05:7022:310:b0:11b:98e8:624e with SMTP id
 a92af1059eb24-11c796b9796mr80353c88.4.1763413380425; Mon, 17 Nov 2025
 13:03:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117080714.876978-1-ojeda@kernel.org>
In-Reply-To: <20251117080714.876978-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 17 Nov 2025 22:02:48 +0100
X-Gm-Features: AWmQ_bkVH0zwZmTGtxY2a6yQt4iofNRpnQgdcxIiUj_oO7rEMvoYnw_JJyWw_ro
Message-ID: <CANiq72=-w2p8sQgUKYgPG3Tx9GSUNgcVUp24k0ck2RqYgupCVg@mail.gmail.com>
Subject: Re: [PATCH] rust: allow `clippy::disallowed_names` for doctests
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Benno Lossin <lossin@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	rust-for-linux@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Rae Moar <raemoar63@gmail.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 9:07=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Examples (i.e. doctests) may want to use names such as `foo`, thus the
> `clippy::disallowed_names` lint gets in the way.
>
> Thus allow it for all doctests.
>
> In addition, remove it from the existing `expect`s we have in a few
> doctests.
>
> This does not mean that we should stop trying to find good names for
> our examples, though.
>
> Suggested-by: Alice Ryhl <aliceryhl@google.com>
> Link: https://lore.kernel.org/rust-for-linux/aRHSLChi5HYXW4-9@google.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
