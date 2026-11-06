Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793948753;
	b=OJYJRgavbqW8H94DLoRIG0itp72w3VB2d+kT7gBeipKw8qMAZL602qUByO7ko8MTL/WQ
	 UTc4Dft5a8f2D/ZFGYK1wiVn6zLHN/LlSAagHDHI6Dx2LDMtHDawi/rg8woCuzkDgMqZn
	 2IUBE4kPUKICvb7wDTYu/yWhEEb4DTun7MJgGLWV6Sl5dcZet0p0T5DvfjF3bKpmsbC7l
	 N1m4rJHFrWCN1LWREIgcxnXdSTvHxsb3ssxrl+RrqIzAXI4Y+vJOmFbZyjobWw/gxvE4E
	 JKYHW/5kCWsWV61HvUMzwhpDSFBOfcnDijygiLD1VL3RAewldnuntwH7o5jtgLwyh0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793948753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=H+EQ5iHmQny3HKRPrm1r/INHyLhkn0X/JQimG80IxmY=;
	b=R/ApLAPToJUzi/oHovmiu4rIYNtoiq+ARNRcURxDeXttdd866F/F7Gp7GUoq53DpW89L
	 5eCvtjagNuUOSKZ6JxS5i1Hu65nLlgoYJkVuyvMrZ5TJa+Licnt9RrFYkPtP6n7E68kiO
	 UCVLZ8mNzBdQ5PLRPK0mTD6+wXiM09D1UxjeMALww17ton+w0P6mZpkoLfku6PtJnfTPI
	 uws3lGWNWEuGxbcVIe3th8Q/GwVXWHDXwdPB+lFyKKz80CKDAr6Gkx2z2v/nKZOZrFN/Z
	 40vFZOwPk7GQr3JEsJamiDB2n3JAjyDhKE8nO69rDmhUWP970NNHeRlxGauDov+2VkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfjwyKvB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6EA606A328;
	Fri,  6 Nov 2026 07:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfjwyKvB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA70D1F008A2;
	Fri,  6 Nov 2026 07:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793948752;
	bh=H+EQ5iHmQny3HKRPrm1r/INHyLhkn0X/JQimG80IxmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfjwyKvBNf6gIoRP0qUnJu6PRb9hysZam74s/yv507UkUm6AepNFMLP5yB79+7wZm
	 mSZUrnL/H/ZkckbmyuzQ2EP1Uh9HS6iGojLXXuD5Bh5fotsNTfhUMrTNgoHL8qo4rI
	 6zsYfk0FTwmUxYazFMoBEmwBvr7RXtrAZpMMdrB9KLqHImUAShqDxxxxUfqt4GGNQx
	 khq5u+EWFgBBlETkXz97qNARZYDYfIL84J76eWQ8ZutyFQ8gHvNr7vpG/vzDlzYGqv
	 4APfcOLEhKBIbAJnL/4nx+QRC07khAGTpQY0/eqT06JIrJdxCRWTZ9HnCde76ehP06
	 N4Df2eMu2iszA==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: fujita.tomonori@gmail.com,
	ojeda@kernel.org,
	patches@lists.linux.dev,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.18 0552/1005] rust: bug: fix warn_on macro build error on UML
Date: Fri,  6 Nov 2026 08:05:43 +0100
Message-ID: <20261106070543.89122-1-ojeda@kernel.org>
In-Reply-To: <20261104211059.353572803@linuxfoundation.org>
References: <20261104211059.353572803@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 04 Nov 2026 16:04:45 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> +                $crate::str::CStrExt::as_char_ptr($crate::c_str!(::core::file!())),

We would need `CStrExt` that we don't have in 6.18.y for this to work:

    error[E0433]: failed to resolve: could not find `CStrExt` in `str`
       --> drivers/android/binder/freeze.rs:109:13
        |
    109 |             kernel::warn_on!(freeze.num_cleared_duplicates != 0);
        |             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ could not find `CStrExt` in `str`
        |
        = note: this error originates in the macro `$crate::warn_flags` which comes from the expansion of the macro `kernel::warn_on` (in Nightly builds, run with -Z macro-backtrace for more info)

We should instead do e.g.

    $crate::str::CStr::as_char_ptr($crate::c_str!(::core::file!())),

I can send a custom one, but we should drop this one.

Cheers,
Miguel
