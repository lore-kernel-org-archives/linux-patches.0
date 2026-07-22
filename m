Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B08386C31
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 07:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704788; cv=pass; b=GjmI1WNWUrctfcB+/qG2wSauAwFOvQ8LSInN0DKlPokT6qm+uXHNJ7jUKj9WTDR19GxTz/72xS7S+egr7QCGRo1h7NwJQ1Tx0QMcS97Z7Y+YRVR7PMz+3ASFvQyYlzGVW3KNSOAozK4ULUUGtTlsH08XPLk8k+2Qlgp8KKrC/+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704788; c=relaxed/simple;
	bh=4zThSNHzxYD+okwWzZg9aALuGq5zqrVRtzbLGFKtg2E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R5BeKMT4jyIuvpHdaXoOqET2nsmHk20VJbehNz6bJpPbYfWvZ1+9TpXphXf/NwTWoOmEMJZaFE/x2zXFnQWjenD9LSKEzUxQuPX1ZohI7Mp0EvDJtDj/G/EOw0FAR25asCbnC2E/SjaQg3GX/mg9enUjwZ7cQ5Xr1COWQoM7It8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ovmYhdH8; arc=pass smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ovmYhdH8"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3860f32307bso1930967a91.0
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 00:19:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784704787; cv=none;
        d=google.com; s=arc-20260327;
        b=EkXJHZLY0vLS2msJeOP1Rhta0Pd2f5CX7hvCCdlnh5NCCt37prV3lYegQnNdpcUkv/
         w6qn+0mtdDd/zbMRa6VEeDdlwthXGRdobEQ1Y59Ikvdeau9WmZ9uKH+o566IzYJHYQvD
         rp53O8a7920bfeHE0qAuAQCGvTWAj3erOgpBko5QUOQpTMx5xQK62nZC3glz2PF/v9bx
         k2oXZyH9smrs8uLZIR8cxK5g2was5ILeliErauznxs8AcI/G/+WrA1rPBk2fUXy9Nwkn
         rLwWCYYk7oSPjFJsEBaV07+9hSbCZlaVOSkO0UK/fyeS19HZ34SyttLrK0s/0BO5HteG
         TZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o3kLMI1ggHSuNQyv11Yct6G+erBFb60cEs2tdiP33S8=;
        fh=7VHtyjoaeEyVm1UsOQzFLzIDtdBgap5RQ2s7+EQYOu0=;
        b=BuXuEgWLBhkpWny8HWMrFCKhLmXywjb6TdMvA4ffbW8FvP65sf3NdzTV635kC9S0vD
         X2YPfuV9VfTNxutwvliofCr/IxAqkvf5Wfw1vFzDidFQQTI1mDh50c6NUE0bbI4jHqHq
         4zcaHykjdKo1f/z+SihIcCqwQ8CqvYJTDG3DLhQ9mxQiymm5Kgip5i9yGM+/gXkRR1RD
         PLuu7cFAG/kENL3uq8QdtSBlq14k6zyxptOnFdijY7sZegXLSW7E/tCskEElSaORP5mD
         3QhJ4/zdVboB67V61rFaI/pVr3RXDbuUrvRMt80fm4CIHG8beDEHXJSj/ZVACoYsA6nM
         vapQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784704787; x=1785309587; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o3kLMI1ggHSuNQyv11Yct6G+erBFb60cEs2tdiP33S8=;
        b=ovmYhdH8/j5GAqgN4sYjWF8lPQQlRjm8Lg16KpdFcVsGjrU1Awgcxkgp3j/vKrMINq
         XO0JaQNgJdG5aGq8fUr2kNiWdTWYVsB87z5dmvXGI/52IeaQcErTir1OkzoDro8r47d6
         eu2MUnl3oXEr1icy2pkzCTmNW+SMb226RKacPTvBjbwnsaHz3lyaQQIJtsIalNrVgdRo
         rGSb7/QJyfVcDi0Uc2s6NiMVSKuo81Ee1KtOe8gykhS1K7f5V62IA5gGXkFZW3Q7I2ui
         3mXacQDV1CHc3sIvpkA1Jk2p+914PKegvukVdBEBmKCY0O6JM/cQo1DpA+7L+Yn+rHuz
         Eyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784704787; x=1785309587;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o3kLMI1ggHSuNQyv11Yct6G+erBFb60cEs2tdiP33S8=;
        b=rPFqbVrfjaq1529KFxz6TuXoo3FvKcF2ROipF/9mvAOqcHboMOkDYzhJhCbPs7zE/D
         wwUVdptYIB/uFR+a2Q/ZB8eVzdWmascOn4Qod6TrUntgl3+ByaV9EV44OOpKj3iCJx2k
         Bmt+mtpZ2GG0I1UX0X5HV5wqf28ApEYlMjwa4HuvJhzgF/oIk+95GEiM6lM5quarQ59y
         gmTr94GMjYbT2PIIfqMRW6gASmJm2Veo8Z4iiN1STU7xBv9gmkmsjlNnlIQD16kPVLvN
         mfqmSb4hhnfMcX1kDK4vYfZ1eeAXH++I1PEY8Pm9GdGpOmU380Q5pfx7fztP/pxuExBV
         /JCg==
