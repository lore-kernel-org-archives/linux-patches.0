Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B32F1FC9
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 20:32:29 +0000 (UTC)
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-94a355c9028so102934166b.3
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 13:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686774747; x=1689366747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=czEjt+NjAyuH0cAt6yqFee89woVRFsyvQrYC+0eGV9Y=;
        b=xTtVN4Z1Q88g5rTsccodRHtuT93zYjcUCBrJT95LZIYNDADStxnQxZyTD2EJ2BW+EQ
         gG9WCiqzycuFhB6BgXwWMlIppjT0CNI8UMkUsdxitpwlvLRaBXOIX+CaKxN3iL8IawY+
         4esEjsAM7hRAtYvRzMgVmR9vSolLSnj+kPwM1wlEcomxT4tuscwRvYZ30cqXIjRZ7AFw
         wpfkcDaqNEGH5bwnGlHbj6F5zl51FHU2M19UQIGZSAKRHHsbwNEwK/7ilANmFsnAOzJU
         vDutlW9DFkMHsGVZF254iPq8SURQag7SygVMF8UeUTIN8cRHVAUiAvVUpGHKMl83Fcch
         heGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686774747; x=1689366747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=czEjt+NjAyuH0cAt6yqFee89woVRFsyvQrYC+0eGV9Y=;
        b=ZnqB3MONjmZkWsUgghYZ44Q7HrrtgvDg9YK3N/e75YjS+0FYGyHrHSBrDUkGvFWalE
         nTsLdodzF2G8iWj8p4JH3i1+i1sdBtYACVh07jQtEcJCjCUKe7lwXN8gUhc9Tx9x8aVN
         z0CVJ5s7Sj5zUtdWU4NbRZ3yvGhwwP+oQdiAUQCx7r/QPAQ+FvmGojP9Ctd5uR+E6cMu
         RDWMXRjIDSbvTOqp3GrpaX/p7ZJ7Lq1D8hTtG54UomEZ+s7/8Tjwbj0c2ceMp/f+hQsN
         9xSUOymKAXxM/kLgBWQrrn9IE1RMeTN3giW7HKhLZGj6mIpGiPHDHm0Xni4Ohg4Sj7YU
         aYqw==
X-Gm-Message-State: AC+VfDw52Lo91g7N/NUV1LGHpq0vppUufQX3gNauhmTCbKRPXFhP83/U
	Z5BmzmGmBhz1iOy+yR7jE7MiJzE1cKvl2rg=
X-Google-Smtp-Source: ACHHUZ6QRTP5WMGlZF6ouKyzQXFEVXAvPfgRaI2C78nvnu3bQtIOBOvXIr1gBV+MPRyzc5u+ThXTy0T5ROzw65g=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:2bf0:b0:982:9e1c:ddc5 with SMTP
 id gv48-20020a1709072bf000b009829e1cddc5mr8045ejc.0.1686774747408; Wed, 14
 Jun 2023 13:32:27 -0700 (PDT)
Date: Wed, 14 Jun 2023 20:32:25 +0000
In-Reply-To: <20230614180837.630180-5-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230614180837.630180-5-ojeda@kernel.org>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230614203225.2909756-1-aliceryhl@google.com>
Subject: Re: [PATCH 4/6] rust: types: make doctests compilable/testable
From: Alice Ryhl <aliceryhl@google.com>
To: ojeda@kernel.org
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, gary@garyguo.net, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	nmi@metaspace.dk, patches@lists.linux.dev, philip.li@intel.com, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Miguel Ojeda <ojeda@kernel.org> writes:
> Rust documentation tests are going to be build/run-tested
> with the KUnit integration added in a future patch, thus
> update them to make them compilable/testable so that we
> may start enforcing it.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

