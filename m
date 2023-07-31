Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2205211C85
	for <patches@lists.linux.dev>; Mon, 31 Jul 2023 08:17:11 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-3fbc59de0e2so39086325e9.3
        for <patches@lists.linux.dev>; Mon, 31 Jul 2023 01:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1690791430; x=1691396230;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=tXBhRdUtHPrrcaPCjbweWbD8AMIQH0b5ap+ZgbPohPI=;
        b=ILtKjJzDWLauNQNKqeZ9L8laJBDSpcEnpFzZw2345aQVHXBXjLv8naR51ob/R/fkrx
         LZQ9pLNzYOC9T0sKxztD+JEJkuEY0hpTLMAysqz7B9t110z9zYv8l/noosXBA7hkvgnM
         R3BBSfm03rZ5fIcCvkWZjjghUGA3/PuWfvlSJh49sw+d2lzAKf3M8w0+Jc2Wg/vsadt6
         7e2rX1FYzM2iz6ku2aEiXRartgWUjhcMWfA6ivOUjTyBy+Z92IgtpVVRpUrmqiFHskS3
         KE7PJrUIxLGNtTaNrskjbeAHBV2rubibWPoffK0u0IsEn3Ys7JW/MibRhejTuc6j20VB
         hCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690791430; x=1691396230;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXBhRdUtHPrrcaPCjbweWbD8AMIQH0b5ap+ZgbPohPI=;
        b=fLCnIhaEMW7AMJwTQ1n+FD2nG1lO46zh5VPKZgioHWeGEWuL00sXqO641NrPf2PXxs
         pvghn7k5k5eu7tkf/7/8WK1LITq9C8TfOAWykzXYXWg9T0FiQE06Vr3EdskVbRYZC0w4
         dNuYh4n3V0UCXi49z1OTkbGZ7xBiqgK8t0UIZIdkdg7UVLeX7SFyQril7eWa5hLHUw1b
         7E70cQcQW5qxEDURlqupiMKC+pj46jjyvGd5ZIQE9565QvKuHMnWqejAj3f7F47IN9Rn
         c9jS7V40x4QL2EUWE2+Wk3PKRilAPXRRqLPnZYCp8x0Ylyhm26S2sq2EuWFoB080hxcl
         XgjQ==
X-Gm-Message-State: ABy/qLaU2ZO5S/yoE3nfQyBPKYLClalqNsnnJVjPi6I6sIZFqJJxgNMA
	NPSPh0F0yxNFxTNi5tp5dZegvw==
X-Google-Smtp-Source: APBJJlGlRoVcspGECVffVhhAtcYYUfteqIvOr8ABivvTLEiMG8/BQmr8aW3Ttv6CWtvng4xkn8QPow==
X-Received: by 2002:a5d:452d:0:b0:314:133a:f04 with SMTP id j13-20020a5d452d000000b00314133a0f04mr4535091wra.49.1690791429647;
        Mon, 31 Jul 2023 01:17:09 -0700 (PDT)
Received: from localhost ([165.225.194.190])
        by smtp.gmail.com with ESMTPSA id z14-20020a5d4d0e000000b003143bb5ecd5sm12241583wrt.69.2023.07.31.01.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 01:17:09 -0700 (PDT)
References: <20230718054426.1048583-1-ojeda@kernel.org>
User-agent: mu4e 1.10.5; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Andreas Hindborg <a.hindborg@samsung.com>
Subject: Re: [PATCH] MAINTAINERS: add Andreas Hindborg as Rust reviewer
Date: Mon, 31 Jul 2023 10:16:10 +0200
In-reply-to: <20230718054426.1048583-1-ojeda@kernel.org>
Message-ID: <877cqgqyuz.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Miguel Ojeda <ojeda@kernel.org> writes:

> Andreas has been involved with the Rust for Linux project for more than
> a year now. He has been primarily working on the Rust NVMe driver [1],
> presenting it in several places (such as LPC [2][3] and Kangrejos [4]).
>
> In addition, he recently submitted the Rust null block driver [5] and
> has been reviewing patches in the mailing list for some months.
>
> Thus add him to the `RUST` entry as reviewer.
>
> Link: https://rust-for-linux.com/nvme-driver [1]
> Link: https://lpc.events/event/16/contributions/1180/attachments/1017/1961/deck.pdf [2]
> Link: https://www.youtube.com/watch?v=BwywU1MqW38 [3]
> Link: https://kangrejos.com/A%20Linux%20(PCI)%20NVMe%20Driver%20in%20Rust.pdf [4]
> Link: https://lore.kernel.org/rust-for-linux/20230503090708.2524310-1-nmi@metaspace.dk/ [5]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Acked-by: Andreas Hindborg <a.hindborg@samsung.com>
