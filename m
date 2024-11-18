Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2085119415E;
	Mon, 18 Nov 2024 10:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731926042; cv=none; b=f5N/OGIvvQ1V6sJoFOwNZeAmUgz1jLGupYL6dc1jTIks7+F3x/K1E+fiip5VK38fDWneJmdWggsP2S9+YGeG97CKAkseb27KK/7va2UvCjyF1kaCDF/Cy3mNwpIHPI43Bal7LQQc87pPmWuSu0EkA8kSjLW2cZk7xcV8ozkLgAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731926042; c=relaxed/simple;
	bh=F1ofiYQxXfAjznmIpDf5RoNpZsYay2hy/O+AC5N90ho=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=k0swPDLfV7pkEowZtBZoFMRzcpMDRRQwAguDfKWCN/Phs0Ufwm8bgvftmx0oT5+oAmEiFR+Ku8ubMAD8Sj7ivWar13222ew7rMG3PrEcLU5bXUFSyunJqQD1JZat0DD3qMDW+LpW/9DxBlhNS6Me3LL8D3qTFCPuLaGvJK3jJH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MQqfwF0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQqfwF0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAA1C4CECC;
	Mon, 18 Nov 2024 10:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731926041;
	bh=F1ofiYQxXfAjznmIpDf5RoNpZsYay2hy/O+AC5N90ho=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=MQqfwF0N5FKxO0yogh0Mma+6VMU9DmeigcBbu5Y4FAmSQwJPzAi8+pLeudYhl2B5l
	 ujQAiZoZC675EgR9XR9y09W0fure2uRxYJP5S9li1uS5b+eO1fqKXtXT1EDgYpZKro
	 b4tkyS7vIO/kaogDq4O8eEmYdjYdeAL05uWjeN36vZ4qdM6e5b/nh9446iIEjvE3E+
	 YGKyCWZQnsKU+xUF6rlZnritPdE1qHiXY5fLF525QG7XhNxLY+OVMKYKYq1zCQ4WbW
	 5w1NN5qxkzQxh60WcjZrYtJtqbZSYnhYRj90AS5uYsuANnoNSgrxpxhdvKXRbTIW0p
	 JeU1Pet77pS0Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>
Cc: "Alex Gaynor" <alex.gaynor@gmail.com>,  "Boqun Feng"
 <boqun.feng@gmail.com>,  "Gary Guo" <gary@garyguo.net>,  =?utf-8?Q?Bj?=
 =?utf-8?Q?=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,  "Benno Lossin" <benno.lossin@proton.me>,
  "Alice Ryhl" <aliceryhl@google.com>,  "Trevor Gross" <tmgross@umich.edu>,
  <rust-for-linux@vger.kernel.org>,  <linux-kernel@vger.kernel.org>,
  <patches@lists.linux.dev>
Subject: Re: [PATCH] docs: rust: remove spurious item in `expect` list
In-Reply-To: <20241117133127.473937-1-ojeda@kernel.org> (Miguel Ojeda's
	message of "Sun, 17 Nov 2024 14:31:27 +0100")
References: <y97yUAwS8e0qJ068FSCaq_qjGqffNgT06-DQqvuAOrx3iHV4qezwqlp9Fl9q9uOMHBgN-tGBBn4ihtDnRNFtew==@protonmail.internalid>
	<20241117133127.473937-1-ojeda@kernel.org>
Date: Mon, 18 Nov 2024 11:32:38 +0100
Message-ID: <87iksk6ddl.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

"Miguel Ojeda" <ojeda@kernel.org> writes:

> This list started as a "when to prefer `expect`" list, but at some point
> during writing I changed it to a "prefer `expect` unless...` one. However,
> the first bullet remained, which does not make sense anymore.
>
> Thus remove it. In addition, fix nearby typo.
>
> Fixes: 04866494e936 ("Documentation: rust: discuss `#[expect(...)]` in the guidelines")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---


Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>


Best regards,
Andreas Hindborg


