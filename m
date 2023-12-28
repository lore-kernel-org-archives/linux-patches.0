Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEE3101ED
	for <patches@lists.linux.dev>; Thu, 28 Dec 2023 19:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kEv0LJgX"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-427fa9ecd60so4148711cf.2
        for <patches@lists.linux.dev>; Thu, 28 Dec 2023 11:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703792583; x=1704397383; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zTgUJfJIqNmJzukT+nSgAgZaf503JH2MNH3MI61x1Y=;
        b=kEv0LJgXp4fNBnxY38IgC2idC6JLs6swVZSOAVQC/MP3IDbTzqOGNSOODO+1L047uh
         77b8bPfcNGi74GcnMvIJ5IPBSXt5qfYpqm3lkysLfvfCcA0cg2C/5B0HwVMwyCT4UM1H
         Z3nc1AQlWAr3HHBnE9VHVtSwNn4qkCgndp4B5C3hvPLw4gN7MP1ueDkR1dy7V6hej9HM
         vF7K320j/9uMtJNvmyXkHLDX836mnlo1nsfjYb71gum9MT2l2zQe/Kd7+FiCu5E+RRKh
         DpSWjR5mSIRJni5BZYbIPePEgTezOct+fuN+YCKhXw2gxo7UxLwtgaoqfnFPDjfKf/0S
         KI7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703792583; x=1704397383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zTgUJfJIqNmJzukT+nSgAgZaf503JH2MNH3MI61x1Y=;
        b=A4falb3ncy96wkjEyP2DqzsfnBJf94KHX4op/mxGwdgWX5SjDmmHSZ5L6z+RkFgPon
         hTJfpVVjQrcKVpalExJXIEA7EfCI9KO99iBy5AZ7f27FpWiPHWxQ0BqMkTKMmnxmULot
         M37cjoKm2BSIumTey5SOWGMlpZR2OyYjbxLfKnFoGSy7GARWwLRMyU4uZHS6uB/+ASAT
         AJ4nq+pq/91NSSstkI5NFnTCMDFMNRy3Dzoumscn++NND+zEd95ZvIG/wBdJr6a0xP0k
         6HzmYvil8gtFY9e9fEG5msNnUmW6vl2Jtu+jMdo6hYltoIkDFrDdH7mMKZJEhsxgNpDj
         R7mg==
X-Gm-Message-State: AOJu0YzsIJcJNMr3+FcxmKiOxOU/Nz8yDfqu/pJRwGP5ytpHZI4kyA6M
	axUFsB69G8U1WQTFgvNv4xU=
X-Google-Smtp-Source: AGHT+IGxOTxwgAz40c0YA6Bu6/T7sUpBSnJBsiff2q1myvGIgQ/KzGmg6oDaDqLDi8HB5BCf/FuvvQ==
X-Received: by 2002:ac8:5754:0:b0:427:892a:edfe with SMTP id 20-20020ac85754000000b00427892aedfemr17790770qtx.66.1703792583543;
        Thu, 28 Dec 2023 11:43:03 -0800 (PST)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id ks22-20020ac86216000000b00423f2acc614sm8399072qtb.87.2023.12.28.11.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Dec 2023 11:43:03 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailauth.nyi.internal (Postfix) with ESMTP id 90C7627C005A;
	Thu, 28 Dec 2023 14:43:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 28 Dec 2023 14:43:02 -0500
X-ME-Sender: <xms:xc-NZUXKy1ErXIJJTrfxCif2itc5hxSLUDkm8vbPYpaCoY0aeGBN5w>
    <xme:xc-NZYk5EYGLTb0vPu3yeZnE8m8YgJDfm2qBjrjr90A4mB3teUsV6vEtkFP4emFfA
    Se-UncdZuvdQKZw0Q>
X-ME-Received: <xmr:xc-NZYbtsj3BltQkFBlYatYUXmUtM9L40rK63AIzpwiLN-z0UlndhrfNunY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrvdefuddguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhepfedthfeuueeihfeihffhtdeluedtveffheeiuddtieehtdduiedvgfej
    ffeuueefnecuffhomhgrihhnpehgihhthhhusgdrtghomhdprhgvlhgvrghsvghsrdhmug
    dprhhushhtqdhfohhrqdhlihhnuhigrdgtohhmnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrh
    hsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfhgv
    nhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:xc-NZTXyAHdHhfoZRtfSNS-u-32HkHAxWl8sAgMASKstQknwod8bCQ>
    <xmx:xc-NZemCIgD_F8T3TmCU5f1nLgGl_F9WermBgWNf8iH-yM302H2u_Q>
    <xmx:xc-NZYevAU7SmQa0YnoQh_Ta1nVxkcYYCxwBnT7mlqc69ylYsgv5pA>
    <xmx:xs-NZXehw49VsnhL_4Mdid26m-v4L0zpffC8uy4rYU8TqQWMBSXr3A>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 Dec 2023 14:43:01 -0500 (EST)
Date: Thu, 28 Dec 2023 11:42:14 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: upgrade to Rust 1.75.0
Message-ID: <ZY3Plt92Jn5xSmXw@boqun-archlinux>
References: <20231224172128.271447-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231224172128.271447-1-ojeda@kernel.org>

On Sun, Dec 24, 2023 at 06:21:28PM +0100, Miguel Ojeda wrote:
> This is the next upgrade to the Rust toolchain, from 1.74.1 to 1.75.0
> (i.e. the latest) [1].
> 
[...]
> Link: https://github.com/rust-lang/rust/blob/stable/RELEASES.md#version-1750-2023-12-28 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://github.com/rust-lang/rust/issues/91850 [3]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [4]
> Link: https://github.com/rust-lang/rust/issues/96283 [5]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> Please note that Rust 1.75.0 will actually be released next week -- this
> is based on linux-next since we will need to remove the `feature` line
> for the unstable feature used by the to-be-merged PHYLIB abstractions.

I have done some unit tests with this based on a merge point of today's
net-next and rust-next (along with some LGTM patches), all tests passed.

Tested-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

[...]
