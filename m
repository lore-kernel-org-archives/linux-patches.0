Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAEF12D77B
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 16:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711383562; cv=none; b=NsWqgeKt7vNoHDk6218HR9LaF6OJ5JHm3a8bxYj2zZpT7dDWv83Q27nq1S0sLkZ0g4882z98tBeBQRrQLG0TU+UeXWBoePvVImUrRGop+vNpnr8vnk1QxdqD4MxNyTTp6D5d7FOBjiYnHzkXQaoUkOTR8pmCGmF4C+s9U819BJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711383562; c=relaxed/simple;
	bh=6utOFEwbdwWyQcN7SLxfqSV+M2t5uCbikbD6Z3HiO1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wb0EtbcjZKnaJKy4xLckfHnWWvy9wnD17HgTrzy5yc7rJ6lZe4RvNrgjDahpoK2kPxsMaJ79pu2xoIbglbNWESOGDjeGd9+LZinp2CBR1wjndMN5QPO/9QaIriJaDFqsgJbCuV4rY0DlQtP86sHe9E3tJgPv2CC6rWx/X5/5wbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=kMZfdPXU; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kMZfdPXU"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-789e6e1d96eso315631485a.3
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 09:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711383559; x=1711988359; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DsgsfaYuhO9HIMjIvNDS3p/KRrPkbJlG84J7jcdFiPU=;
        b=kMZfdPXUb6VzSkGhZkqdFPQJb9+KvUTpL/d0347FP72sP8EnB5M65Z9+01GI8b1GMV
         Qc+lwQ7XXQfHeb4pA/22eklvcJZCBFii/vD296Cd/4lQhhVnQiGxbqYor+6fXKQtZ+nN
         b8AJBfW7fp6eclaVgwhxYFTGihkhxFtOd6xDc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711383559; x=1711988359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DsgsfaYuhO9HIMjIvNDS3p/KRrPkbJlG84J7jcdFiPU=;
        b=MAWL2sakOzUKfYGy9ucdhFK63jGVIQfOwNmD7KXqXy6N4TwFsX98OFIMzZz1mKrMQD
         QESgxVBOrLXd4MHEvaCHysYdERvlwTGlqA1InLZjyZ5ncTI8HACKdjKjDcA/svFsMstV
         xvYBd5e6mGlt67vY5ncZpQX9JLht+DTJ1nqSQOcT9DUxmToww+lVNdGITtKBVfi8mae6
         WFhQ1LczMzHMvNyMy16Qfeo8M+cAnZzyr0UBsssUh+78a5/I5f7tMc1PjMfSWkie/l34
         pwxdTKPDYAxeOzVXO/LFZvmfAHCh/nULtWInuhGJHP+Lj8q0xeJCXW9uyAmYdjYDdyao
         IiXA==
X-Forwarded-Encrypted: i=1; AJvYcCVekbxW4go3FUeX/CbdC1qJ6Y06O4gR4w3Ax1TCDx13I6Z0zRNrWpNhosdwGxfnzsJX+FchyOkbsHMLp3fyJvYpd1X6NrkoHg==
X-Gm-Message-State: AOJu0Yy+vyGLkkNSUXsISseGksfaHMMSRklK+KGOsfEbKBoMkGy0OFtP
	c7cpSnW8IgjZzvqLnZWVadkFWPyAluu/ys3ydkmxj5SPCBdoMQGOP/09IIJm7lcNpfPOv0gssZA
	=
X-Google-Smtp-Source: AGHT+IHvL3KWMEhUEu7RiJtZaafTM7ZQdmil4BqF+fN/Vd+9nVzcyJkNvvm1pktyiAXglnCLqy75+w==
X-Received: by 2002:a05:620a:f0c:b0:78a:5c9e:b606 with SMTP id v12-20020a05620a0f0c00b0078a5c9eb606mr1587343qkl.49.1711383559289;
        Mon, 25 Mar 2024 09:19:19 -0700 (PDT)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com. [209.85.160.174])
        by smtp.gmail.com with ESMTPSA id cz33-20020a05620a36e100b0078a3afff77asm2250668qkb.8.2024.03.25.09.19.18
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 09:19:18 -0700 (PDT)
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-431347c6c99so487481cf.0
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 09:19:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW1GTV6vLi0vSxz1Vx/AdUKqxwNUQBBLOcwJvjoNnH/6UVMn5daqOMwc+CYkm6dc4+PuGgM2Jj9HCepdvS1IJeKwkQmtXv7jg==
X-Received: by 2002:a05:622a:588e:b0:431:56bb:2347 with SMTP id
 fh14-20020a05622a588e00b0043156bb2347mr265739qtb.21.1711383558167; Mon, 25
 Mar 2024 09:19:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240325054403.592298-1-sboyd@kernel.org> <20240325054403.592298-3-sboyd@kernel.org>
In-Reply-To: <20240325054403.592298-3-sboyd@kernel.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 25 Mar 2024 09:19:02 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Wu_SuLcHYQ1bLC-zhV1FnoFor84t-=EERT9mnDdm5Q2A@mail.gmail.com>
Message-ID: <CAD=FV=Wu_SuLcHYQ1bLC-zhV1FnoFor84t-=EERT9mnDdm5Q2A@mail.gmail.com>
Subject: Re: [PATCH 2/5] clk: Don't hold prepare_lock when calling kref_put()
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Mar 24, 2024 at 10:44=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wr=
ote:
>
> We don't need to hold the prepare_lock when dropping a ref on a struct
> clk_core. The release function is only freeing memory and any code with
> a pointer reference has already unlinked anything pointing to the
> clk_core. This reduces the holding area of the prepare_lock a bit.
>
> Note that we also don't call free_clk() with the prepare_lock held.
> There isn't any reason to do that.
>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  drivers/clk/clk.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Reviewed-by: Douglas Anderson <dianders@chromium.org>
