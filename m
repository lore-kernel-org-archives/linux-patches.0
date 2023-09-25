Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4651179B4
	for <patches@lists.linux.dev>; Mon, 25 Sep 2023 19:49:29 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1bdf4752c3cso49131885ad.2
        for <patches@lists.linux.dev>; Mon, 25 Sep 2023 12:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695671369; x=1696276169; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x9jR0bp9vcQzOLj43wS440EgIxc19Wrw9EkXUEXKDdI=;
        b=QbblNrueK5fudP1/07kAp/c+BNxA2cxo2H1i/MtERuMapgHWV3oDwgWII3j2eFnLjL
         1qPURy2UzmcU5VILLEdBcuDZYVeiVfg7qgIw7gnoNhMFh9/GtshB/HPnXmcMuZjcSto2
         j7s+oSNgK4qbdVn/6mTHv5z9iT2tgUL70DoqpvH52m3FXCGeMojk1wqwMVcKG2n4tb32
         ihfACJP+SrF6diAx1hBYxOzFXrO20q+CcHwpvKDtFpd6qmy0nrN+TP2UdO9OkaQmmHvQ
         Sheus2Eb7HrOc9/OXATxWw5jc8UgKAtX5ORT8wFT0H3Qi3Dh0gU4Q/JOHcPeZkUeZd8A
         drKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695671369; x=1696276169;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x9jR0bp9vcQzOLj43wS440EgIxc19Wrw9EkXUEXKDdI=;
        b=BDN5sCHJaCp5N/HCuU0ei+lLFP5bZR2E6LZlUjja9rAAyY7vEQGv0L1hJAd7lI97n+
         d1PkVXGN7ismQsBY06bjO+vDJiXx03Cr+p2SCHXdSEHMzHzlFv1aLCBbtm6pYXG3uqBF
         2QDCmC2BHg4fP86jIWwjtm3qKs0mN33x0rsuzznieFZ4+1majfkV2IONN+/n88PZ1oPc
         Lo9UqQenKmGZl3QC+k1kTWNwjO9PffBC+fF24vepZTLsuyi7KI2JQqk2N4A/1p3CbdM+
         Gox1SibcO3wueNy9h098Goz1qUahC8JCpbcpB3giCBKBbC05p+U7oXdz9D9Z3GEEJ4Dy
         iVQQ==
X-Gm-Message-State: AOJu0Yxa9f5Ndz/Fntyi58DI4A4bkiR7YfjybfYIufqZeBcxfOKqJFrO
	mOdGEAcS8NZbivdBJuLu7hw=
X-Google-Smtp-Source: AGHT+IEP3hHqgdcijF5/i7dWkK16W0tXHGtF0wS9J7MqWj4+boWTkXWnA5AiJ8GRiQB/Fud6wGq6BQ==
X-Received: by 2002:a17:902:f549:b0:1c5:ba50:2b14 with SMTP id h9-20020a170902f54900b001c5ba502b14mr6078472plf.12.1695671368887;
        Mon, 25 Sep 2023 12:49:28 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:dfcd])
        by smtp.gmail.com with ESMTPSA id b8-20020a170902d50800b001b891259eddsm9250970plg.197.2023.09.25.12.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 12:49:28 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 25 Sep 2023 09:49:26 -1000
From: Tejun Heo <tj@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 0/7] rust: workqueue: add bindings for the workqueue
Message-ID: <ZRHkRpZJemtn67rf@slm.duckdns.org>
References: <20230828104807.1581592-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828104807.1581592-1-aliceryhl@google.com>

On Mon, Aug 28, 2023 at 10:48:00AM +0000, Alice Ryhl wrote:
> This patchset contains bindings for the kernel workqueue.
> 
> One of the primary goals behind the design used in this patch is that we
> must support embedding the `work_struct` as a field in user-provided
> types, because this allows you to submit things to the workqueue without
> having to allocate, making the submission infallible. If we didn't have
> to support this, then the patch would be much simpler. One of the main
> things that make it complicated is that we must ensure that the function
> pointer in the `work_struct` is compatible with the struct it is
> contained within.
> 
> The original version of the workqueue bindings was written by Wedson,
> but I have rewritten much of it so that it uses the pin-init
> infrastructure and can be used with containers other than `Arc`.
> 
> This patchset depends on the patch [1] that changes `Opaque` to be
> `!Unpin` for correctness. The patchset is based on the rust-6.6 tag,
> since that tag includes that patch.

Applied to wq/for-6.7-rust-bindings with Boqun's reviewed-by's added.

Thanks.

-- 
tejun