X-Forwarded-Encrypted: i=1; AHgh+Rrfz0a6HFy/WBd8AZIDJ7akFsiZ0aBHZCKmu8BH15lTrBz9RbDzNxnJcgvqS7edqmnfmuOWVXfU@lists.linux.dev
X-Gm-Message-State: AOJu0Yzx+LrtQLzKX4UcXvzjsThKKIpXg12U3LoVXl3JdfiiU0lgNr+j
	0ehlMmcL2OX7ewU9Wh0FjHN2rxktRFXYUIgQc2ufFMrp4r/8rOqGrV4DcBW3rtnQdXUuLddOPbv
	qnDkSUaidCAGKAUnogBPonWSBB8g6Ly6LCecObaE=
X-Gm-Gg: AR+sD10BSMMB+WXKCgg+wFDuw3C41QPWtoy8LxJ2ouSD6+utvyAesDofT2k8WIuvPFS
	X9q1qf4h37+CThZcN54RObH32ltpw0wzzgTarQZWSHpaPNX5XUY8wnXXgrYyyTZ+XeePJcOssya
	u9JVBgziWxSC3c3izi9R9iQFDudptQ3AFgjhR0c13adG4X9nASY9DCLGVrAsbUb6xPqXYnxNWlC
	eoPBzT/UkF1y6iQntkUJ5ACD6TIlwpZiuXi9h2LevwaAuiHw4lScQB+0Qd8pYAmXdeEeHEin+Q6
	VJYcQ+lvj0oj9yFkaNvmPuA/ELLToqp+SkBtO7tNTzDc3NPlrse/gTYSrrtJGAcMkwLa8/WrJTg
	87ER+OphaubsF
X-Received: by 2002:a17:90a:e7c1:b0:37f:e7e7:ad1 with SMTP id
 98e67ed59e1d1-38e92a46742mr4531515a91.5.1784704786586; Wed, 22 Jul 2026
 00:19:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260721152441.786066624@linuxfoundation.org> <20260721152443.212105076@linuxfoundation.org>
 <CAH5fLgh=6eOcsUpBODZmyhQnZ0eqDfY12MkmA20w2JmgxJ3wiQ@mail.gmail.com>
In-Reply-To: <CAH5fLgh=6eOcsUpBODZmyhQnZ0eqDfY12MkmA20w2JmgxJ3wiQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 22 Jul 2026 09:19:33 +0200
X-Gm-Features: AUfX_mzu6_9BMnuLdA9zaU6lvCr1vaDjIaZa_hixp4hYnmzw8j4YHJhB5m5ABiI
Message-ID: <CANiq72=G_TpX6Qjeo9ZAkQX7oVjtMSkw5arjepFOW3_7GSv+5g@mail.gmail.com>
Subject: Re: [PATCH 6.6 0063/1266] rust: Kbuild: set frame-pointer llvm module
 flag for CONFIG_FRAME_POINTER
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 8:22=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> We shouldn't backport this to 6.6 because -Zllvm_module_flag does not
> exist on the rustc version used by the 6.6. kernel.

Yeah -- please see the instruction above:

  # 6.12.y and later (flag not available in pinned Rust in older LTSs).

More details I wrote back then at:

  https://lore.kernel.org/all/CANiq72kek9NoFe2PCFnND1p6BRbuzgv6kT2o5jw09sWg=
+wau_Q@mail.gmail.com/

Cheers,
Miguel
