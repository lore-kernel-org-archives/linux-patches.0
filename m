Received: from fhigh2-smtp.messagingengine.com (fhigh2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4783149019
	for <patches@lists.linux.dev>; Fri,  5 Jul 2024 13:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720185003; cv=none; b=TW4sE5xeHbNgEWN3MW4Lzia4g0496gWFrry/8ZOhJGpJ0hxfnTyx45YIwnkf0UHQOeDFjgflpzh3BG0bRLUlZcXyVtEyC65UY70/QTQ6BRwL7idjR1SldFXSWEhEcUpoquiF8bii0fQGcguXxFsBuj3CqUYtJmxPIcRn796iL5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720185003; c=relaxed/simple;
	bh=1q1E/4sv+tXPeQzeHotYfSBCzhNvk7p+3s4GW+flNQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SbsxBdKc/FDMeYjItaf0cTiZ+r/VByCEIG6SPzj7fOAqs2wzviip8Ww5+OmNjC8TQMZ0LdWRHqwa1kaHr+W/3BRhv7hZdEYbaJXHRAwq5M4YLInHwMzdgdXXUYCFNUM8awTtm6yO30gO0lFImfm7+4v57GwZ4EZXNSoFpz5sZYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fabian.gruenbichler.email; spf=none smtp.mailfrom=fabian.gruenbichler.email; dkim=pass (2048-bit key) header.d=gruenbichler.email header.i=@gruenbichler.email header.b=HSPACmlh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L+q9OYL8; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fabian.gruenbichler.email
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fabian.gruenbichler.email
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gruenbichler.email header.i=@gruenbichler.email header.b="HSPACmlh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L+q9OYL8"
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id CD05C1140216;
	Fri,  5 Jul 2024 09:09:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 05 Jul 2024 09:09:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	gruenbichler.email; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1720184998; x=1720271398; bh=2/V9W+zvmh
	9v9FlupCQg4uipkAwLQHpgwVVERgKQyr4=; b=HSPACmlhO8JY+arO10lnoYVrkC
	Jl5FN3P9o7uCqVfwe1qgu1LsxcbfRwd3YfsuWgwW8AD4w90kv/RyeMzVWNRsMLzJ
	esHVQJjqEgCL1d6uWPidmZGdA8VKSUgdDgcqcQY6dX2ijudMTVGImdCQp7cC8QUC
	aCCwfAtqp7tlHz++0MPUJEUsjDCJozTeyXZxADineJ3oFllfzNBXXMF4fl56ZZTb
	XY/yEXARxseckbXgCwmAvxClguJCw1Yf8pAWFhm9XHQAy74Opuv/H44iVTs6WJ2z
	BTvTq1U8T2xauIxnCjrDeR9Ku+KzXiXwIurqZ0VzgK/aRnqI4E/OXokSZy1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1720184998; x=
	1720271398; bh=2/V9W+zvmh9v9FlupCQg4uipkAwLQHpgwVVERgKQyr4=; b=L
	+q9OYL8zyHuCrIZiKZ5waDDgVJjPfoXuDEs2DXN4lAVc/zgwjRTXCmWbFAnngnZN
	hxQujbspaZ4pVVWpGaexXk3hEperW5hkV4VrfNl0wUenaZBJ7BePgzZi3MK5Gpf0
	DmyeFXWAa8lVugQNN0f/EqEuuKdbQcnOAIpQRfQVjVeXQEjSJmYvx5iA+zkGC45S
	mpB0q0ZfjwAEZwgdMtYPxJI/3YI2sd5/g+psqZw2rsCMoMD0lMjdtpNgG3A4+oeK
	JCH/RgF5KDiUP/7CDOSD5YpYHGFlHk4ys9z4z8TiRVr+WhqFi0TRQix9wyvU13aw
	U87aGXjA639ocWa1WgDog==
X-ME-Sender: <xms:ofCHZuZMBzwn0UBiCkmxZbHvTsHraiRFPNLwFRBoJbCgCtWPPoGOpQ>
    <xme:ofCHZhZ-ML7mc5yoYvPompczj5FKL_203U6iCow-9PzoCm04uQ-euKE4UUnvFsnCB
    6GspAjSNkWcMYYAdOw>
X-ME-Received: <xmr:ofCHZo_LldPFAeP_u6yvX4xcJeqGhJcC7Kb9SydSedtQZip9_vb8wQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddugdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgestheksfdttddtjeenucfhrhhomhephfgrsghi
    rghnucfirhptnhgsihgthhhlvghruceouggvsghirghnsehfrggsihgrnhdrghhruhgvnh
    gsihgthhhlvghrrdgvmhgrihhlqeenucggtffrrghtthgvrhhnpeekvdehudeugeetieek
    gfeihffgfeeugefhjeeuvdfhleethedvieekjeeijefgteenucffohhmrghinhepuggvsg
    hirghnrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepuggvsghirghnsehfrggsihgrnhdrghhruhgvnhgsihgthhhlvghrrdgvmhgrih
    hl
X-ME-Proxy: <xmx:ofCHZgqSYZo35qIDsLj4rJHPDqHd6tovh0KDvnqil7YWLW7yDks3Zg>
    <xmx:ofCHZpruO-5zurZaLutKeL-8kkJXik7SSbC8DuN-HGW2X_PDz4KvxA>
    <xmx:ofCHZuSPwUru4ohQ077UfXnGgTxvBSZPzgKN7W_cYTGT_okQO3-6dw>
    <xmx:ofCHZpqtfoxWn9-jmkS2lSUIIRccNQaUbesJEO0hi4_5blkHk4TkbA>
    <xmx:pvCHZg2sAnm2nARPZr00UwTzx4jqpbWyNqoday3W1d6-6lKvWSM1vfzc>
Feedback-ID: i1739464b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jul 2024 09:09:49 -0400 (EDT)
Date: Fri, 5 Jul 2024 15:09:45 +0200
From: Fabian =?utf-8?Q?Gr=C3=BCnbichler?= <debian@fabian.gruenbichler.email>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Andrea Righi <righi.andrea@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 	Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, 	Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 	Andreas Hindborg <a.hindborg@samsung.com>,
 Alice Ryhl <aliceryhl@google.com>, 	rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 	Jan Alexander Steffens <heftig@archlinux.org>,
 Johannes =?utf-8?B?TMO2dGhiZXJn?= <johannes@kyriasis.com>,
 	Josh Stone <jistone@redhat.com>,
 Randy Barlow <randy@electronsweatshop.com>,
 	Anna Figueiredo Gomes <navi@vlhl.dev>,
 Matoro Mahri <matoro_gentoo@matoro.tk>,
 	Ryan Scheel <ryan.havvy@gmail.com>, figsoda <figsoda@pm.me>,
 	=?utf-8?B?SsO2cmc=?= Thalheim <joerg@thalheim.io>,
 Theodore Ni <43ngvg@masqt.com>, Winter <nixos@winter.cafe>,
 	William Brown <wbrown@suse.de>,
 Xiaoguang Wang <xiaoguang.wang@suse.com>,
 	Zixing Liu <zixing.liu@canonical.com>, Jonathan Corbet <corbet@lwn.net>,
 workflows@vger.kernel.org, 	linux-doc@vger.kernel.org
Subject: Re: [PATCH 13/13] docs: rust: quick-start: add section on Linux
 distributions
Message-ID: <huatx5giw7r357zeecxngkqboiq3lfqndjjrcivxllurqpjvbi@4y5ejgwxhztm>
References: <20240701183625.665574-1-ojeda@kernel.org>
 <20240701183625.665574-14-ojeda@kernel.org>
 <ZoeQVYda-AZN6PYy@gpd>
 <2qwdfogh6jd5uixxjzlagmtfvnykk3x4ztqrn4j2v6qoref5rx@ooj6gq27bq4z>
 <CANiq72n6bYt0AKNxad2+gjwHKQ1RiDxAbjm-2u20L8TcSZE-9Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72n6bYt0AKNxad2+gjwHKQ1RiDxAbjm-2u20L8TcSZE-9Q@mail.gmail.com>

On Fri, Jul 05, 2024 at 02:52:44PM GMT, Miguel Ojeda wrote:
> On Fri, Jul 5, 2024 at 8:47 AM Fabian Grünbichler
> <debian@fabian.gruenbichler.email> wrote:
> >
> > Debian (for building firefox and chromium), and uses a -web suffix for
> > that:
> >
> > https://tracker.debian.org/pkg/rustc-web
> 
> Like for Ubuntu's versioned ones, it seems not recent enough at the
> moment (i.e. for the current kernel), if I understand correctly.

yep.

> Also, it is a single version, i.e. 1.70, right? We didn't use that
> particular version in any old kernel version (we moved from 1.68.2 to
> 1.71.1 in commit 89eed1ab1161 ("rust: upgrade to Rust 1.71.1") back
> then). So I am not sure how useful it would be, but if you think it
> will be in the future, perhaps it is worth mentioning.

right now it is updated whenever its rdeps (firefox and chromium in
stable) need newer versions. once e.g. a stable Debian kernel has
similar requirements, I guess the same would apply there. I am not sure
upstream kernel development on Debian stable would be enough of an
argument to update it (or provide similar packages), but I am not a
member of the teams that would make that decision.

we currently don't provide multiple versions in parallel (like GCC or
LLVM though) besides this special affordance for browsers. I am not sure
this would be a good idea either given rustc's release cadence ;)

as discussed off-list, -backports might be a better place for providing
more recent toolchain packages on Debian stable, and independent from
this thread, I have pondered providing them there in the past already.
backports would only ship one version as well though, and at most the
one in testing (so it would also be affected by the freeze period, just
like unstable and testing).

> > https://tracker.debian.org/pkg/rust-cbindgen-web
> 
> We may use `cbindgen` too in the future, but not currently.

it's used by firefox :)

> Is something like `bindgen-web` also available for stable?

not yet, but could conceivably be provided once/iff there is a need (see
above).
