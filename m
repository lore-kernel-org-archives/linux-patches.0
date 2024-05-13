Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF47720DF7
	for <patches@lists.linux.dev>; Mon, 13 May 2024 17:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715621648; cv=none; b=Q0MeG4n2HovhnmhOhr34TXeIxTDCsnGSzFit6pX6OTcbZ7AEGvumZyH9XlJN0V3J6wpVXh3tcM9RtZjdkb7yaFrco0OIi2tC8sES5V8abQjL9dfLAkMQIoSW+VUspPnA//NTjB65q0SNLNjMDF6JN3VJGQ8pGhVybaITzXbRYUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715621648; c=relaxed/simple;
	bh=LGyj4luFEwyxCJutXStC46wb2QnlMbg8i3ELpfd0ioo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SiOMMssJyD56xClBNdYL987xKnNiuxqOar0Zb/59lah5xsS0TBGNz22mlZPSDh47bNtxg/74bE3r/Ccw+JSgXwMJZAD94O/ds/Z2qTmvvj91d5//UhCjDZbg9Vssfhy8PssEPSZ1/9oTAd/gqx65LPjGWhlZQbZinVj8CNdZVeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VEu7vcAo; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VEu7vcAo"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a59a8f0d941so1135526366b.2
        for <patches@lists.linux.dev>; Mon, 13 May 2024 10:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715621645; x=1716226445; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gF7u5KTdydtGb+C4u/lKHMX/r20FiXVK70KMr4rQijg=;
        b=VEu7vcAo3Ucq0GDZ6+cYbcs2tV9DOR4PC0f01nAu3SerWaszswiDlMsES9fIAJ8ijr
         AcDILRCWNS19e+IqWBmMLPTg/8/gzShUKPFcfVxvnQyEryJs0xDYLrZWV1nFYOFr8gAU
         ArRREIrGRG4rtjNspGPtV1/h4yOgtKTrl7iyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715621645; x=1716226445;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gF7u5KTdydtGb+C4u/lKHMX/r20FiXVK70KMr4rQijg=;
        b=iLfBeLsY4haf5bw1aEcxe6CQnb56UoUKNf6m56J3vy4bx8c+7GExKGirKtD1/wJY9C
         68cGZcSGcHwwQQELw44HUi0LszJVY31NOQsPuv485NyHmdiop4PzxYcLXsSfd50QLb7i
         nYUK1iP4nyLTCHUTS2Z5TzNoDGwKWnsBxF2GQCqhaDB1lbQ0Rs4Eb4qTri/G64+2n1gw
         e6E9XqzVRwYCMWhALXFkJ1LT7zwp5FfY9vD2UL6ja9yskWkotFk7E4bvmXzkZcD2GXXa
         02d95gooYAGoSZPaBKAqDX0l2LKac6WyWaBFlEESDmZopGWR+e2b2BBp2AEsKha4IyqS
         cIwQ==
X-Forwarded-Encrypted: i=1; AJvYcCX06/xR9ZgMXTjvg1TKn/l9juf+4eJ4ePAIEhtmBcmgnkmMt8MOn2MMR5s43K9lMJ8O7ttIKaVMzD9nGLCb3rwf6pTuVy9jLQ==
X-Gm-Message-State: AOJu0Yz37I7lKkj7g7Lj69dUJuMuD6VxLz0s48WqcvEHL7qxX3liytSR
	UHavfiDdUvVoUhPoPw6PWG1ZKj9BK1XHc+wDJcyor6faCkyydcTWhHSpAAiahKGYZjIRRlt6lDl
	U4kEM5A==
X-Google-Smtp-Source: AGHT+IElJfu/2MrXBqIzMjdtA56BufGf4zQS32iGUHGWqRIX4lyd8e8N1BXHHKb1Ce9C9/ptL2xDBQ==
X-Received: by 2002:a17:906:15cd:b0:a59:c9ce:3386 with SMTP id a640c23a62f3a-a5a2d5cb0c1mr623293266b.33.1715621645094;
        Mon, 13 May 2024 10:34:05 -0700 (PDT)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a179263d9sm624672566b.95.2024.05.13.10.34.04
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 May 2024 10:34:04 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a59a0168c75so1212278866b.1
        for <patches@lists.linux.dev>; Mon, 13 May 2024 10:34:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXwMJPILMV9feTEj35Pke3orAeMgqYBJ0pBJo3lxuOCagD2hhNenVU1S8MFCMhNAx8vuf/luKg9pZtX6hMcNGTr3HyB68+2Yw==
X-Received: by 2002:a17:906:2298:b0:a5a:3579:b908 with SMTP id
 a640c23a62f3a-a5a3579bb63mr599168266b.38.1715621643624; Mon, 13 May 2024
 10:34:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <587f5e6b-d543-4028-85c8-93cc8f581d02@suse.cz>
In-Reply-To: <587f5e6b-d543-4028-85c8-93cc8f581d02@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 May 2024 10:33:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiZpyWvC-nh4CPhKkPLMwWb_W00NDMopuxVNTnGB7fYeg@mail.gmail.com>
Message-ID: <CAHk-=wiZpyWvC-nh4CPhKkPLMwWb_W00NDMopuxVNTnGB7fYeg@mail.gmail.com>
Subject: Re: [GIT PULL] slab updates for 6.10
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, 9 May 2024 at 07:25, Vlastimil Babka <vbabka@suse.cz> wrote:
>
>   To avoid affecting fast paths with another shared counter (attempted in the
>   past) or complex partial list traversal schemes that allow rescheduling, the
>   chosen solution resorts to approximation - when the partial list is over
>   10000 slabs long, we will only traverse first 5000 slabs from head and tail
>   each and use the average of those to estimate the whole list. Both head and
>   tail are used as the slabs near head to tend to have more free objects than
>   the slabs towards the tail.

I suspect you could have cut this down by an order of magnitude, and
made the limit be just 1k slabs rather than 10k slabs. Or even
_another_ order of magnitude smaller.

Somebody was being a bit too worried about approximations, methinks -
but I think the real worry goes the other way, where it's practically
so hard to even hit the approximation situation that it gets no
testing at all.

IOW, I suspect it's better to be explicit about approximations, and
have people aware of it, rather than be overly cautious and have it be
a special case that almost never triggers in any normal loads.

But pulled.

              Linus
