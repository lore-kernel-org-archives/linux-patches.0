Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314C63D6CD3
	for <patches@lists.linux.dev>; Tue, 11 Aug 2026 18:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786474521; cv=pass; b=YBtB/a2CP9wbVDSTPMwmwzFU5f7GhgP7j4v9CGLxTfO+N7/KoGiKg1lbiIV5onfKSMnfDZ/W/GcIUPEoDplfGplGqSt9q1bATHT8mF7BQnFGgs/yfPCsq823P3UtxC+rpFO0qkTk0YFw7rP1xKlBJB72cuKkgntqvFCJmYmDP54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786474521; c=relaxed/simple;
	bh=PK5DpGIYIZ4Q5mypA8J7nQL3JpavjxnvYneVp4Wv71c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nawyaCgHYJBQry4V/MANYZ3PGbyBIYWRVG1woJfSYMgM9vZZMoXp9uHI3dID/+NBQS4OiQgLSoLlw2ebJukXoV4407hH8KHzMC5/HgLJ7P9x+rXW+zSQGeWxenF/eC9UBdg9s5CdCtubJk/YDVbRdOtqDP+UThDyUvNVQIGlHYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GYID9E3M; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GYID9E3M"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-384930ca5e2so224665a91.3
        for <patches@lists.linux.dev>; Tue, 11 Aug 2026 11:55:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786474519; cv=none;
        d=google.com; s=arc-20260327;
        b=QoYqCzZ9kiBmdviK3f8PdmlNzzb8PPt86Vki2TFgi2vhuCHskIguCqZWEwpRei1UV6
         M+jJu9zbdWUXo3+ORHbW12IQgjfOk8UKbtZDphj9EuFMcBr5YmGmKF4wE8UJDzumfJXQ
         QzMoDZYhiyWqZ+JMgA4RoKQSA+Q+DyNgtpQKcre77Gb8e+pCl4QvaX4jlWi+Lu5Zw2xP
         o1uFNrapFUsh1Z3I8FpmbcmF+KeCyqzWah4AGaitOwvV3P/oHAUPKKeLUupldJW+sQqb
         kVcEzb6wwgEtu7WiV97qwJVA73OUikBNW7Gg9SSP6N5MxWXrhTEM68MS6X6L+dl3c1s/
         Zy4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PK5DpGIYIZ4Q5mypA8J7nQL3JpavjxnvYneVp4Wv71c=;
        fh=3SpTnRtfB/PW3nGd14E198qr7syy3eL8da2ROsfHmzk=;
        b=U2t+ZtLzCFhm5SFLM/gsssJXBu9RbTZtoRZTCHCHNUWAINZfdjtUHUuvPn1cALybMc
         +PhoBPBdv89p9ugI17QE9IrutMpNS/WihVPpSl97ZFPbuYv23Vdkniwj3hyUVg1A+Zzx
         4gtZf5PMRJ7KGPQK8uwD+uP2k4qWjPUEc5LmVNg2UkV23HRAScJNvboezoh1q611Sf1O
         0ddDbnPf9wKZjEZHLQckOYalyvFlpC9Hn2TkbLnG4EAgqoBpEaeB/Mr+RtAEo9D9GQ46
         au4XzKkYAEdDPY2U8x678uwcYZKxUYdD5b5KRN4pidnu+rmY9+XdUm9/XAGmcoRWk3KF
         LRdA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786474519; x=1787079319; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PK5DpGIYIZ4Q5mypA8J7nQL3JpavjxnvYneVp4Wv71c=;
        b=GYID9E3MlQR7nWDGm8bMJouGG1XZ/3dexcUHxBzqO7F9i2dBulksfejWIbNI/BxcVY
         9qRDF+VHXUW0x3anE0kUQjCT3cofMlSoPZVnqvKshRCpPRsrAKI0SG421xEbuUm4JsfC
         EPByYre80OCxBDMP/8sLgo0DdaWtPiMWZbAG1ORmdFmSVNwICMCpnSfxZltzRbFhKKxF
         k07G2hyhObsrmJykUfnN/vDIHWx6WRcCMffQ42RHjbwRXTR3OjgNle97h/C6S+prYGQu
         y4AxbESEa1SjAjL5a4AO9eotfm5VHLNlT8dYcEc53shJqAX5YWn6SAGtk11fTEswOImA
         Ouyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786474519; x=1787079319;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PK5DpGIYIZ4Q5mypA8J7nQL3JpavjxnvYneVp4Wv71c=;
        b=YeauBeJxUrXB74Cm0pV3q/MKFFkJ+hOIALwgbj9UaW7/6ti+oInTLkQOCxIzJg31fc
         3sa7FS5Yv0jYNiEbNM3ca6gCDz3PnNb9oWmqMK+6kckluMnvEIDBqID/kuTFlHDJAiGW
         IhjOrbIqbMxzeKsJf2oilBJTytAH9+tqbkx2hgB2xQ7BxdKV4Q2xSb8iZE1f8fYmgj5S
         hhrlk1vEPyL547uDoFB0M9FBaWgtYFHhOMYnTYxIUm3VVbeg/pbkWOEbN/LXHBPrOCgn
         rOAUVVi7s93KFAdJp272MuMgXM9qIwGxEk6WewQ8yWT9nKYz1v1xnS8sN/J0MAda/0FR
         0Gfg==
