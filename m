Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A812A34B688
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 16:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761151315; cv=none; b=O59UU+Hx5Zgm1xcio1NuwpRFYNhkmlDmNSekCHt69ZAqm824UjkMW52DgP07AIE5Sddb5i97daucIaoYqGpKyFmhpgmilpCMAQet0DibkYXPCc80qPVQ/63etEOB1hw5FAEUhq0rYbfl+eUflqmrYxtmxugm5n7kHzoHQdPn4N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761151315; c=relaxed/simple;
	bh=EcYgA1Dp2f8fgnuyFgD78VApES3CVJQ6ODo7jPzfgGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U46eKiSVVEWpyQFRYXGtK2W564c35M3ubmfgVNAQGgnwWzw/7Kccb6Bby1tE5Gqplrah4m21749TJwAC7nXXRoHY+jBIVkTihnfh43F64ewBFlu4W+ZLb0iAdJklGjb/uaKPm+DgYkrxxI+0Lpb+9bR8MfscOsyMmxZ9qOVwrFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rg0Ba/NG; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rg0Ba/NG"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b456d2dc440so1161813266b.0
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 09:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761151312; x=1761756112; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EcYgA1Dp2f8fgnuyFgD78VApES3CVJQ6ODo7jPzfgGI=;
        b=Rg0Ba/NGcwIIpBbeVSy7wkfXFzHiXC7Jx5veU96ETVadIAEwqwVRKsJhO5XWfuVmNV
         tWkbCvqaK3p0eOnA8iuBvZ4w/36cR/XFhKJ5+BGM+Qrnd2ntkjoeLdVMV+doZHg0+fxk
         B9RRc7iLMWshvmxbPnlHidyIgeB/OwXNaH4LOwsiy+Au1ex9EyKRrYORxs8wfEpMmnJr
         NccwZ5HYp1J10IAYcq2UfRdL/UH02ysH0VPAEUr9nCYEZwwizxrVTZdkEltQJS2cynPE
         qhwMU9jjKfipVmnTDkGtErKlOtdB5Sxa+ZWjmgyQToIHH9wmfEA8MCn1OsVGAbFWj/ou
         zqcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761151312; x=1761756112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EcYgA1Dp2f8fgnuyFgD78VApES3CVJQ6ODo7jPzfgGI=;
        b=DlL4OHXxg5vxhn58kwC7cNxKaMpJ5tY3vu3j0+QQh5DNUrTsrdLQMjdeNTl5Gg+ab/
         9Ir0xT+EbkOFKWMW/OeqZMZkhBQwDDh1cpx19P2AhoqbIvJi1LOxI0YoRbMhIlh9HAuU
         v4P4o9CfnB2Vcq1PDPdCwEMqAVBYDvICmbnGEH7QdJAezw5wbWYgJkM8TI/iGHr802Sq
         yGyRb0u+f0SZTOWFD1trDYefyAqw7hFWVyUBTpUxaZJ4+A9DwGGVwYgV23uakX5SpDKY
         vihw8Wp9tS2q0ctqwt+CcDQzpNTZn/v5IBzdGPY89YYPj5aoubXYq06SLxSbHR3l6Ls7
         STxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWN0r/cH0tcmRdRHMMdxawJceIpje0QYLne1Rs24OvuRUajnaY+soUVzC5STC+ilehGDjKWjc3R@lists.linux.dev
X-Gm-Message-State: AOJu0Yy73fSBxU3lXn1G+RIaTm2wowfZXO/CkRYX5nE0DGXjatB8Q+zA
	NnSn9DdUSfAL56Z1UvX48b+mVCAJTb1gvGCxjAV7UuWi7i4FXdl2gxw5yb6gQsNeGTSYQ2DrNQW
	zDf/NQrpBtbNmsdJ1zZf/Fj77pZeERbA=
X-Gm-Gg: ASbGnctx/E5gVTIjrPq9EfHLJSVZCeOXem/8x0QxWwo5/rrqy/SS+NAMOVhOJ5wX4bD
	7JUspMHkaXS9B028jT42CKkGjG0OlFJlrQGdZgXpql9blA0C0Rb8Or8Kmd52dHoAS+INxCKEgQH
	rHtuNCYPNmPQC5GgZcx36VGw66JNpBtEDRXGs5EQ6y1Q8A3FWpCnCwQNAiqh+RKNiyhYGEsG7/N
	bk+KStIEAqI1SeApNatI/GgpblFk/oHV5gp4ax7RgF9S/71IBbvAxobKYai113GntIYAH3J
X-Google-Smtp-Source: AGHT+IHkWGnG06JOtYFwx6WKEecUCCr1fs/y3xfoAi4lziINz4JBVkxPbzc5Y9qrcmqbPId7dzqQXzuYY7OGWY5xDrg=
X-Received: by 2002:a17:907:c11:b0:b32:8943:7884 with SMTP id
 a640c23a62f3a-b647500ee9amr2300275766b.45.1761151311555; Wed, 22 Oct 2025
 09:41:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aPg-YF2pcyI-HusN@archie.me> <20251022080626.24446-1-safinaskar@gmail.com>
In-Reply-To: <20251022080626.24446-1-safinaskar@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 22 Oct 2025 19:41:15 +0300
X-Gm-Features: AS18NWAouNqJg7toJrl3zFJYl4AxgHZN6-E0xEGlNVrmOGgNKVxnzpVBWI-jPi8
Message-ID: <CAHp75Vfb5J9P1vhSWkGy_j+ter_774ThBJHZuSp=r583xGP8Cw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] initrd: remove deprecated code path (linuxrc)
To: Askar Safin <safinaskar@gmail.com>
Cc: bagasdotme@gmail.com, akpm@linux-foundation.org, arnd@arndb.de, 
	axboe@kernel.dk, bp@alien8.de, brauner@kernel.org, 
	christophe.leroy@csgroup.eu, cyphar@cyphar.com, ddiss@suse.de, 
	dyoung@redhat.com, email2tema@gmail.com, graf@amazon.com, 
	gregkh@linuxfoundation.org, hca@linux.ibm.com, hch@lst.de, 
	hsiangkao@linux.alibaba.com, initramfs@vger.kernel.org, jack@suse.cz, 
	jrtc27@jrtc27.com, julian.stecklina@cyberus-technology.de, kees@kernel.org, 
	krzk@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mcgrof@kernel.org, monstr@monstr.eu, mzxreary@0pointer.de, 
	nschichan@freebox.fr, patches@lists.linux.dev, rob@landley.net, 
	thomas.weissschuh@linutronix.de, thorsten.blum@linux.dev, 
	torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2025 at 11:06=E2=80=AFAM Askar Safin <safinaskar@gmail.com>=
 wrote:
> Bagas Sanjaya <bagasdotme@gmail.com>:

...

> > Do you mean that initrd support will be removed in LTS kernel release o=
f 2026?
>
> I meant September 2026. But okay, if there is v4, then I will change this=
 to
> "after LTS release in the end of 2026".

No need to mention "ater LTS release", we all know that this is the
last release that made the year in question.

--=20
With Best Regards,
Andy Shevchenko
