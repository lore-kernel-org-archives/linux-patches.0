Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAA7524BE
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 19:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712000881; cv=none; b=F448v7Q5RelP3aUvjASqqQKZPSUBPf0sC/ojMLgZDSTNNoan5WF5C8KER/pzrNkhfiA461XC+BYJOo3YXxLnyHinaGJg+S3uBJssp3zMwpDLTJSInK5QD6ac8BNhKbprJlsvmjf/ItewMXc9HH3zMbEfQ9lZqxY8uJx3EA/nWAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712000881; c=relaxed/simple;
	bh=lnar+0o7dLIVFJzKrV98YGj2n80M98LUV4BiC3ifQZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VybK7Bn0Wot5bNpLSmnKXIumoWZokq9svKR6wq4muFgLAv/7LR7xldz5UXwzg3PuGhBOc8rspiu7GiQjWgrtdNk0ydFj30lUp3RLskrqIEWdbzZTIU7cCikdrSuHG/jnQp+nP+/ZJJ7dUFPsgngOqdfeUlB7tEFFy+q9fYVpxTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iU3gnDeJ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iU3gnDeJ"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-341cf28dff6so3329929f8f.1
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 12:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712000878; x=1712605678; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i+aKdwQrYSYkzio8WwLCV972xl0lvZDetZCMBr85V4g=;
        b=iU3gnDeJBxGDqmy43vjFIqp4nJOxd+oHmrxYWGVi30jp+RL5audDrK4dBtw/GA4wEu
         EqGv05E+1RJPJ8eZVMf1THh8DqH+aut2almRSQqlP/mmQ/G5Gz7/MQ7feJMzkBgkvKT+
         U2s5L/09ccVS5aYHVWUWZ/MWERbiA38OrN0llGVV48kE3e5omLQGf4C7vwpDt3fY0wa8
         IKYoLITjwQQI9rJTw5r2ocr6ALXtuvKO8lyYjt0L4lmcomCRe63AIIL9jFo697sw6JxY
         cDn0fACBSK9j971UJv/Gt1Ln5SKU3MMiPGogeO2TT0qGQJq4/sSXpphDNReesjyFtN0m
         dyWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712000878; x=1712605678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i+aKdwQrYSYkzio8WwLCV972xl0lvZDetZCMBr85V4g=;
        b=N7uPVe2YBHLEAn7GUkrUlCpTUArsduV0mAzOVYcFE4ci/y80W+yDeCeoKiR5iKJvx/
         YvfjdVOfOfr51+VzJl7wmkdcKqTSYBageasopXEWC4CKGZZ9FilqHZJuwjDbUwcCVw2/
         f1Xoas7knIKMxqQhz7O0OsGjDGXqVgfFv52YzDNnX2Jnd03Az/FPus+bIceiRZuaCHxD
         Ztkc5NraSzOjN7wMNLQ8Jt41Or2D+c2ELhYul3pd0aB6AZYHP7pugAbZSgsnVyAiaVeV
         cAU4Que9eGS+2hgZjEEjX9MTr9/znUYD5n2q/p319WFaH4sxebtmzyWr1Qf/AqxcitYH
         Oq0A==
X-Forwarded-Encrypted: i=1; AJvYcCUwjHWhYtJHDbKyiJI1wwqokzd/pEsjfCeZATYBAOyacCIoudRRgkcpL/W6g6kEcWuoo2uLDXNPx/Th8/hGcZn0xgaE+MelhA==
X-Gm-Message-State: AOJu0Yyr+xHrpUkp18fRDGyTS9Lm66DpCHN2glDUoDk6g+QGTTbPfLWh
	pYy65tEJXWrB3Q6hpM7pDtx3B5o7gWp0EwmNJD6D4C395xdB3+Ka
X-Google-Smtp-Source: AGHT+IFMNEfCpuQjJ8WPz+6uM3yEpezsYLuHC2wVq7juE0ooOQEgeuAu2jh/5KYIiQvvkCP2EftuwA==
X-Received: by 2002:adf:ea50:0:b0:33e:7fbc:caea with SMTP id j16-20020adfea50000000b0033e7fbccaeamr6898410wrn.34.1712000878354;
        Mon, 01 Apr 2024 12:47:58 -0700 (PDT)
Received: from localhost (host86-170-129-184.range86-170.btcentralplus.com. [86.170.129.184])
        by smtp.gmail.com with ESMTPSA id l2-20020a5d4bc2000000b0033e7e9c8657sm12297256wrt.45.2024.04.01.12.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 12:47:57 -0700 (PDT)
Date: Mon, 1 Apr 2024 20:45:42 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, stable@vger.kenrel.org,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] mm, mmap: remove vma_merge()
Message-ID: <38b67f6a-6c64-43db-85fb-027efac9d9d6@lucifer.local>
References: <20240401192623.18575-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401192623.18575-2-vbabka@suse.cz>

On Mon, Apr 01, 2024 at 09:26:24PM +0200, Vlastimil Babka wrote:
> With SLAB gone I was looking for what I could delete next, and then it
> dawned on me - it should be vma_merge(). It's simply an unmaintainable
> mess.
>
> The code is extremely hard to follow. There has been a number of recent
> attempts to made it more readable, by Liam, Lorenzo and myself. Almost
> every time this only resulted in subtle embarassing bugs [1] [2] [3] [4]
> [5]. For many of the bugs the only reliable testcase we have is the rpm
> process running in the Open Build Service. Which is worrying, as that
> clearly makes vma_merge() a potential supply chain attack vector for
> planting backdoors.
>
> Thus simply remove vma_merge() and all the related code, and adjust all
> callers to take the path as if merging was attempted and failed.
> The only downside is that there might now be more vmas and maple tree
> nodes due to no merging. To extensively validate that, I've booted the
> kernel with virtme-ng before and after the change and checked slabinfo
> for the number of active objects:
>
> before:
> maple_node          1159
> vm_area_struct      1538
>
> after:
> maple_node          1113
> vm_area_struct      1861
>
> Yeah there's more vma's but interestingly, less maple tree nodes. I
> believe it's worth it. The larger number of smaller vmas could even help
> with better parallelism thanks to per-vma locking. So the conclusion is
> obvious - we should have never tried merging vmas in the first place,
> hence the tags on this patch.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d014cd7c1c35
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4c6759967826
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7e7757876f25
> [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1419430c8abb
> [5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fc0c8f9089c2
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: <stable@vger.kenrel.org> # CVE mandatory
> Cc: Lorenzo Stoakes <lstoakes@gmail.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Singed-off-by-one: Vlastimil Babka <vbabka@suse.cz>
> ---

[snip]

This is a beautiful patch and about as perfect a clean up as one could imagine
(I mean #thebestcodeisnocode right?), but as we have now eradicated VMA merging,
I can't be a hypocrite and advocate for patch merging.

As a result, sadly I must:

Hope-Liam-Nacks-It-By: Lorenzo Stoakes <lstoakes@gmail.com>
