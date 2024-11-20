Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0CF1C5799;
	Wed, 20 Nov 2024 18:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732127534; cv=none; b=UI+HQrEzYr33tGFyotHtyUUQ798RTOE4LHg2oO7zNh2G942W8KrafaScqfFnEukaxrDXU71jTvUM+qXzL4u28YO1c+bkmQjLCBFJr3gYkNIVtHwcVqNiLHV6992iJopD7ZDE5KaKT6TzIahLCfaIdru029/oC4+Pa/vLlEn51gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732127534; c=relaxed/simple;
	bh=kA6jhcAfbHevPYD9R2gSgEA7LXfTHalSyYCChQaX7yA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b35x1OWcyH1Auo5wUUmLgcwgkN5mYWgnZc5yzkWtl9P55guwiWapNRM9ybHS7OFs5J2Lp+lCR8a3DlKPBPCzC95P2JMypOTY/BmFYBHmsjoGs0H8kXfECgj87YMv3LY7t39qeM+3pTQxPeml5boIrwPxBQSg65DJDAuV2p9hUWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09726C4CECD;
	Wed, 20 Nov 2024 18:32:11 +0000 (UTC)
Date: Wed, 20 Nov 2024 13:32:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, Gary
 Guo <gary@garyguo.net>, =?UTF-8?B?QmrDtnJu?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Andreas
 Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH] rust: jump_label: skip formatting generated file
Message-ID: <20241120133247.1789fbb1@gandalf.local.home>
In-Reply-To: <CANiq72mOoAxA9nW+5=kJMmet7JarT7TAADejXK3XCAcVe0A-bw@mail.gmail.com>
References: <20241120175916.58860-1-ojeda@kernel.org>
	<CANiq72mOoAxA9nW+5=kJMmet7JarT7TAADejXK3XCAcVe0A-bw@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Nov 2024 19:09:13 +0100
Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> On Wed, Nov 20, 2024 at 6:59=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> w=
rote:
> >
> > Thus skip formatting it by prefixing its name with `generated_`.
> >
> > Fixes: 169484ab6677 ("rust: add arch_static_branch")
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org> =20
>=20
> Steven: if you could please carry this one too before you send the PR,
> that would be nice. Apologies for not noticing up earlier, I noticed
> when doing some manual merge tests for the Rust subsystem PR.
>=20
> If you happen to rebase for the other sample/test that you asked
> Alice, then please feel free to just fix the original directly. Same
> for the other fix you already applied -- both are really just renames.

I don't do rebases unless absolutely necessary. I had to rerun my tests as
I added some code to another topic branch (and added the rust topic branch
to it). I can kill the tests, apply this and restart.

-- Steve

