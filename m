Received: from techbitestudio.com (techbitestudio.com [75.119.147.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5328E2C1A2;
	Fri, 27 Jun 2025 10:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=75.119.147.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751021141; cv=none; b=l66bGhLISO/C1JSTYrW2kafx9Gz+Fd+abQH7s0FAAKpdcjCatQhDl9xQHSuqpEFr0nQL1HanfQXpSeSzMk6vQycohI2/nx/XhnyXlaZWOs0T61HdwtqsbMBTB3cFxuCy4eu2yRVBAM/29NY+2I7o7svSbiplVKNEd7ql5PB3CWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751021141; c=relaxed/simple;
	bh=bb7T5g653eHTADZB4mZwhNRfpFKwCangLk8Efqyd0gg=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=nZ4XZXh30ESV+DcVQg/IiKgk2MMdunxM7Hifmdxrta92ywgQYdE81dTQYAMeODaEFDdYPMAlYDDKnPFTe/FdaZcQwe7r+ukmzB3MS6kuGkm7Ad1iENe3atR6c73yQNp6gY61SFaIHxOjjOW34seQcos6UxNTzzxzWnKCtQc5Y4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kenip.in; spf=pass smtp.mailfrom=kenip.in; dkim=pass (1024-bit key) header.d=kenip.in header.i=@kenip.in header.b=YEHYCuqj; arc=none smtp.client-ip=75.119.147.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kenip.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kenip.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kenip.in header.i=@kenip.in header.b="YEHYCuqj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kenip.in;
	 s=mail; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vqrgS0UqgBzLa2CIHyVnbuPfpxmfPQydTgYW5Z9NGyM=; b=YEHYCuqjtngyjK1TvgUs5LPy3t
	xsvxMAGB/1gTu13bSCMfo+ugs/VSxuJcp5NyIYqynegcl8o54+l9UfHvQ3t+cOCQfnOp/lY5qmwD8
	qKm+sdsAYjUQqIeudRnvNp8MmjEaGvud2Kvpcfcw5MAR6tXVHtJs3eOuEkvvwhD9Lhc4=;
Received: from localhost ([127.0.0.1] helo=kenip.in)
	by techbitestudio.com with esmtpa (Exim 4.93)
	(envelope-from <siddhartha@kenip.in>)
	id 1uV6aO-0004ff-9l; Fri, 27 Jun 2025 16:15:36 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Fri, 27 Jun 2025 16:15:36 +0530
From: siddhartha@kenip.in
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_mm=3A_limit_THP_alignment_=E2=80=93_?=
 =?UTF-8?Q?performance_gain_observed_in_AI_inference_workloads?=
In-Reply-To: <28338f055b3c9afa8b69ff6f05ea20ed@kenip.in>
References: <28338f055b3c9afa8b69ff6f05ea20ed@kenip.in>
Message-ID: <d391b2ddcb4e69251c3044d7e2f36f87@kenip.in>
X-Sender: siddhartha@kenip.in
X-Priority: 1 (Highest)
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

> Hi all,
> 
> I wanted to share validation data from a Hugging Face-based AI
> inferencing workload,
> which was significantly impacted by the THP alignment logic introduced
> in commit efa7df3e3bb5.
> 
> Using transformer models with dynamic input lengths on Intel Xeon 
> (Cooper Lake),
> we observed up to a 3200% throughput improvement after applying the
> patch from Oct 2024:
> 
>   mm: limit THP alignment of anonymous mappings to PMD-aligned sizes
> 
> Metrics:
> - Model: BERT-base
> - Inference engine: Transformers + ONNX Runtime
> - Kernel: 6.6 vs patched 6.6.8
> - Batch size: 8-32, input length: 64-512 tokens
> - Metric: inference throughput (samples/sec)
> 
> Thanks for the fix -- this change had real impact on a
> production-relevant workload.
> 
> Best Regards,
> Siddhartha Sharma
> ISV @ Kenip
> Solution Link:
> https://www.intel.com/content/www/us/en/partner/showcase/offering/a5bHo00000045YUIAY/deadlock-clearance.html
