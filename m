Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B673DE45D
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780334267; cv=none; b=XKSQz9iGcrlU88s2bqEfHSEvxhnEsiPh4CCzDBMCtsDLS2ppTeMXNEK3/XLOGbiZGfKbO/jmk8wQw1KctN4e3niEoJwX+Iw0Wrf1rm4eu/DzWvWToCkJ2N0ITysx5gEfaq5pflxjmKDAXoB2OcHu4SAe71oA3ahsEBWwu5Dw7qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780334267; c=relaxed/simple;
	bh=QOF4HTo9NC+sG07UWNWNGhB1bOa8fZKjrboF6NtGYig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aaF0BypwI7J1GHN/14StBvuncIWdWiavFd//BnG5/6gv72eS3a685+TxH6U3dr/TmUcIkEMZezD0IoLK/j2Q21AD0PnxWPqlAnTmgjeg67fqqcrGOFgg5GwYRMd/2sSbaWj89nz0cAIhqilS9eO5zvJX48EdYIzviw6lJsu84qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jzli/xfB; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jzli/xfB"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bed4f2f0898so165796466b.3
        for <patches@lists.linux.dev>; Mon, 01 Jun 2026 10:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780334262; x=1780939062; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8glRJeBkbbvtPfYZZguJlBO/diWKKHW+QvqawLEed2k=;
        b=Jzli/xfBWPZXJ3DYydQUBd61nLLb+ZARdXLWOBskK7ezO3kZPKnHcEzFm/iDYni7Up
         gtJGwwccQ0xCKMBicZ2SjhdppSquVexMkCPjkNN0Ki/WsKGFrcXM5vxTeUJo+MFJiPg4
         eTPaS/ZRa4azN1kZp2WPlBACGmJggJAn7KwGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780334262; x=1780939062;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8glRJeBkbbvtPfYZZguJlBO/diWKKHW+QvqawLEed2k=;
        b=oz3OiMgVKaWG9XQ5WeWC5GcZ8UTvcLPgiBA5Z8/M4Fa7mQF+tPD+2VNlOSzB7YdUWT
         4a2S6r0FhcUWOfVgvMab1UG8JVIalj80KALB9IQ49AWNYJGuwLlHUvVG1P3j1vuijLsl
         KEk7mAQr4vmIdWmqYiIGvnzDXdXQBT7kV/5fM694qZKu5gIwQl8GYdFXSnvynrix6NQw
         mbyLSRW9u9S7k8Fz2pAf65+ZS6o6M7moAY+8VZwgTfuhfzAc6Y2TJs8Mp3KwlYh0d6wn
         /1a/B4kYvGjZyGnAzlUha6jgP8rqN0u/0/K0JMPZcSO5hcmvdQzLG/OOE/tyhLwvJH5C
         1naw==
X-Forwarded-Encrypted: i=1; AFNElJ9acCCDBPXX+m/uCZooe6p6ugjWak50fJ+lQ2cEEOzSwmYHsNzroHPQD4b9+4Zqnho1VKz4OxuT@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6JVMDVW4hwY6XPWPA+suDHS9YvxMQXNiD6q6lFzCAeydvTQFQ
	6QMDAXIREBa1Bca3TmMB0HnTg7dvcSoU72TfxUM9hFYLLQnU3KZYjco6b50oMsj2R7f83OmxBXc
	Ypzh0qMA=
X-Gm-Gg: Acq92OFtY3PZ8BrdA8GNOMImLEFoqEGEBEAZGisFqvwNkZ2ApZPBXQL8PTrr6QHat6N
	5jtIL4Bu0lzkK3FliK6PjUL/Q8tyJ+xT2eMy8xpRlFG0/xmvmOwbkgIgsttsZEWdRCRdAoh294u
	LhxSNIJzgrj68lwEOvAbH9mkvzfYj44qYoT+Ck6kvr4wPD4PXHvDVDJlXEWUa3tBDD1mdt0G4Nu
	HomuWoz5c1yZs24GNTZ9ctVnl7bZ7nF/MamL0RQZbKwGcDSGRCYCemCqY/wm59/nNwrQs4L/q0h
	q8+56DviTGESw/uZn9Vu6ntblt20RqB3ULuKk+SZMV49VsWvoJ8z5mphp2W4/71cpsMNqCaW5+H
	4xwcTfNa8xePwB+bm0eIzIZ39+2hgw7vl5SO6NEcgDKPYtoQzKu1C8UHCM3ZUqawu/GMuhxpsiy
	YE1ONikqTD4tipEaMlRgaAicCkmTxa6mFdNoifALG6kzIfhObeQaZY5R6WeGAtw1bb4dL1Hw+RZ
	52swzBCUGc=
X-Received: by 2002:a17:906:eec6:b0:bd9:2b46:99b0 with SMTP id a640c23a62f3a-beab3e3eddemr716019766b.49.1780334262042;
        Mon, 01 Jun 2026 10:17:42 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bee4092940asm82934666b.11.2026.06.01.10.17.40
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 10:17:41 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bed4f2f0898so165790566b.3
        for <patches@lists.linux.dev>; Mon, 01 Jun 2026 10:17:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/gD5JlJ2sraMo/+GnzC3Zc2NBt67rD5qb6TOv4ZXOilVMGHoP5tAMPxKoblK2zAMgvyeR78Khv@lists.linux.dev
X-Received: by 2002:a17:906:4583:b0:bef:12f:347e with SMTP id
 a640c23a62f3a-bef012f3d6fmr16123966b.24.1780334260114; Mon, 01 Jun 2026
 10:17:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com> <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
In-Reply-To: <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Jun 2026 10:17:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
X-Gm-Features: AVHnY4KexWf0o1w3H7pefWBidQ5elZSrUhqo_ATAUmEnAO4iwBaX4DnfDRLKUYk
Message-ID: <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Christian Brauner <brauner@kernel.org>
Cc: Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"

On Mon, 1 Jun 2026 at 09:42, Christian Brauner <brauner@kernel.org> wrote:
>
> Applied to the vfs-7.2.vmsplice branch of the vfs/vfs.git tree.

Btw, if people want to work further on this - assuming we don't get
any huge screams of pain from having effectively gotten rid of
vmsplice() - I don't think it would hurt to look at limiting the
"regular" splice() too.

We already have the code to just turn it into a pure copy on the
"splice to pipe" case: copy_splice_read(). In many ways it would be
*lovely* to just always force that path.

We already do that explicitly for DAX and O_DIRECT, but we made a lot
of special files do it implicitly too, so quite a lot of the splice
reading cases already use that "just read() into a kernel space
buffer" model for splicing.

It would be interesting to hear who would even notice if we just
always used that copy case, and made "f_op->splice_read" never trigger
at all.

And it turns out that the only thing that ever uses
"f_op->splice_write" is splice_to_socket. Which was actually the
problematic buggy case.

Everybody else pretty much seems to just use iter_file_splice_write(),
which does the "emulate it with just a write from kernel buffers".

So *if* we get rid of f_op->splice_read, we do leave the case that
really caused problems, but nobody will ever care. Because once splice
only deals with private buffers that can't be shared with anything
else, a f_op->splice_write() that gets things wrong is pretty much a
non-event.

(We'd have to look at 'tee()' too: I don't think anybody really uses
it, but it does do the "no copy linking" by just incrementing
refcounts on the pipe buffers. So to really protect against
splice_write users messing up, that should do copies too, but as long
as it's all "private ephemeral buffers" that get their refcounts
updated, I don't think anybody *really* cares)

TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
a big simplification.

                Linus
