Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BA5201260
	for <patches@lists.linux.dev>; Wed, 27 Nov 2024 21:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732742579; cv=none; b=XzLMBlhZRP4tIacc0yFCQtDdMC4/u+eg+mgo9Bo3bV9thQf9wV2UOHUcbIEk/PWBAKvScrjRJMaPsZdfs+aLlqnr69OMQYtKw7/nbSLXfKksgiW+3ZdVXdUc9/OL2Ww+DmFQlqT7sSt53Zl+CGtazJyxsn0zaruYZRqDwry2Soo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732742579; c=relaxed/simple;
	bh=mDS1XojcKgyKV+qhf+mZoci6ei6W3HBx9/RajVFqU1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gorrdI5c6Y1QYsTScYZKWtRvNMMB4FH1dt6thhmDXiolzjY63AonJjFIjwFiHysq1iD8qkbm4IUe4yAFJU41b8tTnv8O+ItWVrbYCFILztmR1ikxANMNE5O8aRf5+jM5aWzQTecS6sVaZ4IOWJCmEDD023ro5dqvXwwAq6QZ+8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gRLGnFUD; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gRLGnFUD"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa530a94c0eso14576966b.2
        for <patches@lists.linux.dev>; Wed, 27 Nov 2024 13:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1732742575; x=1733347375; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Au3QzJwj/0l4623aVKpu/uhJ436TUkwvUw3oPsNH4kU=;
        b=gRLGnFUDK5N7GDvq6YQTe6Kxz7WRi+Z66Cm6WYrDLi72d9yV1d/xHns9UCTJR5Ay+t
         HYEBaGo6kLnJmn+JYJqhdi/J4xNcBzDh+15Bm1uCRAPr6sLZH/vg9RusVbs7T9T0tLMJ
         juxyXQA0uzMIZn2I1WK3IXe/d3WcP25LI1ffA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732742575; x=1733347375;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Au3QzJwj/0l4623aVKpu/uhJ436TUkwvUw3oPsNH4kU=;
        b=r10vRvALtmadSIrqhD0sF1H6mpzW4Df+VZAy/xMedYYWq1gVLbSHaGk8tzw2PL5y6q
         epvuPpKscKGixsj/tSB+ziuymiQJXIrfwu0DPeVA96irR6TE0E5sdze8pe43f6+344+c
         H5IjlU+okeHsBzJzIfg9mkOO9uXYiKYDmD49OJR6g1BR7BX+UlUY6wWi/8BuKIFkZBWs
         q4qSfkX2wSqSjbFNqY7Gv1CXCnPQU447F+qtfsXC6/mm28wnGt6tgeUPc4EdUnbHUTXW
         p/Y8qpiLo6VAGpgZj16cwJOyt0Kx/DTzH10MjNFDpOPVGG14Lv/0/V/5Ur0OqBKq2kLJ
         ArcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJvjoHJEQwiJ1U1oq5Nr4CwO0rH7wrcaKUOKxCjxAJS7PqILqfOcOZon6qWPWTpT3DUuWOHyNM@lists.linux.dev
X-Gm-Message-State: AOJu0YzdNUrSK+26zhhlwx25GZvQHGjg1sIwNYY4a7qxzMoF2DjKQ/Wc
	hOk564U6Ww4FBkUiqDdiWXoPmoOTAxN+MjzGOfOsypWFvKZYlVlsH4ZnBZpKI3GvpufKZaFtLX6
	ykag=
X-Gm-Gg: ASbGncuOgvAkRpKT1beom5wpr5ATloOHdLeoClbVngXxhK+L4oajR6P880G5Ds9CzlZ
	bo+wmrF47zufF0rfrCO0+aUYem3k/EkHoFhFtXm55qUbV8t2iMKaOFTwGMgq3y27I7zlPcOtJsi
	hZLC02ouXGpyeSoVh11f7eFgXxh2o5hJbONP62YMuRxq84LIrsJEdfWUleizC8Ig0poofn+Y/BS
	cFYeC82qZnruuFV+Hq6p6qNWpwLj65XTT0uUlxXhTY7XprSGhqxj0429GeqXbdR4tRCWk7sAeOb
	YjxeFc+PvBVfgwnwkvh4qZEV
X-Google-Smtp-Source: AGHT+IHzxuwes+VmkG3I0ADT7SGUPkxhja3cZ5HADqqn1J1OKuRJ7AIUzr+RKJDco6HVBl0cIkx1VQ==
X-Received: by 2002:a17:907:e8c:b0:a9a:55de:11f4 with SMTP id a640c23a62f3a-aa581081a81mr360943666b.54.1732742575436;
        Wed, 27 Nov 2024 13:22:55 -0800 (PST)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b57bd96sm749120066b.148.2024.11.27.13.22.54
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 13:22:54 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa549f2fa32so17431766b.0
        for <patches@lists.linux.dev>; Wed, 27 Nov 2024 13:22:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV/IAARiFB0ruYQqI+XLI/7kXHjU7Xx/eqdTaW+5W0S2GMV5IMNUfTU/JSGKy1cb1L+n6JGNTVi@lists.linux.dev
X-Received: by 2002:a17:906:5a5f:b0:a9e:b471:8008 with SMTP id
 a640c23a62f3a-aa580f6add9mr299720866b.34.1732742574156; Wed, 27 Nov 2024
 13:22:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
In-Reply-To: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Nov 2024 13:22:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
Message-ID: <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: samitolvanen@google.com, petr.pavlu@suse.com, da.gomez@samsung.com, 
	linux-modules@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, masahiroy@kernel.org, mmaurer@google.com, 
	arnd@arndb.de, deller@gmx.de, song@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 26 Nov 2024 at 17:10, Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> Highlights for this merge window:

Lowlights:

>   * Adds a new modules selftests: kallsyms which helps us tests find_symbol()
>     and the limits of kallsyms on Linux today.

This is completely broken.

Try doing "make allmodconfig" and then do "make" twice in a row.

It re-generates the tests, so you see this:

  GEN     lib/tests/module/test_kallsyms_a.c
  GEN     lib/tests/module/test_kallsyms_b.c
  GEN     lib/tests/module/test_kallsyms_c.c
  GEN     lib/tests/module/test_kallsyms_d.c
  CC [M]  lib/tests/module/test_kallsyms_a.o
  CC [M]  lib/tests/module/test_kallsyms_b.o
  CC [M]  lib/tests/module/test_kallsyms_c.o
  CC [M]  lib/tests/module/test_kallsyms_d.o
  LD [M]  lib/tests/module/test_kallsyms_a.ko
  LD [M]  lib/tests/module/test_kallsyms_b.ko
  LD [M]  lib/tests/module/test_kallsyms_c.ko
  LD [M]  lib/tests/module/test_kallsyms_d.ko

both times, and this has made the empty build slow down by about a
factor of two.

Which is a big deal, because the "empty build" is actually fairly
important for me. It's the baseline build test performance, and with
small pulls it actually dominates.

So this isn't ok. Please fix asap, because otherwise I will just
revert it - it really does affect my workflow that much.

                  Linus
