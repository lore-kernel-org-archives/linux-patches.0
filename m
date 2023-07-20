Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0AA19A0A
	for <patches@lists.linux.dev>; Thu, 20 Jul 2023 13:06:23 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-51836731bfbso501679a12.3
        for <patches@lists.linux.dev>; Thu, 20 Jul 2023 06:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689858381; x=1690463181;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/at4jH27H21CsYZHQRwVsYrLL9KruC5VGWS/DvqAKHA=;
        b=OFaEtpUYyMNFOM0NfFcg7nmMcRS3nqz23n4mURCNglVm571UlAJZEZV6pB6LIaUakF
         o/yI2oUJb6FBAhl3Y55XKklv71Sl3gw7TxlZX7lmPxGHlAmg1dxIf1iQaMHOlN+0NwNr
         qTES668VPErVm21NQS8OUWi3vKlfSFwMF26e3jXz/lEVAoGljJsMZGF9BIWmqvgrecLx
         WyeN1k2916KjQj8OjEIB3OF8mFgjh09x1iYSn8R0s2xoGoliiNWGJYH8eSOOldYbpnaS
         8LTVVW963HandtodZKVTgOMmWWvKzROlqPVliJfPhyVzcnWKRQINGTTE7yObFsJzRElQ
         MeIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689858381; x=1690463181;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/at4jH27H21CsYZHQRwVsYrLL9KruC5VGWS/DvqAKHA=;
        b=RUINwaIRAJRlq8aalNy300MXRdfLsCNcj7dBAGWXokiK902yVMR7w0WZdbxeL0ia0m
         H1tYeCWSJvaKAzz/wxbshE7+YpUFaszVA1fk9Ac1s7MUSTHuJbViVQy8i4QRxag77kb7
         PZzP0VlMJcB4UYiPV6Q4DG59j1MNkiVOlcbOxAb39b3CwV6HvSoZI95L1ZRqcQG9amqN
         YCOjO7M0ZzRf1YIq2IFXM3K1VQJ+YI9ytA3SscchiiKmoccIqVUNQsFb9AjNJXjxEmh5
         CajCY9vEe9talS2aaHQRucjJiSEo6RS8FVCeWbEkygYesRJAhfC/SULJZs6z9zNpw6cn
         Nh0Q==
X-Gm-Message-State: ABy/qLYkO+uBFsV3OpCcgr+a601jFVfA3tZKosOw0CEetTNj2ty95ekt
	fpIklWlkRaCx4HnNCGa8bNzD4ANECG4Kze4=
X-Google-Smtp-Source: APBJJlFaiCJripTrjFUxfCIu9UUdHNJum1sFAyZihhb7NiffEyNZF4VvsIcfcvuWRtqY0P7MYcK+iXDdXQdDWro=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:a454:0:b0:521:822e:2f34 with SMTP id
 v20-20020a50a454000000b00521822e2f34mr24665edb.8.1689858381638; Thu, 20 Jul
 2023 06:06:21 -0700 (PDT)
Date: Thu, 20 Jul 2023 13:06:14 +0000
In-Reply-To: <20230718054521.1048785-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718054521.1048785-1-ojeda@kernel.org>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230720130614.3409059-1-aliceryhl@google.com>
Subject: Re: [PATCH] MAINTAINERS: add Alice Ryhl as Rust reviewer
From: Alice Ryhl <aliceryhl@google.com>
To: ojeda@kernel.org
Cc: a.hindborg@samsung.com, alex.gaynor@gmail.com, aliceryhl@google.com, 
	benno.lossin@proton.me, bjorn3_gh@protonmail.com, boqun.feng@gmail.com, 
	gary@garyguo.net, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Miguel Ojeda <ojeda@kernel.org> writes:
> Alice has been involved with the Rust for Linux project for
> almost a year now. She has been primarily working on the
> Android Binder Driver [1].
> 
> In addition, she has been reviewing patches in the mailing
> list for some months and has submitted improvements to the
> core Rust support.
> 
> She is also part of the core maintainer team for the widely
> used library Tokio [2], an asynchronous Rust runtime.
> 
> Her expertise with the language will be very useful to have
> around in the future if Rust grows within the kernel, thus
> add her to the `RUST` entry as reviewer.
> 
> Link: https://rust-for-linux.com/android-binder-driver [1]
> Link: https://tokio.rs [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Acked-by: Alice Ryhl <aliceryhl@google.com>

