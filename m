Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D381F943;
	Tue, 27 Aug 2024 21:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724794193; cv=none; b=CNIy/5lAt5y4R7WLWGJmWFC9+awh3fFvC4U7ErhsEjTMX0DSjUVvyyRxt7P+wfZcHA5ywzPz9nV0Ke2cMMzelixr0LQz0yTlcgEVW/rjQO2wu9+sZmcsLZ8Y4CjhD/Xx4lgTJrSUdNLeETeCIV7lkVN+0Zf01qDyQOuTaQ1E7vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724794193; c=relaxed/simple;
	bh=d+yn0nkxzSuimP+TA4VAK1zkmLd8RAXtLCH9HszvZbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dK1k1yt/uUOPEounG6h3hsRdvY1tTRvF3iwLVIAjtNt5h2beSCUfm5eSil8/u0h36hc7UgCzc9WPHldnymwJxgUw6/au3xqZ18qw9FZ745hfkdp5e6YQPQJH4GYIAfncpCCKTMek3u3W90yfKCxOM4mx1ZNhRIrjEKmqIos2frw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MhbCi//C; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MhbCi//C"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-533496017f8so7974375e87.0;
        Tue, 27 Aug 2024 14:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724794190; x=1725398990; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+yn0nkxzSuimP+TA4VAK1zkmLd8RAXtLCH9HszvZbs=;
        b=MhbCi//CtbmpjeYHKI+8PAbjtpt8pk3qZwi4ioJFGMoKbwrBs0xcTjWDVRVUo/Skv8
         CEBM3yQwEpcrEoMlm1cGcWZNY5gjNpAo2ZDtQpuGNvQruYo6xkk6x/fEISdpPRYcKS/k
         STPeuGU1IugbPrdnN9+XPsFFTsBm+bhlGPpJ/qXzNjYr/y0l++GjxgrcbQp17/M+6jLi
         RbArcZEMoHtGl/gY7pxJLWA2+7iph7aXMkONd5U92oPlXrCsxSfDK6Woac0/xGwXJX63
         W9ropJ2ZQWPvH+DDIEpzXdLeFEdF5+vH1JIAv/GxYHMnZvJL63uyp5mx5Y0HCl+B9KrO
         Vp2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724794190; x=1725398990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d+yn0nkxzSuimP+TA4VAK1zkmLd8RAXtLCH9HszvZbs=;
        b=v6LrbZvTkLCl76Sq+M5YkQ2rY1dhP2O7uW1M8sTkAplx7J/eD6ferg5ZdEyvE4CD+d
         LdGloVK/Z1ChyyJsLEoHDiKWJeFN0i/ndtNSYM3grCK1LK64JbIXcDOysDnTUgh19KTE
         fkvPn8kD7xG+APGlrwS4FiP03u583f1i+Y+/4vtHI/QVrebC+dcHUtOVzLSRsfhetCvz
         cWWHCUpQUVW3s9Dvx83PNkYG3cazU4S/rb/jlDdvX175HTodlBWd78bTKxdAj9S9Dr9C
         Iw291qFmfIVaCUewIaBiIKvgUqE+oH9rNqGkoVlGi4McvRVX17Uh9136+C55FK++y3kt
         jfdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxEjjoihz8SDrie3AhjH1P1o7Q5glQP+zphsgAB96UqJtUfR6TveonpPcG9t8POpRVrS4X5g==@lists.linux.dev, AJvYcCWXw1LFmdY5IneKDmz74sMlKHj4ImoEGCz7rzohZK0wHM4WyQz1h5hFtiOgKWPxsRoLtkZaTQ==@lists.linux.dev, AJvYcCXoKz7/LlID5RtBYhsqAwN2aKR+QCrXxstiyVKhEV5urx8VKlqk1yKtyOtirZauan2sT92G9Gtdew==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3OhQNLgd9uDRxB7aeEiY8FX3ArmQYUY2v8eTgSw/RvBVbZu+C
	HMqmOShzV52s5hWPxuTNaR7xww0IA+Y/VVkfzOySQL9vDY+xFnx9YgkYUYtdK6bSwFubFxS6tJT
	S2I2NXan0yADlyoxFkKrPfr4E1ZU=
X-Google-Smtp-Source: AGHT+IGMOY6Yiz4YkwEpjgWpibJQdtfTsGczDtl/VBKoJFb+V6GQ4EsLOSKLYsP/M6ZKPP5miCYIGAihYSQoDTyOxJw=
X-Received: by 2002:a05:6512:2386:b0:52c:df8c:72cc with SMTP id
 2adb3069b0e04-5343885f615mr9361153e87.43.1724794189192; Tue, 27 Aug 2024
 14:29:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827143833.371588371@linuxfoundation.org> <20240827143836.571273512@linuxfoundation.org>
 <Zs4v6aV4-VpIqdfy@codewreck.org>
In-Reply-To: <Zs4v6aV4-VpIqdfy@codewreck.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 27 Aug 2024 16:29:38 -0500
Message-ID: <CAH2r5mtaz5NSzhvq0hyWJJVvYyk_h-LxW=Ku_YjwSEe49EDO7A@mail.gmail.com>
Subject: Re: [PATCH 6.10 083/273] 9p: Fix DIO read through netfs
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, David Howells <dhowells@redhat.com>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, Trond Myklebust <trond.myklebust@hammerspace.com>, v9fs@lists.linux.dev, 
	linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We are working through this regression with David this week -
hopefully will have more info in a few days

On Tue, Aug 27, 2024 at 2:59=E2=80=AFPM Dominique Martinet
<asmadeus@codewreck.org> wrote:
>
> Greg Kroah-Hartman wrote on Tue, Aug 27, 2024 at 04:36:47PM +0200:
> > From: Dominique Martinet <asmadeus@codewreck.org>
> >
> > [ Upstream commit e3786b29c54cdae3490b07180a54e2461f42144c ]
>
> As much as I'd like to have this in, it breaks cifs so please hold this
> patch until at least these two patches also get backported (I didn't
> actually test the fix so not sure which is needed, *probably*
> either/both):
> 950b03d0f66 ("netfs: Fix missing iterator reset on retry of short read")
> https://lore.kernel.org/r/20240823200819.532106-8-dhowells@redhat.com ("n=
etfs, cifs: Fix handling of short DIO read")
>
> For some reason the former got in master but the later wasn't despite
> having been sent together, I might have missed some mails and only the
> first might actually be required.. David, Steve please let us know if
> just the first is enough.
>
> Either way the 9p patch can wait a couple more weeks; stuck debian CI
> (9p) is bad but cifs corruptions are worse.
>
> Thanks,
> --
> Dominique
>


--=20
Thanks,

Steve
