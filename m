Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B1B1AA1DF;
	Wed,  4 Dec 2024 10:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733306438; cv=none; b=jynTsEcG3hDuD+bcV4UDfHHSKHeLXXMA4WyMxNNgRVjCwBcArbEZ2S0NE19d7GE18W4SPvgKgdzXniF951VkzDpcwpx+GWfXIBG0nSLizKHCeNNS9E0OTZtickiYlrRHWQqfGcbsxxGRwNfbgUt2RalSmpS23r5wfodlh+Kd/fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733306438; c=relaxed/simple;
	bh=riMj8mK85ro6K5wSxmm0vidWnb2YepUy9TgXyoFozoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BR5dJC5y7a1DXiJK83wbnpnUKvgf4QgXuKEZuaWtJ/3Z5KBLFadZzV2UydADrumxy+8l9ouIR0/WWNEOOtN+wiTPFzQzfnaQOa71tplLL1bSfF/n063vdUmafMsBj8ijj6i8lrNNXzhe2YL8HfPmXASeU20x6JbAPuYQBdtR2uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTF/oyWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTF/oyWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBD1C4CED1;
	Wed,  4 Dec 2024 10:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733306437;
	bh=riMj8mK85ro6K5wSxmm0vidWnb2YepUy9TgXyoFozoQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KTF/oyWYSPr1M6eR/SzqkCgoYWnEa+98RCAT95fpSr6vpFbmAGjLcRA7bfHhnw7w+
	 votcOJ+7f/sbdRp266BEn34HoMvRwDcXBWhYE17Ay/2b1dCabti2cFx5UhxP1D7eS1
	 EKB4qJG9HCrbjdI5FyOp9jYz1ihaZIRXvzkQeICKe7XTN9qXERF0n5MaJ3H73JpZCM
	 b2iezu2yY8/dQkLC701MKTMm5HMXlkyKH47vVXDbz1P2M9BGFsH5IOBTOv97iT3SXH
	 Eji9RbUleGqDei5YFRfUlnmW9p8otFyUeJrNoItBIxobgk0UREJkbgyHTgDeq4tphN
	 z20RQjuBuRJLQ==
Message-ID: <2a720dd0-56a0-4781-81d3-118368613792@kernel.org>
Date: Wed, 4 Dec 2024 11:00:34 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 043/826] crypto: powerpc/p10-aes-gcm - Register
 modules as SIMD
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Danny Tsen <dtsen@linux.ibm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Sasha Levin <sashal@kernel.org>
References: <20241203144743.428732212@linuxfoundation.org>
 <20241203144745.143525056@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20241203144745.143525056@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 03. 12. 24, 15:36, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Danny Tsen <dtsen@linux.ibm.com>
> 
> [ Upstream commit c954b252dee956d33ee59f594710af28fb3037d9 ]
> 
> This patch is to fix an issue when simd is not usable that data mismatch
> may occur. The fix is to register algs as SIMD modules so that the
> algorithm is excecuted when SIMD instructions is usable.  Called
> gcm_update() to generate the final digest if needed.
> 
> A new module rfc4106(gcm(aes)) is also added.
> 
> Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitched implementation")
> 
> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/powerpc/crypto/aes-gcm-p10-glue.c | 141 +++++++++++++++++++++----
>   1 file changed, 118 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
> index f66ad56e765f0..4a029d2fe06ce 100644
> --- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
> +++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
...
> @@ -281,6 +295,7 @@ static int p10_aes_gcm_crypt(struct aead_request *req, int enc)
>   
>   	/* Finalize hash */
>   	vsx_begin();
> +	gcm_update(gctx->iv, hash->Htable);

Now I get:
ERROR: modpost: "gcm_update" [arch/powerpc/crypto/aes-gcm-p10-crypto.ko] 
undefined!

Only this:
commit 7aa747edcb266490f93651dd749c69b7eb8541d9
Author: Danny Tsen <dtsen@linux.ibm.com>
Date:   Mon Sep 23 09:30:38 2024 -0400

     crypto: powerpc/p10-aes-gcm - Re-write AES/GCM stitched implementation



added that function...

thanks,
-- 
js
suse labs

