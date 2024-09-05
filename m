Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B74193070
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523457; cv=none; b=b2NllvvTgEKXqGDkCS/Q8D/gSrBgapL2xGecocD6/h5fxa2geGzGzMGNQhzD450g6ttA5vPgRI23A+H5QfUdrXAzBJFmsyYB4zogdeK3vrT4Ik7Xl62j84blOJhHQGX6q6M0RhhBb0DmMja2glkUDUk4RlRFYLTwa63gCoXXbfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523457; c=relaxed/simple;
	bh=2pLfpYslB2ZuYauJSQQHIlJZPnMxW6xOF3LASls58OE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CIy58/iBy0p4PiPAJRwKbHQ1Z+MGl/+o32791Pcexz6JLIOJlG2UjS7pESfBanEItFCrUPCUpxqTcu7RjUGajPtYSUD3R/KDCm8NsmRmtM4g40aHW90PrRUqHuAfUGUfbWewGyveHM8YhPd8VE2oBcsALh/lopzRQj0cbh5L/kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4SHctvY1; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4SHctvY1"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-374c4c6cb29so337080f8f.3
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725523454; x=1726128254; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pLfpYslB2ZuYauJSQQHIlJZPnMxW6xOF3LASls58OE=;
        b=4SHctvY1iFi3DRrB4aVGAQ5yNPvl2bSaSr9aehsZVuqxYX1dn4WoLiqw2YA/vaT0x1
         M1BeJcUSair7WB0xk/xh/rpeYe1kv+3Rr4/MFHpY0vnwcDb0Sy96a8+MirlxrllMMx7C
         L4HbdxF4O3z4WQl7uEuz4zPoZX8UrBHI58/ikl5Yz6rsf8OfY3WLjaAIrQp4OYycsPWh
         UanGckSIvvssb7YLZOs3EUWibsqUSV7B2vGgBCDD3mSpqiVGfuaodLjVJGCK7aCydUf5
         61FYQge4NeBvlkNZ8cnqc8OCr89e6y8n7IiM4t+/M0zgr5ieLlxhn4eXlfPuFH7bZWOH
         2BMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523454; x=1726128254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2pLfpYslB2ZuYauJSQQHIlJZPnMxW6xOF3LASls58OE=;
        b=W2bMEbUsS/zMzWZzBDgjbAEF8scPW0svnEiJk6lsSeulWwN+IIuPwOepRziNlG20MD
         C4PcL5xxd2ZAcTXxLD9OWUn8H3C9B8Xpt1wqRdvvbY+0M6BRbrOd18acBJ+TiUHk8osZ
         CkAXMj8+LpkUl1wcK+RM40gBDockVKdw4cwOMfKAJQf+hMXD9/NISNLM2xqzipKSv6WU
         RC9SAizdR+XrxtWcJrzk5ddsu52rSAv/4ptq2NWZnGsOm6KbcSvG24778o2EXAfyph5c
         deVvhebN615gJVQIE8fFe9OJ6H4Mq/q6tu1pVxlxlAaRoCcouZYLn5i6ULdoJiev1mR7
         O2Qw==
X-Forwarded-Encrypted: i=1; AJvYcCXGN0HtDHX2AsnOkhvVHbKkni4vckC5ytMP5yeSnn91UZt0y3/QHgSMf8uxnjpGHJgseEyfMmiS@lists.linux.dev
X-Gm-Message-State: AOJu0Ywu6+1f0OpMMN8Ok2IXJ6Klt7TOQT9Nv+72a6Zb04uAfcN3kO/Y
	aCQAbyiHHEkVa9VHJzT6Bpnzob4kqUMn2whS7ZufoB2gu3lZZRwSNMSNlCG64uIU9YATVKaeEW2
	H9vFJoTw4E5f+Ygm+CLLPgRpiDqzsMv65T/f3
X-Google-Smtp-Source: AGHT+IFXkQuUA6GvCxWiY5ZV2+dZ7ObdZQnAmrohv7u/9rzMrCvrlFR1MGRiX+3aUn2jzxx2iuNDgsCy59mtYNh8lQA=
X-Received: by 2002:a05:6000:c8e:b0:367:9903:a91 with SMTP id
 ffacd0b85a97d-3749b526808mr19134357f8f.11.1725523453475; Thu, 05 Sep 2024
 01:04:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-5-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-5-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:04:01 +0200
Message-ID: <CAH5fLgjOA7pNtQYTuRy5WAbxJd+uDv2Eh4Z3u6QxSJvd-xcBNg@mail.gmail.com>
Subject: Re: [PATCH 04/19] rust: enable `clippy::undocumented_unsafe_blocks` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Checking that we are not missing any `// SAFETY` comments in our `unsafe`
> blocks is something we have wanted to do for a long time, as well as
> cleaning up the remaining cases that were not documented [1].
>
> Back when Rust for Linux started, this was something that could have
> been done via a script, like Rust's `tidy`. Soon after, in Rust 1.58.0,
> Clippy implemented the `undocumented_unsafe_blocks` lint [2].
>
> Even though the lint has a few false positives, e.g. in some cases where
> attributes appear between the comment and the `unsafe` block [3], there
> are workarounds and the lint seems quite usable already.
>
> Thus enable the lint now.
>
> We still have a few cases to clean up, so just allow those for the moment
> by writing a `TODO` comment -- some of those may be good candidates for
> new contributors.
>
> Link: https://github.com/Rust-for-Linux/linux/issues/351 [1]
> Link: https://rust-lang.github.io/rust-clippy/master/#/undocumented_unsaf=
e_blocks [2]
> Link: https://github.com/rust-lang/rust-clippy/issues/13189 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
