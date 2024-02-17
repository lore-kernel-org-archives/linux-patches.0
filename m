Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373991CA86
	for <patches@lists.linux.dev>; Sat, 17 Feb 2024 05:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708149461; cv=none; b=bdf0jq9UVLelicYiFxSXzd7LlbY4H6y/OXXhDKN74P19X6zkXy6kjQbNfLgUhDbJ8iNQaiiMdF0+9gzMf9tCx/6qgDm10v6rPfxYiJrL9oBw6VoVSxxlrrTldHJ29iCSjZWLZJ/i6SvdVetc5ApyHbuRH47oeeuTYrCW7gtgzzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708149461; c=relaxed/simple;
	bh=te3NvISa2cg+5326YYQR9qU1/sfQi28dFBgXgq7HymI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hAOuGhaDTOsYEJgiILsS5v1S9qLKubiCcl6Obae84FVGEpVgdNUg73vteEdqyP1xow2oWzwX+u/6jyxeHTbvRTCwFewQ0BmwrpvDY5TfcOcE+lahoIOANAb67wRTXiAbXcsY5zP02p5LE/BTYXFzygORbT+DXoFtsWTsfrvZDRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j1lVmWvL; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j1lVmWvL"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-785bdb57dfaso311109585a.1
        for <patches@lists.linux.dev>; Fri, 16 Feb 2024 21:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708149459; x=1708754259; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+uCjdazgHe9L1xw/mXjLr8atA9J7oVAnfB8tvbVqeMc=;
        b=j1lVmWvLSm2Csv8/IFgDX9d3aMNpxskayqQHO1xvYTj+oodVNR3JuZz7yuIqGKU4OU
         79tSt9CgXsE/ebdLgL4OErZb2U8qVYIqgUe4MEqg3Ykv3Kz4QbYjlmKvmGgfvv/jezPh
         JX2iUVZk74ijIlXI5H0Ywa7r+VDrSYe1NC/xLEGpwU/fzFjlKp4TBwEf9X/OymgIV4JL
         XsNwxhN7ZF7KudayIpGnIZ8d0xP8J9FDqfqe1d8JWzIoRSXUbOe+VjkYVFV4AE8DkDuW
         DWH65W1KoTvMH/l7+b8MyMDmy6hqlB/SpXepWhamKCtePjKh+r0m6pq8AzDKjGaZtYBV
         Rw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708149459; x=1708754259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+uCjdazgHe9L1xw/mXjLr8atA9J7oVAnfB8tvbVqeMc=;
        b=W/5PpaqFoVPz9mItP3h6hNbvEaDTJ7XHk5AwEUfm0HoJFNnTvXdlMw8M0JGKRAPTDP
         azVD5nucspKFXyXNADbzsPaDY6CEVuw2zHPLsuExSH+lOQSbQpeBb/uvidMmEAnrxDsi
         tuc3eeV/NQKIJrpuFOelT2Q4tx9pLDnemePq7CwTKoqwiKFah8xUx8C/Is1XEQG88RCO
         F6/RHNkf08mEszGadS9UXqFry0NZlNm44D7pG/8ZdtYin5V3w7ONpnCYcNzS38ce5KAd
         E3R3/UzSgfON3P8p2WlC2c/taQwEqPwnHzEO8jSHLb3+WODNDE21XyTJ5iAhCbdXXLtG
         +cRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdLhG3qZBBzXZq/iOk/1bOrcvIZp8SN8+YC4rcySWQAnT/ZWfKIIlbPdby9Jc9d+F9G3h7vrBMzPZNQ3rJDLJ7e6mYRi3PmA==
X-Gm-Message-State: AOJu0YyLcnpOXNLj39cVeeC35kqH+ecTu6g/F4rA6VNUDr2QaWc/no2p
	ISsBlaHFwYolg56cL4qcbzby4Pt0EB/OnrqzVVK36t+IJTAjivp6
X-Google-Smtp-Source: AGHT+IHwSaPs/0sTuYyvoGkTZ9yU/0PeCt6IS+EHLIK/2TZ+2uktYLYLIeclv/Cjb75EaezoyQI1FA==
X-Received: by 2002:a0c:e408:0:b0:68f:35f5:8e96 with SMTP id o8-20020a0ce408000000b0068f35f58e96mr5046198qvl.25.1708149459024;
        Fri, 16 Feb 2024 21:57:39 -0800 (PST)
Received: from fauth1-smtp.messagingengine.com (fauth1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id ks6-20020a056214310600b0068f2b9a6ec7sm702735qvb.18.2024.02.16.21.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 21:57:38 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailfauth.nyi.internal (Postfix) with ESMTP id B55151200043;
	Sat, 17 Feb 2024 00:57:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 17 Feb 2024 00:57:37 -0500
X-ME-Sender: <xms:0UrQZdnfl4NbTm4uWwvRVrT6KieJBsb00dcr25ZfdE3qfs15uacr3A>
    <xme:0UrQZY1hyUy8DmVym6YNHGUBsFsc5lNvw0_d32anhjOlz2QQ5urOLEcsw6yrQP9tq
    lBIFoxJg79MTnh4_Q>
X-ME-Received: <xmr:0UrQZTqPv8oUezjWvoIIodh5eP7ENC5bWY2foa9JZUls14MjyMBHrfMvSKvkbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdefgdeklecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveeiudff
    iedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsg
    hoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieeg
    qddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigi
    hmvgdrnhgrmhgv
X-ME-Proxy: <xmx:0UrQZdmDmQj-P7KHbcNASwtq7JAZ1BrQPiK-E-lqlF65y2xhdvLgzw>
    <xmx:0UrQZb3dIYw7qCeZEQJj9YmN5RTW4f8e5oDhDqTAt-JPDWrZ17tZMw>
    <xmx:0UrQZcvTxegSNMCIva8DBaFco6dAUbvTZaFvuRtT8NQMQyMtGrRFOA>
    <xmx:0UrQZS10S57g9lkxQrt_FC_ZufMGm7kpcGl1dfJOf10mLNIdT9NZ5nGSoH8>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 17 Feb 2024 00:57:37 -0500 (EST)
Date: Fri, 16 Feb 2024 21:57:29 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-kbuild@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] rust: upgrade to Rust 1.76.0
Message-ID: <ZdBKycd6mPI5cpkA@boqun-archlinux>
References: <20240217002638.57373-1-ojeda@kernel.org>
 <20240217002638.57373-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240217002638.57373-2-ojeda@kernel.org>

On Sat, Feb 17, 2024 at 01:26:38AM +0100, Miguel Ojeda wrote:
> This is the next upgrade to the Rust toolchain, from 1.75.0 to 1.76.0
> (i.e. the latest) [1].
> 

I've applied this on the merge point of for-next/rust-for-arm64 in arm64
tree and today's rust-next (patch #1 has a small conflict with the
target.json changes in arm64 tree), tested with kunit for both x86 and
arm64.

Tested-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> See the upgrade policy [2] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
> 

[...]
