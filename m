Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B5137881C
	for <patches@lists.linux.dev>; Mon, 23 Feb 2026 21:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771882905; cv=pass; b=bPwbhKdcghNnTGwHIFaiUGEf2B5f31le4tTs4Ll66U1g1zo4f4kC0ZLs9kMpenuD4VMJ4irc+pYvLvGCpyoP9op/tb9fVec7wGf6S9HvkdXsSkQaMOsNADAaEsJPAa4PLL6D2VXPGgg6XiG6EsAkmYIrY+TF1yaVsoV9EAWF/no=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771882905; c=relaxed/simple;
	bh=1JG2cynNzhGyhQW47nj1rwIOUkkhTWpJb7I8OtRgOjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XvMRExQ7KYze5/4Ou55IWKlWVBaqSvBfZ6zsedACaPLaIPoHzfZMtBrfwXPPpdaY2cJ62QINcgOjKiQK/JA22jxr059uTMnfj7XoEfyos7mD28x/918tYqKl0cX6oxmSO3NKN0/iUNXK/tVP3mhBq7BBOrBjdOJt7sQo3ikj2Xw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q3TarfCW; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3TarfCW"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-64ae222d87dso4406867d50.2
        for <patches@lists.linux.dev>; Mon, 23 Feb 2026 13:41:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771882903; cv=none;
        d=google.com; s=arc-20240605;
        b=FQtAOruF+JLk6fo31DQ3k1bpji9/xppPuQ9JohAeDBJytN1H3nrbVy4QN8pHDLgvec
         /NomBnTbMtBw1BAsNEqB3+D5dGkQt5vYAJXdAKQ/rpySOD+7V0WOwteRb0WDEJn32ou0
         PQnyKHjOSORcKsfz975D9kU36KEzgU0HkecHGHT2mDe2DtNMN0ofWEp744J5Nq3SgmTF
         IPd3rxitqHhJX+MlowQ7598QccgZ8oDbRpU3TYS6elX/gCVA7YjCMepHw+HNtJ5tUPu3
         fK8mvYN0EJHNmoHYf8GWGrn3Dc7PkVCnZXVekB2fCyHQn9SE4ypVLWIqDsvY/yRIFf0x
         aYdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1JG2cynNzhGyhQW47nj1rwIOUkkhTWpJb7I8OtRgOjo=;
        fh=0Us/GHQQhRXSbxtUTxxaV1uzz59o6h7LKUNyrgIQhAA=;
        b=K3y/W0EEb201rFEuN/9xXhHvPkzmczxJJvdBuYqc1aVSCBMBhf8SI06GxiwYnKv9Q9
         ama04FN6wvWrIRLk1gtwNL5VIiqVfDWYPUU+9XPoySEv5q5gcBHcYNAidtc8OucfYIsf
         gW+/JEyBPpY46szGuI6Z5ip3H7xQ/wN2GiUqqxWrR+4Ijx0F1U8SwL02za1jLCZNt1Vb
         keJmbPgqB3Idz8Sichm3+WUviwyhAJJStqRHSjw8LYAZz/2rTQWligSUh1eiy2qaMAXw
         2rr+0bdSZ5ExnebW+/3uPP0xkqePYc8SmQesi98kVdqDzfEoduBqe1QMiSpU2Sms/w0B
         1aZw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771882903; x=1772487703; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1JG2cynNzhGyhQW47nj1rwIOUkkhTWpJb7I8OtRgOjo=;
        b=Q3TarfCWup4J6gqcNrd6BbNuIfM/AKlGGcg0KSYfervUe7pyKeCGL+fU3wxWiiiCDB
         /C+FLYKVwjVUIQ5RrBLyiSJmdgNeyXgV/IozQTq/qxaGhT0KqbnVCnwTTtB10qZIvfDn
         VXiHCtsoEUd7MrR2tbkfSmKpl7ey8UmId41NqCaHDOOGYMwtNj1niOfh0nRXrRbyCTpN
         JIs2enq8+o7BbRN7EYsJwaecKqTUqGU4+os4N8nMHVcBga59/0psuyHyXMTsQ9OAoNpg
         5HjWMpREmTZdk92J0VyAQgwwUR1k72SwZn+ouaAJdnopZJqDNTN7BwgNbol0h30RaApc
         OqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771882903; x=1772487703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1JG2cynNzhGyhQW47nj1rwIOUkkhTWpJb7I8OtRgOjo=;
        b=KNsl4w+41WGIjGlgwzbNivqBzANKq2ZBLqdvCgKXROncqIE3PXwlNLXQ9KTlsgID7f
         DsqVmq6CZKZmHbKKA53/LJRy7VtB9Y7GcAk79R9bFwHIG0R2zB5nG73UaZW+qAFfyhNm
         n8yyQnVKMX8Qr/fP92oX3uvTJ52MYTZSU5/DStAgtsMUKkpI7h46fBBATqYWo+W1mEti
         8MJ+mDYi43LAXgI0PvEpVvZ2puNYhUBJThAQQ6CSKYrnG5N959t9Fk+PjS2YJQcxZEUn
         zYX7zd3BIGC0LRFAo5JHkEYN2+FxowA95+OfcPxiXhd/OORQo6RbzoZmcFqwPj+XjSgx
         h7KQ==
