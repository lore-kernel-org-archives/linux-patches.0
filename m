Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DBAEAE5
	for <patches@lists.linux.dev>; Sat, 16 Sep 2023 10:52:30 +0000 (UTC)
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40479f8325fso19040925e9.1
        for <patches@lists.linux.dev>; Sat, 16 Sep 2023 03:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694861548; x=1695466348; darn=lists.linux.dev;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NkaN8cKyKQ/v2N4UZS/i+2Cr3FWbQdqVVYD1cTsC53I=;
        b=Ykgw6z99sklbkcToRGSxnWQ3oHi1x/eEXL9pu6ej0kX76SzfJ2c5UFQ7QNIrMcLY5J
         7toP8ba22WeHzJgqt6gFtjsHB4NnPd+0HcP50jXCKxb4Saj1nNeMONLHCTksB78MSB0u
         VppoqjDFOymF0Vhqrrrikg3E+MlfB8sYdAt7S8Ap/2SN4XrQPNIlaSJnnI580qiZO4iq
         bFug+RGUg9lNPMBP50Tjx43D9m7610Ml+cqv8Z147f1KvcTfxtVbaR33SXU6YIVcj+Wq
         MsUBtQJL+atDIg9DaOcbVE27dYwfhhm8VXQjNsfmaWsrDxSuE1QwtSjrws1bzHi2eGqD
         dK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694861548; x=1695466348;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NkaN8cKyKQ/v2N4UZS/i+2Cr3FWbQdqVVYD1cTsC53I=;
        b=e3lhp3ojsdkp/alDaIGq45sTFOLqK0mQmk5PLGETWJEWi0j4CZ8uUcu3QRaeU3Ahpu
         hpxQC4BdwmwbPLi7mRUct63M4GuXsf+Akl4fjltpTIOi2k4g43oHs/HOhpDz6C2a9JJC
         sN4HHqzJNu2aP1lGEjHsREHXfyuRdHSbo+CrjIWGHmoizw907BzpjYaEulWx/Xma3KUK
         9TGA28cVbyD9mOhChPpOZ0lnqsES/kMtQG4LD6BpwZ5vARp4vZbF5GCPbgzAYSSLBgYX
         OnFMtydBSzjKNRws5tk9htHvQkdqCVSCEnNb5k5HgieESgMNW/TO2X4I0TAYRrTQzWoV
         kExg==
X-Gm-Message-State: AOJu0YysFW/sSbnXanl3z0Ww87hm3/E0FaLc/addQgdz6AQOgxI1aVfr
	8t8KdiA49oKon1ENazEawAc=
X-Google-Smtp-Source: AGHT+IFdjBX4VSeBZn0JpdO85JrcBe0bVVpLDZ4NtoJf3Oru0QM0aSmeH6zWGbp6bEW3eVbBqI27SA==
X-Received: by 2002:a1c:7203:0:b0:3fe:15f0:dfbc with SMTP id n3-20020a1c7203000000b003fe15f0dfbcmr3689181wmc.12.1694861548123;
        Sat, 16 Sep 2023 03:52:28 -0700 (PDT)
Received: from localhost ([45.134.213.210])
        by smtp.gmail.com with ESMTPSA id y15-20020a5d470f000000b0031981c500aasm6838175wrq.25.2023.09.16.03.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Sep 2023 03:52:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 16 Sep 2023 12:52:26 +0200
Message-Id: <CVKA9XPFB9BF.2UL40PGKDJ00P@vincent-arch>
Subject: Re: [PATCH 1/2] MAINTAINERS: update Rust webpage
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Wedson Almeida Filho"
 <wedsonaf@gmail.com>, "Alex Gaynor" <alex.gaynor@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Andreas Hindborg" <a.hindborg@samsung.com>,
 "Alice Ryhl" <aliceryhl@google.com>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20230830165949.127475-1-ojeda@kernel.org>
In-Reply-To: <20230830165949.127475-1-ojeda@kernel.org>

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

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
