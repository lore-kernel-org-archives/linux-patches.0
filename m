Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF221367
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 07:43:56 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-401d2e11dacso11160145e9.0
        for <patches@lists.linux.dev>; Mon, 04 Sep 2023 00:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20230601.gappssmtp.com; s=20230601; t=1693813435; x=1694418235; darn=lists.linux.dev;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=ifvCGzYZ8dSBZT/icGjJJZKmlvecnEtAo9NWhhlJprI=;
        b=sA9To7FoM2HqJfyiBtY9Bm2HNDTbtcKO73ZB049dyJQSywuj96wUsThGcmlXZ+OY9h
         ZVyjRzuvOmSz6ClKMEPFRBiY62JYn70H5XSgQDT9scvFyLJBUUVLMvmujnzMhnVWq7Ho
         F+/hxyOEPUyMqewPOjQBs4SIpcxsHVvu8qEhOndPZyvvYW4FYd3zfBlvuqTM6AALhMxP
         EUCev2RHZoV3qtDuqOQUFPOADUsIaWr8+mR4VaEzKDBRDzjTgEJOMqdMeoAPVHKV06SE
         1IU7MEqvtDrHJvMrm5KD8bsAOxgM6qPjzatGMKT1Br2oFd2dThAFZ/jLCC/0IhCbtfUa
         QQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693813435; x=1694418235;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifvCGzYZ8dSBZT/icGjJJZKmlvecnEtAo9NWhhlJprI=;
        b=K1/cLBRxotyum2duHseI10OnT3BYovMxM/PV0d0j8uB5enaEe1fIZqVS4e33kNOX90
         hZmS4LTG6MK+AnCNI/3DzvC1UkHMNnVORjgG333FzOsQWxnZaGuTRRxdIM8iN17eSzK4
         PJHEyoYIEiiLRlX0a+7TPvudFzuyjh7+lKcpxFR71DLV9Wk9FzpEU0C+PtUxA6gfKFOl
         QuBDsViCTEfHq+B8kSciYuHOwbFKSD+Z2RKz9GYmFQkYHrYOaIzG8ZMUDykZBYEiidfe
         incsrDfd2yiraieONvE5dIKi76wW4tvu0DSgBFV80hoyWFXGQcTNeMa17qm0nsZDZai8
         9bZw==
X-Gm-Message-State: AOJu0Yy4xFjRNsZThLLf53M38N7853DLUWq/q4zj66aUZyzbnPCrCM1e
	GrqwfcQNb9gKTDYtl/HxJa60/A==
X-Google-Smtp-Source: AGHT+IF/VhmH8vxSF24dGvyU92yKMeU6tMOo/g5hatDiNDqzAh+m4v5n+Mvz8VKgYQUMhVlad5G9Gw==
X-Received: by 2002:adf:f291:0:b0:313:e88d:e6d3 with SMTP id k17-20020adff291000000b00313e88de6d3mr8760640wro.14.1693813434681;
        Mon, 04 Sep 2023 00:43:54 -0700 (PDT)
Received: from localhost ([147.161.155.99])
        by smtp.gmail.com with ESMTPSA id f9-20020adff989000000b00319756d5b80sm13912160wrr.29.2023.09.04.00.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 00:43:54 -0700 (PDT)
References: <20230830165949.127475-1-ojeda@kernel.org>
User-agent: mu4e 1.10.5; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 1/2] MAINTAINERS: update Rust webpage
Date: Mon, 04 Sep 2023 09:43:37 +0200
In-reply-to: <20230830165949.127475-1-ojeda@kernel.org>
Message-ID: <87pm2ytmbq.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Miguel Ojeda <ojeda@kernel.org> writes:

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
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

