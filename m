Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B94E3DA7C4
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 21:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780522743; cv=none; b=XlzevmB7MF3h7fn7DFS3MtMWebcNMUpKJxK7tM26YlYiOuAVh7USyPx99GvYgNwT36OewIkHUXCNfv5xrlvKZ72N+6i5q+3ltbHI8eqBfxGsbnghykLYrFGJvNzvluAlEaqEjA7X+Ww0hHHJj9yIuJ33Qxez8hg0CSGIgaGYQ24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780522743; c=relaxed/simple;
	bh=KZSmPn6xQM1bVRhAbp7rTJ/2+QAJ2min3ynRo3L1ax4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J2ExZST0sfq17aSx4odFJDOX7HpV8totG4zCt3wLPlUuuR+Z7hUZLATigUrS/gRpaGrRfp9GZ0Ww5JLOcbrlYemsWMDskrXVdyynFrT79/QMN3kH6MjOa0TuQMFnsCYHnmelzbyDpLzxSVEwy1RdNF0EdtSzRHaSfm3WuJCRYao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TcZfbmmN; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TcZfbmmN"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-842273a2c4dso3702b3a.3
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 14:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780522740; x=1781127540; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O8X5hcAFVZJZKmCogabE4dJnuZ1g/E7cQIrqG9l17rg=;
        b=TcZfbmmNXXqqU9dboeWy1xxCSEXOGMulKi+SJ5jLBiDu1X89IKtZObyyNaAnf2/PE+
         pTf096VLBq/TK7zorMCiefvV49KF8IF798Wn/0PRpS3joSlrb9zK0Md3+u4XafCBVdSw
         cvAlsH+aJkOJ0xdCIt69j21wRxTNta4t8pqoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780522740; x=1781127540;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8X5hcAFVZJZKmCogabE4dJnuZ1g/E7cQIrqG9l17rg=;
        b=Wqyix10iEpSQE4cgmaLqGLKk8SHHJ7cpKUJOI0uLWYvp2uuMQSRXa9OPXOg56XO+aW
         b4UEVTDQVrnFhWE3mctCP5VGC8ClNlP09qOlQb51SGopQfTy2ZJb3JbUni+L19T0wKyI
         RVf0q30xTzRw6NG08IvwR/ZCurbAHi+J9h5Ta6y3jVt30Ikfn+zwDusDGR6LcGsDt14U
         1sb7FZ43R4FbCj83hxVH2v0l0jtxvoled5lkM/GM/oa4n/uePy9zENUr+NcOowgT+tGp
         NY8xYMnrU2VDuGFRBkOeEZDGmSBdEa0NhyTX+j+BB/mgkKrN/d4uptfC3n0qM0RANPiS
         EFgQ==
X-Forwarded-Encrypted: i=1; AFNElJ/yd5xgwOQsTP4YasOfS4dxoXvKOUoWaqWP+jjE0Xpm8LTrQj6JddEmyIe1XptSU1yqltPoSxJm@lists.linux.dev
X-Gm-Message-State: AOJu0YwxBM8mxoxO3PBj4D9Dj+CyqUfEYm9dVUhrrgVPmfgYKn23WVvu
	d44CaAHFo0/5G7lF2tgzy/cOoy8n24/V/+/tD57lu2dnkKt38is2f4ACmBNpcOuoOT/knenEtV8
	yI+9l7Y3O2g==
X-Gm-Gg: Acq92OHylSW7RIxVP+Uda9cirbKdCal8lhq3s9EfuhqyPOj+47/e2Ya1Vx1ILo+uOrI
	tBzA9NpWPVE+xvU0lAUgmn/HRaht+/jejDSP6MOuS0228FIWD+m38MHHTx8Vgdr+v3TS63xCErd
	t2Mjjr8oll3ks394S4V6GPEiIubc+itVnjVZrIS9076W/UBalQ6PZOPdDfJbCDrhraAzFIYS7BP
	zdIqSV3RNivGfg9TbEFBpQq00CNEIWYgUxY/WL5TE+8jXcikofy8UUAdRyCzPklXE0aGojId7pF
	+U9KXQ2iUs9aLSaHg4ohnbLavGKmYZ5d86QjAq3tWxnLvSzL5+oSYfeMONb6ABfjZq0ZuFRGSOm
	fyBQocyIX1kt5C2StUnF4lFXQL82mbkhqS9gkeDbuWj7iusQ1zVZcZx/dg3/OHuRQOUY6ao7TU7
	xhMOs7UYGn7kgZQEOqetEWcR1+1KYBXnMgIoJDVVbAFbYNt8tpoN8gjzU9QXwM9rewBHbrLfLzI
	BHbmxkf6HByKuCoa94ZIQ==
X-Received: by 2002:a05:6a00:3695:b0:842:3be7:4d54 with SMTP id d2e1a72fcca58-84284e2713amr5219411b3a.15.1780522740182;
        Wed, 03 Jun 2026 14:39:00 -0700 (PDT)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com. [209.85.216.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428221c3e4sm4099254b3a.5.2026.06.03.14.38.58
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 14:38:58 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-36d8b644473so4344358a91.3
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 14:38:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+nxL0OOULQucYgE7lFKP2xENUt/62b4R4XrYfsyIyGvtih11G3YEkyMr1TYewf0yAj1XOgbsd0@lists.linux.dev
X-Received: by 2002:a17:90a:d647:b0:368:af5c:5925 with SMTP id
 98e67ed59e1d1-36e31102a48mr5572800a91.23.1780522737998; Wed, 03 Jun 2026
 14:38:57 -0700 (PDT)
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
 <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com> <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
In-Reply-To: <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 14:38:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wha=LtAq8y-B4j9ps1g_qv3CK0LrHdHEVxP_52p-m=NZA@mail.gmail.com>
X-Gm-Features: AVHnY4IpVbwzilxzEo0kIzmtKsGcV63XCgmSpKmBQvjcdm3Lbflf84U-wY6VXLY
Message-ID: <CAHk-=wha=LtAq8y-B4j9ps1g_qv3CK0LrHdHEVxP_52p-m=NZA@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jun 2026 at 14:36, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It was just the filesystem side that basically now instead of exposing
> the page cache directly (with filemap_splice_read) now only exposed a
> *copy* of the page cache (with copy_splice_read).

... and let me note that UNTESTED part again.

The patch looked "ObviouslyCorrect(tm)" to me, and I did actually
compile-test it too.

So it probably wasn't _complete_ crap.

But I never even booted it, and if I had, I wouldn't have had any
loads that uses splice (or sendfile) anyway.

So caveat emptor.

              Linus
