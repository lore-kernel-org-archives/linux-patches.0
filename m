Received: from fout1-smtp.messagingengine.com (fout1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9A879F3
	for <patches@lists.linux.dev>; Fri,  5 Jul 2024 06:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720162025; cv=none; b=uL1n3O5WbF/BCZPvYF2YoQOWrB6BIrvhq3xIbWZozwrZomQLQKFHMItZmaR/7kw+s69hGZ4afcIdpaTfSPN/pGFpcnjWlx2TB+Qilv1yzPA6JK9iP97TcBpQLst1K7cl/GRy3nVWLI7WD9C0qcPVYRTJZ1UFXmJoIe/ZwegKTfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720162025; c=relaxed/simple;
	bh=C/MYmdOL9LY9FmZmwMd0l+ZoE8eXqMAQ16YbHpqQLP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bUnA0U2fPDecIcWxlcIMNMnME+Av2H+p7GUiazTgGtqOHk8buaEd0rxXupnFsAnXzgorX6bmhLMYe8JkVSdF8/g3Ai0evVTYbBIQ3/+urybYsJtilTl58WoKQTI3KgCMDc76QGfSCNHhxwHnVtaXwKMeLEPimlprDclZDHJUMfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fabian.gruenbichler.email; spf=none smtp.mailfrom=fabian.gruenbichler.email; dkim=pass (2048-bit key) header.d=gruenbichler.email header.i=@gruenbichler.email header.b=BYPu7Agc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=oRe+bCL1; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fabian.gruenbichler.email
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fabian.gruenbichler.email
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gruenbichler.email header.i=@gruenbichler.email header.b="BYPu7Agc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oRe+bCL1"
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfout.nyi.internal (Postfix) with ESMTP id BC476138017B;
	Fri,  5 Jul 2024 02:47:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 05 Jul 2024 02:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	gruenbichler.email; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1720162020;
	 x=1720248420; bh=9nfRXpzLJzZ92qq3tMa20LHvs1pNJfjmA+2wswtKqSk=; b=
	BYPu7AgcWtUMJhVBWJsHdRlmyC3XnP8eXt9MXd3bEO2pOfjGjlzTxNvYl7hzXd6E
	x1l59idjtzNzPKSGKDeNbDDss15B68HV7MsaVESSksjG/+HwvaYam7Y2ahA3qt24
	or5MnRRkBu/p4U6xkKiORn6cLsjTVU8S3evTTafhzrh7FKKDbx9rofJ2FuGns3UH
	ur6I41DzGH7mXcgL8fJcdOs7D8pbMiALq4pUuEzpC0JlbyxOmdiezIUeQmTE/q79
	1YDb1YCrMfH4g+Im2AvN9Atp6M0yR7SXAylatV+yiGu2Leukad5X6nTFzW+OCRJQ
	9o17A+sg+F5ssyIat3/t5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1720162020; x=1720248420; bh=9nfRXpzLJzZ92qq3tMa20LHvs1pN
	JfjmA+2wswtKqSk=; b=oRe+bCL1JQ5jnqJfpbLGgtUKIKZk7KchosqYTfdbXrt4
	bpuofYFPA08x600wgnENWbgpjxXKLIN8rOC4Z4NcuQlSVb+AFMbjhPmCJhVVmz6s
	ZUAVoDUK9d7Ah+9hlFNs6jFwI0KOBEeGfTRxqA3Wlwt7E7WkJ/+knGKgAz9mSGZ6
	qCrrmmkuoEEp65k2ltvd6iOIpHncyXkh2/mzWMyTDMnmb65jnHrzID7OEyREd8BV
	4Hifd1BYRByYI1ZnrAhtL3CS0it53sBzqjIM4Kqp6PKq1eTK2EJIuj4bpJD8zBHJ
	tAJJh+f7lHKcAcGBFLfdxzD72b5/5b1LoaVHmS//UA==
X-ME-Sender: <xms:3paHZmdPqfGRZgRnKczH6C69cxMz_s9V9XBA25Yy2IXCpcfyIEx0kA>
    <xme:3paHZgN1V89JCnx9h4p8fom62PnrXtAkQvSo8SwgBA3cIDjLmi9lvmU3llAIx5MQS
    akaoGRUDAKxhhEY0XY>
X-ME-Received: <xmr:3paHZnjcgUtH4ec8_ZOvX90fKDOCKGg6jfI5g8VJDQQGw6MTuA0jDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddtgdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhephfgrsghi
    rghnucfirhptnhgsihgthhhlvghruceouggvsghirghnsehfrggsihgrnhdrghhruhgvnh
    gsihgthhhlvghrrdgvmhgrihhlqeenucggtffrrghtthgvrhhnpedvleegffehkedttedv
    geegheehhfegkeegffeuuefhvdffjeeuffehudejjedtleenucffohhmrghinhepuggvsg
    hirghnrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepuggvsghirghnsehfrggsihgrnhdrghhruhgvnhgsihgthhhlvghrrdgvmhgrih
    hl
X-ME-Proxy: <xmx:3paHZj8b4mWMxb0eIoygShhTLuRp289JWUXjc4k_Y-XjZsUx9Qdimw>
    <xmx:3paHZiv4F4I7uVjJklqtt-Tr7ANBeeAZfzBfsEg9VHqMpv_Ag7sYEg>
    <xmx:3paHZqHotX9dVQEcqtQKTZW_f0JvpOCoEFI53M6fYD3hXsdBcVYzJA>
    <xmx:3paHZhNEflT67Jq4z1eForHl2hzhIh_5j5veCE2IzmL22mFtcfapGg>
    <xmx:5JaHZi6CvnEOtxBPZ5Gh9GJsDU-kK8TLiFBZwWPmRcH9mTcxs06zNi8o>
Feedback-ID: i1739464b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jul 2024 02:46:49 -0400 (EDT)
Date: Fri, 5 Jul 2024 08:46:45 +0200
From: Fabian =?utf-8?Q?Gr=C3=BCnbichler?= <debian@fabian.gruenbichler.email>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>,
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
 	Fabian =?utf-8?Q?Gr=C3=BCnbichler?= <debian@fabian.gruenbichler.email>,
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
Message-ID: <2qwdfogh6jd5uixxjzlagmtfvnykk3x4ztqrn4j2v6qoref5rx@ooj6gq27bq4z>
References: <20240701183625.665574-1-ojeda@kernel.org>
 <20240701183625.665574-14-ojeda@kernel.org>
 <ZoeQVYda-AZN6PYy@gpd>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoeQVYda-AZN6PYy@gpd>

On Fri, Jul 05, 2024 at 08:19:01AM GMT, Andrea Righi wrote:
> On Mon, Jul 01, 2024 at 08:36:23PM +0200, Miguel Ojeda wrote:
> ..
> > +Debian
> > +******
> > +
> > +Debian Unstable (Sid), outside of the freeze period, provides recent Rust
> > +release and thus it should generally work out of the box, e.g.::
> > +
> > +	apt install rustc rust-src bindgen rustfmt rust-clippy
> 
> This implicitly covers Ubuntu, since packages are sync'ed with Debian.
> 
> In addition to that Ubuntu also provides versioned packages (such as
> rustc-1.74, bindgen-0.65, etc.), so in case of special requirements
> (e.g., older kernels) users should be able to install the required
> version(s) using the packages provided by the distro.

Debian (for building firefox and chromium), and uses a -web suffix for
that:

https://tracker.debian.org/pkg/rustc-web
https://tracker.debian.org/pkg/rust-cbindgen-web

cheers,
Fabian
