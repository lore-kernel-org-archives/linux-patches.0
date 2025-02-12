Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2285202C4A
	for <patches@lists.linux.dev>; Wed, 12 Feb 2025 20:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393925; cv=none; b=NigFJlIjYM712jDged5KwMqdIUSfiAyZyMeaVAWpMuvnCITuPyhdhifRp/qpZglmPnYrsHO0tm2Z+xeoLQFdz3nePKMYdIsschiCLQ6CHGtBB4od38sd7m6dg+PSDb1q1XUQaAo23/yS6tay/ZjOhEcMsqk7Dj/EGYKwYTOF97o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393925; c=relaxed/simple;
	bh=fvwn4DcfeuVU3pip0oOfJYQ72oh9YToQYowTNGciXVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DD9ndfx/+yD9KwUVCDFclVXaXqqtkzo5xol7cbi2aVi1AO1j7WIVshfcAmrsuXoeOP4wUvzcKsva2OFk2x2JC7hIVOgZJx52EGXSL9LKdsaT3j6p+BPLgv6iLdGEYOpPDq0CNI2hBhoOPcwS+KzZSnZQcFw61pWWjeiO4H9oQjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XWdBCsNe; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XWdBCsNe"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YtVz60NYqzlgTxf;
	Wed, 12 Feb 2025 20:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739393918; x=1741985919; bh=2z6lVmeEQmsJJVxbjmRrfpZw
	mOOkkfHOmfNeUYVP6qg=; b=XWdBCsNeeFoaStfe/spE1NEm9nN6CARYIQlkaPhh
	d0IoRjf2RYTL55H4XxuptPkPXgXx8ZpMaSecG4dIKmZoG4QkvwYI9DK3dlxLbWaO
	xEB6f0fSzOTSBLiZskoF/ivvvEo4BiinfFEd4svD3pOgCev8RigZ16LqXIupkmmr
	v/cVRo6j7K5wIGLcsoPN6vD3Q5kEvKLxfkICg6oJE2Mq9xBOnFA1tWeBVkviYWUa
	NdlS4yQFs3QXQhZ3k1wONyHu/9bQdaBrykLFg2OvlpkvM2KCMOgeBubJxvIjvih4
	GVuyBKPcFtKX+fFKQvPeUi4lCfk3Kf9lTRdFhbvwFFZ7mA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nvkabZPpXh8Q; Wed, 12 Feb 2025 20:58:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YtVz139pbzlgTwc;
	Wed, 12 Feb 2025 20:58:37 +0000 (UTC)
Message-ID: <2e6ea8bc-6e9a-4434-8ffb-ec16ead86df4@acm.org>
Date: Wed, 12 Feb 2025 12:58:36 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH blktests v3 1/6] common/xfs: ignore first umount error on
 _xfs_mkfs_and_mount()
To: Luis Chamberlain <mcgrof@kernel.org>, shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org, hare@suse.de, patches@lists.linux.dev,
 gost.dev@samsung.com
References: <20250212205448.2107005-1-mcgrof@kernel.org>
 <20250212205448.2107005-2-mcgrof@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250212205448.2107005-2-mcgrof@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/25 12:54 PM, Luis Chamberlain wrote:
> We want to help capture error messages with _xfs_mkfs_and_mount() on
> $FULL, to do that we should avoid spamming error messages for things
> which we know are not fatal. Such is the case of when we try to
> mkfs a filesystem but before that try to umount the target path.
> The first umount is just for sanity, so ignore the error messages from
> it.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   common/xfs | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 569770fecd53..67a3b8a97391 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -15,7 +15,7 @@ _xfs_mkfs_and_mount() {
>   	local mount_dir=$2
>   
>   	mkdir -p "${mount_dir}"
> -	umount "${mount_dir}"
> +	umount "${mount_dir}" >/dev/null 2>&1
>   	mkfs.xfs -l size=64m -f "${bdev}" || return $?
>   	mount "${bdev}" "${mount_dir}"
>   }

Shouldn't ">/dev/null 2>&1" be added to the _xfs_mkfs_and_mount()
caller rather than inside the _xfs_mkfs_and_mount() implementation?
The above patch makes it impossible for any caller to capture the
stdout output of umount.

Thanks,

Bart.
