Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE9D313E00
	for <patches@lists.linux.dev>; Mon,  5 Jan 2026 10:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767609527; cv=none; b=VXJqY1hesbg+XoVm+5uQOJ4OWsbV0lMvF8MJjjYADWIcO/rGCL5fKsro1sgIBEDNch4oHE5a+PG/Vb1irfnAkSXgrc7iijxbICulZkPS3OlvW9AgbNN93Jaajku8GcOaOF5It9KodXMpknxCOFHIkJGUIN6/EwwczwCrWEe3K8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767609527; c=relaxed/simple;
	bh=KXLosAKj9WTZoqxb3cLCJTfmO0KCMCIscavgasNNB2Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ad5k9Dv2CzplUSJTpb6Dz1EyfB/4bykZaPPOVH5XitUNgc2rfGn7h17vsRyP26XfGjEwoZP1c1j/tYp/Yagbb7MGqXmIKGd3XCR2rWuUBpIgvuXYFPr18rT150zNFe2GN5XO/N5eN/C0tTWwy7C3RIPF/Ok7W1E8tjgiayGzJJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UPC7zf0z; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UPC7zf0z"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64b8b5410a1so16138974a12.2
        for <patches@lists.linux.dev>; Mon, 05 Jan 2026 02:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767609524; x=1768214324; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rpr1WOrht6j6ORsQatZtyLhRtfXLJi3Q8MSwGacBmmE=;
        b=UPC7zf0zHbPdJXtOEfV0FvN4rFkFxEDcuP9jy3xMhYGpqHzcPX8H5IdqWM7h1Y/y/p
         LAvxkvBhWSIDCtxy/OZf+CHZf+bgrVyJlcIMHgTTZlV7CBErSpzmbaBkLRRkScsfn6ET
         dY0c6WJpvOcS6ZLlxfIwFyqmBqmCpx5fzkQPehe8zbQ4edeozVJVamn3JPCriq0Rdqcl
         uA6+M883T/W71bRIoA0PuYR7U0Pp5roIzMYdohW514jownYuK/qLm8DNR3FjqJC1cF2e
         qgOAsKiGw/8tE/yiPPCxsQZYl644JLZsF9wpm5hOrdM1FYnbGpcO0GvAG3nArJAIAQ5Q
         IGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767609524; x=1768214324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rpr1WOrht6j6ORsQatZtyLhRtfXLJi3Q8MSwGacBmmE=;
        b=MJ3KbFJVSjzQ6qVlCTQ/EZJ9IXsSmza5kAE0HJ2wZThx8BBlHbqTdrsIPS8H6WSDdA
         0LcFot/PkGlAWZviVIBYYAGCWMuG0UV0ydXtz5WbuL7YJnwkKIhxlNF6GL7brnYiDP9s
         3nSF4c0Gxl34kVCemJOENufOw7HeQfvFD4WIZq6lTtioMxhf+jL72B52RfL4k31qnkzm
         Mq/rfYFZlzmyDJZdC++2RMdKIkR5BsHJgq1+5jZR2eC3n2KWj2on/GMde7icwjFYGPFR
         I1eVkz+5Mw/+RHfGM+4kmvjmrLnQfb1GMx2vAJxLsGeM9ts1l79dvC/kMDFQLMLvjDKI
         ZYCA==
X-Forwarded-Encrypted: i=1; AJvYcCV+oAhI7+jkFi2ltacFRnQis8bk5nX0DA8wXesu8OEwcy2mr7xRUUeS6AHbc3+7AlfD46paAU3H@lists.linux.dev
X-Gm-Message-State: AOJu0YzJ4gw5bjuFrSLqu6gWaYU8I1pGp5QgdUw4BMiQjuDMPOiTu1II
	Oj5hkm3wAvGnU4VCXx/bkNvFZqFZ8nQHusd6aHQKLoTlr77w84DJEdfGei2Uy5OBK0VQ2TpR5rn
	C6lOXkKX1ozE/iQvGgNSuGTVRA8YfCZ8=
