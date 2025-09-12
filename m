Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC64270EBF;
	Fri, 12 Sep 2025 08:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757666952; cv=none; b=tG0YQg92Uf5WUtP1jxyGk4OTENQ2auWd3oOf5AddNr1/OW7jf7y9T8FBK/tMYxH7MlLPb11M0CGDr1RgAFvVxdzGR+a6GmaMqYA1kSMh7XljMyuFQy27t/lf2soS1mHeeMdWPn7cnwipn92FtLaRfI2o9OfQzs1fVljexM1aFfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757666952; c=relaxed/simple;
	bh=gfR34RXEEGjWW5IkAv/DEgJ1H1uM00GnTDkWz4vxGtI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=TOfTMSDkLbX5qROVvph2KT1/rzcirfKa86+3XEFDMrG+GACqz2cHHX+twl7AEhFnlMkBPtLYuTg52TFgSstKbOZ3ZwwEUJ3Snb40cStCezQsFkwfDJUXpX6bHzdijFnOP9Rb3hdu7A86uQd3qBEiPhLc9N6pQZGTz8NARx8FiF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=PI5cAE5l; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Gq5/r5jv; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="PI5cAE5l";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Gq5/r5jv"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 15A611D003F4;
	Fri, 12 Sep 2025 04:49:09 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Fri, 12 Sep 2025 04:49:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1757666948;
	 x=1757753348; bh=+p9GzJieOwhor5aWURPNM9zhi5lxCVgpWYiOO0XBHPQ=; b=
	PI5cAE5lN6QR+1vzg9lgHqhcqy1+SKUF6XrVxFZgShVCecHaYM1azq348NJCXbkK
	/YGJfqMdXMOeHyfTOUFbRHOAIXiH6aWtPI9wSfvN+60Q7wGIr24RI4B0dpvpZ5Xw
	o1n8tUL5nwJz1LQFZIn9n7/kr0r49BLkrXRIrTntdPbi75zuqQg6LHLenlCwqk9u
	QUIaQd/lmOxiibz4h0NwLpUbGkkimfJEcaaJ4wPb0cWa8De+TLe73/Z+sF61R49J
	xvs5qED1VzG2SjDC+AOj2QjEaEFwcwCWzodVZ5RupEo7IqYgKQ8VcNAVWjzMxfE+
	4eViwyYYIM1N6DG6AkRKcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1757666948; x=
	1757753348; bh=+p9GzJieOwhor5aWURPNM9zhi5lxCVgpWYiOO0XBHPQ=; b=G
	q5/r5jvWs1/BOFzwRgD04ps4BGfCMiE2Oc1Ezi5D012RKJIR/sJj8QsOua4woWCy
	wE8CAtXCCZQ7/EjAaiDCZYxj2WgK7b7QNOWSgf8PC9FHGxSVxtuV1awZY4XsoPLx
	9ABuwMjrxlkLHT39EDvnsqRf7w8Ex4JL7k34jS1eS+OPbsK260p+DSglCZiWKLEq
	ioPaz+IgG8XfmDDDEoU6kS3sQzSrm7DdRzp2Foijvgpb0f1v4zOqncNYlha4DTOo
	9k1wgfaNQ9FA/Bq4W621/cX1hkL3ByN+nI8F/XXTOF3U/l31nyeOVrH8/AegKh78
	tQJ7cIlTnWoNmZWT+oZvA==
X-ME-Sender: <xms:hN7DaHzWP0G7J1chBD9rBGDiWV9pbaiy7ceyqwGdnl9A8W6XUqGzwA>
    <xme:hN7DaPTWJ617wAXHqOs7qAMhN1gWN3aJ_099dbYEGqPAeRrIUqdYhkMfihvbN3Njv
    s5I8OYUlsF-ddzu_n4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvkeeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogfuuh
    hsphgvtghtffhomhgrihhnucdlgeelmdenucfjughrpefoggffhffvvefkjghfufgtgfes
    thejredtredttdenucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnug
    esrghrnhgusgdruggvqeenucggtffrrghtthgvrhhnpefhfeejhfevudegkeekjeevgeet
    gfevfefgueegtdekudfhgedtgeegtdfgheffkeenucffohhmrghinhepghhithhhuhgsrd
    gtohhmpdhllhhvmhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduvd
    dpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepnhhitghkrdguvghsrghulhhnihgv
    rhhsodhlkhhmlhesghhmrghilhdrtghomhdprhgtphhtthhopehjuhhsthhinhhsthhith
    htsehgohhoghhlvgdrtghomhdprhgtphhtthhopehmohhrsghosehgohhoghhlvgdrtgho
    mhdprhgtphhtthhopehtohhmihdrvhgrlhhkvghinhgvnhesihguvggrshhonhgsohgrrh
    gurdgtohhmpdhrtghpthhtohepmhhrihhprghrugeskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepnhgrthhhrghnsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmrggrrhhtvg
    hnrdhlrghnkhhhohhrshhtsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtohep
    ughrihdquggvvhgvlheslhhishhtshdrfhhrvggvuggvshhkthhophdrohhrghdprhgtph
    htthhopehllhhvmheslhhishhtshdrlhhinhhugidruggvvh
X-ME-Proxy: <xmx:hN7DaFN6ktGAzX2citag5xjmrnFbnZ2xqqv4Qog_XAMAWijJWBdMjw>
    <xmx:hN7DaFeKtg1DXHM_1ctiU658VQRTht6iVRYOADbVWuJTiH24g6vsmA>
    <xmx:hN7DaG4E_W45TghQdvb3NuWhCa9RnbTIxa617cZqGhVOC1K8VRLBiA>
    <xmx:hN7DaHIEldT5yTfNqFOw9uk3ZsxRjUzKXecM2Ze-Au1Bv2tu0Z1tsg>
    <xmx:hN7DaJFUyx53S3C9MgBGfHQgw0-l6xHdz_jxOBexZZnPt6X7MZ1HSoyO>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5F752700065; Fri, 12 Sep 2025 04:49:08 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AUnaucIrvcY7
Date: Fri, 12 Sep 2025 10:48:47 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nathan Chancellor" <nathan@kernel.org>,
 "Tomi Valkeinen" <tomi.valkeinen@ideasonboard.com>,
 "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
 "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>
Cc: "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, stable@vger.kernel.org
Message-Id: <6bb9a15d-ecf9-4fdd-b118-cb4db108483d@app.fastmail.com>
In-Reply-To: 
 <20250911-omapdrm-reduce-clang-stack-usage-pt-2-v1-1-5ab6b5d34760@kernel.org>
References: 
 <20250911-omapdrm-reduce-clang-stack-usage-pt-2-v1-1-5ab6b5d34760@kernel.org>
Subject: Re: [PATCH] drm/omap: Mark dispc_save_context() with noinline_for_stack
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Sep 11, 2025, at 22:24, Nathan Chancellor wrote:
>
> Cc: stable@vger.kernel.org
> Link: 
> https://github.com/llvm/llvm-project/commit/055bfc027141bbfafd51fb43f5ab81ba3b480649 
> [1]
> Link: https://llvm.org/pr143908 [2]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
