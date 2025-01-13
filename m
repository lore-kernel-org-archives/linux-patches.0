Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F1024022F
	for <patches@lists.linux.dev>; Mon, 13 Jan 2025 17:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736790431; cv=none; b=Q6L1msrSj2NK2NGcFGMvb0/zPika4vBKUanYJBryTO5bQDGZRgU4DdaiyLC55NYiF6SGpLqXP3+94BnL7OpXYzKK3PUYlHk0+lImp72nSOBXetSl+Tz2oh6mPEz+EWwKvomTocYDpJcAKzRRUjWYTWvjoWMCJx+zNsq/yLkEqeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736790431; c=relaxed/simple;
	bh=UEut3SNd53RgLH7EweUyY0BNRszVLzCR2TgXDZy+T+c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=njY7zNmYDh3wH2lcuIAXF6qwuIbfGH+ClCzSPH9LjtJprwwsYolzGAu19fk+yAgd5AgV9NpEkDPOCeXk/27tKoTnSrpkYOL4ko/KkHSnAMwi+Se2w441GRI77KebXj6DqHtCwEmIY+JixJVqQ03An+0zh+gc8pZVYP5GobNw9Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=fwo65gjC; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="fwo65gjC"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 152A6404F5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1736790429; bh=m4FbUsYx+NEdoipGIuGZHGLLbLspNQt/AmLV+dDNrZY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=fwo65gjCOQSXqf4l3O5YCcr0W8RmG/x8d38NyXH5Lh1zOGQSHcT7a61qJe7MM3VuR
	 PLl42yCLIXTfRkkMT4SdQAly/aWC7FSdej3M80bm8PtyMGXajKF8fE/fX0CHh1gFMM
	 qnUFg2UyS8HFuNAWY5oaEzaqgQCTrnNX/8ljTotxcb/usuLv9bs9uWnaI8t5XeIvgk
	 QsrEZJFRY/eAgUemDQ4TMal4UBZwDWzApTTkbhddhXsXUFQDMK2jahNxzEMrNq3dFG
	 zBfwaAStCJADnH0UdV700na2ir5oMnySYnfJqM3XoDSX81Ix7jnmuGMn3/5+Gd+aVc
	 z2taqTe7W8u4A==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 152A6404F5;
	Mon, 13 Jan 2025 17:47:09 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, Miguel Ojeda
 <ojeda@kernel.org>, Neal Gompa <neal@gompa.dev>, Sami Tolvanen
 <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, Luis
 Chamberlain <mcgrof@kernel.org>, tech-board@groups.linuxfoundation.org,
 Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Linus Torvalds
 <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] Clarifications around Acked-by and "# Suffix" proposal
In-Reply-To: <20250112152946.761150-1-ojeda@kernel.org>
References: <20250112152946.761150-1-ojeda@kernel.org>
Date: Mon, 13 Jan 2025 10:47:08 -0700
Message-ID: <875xmibo83.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Miguel Ojeda <ojeda@kernel.org> writes:

> A patch series that aims to clarify what the purpose of the Acked-by tag is,
> in order to help newcomers understand the kernel process better, as well as
> to give extra flexibility on the usage of the Acked-by tag.
>
> It formalizes one of the proposals from [1]: "# Suffix" for Acked-by.
>
> I hope this helps!
>
> Link: https://lore.kernel.org/rust-for-linux/CANiq72m4fea15Z0fFZauz8N2madkBJ0G7Dc094OwoajnXmROOA@mail.gmail.com/ [1]
>
> Miguel Ojeda (3):
>   docs: submitting-patches: clarify Acked-by and introduce "# Suffix"
>   docs: submitting-patches: clarify difference between Acked-by and
>     Reviewed-by
>   docs: submitting-patches: clarify that signers may use their
>     discretion on tags
>
>  Documentation/process/submitting-patches.rst | 22 ++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)

I've applied the set, thanks.

jon