X-Forwarded-Encrypted: i=1; AJvYcCXE4882veY0d+4TzYrDSKqK7kU9ZaEX9QF1GHawyTOSYZXgI18xrlIyz8M1tFbryyv0FGYmBeHs@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7szndM6AcjEZ4BiOAxDwkrjvI8aedbmJ0RFcPAKBokpEWUxCk
	YLf9J5+EPTEem6OHcB9jjlwbpt3cLZztP/kS0b7NM9eLyPO2cbKhmNH0b+K8ps3tYVbykv29Uwq
	Yv/JycEKtRcOeUsWrLJhWczEXlzfuWEc=
X-Gm-Gg: ATEYQzzplq/vjVVtCpcAwnBvU3SHY0xkOyvfloT1uFBTscSWeG4zEU5XPeWtq7kPcRq
	806n00UQIJDlZCC26UIIfECTHvGWkesgWxWRC/xVeucGBJ5fNxWiVrZB7jaR2T3LOkRhz0QXggL
	Ma5kGUoQFGa6yKW4Ehne5MZyc1IBbPkJEtyaPHX3qVMd4c/3+jtKy14d/7rm5CBZvJFbX4Ef4ui
	+3iINcjh9Jl1EbOSxi2qOCl/udXtwywNAaqCwWKMR61ckEcZ1WUdk80olSB2RvzFk21pSWUBeSZ
	yeJMiws=
X-Received: by 2002:a05:690e:134b:b0:64a:d67a:1fdc with SMTP id
 956f58d0204a3-64c785dc781mr9063433d50.13.1771882903527; Mon, 23 Feb 2026
 13:41:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260220105913.4b62e124.ddiss@suse.de> <20260220191150.244006-1-safinaskar@gmail.com>
 <20260223121946.45b3c5b1.ddiss@suse.de>
In-Reply-To: <20260223121946.45b3c5b1.ddiss@suse.de>
From: Askar Safin <safinaskar@gmail.com>
Date: Tue, 24 Feb 2026 00:41:07 +0300
X-Gm-Features: AaiRm53G7mBkRTZxrmFx_UAZ2LIC8h6oVUqyUREBRtA1_T72X2Ms5uG-DS2L9PQ
Message-ID: <CAPnZJGC0kHEmAqHeTXwbcmuA0GqEOhDmCfjLRPRKff5DsEgW6w@mail.gmail.com>
Subject: Re: [PATCH 1/2] init: ensure that /dev/console is (nearly) always
 available in initramfs
To: David Disseldorp <ddiss@suse.de>
Cc: brauner@kernel.org, initramfs@vger.kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, 
	patches@lists.linux.dev, rdunlap@infradead.org, rob@landley.net, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 4:20=E2=80=AFAM David Disseldorp <ddiss@suse.de> wr=
ote:
> There are still other options:
> - use a different initramfs archiving tool

I'm trying to solve Rob's use case. He tries to write a tool for building
kernel and rootfs called "mkroot". The tool is written in pure shell
without any C. It should not have any external dependencies.
So it cannot depend on a custom cpio tool. The only cpio tools
allowed are gen_init_cpio and whatever cpio is present on the system.

> - point GNU cpio at an existing /dev/console

This will not work if we are inside some container, such as docker.
Container engines usually replace /dev/console with something else.

> or call mknod as root

mkroot should work as normal user

> I remain unconvinced

I still believe in my approach.

According to current kernel logic, /dev/console
magically works if you use external initramfs and doesn't work
if you use internal initramfs. I simply propose to make internal
initramfs work, too.

> To me it still feels like a workaround for GNU
> cpio's poor archive-contents-must-exist-locally interface.

I will repeat: mkroot should work not only with GNU cpio,
but with whatever cpio is present on the system.

So we should either fix *all* cpio implementations, or
fix the kernel. Obviously the second option is easier.

--=20
Askar Safin
