Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E198DA461
	for <patches@lists.linux.dev>; Mon, 28 Nov 2022 19:57:50 +0000 (UTC)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id ED8655C00E9;
	Mon, 28 Nov 2022 14:57:49 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Mon, 28 Nov 2022 14:57:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to; s=fm3; t=1669665469; x=1669751869; bh=EhWJMM1p5W
	+r1kg3giwYu9gUFHXT8JN007h39JPV/cY=; b=DDj2pdPXxurjonkJMVVVtu7CsL
	MaZ0bXONSaf6WAeKSY8MwU77nU4uAP5lBiiMOd2G3hgSTjAiexZJei4gX70wSgBk
	aaVGk0x5hAsZ8xtTHjppOqNQSzkg3lthKS1ZNkzzBIE3e+fawCeyncqUMpwhGKc9
	jNYHBc5vl3vhdeEJw43kSe9OJif7g9UwqHLjY4ypv2oEV/cpKqdY3xvVrhCSrO08
	2i5vKEcsKFbJUUD0hXDmkQptZe8bP8POfIKxh2u/sd/kZg3JylLSJkmNa2Mmn9mN
	8PeE9e2rWjtyBGuaHMhMT0fz5pboLBqyl795RmYL+icDsQBWJTnZTi3kjoVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:sender:subject:subject:to:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1669665469; x=1669751869; bh=EhWJMM1p5W+r1kg3giwYu9gUFHXT
	8JN007h39JPV/cY=; b=wvoX67+tP4fH+Kggip5vgDZlRgQAH4Iz7lSN0Cd2IVw1
	K8E+CCRy+dV4Z/0FUQ1gRXVfO+n27XWq9gjl4RT36n+2/4rLylI1l7644SgJGCwS
	J203bc+f4YcmI6AxPToMYYOQgdBPLl2YiVMbrFH/voINQjyG5z+9NrW+9Fly9vO9
	EVbcjm2ku6TWV4im3Bsf/p//6C1ESjC8PVyFus03/pKY1rxJ62rqEZ+X4vVWijyX
	9nqvwM3CAir0MGC0wJyC1lMiRL6AvS232kAgiVifYXwgcMy8xaWzwbARy/MkdFGE
	E9P5YJsjBisLiaIY5zfVrmZq3ODckLy15x0Rx0iNnQ==
X-ME-Sender: <xms:vRKFY_Ef-Gsw86_671377XRmPqcMP5kAcozUeeyDc0DlVE41WrqBag>
    <xme:vRKFY8U7ep2Y5guergsRMVW3KKvdnlKYdivjbyt7auh0PyJn9lLFIuvXcbMQPKbRh
    by_dyuJXcrezsLvX8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrjedvgddufeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:vRKFYxLJusVyl6kycHwUsCVZVBGFU2GUQ9J8WXmBNvvUGkg9ryPslw>
    <xmx:vRKFY9E0qT4eNPmtFmnfKzscBmoBtFAWPbMw0c4ugva4eH0tsfShPw>
    <xmx:vRKFY1UHb95TRxAHfuA40nU3Fe_R0i0eKWT-3LPFcwiNmWD8Z06_Gw>
    <xmx:vRKFY-MYKhtn4_EW9qVFaf4ID69McpBXifc41tXSs4Gzybi0AHR8fQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 6E55AB60086; Mon, 28 Nov 2022 14:57:49 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-Id: <cd01e0b4-579f-48fc-995f-6e1acebd02af@app.fastmail.com>
In-Reply-To: <Y4UKpP7/NOwPIkYe@zx2c4.com>
References: <20221128111829.2477505-1-Jason@zx2c4.com>
 <20221128111829.2477505-4-Jason@zx2c4.com>
 <8f9326ba-f879-4b9e-9e5d-b65cad7cd726@app.fastmail.com>
 <Y4UKpP7/NOwPIkYe@zx2c4.com>
Date: Mon, 28 Nov 2022 20:57:28 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 "Thomas Gleixner" <tglx@linutronix.de>, linux-crypto@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Adhemerval Zanella Netto" <adhemerval.zanella@linaro.org>,
 "Carlos O'Donell" <carlos@redhat.com>, "Florian Weimer" <fweimer@redhat.com>,
 "Christian Brauner" <brauner@kernel.org>, "Samuel Neves" <sneves@dei.uc.pt>
Subject: Re: [PATCH v8 3/3] x86: vdso: Wire up getrandom() vDSO implementation
Content-Type: text/plain

On Mon, Nov 28, 2022, at 20:23, Jason A. Donenfeld wrote:
> On Mon, Nov 28, 2022 at 08:18:12PM +0100, Arnd Bergmann wrote:
>> On Mon, Nov 28, 2022, at 12:18, Jason A. Donenfeld wrote:
>
> That's more or less how v7 was, but Thomas thought the x86 stuff should
> be separate. So for v8, the organization is:
>
> 1) generic syscall
> 2) generic vdso
> 3) x86 wiring
>
> The primary advantage is that future archs wanting to add this now can
> just look at commit (3) only, and make a similar commit for that new
> arch.
>
> If you think a different organization outweighs that advantage, can you
> spell out what division of patches you want, and I'll do that for v9?
> Or maybe this v8 is okay?

My interest is that at the end of the series, all architectures
are hooked up with the same syscall number, which avoids confusion
and merge conflicts when we add the next syscall to all tables.

How about one patch to add all the syscall table entries, and then
have the x86 specific change just turn on the Kconfig symbol that
actually enables the syscall?

     Arnd
