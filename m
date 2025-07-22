Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F242BEFE3;
	Tue, 22 Jul 2025 09:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753176552; cv=none; b=ckuSjqgAS8RqjwuTaLU4e9XHKSp9HwwV9pBaN6DG7YCIjxd3BeeYzkJUt86zHtRcWqhxNQSW0pW71jTrIM8M5MWgNe64517a0/2rLN2QtJzHq94CBn5/+E+sgNJ0VewNbnE+gNVuoNWSTZX6suLhAnQgwAflVd059eMhQ6wXQaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753176552; c=relaxed/simple;
	bh=enVP14U28hE+PnqiYzRdLrXgVSE41+FcW7F4HH/TMug=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=D5NakjeSRobNl2zQis9f9E3ib7Ufa28LMOu+Maa5hPLsUP6rPLFCVjEip9VG0rjDS3fNA9rCzIXP9Z+Tcshgb3mn6eepURhSX3/nQKL2gB9tywPNiDSmPDYQXLyQnCeYHFji3Bijz6CJhxE2Uw8lGaujJxTFhTX864Sqx6RSDpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epOLk3cq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epOLk3cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EFCC4CEEB;
	Tue, 22 Jul 2025 09:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753176552;
	bh=enVP14U28hE+PnqiYzRdLrXgVSE41+FcW7F4HH/TMug=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=epOLk3cqY1C1/UIHczxHBajXBQ7VAK5QENDgP7SOlW3GcnU7EDU9dsqQ+DMvpiTd6
	 40R4RWsysPr4dEkLSRwobE22Z2CLghn529FXtvOftLptOlOjLxEA3CowZVyw921Vmk
	 W94sIIEuarC5f0ixcqjJCAKeDR4Jho+YWoe/EoXUlTq5LPqeX9mtjPdmkgbFw7+ZHl
	 wGoRcmiDDHHJaW6aKhKmq99ZXGiiAauy9fptjv4AproU/f3ZOZ38D1ge5e4Q29UcGo
	 a0WoE0b5I+WGWFItv3SZ4ILXV1ls4mG8jTPTfLgj3tn0HYfrjY7D1bmRPd7dLvHMt2
	 81V/qu8lhw8fA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Jul 2025 11:29:07 +0200
Message-Id: <DBIH7VEMJY0E.4KMGP0KSLZHG@kernel.org>
Subject: Re: [PATCH 1/2] rust: io: fix broken intra-doc link to missing
 `flags` module
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng"
 <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
To: "Miguel Ojeda" <ojeda@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250722085500.1360401-1-ojeda@kernel.org>
In-Reply-To: <20250722085500.1360401-1-ojeda@kernel.org>

On Tue Jul 22, 2025 at 10:54 AM CEST, Miguel Ojeda wrote:
> There is no `mod flags` in this case, unlike others. Instead, they are
> associated constants for the `Flags` type.
>
> Thus reword the sentence to fix the broken intra-doc link, providing
> an example of constant and linking to it to clarify which ones we are
> referring to.
>
> Fixes: 493fc33ec252 ("rust: io: add resource abstraction")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Thanks for catching this and the other documentation warning.

Applied to driver-core-testing, thanks!
