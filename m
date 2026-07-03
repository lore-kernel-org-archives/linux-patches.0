Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D633D9559
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 12:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783081972; cv=none; b=WOCQ6pZcV1kP94zOegvZT7dEK0F1kD4VhRNx3RnA6wfi5O0F0py2no5Bqw34UtJYTDIGTra1UMvgaMNbMfS+Ua8DVlpqpPNCBsxuPUReAvrRu78c6jwIE1AtKqcYZQBkU3OIUu3pu8wZA1TuTtcDqfkEQrsi5DXO3/AtZP4IU24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783081972; c=relaxed/simple;
	bh=nmZA6+uB3urD2hKCpKw8hiD4oFjQ9dwF7f3r4Tfky8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0NlCNGXgD0iVoJe6263vkNnnmGCxrUlg1ANN2l99oEXwbbkzcypTdiub7/W3x73rTSFxefjluUQ7CrXD/RNlCLao+ttRvlyIjpmUlP7tI+yfiR4xx+8e2K0kF6kR+RW9JbrWTS0sL3tsaq9nX8JOlXt5AKBM4cbOmJI3270ybE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lGEn1QW0; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lGEn1QW0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783081964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KPobOMpzLXIZ6h+MVV8WTmoa13pxNOpbezeoUAZoB28=;
	b=lGEn1QW0L8yjWbmvygdeC/+JFPmdBuDOtLNHL0GwaV3OabcFTtTB7N57JCebnvsxY5f11U
	JxPftL4Si3/LLOk4OVjNnBewAIQz2oL3dsHYRBTXUfkxsTC1OhC05Y7sLk10yR3fUokWTH
	pa9kLdLXv25oUUqe2O91ufSHmFeBjV8=
From: Usama Arif <usama.arif@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 6.18 044/108] block: invalidate cached plug timestamp after task switch
Date: Fri,  3 Jul 2026 05:32:35 -0700
Message-ID: <20260703123236.3139759-1-usama.arif@linux.dev>
In-Reply-To: <20260702155113.020016705@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu,  2 Jul 2026 18:20:41 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Usama Arif <usama.arif@linux.dev>
> 
> commit fad156c2af227f42ca796cbb20ddc354a6dd9932 upstream.
> 
> blk_time_get_ns() caches ktime_get_ns() in current->plug->cur_ktime
> and marks the task with PF_BLOCK_TS. That cache is only valid while the
> task keeps running; if the task is switched out, wall-clock time
> advances and the cached value must not be reused when the task runs again.
> 


Hi Greg,

It looks like this patch was backported, but the preceding patch [1]
in the series was not bacported to the stable branches. Both this and its
prerequisite have the same Fixes tag.

Not having the prerequisite will result in a NULL derefernce.
Could we please add [1] to the stable branches?

Thanks!

[1] https://lore.kernel.org/all/20260616141604.328820-2-usama.arif@linux.dev/ 
