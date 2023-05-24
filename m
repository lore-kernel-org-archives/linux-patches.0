Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BE218C08
	for <patches@lists.linux.dev>; Wed, 24 May 2023 12:33:34 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5128dcbdfc1so1000745a12.1
        for <patches@lists.linux.dev>; Wed, 24 May 2023 05:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684931612; x=1687523612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XZafPqgI9Fb4pogcf8RRb1JCJ1KFVqaaBis24tWL2C0=;
        b=6nLPqQkHIbAbRRsrRMRjIaMSxB8wTAHe51+mF9Ro3EK6sZAGVNp7lyfPZztpFwZTXh
         z8VZPUGKeJukHFmyAzqI20VUE9rUSlxm9G3Yi95DGQZOPXEmEh0BXj5AaG9ZfAfiTVDh
         +3wCp8HgcDP32GpMMLsnNDm51CUz/p2Y0dDom6bYLprj56kHfnOsr1Et+ErbIdGbMejk
         /RVyC0E1D4dgHkbc16XZf6WQqd2INAcwgj+mcu3N/MTQpix6xA5GC+F8JDCyf6aYcMc7
         /nUgh1gRYQieFevxn19EJByi5XLeozkDDxrJYxrncCvqtGMUsihyArzJ4VQ/mgEzuyjF
         2oVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684931612; x=1687523612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XZafPqgI9Fb4pogcf8RRb1JCJ1KFVqaaBis24tWL2C0=;
        b=cjLzeOCOerzXNx9g8OWmTxcpAukSJYtOc4ULu4ARTiaWVtGJQfLPSzk47Io+y7w3Yd
         PiBD1KLL2382ga+W046MhQqzskQMxXfiw+Gy17mf8ITT/vu1n7Dj+pzyLD2a0U00r0gT
         IPROAN1JCBjp+HJ10THf4SCMHjV0viPh2QBieKCUkZBU9DzkXEXPqjbwxq+u0da2Flib
         dBwJuKCMCoCQfgjpyN+8k9A+sH6flxfiD9KMenp0ugTeqS/F++9vA8eNhpYaIpC+osGs
         KiJ8QqdWuAijG29HHM8Fojq4hzn1u0uVAdWpkA+hn1SVmE6H+82w3VNOatamtb/XKnx2
         ICiw==
X-Gm-Message-State: AC+VfDyz8/I4Vu4zlaSTiCb2Od4tf4441OR7oimcqa0Ar5YGDNbGCJId
	YDiVS9v7QL6br+7T4D+WBZipcoLRGpAC6Wg=
X-Google-Smtp-Source: ACHHUZ6nEk5+MTTdAeuKBA1sa0MKBRxd3bRqOe3lsS32BwxY4I+/jQylsZCoMoxlY0J3DOW/9hm18x4HO2Uf4a8=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:9f2d:0:b0:50b:fc7b:de7f with SMTP id
 b42-20020a509f2d000000b0050bfc7bde7fmr922098edf.2.1684931612445; Wed, 24 May
 2023 05:33:32 -0700 (PDT)
Date: Wed, 24 May 2023 12:33:30 +0000
In-Reply-To: <87ilcjdthc.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <87ilcjdthc.fsf@metaspace.dk>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230524123330.2501843-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 0/7] Bindings for the workqueue
From: Alice Ryhl <aliceryhl@google.com>
To: nmi@metaspace.dk
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tj@kernel.org, 
	wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Andreas Hindborg <nmi@metaspace.dk> writes:
> This does not compile for me. Could you link dependencies to be applied
> first?

I messed up something related to the patch for specifying error type on
`Result` [1]. This patch doesn't _need_ to depend on that though, so the
next version of this patchset should compile without it.

Alice

[1]: https://lore.kernel.org/all/20230502124015.356001-1-aliceryhl@google.com/
