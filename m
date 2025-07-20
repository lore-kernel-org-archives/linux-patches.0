Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17319AD24
	for <patches@lists.linux.dev>; Sun, 20 Jul 2025 01:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752974769; cv=none; b=TXHTI28eKVtlz671mmFrTHC+rRs07iYls8g1cud5ZuB1ydIVweZLopFpX0WYvX5viQQ8lXcZ+4kO8aLR/W5AFGbHXDik0r6Uvw+9s6dlGcVvlK4/8yqyXK60Jx2od9v/yFSSlj6jkh4fCh3TaovuioREo7xPapjgFSLAxbTqLtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752974769; c=relaxed/simple;
	bh=M5v8j/MbUJSw56NDaZKEqyXgTiM8XeO6qX4gT3RlSPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kr4cSwionyxmPBOrkcEXyMCi/iWJj0ukZNQrewSR6wro9WsLuPoWE8I9IDigOMIk3RWfh1PeeVoZAC37xNqulT0G93Tm+qRN3bZxGbULhTqFI8FbKVaibqG8ovsDqjXHYm/0sJ/pdTRcGF2G1K76/KaekiFIxWx/wJV5DP16LoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GiC+jMBL; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GiC+jMBL"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ab380b8851so29161541cf.2
        for <patches@lists.linux.dev>; Sat, 19 Jul 2025 18:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752974767; x=1753579567; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:from:to:cc:subject:date:message-id:reply-to;
        bh=H4YkocWtLM+MV9VqVW9r5H/qPxJMGyUCFlNySJ25hYk=;
        b=GiC+jMBLJcfFgPGja47q6Cdu9sE0kdYsitYg4MMp25BLOgz7QYdQ8cRvkW6fAzCvGj
         53BNvL44h7xxbxQdO8KCzt2pZ5uV62RmQVj9ViFRJ/ZpxzuARuhqS3zlPtFGO3oIFldg
         RfMm34SZQ8D1GzE8HL3CJbrRbAIvZJJgtn42ZNJpTT3hMBM46lgMohzlUTzrpgwTSyVS
         JzORPLF1u4VBZ0x9HBB8YBwEvl51Ej8pOQC+lrq+vlIL85b2UXZjK2ZJnYzUBKLfiykb
         AamJMSr1t2BjEDA6noKaZw506o3hhWlsK4LOdS2qhZW4/b2hMLG/UMJKnmpq4k9EKaak
         6I3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752974767; x=1753579567;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H4YkocWtLM+MV9VqVW9r5H/qPxJMGyUCFlNySJ25hYk=;
        b=Vx0wULPnbTYGaQPadwQeNcsK1YAwWvvHGa3PQmstG+OTuL/Axj/uKq1pc78+/EF+pz
         C78LJu43GO3kXPYpR4uVyK1AMHXv1PgcE+Udaj1qiULeoAcMkkhdeOe4eOC9u+rN/a+Z
         J5bJmLRpc2pwocNv13UpxYfkkV3JRKSZWonYZZ7oI/Xe4FCkGHvy0gO1NX/LqC5TrYLy
         WBsDrqpXl6uPOPejn52LUTCFc4/zf74xRrg2WhDOFzFxf8b5eL2jWc+ET+/OaYYpV+Fd
         rn/3IUk/kbPL/cdF4PZtHb9ewPK5f5KC9kvGMb7nf9fggjs8hdc13ATWr4MsCk+GEcdd
         3rEA==
X-Forwarded-Encrypted: i=1; AJvYcCU5h7JMdDFRpe2WNnKYvQNevVPDwWB9AYPlFhIZF7VX1SNH1VGAL96AqrzQcZOI6ufmVjpSvHPr@lists.linux.dev
X-Gm-Message-State: AOJu0Yx42ipHHWgwfy7NHBLDqs70sBgSIOobTZSOz6XJovg2f2tT2pX+
	Ts9NyG7EYUsvGSREf3zfInBuvgqJ0hnaH5z7bg+gR1YJ6hebha+qM9s0
X-Gm-Gg: ASbGnctu7SEC82Kf6lnXXegLiXtTRqC1XbdNQLy1bnr+gKrtIsFzYg8b2bNsw/m0lQK
	T6CgqaUXwPCV0RQJH2/rSMRn7blx67BGJZ8rq5nK1gTxVaeDMzYfJN+QGaHIQQfxCwuGLCIYdpB
	0IW2TYud7xR1jmA5fxpCxgCHWWBR9NYOIVV0PeIO0NTXKhP/mhY/Ff9MNM9L4mXwiNSJsMEtxoY
	/oZMmCQp2XkHNM58FBDrIy3deT92N5qw4lt3+o/zDTLp8b5lcfOotV8DT0kErpdqeKaDBj78+mx
	oNIfnoT2lmh4hZJ5N5ksfj/Ay7DD3LaC1NbsDZ0Bdq35tvPUtuufpoUAhlcf+NMbj4TvVQvxEi7
	RnCjyMa+kv4sJLfyv1D6B9Z/k29FgPwNcsbeoU8O1KDN2cXffj7WFxXXHrhKvFp1GiDb9b4Zzs+
	KSZRMhQ+IxJmY84N35U7AZeOM=
