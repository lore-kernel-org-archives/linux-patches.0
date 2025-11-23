Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2B9190664
	for <patches@lists.linux.dev>; Sun, 23 Nov 2025 12:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763902271; cv=none; b=Ah+uc2lLh0G/mL0XG6ckOEChD72gDbpMPbMUbtrsoUXAe8sPpQcLSwIwBuFFcjqBBdDsCkhLtvuhiqzrarnoZuZhFxDC5KH//IobdcthlltshnUGzDaTdfDaEqMdB6Vhpt0BdRST5PhbdkwFXW1u3oZGpwAUpf0hzy35i93HA0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763902271; c=relaxed/simple;
	bh=hh3f/KSBNY/MI9DUyZk2g+MRS3pxrt5gBaQH02mgQPg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qaVoaon8FfmdM+o7zwGK8GhgDC3/MhCQyIy/JQKRCCoXpVcNiz0dFAh85EH+RpMgPPId+dT2CMSrcirExDPLM2ZkinsmTXaxWg/mPZWJcelb+AwYXm952GS+jL+KV3ZK6QAxvg9AEs7Lo6Y1d8oZjqoxzPYmd+H3XvT8RUt+qp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J4ICHhik; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4ICHhik"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-bc07266d011so94700a12.1
        for <patches@lists.linux.dev>; Sun, 23 Nov 2025 04:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763902269; x=1764507069; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hh3f/KSBNY/MI9DUyZk2g+MRS3pxrt5gBaQH02mgQPg=;
        b=J4ICHhik/MUWriGsGTS/emf3Mxoo91iwgwZWpK42fq/C/qBd0PQtjWHuz8dMtG0cFC
         L9YpfTA30R1SsDWaF1MeTE6fAEvPyCYNClPg7jcJ9n3YxMGThDDHF4XY+HavgRAly72R
         fI0TXSYtiatZxrd8ZEISIbhPnbORNFYecZCc1y3bJJzN75GMaoa79a+FutxvjZoXri9f
         FDtcdxhnlhbvQPTVFkSRtleyQuWmOVltfcIHku6zlo7T/Pfld7vWV964GswLFWGg6eaA
         +U5LGLH2EqVvUdGCUDoJoYHP8RTrj78tLqIsxSmrurw+wa3I2L9mUSE7muEUJugHBSkP
         8SYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763902269; x=1764507069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hh3f/KSBNY/MI9DUyZk2g+MRS3pxrt5gBaQH02mgQPg=;
        b=MBKQuX0QyvmWLu3oWcmA/znhAQkFKsMdPjPdXsmaH4V/zdYFmhxJLEGzz8lE7EpzaB
         Zr0z3D3hRLtWJfpH6ChdGwv14QYGbQf+1Si1IUK8A8CmpF1QqspjLy1R6kM0tGZKTkRY
         XQhgYINK932DdBWrtbAMBFLDCDxFD8574vazgG+uAuVSrIYZya7X5e25q6cbKd7EeICH
         ABpj/aUZMyqtgKUQU8x0C1ZAg1vwgO93vKsFGYBU8n3w9mgDiajH2d5w7iMRDr9yUHHK
         8oHznZvxFmLpYl4496AFq8d7CW8k32N2iYciTIQCtSK/ZB3nN4osInWLEJjJFH0ji62c
         l+Hg==
X-Forwarded-Encrypted: i=1; AJvYcCVfxgRh8d7OtHwE+hwuHDUPYSAH/qIZnFKiiWuDD6y6C/dEo9HkFa6k7hViVlYaYXEa33x2qiTB@lists.linux.dev
X-Gm-Message-State: AOJu0YwIkPcpc+gWTvyRU2cU23npvnVvgf7HvF/wq+wHM2yUMXYKDUUu
	/iqp6Pw8tooZ/odGvWYfCmt0ZwxMsc/GSaizJvfVFuYZbC8gB5tUE3Ax7VpH7Fu1BIxt3KjZTyz
	NX8kgUzHS/uvF6spVKQJgcMTsyToaUGw=
X-Gm-Gg: ASbGncuzzeQgfkVm+ojhsl/JntNsiOVaZNYszer+aPj7KmC8lJ/WYqET6cfp22dmHqu
	qsA+zpWcd4VIdQnTv7XLRzITKIZwl6aeCt6FmYvMvUiOJtzmwN+aZTe0bL3Fsp391B2Aq35d/qQ
	+3y7f/JIaZvlT8jrkMTA5wgWI8RAfwznHvkPiaqWcKul6X4jxYRTz351Z/fAGni8XUUHxYfmskA
	95TBshqED0eHI/fCnMxxDkuh3YLm9XJ0A6d792AtP16P9NaSUdnGmr2jAgl+1KrL2nG2WF5ICnS
	bZHVzFlcFK/6C1O7iYRopAEFU0j3D78bOMgQdg/+0gOGkvPsziaB56B8n2csWDLyOOklou8fQns
	tCMLw+tzfgTjBrQ==
X-Google-Smtp-Source: AGHT+IFzGpHkwEeZtyBB1sA8C0zv73zZE61XXExuoWlx0JAyvU8o9HZNqUld4AqnEj4edoaKWnUZ2M8aAmsP3pGEL+M=
X-Received: by 2002:a05:7300:ec16:b0:2a4:5129:fe99 with SMTP id
 5a478bee46e88-2a724bc5450mr4369303eec.2.1763902269389; Sun, 23 Nov 2025
 04:51:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121043750.298843-1-y.j3ms.n@gmail.com> <20251121053633.1594703-1-ojeda@kernel.org>
 <CA+tqQ4LX2ihwY11VJk3LNNE-STsONJWF0rdDa0Pq09oA7YRXEw@mail.gmail.com>
In-Reply-To: <CA+tqQ4LX2ihwY11VJk3LNNE-STsONJWF0rdDa0Pq09oA7YRXEw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 23 Nov 2025 13:50:57 +0100
X-Gm-Features: AWmQ_bnvRqwTLU4C-A_sFwJUrt_-BRRzQMSF1pa9UGMsSEMrNHTXTBWcIgdzbNE
Message-ID: <CANiq72=Yo6-yLzQ6f047vXk1e-mm8=EH5t3dZRpLaZN1iuRNMg@mail.gmail.com>
Subject: Re: [PATCH 00/18] `syn` support
To: Jesung Yang <y.j3ms.n@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, alex.gaynor@gmail.com, 
	aliceryhl@google.com, bjorn3_gh@protonmail.com, boqun.feng@gmail.com, 
	dakr@kernel.org, gary@garyguo.net, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lossin@kernel.org, nathan@kernel.org, 
	nicolas@fjasle.eu, patches@lists.linux.dev, rust-for-linux@vger.kernel.org, 
	tmgross@umich.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 10:08=E2=80=AFAM Jesung Yang <y.j3ms.n@gmail.com> w=
rote:
>
> Now everything compiles. Thanks!

Great and thanks for testing! Do you mind if I add a:

Tested-by: Jesung Yang <y.j3ms.n@gmail.com>

?

> By the way, I needed to make a small change to
> `generate_rust_analyzer.py` for rust-analyzer to correctly reference
> symbols from the vendored crates:
>
> This might already be covered somewhere else, but I'm bringing it up
> just in case.

Definitely, it should be included.

Cheers,
Miguel
