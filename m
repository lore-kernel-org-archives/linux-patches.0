Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B98A1A629
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 19:14:29 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id j2so3453952ybb.6
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 11:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t5QX7uHtfmZJBGSD9wRN2efgSKLRw72121V+CgaBiz8=;
        b=Dn0rsxA4mZcz58cbzTH9lg6bXc5PfKPEKP71oiU39d38QwbWdljJRKX/K+4riEKErV
         aQ/TPalbvCgPeJqEeQDmIJJ3NU8aW3wNOYL54ICglMFYm3ylqZ6ePMfdcxsFtBiolKJO
         NHKRXyYTWXs5s7zHxB2EEgcDsamgHmPCfODhd/54lI+MZ8HjunHOmud3cu+16QEouZBQ
         UX1S4L4FhcLWsUTRWSZr3xmH5vqUkzFElLj4pUGZBzlF4a9TaCkCLHshwHAOHY0jleC7
         rl/COzXtS5c7w9UOM2fhDB3SRAQMSf6Pan160yAi9uNXuvQ+CqKQ6oPrf5ZlxzvBRZMN
         dAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t5QX7uHtfmZJBGSD9wRN2efgSKLRw72121V+CgaBiz8=;
        b=koxopWiDv4UODjPggr6K8VoLxwH0RivOY49llwEIYwF37r0WZdqLxGQlPHf6rf/4Dn
         LWjs+SsAS/oVHor2V8lJJF3tKe9HthyuRKqb/fdOw6sQtSQnItLTOCepBfZzt61Jg9nM
         v1X2LIF9/71BD8mERCxj5McsQrkigk8xEzSzw0i8HIFlVcZYXwBWcwnnepxp4r7aY+ge
         xMGrgek3ysDvGWLLqliUoAd4cBEq64A1LhhICume+nmHIa6N2REj350pXgM1eKyL9pU4
         gzmTqoTYrksBgHI0tLpUbEg997lQf1vKrGEVSzvJy0K/rS14qmnGK5gshzwE/YBXbeLQ
         T0Ag==
X-Gm-Message-State: ACrzQf0FPFcdmMwFgzLIW3ADnxOHXIw+R1Z83UrF9/pPbWe7f9X/HBM4
	S2CdK0H4jBzpJT5q8DSdoo7Tj0de/aNs2MAXYAI=
X-Google-Smtp-Source: AMsMyM6vpNwmXQB6URQ88jmewQp6LACCUdpXdONZgdbve2oZHi8cBcOo2qirgHGVTFWGHi7XeXb80pgjl/OTZPykb04=
X-Received: by 2002:a25:76cb:0:b0:6d1:698e:31e5 with SMTP id
 r194-20020a2576cb000000b006d1698e31e5mr37654398ybc.328.1668107668358; Thu, 10
 Nov 2022 11:14:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221110164152.26136-1-ojeda@kernel.org> <20221110164152.26136-24-ojeda@kernel.org>
 <Y208lVCN3VweD5iI@Boquns-Mac-mini.local>
In-Reply-To: <Y208lVCN3VweD5iI@Boquns-Mac-mini.local>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 10 Nov 2022 20:14:17 +0100
Message-ID: <CANiq72kR3YZv65NYPx+H57XO7T85kioMWMZajRnk7f+ru-3x+w@mail.gmail.com>
Subject: Re: [PATCH v1 23/28] rust: std_vendor: add `dbg!` macro based on
 `std`'s one
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Niklas Mohrin <dev@niklasmohrin.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 10, 2022 at 7:02 PM Boqun Feng <boqun.feng@gmail.com> wrote:
>
> and I'm almost convinced ;-) Better add the gist of discussion into
> comment/document/commit log? Users need to know when to use `dbg!` and
> when to use `pr_debug!`, right?

The docs talk about it a bit:

    +/// Note that the macro is intended as a debugging tool and therefore you
    +/// should avoid having uses of it in version control for long periods
    +/// (other than in tests and similar).

That is the original wording from the standard library, but we can
definitely make the rules more concrete on our end with something
like:

    `dbg!` is intended as a temporary debugging tool to be used during
    development. Therefore, avoid committing `dbg!` macro invocations
    into the kernel tree.

    For debug output that is intended to be kept, use `pr_debug!` and
    similar facilities instead.

Cheers,
Miguel
