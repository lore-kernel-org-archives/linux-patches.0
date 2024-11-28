Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0530E45005;
	Thu, 28 Nov 2024 02:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732761525; cv=none; b=fZO01fzRVPPXfyE7y3O0yri4F4QImVU5mVMdB3lHyR5vmckPeKYAj7/KQs4IW+oXZvylQ2kUGwRkOuHWh2lz/VaiIEa8oi1cNjL+B7mxPn36vJhFqVQoYZ2E4IhrOWvJM+mTOoQqeP400AyHI6PdPxYrqQUtphf0URgd9WzXrn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732761525; c=relaxed/simple;
	bh=DhtkhsAf5KEiXr6/yx6hh48ny0Diwr74maMHP+gWSkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G52+kp7rnz0G6B1KN+c21HnShbjlyBx5brLUswkgokKsTNw9SApKQf9bC2uvtBcEKp3hd//lLAzWc6AoqSHvzV1MwaL2A9Grc9wsEOcZ6Ww37+QQbCLBbeFj1Xm6vzbwXDFRdVFOfuWmkiWtzT3LxcCo1yea8TcShv9qpmsCJFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=umXoDWuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umXoDWuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49ABBC4CECC;
	Thu, 28 Nov 2024 02:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732761524;
	bh=DhtkhsAf5KEiXr6/yx6hh48ny0Diwr74maMHP+gWSkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=umXoDWuzT2TWRJDIvuBaoPcL9rqVn2tJJ4YEx6dGXxwXvbhpsBnZmwXM8PBSMQOQr
	 DcUTe+j3K0MR0cuEMKL4Iy7ovyNn1LQ8U0n2c/My5unJOJoq07XUSuolNucu36i8cn
	 zD3FlSUbRkxuKBnHPYO2Fzb4KD99VrmXr266mg5VDM8tNSVyZ/T+1ulQDpVkqpcWju
	 CE9UGDrpP59wTKSA3hQwq8iSBJzmKR44h5t1JuajPNgRiJvnL5hVDOYnYYorY+ixqs
	 Ffoceoj7wjs8dd6ZOmP+TQUDKLNZBM9qurLy0tssoHJOdTilWoPBjdvH0mKTLJwvjr
	 paJ0Fg/QzMCnw==
Date: Wed, 27 Nov 2024 18:38:42 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com,
	petr.pavlu@suse.com, da.gomez@samsung.com,
	linux-modules@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, mmaurer@google.com, arnd@arndb.de,
	deller@gmx.de, song@kernel.org
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
Message-ID: <Z0fXshsZI8J0NhQo@bombadil.infradead.org>
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
 <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
 <Z0eeuCyUGcKgsc5h@bombadil.infradead.org>
 <Z0eqiayuv1w4a_dc@bombadil.infradead.org>
 <CAHk-=wj+imfGvW73XoYn60bAMzRtPfXFqwFTUqBoEq4=u5_oUg@mail.gmail.com>
 <CAK7LNAQyhxPZfpK3hVPtYvCYjad4pTUim5jVsEsuXqefY8KhWQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAQyhxPZfpK3hVPtYvCYjad4pTUim5jVsEsuXqefY8KhWQ@mail.gmail.com>

On Thu, Nov 28, 2024 at 11:09:43AM +0900, Masahiro Yamada wrote:
> diff --git a/lib/tests/module/Makefile b/lib/tests/module/Makefile
> index af5c27b996cb..8cfc4ae600a9 100644
> --- a/lib/tests/module/Makefile
> +++ b/lib/tests/module/Makefile
> @@ -3,13 +3,12 @@ obj-$(CONFIG_TEST_KALLSYMS_B) += test_kallsyms_b.o
>  obj-$(CONFIG_TEST_KALLSYMS_C) += test_kallsyms_c.o
>  obj-$(CONFIG_TEST_KALLSYMS_D) += test_kallsyms_d.o
> 
> -$(obj)/%.c: FORCE
> -       @$(kecho) "  GEN     $@"
> -       $(Q)$(srctree)/lib/tests/module/gen_test_kallsyms.sh $@\
> -               $(CONFIG_TEST_KALLSYMS_NUMSYMS) \
> -               $(CONFIG_TEST_KALLSYMS_SCALE_FACTOR)
> +quiet_cmd_gen_test_kallsyms = GEN     $@
> +      cmd_gen_test_kallsyms = $< $@ \
> +       $(CONFIG_TEST_KALLSYMS_NUMSYMS) \
> +       $(CONFIG_TEST_KALLSYMS_SCALE_FACTOR)
> 
> -clean-files += test_kallsyms_a.c
> -clean-files += test_kallsyms_b.c
> -clean-files += test_kallsyms_c.c
> -clean-files += test_kallsyms_d.c
> +$(obj)/%.c: $(src)/gen_test_kallsyms.sh FORCE

Thanks! We can also just replace the FORCE with $(KCONFIG_CONFIG), no?

  Luis
