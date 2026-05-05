Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5881748AE1C
	for <patches@lists.linux.dev>; Tue,  5 May 2026 16:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777997032; cv=pass; b=sdzdlBlsbDUgqmibF/F1bm2jSTlVZiIJkHo0q6OSi9fSa+oBEwCbPn4SUyAxvPsoLuh95UhCnZmYk3FQkpLdq/+lplG6k3KOTIJc+V5fzI3f8qdWiquYnfUhzeCntv74oZoDmm138W1t0oAHcU2XaJWd48dhGsQLbF6y0Wm/0Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777997032; c=relaxed/simple;
	bh=DOxw+2aGh05xah5kcfBJMyzXIPlOW0sfsA2Z1OFqjOk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JAzRGbzHgBy6HDcaFcHNGH0dWdNq1OjmgYk+bypeyCd9YNX0GwbNBAo1LGErYedCVq6kE73jINPVUib5zd9dHh+yKv+gTyztnVprc+MsSVFh3v+2PL5xowlmCTzprI+gdpN9IB9SSWAHExERAJr2IUlO/vUINs8Evwg3ZxPU1qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cwGI6lCG; arc=pass smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cwGI6lCG"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-12c1a170a50so7115356c88.0
        for <patches@lists.linux.dev>; Tue, 05 May 2026 09:03:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777997028; cv=none;
        d=google.com; s=arc-20240605;
        b=TmzowcDGLLagl5J19LgyV5TcvYhYDigrs/rvu7fY1VQGJZb5gLicAtqpb+k+cY8Y5r
         wsT2S7Ocp0vMeeSABCyyyZe618upzZ8lGbMks4Z5+uYNdCvSzL4b8C8ikI9tmrv1MDHt
         0u4jkpzlZKhv6apXozt8uqmK4XteQMY3+FviW9ufNVDe7XvSYGVDKZYD6ZmQpC+0t7p5
         4XO+I4+e2MXwAPcFREVTf98RrmWnTP6VO5Ip6s901epJBhcfE5a3uFe6vmTEJZLwi12u
         jRGK+5JMI9mn0kmDhyc3ppSOiy02WDOiw9nuIxD55DJzgeXSpch4AZLi1i4pKzgebgjV
         ey5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DOxw+2aGh05xah5kcfBJMyzXIPlOW0sfsA2Z1OFqjOk=;
        fh=nqm/Y2fo5dtvvjTRIjm9eS9nm68fUh7tVye0KBev4ug=;
        b=kAXXmIIiG4CstHjFwQnpjEncxJZlJ2yK5/HgFP97hf1pzoJDZGfz5bmKFWc8hN85Gl
         F7TLkepAwIiBGEPUghBpsP56EU87E1hl7/EoSUKPtfgWrBTZwL5KPel9Ii5xpfmUml4P
         n6bAlb0kLee2L4HH0U9iZ3/KMty25EoXrUy+5Hz71xkqeSQzf52WQ8HQ9m5jgM4Ie+tK
         X7gB4ZoiDNBOB5/DYpb7yN57fyOdNP60cDcYz7rSQcIX1ZhZ8J5L0IAhj5xSqwmS2rT/
         GuIQcdmGF5Zfg5IhInBFReoVrdiKEygrYEiq7P3FADhohikgRYQvoB6KR9tqku0+SvQK
         MytQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777997028; x=1778601828; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOxw+2aGh05xah5kcfBJMyzXIPlOW0sfsA2Z1OFqjOk=;
        b=cwGI6lCGhSCwNKpTUNwh5mtTkgG5zY3QLpWDHqr8UYSpTcO+s1+Xhf4zInNg56VXT1
         KOwkyww312KkTYdXPRc0ojHbdiqYn4xDvV6ZQCoL8IpbfVl7pYI5iZ1jgfQ8UqBb1E4d
         mzf4X0dvNujowvV/vEHlpU0V6JN3QlZr//3+nhyBoCDBrDtQlHnh59p24EhFncT5eJjq
         RBAKUr5cfZDqC1/4GfXFsXUyrEXrxI88iKasrVtTdsOcGjnO7tvt8TQaXbQ4RgcxauIG
         POpd2/m0Nxs37ru07CQy+Ui6d1o49LJUo2mZ35Jg4qtzV7eZrdcZ47f8YunWRSxa1BpQ
         I5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777997028; x=1778601828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DOxw+2aGh05xah5kcfBJMyzXIPlOW0sfsA2Z1OFqjOk=;
        b=ZyGHwCF4fJJsBlAdCqzHWp2D59L9B8YcJGiUp2SKJlgZyF9j48UYEq46QN19xprtWG
         m5glU2OOReUSKL6BqFn0xb++tr3F/RE9sAfSc+4xbzAV0TgWlBpd/nTOqXZp4goFfLAG
         VI8zU3ieG3u2m871ndZPkDwhYuvQpkXrs4hHHer/+KOI5DI0aMQaFhw1+YNII+cKH8Am
         KzETF9ibPxG+GJVXyyKtE14ziJ2TM8vMBaIUaQT3UkK3tPTQ1FEPzaNMAeWVnDRJB7sN
         6gmsS0Z+RCz0+H6At010jHoF4iKdQsEyL0Lc4VYT80JbRp0uZOD2wHRXd1Dy8wwb1/S9
         PbMw==
