Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE681A629
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 19:20:49 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id e68so671661ybh.2
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 11:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r5bxCyKZFPEMnYesOrxO0GPZIIFmmUudJDEr+9p0CwI=;
        b=SB6+Zp37yrYl1KjihfUXIB2fnmBj5/nehOR6lap2Kdjm+IIKRwZYIhQty9NZzVRRC1
         DxWcuwrmU6MsMba24hfDpnNrl8yoEqHULg7D2445JtXimJQzf6ica9lErDKxLkm+heJE
         2CNGMb3VW7mVD2ay2uLuHckxmyNpDR16FYCLwk7ZaN93NTDs/JN9bFhIvRNwhXJ6rVMA
         RFywIK0NEXlfpYeCTJam+U5bflZGn+R338pSq5XNaRkk1Tl6lX3d8wpqJ0zRm7T7wqIl
         RtB7EOVFR7vd3hTvRw2Ee2AJgiVYu7HIebcgwQVCsfe8iiBOk1UZ3maL+h1GwVZJb5Gw
         ew0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r5bxCyKZFPEMnYesOrxO0GPZIIFmmUudJDEr+9p0CwI=;
        b=yHzFeg2xDxKq02Paj0NKqTa9FS9YMSsOXv/hNJ0Q/8R7HkVAG+X6cPi9duCfMk707s
         aLfehca7ccOFxHn0LxDUbcQRjb5DEYqg0oeH7KuVsUupTcYme0KkU5thlu4mIjvSdsh5
         JLbRFEOiG4hcdZ+KlhOyN6K1375Szpt53SWW7o3gu0ftuNxd199YuWDhkr9G5agwLX2Z
         D9kBAN4w3KXyfE/WGizd4qM9ekCz3b+zNfPatmuzFWoELdKMJflsMWVzyrh/KJ1HlgeO
         SVBUwrCn/iV9Ck/FVA+lJ8JKvKe8ym5JYpCLUKIdZi4ANsR4CHZ7/GEG8Pu9hiq7StRq
         rGhg==
X-Gm-Message-State: ACrzQf0HMG5DGRFmy7hn5ONuCYpgjCoAzmh6x6zU2NbukAPWhbts/+RU
	gusQLlJ0bLDdvxN6UcWNcjQLUCGmAgD1Rn2DgO0=
X-Google-Smtp-Source: AMsMyM6ujXB3E5qr8ACm7ChQ/98dmuYWx1qvcPzOksm2hYQukBm3DXCr5HN1zEsHEYSqPgDLPnegt62/qQ7BID7N4G4=
X-Received: by 2002:a25:bc81:0:b0:6cb:8949:fdbb with SMTP id
 e1-20020a25bc81000000b006cb8949fdbbmr1288650ybk.328.1668108048105; Thu, 10
 Nov 2022 11:20:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221110164152.26136-1-ojeda@kernel.org> <20221110164152.26136-24-ojeda@kernel.org>
 <Y208lVCN3VweD5iI@Boquns-Mac-mini.local> <CANiq72kR3YZv65NYPx+H57XO7T85kioMWMZajRnk7f+ru-3x+w@mail.gmail.com>
 <Y21N+GtGsqzaPSFp@Boquns-Mac-mini.local>
In-Reply-To: <Y21N+GtGsqzaPSFp@Boquns-Mac-mini.local>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 10 Nov 2022 20:20:37 +0100
Message-ID: <CANiq72mXxcLyf0EU7bcSHGMHZHNKmkxtyMEA72a4gfZeJH+z8w@mail.gmail.com>
Subject: Re: [PATCH v1 23/28] rust: std_vendor: add `dbg!` macro based on
 `std`'s one
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Niklas Mohrin <dev@niklasmohrin.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 10, 2022 at 8:16 PM Boqun Feng <boqun.feng@gmail.com> wrote:
>
> Yeah, having some kernel contexts is better ;-)

Agreed, and being able to tweak the docs is, after all, one of the
advantages of having a custom version in-tree anyway :)

Thanks a lot!

Cheers,
Miguel
