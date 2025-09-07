Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8761E2823
	for <patches@lists.linux.dev>; Sun,  7 Sep 2025 22:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757284271; cv=none; b=Z3VzP0OJlwDBArZB6GH1CjQf0YhkLnFmSX+GV2t2Bba7BsRDPffOoI7VclI2MSkoQfeWru4+1ymlaSiF8CKuje8rIIG0yIU3l9uawIm1BOYTscmUR4tu34GBljpZ7/Q95KD06+Fk2egID8eYopwMBj7bx1AfZRWIhis9KcggqMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757284271; c=relaxed/simple;
	bh=CSFBlBtDLQ60LZNRpaUXVbkiMpIx+cA4r6gRvNosVrw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UKjAe2cVawHX2DoXYdYCN6QdycfvO4+9qdHVeUF9y+naC4mAlouy7jVQCN8TC7Pjr4Xl5jYNOWI2CPD+5qkMV9JkHfuUXOPRaqnllwcBKGr8pUnEiz12QdqTih9Dhn18l6GHTw5qzJPSZ1UfFCMjJnaUX8bjQXf2BspuE7stsog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S3fMNdi3; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S3fMNdi3"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-24aacdf40a2so10447315ad.1
        for <patches@lists.linux.dev>; Sun, 07 Sep 2025 15:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757284270; x=1757889070; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9bPu15Z4/dThW5eomvhcfyNbJrTtij67l4baLOyMhc=;
        b=S3fMNdi3t9VBli5A1XmCkML4uGKBMsV52YgyJkLQEb+PkG28HXqkbbCkM3mB4Ezb7b
         MTLrT/g+Puwk3dXIVUMwBYyJ0WHrfX++vnJxkqrdtPnzw5PZ4VtZSRQ0LBXkR7K4HtP5
         dyGGu91dFxvhAtqft2yi/c2D1QwkjvP8fQTQnvaaQ1ytbhH+v4LuGzmW6o+x6/ZLYUcC
         Kc/nSXasjs9vrI7pKQ3nO/6p8/1JxHCAKYNVnOgqZcP1or/MdcvcQv1HaaE5NMkZp7vb
         frbp9i65TKBClYv38Met5N8g/BpUfUMZxy8nVTO37jwE/Bzit3ca8fzbh8XV9QcToGtN
         SiIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757284270; x=1757889070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g9bPu15Z4/dThW5eomvhcfyNbJrTtij67l4baLOyMhc=;
        b=UZ/kLaBq+AsVg32Tpcg5PBeyaUQBtYo8b9Zt6KVd8D5BnTWoJHmHfHjq5yNSrKpALE
         lVBOXsUz9Mc9wTv2bl8RZMLzUC6Gs0zHMG6LbBPEBEmyjcbWu5f2fpm0PE7poBBUWj2R
         nUdK19jX5PYaSJzoBIYlMegrpxvDQH3itSPxtupeNA+Xq5nG6lrKMXpmCNumlZ5Zj+m1
         K6tQO5qKGpsD5yxTHqyqtWbcRcS1oyUtE4+6o/cF/nTs11W+6sTV6MUJ0bfVBpMJV/qC
         nTuMHNnJtqks7zAqVIvvZpDhf2CXxnh5M2guuybMMrhIuwhDZPadONGLvZv/V3/fzq7B
         6kMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCPskKEQ+J0QhdvzamOuef+9bYGKuebN3XSPGEApxkqsC9GKQ6qpy2LxlEZNSB4Ld5SEKY9kGE@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3XFlZv8JshgtQixQMTc0xMkTjUnpVbnTnxHK42voZWL0l0bFO
	hS94CLCunBC0L0yqE6G6reAGQRQRk7d3joa8+3ynAn2bprRcSNwQ8lWmtC4pAmhvS9Ngww9g2qE
	GY3Ct/+vXUlIDwrGb49SmGXiWkVA1CBs=
X-Gm-Gg: ASbGnctZTvzv4EyB5VjjIjRDIpvIMzj5XPqVrKDkGBir86wOjOdLsKbg2aqbgyfDDyB
	KyJ9CnoPFnbt8iCgG1oFBKrt1c3SGaT+EVjZpjB9YiXijf6lbbXLm+Udq3rrhyc15W0sF2pZ8Io
	z3qrcVJoMDY9QL1iY7EuBiWaUYBPhp69z3tryXBp3XSX0GAxLHuMkWjn5UdW6t3jibRdVpaViu9
	Bb5ABFh2iHcNxyiJUt7KV5g/Rr2T5s76GqUBqhOPdH6Zi3wAL2iJibAY6zcYHNv6hShajorKPHB
	9T+gg+QXba0uhWdCGoDMuRuZ//IIpFtndMaShEMZXabDNTQ=
X-Google-Smtp-Source: AGHT+IEj4AVClx0YLlxE3BvIdWOpSMLw0zkdrNVU6iMlzQLJXUNXJO8RnxcSaBFanH1/GPk0Wy3TwbgoCxNXplP3A44=
X-Received: by 2002:a17:902:d4c4:b0:24c:cfcd:7356 with SMTP id
 d9443c01a7336-251663b6f4emr41816155ad.0.1757284269623; Sun, 07 Sep 2025
 15:31:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250801161752.443431-1-ojeda@kernel.org>
In-Reply-To: <20250801161752.443431-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 8 Sep 2025 00:30:57 +0200
X-Gm-Features: AS18NWA5OqPbW63AgbnzQJKJXtbFL3DAUQrImPSTwrtiRAD94szVxKKASywRaM8
Message-ID: <CANiq72myxAFJbKYaxsuf1PmRQetEct=3yqeJ2sqNkJROT1CQaw@mail.gmail.com>
Subject: Re: [PATCH] rust: prelude: re-export `core::mem::{align,size}_of{,_val}`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 1, 2025 at 6:18=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Rust 1.80.0 added:
>
>     align_of
>     align_of_val
>     size_of
>     size_of_val
>
> from `core::mem` to the prelude [1].
>
> For similar reasons, and to minimize potential confusion when code may
> work in later versions but not in our current minimum, add it to our
> prelude too.
>
> Link: https://github.com/rust-lang/rust/pull/123168 [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72kOLYR2A95o0ji2mDmEqOK=
h9e9_60zZKmgF=3DvZmsW6DRg@mail.gmail.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
