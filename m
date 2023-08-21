Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178D64A28
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 11:25:03 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-589a4c6ab34so46236197b3.2
        for <patches@lists.linux.dev>; Mon, 21 Aug 2023 04:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692617103; x=1693221903;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KNwlE0hptEJ+KomxedbhNDZdQW8nX6UaNAvgVOd3YTE=;
        b=DqYbQAqTPQYpujtcLYwSGJB6scOaDUgrpKcB1gNAriudu9qoLwTPXxTSLZ5kmAiqvq
         ZtUugMzKUiimHHWbnvjmP/cP1LtcksHcdFvDPRhov/AeIInzkZlFdTuCpufy9/OmoO09
         jhymM6UxghCuAKYy4j+Dp+DxnZujMVH+ZqhupYyyLuSR0Mi1WDRbwyq80Iq5pBDhUTG8
         i3jB2nDtQpdvsHgBjlyeG5TjE2BBxYrc/O5gFpsNNdYBQ1n7Pi2mSqrxZPrZq4g3ndlu
         /hZi+m+DI5Tf9AlMAkxRg3HvY66XstbLFnnbtBjIw/NwI1hOaUecO4GjNBN1Sahhv4wK
         0n+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692617103; x=1693221903;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KNwlE0hptEJ+KomxedbhNDZdQW8nX6UaNAvgVOd3YTE=;
        b=Bfm0DPRi9d/zVZsSHksMEO8jqVwZUV/8K9WbK/9lRV98C/Xel9MYbOLa+Y/BqnmAGe
         86eFuXzHPy1Muag5V6FLuFQMCqMUq8FqBUf49DHityXV1+p9IObmOSjExR+JyFRcQPzX
         tkxWyttmgX04mrppvxpkRyyvXT9GPqyBXQ0KO/COr+37rFuSSv3gGEE8oxJdSp2S9sjn
         yvhTcqPevQUc8syBwxrtvpbI/Dzcv5qEFHEXxEdTL/ZpWabPZZ/By9wMGEjadpq2B0KJ
         S+nWGgf3O8tMrSP12Auof+tYbjUyfG8Q7njLLOxH1Of6yg8f+B/4b5cgLxcbF5ZLVl2b
         MHcg==
X-Gm-Message-State: AOJu0YxXrmlPLoDtKrL5U5v5sKwCaGENAa55Kx1Wt0pLLuWw/7Q5z00u
	Xl4tJHdoFbUvpm973+6HdH7ACx38oHk/r6c=
X-Google-Smtp-Source: AGHT+IEyI+l1AmBVra+jc/USX7OIpJ/VyLZPOuiV4jSok8FXOhINKd/eEKL8WvEoKj4KrH4vZ1m4Y2YlYLCvU+I=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a05:6902:18c6:b0:c72:2386:7d26 with SMTP
 id ck6-20020a05690218c600b00c7223867d26mr71861ybb.0.1692617102826; Mon, 21
 Aug 2023 04:25:02 -0700 (PDT)
Date: Mon, 21 Aug 2023 11:24:57 +0000
In-Reply-To: <20230814084602.25699-13-benno.lossin@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230814084602.25699-13-benno.lossin@proton.me>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821112457.1363843-1-aliceryhl@google.com>
Subject: Re: [PATCH v4 12/13] rust: init: add `{pin_}chain` functions to
 `{Pin}Init<T, E>`
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, lina@asahilina.net, 
	linux-kernel@vger.kernel.org, nmi@metaspace.dk, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, wedsonaf@gmail.com, 
	yakoyoku@gmail.com
Content-Type: text/plain; charset="utf-8"

Benno Lossin <benno.lossin@proton.me> writes:
> The `{pin_}chain` functions extend an initializer: it not only
> initializes the value, but also executes a closure taking a reference to
> the initialized value. This allows to do something with a value directly
> after initialization.
> 
> Suggested-by: Asahi Lina <lina@asahilina.net>
> Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