X-Forwarded-Encrypted: i=1; AHgh+RruNkPSBVI/V1ZrEjcTBQpYZSKjG69tpcEe3pcnSHz3fhJzjF5d+87wAHF4fP1+NfMK4wqJSTUb@lists.linux.dev
X-Gm-Message-State: AOJu0YyuAovyg44cuXXuSa1rajblS+5cWfkA/OT61QtsM+pf50xXkLNB
	5nct5lbP0l4S5WyEDmOnojU7iCJU9/j+f2b2ip6iHVpjPFFUf1iUPGI03SHX4TgigE3jUfDRD+i
	zJuthc0jWYUAcL3kWQ8iid2DefYWM23FFaTggVofm
X-Gm-Gg: AR+sD10tzXnif5G0SILrgBKzf1Cp+xVUre3/NXyYeAqKQ3sso1oPRBF+zd7TmH6f6pM
	/yCbL6ExrYkTyO+etGo3ShjyBuh9RYoeVSnKXvXxD5eAp3vsCRv36otAbzo0LmeIeaBxkYPwL9P
	fdEr5nrzX/1Olt/mO0U1Pv+akzbp8TWGvQy3sTQQeG7Z06sMjSRKATK3b+uq+BWLePb/jJNbEun
	pLLRckjQVXRt4HPGfP7FwwTOBeE1lhWB4JqXy4lc2cNsrTjWpGaz3ApnCB9q/3FKEBjmm2jXDOa
	/GhBIi1VyRc0rza5E/VrY6HKp3KBiBMqnsyiuqwv7zqA
X-Received: by 2002:a17:90a:ec90:b0:38e:2860:253f with SMTP id
 98e67ed59e1d1-392ec53e6c1mr6200831a91.12.1786474518666; Tue, 11 Aug 2026
 11:55:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com> <20260805183702.GA72896@nvidia.com>
In-Reply-To: <20260805183702.GA72896@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 11 Aug 2026 11:54:50 -0700
X-Gm-Features: AUfX_mzn4PfVgkS4FrNbhoBz42phR-uhV7z36r-0P3XLSgGGUO-8rzrUFVLpZk0
Message-ID: <CALzav=f5oUW+B9RvOyaRGtG=6CX_4g-2Di+obFZ4O6B-chZtAQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] mlx5 support for VFIO self test
To: jgg@ziepe.ca
Cc: Alex Williamson <alex@shazbot.org>, Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev, 
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 5, 2026 at 11:39=E2=80=AFAM <jgg@ziepe.ca> wrote:
>
> On Thu, Jul 16, 2026 at 02:03:16PM -0300, Jason Gunthorpe wrote:
> > Add an mlx5 driver to VFIO self test. This is largely a remix of the
> > existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
> > to issue RDMA WRITE operations which effectively perform memory
> > copies using DMA. Since mlx5 has a stable programming ABI this
> > should work on devices from CX5 to current HW. The device FW must
> > support the QP loopback configuration.
>
> David I was going to respin this to fix the minor nits, do you have
> any more feedback or are we good to merge it ?

Sorry for the delay. This has been on my to-do list, but it keeps
getting preempted.

I will do a pass through it today and make sure there's nothing else
needed in the respin.
