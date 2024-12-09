Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6070319E97C
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 23:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733785845; cv=none; b=JgLFlbiNJe8Kskt3zx4L8INOyQyI+I0kWam84ZjXqPq1/C4ASa0/VgJDQoKJyehz19i9mlw0YIykJz4lU1fl7STIupJ3DXKs4MHQHvZjnoQbsDhLpvcS7uvemyoacEMOetZZtPsViyqaHXK7My4TSd4MODgw8dGe6o548pX4DXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733785845; c=relaxed/simple;
	bh=E2nTtrwCG1RWUGoeVV6buBH3LUJxG/yFAhyZjoMYrGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FqvjxVf64HgxsfId0zBxKJcHfGkqXkBh37MsbBV/+VDRCsI/QtneaZyx6Mt1PuCp1SCi1m1Bcd4ryUBqW9GC7Cs/qC5knwm2eaVK/miP4X+ccmaGHMs+vd1vEm6kRNvZ0AXQB2cep/XdRLzM5WqWhwauYHKxNWnsPW9fO5yYMPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Frj7cZsJ; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Frj7cZsJ"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2efdaa02378so15115a91.1
        for <patches@lists.linux.dev>; Mon, 09 Dec 2024 15:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733785843; x=1734390643; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QE+fKlDSe7E+kExUzTzdcRgoLew/xvVD6sIuR+E1rNI=;
        b=Frj7cZsJLD/+PLkvGhAo3Sb9mwcdY0MpRvV5lNqQAcjtd7XXmF1hfYWRw1yqIE86T/
         4nQSLyPl5iVWYxJhpconw+VdolBJugQ9P/e+6sP7U93FQJ97wsLEbM3pHjhyEJD7WLn7
         4tuGpLi1J+kO9hVGhN7eMm9ZrKH5fEsaJo5+YqABKiMLaeZlxW19DgCZJT4V68iUfLA3
         xwLakIDfIZk0sg8hmgUy38iSDY3GqOnzHtXec225pSMpQbjDyZ24yGBTHzPlRCR4IO+3
         TfqpTJYOm9WX5gdFo29ESb5XD+AERmGKBpd+3xlGtwOYJUnu+RqwBKaeB62ni2R8IC/K
         oLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733785843; x=1734390643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QE+fKlDSe7E+kExUzTzdcRgoLew/xvVD6sIuR+E1rNI=;
        b=uy8o2Wuv8qjfgMmZl2RGNqDFKi8vdh/tIC3siw4SH6Intp42YHkYokC1g7+SFZg71h
         R8THlL4CTf70UAQzS/muCYPUwCE0wtgp1f0r+r8M7MEfvK3Zh0SjKsk+VXQDmC7rildC
         My7H3/EwtqM8V1xXxhZwcwzz/q0nMpiq1o6mtgCxfw+ZdJ+SAlTEqA6WxzsrCbZUfGBO
         smRfqAFdL6tap7VnS1Zs8L+h3aPdi2Y5Ilv3LHnL7Tp3TJ1n2/E2ztpGBAazvpIe0cjm
         3iDKSAxyretR20zSOmTYQ0CouMwZ7D9RbYxyRPkHpzdJw+S+JOFa7BRzGGJI7hpqDa4O
         hKgA==
X-Forwarded-Encrypted: i=1; AJvYcCUIQKnbBgXR5nD7DanA7wmS9IJW+LdOo832E/NpzRpev0vB7SNM+sqtJVwIe0IYfVpSHb1jV9hF@lists.linux.dev
X-Gm-Message-State: AOJu0YwX06BOC6eiDqbjn9TiIdhp1CBTpk5hek/jNINh5ocOmoUQaSII
	1emOdkmHS2D8h64hlV4CfnD5To5h3Lp4jUvr/uOE3gUXsr0DEY8+HZzBykliZHXiJX/U3fIkw6t
	u8al3hUp3Rs/5+PA0StsZAPsr4y4=
X-Gm-Gg: ASbGncvbvD6KqxoPu7If9I1FdC6F6DiTHYfMUkLETIVg7pYZJN/mKf5+zTKvAzrMZqq
	+R3AeBZZHFWs0UdCYWzBJh5WOKISiO4VZif8=
X-Google-Smtp-Source: AGHT+IGI8SxF3kv4Towz1Sn0iVeRrBAzBUBXonLAFx+//gR5/lMdXYf3/WqqCG5i0YIC+b+9KFrc1WCKHw6mrXFmPzA=
X-Received: by 2002:a17:90b:4a83:b0:2ee:948b:72d3 with SMTP id
 98e67ed59e1d1-2efd472ea91mr789956a91.1.1733785843572; Mon, 09 Dec 2024
 15:10:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241125233332.697497-1-ojeda@kernel.org> <fe2a253c-4b2f-4cb3-b58d-66192044555f@redhat.com>
 <CANiq72=PB=r5UV_ekNGV+yewa7tHic8Gs9RTQo=YcB-Lu_nzNQ@mail.gmail.com> <e544c1c7-8b00-46d4-8d13-1303fd88dca3@redhat.com>
In-Reply-To: <e544c1c7-8b00-46d4-8d13-1303fd88dca3@redhat.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 10 Dec 2024 00:10:31 +0100
Message-ID: <CANiq72m_b4y6bJJ6sB5gUe+rpa51FXtwpwENQy3zGGMtuFJ3Xg@mail.gmail.com>
Subject: Re: [PATCH] drm/panic: remove spurious empty line to clean warning
To: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2024 at 12:05=E2=80=AFAM Jocelyn Falempe <jfalempe@redhat.c=
om> wrote:
>
> You can merge it through rust-fixes. I have another patch [1] under
> review that touches this file, but it shouldn't conflict, as the changes
> are far from this line.

Sounds good, thanks! (But of course please feel free to merge fixes through=
 DRM)

> How do you test clippy, so I can check I won't introduce another warning
> with this series?

With `CLIPPY=3D1`, please see:

    https://docs.kernel.org/rust/general-information.html#extra-lints

Cheers,
Miguel
