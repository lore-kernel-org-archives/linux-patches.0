Received: from fout6-smtp.messagingengine.com (fout6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DAC5576D;
	Fri, 19 Apr 2024 12:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713529177; cv=none; b=GxH6MbCpv7eqOkM5cVqpy3Wh9aEXn6lPhu4LqHfNQ5bZVFT1YFRQWM7Ji84ujQJipR7U4jMFWeKjvtDwGG/88cWrQ1xe0CSuqgAhjbv49TZpQ9mZtN4bKY8WJhDeaQhmoFT29fLdvolSb8mf3rPEF+jUOzUBkfNk9gJsbrpjYso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713529177; c=relaxed/simple;
	bh=/whT3z5v9d3GECrMYWOwGgUqcTc+ApynIFFO5vcP1Xs=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=o/aV/i4xP/ZgiU8s1zW3JpuNsSpfZxqXauM+00PfhJgw8fIuWwdxqTx3KvwhYDF9lBKxHdOegoRaXXlzeqmbg6Puophti9mPu1oFg51g3DIg2eM0YD7XSORPhW0AK95e+EPdUq1qoq+fXTdCOYDXpTAyRePgbvI1zHUlBpOXnEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Q8D9jSci; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LJ+aFUpS; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Q8D9jSci";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LJ+aFUpS"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.nyi.internal (Postfix) with ESMTP id 1C7EE1380259;
	Fri, 19 Apr 2024 08:19:35 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Fri, 19 Apr 2024 08:19:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1713529175; x=1713615575; bh=cDH8lSOwI7
	lw/vz2NbBtbId2tyQzUWt6KQXELxMEHy4=; b=Q8D9jScilsyTTkkRTPio2R0RLa
	GUt2L596HnWUE/TmLTpOeT7sHgLL+4puXyQtARJIsfUxFxR4GTjKsdXsexU7wjWW
	oyXrJQdnValZh3rxULoh+V2btb080ZF1iyVGPfRMv3hGKdiiFXX4JfrvbdI612iF
	xgBTkGg6EQhrHDmE2rdBfJS+hNQKalWNeWsL1U0pLxOusxc+ornlUPtFtN/SE/p+
	/jPGAz0/XtezFzRxJ8/ioIn2S5G0IgOvgAbD1zFKU9b7fOdlGdSEG15l4sAOtJtt
	YyK93/7VG5PEDSMd//O3trOFtU4zlI6T6rv98a9jexn3FHbn77CVJF8zgJyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1713529175; x=1713615575; bh=cDH8lSOwI7lw/vz2NbBtbId2tyQz
	UWt6KQXELxMEHy4=; b=LJ+aFUpSEHrpfuBbCzFEhbMkQD6iR2ON1ev8jNB8A2xM
	J3ImrKAVdi/z17wRrGgAUHkOPz3pYDeLzyfFpoWviARbmZ/+3lv/BE8n0f7d3IFz
	+0hwwoLj4zecQ0Gg7DpAcM41FLvNnHcgpkez/8Pm3Az+vrnCGEYaJnz6YfewPhA5
	/XE4JTiao0TxaiKUmdyulWbKjmElHuTgbOE1zsd0XprASqQwEpw/wWYNa+ycBjw8
	65F8unQMW7LaJ/7qVPI9HHdUie8diXWV95WfyvTRmSBYrQjlLDn4GgccpFrxubkW
	dt39IBmVb+ltgQKvIRVDp1T00DxIYROi15vkyJhd/A==
X-ME-Sender: <xms:VmEiZrlxdEOI8gTifpquVy8mQaJpR4ulGqY7UGMHukyx7aHbFJPM2w>
    <xme:VmEiZu29QuNk3x7WzIt6d9VRjg9j_W1c9q93vQW6ueBjyhAY4HSxZNhjL_QVJLyAY
    DstQl-jRDWgsIKu5UQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudekvddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:VmEiZhok6k2kXj6ApBIuWNDTlOdFW_lnM5D8ZZiBR324TJMOijHXdg>
    <xmx:VmEiZjkn_KFN3T-QUtxOXxeewTe3iVRTf9fzq6WQptTVCNqJSoBaag>
    <xmx:VmEiZp2taVa-TXQmYmaSMD-iJJS76rTSzaD3cU46i9W_hKI6KL_-ZQ>
    <xmx:VmEiZiuWnHCQct7gBlnvPxMNQYJxqpeEMDTzzN2ZS4kfxoPtC-UIpQ>
    <xmx:V2EiZnPDWLdSVOyi0UFi11nHl9ZTEptBbmQpY-7-2xEcfkHwjiB_RtnC>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id AF7C3B6008D; Fri, 19 Apr 2024 08:19:34 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-379-gabd37849b7-fm-20240408.001-gabd37849
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <1509513f-0423-4834-9e77-b0c2392a4260@app.fastmail.com>
In-Reply-To: <20240419121506.23824-A-hca@linux.ibm.com>
References: 
 <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
 <20240418102549.6056-B-hca@linux.ibm.com>
 <20240418145121.GA1435416@dev-arch.thelio-3990X>
 <20240418151501.6056-C-hca@linux.ibm.com>
 <798df2d7-b13f-482a-8d4a-106c6492af01@app.fastmail.com>
 <20240419121506.23824-A-hca@linux.ibm.com>
Date: Fri, 19 Apr 2024 14:19:14 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Heiko Carstens" <hca@linux.ibm.com>,
 "Alexandra Winter" <wintera@linux.ibm.com>,
 "Thorsten Winkler" <twinkler@linux.ibm.com>
Cc: "Nathan Chancellor" <nathan@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, gor@linux.ibm.com,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Sven Schnelle" <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
 Netdev <netdev@vger.kernel.org>, llvm@lists.linux.dev,
 patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Content-Type: text/plain

On Fri, Apr 19, 2024, at 14:15, Heiko Carstens wrote:
>
> Plus we need to fix the potential bug you introduced with commit
> 42af6bcbc351 ("tty: hvc-iucv: fix function pointer casts"). But at
> least this is also iucv_bus related.
>
> Alexandra, Thorsten, any objections if CONFIG_IUCV would be changed so
> it can only be compiled in or out, but not as a module anymore?

You can also just drop the iucv_exit() function, making the
module non-removable when it has an init function but no exit.

     Arnd
