Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAA9303A39
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 13:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762780990; cv=none; b=ZNPgohc8F4AK/cKxJdFs2WGBRLnZh/uJUX3h8872W+HHVmhfFW2GfaJ3T5gF/bovEcxAFXcHK0erxUmdp0ikZDvE1ift9loAWTHtfXzAYy3jTbynYmXz8Eo0xkb1OtMztMoY2+XOzN5q+UqJZPxF0MRQwM7gPst8R+Sa6BOxouo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762780990; c=relaxed/simple;
	bh=C3acuH7QCQn6p/xm12ErSwRFYfxoFjG9C3ZXOi4OU58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dqDwi5wZMUDBZpsDufE4dPokSGi/unTOBLlr020ysq0GKq62pMrmMZZKx5f2jjyOcVK3J+xwceTzVS1sPOrGG5ZRIJ4nhAfnaSRXBxPCSwG0Sl3XO+gRa7+sAeoCIMiUaF98WRbNPSRDHgOVYZIwf5Xs+EIlM6CbdQkp+Hd5mYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cdHMbBZz; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cdHMbBZz"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-297ec8a6418so2658105ad.1
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 05:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762780987; x=1763385787; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C3acuH7QCQn6p/xm12ErSwRFYfxoFjG9C3ZXOi4OU58=;
        b=cdHMbBZzbpPQTpV9+xbHCuFdXM8Gs/lDOzB8B8T5Cj6xfX+owcu5aUXm8Wu0bGYZu4
         e6FhMbEyuIjW84MaoeWHAGiNB4enXXcSdItI051muL+ImtdKp+hojoIefksJe5hkNcGI
         qg9xwvMqp9JGSJp5kweZRuy5TySVFAWL7B7LH1qyf/16B+PUzzj/aMuAUClnBZOKxcGz
         gv0bmlJbo152a6ceyjJS+KfsTi99dgMXoCKbd9lDVSTrbhQC9R/B4+V2FM8Aajae3XxW
         fmoDmfeO+py3joQFzf9IiyABdXFGnpoxXbJUI71yxybCQNuzFALFENdInVRBJfSUa/BD
         Mscw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762780987; x=1763385787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C3acuH7QCQn6p/xm12ErSwRFYfxoFjG9C3ZXOi4OU58=;
        b=eZifcSZ+wO8twb8emOKAVk1kgYQHiqP41DcEzYGjDdm12OsZuwUP6pvc8J3y7uvJ1B
         xQQ5SZaf2vmlR2IYPraAuHtVe0+JbNJW+beATChL/UQoKcUAKuC+xXaciJgeGupkCqMZ
         LLeeCeKHW1fOM9+u5AFRln1rugXdk8x0NviIlOTRNh3aTbC2jNoKKieHWHFFCXiCbj6P
         bSjql/Zs7ojleYW0M4z4zGQznInVnjTSm/DigSSrJYfhXqzAkfky0Vdg5rUiB5EZLoKD
         fmwDMek27b1og7mzZHub75t3lFM8RQZ5rhKPaP3qyX68PdMC1pkpk0mH06EzZYM9MM0D
         pzMw==
X-Forwarded-Encrypted: i=1; AJvYcCVFfxGYSfrVxObDZuVGg6rhsSHNo5fuECTILO7gPDZYTzqK5l0t3jtqRSSoNQSF7UbvB6PZlOB0@lists.linux.dev
X-Gm-Message-State: AOJu0YwR2r2FIdJdesM1Hllf1ZI8bB5mQfYJpabngHk7e11HXNLovQkL
	z93Hy9Cl3sWIjrXsfWZCtcFXfuidEBxPK0HnT/V3LeRAkDIggD3Hl95/qN/K0RM67EV3ZxAVF6o
	dW+IXOIt55qd2kULTfRPm19EoOEElGiU=
X-Gm-Gg: ASbGncvNc0xqpnnhudQebN0n1V81Te94AoEjUBMQ7QKK0ofIoBtYN83lHpXot0Zshuw
	n4faruRalFDYgQATeAVMfUTJNyfYuv/hA9Zm5lOGj3LaOel6VyTSXNFAuUJsENJtEesvlKEBpNa
	4M3UBSInjLCiZ2ol4u7EHRuV3V2I8ZMathlalrGS9lQEzJmH5Kafc41D0bDJAuuK4kmV3v8SmiG
	Bdcfo2MWT7t4QKqhPOgxcO62kYnd6SQlxF/sIii6K0qx+WiuniwyAJUi+8a5Z074wBoamGL75MO
	dC4cYBuQHrkrvJPUfP7AjnUjc2vSwd1rUduHIAgiQ0lbclOk3KNQCUf9i4JbpMCFYlncMwt1vxt
	N60s=
X-Google-Smtp-Source: AGHT+IHgHDi3q6OyQUJsolTQIPR9Fj/+81SVNx0MCb8IGd9foxsR78ymwzqgxKrlTwxxt2S941IeTNAE2DlJ0icIPNk=
X-Received: by 2002:a17:902:e809:b0:297:f2a0:fad6 with SMTP id
 d9443c01a7336-297f2a0fc40mr54637915ad.9.1762780986630; Mon, 10 Nov 2025
 05:23:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-14-ojeda@kernel.org>
 <aRHQA6FEoxACerIQ@google.com> <20251110131326.309545df@eugeo>
In-Reply-To: <20251110131326.309545df@eugeo>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 10 Nov 2025 14:22:53 +0100
X-Gm-Features: AWmQ_blPKQ1VNfZu1Ux9YpaOP8DxeSL_ehdyoNT5qQqWUnszwlBjdrKVMppjRig
Message-ID: <CANiq72nkjWbtEktSU_TrEfY2Agy7FK0-OLBWPLqTvp_p-CkBUg@mail.gmail.com>
Subject: Re: [PATCH 13/18] rust: quote: enable support in kbuild
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

On Mon, Nov 10, 2025 at 2:13=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>
> This is to be able to skip over edition flags for `quote` when building
> the rusttestlib?

Yes, it is needed to support skipping the flags, which isn't needed
until this patch.

It can be done earlier separately since it doesn't hurt -- a simpler
option is just to mention it here in the log.

Cheers,
Miguel
