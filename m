Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F1779FB
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 18:28:59 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id j2so14469447ybb.6
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 10:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J7Cbl6yOGS5glTesfz4JpnFGgPjdFsy/hI/Fu3TtNcA=;
        b=drX29G1u9fMT9l6Hp7fcV2qNgmfPxuB59iVHntbMgsAzh0smdUEpBxZICkvBwf1FFf
         UNqfH5/yeOia6fW3ZDVfWdjj5T9hDST/nbTIZiSD2IRZzeYr0arXTPy+uXvzG8ZbLBVW
         92wEpC//TcGJ6N+awQyc4zXJfMAeukg14QxIeluoluAbRVHQToCXLpVshkgTVv+G/ShF
         bpOGkvBpTzkExgO3abE2mr4NGZ9CNzospH7d52qv2z3YJ4PLWdV4i1dwsOTyLTA8EuQH
         K6aqECR+8Dw14+5Lm7NGwepqtapNT5qEuoVajz6zr8d2WFuh6KMK/nQDrH7OALhdCKGH
         OFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J7Cbl6yOGS5glTesfz4JpnFGgPjdFsy/hI/Fu3TtNcA=;
        b=SGtq98sVuDmOiAKg0zRk65M/YJI07RANN/WWs+gpI8mQ1EnxXqfPgniHOH6nrfToFz
         5OBdnqgEH7WvhCLp6HhVTGimPiPdCMHKTE0qaArie5neOxBLOFjjTX8+kxwDNQCnu9AX
         gXROvXTg0/D3LIXFpd9FGcW+0asKW8NdzX2WNlVCbWE4Zlpy0XZSynCNcs/rmtA/boVZ
         HtLKi/pcCRT/pMQXo5fZwB6c54h/vtCzDb61U7B6pajUkms3AukY9LjqVwFww0yQWp5O
         VDRu2jhKsLEX5JvLTB8IIXHusa+wXsK8Ym11jlZno8UWrs1t2+y9A2/nYiRNsC7usHkz
         jlMQ==
X-Gm-Message-State: ANoB5plpVcxxcgpQVZQF9iqo6/wy6HuKghrYFaFCCEzYCiHSkXUVhs31
	seiGOUwnl4pmid1G9pUPC5N2tEsanYtVMo6UfvI=
X-Google-Smtp-Source: AA0mqf5aQ0w73PMOl6ZBZBmojg1Wqgc36djy6RijD/3PnIFpiT6VewzgiT0qKGSOqwdNYTYxj7W5Ew+U+YKkEO9guNM=
X-Received: by 2002:a25:41d7:0:b0:6cb:8949:fdbb with SMTP id
 o206-20020a2541d7000000b006cb8949fdbbmr13428033yba.328.1668450538671; Mon, 14
 Nov 2022 10:28:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221110164152.26136-1-ojeda@kernel.org> <20221110164152.26136-20-ojeda@kernel.org>
 <20221114143928.4dde6589@GaryWorkstation>
In-Reply-To: <20221114143928.4dde6589@GaryWorkstation>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 14 Nov 2022 19:28:47 +0100
Message-ID: <CANiq72=1q8KDtjYqb286Chs7KFi3BXVAyCyHO=bpj+yY25EfBg@mail.gmail.com>
Subject: Re: [PATCH v1 19/28] rust: str: add `c_str!` macro
To: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 14, 2022 at 3:39 PM Gary Guo <gary@garyguo.net> wrote:
>
> I wrote this code when `const_panic` was not yet stable. Now we have
> stable const panic this function could be removed.

Indeed, we also took advantage of it in `static_assert!` when it got
stabilized but not here. I will update it.

Cheers,
Miguel
