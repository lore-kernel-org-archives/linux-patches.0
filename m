Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9CE1E519;
	Fri, 15 Nov 2024 02:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731636304; cv=none; b=cajuYOd0uWFkwGiNdWiZBjo6L+tE2r2grdARv0HsfRxznQ30y/3bArw4UkIhXjcJe3HZFNVmhCpZFGFGh9S0nuSDSOM3/DfJIk+OS2bOQvuQXwnoqo+YNDYAUQ2ZNwxB22Bir+R7Rij6WD7R/a00Gs6D/2bq6CDRU+RDxlAQ9pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731636304; c=relaxed/simple;
	bh=jL2s2t/zhJpJ+qG123A/AS1ete6L8+lC03CZs2yFVLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhmDYCmH+MPiV6k3rG+M+kFJyLMHOpvsBK68MNvtBgnj6b1pSItDNbob196TBAwB1mwteto9Nui97+bcow0cge3UWs+y+zau1KxAoGRZMullBJ//6RIlXoQPIdzPjAY/t4nJHC5sg873LEdlQi8BbW4moapsMCe0gDvu75vIebM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NZjRaArP; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NZjRaArP"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2114214c63eso11744495ad.3;
        Thu, 14 Nov 2024 18:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731636302; x=1732241102; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Un3CG6pCAJkVBfC1wRNirZ10KSeDAdNR1yEq+oR3gcI=;
        b=NZjRaArPhIarKjZeGXcDzRquBD4f83ecxEfegbGGBkIXah+NfvSt2q+AsNCTboxW3w
         dKZzhkDBL1TqyjeUyh7kt322Ga6Z+o3VNIdZbRREjvggfudn3oxWcdkmLL2hNnU0YTyr
         wYr9NU54DYETD2u8LJRqMGWNP96WGcFaz2pqVIfYdJSAW55tDUThTvBnBX+ZbslKnu/r
         wQPUBpTaXA5824XBzZnnH+PWSCxuNrFStNBi2QX9b2rDQxTy6mmryFO7oNEjC/WSnnB/
         LBM8H0bAWXUwE2JbKjSutgk/pFDXeVzKmmaIKmMQANf+BWYLPbMAiqFQbJ8Zzw2UHq70
         9TnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731636302; x=1732241102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Un3CG6pCAJkVBfC1wRNirZ10KSeDAdNR1yEq+oR3gcI=;
        b=TM/8KsdiKdlXelIUPB6yjptPcrU5oFZwCGv7xgbBAXiCkQAOY5KrDhx62RjSGGbboF
         QMsH2Hi7DJct4Xfs5pq1Qu+hAhonr8k2/QGRAGKDf0SWacahxTynXW6elcq8s8LaphVg
         ZywZYfiI22FzhOSo+IiWcqqA0inIz+xKHwE56plJt09IbSmDz9IG5Lbu0hS7QV6qdDvN
         0ddWNt58ajeoBkYIq3I/xnaAqvKsW+k3awfI3LPYXZAo7d9Vyw7yFhUz1xUONyDzRyXw
         gdP1a525NEhSPf+cFmIhgg/n8+c7btc6B8+mvvoz3zfp0SB1p1NdsqvOYpQ3+Ctg4v+y
         qVUA==
X-Forwarded-Encrypted: i=1; AJvYcCUW1eICa4oyhRMthPWUvh43F/CqJUzPNJ5Jccle1m3iYm1f1vnW7DnafQK1g9oxPftpfr4c@lists.linux.dev, AJvYcCX8ok45JPp+qKYWpsvcpNBgaL89lVmpfWJin3tOqC7w62XWEHpAqLTo6agSULKVb966g5W5u77N8w==@lists.linux.dev
X-Gm-Message-State: AOJu0YxttG1/wmMmRnIh6H3QGKwsiHoKtPax505+1li+CVSwHUs4VNF4
	84eYxX07O89/6eFWve3bxXsLcGY2yoh1sPJZ1lKxbIniCBRsFnKB
X-Google-Smtp-Source: AGHT+IHuju1uUcuI7sPhozxnpX9DM2JJjm9MZFu6wM19m/lqqUGsSkVyUtUpZbburP1WLyFNgftIEQ==
X-Received: by 2002:a17:902:e806:b0:20b:7be8:8ecf with SMTP id d9443c01a7336-211d0ed2bb8mr14996985ad.53.1731636301875;
        Thu, 14 Nov 2024 18:05:01 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:82bb:de58:4fde:fc46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f47c0fsm2873415ad.214.2024.11.14.18.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 18:05:01 -0800 (PST)
Date: Thu, 14 Nov 2024 18:04:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Marek Vasut <marex@denx.de>, linux-input@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] Input: ads7846 - Increase xfer array size in 'struct
 ser_req'
Message-ID: <ZzasSty3XHbWBDJV@google.com>
References: <20241111-input-ads7846-increase-xfer-array-size-v1-1-06cd92e9f20f@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241111-input-ads7846-increase-xfer-array-size-v1-1-06cd92e9f20f@kernel.org>

On Mon, Nov 11, 2024 at 08:09:55AM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y, trimmed for brevity):
> 
>   drivers/input/touchscreen/ads7846.c:412:2: error: array index 6 is past the end of the array (that has type 'struct spi_transfer[6]') [-Werror,-Warray-bounds]
>     412 |         req->xfer[6].tx_buf = &req->scratch;
>         |         ^         ~
>   ...
>   drivers/input/touchscreen/ads7846.c:416:2: error: array index 7 is past the end of the array (that has type 'struct spi_transfer[6]') [-Werror,-Warray-bounds]
>     416 |         req->xfer[7].rx_buf = &req->scratch;
>         |         ^         ~
>   drivers/input/touchscreen/ads7846.c:334:2: note: array 'xfer' declared here
>     334 |         struct spi_transfer     xfer[6];
>         |         ^
> 
> Increase the size of xfer in 'struct ser_req' to ensure that there is
> enough space for all necessary members and there are no out of bounds
> accesses, clearing up the warning.
> 
> Fixes: 781a07da9bb9 ("Input: ads7846 - add dummy command register clearing cycle")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied, thank you.

-- 
Dmitry
