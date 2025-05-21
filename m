Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A28E19E7D0;
	Wed, 21 May 2025 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747840157; cv=none; b=KEjyZfHTOUjYnTvFok0LfuOY9nRfDOs41DgcisgsUpk5QQADkoMfyU2GrOei8MECxUW5lfFqbt/qMstD36JC4lACFgrupp5rO4cvwsgWWMLBRaNYm3WSs4NgtGWbGvTjp6BcuyLOWCeGnLAb56MxF18ERc+6fnpOvZK73Q2h8dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747840157; c=relaxed/simple;
	bh=yEGXJKcukp3coNXCgoAIIW+0/ePHVQR3Nl9Yg3otJmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2Y8GriFHtrx+oK46gS9mpfs1eriJurZ5q5RHdkkDFkl8E2vSHt+2Nt9203piTBxcQDeN3omv1lEqqOyGGkRbdszd3QW83g98n2x5cJAAOCGIYkrwWZ1MwAb3WSm2TtOuRcBTjthlMNctZRmYe6mLl3neE5nl8gaDnKycuXKahI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEq8pzqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEq8pzqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96D0C4CEED;
	Wed, 21 May 2025 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747840155;
	bh=yEGXJKcukp3coNXCgoAIIW+0/ePHVQR3Nl9Yg3otJmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XEq8pzqRt72hISS9fQ+vfp5K+Wy10HZtbsf/zA4SlKo0tgb6a9mfW24MZfxm1hezH
	 jzOLx3sr5Y4QuBWcNwboyawMnBwGnXicuZQ+N92yfFcg/9czudo5oyqJ9w7oUfPoog
	 qo4C7liYNRj7LjR9uIL4yGE6UADYjr/iEA/KeHmE=
Date: Wed, 21 May 2025 17:09:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>, Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 00/10] rust: clean and enable Clippy `doc_markdown` lint
Message-ID: <2025052156-creatable-uncorrupt-47ce@gregkh>
References: <20250324210359.1199574-1-ojeda@kernel.org>
 <CANiq72mBHcsCpn1ZJRJ9Qa-Ass1MsoKdKcFpiFF7hNwyOXjAOA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mBHcsCpn1ZJRJ9Qa-Ass1MsoKdKcFpiFF7hNwyOXjAOA@mail.gmail.com>

On Wed, May 21, 2025 at 04:01:28PM +0200, Miguel Ojeda wrote:
> On Mon, Mar 24, 2025 at 10:04 PM Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> >   rust: alloc: add missing Markdown code spans
> >   rust: alloc: add missing Markdown code span
> >   rust: dma: add missing Markdown code span
> >   rust: of: add missing Markdown code span
> >   rust: pci: fix docs related to missing Markdown code spans
> >   rust: platform: fix docs related to missing Markdown code spans
> >   rust: task: add missing Markdown code spans and intra-doc links
> 
> Abdiel, Danilo, Rob, Saravana, Greg, Rafael: anything against me
> picking these ones up?

No objection from me for you to take these through the rust tree:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
