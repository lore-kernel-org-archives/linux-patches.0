Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188D076DD8
	for <patches@lists.linux.dev>; Thu, 21 Dec 2023 21:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PLncX9s0"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-dbdb12203b4so1232317276.0
        for <patches@lists.linux.dev>; Thu, 21 Dec 2023 13:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703194962; x=1703799762; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qc6DvoHCBo6SR0ql109kb11eHuEG/z5z0j0o6Yh0aEs=;
        b=PLncX9s0cx3ZViDHXxwZx741qtHFqVaySet0LD6Qm7oA0+5etCMQQY0V5Bvq24Fugj
         XRBubqLL/8hNoiIvXhMNSsQFK1dZfoprPWJAkjJSUfh3BduwyWGBvkddQ3VZSCNH/rv8
         7HVspalHIbXgi/NWp0SdBg/7pbNW/7pvZD/HMyZiXMjZ0Bmpvj0lYI3x7gRWlAbwU3S3
         caTbUD+1vCwMTTSRU1sfIB+myEy03YAhSWOU9ybUdeNOXttehXby93GDjmvWuJI/nvX/
         ioOsF2HuQ2JJG5Elgk/9ySbwa4sfZFC7+evknBfaqc7wWAGjMkeDoirwxSoxklcaw7aH
         8KOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703194962; x=1703799762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qc6DvoHCBo6SR0ql109kb11eHuEG/z5z0j0o6Yh0aEs=;
        b=wnSK3Hp+wBbe4gnNLZ9IhjBn4f1M08mKVM3TuYQ0swBM/KR6Xm7X4/y1lVf3ZtCbqb
         tMhoFMq5gS8k/MJdifjhhCIDEnZtSvYAyPMLvkx2zbBg8vPZVenPXol/9pyQvU4NILYJ
         WVpRQa98zGdIBFnT65HXRGrNBCOJT/ydq1FiB1DoEGo0db4WfdEw6QeH7TBam9+I3cb0
         BzBnW2C9V/+IaIiXQxLb2QNGCpCPXolQY43gkhzIJKjJlHQmwhdqd3Du//A8rKVcBL7E
         jT7cxqsymBKSreXrCVfyUSUh26UpiJ3I7P0wHtBpQSVvETEnbpzaAJ7DeF3nQy1iO9lt
         MN6w==
X-Gm-Message-State: AOJu0Yz8C9+zLUyUUinYyeMgF8Ve1m4Cia341GLbX4EEgOIKzO79pU47
	TM16uUAYJX7IanXEIMZFgvIQv300eJY8pXKFI1E=
X-Google-Smtp-Source: AGHT+IEDxN5fCuZZQgeRAfx8XcLajEsgJW1NOnjf/1K4gD06U74Wnhm26W0sYXsjWx1oM6A96HMSn3m5EMWm/hq7iIU=
X-Received: by 2002:a25:6914:0:b0:dbd:c9dc:8751 with SMTP id
 e20-20020a256914000000b00dbdc9dc8751mr380198ybc.102.1703194962157; Thu, 21
 Dec 2023 13:42:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214092958.377061-1-ojeda@kernel.org>
In-Reply-To: <20231214092958.377061-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 21 Dec 2023 22:42:31 +0100
Message-ID: <CANiq72mzBnHTZqsy+VN3dbHy1OF0DcSiknULpgMnxy_-FZRk4g@mail.gmail.com>
Subject: Re: [PATCH] rust: upgrade to Rust 1.74.1
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 10:30=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> This is the next upgrade to the Rust toolchain, from 1.73.0 to 1.74.1
> (i.e. the latest) [1].

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