X-Gm-Gg: AY/fxX6QBBEJC7VOBLMj57B9j6JtBkcvbhyYoym4PnZxg7phYTcLztmK3OJsVFSQM3K
	OLGTdOMvH4ZdJpcGpNUmU2dXs/ewiL+8sGjOLUR9GM8lMVB1Fk7KnLim69hGRMdbzpi2YBK92S8
	O+gfwFEADYQcJ3O/C1LrPz5iclgHY3T8M1Rtekiz9rZcQMDt1refoR60ORq+lY6KVhugIKxXT96
	QHACzcnSxNW7xmSplags6ro0JJYr8V1Xymlv/vYKwmk+livkTo11fGxwwWid1ZNA180Yqsk
X-Google-Smtp-Source: AGHT+IHve9mtUuYnBvwRtwl+XG1rrtZF7lTbS5cmb10zuaOisWC6Q5wRw7gN87SXZ2xj5LiVrwPD92wuBLz5gGcL/fA=
X-Received: by 2002:a05:6402:51c9:b0:649:b200:afe9 with SMTP id
 4fb4d7f45d1cf-64b8edd8b54mr44168355a12.27.1767609524051; Mon, 05 Jan 2026
 02:38:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251228063440.2623595-1-safinaskar@gmail.com> <20251228063440.2623595-2-safinaskar@gmail.com>
In-Reply-To: <20251228063440.2623595-2-safinaskar@gmail.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Mon, 5 Jan 2026 11:38:32 +0100
X-Gm-Features: AQt7F2oW0pJ6x8V2KE_T8rhdE4-ywJ_uvZca_rX5x6NdgmoMtVTx5Rb8XUCp2AM
Message-ID: <CA+=Fv5Ra7fFTd2wA77iM_6X7NooApfoMJX5z1j60cXex_uxm7w@mail.gmail.com>
Subject: Re: [PATCH 1/1] alpha: trivial: remove ^L chars
To: Askar Safin <safinaskar@gmail.com>
Cc: Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	linux-alpha@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 28, 2025 at 7:35=E2=80=AFAM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> Remove ^L (a. k. a. \f a. k. a. form feed a. k. a. \x0c) from arch/alpha.
> I'm attempting to write my own tool for parsing kernel code.
> And these characters complicate this without giving any benefits.
>
> Signed-off-by: Askar Safin <safinaskar@gmail.com>
> ---
>  arch/alpha/kernel/core_cia.c      |  6 ++---
>  arch/alpha/kernel/core_irongate.c |  2 +-
>  arch/alpha/kernel/core_marvel.c   | 18 +++++++--------
>  arch/alpha/kernel/core_mcpcia.c   |  4 ++--
>  arch/alpha/kernel/core_polaris.c  |  2 +-
>  arch/alpha/kernel/core_t2.c       |  2 +-
>  arch/alpha/kernel/core_titan.c    | 10 ++++----
>  arch/alpha/kernel/core_tsunami.c  |  4 ++--
>  arch/alpha/kernel/err_common.c    |  4 ++--
>  arch/alpha/kernel/err_titan.c     |  2 +-
>  arch/alpha/kernel/pci_iommu.c     |  4 ++--
>  arch/alpha/kernel/smc37c669.c     | 38 +++++++++++++++----------------
>  arch/alpha/kernel/sys_marvel.c    |  4 ++--
>  arch/alpha/kernel/sys_titan.c     |  8 +++----
>  arch/alpha/kernel/time.c          | 10 ++++----
>  15 files changed, 59 insertions(+), 59 deletions(-)
>

Nice cleanup work.

For a v2, please consider adjusting the commit message rationale away from
personal tooling and towards general readability and editor/tool compatibil=
ity.
Otherwise this looks fine to me.

Magnus
