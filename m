Received: from fabulous-taliesin.relay-egress.a.mail.umich.edu (relay-egress-host.us-east-2.a.mail.umich.edu [13.59.128.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E694F2652BF
	for <patches@lists.linux.dev>; Tue,  1 Jul 2025 21:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.59.128.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751406180; cv=none; b=eB5RSr04H4Eqz4pslDCXVddaWrh1Rd2ROs7yTyDyYAfk3O71cavDUiShLw6Jf5uSsRi++12WuGSxZUEoa9vQwDNcHe878r0DgVP42VseVyvpYPUw7wnEQulWwkemnN3RGYS5tPa+1F2uQ/BWOJv3ET5xslCAUK5hfNCh9zLRrmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751406180; c=relaxed/simple;
	bh=FfRpsdCetCvTN4MvBRq2kYjiqRtFaR1ruWoUx1S7KfE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=QKzKBTnu2MV/iqnkmYqsqNbmKa0GJTusXh9Ap86/l32gi+VnW/Ba4iLnWzZviDPxqms/kRPkPJ+dfR1jDO+lURGu6YvRLOC2guyjZsLIY0XgzTaJPlNR3mH8VECE2h0wvP8sc1ZLitysPwWnbE+Cfeb6n4s+ZONhjPMnn7WsQsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=Tqr4Y0So; arc=none smtp.client-ip=13.59.128.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="Tqr4Y0So"
Received: from enriching-yacaruna.authn-relay.a.mail.umich.edu (ip-10-0-73-67.us-east-2.compute.internal [10.0.73.67])
	by fabulous-taliesin.relay-egress.a.mail.umich.edu with ESMTPS
	id 68645573.35A3BCD8.56E4F08C.132849;
	Tue, 01 Jul 2025 17:38:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=umich.edu;
	s=relay-1; t=1751405937;
	bh=EoCFQ7P8Tnk+dsaPLBjGlDsJb2PcEiJqEGBMjg3BNJA=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To;
	b=Tqr4Y0SoTUl3hjVtISApUUlSvtP0x0o8Q7gTb9EPBigNjeSAYteDfqIdKlbKDDnWC
	 hVm+wsmrlcn1Us/3D6z/iRMyZnzYslcRxSfRvXlln/hkKbBhxYhmbLKCtn5g473ZSR
	 HEuJmQxcMTTCpNO0ktclae25mAPJ8ui8HIcibKoyapT/iGkVjjuOo9J56Lv70kVlHz
	 +a2XCXpn7LEUcUk+2DzyblYtNAJxIEnFKbnMMoG/Y1XyKZYuf+zcPf67Oe32YCdZ/2
	 cBbMyHkcsMANYRqq+RHR2KiO48ISBDdK6yaZSkzfA1pI7GiKCTV0K4vuN/vnQUTbMI
	 jWvnRKklE2G/g==
Authentication-Results: enriching-yacaruna.authn-relay.a.mail.umich.edu; 
	iprev=fail policy.iprev=73.110.187.65 (Mismatch);
	auth=pass smtp.auth=tmgross
Received: from localhost (Mismatch [73.110.187.65])
	by enriching-yacaruna.authn-relay.a.mail.umich.edu with ESMTPSA
	id 68645571.4F66061.263F03BF.1065300;
	Tue, 01 Jul 2025 17:38:57 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 01 Jul 2025 16:38:56 -0500
Message-Id: <DB11L7KWH27S.8L9WLRAR1B0P@umich.edu>
Cc: "Len Brown" <lenb@kernel.org>, <linux-acpi@vger.kernel.org>, "Boqun
 Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH] rust: acpi: remove unneeded cast to clean future Clippy
 warning
From: "Trevor Gross" <tmgross@umich.edu>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Danilo Krummrich" <dakr@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>
X-Mailer: aerc 0.20.1
References: <20250701174656.62205-1-ojeda@kernel.org>
In-Reply-To: <20250701174656.62205-1-ojeda@kernel.org>

On Tue Jul 1, 2025 at 12:46 PM CDT, Miguel Ojeda wrote:
> A future Clippy warning, `clippy::as_underscore`, is getting enabled in
> parallel in the rust-next tree:
>
>     error: using `as _` conversion
>       --> rust/kernel/acpi.rs:25:9
>        |
>     25 |         self.0.driver_data as _
>        |         ^^^^^^^^^^^^^^^^^^^^^^-
>        |                               |
>        |                               help: consider giving the type exp=
licitly: `usize`
>
> The type is already `ulong`, which nowadays is always `usize`, so the
> cast is unneeded. Thus remove it, which in turn will avoid the warning
> in the future.
>
> Other abstractions of device tables do not use a cast here either.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
