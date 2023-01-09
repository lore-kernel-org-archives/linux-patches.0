Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C499D522A
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 21:06:17 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id e76so9785661ybh.11
        for <patches@lists.linux.dev>; Mon, 09 Jan 2023 13:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ruqurkiOPq/60Ofar99Z98QHHgy9IA7M4V3XUwPdHC8=;
        b=LxtJ+X5iYJcNmJcWpm8rjH0waBDqiQdG88taP2+j4q047HhQOLkKQ8jx0LC/bkrgRI
         kseC7SSxeKQzZ8aUlq45UXd9n6m/9OcB0UsICzX25e59lc7kS7NgzzfgPjM8Ouk973jT
         VBWfXgQ792/ytHcAoc1v2U9mvvmYKV64/XGlBY429/siIJfamy0eVNHCEduLusREe5KI
         Eo83FW6MBM/4Lhx0e3fQqnG3LljPWHuE6468vOsHUEbk9bNwWvVTlQl6zHMonFlu9Jks
         zmDi2+hDjohK5zWF8gGiP5tZZdhqe7ByGL955eFJBeRIXXo7wrOn8MBD/I4SkcS4NrHs
         xqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ruqurkiOPq/60Ofar99Z98QHHgy9IA7M4V3XUwPdHC8=;
        b=HCb8iqSLQxWrAfe5+dWc/RK59jHa0hczkp31VKcUzyG1xUpIJDC/5wdBHjDuCA60oa
         k9CWrDe+POky12nmdBJvdc6h6qyb6hWxuRpXypKHS+J+zMLH1yqX4MGAq2QTbNZ0cYqX
         BhVls8i0lICUoGXGXkJzWiyGXrAyUxw4Ka9dzoZ3ccaPiuOXCfpxgGx8fMGjiQ3eLqpl
         bgnusXCbfVUb+5PobYLRGRm0GaJIe1d6OdSeNO0KT3t9Vm/iEUFiMdUpYj0mVIMhlKft
         YWgJc0DNvJ5l6ucyOr13qQ+ujsYVHHfuK5GdJCwHhm4Ln92riUwCvNvYcBAtyxEujVFe
         WZkw==
X-Gm-Message-State: AFqh2korGawJ0y4td3CSo/SErIJrVXX4RWUYhIQEaPSWGTKi8TOmFx0k
	f7JL62ZM/DEvWokEUKSwI1flO1PNVkkVHvQe53c=
X-Google-Smtp-Source: AMrXdXtV6jEFbH9LeE1FPymK59PmRaEJbE++VCpZc1kGfJiDhWH47gzHv0RWTADEClSW7TO4g6lpJWsTcg61ZqgjnAQ=
X-Received: by 2002:a25:ac08:0:b0:73b:23cf:ad63 with SMTP id
 w8-20020a25ac08000000b0073b23cfad63mr8094083ybi.323.1673298376640; Mon, 09
 Jan 2023 13:06:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org>
In-Reply-To: <20230109204520.539080-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 9 Jan 2023 22:06:05 +0100
Message-ID: <CANiq72m_+xJYUxrwFc7vNLkuOb6zC-W-wDzXjbPb8Ursqzwiaw@mail.gmail.com>
Subject: Re: [PATCH 1/6] docs: rust: add paragraph about finding a suitable `libclang`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 9, 2023 at 9:45 PM Miguel Ojeda <ojeda@kernel.org> wrote:
>
> +* Or ``LIBCLANG_PATH`` can be pointed to a ``libclang`` shared library
> +  or to the directoy containing it.

I just noticed the typo here, sorry: directoy -> directory

Masahiro: if you take them, please feel free to correct it.

Cheers,
Miguel
