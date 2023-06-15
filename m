Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D15657
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 23:47:51 +0000 (UTC)
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4f6370ddd27so29325e87.0
        for <patches@lists.linux.dev>; Thu, 15 Jun 2023 16:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686872870; x=1689464870;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yf3QILbJ9sRzhzF2PoMYVw4hbclOb2Vg8iQx5dyLYzo=;
        b=S4+7X3x1MhqFzqF9Pbyo3LB9150OMrfgzHssXAOFbs+kKShkgkyJgmh0sj0Oa2pW2I
         LZYMhJpAa7c+4T9SCC5YTnJi+scaa8sjVadtbIwe0BtYwEkrotPDh2y/q69n8WPqPVqh
         oniQbg9blKOTUba17yBY2EwEGVmOFpoCwoQgR6UrZCQBxiwX3eMO5DL3kVNmFg6EeHng
         8KKXap7ppdpqZQu5oDYb6/N+MaaAq0FPoTaR+gEoAikK5YP3r1snl3qcwCguTat3QDIY
         /aggYUfMCjBfVgwe7IAq+Maj3aQAGdS5zZDoSZ6kyuyGL8UQuS5ZUbekPdToazAjSo2V
         H3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686872870; x=1689464870;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yf3QILbJ9sRzhzF2PoMYVw4hbclOb2Vg8iQx5dyLYzo=;
        b=Ov8uoasKMd8nZeJFJX0GlmYk5H9phz+d6MgqBTfoKsNOfeNcFMLRQwi/jGUEA7LKP+
         U5etTg54/W6ODdymSA8KvfZSHa1FO/9bXTYf6eYDz2KB8iVNzla9wLAgRqks1e/TwuA/
         ms5P0AyghM3W9wuaXK2TbjCaPWeaKTG/QRm2DsNXLmqt6TUI6hijDPLLKb++kzBry/St
         hI7gFVANEuTQXvEtP9bRQvJvkeNFpPnIMoLYw23gCGXsqGf1y3Q+jBK5wqj3f6VrjSSh
         fS37a/FJKIGaGxLPhOUWlNClrv1vE9Hu0whHkFOgwJUqZ1lnbnAxx1Vt5hIYKgOTpaN9
         XafA==
X-Gm-Message-State: AC+VfDyZ5t0PIpCfFtPTbkw7Ous8ImZ0aVNsDHSacr7Z61kc6Rhoe3on
	aGEFNrTx8RkLq18DK72ikEY=
X-Google-Smtp-Source: ACHHUZ6YbWrh09j2k5T+J04sVygSmkwhQcbZT+VQj3PFb8ngeE1UFNS0aCe1XG9mA4jGqpqCcLpvxA==
X-Received: by 2002:ac2:5bca:0:b0:4f8:4263:433 with SMTP id u10-20020ac25bca000000b004f842630433mr94075lfn.66.1686872869344;
        Thu, 15 Jun 2023 16:47:49 -0700 (PDT)
Received: from localhost ([146.70.132.158])
        by smtp.gmail.com with ESMTPSA id y3-20020a5d6203000000b003062c0ef959sm22130703wru.69.2023.06.15.16.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 16:47:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Jun 2023 01:47:47 +0200
Message-Id: <CTDMIX08TTIR.AM5Z9I4YE6XQ@vincent-arch>
Subject: Re: [PATCH 2/6] rust: str: make doctests compilable/testable
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "David Gow" <davidgow@google.com>,
 "Brendan Higgins" <brendan.higgins@linux.dev>, "Wedson Almeida Filho"
 <wedsonaf@gmail.com>, "Alex Gaynor" <alex.gaynor@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Alice Ryhl" <aliceryhl@google.com>, "Andreas
 Hindborg" <nmi@metaspace.dk>, "Philip Li" <philip.li@intel.com>,
 <kunit-dev@googlegroups.com>, <linux-kselftest@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
References: <20230614180837.630180-1-ojeda@kernel.org>
 <20230614180837.630180-3-ojeda@kernel.org>
In-Reply-To: <20230614180837.630180-3-ojeda@kernel.org>

> Rust documentation tests are going to be build/run-tested
> with the KUnit integration added in a future patch, thus
> update them to make them compilable/testable so that we
> may start enforcing it.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
