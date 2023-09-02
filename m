Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ECF3C1E
	for <patches@lists.linux.dev>; Sat,  2 Sep 2023 18:58:30 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-99c3c8adb27so27959566b.1
        for <patches@lists.linux.dev>; Sat, 02 Sep 2023 11:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693681109; x=1694285909; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gl4SU+iR0aYjorFAnHIvqmzFYuhuur+i3elwAKbseyI=;
        b=Hk0rVJFtx3+7NDis9hFvDkmGtjwfMl32MjeEO0nfHyFqbQcdmGL+E8Cxn5BCcvgqKH
         MrVzveIImqZc/RzbSaZKRXIHTYPS8sSFUMf2m4XdbDn7kQglz9Gt4sPhirGdS4z3wrC6
         S8yOwgJwUENsgkANhvYdJdw1MfhBsEqCG+fN/NRJTUUXrbT+j5ms7aQ1kv70AA8DaowG
         w7R7BNCFexUaqU49xyM1xW+OW6+cdAD/EsbPMAvcv9sl4VgPE2FHAi8XMapm3x66xDin
         uP/jS/D0lT5QDKegN1RHzjzbmLufGkFJ7Nq7SZUT7FVhQdyLP+9tpvHd+eYAkTEzFwBz
         Z5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693681109; x=1694285909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gl4SU+iR0aYjorFAnHIvqmzFYuhuur+i3elwAKbseyI=;
        b=OzSumI4qoEuc+dxhkRpRFwf/8KLFCN+KNCUWP140Fya7lvYLerwSF77xfx+VTN+faO
         O5UctFIa7BFucV43CsPjXmIA5qSYbToiDRs0RA5M0Iuhh3Ygn55ECm+GOpjePXaO9xUw
         xm+VPk2tSw50guWCkLrEFd9tyuxLXW3GFAc9taCQjkaxmD9BpWUMi2fbwD4PnlnmJGhQ
         0QZR8qGaiWO1Cnr7Zf1HfovHA9F1cDm0OTKkTKJn1x5B+9SVvlr1IHeIpR4m3Dshqp0S
         jrmBKmND2Hv9jzMulX92A79vl8rrHEnNtiows7QJlUgFUDQDfATykIdBzMMWk5kphdzi
         D9Ag==
X-Gm-Message-State: AOJu0YzK6WdrqDcUv+rjZla7O1bQ+hHQml2076ONXcoy6P/kIIouysLv
	b5IFqCBaCTdjp7pTSsn0EBc=
X-Google-Smtp-Source: AGHT+IFODLtoLsf48req917bK98NAE1I+S0Yvh0IcbImIFKunEHUw0bS/eMKsPkoBwjtjAKUsC9jbQ==
X-Received: by 2002:a17:906:3291:b0:9a1:bd1d:61b2 with SMTP id 17-20020a170906329100b009a1bd1d61b2mr3846170ejw.56.1693681108930;
        Sat, 02 Sep 2023 11:58:28 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id dt22-20020a170906b79600b0099d959f9536sm3809066ejb.12.2023.09.02.11.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Sep 2023 11:58:28 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailauth.nyi.internal (Postfix) with ESMTP id 3262227C0054;
	Sat,  2 Sep 2023 14:58:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 02 Sep 2023 14:58:26 -0400
X-ME-Sender: <xms:0YXzZKjOM7vXfm3HVkUDU0HZFNGkQUgqEExdD0KbIS6uXmG_kIdn7g>
    <xme:0YXzZLAJkLst6hOrR-rTk-s7jVxV8KIIk2Qv2yn-PfjE46KhZt7LSuu5JRyrDauJ6
    2X7bQ6K7CoGvb4V_A>
X-ME-Received: <xmr:0YXzZCGYqMoJhEAtHxHkRKYJgir7PO31NRvXt0peBiDgs-ksSY9lKZNpLwAFDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrudeggedgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhepueeutdetheelkedvieekjeefveekjedufeefkeduueduffejueegfffh
    hfffkefhnecuffhomhgrihhnpehruhhsthdqfhhorhdqlhhinhhugidrtghomhdpghhith
    hhuhgsrdgtohhmpdiiuhhlihhptghhrghtrdgtohhmnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhph
    gvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdr
    fhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:0YXzZDTYxeOmU8jO2ij9xWNjbmq99qNm1HytDpYGvMerrqxShTtQQA>
    <xmx:0YXzZHyKr18TrP9pLU2296aXWyW1QYWcgnRGV2Gt3dYYR9Ovd5o5GQ>
    <xmx:0YXzZB77Xyc7WAlj5_6vZAvBakPp3QpGhEAOUVBgKk4ehLBaI6j7Zg>
    <xmx:0oXzZMqzPXuIdezaISsZkoUXCNcxUR0KUr4fJg13HQz5t57kHdgcmA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 2 Sep 2023 14:58:25 -0400 (EDT)
Date: Sat, 2 Sep 2023 11:57:22 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 1/2] MAINTAINERS: update Rust webpage
Message-ID: <ZPOFkpue7MX28bE7@boqun-archlinux>
References: <20230830165949.127475-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830165949.127475-1-ojeda@kernel.org>

On Wed, Aug 30, 2023 at 06:59:48PM +0200, Miguel Ojeda wrote:
> A few months ago we started a webpage for the Rust subsystem and
> the overall Rust for Linux project [1].
> 
> The current `W:` field of the Rust entry points to the GitHub
> repository, since originally we kept information in a `README.md`
> file that got rendered by GitHub when visiting that URL.
> 
> That information was moved into the webpage and got expanded.
> The webpage is also nowadays the entry point to the project,
> and we pointed the "Website" GitHub metadata field to it.
> 
> Thus update the `W:` field to point to the actual webpage.
> 
> Link: https://rust-for-linux.com [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 12601a47c839..7c8088e9a11b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18558,7 +18558,7 @@ R:	Andreas Hindborg <a.hindborg@samsung.com>
>  R:	Alice Ryhl <aliceryhl@google.com>
>  L:	rust-for-linux@vger.kernel.org
>  S:	Supported
> -W:	https://github.com/Rust-for-Linux/linux
> +W:	https://rust-for-linux.com
>  B:	https://github.com/Rust-for-Linux/linux/issues
>  C:	zulip://rust-for-linux.zulipchat.com
>  T:	git https://github.com/Rust-for-Linux/linux.git rust-next
> 
> base-commit: 4af84c6a85c63bec24611e46bb3de2c0a6602a51
> -- 
> 2.42.0
> 
