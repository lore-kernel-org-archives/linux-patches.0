Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1994C040D
	for <patches@lists.linux.dev>; Fri, 15 May 2026 16:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.167.242.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778863974; cv=none; b=tAz6dK9Wm3TSmRFPjwQzIK9G78eumIDc6FWFkj7TrjBq7R9O905fUjBap1xeJQwvII1b4vcpAxLB+bewMZTbcEZsE8hSfwEqOrO3eTNsrmF2HbRsAn6pOi7Llml3EVN1+Gf10TokrLcxcDTWvsELx3DGGn4WhE6ZsN1MSie0Kz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778863974; c=relaxed/simple;
	bh=a5TGuieO1EdOH+HQq0dB7K3Y4o8LQ1CXEggScH+bMMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JcG1zZR89yejL/ZiMJz1kMjUaSuC6wJR0N8jJYBC0p37JSxFYWDZNMQIIOSZIDOOgCsbp/f9MB2yQJB4b+nduPmdyZtSzUNk463VK5sdDZGEc0YDibNcFAtSu2hAbRaRLWfkCVtK16ZBQ52S7JP84IVS2QtIV8+BRHazml1OdP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com; spf=pass smtp.mailfrom=ideasonboard.com; dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b=HSv9Vyeu; arc=none smtp.client-ip=213.167.242.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="HSv9Vyeu"
Received: from ideasonboard.com (unknown [IPv6:2001:b07:6462:5de2:520d:d7a3:63ca:99e8])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9D7BC56D;
	Fri, 15 May 2026 18:52:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1778863953;
	bh=a5TGuieO1EdOH+HQq0dB7K3Y4o8LQ1CXEggScH+bMMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HSv9VyeubgIoKCDhj6wYjVffYv7NaHhKapVFexlCRcredlToH67n9/CgyEdqjY3V7
	 gkKrIrxAnbr7q/IlblqEFMIR+LQx3IRmEHacvVP/ObbpKqMnoBxCtPa3KpnfJTmu3h
	 +qDQBsuyuuiknxN2YTiS4PzvSHkLzMBdWEHDYI00=
Date: Fri, 15 May 2026 18:52:40 +0200
From: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Daniel Scally <dan.scally@ideasonboard.com>, 
	=?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <barnabas.pocze@ideasonboard.com>, Jacopo Mondi <jacopo.mondi@ideasonboard.com>, 
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: Re: [PATCH 7.0 016/201] media: mali-c55: Fix wrong comment of ISP
 block types
Message-ID: <agdO8lvv9vj9_1n8@zed>
References: <20260515154658.538039039@linuxfoundation.org>
 <20260515154658.887165119@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260515154658.887165119@linuxfoundation.org>

Hi Greg,

On Fri, May 15, 2026 at 05:47:14PM +0200, Greg Kroah-Hartman wrote:
> 7.0-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
>
> commit df16624248296ce4e8890c7ddcc95f0ccb642bcd upstream.
>
> Some bad copy&paste happened in the description of the ISP block types
> and AWB_CONFIG got mixed up with SHADING_CONFIG.
>
> Fix it by assigning to each block the correct type.
>
> As only the comment is changed, there is no uABI breakage or regression.

I know this is borderline for stable, however it's in a uAPI header
so I considered it worth adding stable to the cc list.

If you don't think it's necessary, feel free to drop the patch.

Thanks
   j

>
> Cc: stable@vger.kernel.org
> Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
> Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
> Reviewed-by: Barnabás Pőcze <barnabas.pocze@ideasonboard.com>
> Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
> Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/media/platform/arm/mali-c55/mali-c55-params.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/platform/arm/mali-c55/mali-c55-params.c b/drivers/media/platform/arm/mali-c55/mali-c55-params.c
> index be0e909bcf29..c03a6120ddbf 100644
> --- a/drivers/media/platform/arm/mali-c55/mali-c55-params.c
> +++ b/drivers/media/platform/arm/mali-c55/mali-c55-params.c
> @@ -43,9 +43,9 @@
>   * @digital_gain:	For header->type == MALI_C55_PARAM_BLOCK_DIGITAL_GAIN
>   * @awb_gains:		For header->type == MALI_C55_PARAM_BLOCK_AWB_GAINS and
>   *			header->type = MALI_C55_PARAM_BLOCK_AWB_GAINS_AEXP
> - * @awb_config:		For header->type == MALI_C55_PARAM_MESH_SHADING_CONFIG
> - * @shading_config:	For header->type == MALI_C55_PARAM_MESH_SHADING_SELECTION
> - * @shading_selection:	For header->type == MALI_C55_PARAM_BLOCK_SENSOR_OFFS
> + * @awb_config:		For header->type == MALI_C55_PARAM_BLOCK_AWB_CONFIG
> + * @shading_config:	For header->type == MALI_C55_PARAM_MESH_SHADING_CONFIG
> + * @shading_selection:	For header->type == MALI_C55_PARAM_MESH_SHADING_SELECTION
>   * @data:		Allows easy initialisation of a union variable with a
>   *			pointer into a __u8 array.
>   */
> --
> 2.54.0
>
>
>
