Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DF85FEE4
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729530393; cv=none; b=dBGwPEnYUJamPYStm3Ng5LbfJixzWY8gKY4mXsPleD8wumM4SdtqV0vDsVtTZtImmYFg5quwrWZBDMtrt9AqiImEl719/ZkbkKQddHNvBY+WlJ6mC9a2EI2Ua3Pkji4Rxi2+4RftQDYIL29u4WvlwpqzdswdD8pmUZHBbWhCZa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729530393; c=relaxed/simple;
	bh=X5kmd610FEscRrunhJz3c1ni6ltsuNEVDD2UBNJXJmY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tTp/rA9uzpOBdDICZidII8rOCZfQqumxoA96hDCdC9x/P9SC3bGBJjaBHzFrLIUFHN306FvZinpgrFNxynzNg/d9dgEUFXM8ytfnv6cfYwgsEpG9gMvcbBB+ago1WmM9HehAMVygTg4tPt1KrtgXCYHi/1ojE6DPeZteecPnjxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0m96Dyh5; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0m96Dyh5"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-460a8d1a9b7so10861cf.1
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 10:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729530390; x=1730135190; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6AJQaP6lejXxoDFr/L47fXxDRsNjBuRBiU93WXWAkCw=;
        b=0m96Dyh5bE5qqX1Ci8Hydg+4RZFB1bZeXOlX46RWCcAMAesHrN4dotC8kYtBAnXIMG
         EM22LpzWS8sWdMz6MWlECd2gfFZ9SsYzCnTcjm3wvMpCtGyjwDnycm4t4Xzztf76zfvZ
         xD49topNEM+AQpY46CE0ztfQA61bVeCcFpkCDb+9eWa9fzMnl7TLseqZl5F+KVMCO2NQ
         A8/vFzug2qCR07ROJjoBglKmjQgKmhnitJw8r2rHGmRfv+eUOHYdxoiH4yRig8R7wsvD
         oYpA2tBhoIkNxDhC3KVq5w4WWNPuFnM8uwJfI/ytQlv9p378Fzad8xED+XN+oN7lSd6O
         LNXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729530390; x=1730135190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6AJQaP6lejXxoDFr/L47fXxDRsNjBuRBiU93WXWAkCw=;
        b=ZnleRw4+f/QM2He2KipPv3koSJduKGTKxuD/MjiTGgfRkpJB1atZDc45yCCpP9otfT
         /c937dE057UnM2QdD00bv6CQpeTj0+VN4cSlqUpRIWPJnhLmFGdgWIH7OM9fSw9qYcoL
         he+x8pe2Gmf27JICGaW3acur334NJenx8WuLo2hlZHGN6L2p5akX+tHledslUJNJk9mX
         Jj3ol2w+fXZm+vnOuA5D/8xAfA6pzvJiLlOictLXLQJYFpIQmNqpbVeMu4jzLaWi0TEd
         xqNBQftUoKzyBPcMvldje1s5/NYD8bF0lLHz1wA1JX7RQqBbK+zRQ2qOQmHKxmHrMB3T
         Y6Yw==
X-Forwarded-Encrypted: i=1; AJvYcCVA0xRbJ8t6NBPd33Gf0UrL9BAGi8by3BSJb6ic6d5SUEzC3PasNoYGzU1P/kyVJbRAOyv01PUM@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3lRdfp3gLc33AEOC6x3x0lpPmppMDUchExzrjg6ehbqQNWp8E
	C1BZ47glZd02xVj1HTfZuDsKmkKZ+m0NBdM2QuvvI+v4p4xaC+ZiY3OTZCF9DEu/Gl3HKR06l8e
	Q04WLVKz6SxX96cPfUytMGox/H+dcAslyERdX
X-Google-Smtp-Source: AGHT+IG8C7uzJEQzdBvBjvlkO06dxz2dTbSsoDNYgZ/WJwAsrG+FF6lsUc4oj6IFs5BLoTA9zzkhRN/kvRDwTgBvzRg=
X-Received: by 2002:a05:622a:5b90:b0:45f:924:6bcd with SMTP id
 d75a77b69052e-460bc6abc5amr5210591cf.22.1729530389600; Mon, 21 Oct 2024
 10:06:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241021102259.324175287@linuxfoundation.org> <20241021102300.282974151@linuxfoundation.org>
 <a4163f51-cc1a-0848-d0fd-e9b94dafc306@candelatech.com> <ZxZ_uX0e1iEKZMk5@pc636>
 <2024102130-tweet-wheat-0e55@gregkh> <fb0cd50e-5525-4521-aa1d-f919ae19f77d@suse.cz>
In-Reply-To: <fb0cd50e-5525-4521-aa1d-f919ae19f77d@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 21 Oct 2024 10:06:18 -0700
Message-ID: <CAJuCfpFU1tLc_wvAGu1T3WximLFRARVxBtJTm0bOfgqt_MnYyA@mail.gmail.com>
Subject: Re: [PATCH 6.11 024/135] lib: alloc_tag_module_unload must wait for
 pending kfree_rcu calls
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Ben Greear <greearb@candelatech.com>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Florian Westphal <fw@strlen.de>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 10:04=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 10/21/24 18:57, Greg Kroah-Hartman wrote:
> > On Mon, Oct 21, 2024 at 06:22:17PM +0200, Uladzislau Rezki wrote:
> >> On Mon, Oct 21, 2024 at 09:16:43AM -0700, Ben Greear wrote:
> >> > On 10/21/24 03:23, Greg Kroah-Hartman wrote:
> >> > > 6.11-stable review patch.  If anyone has any objections, please le=
t me know.
> >> >
> >> > This won't compile in my 6.11 tree (as of last week), I think it nee=
ds more
> >> > upstream patches and/or a different work-around.
> >> >
> >> > Possibly that has already been backported into 6.11 stable and I jus=
t haven't
> >> > seen it yet.
> >> >
> >> Right. The kvfree_rcu_barrier() will appear starting from 6.12 kernel.
> >
> > Ick, how is it building on all of my tests?  What config option am I
> > missing?
>
> Most likely CONFIG_MEM_ALLOC_PROFILING
> Depends on: PROC_FS [=3Dy] && !DEBUG_FORCE_WEAK_PER_CPU [=3Dn]

Yes, it's disabled by default.

>
