Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5A91BD03C
	for <patches@lists.linux.dev>; Sun, 12 Jan 2025 16:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736699605; cv=none; b=HAL+xYntnDyztcaejR17harMx17m/9O5XDIXssU04L0Gu1BYDIIgOJZORWZdNqRhBRxmzmbx2Ht/n2w3xT+bd+9OjJQTqH0q62lXkLFDxzkZsuOJe1Th585MKJzsbqNjwGhn4vNGOyCX68LdbCg2T5ETI/XeUU/nVmuW/jjnh80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736699605; c=relaxed/simple;
	bh=XVqHpY3N9bg+00YKap6C+QuFblHD0Z37kdfroKcfoBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K4rSyKMT5lq3W11eH0peoXt4EAIUB9defKXCQnqFoDkbHBz0IyJ3bp261xgUDEQZp82pAxcU+tCVjxTrnIrR9HEXXcrWxQ/itpsfMZVK62VeZuIrb1TjRGukPfm5m1f1Zp+AxIh6ZkWaFw3OzCKONSTvHlet+hzZvmcNNf/V0rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CcwR23uf; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CcwR23uf"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ee94a2d8d0so749876a91.2
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 08:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736699604; x=1737304404; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XVqHpY3N9bg+00YKap6C+QuFblHD0Z37kdfroKcfoBc=;
        b=CcwR23ufoWkCt4qx8N52zsp6w0VsrtsfaUJluIwgQBF9LAv2ehbtNaXRIZ93I9L50S
         AZH8reh51oEzX+6VMwr94kcvxyfk5D/6QdIuCLo+8DjvQn8Cog9zd8BnDz6Yrd/JpbNx
         n/3vAb6c7yMKltnD189vGWfWp/OaymMrTFzdHLE/b48jDyAp6MYR2DiItBkac9FDMqpp
         FoPFlWFkwDzz56u8IovGYCeZNq5oGSgIkeb0S52uLKv5xDpdDonh2IXbf77S2iMo8KgI
         OM8Iyg7jF/o7zHnB6VNANwsBMrKHXrXZc9TOq7pl6yTEZbtIhbo8CdPvoqFb04CFjqQA
         lKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736699604; x=1737304404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVqHpY3N9bg+00YKap6C+QuFblHD0Z37kdfroKcfoBc=;
        b=iVAB+rxAM0qCN5OtLOKLkE8/gNzCFE6AovdNVgtiLNfUgn2wPDZt4SnakS8ePGdnTp
         argBK2Lk5CzaZDuFaipDur8CwuxgatBfocqKpfzXoXwzMKP1F0D437WNb1Y7l81o8Ovc
         Ioq+kNogNgiK+mBIOeJuFSe8hH6LZd26+si3PVzjSQxIeDiTRZZswHKXsjG5EPamfgA+
         smm+x6IruVU00N1lhSVjKCbqxRu3TkVVuYkZ1GgQNYYCOw1gMbpUcJrg190wuEuCA69H
         RJd6IDs1kJ/W5ZPauSQShWXfW9XJCKo606jhPwSu9x4LrdL5QcZFkO1i8ygfH5TXlGvE
         5UiA==
X-Forwarded-Encrypted: i=1; AJvYcCVQf7CDdmS332NrCudW3h2wj90HEJUAI5OKz9mJ+kWEQflGVy7MsivcDFiuedrMECQTqdsn9OVX@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9wC/AXDvCpUi2t0ulAb4AH61yuT/W+HU8RRkg3LCgjKwgVhdO
	BF5xbrkPWTuj4HrsgTOvEzYZNWE1xF2kPjU0J22ElwSfqJEN4bcexnWPyCYNA5umpTEsElbUw3K
	CgVniik+DWp8TsGsXgUfuIewA9+s=
X-Gm-Gg: ASbGncsXGczz79mGcbkbd80PAExceDhFF20sSOKCwXPZ40FP0weiv5+gy9B09dB7pd+
	/hlv3aefXdZAX+CyT3cekm5zAte7CUfkM1SUMRw==
X-Google-Smtp-Source: AGHT+IF9qCroMjFPgvBrOcm4sTwu8DFr8c2pZOMN3ul1CkskTe9gK5SbLAJsB7sYZjuS8R9wMmOjKIpCXLy5qVlhxpo=
X-Received: by 2002:a17:90b:2f07:b0:2ee:f59a:94d3 with SMTP id
 98e67ed59e1d1-2f548e55126mr10017977a91.0.1736699603851; Sun, 12 Jan 2025
 08:33:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250112152946.761150-1-ojeda@kernel.org> <20250112152946.761150-4-ojeda@kernel.org>
 <CAEg-Je-Knta8BtYSbZgX8cZ9Gd-2cpDAUE83dCJZbTbqmSfcKA@mail.gmail.com>
In-Reply-To: <CAEg-Je-Knta8BtYSbZgX8cZ9Gd-2cpDAUE83dCJZbTbqmSfcKA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 12 Jan 2025 17:33:10 +0100
X-Gm-Features: AbW1kvaZe2CFc-6pU_Vov_pNC6aiqdn2dh03696kzpcBc1UaVJG0rucVMsTqMCA
Message-ID: <CANiq72nPJHW_2B34d4jScTuvFA=Ux+EszvLN-p=wwPd5sFt54Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] docs: submitting-patches: clarify that signers may
 use their discretion on tags
To: Neal Gompa <neal@gompa.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Sami Tolvanen <samitolvanen@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	tech-board@groups.linuxfoundation.org, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 4:47=E2=80=AFPM Neal Gompa <neal@gompa.dev> wrote:
>
> A tag must not be dropped without the tag submitter's authorization.

Tags get routinely dropped, as the commit message explains. So we
cannot say "must not", sorry.

Even if that were not the case, tags are currently added/decided by
signers, not tag providers. This patch is trying to document how it
works today.

I understand it may feel bad to not have a tag applied, but it is
something normal in the current process. Tags are publicly archived
nevertheless, so e.g. one can still prove work to others.

I don't think misunderstandings about development processes mean
people is "rude": it may feel bad, but that does not mean others are
"rude" necessarily, unless they were rude in their manners or
something like that, which is not what is being discussed here.

Thanks for the quick review!

Cheers,
Miguel
