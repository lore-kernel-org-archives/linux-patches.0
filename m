Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E052135A4;
	Tue, 29 Apr 2025 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745934057; cv=none; b=nRbkIb315VjGL8IluU8XlgXIaAhTuTCD84uThVYqT7UopOeKYLcY4jIUSizbWiiPRlNt8TomGtgzDP5+BcE6BMYw88LLjKZyhQooH6IEQ+5VJa1T7p8x3jJyJDmCp6dJG3wxWZs/j6Rw/vY59dM1C14C2yAi22Hgkvc6kGfhwXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745934057; c=relaxed/simple;
	bh=MSR2wRV13Chm7qMvjBrZUPPk8jV++N/soVmQ3bTqXts=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tzskl7bZTgZNxU6Pl2Wvs2XmCmirilHBqakYO/4l1ZVzA7mqZ8iC6Jhw3/Mu8I6iDV1QzXGW4I1jHgD6Kug820GR+Y6TYCm/JcuoMIj/J1NFFyl8OLiHKqwK2HAQNTU0hERDg2+opYDgzxqF3gsybf5yoDwLw3WqwYPBnGgfCMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vN9qfmF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vN9qfmF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DD6C4CEEB;
	Tue, 29 Apr 2025 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745934056;
	bh=MSR2wRV13Chm7qMvjBrZUPPk8jV++N/soVmQ3bTqXts=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=vN9qfmF84NbKzn7Z/5xjUCpgCyaZL6Pkeb8qdBJbLPoPfHlFmQTy8J/HRZXFK5k+W
	 SWpPE3Gsr9AxN5ihDRAM1I8YcqE8iaxAveDcO8+sdIcMWUVURBoVHhhn95Q3EDyKf6
	 IH6hDcfkVln6QpaUpQuRYQCdSJLywiky35FaQn2b9mpGcwjmbHKWyNzU6O+u3grOoO
	 GC/KIW9kITnDt9y2CMj+yKIx2rURdd+Md8i58qQ6sZTgR1Ltz9zTLJhsr8Y12hev0O
	 k41fm9Crfyvz9GUNjC455Lw4tRuDQYY8u4VdsVdb//812Yrv1kD2qCJR/66dBApN8k
	 xZ+MYsmGpKK5g==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
Cc: "Miguel Ojeda" <ojeda@kernel.org>,  "Alex Gaynor"
 <alex.gaynor@gmail.com>,  "Nathan Chancellor" <nathan@kernel.org>,  "Boqun
 Feng" <boqun.feng@gmail.com>,  "Gary Guo" <gary@garyguo.net>,
  =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>,  "Benno Lossin"
 <benno.lossin@proton.me>,  "Alice Ryhl" <aliceryhl@google.com>,  "Trevor
 Gross" <tmgross@umich.edu>,  <rust-for-linux@vger.kernel.org>,  "Nick
 Desaulniers" <ndesaulniers@google.com>,  "Bill Wendling"
 <morbo@google.com>,  "Justin Stitt" <justinstitt@google.com>,
  <llvm@lists.linux.dev>,  <linux-kernel@vger.kernel.org>,
  <patches@lists.linux.dev>,  "Aaron Ballman" <aaron@aaronballman.com>,
  "Bill Wendling" <isanbard@gmail.com>,  "Cole Nixon"
 <nixontcole@gmail.com>,  "Connor Kuehl" <cipkuehl@gmail.com>,  "Fangrui
 Song" <i@maskray.me>,  "James Foster" <jafosterja@gmail.com>,  "Jeff
 Takahashi" <jeffrey.takahashi@gmail.com>,  "Jordan Cantrell"
 <jordan.cantrell@mail.com>,  "Matthew Maurer" <mmaurer@google.com>,  "Nikk
 Forbus" <nicholas.forbus@gmail.com>,  "Qing Zhao" <qing.zhao@oracle.com>,
  "Sami Tolvanen" <samitolvanen@google.com>,  "Tim Pugh"
 <nwtpugh@gmail.com>,  "Kees Cook" <kees@kernel.org>,  "Nicolas Schier"
 <n.schier@avm.de>
Subject: Re: [RFC PATCH] rust: allow Clang-native `RANDSTRUCT` configs
In-Reply-To: <CANiq72mNJrMMbEcfJMLT4kM-_iviM0AR6oeigCyrb5eMWkn3KQ@mail.gmail.com>
 (Miguel
	Ojeda's message of "Tue, 29 Apr 2025 15:19:13 +0200")
References: <20241119185747.862544-1-ojeda@kernel.org>
	<CANiq72n4Fw96hcuqQeorsfH7z4Tb+R1gdf80H_XkD-oA6z5TSA@mail.gmail.com>
	<PVK5DQh3QRZOFQ4cMasO5h75CnLppaPo_aKbvSjzd0gv-bUIagkLyv1FZG5KvJqSUWnl8qwSmmQdl6BVPEcNKQ==@protonmail.internalid>
	<CANiq72mNJrMMbEcfJMLT4kM-_iviM0AR6oeigCyrb5eMWkn3KQ@mail.gmail.com>
User-Agent: mu4e 1.12.7; emacs 30.1
Date: Tue, 29 Apr 2025 15:40:43 +0200
Message-ID: <87jz732ihw.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com> writes:

> On Thu, Jan 9, 2025 at 3:51=E2=80=AFPM Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
>>
>> I may pick this very early next cycle so that we can get some testing
>> during the -rc's, and just drop it if something breaks for anyone.
>>
>> But any other testing beforehand would be still very welcome...
>
> I ended up waiting on this one since I think Andreas would be able to
> try it with some actual workload (the nice benchmarks he has). Anyway,
> it will go in sooner or later.

It is on my list, sorry for not getting to that yet.


Best regards,
Andreas Hindborg


