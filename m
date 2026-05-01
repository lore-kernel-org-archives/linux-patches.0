Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B34E1A08A3
	for <patches@lists.linux.dev>; Fri,  1 May 2026 03:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777604504; cv=none; b=bWWZdxzoLGi++3yyREVF8EoRuasLnphqeieBBCyApXBwgVSDES18K2kDhcb3+gnpWvEfcSPNujjYPsxzCMAlc4oHyzYkOVmlrPRxTevhBfGIBt0JOGD7QXAJ26wypTuRTei9Kun1REqBRpqFZi3S3d2lP7GdEyY/jcmU6KFcons=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777604504; c=relaxed/simple;
	bh=2zdWrY87j65xBnMHItwSK4ZtkUkSeYSCDdievMvYSgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BDA5z9XMYZpjiqYoRvkAQ7IMZtWvcq+VTcT3VoXsXdc/Ke7TpWX9ThZfUCWLvS/5kg5YBsg3soDg8xXoa+rp77duQaW5XsgN8gMVUJp0WomL5DG4en83zePdwmwQSOuavdLV+62Vp2hty16QtKZBg1Rv4rPZ8lWKhSfpHTrmhrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PriSyPY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PriSyPY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41375C2BCF4
	for <patches@lists.linux.dev>; Fri,  1 May 2026 03:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777604504;
	bh=2zdWrY87j65xBnMHItwSK4ZtkUkSeYSCDdievMvYSgY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PriSyPY4X/eBn26UcTwITTvyTHH1QbQ9BM0CLAF3bLggaGp8y3hAtJVYLmuGPR2SI
	 50T+CRqvvFwOF6r9W0FXLP8U1RUtEkBJ5I0Fs0v7nT+pX1ZqKZuNVF+Bj33ARYFptY
	 7dwib5o5KJ9Jj/Y3wHl57VNXvg0eqzU4vGY6j8FAkmzcpoQEp3pC36cGFnh6yTO64c
	 /LvyEVZpH+iMJIpgTAzDe1P5KcxiZq1eqyidyPiMuZr+dxAUl3wpGcBDyf4qoT0b5R
	 yaO0F1ROO2vEavQeirReZdM1jPrli5venvQVY480sRzqxbUvKXAz9AYtrXunwgTXt+
	 zfeoEI3qsXWiQ==
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-65c1ba7eeb6so1285075d50.1
        for <patches@lists.linux.dev>; Thu, 30 Apr 2026 20:01:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9j2/OmVNHY86Qg+V2t1RFQAzhU8keEfgeYCGrWULRr9POY/3l3z3Rfs7sw7HKyYEVcC9Ab6X1Y@lists.linux.dev
X-Gm-Message-State: AOJu0Yzkgmmm0FZMj+QtRcT5oPBAjekRd4ujvm3eeG4dVcqInTiy8iHt
	FZE5I2wFgBEwdvbtvkQqpvFZ0l/oLSkvAZwNJJIlXeBYey1iFwuPl6biI0A38MuSHJEioAPDTcI
	UBsS0F7C7Fkqci2W3VyVBc7t9eZjy/J3QucF/7oILwg==
X-Received: by 2002:a05:690e:1381:b0:658:d26:d8cf with SMTP id
 956f58d0204a3-65c18c85c83mr4753063d50.23.1777604503446; Thu, 30 Apr 2026
 20:01:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260430232851.236666-1-wnliu@google.com> <20260501000059.262516-1-wnliu@google.com>
In-Reply-To: <20260501000059.262516-1-wnliu@google.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 30 Apr 2026 20:01:32 -0700
X-Gmail-Original-Message-ID: <CACePvbWJTk-dTuOP6owxiUkh6HfRp7AWGW9KMJVFtdABmw==4w@mail.gmail.com>
X-Gm-Features: AVHnY4KS8noUTYIFJB1xZmFbA88r3mKCmhaLIyZbJuxdfsmwjkBoTi4_Qy9-6do
Message-ID: <CACePvbWJTk-dTuOP6owxiUkh6HfRp7AWGW9KMJVFtdABmw==4w@mail.gmail.com>
Subject: Re: [PATCH] iommu/amd: Fix precedence order in set_dte_passthrough()
To: Weinan Liu <wnliu@google.com>
Cc: iommu@lists.linux.dev, jgg@nvidia.com, joro@8bytes.org, 
	patches@lists.linux.dev, robin.murphy@arm.com, santosh.shukla@amd.com, 
	stable@vger.kernel.org, suravee.suthikulpanit@amd.com, vasant.hegde@amd.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 5:01=E2=80=AFPM Weinan Liu <wnliu@google.com> wrote=
:
>
> Bitwise OR | operator has a higher precedence than the ternary ?:
> operatior. It will be incorrectly evaluated as:
>
> new->data[1] |=3D (FIELD_PREP(...) | dev_data->ats_enabled) ? DTE_FLAG_IO=
TLB : 0;
>
> Wrap the conditional operation in parentheses to enforce the
> correct evaluation order.
>
> Fixes: 93eee2a49c1b ("iommu/amd: Refactor logic to program the host page =
table in DTE")
> Cc: stable@vger.kernel.org # v7.0.*
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Weinan Liu <wnliu@google.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris
