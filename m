Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1D42E3EB
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 14:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730990921; cv=none; b=sU2iwVn0iLuWfEd3cf0zQ4GK8zQ/X1xLADLVSRhRTki/X8nN+5O/graYYr7Na9zrGSy543lT8RZmg5HrEG7R8zpHoZpUi6UFxt2r/oWNcWGMY+M+d138dGA5oGHyQgcTcvnxNftFTOs/sE0n3HhwgMefP67Ob1Xou2TL17gjOkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730990921; c=relaxed/simple;
	bh=obhoIviuaHhyC0A/b6MUfz2+yt0S4BGH+02rVk3sulM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cG43V44czIYJ6LqwDy+ZLwt0kFfDqXuewJPoDtVC02pRklxugsjPKUejWKiS+ytIV8/fJYzGXCmCeJAiyrdicqKEx9cZL7jKpGZdo4OeFZZzZ+TnSE21ikzj7fjp/uX1gLwtBFegs3N4M/iEemeJ9x1YFUEqvmB7KW1q5OoBcWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fEPWu+Uw; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fEPWu+Uw"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4608dddaa35so338601cf.0
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 06:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730990918; x=1731595718; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obhoIviuaHhyC0A/b6MUfz2+yt0S4BGH+02rVk3sulM=;
        b=fEPWu+Uw6ykVnmOMzmEgUYT335rR7xMwR7tMqRR1IehEIasDrcmO4Lxcz7aWZ2yGY/
         dWP+MzPOBHgRNfvvwfBavOjD1SLTiIVgLNoUkO59G3CYLTTtNGz7+bQ+6p2etPT/TIA5
         1jPp9rXRSL9EGYeaUBSwBbyGwQQIpZidcxIjcYqYksc3fhB9Q9wdyzkp7MiWgsub02DE
         k/A13C9WFwhZ/FPBCL6IhbDJpERrstQ9FwQE/a9IX9Sh6PodL8U2qRMAZgNH3SpTWsbV
         U9950lChlPco651X4d9OaQIrbwueCRKtRE1TXDp9y+XrvttudfSeiTDh4F7FckWsQGA9
         UZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730990918; x=1731595718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=obhoIviuaHhyC0A/b6MUfz2+yt0S4BGH+02rVk3sulM=;
        b=kTgWBTsPgKhklHAi4i4zNpWR0MZxP2DorTj6ZrH3N475e17sop0jCOMhfaL8FEbeaS
         5ZAwNqfASD7B5Bx/ahVVyFM8iQCwV3kcy7xccO6H6y5SnZsU4WOH6MfWuvBPZtV9xEQJ
         5zRWlq9j5eucOYf0OONTYcjj3yyRT8w3aJt72Dba8b9v2kGbSgp0XeGMirmhDvi6bptI
         NzZCuUV/s0jJjfiirrW4ThEsKYGa2dA3t3GIc0w/cPCSWJj6cgRb1dRiJNJSdcvXpwN3
         LmQo6KrAK406rZzsK75ron8AQ7ApZG+PVt5tPCKrBLKPeFtiHicHTLwxFsKI/ThzybOq
         6pvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAAam3lBKwesidf0gw78jvojsYiyCnaPYNROIZMRvhO8WuIetc8yjyCfHhqZ7Sq7yHAJpPLaeQ@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7Z/bt30OeEj5L3L1eH+B0J8Moxvjqe0BoKL25EDyD4GEO8ldc
	AFcGnhKwaYTqAnQPiJLsx9jvKeGvbe/hX9v42ccqYcWTU6Y4zygiZZyy2qJ8Hs0s7IZ8UvpuaAa
	orTPkZ/Zqb8KCh6qfk0F9h+P2VUMtUGTH/vKF
X-Gm-Gg: ASbGncuW3HlfHHhwuaUSb1PM16sulc5LZ4KPD/kXWv29awDMdA4hbWKAao6mPn70VU+
	L30iB8SGtMtO3wdv/KMkSlabyhgqkc+H3B+6A4ivcQYsAVSEdI+rUUf7N1a5w
X-Google-Smtp-Source: AGHT+IFUtxSOl7YCdaawpBadONVmwESllKbqlKdDYg3jdy0lj0KRfJTQJdUdOzWNrbgKvlM+eMv7ydh90ffq9ljzyjQ=
X-Received: by 2002:a05:622a:528b:b0:461:3e03:738b with SMTP id
 d75a77b69052e-462fa619d72mr4247661cf.19.1730990918259; Thu, 07 Nov 2024
 06:48:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106170927.130996-1-surenb@google.com> <2024110700-undertone-coastline-7484@gregkh>
 <2024110725-goofiness-release-bd30@gregkh>
In-Reply-To: <2024110725-goofiness-release-bd30@gregkh>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 7 Nov 2024 06:48:26 -0800
Message-ID: <CAJuCfpFRH_TMJ4v+KsaLMi__yaHg9Agg-HdyUFdHzc=3MeMTnA@mail.gmail.com>
Subject: Re: [PATCH v2 6.11.y 1/2] rcu/kvfree: Add kvfree_rcu_barrier() API
To: Greg KH <gregkh@linuxfoundation.org>
Cc: akpm@linux-foundation.org, fw@strlen.de, urezki@gmail.com, vbabka@suse.cz, 
	greearb@candelatech.com, kent.overstreet@linux.dev, stable@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 10:46=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Thu, Nov 07, 2024 at 07:37:43AM +0100, Greg KH wrote:
> > On Wed, Nov 06, 2024 at 09:09:26AM -0800, Suren Baghdasaryan wrote:
> > > From: Uladzislau Rezki <urezki@gmail.com>
> > >
> > > commit 3c5d61ae919cc377c71118ccc76fa6e8518023f8 upstream.
> >
> > No, that's not the right git id :(
>
> But it is the git id of the fixup patch that I also need to take, so now
> grabbed, thanks for making me look :)

Sorry for the confusion. Sounds like you sorted it out :)

>
> greg k-h
