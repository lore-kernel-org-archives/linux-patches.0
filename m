Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8B3657
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 23:46:56 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-3f8d2bfed53so1456165e9.1
        for <patches@lists.linux.dev>; Thu, 15 Jun 2023 16:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686872814; x=1689464814;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+cok297KiEkBtIanAPvWodXIpSbY3USJpVP/auvzSoo=;
        b=GEWzOBjU9+uklUn8K1KiJ3HxTLmkUx9v6wLg6ny+j7IskV/jkFniTlJAR6uk0Mo868
         vwY9L0y1g5vpjAyb8r8/zSzXxy0QmvoUcmMGtvPi+2QIUpWX4xbvNneZ2FyvCIHm6sPu
         Dnup7WCuPXYJeUH+qFJmRSZV0vZ+UMxleSRxKdWMkguwHbsEclDn8fVAR38HQErwoY3F
         kYb2oyV43zb+19M5owAo2K5GZat+mnwtrzY5lKzMCKjajvjJuY96IOakuJfxQZyFB6ym
         taMzqIhTty0uhkNglC+ytKNqpjZF1aHvH4hwhZo7cwqUDkaog3xC1YBLkD1c88S+KEJN
         9NGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686872814; x=1689464814;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+cok297KiEkBtIanAPvWodXIpSbY3USJpVP/auvzSoo=;
        b=iqjFRxRr9lmPBnLgmQdaK070V4soZc8VXZSD7jvzD91OCicWnQH+FbdP7ujSa50oVK
         SU0lN3bIQrGaHRIIJwp1YM1CpaT/+matWF55kNqmCZGwUpynsrSULnQk/UsXWkU9FEqs
         HK3MBHINItgJMbajbspdVdj3XBvuQBykkFYjsPrhYGu5Oh/xCbnJBxh2ZixIS9PnyOWp
         erf5UntRsRTuBRkPlLMHwXN/RznLyz2qjoAH90jFRFUgbasqYPnJ5mOPEub2LDHEwWId
         o9c55EBb7c2u0P4SaxU109LUzTKCRvzgfm+NMwB6BtYzQANugO1HKGoxq5P46/LwSzyh
         ly4w==
X-Gm-Message-State: AC+VfDwiBGuf1Y61t/AkjslAmrXW6eQOTaUW8d3eR4vsZEqjlTPN7rOS
	LHqbSnHZYpOktopmivrWLYY=
X-Google-Smtp-Source: ACHHUZ4McPXi8/B0MVcUFH60m4X3rhsNMsiSCE1318ihls99X0Jo2hKc8kOG6o63XEtNWhnh5HVF3g==
X-Received: by 2002:a1c:f616:0:b0:3f6:d90:3db with SMTP id w22-20020a1cf616000000b003f60d9003dbmr194999wmc.3.1686872814417;
        Thu, 15 Jun 2023 16:46:54 -0700 (PDT)
Received: from localhost ([146.70.132.158])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b003f4283f5c1bsm14034217wmq.2.2023.06.15.16.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 16:46:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Jun 2023 01:46:52 +0200
Message-Id: <CTDMI7T6JJCN.3PY8NVQ79IMJM@vincent-arch>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Alice Ryhl" <aliceryhl@google.com>, "Andreas
 Hindborg" <nmi@metaspace.dk>, "Philip Li" <philip.li@intel.com>,
 <kunit-dev@googlegroups.com>, <linux-kselftest@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH 6/6] MAINTAINERS: add Rust KUnit files to the KUnit
 entry
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "David Gow" <davidgow@google.com>,
 "Brendan Higgins" <brendan.higgins@linux.dev>, "Wedson Almeida Filho"
 <wedsonaf@gmail.com>, "Alex Gaynor" <alex.gaynor@gmail.com>
References: <20230614180837.630180-1-ojeda@kernel.org>
 <20230614180837.630180-7-ojeda@kernel.org>
In-Reply-To: <20230614180837.630180-7-ojeda@kernel.org>

> The KUnit maintainers would like to maintain these files on their
> side too (thanks!), so add them to their entry.
>
> With this in place, `scripts/get_maintainer.pl` prints both sets
> of maintainers/reviewers (i.e. KUnit and Rust) for those files,
> which is the behavior we are looking for.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>


Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
