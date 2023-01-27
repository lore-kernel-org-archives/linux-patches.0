Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CFC5221;
	Fri, 27 Jan 2023 21:56:27 +0000 (UTC)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 5BFBE5C03AB;
	Fri, 27 Jan 2023 16:56:26 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 27 Jan 2023 16:56:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to; s=fm2; t=1674856586; x=1674942986; bh=M33WKsccc4
	6ZtlJ53/rvzaVY8Fx6Dq1FfgapdCcpWUE=; b=QHf91aGWZ96GRIzdEmq3vGZ1/8
	KZXGlxB0SJtdMPHiFt1ewL8bfOd4TtoBYZJyksSkgPeDfdfGoxKXAAfSc4TAElAV
	mw4i4ssv5+DSQ2NEN5dhOcTcyEWWDdmSDOWiOHALFt8p7MZsMLSpgPInQqDyYlzO
	/fI2vKL4bf2sGJ54Gch/1dJSFFKFDQaq0eEf96MPUzVUjOAgL172M/oFd3vA9tO7
	MxvagCKkdz3y8COfTZsUvwcXThfKuCPHS7JKALJPbNWR6znmXd5INQ14XAzLbaPG
	5jEPHcdH5NZoOnb5YQg31D3HNdVJOBb9/OXgtBEW3yprm1Wd1qQ2dpVEuRMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:sender:subject:subject:to:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1674856586; x=1674942986; bh=M33WKsccc46ZtlJ53/rvzaVY8Fx6
	Dq1FfgapdCcpWUE=; b=ns9wDMj9nhMtfnHP8bOaKP/v7NRKpLv1DDiVUHXtox0E
	v9pyXYRJdE9d7i6ttHjNN1RUST7xsjlNtzfvlTilofEljVskLVkJnkVv7R/IKTN/
	xuc4Mg7lLguFPb9q36rHZt/zTDSZYF1X4qEDjHCTXlYQa5MqvmQcq5bRYRnzaXh2
	GAsEqkJMtrXQ4pS9P7Wkuh408b/dBTnZPFtk0P5K3NkyMCPVjyHuJGsairZ8NDJn
	g2PPQzGWoEiPaVvmK2Qv0Lv+1k8pMZM2KuuJAsEzGkqYtUpyKQkxTz4iLU2X+HrU
	xAgqlwEHL5CPUxugTyD1WPA9bBR/wkrpv1geYb5QTg==
X-ME-Sender: <xms:ikjUYwfPlTPy7_N_QQJ1sYuGZO3gpWZcaMWxEl-WImXeeBcHO4MmgQ>
    <xme:ikjUYyOMM8NavQu4egUvdt4ZBWnYThoGKiig4fAEFTKlhGn-xaur7RUKS5GwueeD9
    BiQZXbjKFec-l2LT1M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddviedgudehhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeejvddvvdduleduheejiedtheehiedvjefgleelffeigfevhffhueduhfeg
    feefheenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:ikjUYxh1fu6ggMw8yUbvu2dJcypTYcQe_G8emTYnmczvGgnnuyGvnQ>
    <xmx:ikjUY1_XDjAUujQfmJObn-pnZGTaU3kQ8ptVeActEU4Xd3bV5XBewA>
    <xmx:ikjUY8vRqPXY6_NBF0iMTqaoSBH9SCnFwXpbmx6QT77Y8v-x3LAHuQ>
    <xmx:ikjUY2XaMyAdXhusHrY5uAzY8IWDuli73UY_KDHlxWMMHo9LcffWrQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 12D63B60086; Fri, 27 Jan 2023 16:56:25 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-Id: <1206e990-23b3-44c8-97c9-869ec0aeead0@app.fastmail.com>
In-Reply-To: <20230118-v4-v4t-lld-16-v1-1-e3d9a00ae47c@kernel.org>
References: <20230118-v4-v4t-lld-16-v1-1-e3d9a00ae47c@kernel.org>
Date: Fri, 27 Jan 2023 22:56:06 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nathan Chancellor" <nathan@kernel.org>,
 "Russell King" <linux@armlinux.org.uk>
Cc: "Nick Desaulniers" <ndesaulniers@google.com>, "Tom Rix" <trix@redhat.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] ARM: Allow pre-ARMv5 builds with ld.lld 16.0.0 and newer
Content-Type: text/plain

On Wed, Jan 18, 2023, at 20:22, Nathan Chancellor wrote:
> Commit 6a7ee50f8f56 ("ARM: disallow pre-ARMv5 builds with ld.lld")
> prevented v4 or v4t kernels when ld.lld will link the kernel due to
> inserting unsupported blx instructions.
>
> ld.lld has been fixed in current main (16.0.0) to avoid inserting these
> instructions by inserting position independent thunks instead. Allow
> these configurations to be enabled when ld.lld 16.0.0 is used to link
> the kernel.
>
> Additionally, add a link to the upstream LLVM issue so that the reason
> for this dependency is clearly documented.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/964
> Link: 
> https://github.com/llvm/llvm-project/commit/6f9ff1beee9d12aca0c9caa9ae0051dc6d0a718c
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks a lot for getting this fixed!

I gave this a spin on my randconfig build setup, which showed
nothing unusual.

Tested-by: Arnd Bergmann <arnd@arndb.de>

Please add this to Russell's patch tracker.

      Arnd
