Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB42657
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 23:47:26 +0000 (UTC)
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-30af159b433so21173f8f.3
        for <patches@lists.linux.dev>; Thu, 15 Jun 2023 16:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686872845; x=1689464845;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WubxQvcgIlFA6V3TisKRN4J5Y421r52QRaGOsMXM65Q=;
        b=eCNmD3yBq/LG530po0EXJGex/14UifXn8/8oZ2uRDyigOyhZRUtX2eLTaBD8dnj2E6
         HVTppvGSLfb/begoPnzgs9rapuzDzYHxDsrNVZJB0OYvH1Ha1W3msZU73nvmWQMaCbJ5
         Ic/BE6dMAAmlXQq560lu7sKpyUWQhSSjxk/aMaECF5wCWuFgp7J1PWkBQ5s2c48sLW9v
         l0tylErb4d4R3Z7+iBw8A4pTbcdT2jf/BwOaUI/C2iXq3wVKc7MVN2XK+qsWiwHpNHEZ
         e6PlPH2PzzKAtMttQpbryGZUuM/LWYcpvMuDdxUEYQURHIgvK8Cho8Uns2wSyLXKQneO
         sEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686872845; x=1689464845;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WubxQvcgIlFA6V3TisKRN4J5Y421r52QRaGOsMXM65Q=;
        b=NQJIuPuOAJ14J1pTKuQUunLyTI0eXJSggtsWIlY0L/YjWMbX3ejcslKfi2pnJPwe+S
         Tk5HAtL9V15f2pc6CkpZqKN7xYhY8eJ6n6xoR/ykxnPesCLxlWtq0H7Noch+fnX+9LJy
         NDtuNx2r9V3OQOZa2LN8sBd4IThH4VPkf1s9VfAUnlkeoA39rB7wVYXhlG94QkjLcXBe
         /b2XtBXOVvkCfRGctrGbyMVIJ9vGlkU5sGV8ehlGbShc2b5Jsxd75zI+zU/Na9ShJJib
         KXxfIhrpTwsDC0hwhJVGrePckcv5DJnHJH5D49FMHw4FfXmp+6wSskhTjqKtZXXTSZ+P
         DViA==
X-Gm-Message-State: AC+VfDw6jMxsEB/VrKTS1HXdcjJ88LPoPI1+EcMKUtmPTlNuncHu2tnE
	vWkiNJKCzt4dKRaXCrqQZtQ=
X-Google-Smtp-Source: ACHHUZ4uQRZfrrUrBPSxeJd4zEcpjQy3rY+wEE0NAjHeOBQE3IquEFE26e0hbiX7l8ujfqF4X565Yw==
X-Received: by 2002:adf:f811:0:b0:311:17af:df96 with SMTP id s17-20020adff811000000b0031117afdf96mr182992wrp.44.1686872844729;
        Thu, 15 Jun 2023 16:47:24 -0700 (PDT)
Received: from localhost ([146.70.132.158])
        by smtp.gmail.com with ESMTPSA id e40-20020a5d5968000000b002fda1b12a0bsm22249612wri.2.2023.06.15.16.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 16:47:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Jun 2023 01:47:22 +0200
Message-Id: <CTDMILRDUJ0C.385MPE3EIPRUP@vincent-arch>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Alice Ryhl" <aliceryhl@google.com>, "Andreas
 Hindborg" <nmi@metaspace.dk>, "Philip Li" <philip.li@intel.com>,
 <kunit-dev@googlegroups.com>, <linux-kselftest@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH 1/6] rust: init: make doctests compilable/testable
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "David Gow" <davidgow@google.com>,
 "Brendan Higgins" <brendan.higgins@linux.dev>, "Wedson Almeida Filho"
 <wedsonaf@gmail.com>, "Alex Gaynor" <alex.gaynor@gmail.com>
References: <20230614180837.630180-1-ojeda@kernel.org>
 <20230614180837.630180-2-ojeda@kernel.org>
In-Reply-To: <20230614180837.630180-2-ojeda@kernel.org>

> Rust documentation tests are going to be build/run-tested
> with the KUnit integration added in a future patch, thus
> update them to make them compilable/testable so that we
> may start enforcing it.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---


Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
