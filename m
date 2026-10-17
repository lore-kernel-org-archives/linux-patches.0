Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE26941DEEC;
	Sat, 17 Oct 2026 19:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792266355; cv=none; b=HTcET/fE3+YUEZ02efyUdKx8y5mZZzVN9lgo5su+O6lxJ9WeWOP92Lr4ljglAvgcEnPFF5whOmI/qL65ZG/gRNZY8c+gtUUQ0Egq51iLLqPG/2C4/ZS+3wQGZK85AjZqZqHVfzqM8uvQjPYzgeVBetk3Nm6dvlpWVHBhFG5/sSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792266355; c=relaxed/simple;
	bh=wWLDOJdrfIDfiLHhWX4LWDsIkkOm+x5wPTFgpcAbCbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBMIFJmfRuqlOHNth5R1HyCn3Y2FOk8uGYTdX8FiLk+7F/avonrSh8FX+uK1SXRSewNx7yoaaQYpXzHOPayJDzt8HqpWQrF7Hjp7K+ixp03N3eVjXo1AGYbzfUInz6a8KZtTaMix7YyunVIAse/o5RE2MFB41U4g8xv/baHde9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kU81wk70; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kU81wk70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BD61F000C4;
	Sat, 17 Oct 2026 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792266353;
	bh=ITJ6t2fZVc0gHUZydBoqsFaY4joEqY86BVsirSkhtKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kU81wk70kECsQgR0a9kXHPpTa3dFf+0cL1ufffspnWGRe8ikpP2d2YZYhDJwb3/Fd
	 Yebz3diQ0f0OrteRP7skmgCpl5Yx2NDToI9HG0zt/Cg2fTy9qAwBkm/8hej3hdpeI1
	 W7TsEkW0pduFrZxkG8NVgLvGJ9lSlwp7B3RVAEIsyYMbfY6Vpu0L9FPBNS6ufHOrCe
	 HtI33lomydjtRizGXG5+axgOf55U5zpWwaVGgVnP2TOEctHFv27gBxCcyXvu45HQpk
	 wcAeq/wUicL8FwTAsAt06GoINGHS9/ICBwSyYsGMmpFrN00P6aEAeRZ/YtqnMySaT2
	 0aT1tdsC9X+bA==
Date: Sat, 17 Oct 2026 12:45:48 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Kees Cook <kees@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 696/869] kcfi: Rename CONFIG_CFI_CLANG to CONFIG_CFI
Message-ID: <20261017194548.GA318740@ax162>
References: <20261017160036.979869304@linuxfoundation.org>
 <20261017160054.817469217@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017160054.817469217@linuxfoundation.org>

On Sat, Oct 17, 2026 at 05:58:57PM +0200, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kees Cook <kees@kernel.org>
> 
> [ Upstream commit 23ef9d439769d5f35353650e771c63d13824235b ]
> 
> The kernel's CFI implementation uses the KCFI ABI specifically, and is
> not strictly tied to a particular compiler. In preparation for GCC
> supporting KCFI, rename CONFIG_CFI_CLANG to CONFIG_CFI (along with
> associated options).
> 
> Use new "transitional" Kconfig option for old CONFIG_CFI_CLANG that will
> enable CONFIG_CFI during olddefconfig.
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Link: https://lore.kernel.org/r/20250923213422.1105654-3-kees@kernel.org
> Signed-off-by: Kees Cook <kees@kernel.org>
> 
> [ Adapted to this tree: the kconfig here has no "transitional" keyword, so
>   the CFI_CLANG compat symbol is omitted; re-applied the rename on top of the local
>   contents of the conflicting files, converted the remaining
>   CONFIG_CFI_CLANG users (riscv cfi.c, longest_symbol kunit comment),
>   and dropped the tools/ cfi_types.h hunk as that file is absent here. ]
> 
> Stable-dep-of: 52fb1756ea1d ("riscv, bpf: Fix kernel stack corruption in tailcall with CFI")

I object to this being backported in its current form, especially as a
"dependency" of the listed change... The transitional keyword is very
much needed for this change to avoid silently disabling the feature
across olddefconfig. Either backport it as well or just do the simple
thing and properly adjust 52fb1756ea1d for trees that do not contain
23ef9d43976:

  $ git format-patch --stdout -1 52fb1756ea1d | sed 's;(CONFIG_CFI);(CONFIG_CFI_CLANG);g' | git am

-- 
Cheers,
Nathan
