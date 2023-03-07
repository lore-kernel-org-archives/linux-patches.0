Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B1E290F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 09:26:20 +0000 (UTC)
Received: by mail-ed1-f51.google.com with SMTP id g3so49747720eda.1
        for <patches@lists.linux.dev>; Tue, 07 Mar 2023 01:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678181178;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ztapAqrp0P0arwM5QDm4n16xyUTGqlP0zUmPheiyv8=;
        b=ajw0Ap8dLJ0TFUrTkUnw3NQh/6Hl0eG+9B/0Z8Yq8vvj9ltkeF2rPq7WWmcgAjZVkF
         bxz27W2e73rYXr0qP7TsVMmHHd3f2707LiWu8HnA9FJJdGvjByP3u2JwFrd+2IEjpMh2
         VXx1liWRNYheg/Z4ARSHN7aAPHjB8ZJYzp8GAq668mmoAGIr860MEy5QgntC+Qdtmr2Z
         Hcr+1aAyzC6pyp22E3MAl0/YmvGo/OHR8BJgORQLg4SRU6CJzU5CfdF5hl8ZLz1VDKrz
         UnaKsxxdqy26QfWtTtfYH6+AkiCn2lq6EjqHDHbBX+zcFLevhTfHK+m6BBWqML6HxdzI
         Qv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678181178;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6ztapAqrp0P0arwM5QDm4n16xyUTGqlP0zUmPheiyv8=;
        b=oLMR3brWQgGBE45Ao7TohH0Npx7o6L5NO29Dr5bBuzmU8nq3MjZ0Qz+ufdJ4Whl2hu
         eg96hGfk6TL6494/gEQfoHpUJePG+pLxaoIt4AQGJ/qS2p1o0iSWNDGKDb+uwA75XHBI
         Ra3AAd3WebqHVqFvNwGqUUNrXIOQQkgDWGOtL+sEiHtuYwhpJOYoke8R3PRThyEvRJ1t
         jLMEfI2m9pZF9eAb22csWkAYhgFWUWmyJzhHfLl5DYqM0dxwFBiYVXon1vLDSp0XjwFL
         Vfs36cqxemzuVHFVWJRmwfvd27Pethp52RQ/wLWxD659VfWX6u0ecVqurgahZZl4PI+Y
         MLmw==
X-Gm-Message-State: AO0yUKXnBN1e2+jAENHNCGiHLTQfsJ9+14asd98BmpA7rxomUodnhGwt
	6FZCw3KJYViz6yOV3ntxScE=
X-Google-Smtp-Source: AK7set9vnOx118VHRJHv28HiwsiIKXKtrIehHz+W/nZGoYhuq4nLXCAiKufIQdTAhvQTJ74zUjoavQ==
X-Received: by 2002:a17:906:fa82:b0:8ea:a647:a5aa with SMTP id lt2-20020a170906fa8200b008eaa647a5aamr18566645ejb.38.1678181178059;
        Tue, 07 Mar 2023 01:26:18 -0800 (PST)
Received: from localhost ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id hb15-20020a170906b88f00b008d09b900614sm5741459ejb.80.2023.03.07.01.26.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 01:26:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Mar 2023 10:26:16 +0100
Message-Id: <CR01KTDBXXM6.1IJUOC2OAJQX2@vincent-arch>
Cc: <linux-doc@vger.kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH] docs: rust: point directly to the standalone installers
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>,
 "Wedson Almeida Filho" <wedsonaf@gmail.com>, "Alex Gaynor"
 <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>
References: <20230306220959.240235-1-ojeda@kernel.org>
In-Reply-To: <20230306220959.240235-1-ojeda@kernel.org>

> The Quick Start guide points to the Rust programming language front
> page when it mentions the possibility of using the standalone
> installers instead of `rustup`.
>
> This was done to have a hopefully stable link, but it is not too
> helpful: readers need to figure out how to reach the standalone
> installers from there.
>
> Thus point directly to the page (and anchor) with the table that
> contains the standalone installers (plus signing key etc.).
>
> If the link breaks in the future, we can always update it as
> needed. And anyway having the full link includes the domain and
> gives more information about where the old docs were in such
> a broken link case, which may help.
>
> Link: https://lore.kernel.org/linux-doc/CANiq72=3DgpzQyh1ExGbBWWNdgH-mTAT=
dG5F600jKD1=3DNLLCn7wg@mail.gmail.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
