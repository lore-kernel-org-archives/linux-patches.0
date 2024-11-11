Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253C68F77;
	Mon, 11 Nov 2024 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731346328; cv=none; b=d1icd7k3JgtaAluYeh7mb0j+/XFsqcI5CDeQORpTK2NvyeDxuzmHCAvAFJ5m62kmNIX5DuZwxm4USB273+ZoLMmlqtse8ttABNsmOHdfTkVN5/GWt8duwQUiz9EKvDNKHTNJ9FcN7ncv9/1k4lkjtFSQZb5iZfWn+MIwywGi388=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731346328; c=relaxed/simple;
	bh=R1OxGtW1OXn6UnWHatNz7pta1Hc/mAoMIINg5IcSwIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W6FewgJtBZVlFeSNQqrAdTaOZfZMjiBGioi2qX7ZVYIXmqdIFuZx33PCdw3/pW3ZaV/ziXZ4LxBDac73y8ujX0qk9swhJYG8libS5AkiExkGLYTlLH0ENEOIysKxEQLZNVbSEPPT+OASPdROTML77mJ2sI8H3F6xWmQlFGg0GfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=mIveQqah; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="mIveQqah"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 108F88932A;
	Mon, 11 Nov 2024 18:32:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1731346324;
	bh=m+Eyb5nA9rP5UvCqe5BJXcKC8MFjYJaJOoHKui5tOZc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mIveQqahnM5ROin2S8Hd9hqJT92YGDjyviAFuRNsqftCOxP0Ha/b5in09JCXIVOba
	 o5pr2rda+lX8TFA8UPLPUiniuAS3I0t+73b6DwLH7uA8XbumIYrGRTQrkMtxrEjV9n
	 ESF5hZEiWz7sZ+y+KSZL5ykZNFTCE18BNkAzcfWplnHn+1Bgk6WqKHHrzM7zgqqzUu
	 1mpDzt4VuXtPZJqKqHHwKyKvpm7dUdctaj6XqKO0KEBSOtXEoeTAxuPkLB+ut55QJD
	 yNJTvZYE2A8KkZoX46qhtPe3nxOT+heUkH63krZ/A0ahUQKAh3Q6mopMqzHfMhKqqX
	 QQSCs4dSCPs4w==
Message-ID: <781bff37-975d-418e-9ea1-ecb3deb16612@denx.de>
Date: Mon, 11 Nov 2024 17:18:12 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Input: ads7846 - Increase xfer array size in 'struct
 ser_req'
To: Nathan Chancellor <nathan@kernel.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
References: <20241111-input-ads7846-increase-xfer-array-size-v1-1-06cd92e9f20f@kernel.org>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <20241111-input-ads7846-increase-xfer-array-size-v1-1-06cd92e9f20f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 11/11/24 4:09 PM, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y, trimmed for brevity):
> 
>    drivers/input/touchscreen/ads7846.c:412:2: error: array index 6 is past the end of the array (that has type 'struct spi_transfer[6]') [-Werror,-Warray-bounds]
>      412 |         req->xfer[6].tx_buf = &req->scratch;
>          |         ^         ~
>    ...
>    drivers/input/touchscreen/ads7846.c:416:2: error: array index 7 is past the end of the array (that has type 'struct spi_transfer[6]') [-Werror,-Warray-bounds]
>      416 |         req->xfer[7].rx_buf = &req->scratch;
>          |         ^         ~
>    drivers/input/touchscreen/ads7846.c:334:2: note: array 'xfer' declared here
>      334 |         struct spi_transfer     xfer[6];
>          |         ^
> 
> Increase the size of xfer in 'struct ser_req' to ensure that there is
> enough space for all necessary members and there are no out of bounds
> accesses, clearing up the warning.
> 
> Fixes: 781a07da9bb9 ("Input: ads7846 - add dummy command register clearing cycle")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/input/touchscreen/ads7846.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
> index f7bc0a3e56d86932823b6bc0dcd6bcd8e1b9b5c2..7b3711a3597c86f18c45d040f73bef884ec3c4aa 100644
> --- a/drivers/input/touchscreen/ads7846.c
> +++ b/drivers/input/touchscreen/ads7846.c
> @@ -331,7 +331,7 @@ struct ser_req {
>   	u8			ref_off;
>   	u16			scratch;
>   	struct spi_message	msg;
> -	struct spi_transfer	xfer[6];
> +	struct spi_transfer	xfer[8];
Sigh ...

Reviewed-by: Marek Vasut <marex@denx.de>

Thank you
