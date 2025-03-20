Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB731DC05F;
	Thu, 20 Mar 2025 22:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742508193; cv=none; b=h6YM251v4NMGR0hEasjRmre+KqguLgvkOIntLBp8/f7tljz/RqtST/hLXbmVXt3dsOfDPx1PrJyCT5CnzCCQWwlPvjzD29njoGN1Csaf2IzNMcWkPapyOD0K/3U9hbgyT1UX6JK1LpT8RbNMkiB6LwLnH+ClC7DubWZvDXEUuPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742508193; c=relaxed/simple;
	bh=o/NoRaNjVbaZ9od2IyCqGECRMJQPgyEg8JJo7vsV2r8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b5GdsDxiNR9T6rebaNMGrb9xW0xQQRw7MFuzgQ7UFZlsJNbRnh4Sx+V5bnwx0k9mwxVEB2+fB4Fi+X0AXLo2n0Ekhu2Zddu03X4+Q16JPSIE4ibIG+rulzflomWIi4yMBaKJAz9tHgYiFfptfTLmmcYhhl/Cp00YfCiVFvQHNWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=BGuP+IQy; arc=none smtp.client-ip=217.70.183.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="BGuP+IQy"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 96B6D44364;
	Thu, 20 Mar 2025 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1742508187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q9ANWztryAtzgs9DRNwfWIv3Pg0tyATZHHdZaolpDOY=;
	b=BGuP+IQyk7BHW5sC3FOEVRzpV0bZKhxuuSXJ3EQgav8x4Vj86p9Iw6osoIrkzejmfEleML
	c9UcXzN/7Ds8rib6jllcHjvCBSw+UoU5ByU1aYzkxcQ0+R7gaapu7pGFkku3xe3wLBjUJJ
	3yrwbMpxzrsCXz/q9mepxDs7sTuCMt8f/pcoUI8Iq2j68RnaXFDrdbHNsxGmgQYFE+67YO
	eP4IfL+c0wBqwdaWeO8N2Emis4FAV7pOfxNrVGpDkbJV3ggwZ3GcDe0eBAR2ua7GDr1vQI
	FtXUMvOxxGLsCNEQ/SMi6ILGky2/TcE9uMM+8Iu6EZQbPC4gI+UrF1wdR+9QDg==
Date: Thu, 20 Mar 2025 23:03:05 +0100
From: Alexandre Belloni <alexandre.belloni@bootlin.com>
To: Miquel Raynal <miquel.raynal@bootlin.com>, Frank Li <Frank.Li@nxp.com>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Stanley Chu <yschu@nuvoton.com>, linux-i3c@lists.infradead.org,
	imx@lists.linux.dev, llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] i3c: master: svc: Fix implicit fallthrough in
 svc_i3c_master_ibi_work()
Message-ID: <174250817539.3598269.2833694260995006704.b4-ty@bootlin.com>
References: <20250319-i3c-fix-clang-fallthrough-v1-1-d8e02be1ef5c@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319-i3c-fix-clang-fallthrough-v1-1-d8e02be1ef5c@kernel.org>
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddugeelfeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetlhgvgigrnhgurhgvuceuvghllhhonhhiuceorghlvgigrghnughrvgdrsggvlhhlohhnihessghoohhtlhhinhdrtghomheqnecuggftrfgrthhtvghrnhepieejfefhffekjeeuheevueevjedvleevjeetudffheeutdffudefjeduffeuvddtnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpsghoohhtlhhinhdrtghomhenucfkphepvdgrtddumegvtdgrmedvugemieefjedtmeejkegvtdemtgdtvgekmedvkedtieemkegrtgeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvdgrtddumegvtdgrmedvugemieefjedtmeejkegvtdemtgdtvgekmedvkedtieemkegrtgeipdhhvghloheplhhotggrlhhhohhsthdpmhgrihhlfhhrohhmpegrlhgvgigrnhgurhgvrdgsvghllhhonhhisegsohhothhlihhnrdgtohhmpdhnsggprhgtphhtthhopeekpdhrtghpthhtohepmhhiqhhuvghlrdhrrgihnhgrlhessghoohhtlhhinhdrtghomhdprhgtphhtthhopefhrhgrnhhkrdfnihesnhigphdrtghomhdprhgtphhtt
 hhopehnrghthhgrnheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohephihstghhuhesnhhuvhhothhonhdrtghomhdprhgtphhtthhopehlihhnuhigqdhifegtsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepihhmgieslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehllhhvmheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehprghttghhvghssehlihhsthhsrdhlihhnuhigrdguvghv
X-GND-Sasl: alexandre.belloni@bootlin.com

On Wed, 19 Mar 2025 09:08:01 -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   drivers/i3c/master/svc-i3c-master.c:596:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
>     596 |         default:
>         |         ^
>   drivers/i3c/master/svc-i3c-master.c:596:2: note: insert 'break;' to avoid fall-through
>     596 |         default:
>         |         ^
>         |         break;
>   1 error generated.
> 
> [...]

Applied, thanks!

[1/1] i3c: master: svc: Fix implicit fallthrough in svc_i3c_master_ibi_work()
      https://git.kernel.org/abelloni/c/e8d2d287e26d

Best regards,

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
