Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7EC1990A3
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 09:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528453; cv=none; b=TW6q2K7/jLsR2SImQqhdBdbvg1fas37wN7JpP3kviLErbAi2hUs/WVF01UKGIMTyYC6JAQzIj2UvtJQ+nGlLz0qNYzvFbSWjqzbjKly1bu7MljnVY+Ix/m1edUzOj69cByQb1XoZkCKAPfH+QdprrrVMDltvfsF4UYWGt9dLLeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528453; c=relaxed/simple;
	bh=sAZMwktIK3YKRAZVnZju0CX7HpP63pX1nZYVPNJfOVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h1rmIYtV9T4e3j6eciDLOzNNnqIB7mZ47IQgApcYF8VV6L7e18ONu6xVjDqg5S7NtcNIWvcrpNwGk8MC52ZX27+czWh52SdjiwQl9o3sRGk6mOXbqGpxp7SXMfFgpqWZluKuOpEjLvDeLfMq+EeNy8juzc1kpOLcxSiVmYrFwOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G5K7qe43; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G5K7qe43"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3df171a2588so75417b6e.3
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 02:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725528451; x=1726133251; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sAZMwktIK3YKRAZVnZju0CX7HpP63pX1nZYVPNJfOVU=;
        b=G5K7qe43DRtp0E9XvKS5zb7hI1tXmai/eO750hBkMSo0OGkpN18Dj2d83uzAlkLLuC
         WmBaxNb5cUWREqxBRU8pzyS/cAd2MkEGvE89IenFKxI+Fg07qbflAaBnKiAS1HwpcXSW
         zVtBbu4L02NCmV97kasC82MN/AHTbFbkB9Yi+bWAa8QFGYwO03M9VA2+J8WwmT4gb2sd
         G3tmlPl2VpxkRg625WmhQJ+AMKJ0xGCv/lJpdDg7hqADlnRNDPGLOb4Lflw1eystiLNZ
         JoBnHidEPE3P4uejWv3CC85SC0TV3NdYenQGwAia2K/d83LqbJx1+KcJgjZpCtXDC6uT
         PPeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725528451; x=1726133251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sAZMwktIK3YKRAZVnZju0CX7HpP63pX1nZYVPNJfOVU=;
        b=tQHbFwC7PQ2TFYF0UGrmF9WyYmpGteaJ+lnz0tBsIX1/BkxsKa+jx55LF2bDzGOiPv
         P06rlMlwgrQ6eI1M4NrjyVXBph6/kaAHwLjCMDKpdfiHeOsB9T5OK8k9PiR6zlI+C17u
         W31KWb/pSampx760FLSlxq8q/MioaRdQi2UpVCRoqNNIRJ8vQioUzf/Z9oV0yFcWBXDQ
         FxbBJ1EKp+uJk7HRUsovSmSgD0QgrfCPv+Gh8LMdmyKA+7Rl/JhO21v14/axGkyIUFlj
         GVFQLqWjKgVpF208w0X1NW6uSOO9tKcv5I1g9KTHT8hsp5KqdjljWNEinzf+5VhlYE88
         Ucwg==
X-Forwarded-Encrypted: i=1; AJvYcCXu3mIl97P3xUV+5HHW8j/I+QBmK49wsrubqeBldrINBz0tn3UjgReRrk4v7f4zE+9CBL2Oz4yE@lists.linux.dev
X-Gm-Message-State: AOJu0YyMPzJrA4bYsy656Ik5fECMtcVjb5viFhfKvWpoWc7cxdaQo5Vt
	ZKMh3hFse4G9muUTEdSJY0csk1n+FznCJXuWkjo0ulHqzpfYKrakSsPEC7xLQaVao4dd0sVUJiC
	BJu0qOIZArgi9+b5tVGTJw3zHy0g=
X-Google-Smtp-Source: AGHT+IEsl6m7kT10HtKDX5CkoIfxB0mk5gmrU2avcA2Pe0aumkMklamu40nsU3C0izBc7uVm8+BhrHiVBvDiidH5JU0=
X-Received: by 2002:a05:6871:8701:b0:277:c0b6:2224 with SMTP id
 586e51a60fabf-277c0b6642fmr7015378fac.2.1725528451020; Thu, 05 Sep 2024
 02:27:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-20-ojeda@kernel.org>
 <CAH5fLgjfxSOmnPsk_673qNdnpVoj1W11LD+qgKqBG8J7sm-u3g@mail.gmail.com>
In-Reply-To: <CAH5fLgjfxSOmnPsk_673qNdnpVoj1W11LD+qgKqBG8J7sm-u3g@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 5 Sep 2024 11:27:18 +0200
Message-ID: <CANiq72m9y6agZyca0dhchr64xJYjuNL3G-NVSKO6=wyU=skJ=g@mail.gmail.com>
Subject: Re: [PATCH 19/19] rust: std_vendor: simplify `{ .. macro! .. }` with
 inner attributes
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 10:19=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> Are we ok with changing std_vendor?

Yeah, to some degree, i.e. the code is already adapted slightly (it is
not intended to be a 1:1 copy). As long as we keep it more or less in
sync with upstream, it should be fine.

Even if we had to diverge, it should not be a big deal, but it would
be nice to be able to pick up improvements if any, e.g. there is `let
else` being used now upstream, which we could replicate (I will create
a "good first issue" for that).

(These allows/expects are not there in the original anyway, for that reason=
)

Cheers,
Miguel
