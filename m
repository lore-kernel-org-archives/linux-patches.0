Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E597C1CA9A
	for <patches@lists.linux.dev>; Sat, 17 Feb 2024 06:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708150673; cv=none; b=GampX//VIdb5SUfvFnEW1bYRWOt0ci4vVqLKvwLhsDtMu1EiEV79jjrgKPVEVi5tbv+X9f1LM8sAVN08g4k1Gv7tChgHP1TORgTRZebO4ycGBU8hrsG7d+lOoTwtgoAd6DRijbB+4unFZj30jKXlL5i/4xn+GPo934BgSzcc184=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708150673; c=relaxed/simple;
	bh=WcO4cvegFUZfoRhn8nlC1otY3e5B7iw2Um3tCN0jCRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RPwmbT62R2eT3jebBi1W04tpqsewS0Y4OCjRrg6/mzAGwALl4qsNHG+T/XuK2G80AGqcBtAvdQr2Yh3tWm1ElgFDcgWRxXA3T/ulso44NftC+XjeJGWwuiYeXIrFNiGX07pQk3Wf3MuofI9gYq0/vcVplMuhASr3tQWxbCq3SH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MerLmTfK; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MerLmTfK"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d746ce7d13so12901145ad.0
        for <patches@lists.linux.dev>; Fri, 16 Feb 2024 22:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708150671; x=1708755471; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u+u+if2n6ZNzwn4bl2h6DYMm5ylG/p9ucE/vpNLKYag=;
        b=MerLmTfKebk8EWVMhzyd/9r7cyq56BPYZjN/zE3jdQJDU1m9J/KnJfV+tQI0nxzk8N
         6Uj2h4HdVLxuS4NrCu0vh6Sf48Ch1YIn2HYCVXNH8YyxBE3M/yj/ZhB0c+4CPoeKILYf
         qccBvBrnZ///xd7ClVtVIwQv3kWrgQF0l3JpeOHPFIRUvxdRp9NwYavPdugYtPEqlmLO
         N/21D4MjCqWO2o9nBZoZ9GcEDUCY9mncMKi4G+AG0NqHjHP8i8zb0C510KX7O1jtgA7Z
         DufiQgvaCNktqKwF84I+iu0K2sUlMU2aTXAPQkGzfKfkumqBSKQKHpKEG2zKPCAqaVsk
         RXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708150671; x=1708755471;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u+u+if2n6ZNzwn4bl2h6DYMm5ylG/p9ucE/vpNLKYag=;
        b=cGMg7PISDQ7Gu/RB4GJSBXM97Bq3kmsjUsQOLWlVHj5BATzFurRTlPT3BB4nB79wJ1
         vFmL3Ah9NocfZkbHyeQzp0mbjI/eYA+LHaXz8gRxRjc5OayzzoR0x6vELjd3/+nYVDOy
         ubk+vkQVm8E33tVzo6Z5TjUDdxeq8NoflOzINxw2Y3VHYHx5MZ/BczecELkeH/htoMNJ
         IiFe5YpUHALWN3nwUS7sg+HJQxHb1UiC6kO7sJwoEZrJQf5Gnqcuoly9g5L02nDiZkPn
         DhGm/UeB66elbjl59tnwKIgQoFFvtXKiU6u1cbXYIqPDl2j8LJtsxPP3mgT0bnP9fhY/
         Iw4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUZEOr3rAuGwkesZrwkryXXj1mX5+hi6GHDXV++2zSmvb94wGqfhTJKWCbyqHQWLNfXxjT47xDTVPw3MJRiKoq9vUHR8EyHoA==
X-Gm-Message-State: AOJu0Yw6YhyN+o8ZU0/9/d8yWK0zHjMvHDgy/+KevYf00WXRtchwRSYQ
	ccYhTipws4L84rHxZeK+DCvkVmF0jdbRIjRHEaopXsPfW52T882M
X-Google-Smtp-Source: AGHT+IFlw8vIIyiOXX86wfqBbEE3qnndY4HJQ0ATBDuzYod2px+tEUrnu9gD5PDTSSwEpWqFkCZoyQ==
X-Received: by 2002:a17:902:d2d1:b0:1db:9896:3eab with SMTP id n17-20020a170902d2d100b001db98963eabmr7150628plc.36.1708150671123;
        Fri, 16 Feb 2024 22:17:51 -0800 (PST)
Received: from fauth1-smtp.messagingengine.com (fauth1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902ee4c00b001dba739d15bsm765277plo.76.2024.02.16.22.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 22:17:49 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailfauth.nyi.internal (Postfix) with ESMTP id BA1081200043;
	Sat, 17 Feb 2024 01:17:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 17 Feb 2024 01:17:47 -0500
X-ME-Sender: <xms:i0_QZSUBs-b-Pkjc-j3fUZ_KwBaATGXpLYAiz-pjKZ4CYoQsrNnbJQ>
    <xme:i0_QZenWUHnnjB8OoPoUxoHQ9PaEFBoBdCfLDH4ebxFfovVprPAOaNM5XvFK3MS4I
    OcsHe6_vfaL_YJ_5w>
X-ME-Received: <xmr:i0_QZWYvrWwwBe-cGR0W6Jc9-NATF8jjMxts7xsgxIp8hbnWbgQ-XmC_LQoS3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdefgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveeiudff
    iedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsg
    hoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieeg
    qddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigi
    hmvgdrnhgrmhgv
X-ME-Proxy: <xmx:i0_QZZU-Pkni92-b5SrpdJ1_rnaEtvuSb5dhy4LZa0gqUoAAKGxlLA>
    <xmx:i0_QZclHWj_CKEvBKxpvsJ_N4-fZAv7SvrT2CkZ0u1xLoLbf-ardWw>
    <xmx:i0_QZefCIRJE86r6V0sdChbbFp4mOjGDVa_JoczDTC7f-TsfLW8JCA>
    <xmx:i0_QZWddWg1ECaGGbMydvhHWkbh4I6-b3yptZC1q7LqQt9-ZJMkXp_zAueQ>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 17 Feb 2024 01:17:47 -0500 (EST)
Date: Fri, 16 Feb 2024 22:17:39 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: upgrade to Rust 1.77.0
Message-ID: <ZdBPg9-cYwgLOrxc@boqun-archlinux>
References: <20240217002717.57507-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240217002717.57507-1-ojeda@kernel.org>

On Sat, Feb 17, 2024 at 01:27:17AM +0100, Miguel Ojeda wrote:
> This is the next upgrade to the Rust toolchain, from 1.76.0 to 1.77.0
> (i.e. the latest) [1].
> 

Again, I've applied this onto the previous 1.76 patch and tested with
kunit for x86 and arm64. My toolchain is today's beta:

	> rustc --version
	rustc 1.77.0-beta.4 (d783f371b 2024-02-16

Tested-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> See the upgrade policy [2] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
> 
[...]
