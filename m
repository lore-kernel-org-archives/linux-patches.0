Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0980C2D738F;
	Wed, 22 Jul 2026 05:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784696965; cv=none; b=Ow+Zqi3KRucUoJn2rEsgSRoF7nVGiHEbxXgt6/Q0fRLVH0x3Bu/mJg7UlVJFrMWCiXbO1+uhR6f14ktkOMgiPelUhQZp3gNYq9l1EWkR4oiyus3CLjPNv8TxPDfySvYbfly36xEVQrbIENyOOjKB5GxH5SkNBEsV8KUqLsnslME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784696965; c=relaxed/simple;
	bh=nNdg8Ej544spvDaEEf2ZW9klWc2zw0nMsT3QIpou15Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f7uzcsN5XcZwxqFI4qO9/CQkJFMhOaSt4XZJdWS+vsGsvBJrF5gO6sdh4wPjB8SwnMlRIT8c52mrnjXtLveAQRIHpNUi8I+xi9XkvGglIgA6iOS1ESiwe+55pD1yAtRKwbBdjqxOkV0fht9WiyYdhpaXYgnbiWQQa0Y4pAv96UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQKdy3ZC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQKdy3ZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2A61F000E9;
	Wed, 22 Jul 2026 05:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784696963;
	bh=Sp0oBn2A3UJy7GjDdLimRq5Z/3hvzhUwc/AK/Txvgi0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dQKdy3ZCErs8SQhSMBNPNzcGwDugWiuGZAf9pYMFov6Chev8PZ0Kqb6oNwe/tlBiD
	 9YH1DSem8Sb2T0FutRnukw43tSJDRMc4fbemFCJkyew8EdYiPUkGihNm0KCCX3s+89
	 LgkmYm43tpx7Nu/meKsu9hcLE8hVYTqMQFbRtaEtPT9S5T/CEjeuvQnOqKbYcK/o/T
	 Os4JUi2CDaPg+eVOPWh2zzL5du2BtsGSVV6psxL7xXlvwMAWtk2i1eeo9p/U5uwWAr
	 w6USA+Lq4WL0UJnf+txKD8Bfe/+UM/8cqWt6XSe/7CNH88kPbOXMlCw8cGB6lWu/QY
	 7hy4dxHg3dRKg==
Message-ID: <26425ef4-454f-4087-98ec-d045247242d8@kernel.org>
Date: Wed, 22 Jul 2026 07:09:20 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0898/2077] gpib: cb7210: Fix region leak when
 request_irq fails
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Hongling Zeng <zenghongling@kylinos.cn>,
 Sasha Levin <sashal@kernel.org>
References: <20260721152552.646164743@linuxfoundation.org>
 <20260721152614.000907002@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20260721152614.000907002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21. 07. 26, 17:09, Greg Kroah-Hartman wrote:
> 7.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Hongling Zeng <zenghongling@kylinos.cn>
> 
> [ Upstream commit 5ad28496055858166eb2268344c8fda2c26d3561 ]

This was reverted upstream by:
285ecb7d9e1b Revert "gpib: cb7210: Fix region leak when request_irq fails"

> When request_irq() fails, the region allocated by request_region()
> is not released. Fix this by calling release_region() before returning.
> 
>    Smatch warning:
>      drivers/gpib/cb7210/cb7210.c:1068 cb_isa_attach() warn: 'config->ibbase'
>    from __request_region() not released on lines: 1064.
> 
> Fixes: 82e3508046f9 ("staging: gpib: cb7210 console messaging cleanup")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> Link: https://patch.msgid.link/20260503093036.283546-1-zenghongling@kylinos.cn
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpib/cb7210/cb7210.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpib/cb7210/cb7210.c b/drivers/gpib/cb7210/cb7210.c
> index 6dd8637c5964b3..05058bf2cd50bc 100644
> --- a/drivers/gpib/cb7210/cb7210.c
> +++ b/drivers/gpib/cb7210/cb7210.c
> @@ -1062,6 +1062,7 @@ static int cb_isa_attach(struct gpib_board *board, const struct gpib_board_confi
>   	// install interrupt handler
>   	if (request_irq(config->ibirq, cb7210_interrupt, isr_flags, DRV_NAME, board)) {
>   		dev_err(board->gpib_dev, "failed to obtain IRQ %d\n", config->ibirq);
> +		release_region(nec7210_iobase(cb_priv), cb7210_iosize);
>   		return -EBUSY;
>   	}
>   	cb_priv->irq = config->ibirq;

-- 
js
suse labs

