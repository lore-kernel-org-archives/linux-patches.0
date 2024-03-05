Received: from wfhigh7-smtp.messagingengine.com (wfhigh7-smtp.messagingengine.com [64.147.123.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B689818AE0;
	Tue,  5 Mar 2024 22:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709677241; cv=none; b=YLAsceXwxTEFUscdBRCESSWS6KRDmzOuulyxxHFIMk2fZyqm2z1buGOW2l3F1culj0DHOcEMqWf90TqI7bqaIouotQWcfE1n1XRfLTnwdmdv0gJSicBVxr6PYEaIDDozLPZJnyzgL9UdU7+1kCKNS7eXP+lFjG5DUp9ptm1i30M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709677241; c=relaxed/simple;
	bh=cJSh5WC3TcK0ncHmqJarmaVKE8EIju9DrUGMpqKeeDM=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=tb7mYzbfj6qunMHsIEKnI1D9hP4AQYjdsk3Lnx8R4qfus2QJUySz4U9G1tlZ+3GNeEoN0tSK9zQf3q7sUs1fqKR3yYLd9i8mNNWeWvBM2cUAsKpZuAfXG46xDoI3ViowWbmK8ab7B59ZloGU1mFPIY5Ooe3UKuWIExBSMbvuGH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=TX0287BY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=G0DfJrRK; arc=none smtp.client-ip=64.147.123.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="TX0287BY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="G0DfJrRK"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.west.internal (Postfix) with ESMTP id 13D131800098;
	Tue,  5 Mar 2024 17:20:36 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Tue, 05 Mar 2024 17:20:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1709677236; x=1709763636; bh=RA76mlg5ek
	lvGZW+o1Volc1xu5PRh1gUrgo0OjPyH3g=; b=TX0287BYzltjF5Xh/4uZkmu2Gq
	HuthSWmXtI2eRv3aCncstXaerbHdw/M8whWb5/5/8zIZjWKcKFylfZHsetGqSqQq
	lLMeaZc+i2DnHPiC6H1IHmiiO5ae7vKa8nstMs+m5C74y4e/A41QBrbB1TEyRYfj
	YSstRSW6APDSjLK56d9Xxx7ShxxBqOx2sHmYd3y0iuxLlQRqRuTurATHx7huNVXz
	Ih2W41s4627IeLByV8FUs2yNPJ4GGTlcEhO4yNO7bbp0nFETCtF8QFu6RbafJVnr
	SgiWdzYhVs5ErNG2Gzt4/eqk7DBDEaeELSApV8iai8VLvpfr8+8pUDKgY0KA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1709677236; x=1709763636; bh=RA76mlg5eklvGZW+o1Volc1xu5PR
	h1gUrgo0OjPyH3g=; b=G0DfJrRKcZiGwgk8umVmB3KPG5xKuM7ErF6L5lhnyK0d
	xL9jtOraNTxHsld3tZjm2y0JFM+L7bm1kujBgfcBtfJruw1FoWYEtKYiCLkNnkJ4
	KJ8Vy/6fPfAl10m1Ga5FhPAmP6rKgli1FkuYz7jk0CVzrnT0dDTxU4gEtGJSCkBj
	tlIe89zzWuWg8F7jDT7IJSukb1N4YxCjk0Qalhhyk+sFqNa11by2n6+w+/lHriGe
	RRqUbknWPjDReraVRYTIhbjQSgWI09l7p41zDb4FSlGHSVvepWZMCkZ+d9UthPUV
	ZTnzpqg2ScfToa0E9yroXGH7nsxz+A1kVCx4st6N+Q==
X-ME-Sender: <xms:tJrnZdZHU8FUPwdhN8pHBSG3KeWBI7qBaW5ZdBQBvw0_dNoWDENViw>
    <xme:tJrnZUb2PThJOmY4A7PeRbJGwglgi_NJ25ITt0FfYnTIT1ybCYC-nA0R-_r18-kkh
    x2cjNTJZdDvkOZbMGU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrheelgdduheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepjedvvddvudeludehjeeitdehheeivdejgfelleffiefgvefhhfeuudfhgeef
    feehnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:tJrnZf8XjVEGSMMrr0aCdWH1HiDXpdRoX_9CMUplrSQ-sK8ZQCCPEA>
    <xmx:tJrnZbq9mQKjkioGoH24LduwI_BsGWSvR5jkcZupdzvPQ58AFCtlAg>
    <xmx:tJrnZYqopqvoQ_lb02v4x5G0n0MmPNmKth11otlXqkXsPVYZegMrNg>
    <xmx:tJrnZVhxkJF-dWxna-47-jhpq_TMhy2CSBWqzgRNUlrHCn-Qpk9J_KIxcPY>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 252D9B6008D; Tue,  5 Mar 2024 17:20:36 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-208-g3f1d79aedb-fm-20240301.002-g3f1d79ae
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <06e56321-61d5-43f3-83e7-c583e053e600@app.fastmail.com>
In-Reply-To: 
 <20240305-disable-extra-clang-enum-warnings-v2-1-ba529ec15f95@kernel.org>
References: 
 <20240305-disable-extra-clang-enum-warnings-v2-1-ba529ec15f95@kernel.org>
Date: Tue, 05 Mar 2024 23:20:15 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nathan Chancellor" <nathan@kernel.org>,
 "Masahiro Yamada" <masahiroy@kernel.org>
Cc: "Nicolas Schier" <nicolas@fjasle.eu>,
 "Nick Desaulniers" <ndesaulniers@google.com>,
 "Bill Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 "Yonghong Song" <yonghong.song@linux.dev>, linux-kbuild@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2] kbuild: Move -Wenum-{compare-conditional,enum-conversion} into
 W=1
Content-Type: text/plain

On Tue, Mar 5, 2024, at 23:12, Nathan Chancellor wrote:
> Cc: stable@vger.kernel.org
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2002
> Link: 
> https://github.com/llvm/llvm-project/commit/8c2ae42b3e1c6aa7c18f873edcebff7c0b45a37e
> Acked-by: Yonghong Song <yonghong.song@linux.dev>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
