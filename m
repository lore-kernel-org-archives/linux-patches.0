Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8E140627F
	for <patches@lists.linux.dev>; Tue, 28 Apr 2026 18:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777400834; cv=none; b=KwNyxjuQr2a51tcazuji/jKXKCw/Hyzqx9DOz0WFnJh2zKfhPytIkREQAH9hsj9GDtwBAJ3IMS3+qr833+c9nKVsvm3aXecsOjTdAbrnCB2P0qpjixUpAMK5TEywFWR3XZFL8yvg1pGn9JZdNvirBnmwZCMYF/KRezjZXRWadjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777400834; c=relaxed/simple;
	bh=Qgs4VKe6aa4WyJBdEkeJSC4dGYTWRhPAU+v9n/d2wxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I91dJGgBSD9+aCG3ma5ZsiY8OTnq/GS3aUVfl/6Wo13p4a4pSe//ZsPdZPZ5bapXnWPtkrYi1n7p8E8vxWhE0jr2KAymJEA7dSSrTw3A1PBo+8byKN6T61k50ch+1Q+Dhi3etuNbNTOo05OIj0fhRtn1lMcqIo2Tt3SYigoJB08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nYrk+WnV; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nYrk+WnV"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35da2d35eccso8129258a91.0
        for <patches@lists.linux.dev>; Tue, 28 Apr 2026 11:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777400833; x=1778005633; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0UGTjzT1o8VOQ2X8VCxDZk9yTiALK5gtuUuVtTpZzQ=;
        b=nYrk+WnVJN1cLyD9qOm90f3cmNqcYl0LcRLo2HuO4byGmR4tH/LuuHrDAVvaxSorYg
         CTFBoVn+7/pzAAoT+axfKpz1xfVgA2YauEdCyQS+9AvuSEfsCsO8XFI4bQPerfLATxIa
         yrPkJ6nYJX35nscK5UtS60P4knUZLPqMFSgbu7CWxA8ey1x37AipLaCJZ8KEzVmpSwcP
         dVgWAcah9XGAumZYAcoxVrydEBUwuDBIlzwzlNrAY2k1kAbO838iIdqtm/Xs+hYuhGKr
         YR/G/PxX8wBk1tNKv+U5OZBi4UO/lrU9/U46qYe8bnhx8wDEh9GcJxNhFX1wf748Lr6y
         xnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777400833; x=1778005633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y0UGTjzT1o8VOQ2X8VCxDZk9yTiALK5gtuUuVtTpZzQ=;
        b=B2aVAhfTuvsvuRp6lHSC0ZKq06jXwaVVsSA54YwAJrCpYbLPJ6WQyj29M1H0RxXiMP
         McReGOzzm7SloGfUTFvPy+mxffHhSm+qiOul8aX6D7LQpufHp/b5IZqoetUr44lJlIxL
         a/I8b1lxcw0FiWrql1d3Kjst7k8bTiyCiDhVwdDqZlaXCqUcHS9OsGGKLgPs/JHTbygn
         yn7i+shbCn/HpCQyO4AFR01OjSRYseQ31RwEppllqH24t3PaBkoyKV27Y1zZtSIiKecn
         Bq443maFeW6qqmziIfNF2TXRSEZ399MZ4qXxNwgwqsPBRtqhi60+tQq4rzFOzMXV29Qg
         3WoQ==
X-Forwarded-Encrypted: i=1; AFNElJ/lAdXF+NtIlgbmgwZym4rnqtZkzZXujtdWyySw8AH3SZMpCUkjA+j46CXh0xHS43PlvWr6OST/@lists.linux.dev
X-Gm-Message-State: AOJu0YzQnjMNSbFKMKRyuH1INdafNGAiWBjdqBu0rj2l9GZlOvHzj/zD
	3DalJIrzLJkVtZoap8NSrOztXRgNa1cZMB12W5NOa2/30mSxrwu0ec0FZsph75CxfA==
