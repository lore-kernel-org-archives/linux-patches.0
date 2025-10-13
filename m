Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747CD2DEA76
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 06:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760335596; cv=none; b=Zb3R2Tqyx8om+t6wZ7JTFwNEnHaGTXFOGjMnz7MjyKtEL4oR8FsTtVfGYi0pBIPjjFknvsgReuM2Lzi9oJKWr6/KIzc3dpq9fTNkdBvnJo9zhhINoj8G+dFwYxzw/FagnOynZcQl5quEDMRyhMQP70zYJ1c1CnJImCwUmYts57Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760335596; c=relaxed/simple;
	bh=RSL7ODefchx0oaqAeJ6n26+cCreCbBCiVlRzlUCjIjc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h8fcsR3AyJiJZ7kmLmNft6nM0SOzqNz4lEZv13FL+XCwLYMJzR24SgPdLLQWZK0KlFQCKdiNWTLVwgLyF3SW4u4w1p6aJ8TwSsLvQulW+yMv10E/f1sdXcQafHmZCISR4bsYf0iStrPruAYksdsiYzx1eQALhGcmyk+2TTRX84o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d2hDjusB; arc=none smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2hDjusB"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-633c1b740c5so3745703d50.3
        for <patches@lists.linux.dev>; Sun, 12 Oct 2025 23:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760335592; x=1760940392; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RSL7ODefchx0oaqAeJ6n26+cCreCbBCiVlRzlUCjIjc=;
        b=d2hDjusBxBn9+VwLgoHDwtJ90LlCoG0ueQ3cbD7Lv91aw06BiprhI1Qmr+6wSryYV+
         4za/5e/YJjwq/N11FROODjydQPJE3CijhrOqzh6xnQI/vkXVegVf2DzK+jhoqILCFOzG
         usjtPjkNKG0yHn4bJoR7Jg7MRcqgDPVgEJjiNLzIWhByGeBwrDpQfirn8BnahgsVrrhU
         pARx/qfPXle6MCLeJWpf0L1pa+LZfv1eDSDs2NuVEPUj3UdfV5D8s2WZ0Tv+tYMQhtQf
         FXjOIA35Wnagtq3z+aIu/lj5QBCSeP4ehAAaeRcrSjI30fwEcOgCLdeSgDdGzh/SHI9o
         wh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760335592; x=1760940392;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RSL7ODefchx0oaqAeJ6n26+cCreCbBCiVlRzlUCjIjc=;
        b=DMAmUU1TGaC5gwjRs6WJGJ1U1e3pRCBOhp6dxty+HAIm5IkfmGPKwbLfBSNf8Nt/hp
         H8SI14T7LGQYU/jgkgSRrLJVBQJN6udx/zulGIvv9Y9fsiZ1pepeDz6GH4jNtOFlL/0I
         bocsA+feGyWljI1kA+JxWuk9sgUfP0G+6uA+LXL+QSUQS3znQb03G2xWtED1o0t60qK0
         SjO8YB+N4G45dR8pl0q6TsXLjV50HLEuokLg083hbjRE3xd7aDeD1aDEdq7fKlIrQ4i6
         U+FayG8wTLgVahc6fI/h06OeGn4zIdbfGkIDD5ItU/a+gkUMK/9C076gocoiU1fOEika
         Pc2A==
X-Forwarded-Encrypted: i=1; AJvYcCX01aQy20TaEjlS/ug2JfsIcstNdfFFY8rU6fY8s0I2BmRXac3uy/Fhpew6A+xZ6vlbn/GDVoYI@lists.linux.dev
X-Gm-Message-State: AOJu0YxbLPGY7s6lIlImHxfBSiFgiEV6zkn0Lt3WwavFs/XzWt6ChEKG
	BouJ8Xd+pHd/YiD2x4lIiXXuuaRs5LrFKFpPAPezhVp1+WcsIo0M5plEQNuViCvR5+CRcunkdN6
	+2beSCw2aj4qpIYj5kWtF7ZM8OmGPNxg=
X-Gm-Gg: ASbGncv7Y5oanTjxSJM2th0mMYSvVYAOPoMRYGu6VaywfkdiCbE+ibnltgHigSrRR0K
	3TXtTi63G3ODo5d68fHhK7fNzzVleoH1qtNolymB8hG2h9q7Rupb1ovP4UxItL3aCbi+JNe/7kD
	ft/nVQ4jDy57DrPNzP0di5y3TrTQHwdXXGdz/uxUgLXWjTMiVm5sqtM3MRt25w9KfEinqwJACM5
	FFIrIAs3MuYlZlkzAQ0tRUf+7BANZLRmoFH
X-Google-Smtp-Source: AGHT+IGNAOIcFLi0/Sm93Y3jSHSuxr+30gS3y7Fr34MKhVqQQnt1MJ/lLmHR6+qpb+bVmq5VVWr9ycljJFZ2Qxe2L4U=
X-Received: by 2002:a05:690e:4142:b0:63c:f4eb:1b0d with SMTP id
 956f58d0204a3-63cf4eb1b25mr7582533d50.22.1760335592286; Sun, 12 Oct 2025
 23:06:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010094047.3111495-1-safinaskar@gmail.com>
 <20251010094047.3111495-2-safinaskar@gmail.com> <CAHp75VeJM_OoCWDX20FhphRi6e7rG9Z4X6zkjx9vFF12n7Ef7A@mail.gmail.com>
In-Reply-To: <CAHp75VeJM_OoCWDX20FhphRi6e7rG9Z4X6zkjx9vFF12n7Ef7A@mail.gmail.com>
From: Askar Safin <safinaskar@gmail.com>
Date: Mon, 13 Oct 2025 09:05:56 +0300
X-Gm-Features: AS18NWAQKixJeSnu1jMDTs2ReasUmQ44oKevMSLcLyEUnjeI8Werl5Jwf9tycOM
Message-ID: <CAPnZJGDvHbDt_JvDNLN+LaU+5yFyB_qkdBtVhSEV60_yktAVzw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] init: remove deprecated "load_ramdisk" and
 "prompt_ramdisk" command line parameters
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Aleksa Sarai <cyphar@cyphar.com>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, Art Nikpal <email2tema@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Rob Landley <rob@landley.net>, Lennart Poettering <mzxreary@0pointer.de>, linux-arch@vger.kernel.org, 
	linux-block@vger.kernel.org, initramfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org, 
	Michal Simek <monstr@monstr.eu>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <kees@kernel.org>, 
	Thorsten Blum <thorsten.blum@linux.dev>, Heiko Carstens <hca@linux.ibm.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dave Young <dyoung@redhat.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Jessica Clarke <jrtc27@jrtc27.com>, 
	Nicolas Schichan <nschichan@freebox.fr>, David Disseldorp <ddiss@suse.de>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2025 at 6:02=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> 1) often the last period is missing in the commit messages;
I will fix in v3.

> 2) in this change it's unclear for how long (years) the feature was
> deprecated, i.e. the other patch states that 2020 for something else.
> I wonder if this one has the similar order of oldness.

These two commits were done in 2020, too. I will fix in v3.

--
Askar Safin
