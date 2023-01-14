Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B3A33D1
	for <patches@lists.linux.dev>; Sat, 14 Jan 2023 12:12:32 +0000 (UTC)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-4c24993965eso313382627b3.12
        for <patches@lists.linux.dev>; Sat, 14 Jan 2023 04:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocG+aQYX3J6pPZiaecLuAdSLxqQP2C97Q6clgYMlPSQ=;
        b=NnTUf4zMPGcuJ6iWKPXSOQftiob0xB7Hg/1iZUp5RaIZwPisRkMZ6aSHAyd6P+G6xf
         0bj0mYQz7wfvxYCF9HSGHnF2Nwde7H5fkl3u1aEznXqeS/D22qj95sAETiNhl3PVZW4n
         FuLhGW4vqCUSBXe824IQ1DVGVf0kJIiMKLtQcK0dvW5uoVfY02T7pZ+wia4FKYqSm821
         l6FLI1h9zFMCtK37fOWufwrXnEIL8HxipROm+S+n6akXZ1hJevJAuyq6JZPs7RA6ryfi
         UktJFQaaI5z+IuSw31GbU1wqvS+4x9gVGjcTZk0I36dxhAq0QailGg+nDEh00yjzWl+9
         OEjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ocG+aQYX3J6pPZiaecLuAdSLxqQP2C97Q6clgYMlPSQ=;
        b=hZMpP5mt/L9tkWvnkun7LTa6zHvBPih/E5T4xN0VTasZWGu56ZiAzaVqPYLLOsKNs0
         qc+j9gOsxcPb6fuQDjHv3OdfF+dH+Kf4E7pqy20j81FE9sssertJfKNPQ43iZ1LgRELw
         SiWRDJyFFfWsRibz8lYOQbgCuSnK1UMvMBeDXv7K74wngMH1/wDXH0SeF1nCFf/WK9sB
         h7LlORqZvDRPFEbAVHFfufZ6j6XQvMimY0fZ7YlHLGTpR5yHoxZkG3U/x2ctBJ3ATqMp
         /Y4KwnZrrC5eYNSyIgthFG6km5YSDdwP+9LofQXIPzgEnuYLPGjTtCrA+3RKUAsgXzf3
         f85w==
X-Gm-Message-State: AFqh2kr2eT5y7ka35aw+2FLSYkgnDIdYOg5nqQgdyXDvGZoZGagTqJqs
	7auaimL3rCvt9+NMuYVoRWxfxyIiNb0JhabdmDY=
X-Google-Smtp-Source: AMrXdXuMmb7KLM5QgZsTcsQwoQKe4cn16T9y85eLJUWL3VYmrFA94ufuFZpeh1+313LveyMesX8TLRkUmKEG37iM/w0=
X-Received: by 2002:a81:b60b:0:b0:45c:d900:f30c with SMTP id
 u11-20020a81b60b000000b0045cd900f30cmr3752622ywh.256.1673698351831; Sat, 14
 Jan 2023 04:12:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-3-ojeda@kernel.org>
In-Reply-To: <20230109204520.539080-3-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 14 Jan 2023 13:12:20 +0100
Message-ID: <CANiq72nZ0YUYOUO4NAKDzQKisxguovb=f2f4uNcL3TqwEWRQeg@mail.gmail.com>
Subject: Re: [PATCH 3/6] kbuild: rust_is_available: add check for `bindgen` invocation
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alexandru Radovici <msg4alex@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	=?UTF-8?Q?Fran=C3=A7ois_Valenduc?= <francoisvalenduc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 9, 2023 at 9:45 PM Miguel Ojeda <ojeda@kernel.org> wrote:
>
> Reported-by: fvalenduc (@fvalenduc)

Cc'ing Fran=C3=A7ois who gave emailed me his name and address, thus a
better tag can be written here for v2.

Cheers,
Miguel
