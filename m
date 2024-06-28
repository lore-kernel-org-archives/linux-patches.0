Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6661F1C005D
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719583881; cv=none; b=ISo4l0GhYhRdzwVP2W4r8FCCkLEalMVtG339rLeFcOxhVH2jATXsFogwnam+vDIzuPmrOF+nLaNZrCnF7nb3bAZ+ZLBq2UcYjMNMm6p5HdYCCdHvtdVhDS0NZD1g6YdQniCLWY6EeaJI4h4mH3JBifDUW5gtEoz3TCeTBptBtuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719583881; c=relaxed/simple;
	bh=kiBm5EREbGVMfrUkvJrKTbweEBAPn9IDvv8OAj+0kdw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VfvtPqjuKNEfDxhR6J/nNCfB/atSFWD6o7Qee9GrTKgdGCA1ms9Nd6d3fR0zTV89STxaMua+HXYh+2w72UqYz7d7su3DX1tUemHx/hZft2Hs3TUylWIMGhVntTWfWokx2qF2QoMoiUz/J5L4VuqCtGm8SEd0xxWIGwsd0sZJXPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=jccxMSwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jccxMSwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6020C4AF11
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 14:11:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jccxMSwA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1719583879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kiBm5EREbGVMfrUkvJrKTbweEBAPn9IDvv8OAj+0kdw=;
	b=jccxMSwA7KN5lVInGIUdn2zhnh/XvdjtM6g4cdb4vYra61SPNWpxOGNCzc0MGg13tSJqQG
	x0gc3/RwSTQYvWVYe9izd4/kra4HSPguMUo3MUkRvdPlH7eBch5i1YTLht4wm3RPz9Qeao
	HcneQ8WMZSMpyymwBU5F5MC8/xBLduE=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a45f1c53 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Fri, 28 Jun 2024 14:11:18 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-25ca169f861so254187fac.1
        for <patches@lists.linux.dev>; Fri, 28 Jun 2024 07:11:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCURZf5mV8G2NWq0MDLPZdLgSqfR7w2O2MBU6v7RiklRYVedCJo0zCOGnvpy+rC2zsR4c3KGY8zYHGl/mLWCAhVmy9qIQGJT9Q==
X-Gm-Message-State: AOJu0YxN/RAFCcWlcy2NGy2L+og70BGJeqB72NyK0HQCr3+dWt0Em/so
	ZDknAwEU5DuVVePWTARBge5DtcGVSVNCQLrlPsKTbwPfpPWvYfasCT9FbQ44WhfrH/Te5BKPdLf
	thtD3kQkpSX9495QD71XU28HAgR8=
X-Google-Smtp-Source: AGHT+IH73i4vWkUwP/nwORa1lPm13U0mDbFmM3PEnMtqyVA68Re9x3Dv2/wlZYajXycXMVpAiSG9Efnf12qa3yZKoaM=
X-Received: by 2002:a05:6870:2cf:b0:254:b337:eeb5 with SMTP id
 586e51a60fabf-25d970c8faamr711542fac.18.1719583877248; Fri, 28 Jun 2024
 07:11:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240620005339.1273434-1-Jason@zx2c4.com> <20240620005339.1273434-3-Jason@zx2c4.com>
 <20240620.020423-puny.wheat.mobile.arm-1wWnJHwWYyAl@cyphar.com>
 <ZnQeCRjgNXEAQjEo@zx2c4.com> <87v81txjb7.ffs@tglx> <Zn7D_YBC2SXTa_jX@zx2c4.com>
In-Reply-To: <Zn7D_YBC2SXTa_jX@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 28 Jun 2024 16:11:06 +0200
X-Gmail-Original-Message-ID: <CAHmME9pBvKRUnpU1tgRBELRBoPV6m+56Rw9+K+QFsjmzh1fT-w@mail.gmail.com>
Message-ID: <CAHmME9pBvKRUnpU1tgRBELRBoPV6m+56Rw9+K+QFsjmzh1fT-w@mail.gmail.com>
Subject: Re: [PATCH v18 2/5] random: add vgetrandom_alloc() syscall
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Aleksa Sarai <cyphar@cyphar.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-crypto@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2024 at 4:09=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
> perhaps definitely to deal with,

What?! I meant "definitely easier to deal with".