X-Google-Smtp-Source: AGHT+IEWeJHBnozEVYV+zCWV/y44rQfzmFwYBgyuanGFP4F26GarMSuN2OTUeRI3QpjoEguzfIT7cw==
X-Received: by 2002:a05:622a:13d2:b0:4a7:2f49:37d6 with SMTP id d75a77b69052e-4ab93c509a8mr229433761cf.5.1752974766930;
        Sat, 19 Jul 2025 18:26:06 -0700 (PDT)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4abb4b2643dsm24368211cf.53.2025.07.19.18.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jul 2025 18:26:06 -0700 (PDT)
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id DB245F40068;
	Sat, 19 Jul 2025 21:26:05 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Sat, 19 Jul 2025 21:26:05 -0400
X-ME-Sender: <xms:rUV8aGtL_yI2duiIFRu3swL3rqMPKft3UOSRuXO2aayCLbl8RjcFbQ>
    <xme:rUV8aGJExnP5Ar97sZVwfXJcLcY9JBuHOCK_N-OTGYyWJ4QEgTFMDTY4KPuEFeCFI
    425fWlDRa6Wk0xFAA>
X-ME-Received: <xmr:rUV8aKfztCBxfwfIgCebLBldkKVVwJRG6DXdFBe8PYNeX5a_K_MJ8Cu_pQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdeijeeklecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtth
    gvrhhnpeejhfeikeekffejgeegueevffdtgeefudetleegjeelvdffteeihfelfeehvdeg
    keenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfh
    gvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgvpdhnsggprhgtphhtthho
    pedujedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhhighhuvghlrdhojhgvug
    grrdhsrghnughonhhishesghhmrghilhdrtghomhdprhgtphhtthhopehtrghmihhruges
    ghhmrghilhdrtghomhdprhgtphhtthhopehojhgvuggrsehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopegrlhgvgidrghgrhihnohhrsehgmhgrihhlrdgtohhmpdhrtghpthhtohep
    ghgrrhihsehgrghrhihguhhordhnvghtpdhrtghpthhtohepsghjohhrnhefpghghhesph
    hrohhtohhnmhgrihhlrdgtohhmpdhrtghpthhtoheplhhoshhsihhnsehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopegrrdhhihhnuggsohhrgheskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheprghlihgtvghrhihhlhesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:rUV8aIVq3amHiwemn9ps7odTlSGCPiMOM_Bj247joP-p5M7gHC5f_Q>
    <xmx:rUV8aIiX2hJYNu82rcdkrXJWUm5J5g-C4b7AiGkO-dRUFUsSyHTe1Q>
    <xmx:rUV8aChReM-azl9rVPaXidEE8faUNNo2-_Pz8MvwohobH8ROzcDR7w>
    <xmx:rUV8aNtWqhJYl4Z0xulD53gOaqci6Z0yOJBrULjOBJt1op-Qt8FNYQ>
    <xmx:rUV8aAtwMwVwsXGfVnYHvV_e48zci7d-d9FdTnZF9s-nfgLlGcBbng-K>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 19 Jul 2025 21:26:05 -0400 (EDT)
Date: Sat, 19 Jul 2025 18:26:04 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	I Hsin Cheng <richard120310@gmail.com>,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] rust: list: Add an example for `ListLinksSelfPtr` usage
Message-ID: <aHxFrK39YKEpKV9x@Mac.home>
References: <20250719183649.596051-1-ojeda@kernel.org>
 <20250719203646.84350-1-boqun.feng@gmail.com>
 <CANiq72niUM8YAiVWooxAPCy3c3Yqt6_1fjW2HN7TVLnmL_GQMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72niUM8YAiVWooxAPCy3c3Yqt6_1fjW2HN7TVLnmL_GQMQ@mail.gmail.com>

On Sat, Jul 19, 2025 at 10:54:45PM +0200, Miguel Ojeda wrote:
> On Sat, Jul 19, 2025 at 10:36 PM Boqun Feng <boqun.feng@gmail.com> wrote:
> >
> > It appears that the support for `ListLinksSelfPtr` is dead code at the
> > moment [1]. Hence add an example similar to `ListLinks` usage to help
> > catching bugs and demonstrating the usage.
> >
> > The example is mostly based on Alice's usage in binder driver[2].
> >
> > Link: https://lore.kernel.org/rust-for-linux/20250719183649.596051-1-ojeda@kernel.org/ [1]
> > Link: https://lore.kernel.org/rust-for-linux/20231101-rust-binder-v1-4-08ba9197f637@google.com/ [2]
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> 
> I sent that one because I am applying Tamir's series, which triggered
> the error -- maybe you can put it on top of those?
> 

Sure. I overlooked Tamir's series.

> If you do, please note that you need a couple changes -- I will push
> them to `rust-next` so that you have them.
> 

Will do, thank you. ;-)

Regards,
Boqun

>     https://lore.kernel.org/rust-for-linux/20250709-list-no-offset-v4-5-a429e75840a9@gmail.com/
> 
> Thanks!
> 
> Cheers,
> Miguel