X-Gm-Gg: AeBDiesLKwem9Gmk1tTsRDuvo3puJLoOzmif/YTIM3ktOYUyk6H8UY2M+aXevr5s+9t
	KcBRLqVfiJx8Ka6nKnFMdQ9wwZzuVVwwKJSXvP5tHrVV5t48CTZei7yS4y6aWBdgZdZ3qda2p6y
	GBgURV3Kepc3lAjUTcUt9riYyrr7PaI8SN0cFnHS7ecMiqrDfE63Re/mmKwIBdhKogx5rI9d+qq
	sZHEVCy83MfYRRE+9ebmFiAdYGRj9csV3v6dP+emjZjY716HfM08TI8Xoal0fFZYIhYvIB7qu9d
	pjnAobjwpgyiFbGjee8UvUD/gskpoD4r05mksHrb3kP5nkRtQicNUKaap/6MQeudoGPlAgTYkMU
	uFUTu5AicoBOzM4xXS/cCK1WKV+AZX9P3iDjXiFhw5RPkxr6+iHQS8nFrDI/DKtKPaj/23pBEug
	pXVp6KgG97QS3s2O3DBNJuTMtoj2zd4us1KotlXCHSld/zqMx3BqmZLAkfJkkni+s0toe6UCAnP
	kWBcQ==
X-Received: by 2002:a17:90b:268f:b0:359:87a8:e65c with SMTP id 98e67ed59e1d1-3649202ea13mr4377890a91.17.1777400832390;
        Tue, 28 Apr 2026 11:27:12 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364a119e0b4sm76522a91.5.2026.04.28.11.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 11:27:11 -0700 (PDT)
Date: Tue, 28 Apr 2026 18:27:06 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	patches@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH] vfio: selftests: Fix out-of-tree build with make O=
Message-ID: <afD7-rg58XvqRJpD@google.com>
References: <0-v1-79f29139180b+8e-vfio_st_make_o_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-79f29139180b+8e-vfio_st_make_o_jgg@nvidia.com>

On 2026-04-27 08:07 PM, Jason Gunthorpe wrote:
> The test programs are compiled via a static pattern rule that requires
> intermediate .o files:
> 
>   $(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
> 
> After lib.mk prefixes TEST_GEN_PROGS with $(OUTPUT), this creates
> dependencies on .o files in the output directory (e.g.
> $(OUTPUT)/vfio_dma_mapping_test.o). However, there is no rule to compile
> these .o files from the source directory .c files when OUTPUT differs
> from the source directory.
> 
> Add an explicit chain of pattern rules:
>   $(OUTPUT)/% -> $(OUTPUT)/%.o -> %.c
> 
> Following the same pattern already used in libvfio.mk for the library
> objects.
> 
> Fixes: 19faf6fd969c ("vfio: selftests: Add a helper library for VFIO selftests")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  tools/testing/selftests/vfio/Makefile | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
> index 40165d087a0bc4..81c3be8298fdc2 100644
> --- a/tools/testing/selftests/vfio/Makefile
> +++ b/tools/testing/selftests/vfio/Makefile
> @@ -27,10 +27,13 @@ CFLAGS += $(EXTRA_CFLAGS)
>  
>  LDFLAGS += -pthread
>  
> -$(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
> +$(TEST_GEN_PROGS): $(OUTPUT)/%: %(OUTPUT)/%.o $(LIBVFIO_O)

Changing this line (with the fix you replied with) is not actually
needed right? I tried the following without it and was able to build:

  $ make OUTPUT=/tmp -C tools/testing/selftests/vfio

$(TEST_GEN_PROGS) has already been prefixed with $(OUTPUT), so %
in the original pattern already included $(OUTPUT).

Is this for readability?

>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
>  
>  TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
> +$(TEST_GEN_PROGS_O): $(OUTPUT)/%.o: %.c
> +	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@

Looking at this commit made me confused how this was even working before
and I learned that make has built-in rules to build .o files that
assumes the .c is in the same directory. I see now that we were reying
on those built-in rules to build $(TEST_GEN_PROGS_O). It makes sense to
have an explicit rule to handle the directory mismatch between .c and
.o.

This also got me thinking it might be a nice cleanup to use the
predefined macros $(COMPILE.c) and $(LINK.c) in these rules instead of
$(CC) $(CFLAGS) ... etc. No need to attach that to this fix though.

> +
>  TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
>  -include $(TEST_DEP_FILES)
>  
> 
> base-commit: 681b35420592a2e072d9759254185e72d2e914c8
> -- 
> 2.43.0
> 
