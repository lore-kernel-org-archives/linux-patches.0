Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820162FE575
	for <patches@lists.linux.dev>; Fri,  5 Jun 2026 15:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780675139; cv=none; b=dLk3N1Dyvm1Xfj9zA7GDkaryAQStvxcli7JWEIxrmLCjUZhLQBpqjXzjQH/iBlouKZ/68x8f9NIRNf4s/M6YAyaPRKvN0zCP5AS32d0G3XK8ut3jE1HALXQKNVHY22LulubZhPWSeDih5LceUfFwQ13zargejkdvrsshjlD6YA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780675139; c=relaxed/simple;
	bh=cHDeiU+5q6zHW354GymA6FXFmgmlOGfgwP7cdr1ffak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FWV+YYuo17g5E0HiQVh02bbXHGOz+NmmEBnJToQBLbDvof2Db2Pae+bxOAIolYuegJpP7ROdvAyBo9SfFLVuZ3yYZ7/Y1OqpCESNJCLmPjuH6vNiRBj6hLt95VWh+JtR7tevYAY48jwAJRHYYTw4YsPNiCymA/wFpxbP59JUT3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bn1It7u/; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bn1It7u/"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6912f4acca4so502162a12.1
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 08:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780675137; x=1781279937; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OUZ5QahFiUWTYdBZUTA5YwtlfS/dH2OxVTaDuMHjYEI=;
        b=Bn1It7u/MRH3X6OdCCj1wYviEkI13P8GtBChdK3iwS+l3o4C9SFr4GFe6iHHbEp6a2
         r3CxdUGfuKFlIzUCsPuS4EYE3VyW3DH/zxrivybpPUW4I5IcDm0hhIvkosrcY9wVsmnb
         qQX3fK94b27dJZvzBQFHNgTljfOFUbvm4JsK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780675137; x=1781279937;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OUZ5QahFiUWTYdBZUTA5YwtlfS/dH2OxVTaDuMHjYEI=;
        b=KBH4/B6fpf4l/oHRESVbL7ee2jf0QvsHShQhb2AmnJfCW8yueWAWCTKzGKsAbt6pnB
         ls70v7IHbSeNpIA6x8I9Sg2h/umc0sOOYJ7OfxgV6QD5r07CTrLQE31m2JoJS4ix0AFI
         Q5CLcrZL67S9B0Hqezhj0P8GzDF4TSWX11ILJu6YlTTyQ5/P7TVYR0H1q7ySoRysko3D
         X2jH92Szr1nFNqJKE10cxFOrH3VAz0SpVgFWJpMBuWgkcY928zTfPWWnj3rb0ZylEwaF
         TzQ+yQZPOb/Jie3kl1ziVIndgDbUsbM2tK30UluRlXR6bsO2KZYH+aDEi6lJcCbWrC6h
         pggQ==
X-Forwarded-Encrypted: i=1; AFNElJ808ZlXzMblEHOSTyUJ4q65gngNCs96AXXxdBxmRQzCG8ncNz1XcSVHqJSLdKHFLmwhH1cqWajx@lists.linux.dev
X-Gm-Message-State: AOJu0YwInPGK2zhOChqxQu/5sY3KabUmCM+BToM0tTxxsCLCUoNws6B0
	iRdqZk2PqXHRGuEE23Kqs1KDziMeuwlNXXd4K5KWfOPWPx67eEqsP5tz7USEOMVaJ+o4mCA9fdW
	jT2+2nJKGrQ==
X-Gm-Gg: Acq92OG+RthSv54EYSg0yoJmzRo1C6lrZEK1ue1o68JSVDMxyFImgTn7RrKJB039JOA
	tS1jkox/yTU+1N/Vx2nQh371wSLkYmHzgdeb50QiWxCGJS/ZipxH3kxFjKSddWmmS91vUh4Wd+H
	9FknY63a6dmsyu6GwyNSpqKntVLEcfS5deV7j7YSerB6SIOLIWHMv7VvkEqkwjOZt1vUW1ilZxu
	TOxWxgXwKZ/jFA0M//+jQCTyIN94T8O6EoIREmqRRzeBsFivfSBz5eOoBFQnWeoP/S/wwVai5Y+
	2uN7yv7YqdPXdq2u4DirR9LItcdJmKzGXSIAzxu+jMPckzvAf5GPnsv2FTD8Y4H71MPnW+LV7rB
	TEWXnMdkWF+VV1+P6q5IDhGF9wEvjHzFr9x21fUGC+vf2oCOPZycZhFa/VL3Nwe6+qNgLuvXNK6
	qj+bepIyS1FVBBKkwihbiAi9Nac+4z8MI2B/p80u3oYuXEIFEHr5lVdoXx/89ILtJIuC7Te0p7s
	9/odO/Z+Oo=
X-Received: by 2002:a05:6402:2713:b0:689:bbd0:45b0 with SMTP id 4fb4d7f45d1cf-68fa4c1fcf2mr2152276a12.9.1780675136966;
        Fri, 05 Jun 2026 08:58:56 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68e65867e67sm3813103a12.21.2026.06.05.08.58.55
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 08:58:56 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-68bd167797dso3173342a12.0
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 08:58:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/72aQGYVD/v6PofCLV5aKeaRKQtet+5HxrAAScDqFsPl6bGhHtqu1/NnFKgyi+f2vyKmfdWk8e@lists.linux.dev
X-Received: by 2002:a17:907:a03:b0:be2:dd37:facd with SMTP id
 a640c23a62f3a-bf370e6211cmr221318066b.20.1780675135190; Fri, 05 Jun 2026
 08:58:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
 <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
 <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
 <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
 <CALCETrXpqPMS487Bm8f8mHe8hv9DzCqoaW4UdoHetzYBUAhYLw@mail.gmail.com>
 <CAHk-=wh5bFj1a7eaGp9sixDg3UXu7xUGfU=YJo+ckpGxGAyhXQ@mail.gmail.com> <f1c7fbbf-5be1-48b0-8927-2d9b75a35816@samba.org>
In-Reply-To: <f1c7fbbf-5be1-48b0-8927-2d9b75a35816@samba.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jun 2026 08:58:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=whL0oLvmh3FO9SapDhgrXMT_d6qkP2V3OBjysOWXod2Og@mail.gmail.com>
X-Gm-Features: AVVi8Cf0FjZlqJePEzD8bhzCDc_NK8sni3u4Z9RMJefCrCHFLhBrwtWwfg4F_Wo
Message-ID: <CAHk-=whL0oLvmh3FO9SapDhgrXMT_d6qkP2V3OBjysOWXod2Og@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Stefan Metzmacher <metze@samba.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, 
	axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com, 
	hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Jun 2026 at 08:15, Stefan Metzmacher <metze@samba.org> wrote:
>
> It means the most common workload, e.g. a file only opened for
> file serving (or simple opens in general) would still be able to
> be optimized.

Nope. If your web server opens files with write access, I'd be
extremely surprised.

And if you don't have write access, and you're sending out data from
files you opened just for reading - the onle sane case - you hit all
the existing problems with "I can certainly look up pages, but I damn
well shouldn't pass those pages to the networking code without copying
them".

               Linus