X-Forwarded-Encrypted: i=1; AFNElJ8JSZdKdSf/bvITCS133ZuePTE8I8f3GdKleems9wdPN1zGk33YrtrDcmxxuoO1V54Uswmg/YKy@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5n98O67Y+iVu/h6iBg+t0SV1/6XefgorezegGyeRDl169CU/V
	X3jsPrRWMcyT62cjq4Q4DA9tqha5lA+taOXVvEQd8WxtltNY3mpwiSTW9C1w41ldyjJP4rkU9yB
	2mAm0vmEIx4TuMcu8Xzb8W84X36Z7XSRWnRmWpn7x
X-Gm-Gg: AeBDieu88fcVRqJ94L3dwyUNNUVdSB1fGvtq9f0vuLHDWMKhwQHi6j9+MQOcqtI22hA
	9v2sZJ1PH2dcDSTEyRzyNg7icVC5DQGqGX18fcw+EjyO1qFUNBXU+qjJDWNpksPI9DKldyOAxrF
	gBgBAV0d4RBm6rc4juYa4xTzM02KtIcXToGIoPBuCOe90kTdYn4lSzlvi9ZVNPolLIhQ+yMooKI
	5+fVCv28dYrVHmrrHmc2HDKYKKsbpUBaEaqyQy1bk8YY4w7R+nMcU7bmU6Vr5U=
X-Received: by 2002:a05:7022:78f:b0:12d:ca32:59f with SMTP id
 a92af1059eb24-12dfd7e5bdbmr7028039c88.11.1777997026608; Tue, 05 May 2026
 09:03:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com> <9-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
 <afkfP-8UHaoyLd5Y@google.com> <afoQtL6gEN2wUba7@nvidia.com>
In-Reply-To: <afoQtL6gEN2wUba7@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 5 May 2026 09:03:19 -0700
X-Gm-Features: AVHnY4LsNmTptv6RYHm1ivIrJui-vL8wanpj85inMj7g24wxtEjU8rbJcAF7qfg
Message-ID: <CALzav=eQcRUNR8FtqDwXsjm+MbMSN-u7GyCj96-NmbDhB17GRQ@mail.gmail.com>
Subject: Re: [PATCH 09/11] vfio: selftests: Add mlx5 driver - HW init and
 command interface
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 5, 2026 at 8:46=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> On Mon, May 04, 2026 at 10:35:43PM +0000, David Matlack wrote:
> > On 2026-04-30 09:08 PM, Jason Gunthorpe wrote:
> >
> > > +/*
> > > + * Driver state =E2=80=94 overlaid on device->driver.region.vaddr.
> > > + *
> > > + * Contains both software-only state and HW-visible DMA buffers. HW =
buffers need
> > > + * strict IOVA alignment.
> > > + */
> > > +struct mlx5st_device {
> >
> > Can we do s/mlx5st/mlx5/ on the series?
>
> No, I don't want to do this. Since it is in tree I want to reserve the
> mlx5_ prefix only for the main driver. The driver is huge, I do not
> want to harm or confuse grep - that team will get mad.

git-grep can be scoped to directories, but ok let's keep mlx5st to
avoid disrupting anyone's workflow.
