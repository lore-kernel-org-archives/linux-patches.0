Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7DCBA57
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 23:31:06 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id d62so8048137ybh.8
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 15:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8x+fgQ2I+pqMaMW/X5cHc/YMKvj8qdTDIS+NdFNCDfs=;
        b=UfJhXVJb1zWU33EOx/tQXgiCDEU01jCZSsPVbZIiPgBaKFDfZNX0lZLjS108G07PUG
         FMWkrMhxWibRRQo3QQHDsFAt1R1S8aYvXIoUu6KyT8bA5q3INPo9T/TYrZGvXlwr0b2i
         ysNr3Usj3/vBXtcxXgklg5QZgGqZyn5AYSbmBldrOYpatdZjtOp35qAtlFkclQrATi6T
         9MpCMO/Ze0RJ10tc8gTW8tnJrGrrSKyklsR9S8sNTSqF5wsFn/5flPsTiB8FmSesbYup
         u26YHzPZjXNw+A4AoMD1fJaW6xATtQrfHItSeX+iOFMKgp4I0wM9tMCrkptVeelW+xkJ
         F6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8x+fgQ2I+pqMaMW/X5cHc/YMKvj8qdTDIS+NdFNCDfs=;
        b=4XIIMk5/imkmNAnDliUhVb5fIub06r5Mm3P0o6Ra2YdZc8Io+/0Xlrg3gBijDhsel3
         v+M1fYr+XepTaTowZ0fCVrH7IFI1NtzSGDoQtLFWipdaXhlz6M5RgB8fix1bwINglsCT
         ZNsC+nTj6vR2J2etugZi1UtKslkk5+vVfGk5SohJW/EROzjKUfqb6GmkDatVh7URwr8X
         VAX8s/zBA7IC34i8kWY0wOfQER+jNt+RWLIkXIlmarLBi5FGVraRPBCBlANPgP1PY13P
         OcKv/7SbFS265c4ERdHCB2svdI1B8Isz25MR8OBs3RUlq6c5aU3LdVMXn5hAYENvtL+C
         oA3w==
X-Gm-Message-State: AFqh2kqLlidyjQuT1eXRMCEsjAdM4pJ1MKN0GmrqqlQ1ey94mCuH4jvn
	gu4L91t+L5RXBc4Pmumjll6O9APxv7UVf82URgU=
X-Google-Smtp-Source: AMrXdXva20Xrfbl+zo3SLpX+v/KZPjReiMCBsty5G9qfiJpanHD4htIziE8YIoEbPoyqjtYrmzhByrDdsZ7Bq44udRs=
X-Received: by 2002:a25:e6c7:0:b0:7cb:dfbe:3996 with SMTP id
 d190-20020a25e6c7000000b007cbdfbe3996mr620654ybh.489.1673652665276; Fri, 13
 Jan 2023 15:31:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-5-ojeda@kernel.org>
In-Reply-To: <20230109204520.539080-5-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 14 Jan 2023 00:30:54 +0100
Message-ID: <CANiq72=FZB1_muUYq=ZGPvY5jfTgg8FqcKnG=E1BMQML5rVG=w@mail.gmail.com>
Subject: Re: [PATCH 5/6] kbuild: rust_is_available: fix confusion when a
 version appears in the path
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jordan Isaacs <mail@jdisaacs.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 9, 2023 at 9:46 PM Miguel Ojeda <ojeda@kernel.org> wrote:
>
> Reported-by: Jordan (@jordanisaacs)

Cc'ing Jordan who gave us the email address in GitHub and wants to
send a `Tested-by` tag.

Cheers,
Miguel
