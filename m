Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2233043C0;
	Mon,  1 Sep 2025 09:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756717885; cv=none; b=rV8KpBO1EPNYSsb+V2f7ETQsgT7H+hHoeWESIxWmT+Y4SNb7liqH8J16vb2KsiCm4zOVsTkXNQFS3GEFgspzMiW93WHk+uIoN5NsmIldMqTb1J34Tkc3VulYgqyn3hZh5V4we0g5baXgWGEBStsoFwaUS1+1vaKUUYGh6QS0++E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756717885; c=relaxed/simple;
	bh=e7IQd7jdRCryUUMeIu1J5IWuEsonevhWYhuN2P6mwwI=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=p3CME5AYbAFOn0sac18NoiC8Oeo+3kqvIGV4qPlmbS2ml8+d2wMiALseNhK/he/JMlyA+I99F2gyhc6A0Usg4PqG44TJQNOURB7klJ9Rxuiit9KBGsMC7TFj4htrn6aGG42ft9ixgAPiEaGzGEvWYtIHqmRDzjrKXz/dtbHffco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p9Z1nq8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p9Z1nq8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEB7C4CEF4;
	Mon,  1 Sep 2025 09:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756717885;
	bh=e7IQd7jdRCryUUMeIu1J5IWuEsonevhWYhuN2P6mwwI=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=p9Z1nq8tYVcZxiUkDkCpDTRrcV6CGYdo8h/hbff/fDboABjPhYZ7vPWOA4BxPT34e
	 9I0Lw5F+QevJJoFoCnOMlg0Fb0QoTErcYHxbeZ/wNwk5ubyEABshVyel1rgxO5lzYD
	 XPtP878fU3PxYhlUDrYie7+gXVSh6//N3gZTCeoGwYBjM8AFH6fS85e41RujBW2ydY
	 S49q27J5BCdfWLEicJCiDFmibiOXdANo2rdsUUflu5yFnFAMsZNLDsMHqMZRdL57HQ
	 bThxp4qT5U+Fbv1SwNJyvVm7c+Fdvc+LB7eB8GvedUuJyRhoEDl1JWwVm22Ebkos8P
	 Xll/bZv0yc19Q==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 01 Sep 2025 11:11:20 +0200
Message-Id: <DCHCILE9D2I9.TWPTF228RIJR@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH 1/3] rust: error: improve `Error::from_errno`
 documentation
From: "Benno Lossin" <lossin@kernel.org>
X-Mailer: aerc 0.20.1
References: <20250829192243.678079-1-ojeda@kernel.org>
 <20250829192243.678079-2-ojeda@kernel.org>
In-Reply-To: <20250829192243.678079-2-ojeda@kernel.org>

On Fri Aug 29, 2025 at 9:22 PM CEST, Miguel Ojeda wrote:
> This constructor is public since commit 5ed147473458 ("rust: error:
> make conversion functions public"), and we will refer to it from the
> documentation of `to_result` in a later commit.
>
> Thus improve its documentation, including adding examples.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Benno Lossin <lossin@kernel.org>

---
Cheers,
Benno

> ---
>  rust/kernel/error.rs | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
