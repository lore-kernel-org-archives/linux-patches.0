Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C971D88DF;
	Wed,  4 Sep 2024 15:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725463162; cv=none; b=INYv4M2s0CEwFBh1IwcnogSduI6vK50g3ysCJr10WrCutgO4g9pGhV34SLzePjPFVOQq81M5cHtHUIq0llj+r7uEmAVg8VnFaGhV8vyx9b7uXO4PaF1oXvpMp6bBsFN30gIg3tcXTFomxZd4hktU2kMTsx8zEaUkIvHAhZUBi3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725463162; c=relaxed/simple;
	bh=8coHPwvf5Ng2yRyTRB+jIoQtYTgqNip0dJ++FwSwyvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gKwUs0C+GSSVfUClDKDNKjOO/pOTHs+HEHbv2wnZneDJ69kYuxAH31KGfLuAOrYzsaAtTOtfpQOKpkUVGf06dn4iU+p1s3hftJknhrTtBrdUX2kNhydgvElewJU+CnSjMDuMDRzvGa/soTYb4e9Vl6cjNnxV4XPCNd25iqC26TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7g87hmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7g87hmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2885C4CEC3;
	Wed,  4 Sep 2024 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725463161;
	bh=8coHPwvf5Ng2yRyTRB+jIoQtYTgqNip0dJ++FwSwyvE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P7g87hmSXEwVWFzKD+oLLYMCHacEirbBApQjYhH9R/iXR5ZgQR4bpZZ4rayZqQhdB
	 Oij9uAGszOPnbNFYoxo9LCg7oixQvQzu/bqcRq6DQSb/ufdJFldIuSE96/aLzMVn5T
	 BJ2Vdl/IlmijRLJhH8c6J+uo2jCS2xdQna15KzxuvETPIa2IZCCYNcr/ObjaaP7Ule
	 Si91ZHL4Ezp0P3tUpc26FFPiVT00bRpken1cojbKIcFQuRItePtEj+pmVJ7SNvNkGF
	 2mVvQdLh8DtOsRq2pR/KgAy3fM6YHO9wGMjEYTbAMcmdNt0YVoAVYkIcrEhK2NK1+t
	 jvnM/OHcwO05A==
Message-ID: <d114d151-950b-49a7-8be5-19c1b8b15d7c@kernel.org>
Date: Thu, 5 Sep 2024 00:19:17 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/3] extcon: axp288: Switch to new Intel CPU model
 defines
To: Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, "H. Peter Anvin" <hpa@zytor.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240903173443.7962-1-tony.luck@intel.com>
 <20240903173443.7962-2-tony.luck@intel.com>
From: Chanwoo Choi <chanwoo@kernel.org>
Content-Language: en-US
In-Reply-To: <20240903173443.7962-2-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

24. 9. 4. 02:34에 Tony Luck 이(가) 쓴 글:
> New CPU #defines encode vendor and family as well as model.
> 
> Link: https://lore.kernel.org/lkml/20240611174016.352953-1-tony.luck@intel.com/
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/extcon-axp288.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-axp288.c b/drivers/extcon/extcon-axp288.c
> index a703a8315634..d3bcbe839c09 100644
> --- a/drivers/extcon/extcon-axp288.c
> +++ b/drivers/extcon/extcon-axp288.c
> @@ -108,7 +108,7 @@ struct axp288_extcon_info {
>  };
>  
>  static const struct x86_cpu_id cherry_trail_cpu_ids[] = {
> -	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	NULL),
> +	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	NULL),
>  	{}
>  };
>  

Applied it.
https://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-next&id=089a6e37c5394bc22d34c0c22b14a31b897b5831

-- 
Best Regards,
Samsung Electronics
Chanwoo Choi

