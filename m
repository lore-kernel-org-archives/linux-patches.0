Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA35A195FEC
	for <patches@lists.linux.dev>; Wed, 27 Nov 2024 23:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732751831; cv=none; b=qg0WMxCur91+K+euk5hGEDMFhm+yxLk1fR7cwUmsSMytIAGzbkeqDWr5C1alcd6CFOD6MiuIuNBbx66jwHRjzd/2ijxDtE/Lmn1Nm8x9k/NGItoRfTcIiOJCW7ezjKvlNXDVDqiU2eheAi3ezW1LUY8tESGpyv8a3QH2XrVIe6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732751831; c=relaxed/simple;
	bh=gThBsz3+hRwi0ezlPl0OHla0tdLsXvJYTiWleIRrU+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y4490kwH8stDTeWzNL3REApUa92L4LpLjtUtqYB+Og1+NvMTdwU1oM2ZMNDLVGLhJsXmFeZSMJl6OFL7tW5MKnKtsmES9bRrP+xhsDk0p6HJFVBBY9Hc76Ch0IJy7GTT37UMG83+nQQuB3tBaPGmTsQnNcNLz9WGQKEJhG4fq/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vt45ug6i; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vt45ug6i"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aa578d10d50so33541566b.1
        for <patches@lists.linux.dev>; Wed, 27 Nov 2024 15:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1732751828; x=1733356628; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KPlRZAjURNuIqI+1cp/M1BdMXf3esRQ0x/UNttbDRTI=;
        b=Vt45ug6i7f16TAqdWZqt6PVvHqOwYuPeofZupunOWmee7sR5ykBA8rd6ka+ZNR3U46
         R88LYYlzFhoeZoPRyE25/2Phu1vq9w4Nk9C/B12WTKiujQFCCDLna42DImWLF2dhZ0Ag
         wRBqOaRFL2e510FE/5XfeSWhQjhzo1RMwJ0uA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732751828; x=1733356628;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KPlRZAjURNuIqI+1cp/M1BdMXf3esRQ0x/UNttbDRTI=;
        b=VrWa1fIegVakxhKY4MZyNaJa2j1ljhVkyITWuesy2IZv8RPq/FH0w3Dv21mdZovpr7
         dFyv3D95lptSD1oFFunmR3aXjw10e3n7kDa7+sk1AZ83FEYW4UvZu92hLH6D59Rusrw2
         SFtr1eicNLzqmJ2vK3jf92cFgHFZ5xNmF4MOvPh5uIsaaVJPQbiSuv9ypSGVuDmHbZx6
         PPgvh3XPx60RjwtLsbUKetpzNyAiD3ckiIg0qq0YL8YVG+oReFRVrwJWITJxU2ULQcSP
         Ifw+o42+7VnWl23qwT+aLRi1SkzN6+pml2zpagUBUegoTgkHpiKk7WH3d3yy5gxBsjWi
         1eXg==
X-Forwarded-Encrypted: i=1; AJvYcCWRZftK9x3DVC7/7Oex2UcXq9KgX7MTA/DiQ6Xf/XFnWFZKCOFKGm/YCjwN3/QTQgN2xotaqqho@lists.linux.dev
X-Gm-Message-State: AOJu0YwiidqRbjFJ1fYn7r//rZ0rlzzSj7YECdBOPy6oeubgkx0v2uqV
	SPMAAGHoZ/otOkXCR5uZsZzqwhgjMtYKd4Bd1Q+07He8rQmQGz1t+AgM7ohXiZQ6K5csxgjjJRM
	9iG8=
X-Gm-Gg: ASbGncuZQg7jZXEv3dZLa0nXWXve7po32ufySZGIxM/G0VjcoHNJcyVV7prn8+tgX3R
	3F+BkTi/3EhPv91wz9zNrGY+Cgiz6DKJZoAnLyGcKAfaFbT8xc5P6piLX64PHlUEteGnIuCsEyr
	Vp/JPIum8bs69526TUVphjLLZ3KttI8KexiB3A8dPTq7SjyZoTiuxbh2/Fvyvjd0VPqwNwn2J7a
	tUZGTxYW5WIHrcLjWAQ3LvA7PYNxSXtCCUDhdWNDb1LqeP1ebbTEQVh0NqVFeTHtGfVSY2kkQ18
	1q1ehV2XfYmcrHvzW2pacO1G
X-Google-Smtp-Source: AGHT+IExUuzbjyLPRzKJuQH2/ssTvbUgILjsqrdp8xmM8AJmtXhfkDodwUM6PHu+ZmIUnGZVGtNc8g==
X-Received: by 2002:a17:906:846f:b0:aa5:ac9:ce5e with SMTP id a640c23a62f3a-aa580f569e5mr457551266b.31.1732751828012;
        Wed, 27 Nov 2024 15:57:08 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5997d4124sm5675566b.64.2024.11.27.15.57.05
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 15:57:06 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa578d10d50so33536566b.1
        for <patches@lists.linux.dev>; Wed, 27 Nov 2024 15:57:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWlsUnvKCCAOxUIzXnuVDx1FKNNEeMDFyC/W0L/Bys3xL3IWtAFmh6NrE3kS35bqOLVptUzNIW+@lists.linux.dev
X-Received: by 2002:a17:907:7754:b0:aa5:1da6:d4f2 with SMTP id
 a640c23a62f3a-aa580f22baamr487890266b.22.1732751824877; Wed, 27 Nov 2024
 15:57:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org> <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
 <Z0eeuCyUGcKgsc5h@bombadil.infradead.org> <Z0eqiayuv1w4a_dc@bombadil.infradead.org>
In-Reply-To: <Z0eqiayuv1w4a_dc@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Nov 2024 15:56:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj+imfGvW73XoYn60bAMzRtPfXFqwFTUqBoEq4=u5_oUg@mail.gmail.com>
Message-ID: <CAHk-=wj+imfGvW73XoYn60bAMzRtPfXFqwFTUqBoEq4=u5_oUg@mail.gmail.com>
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: samitolvanen@google.com, petr.pavlu@suse.com, da.gomez@samsung.com, 
	linux-modules@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, masahiroy@kernel.org, mmaurer@google.com, 
	arnd@arndb.de, deller@gmx.de, song@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 27 Nov 2024 at 15:26, Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Wed, Nov 27, 2024 at 02:35:36PM -0800, Luis Chamberlain wrote:
> > Sorry about that, I'm on it.
>
> OK here is a fix, goes double build tested and then run time tested.

No, you misunderstand.

I don't mind the tests being built. That's *good*.

I mind them being built *twice*. That means that there's some
seriously broken lack of dependency logic.

            Linus
