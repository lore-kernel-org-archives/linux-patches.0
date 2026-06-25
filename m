Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227613CEBBA
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 10:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782382301; cv=none; b=amkHR3FI5SS7yx/AJI/9/RmjySKZpmR/mo9w/3FiHJfvWSwUbaS0XYNeZrIq2GCTD6F+HOXBH6SrEDLS3CwIlUxGSIEQd6xOsK6SLTn1Lym1gzNjCX9EJylylNV8/F9EPrhCWhsS7bMt83vGpcONuuecJ2V6XaZlfu9el4BzMvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782382301; c=relaxed/simple;
	bh=XGh9YDm1F7Whc/NJ9BuaKR7akM8txwMpeQmBzjBxQ4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILPvbBprhCCnGiptpLE98g0hx5x0uk8f/lr3IR0ni/D2eT4AktZlROx6raSg34mt7ok/mjatOzTogzUvpBhvXRdNSd/QIX3OumeROfVsB6FnZIOVKslVyASdYnw5pfaaZeM/Q8IgknQ2kiOAT5JIv+he6LlDEnneBWTSyJ/pYII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PhiYxVIU; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PhiYxVIU"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so20188165e9.1
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 03:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782382298; x=1782987098; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELq4DcsgmxsG/xQ7iP6tdp51y3PfpvNXYbA2lrH5JcM=;
        b=PhiYxVIUsmO0BHnHFh95B+gvBaIeCjPKn3dRxwFlo+Q87ItR9spzL6wcg5n4stzgLL
         Rx/xAeU/cH1IAdpwaWxyTwfZN9ElNI50U7tbtbunaEjGnBSKrEfMvaweJu7WM4tb2XoY
         MJhrJf4+pG+M69WCnPiFQAKVbkfqCNZDanBK+56p8tf3UMbYrxbnrBEn+3zZmDJ9ogoW
         cn4vPqJth24c9+G04Jdp5V7mhnjpMFgJneRSCCvwUoCoYNaXh4P7aYUKbeXg2ZKlIfts
         T30Vtj5EH8FzzNyXg6sAHOOhdCk4nj4R15cQ2kH4YUIWaHalpNV32WdzGykQpqojxywM
         qRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782382298; x=1782987098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ELq4DcsgmxsG/xQ7iP6tdp51y3PfpvNXYbA2lrH5JcM=;
        b=lZ2IOHVXSQGC1oetHnzcZKpkGCsEFuSUuEy9c72C2xl0A6PF07X5BWEmz5Q0VLChmz
         NTc8+SvGp0pYDWXAGVbKFzlRSo5JfpohPkRnkxDdV8er0l4bS7Tik7r3I6zWmeGbAjR6
         krthGD4aq60fvoRHUyPMVN6KmIdTgiR3+3uGO1FlnrRVtoF3UoutPy80anXU+0w3Kwup
         NfzhlpZwMtjDkWsy7f19REmOxYHnXEvYheCaOn+IEjgRz7H+znGzN3Z1lxD9edtHuvWk
         6PfOzovoRP1qBe0BVsvA21M/ZAKN5+tioDdt6my9nTmydKTDArKZRp3v3fnW2GH5xsqN
         Ajnw==
X-Forwarded-Encrypted: i=1; AFNElJ+FjM7SWzIdz0+fvq5xxZRSLhFRH9/p8PSfFh/dlRTnX1DE1a+jiMCBrTMAZBQJcXcN16ISCnRO@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5MuObYGcIfdXQFspSldwhgDGM1TgEPUCzlAwUE7kKyM3XTPQO
	1HaS4y5m7nOl4LAwCsU34c3g/XncwKtx0X3qf9Rbpvi68H73VwBuF8XL
X-Gm-Gg: AfdE7cmbfCTBiI9PZ1i/k6YC/XyClivo1OeqPGdZfIRDMqQCSsNYGgMTvqoN6vbOGOJ
	XKtkT+JwyP/R4574Yg3p2jEuNwhyNDj59HH8AYZvNfAvMsf38RBDm/Wyl4Zw1qoVWVqNL8ZK6Dp
	J+X2dYP8N+kgHvP5gu4FRX++CI9fFOgPXPNh8e0CFvGgCVrkrzONckpErbOICjvvGS4yC+oGE0i
	/a9cT6+onbxmoF23cMDIGVFhsyJX6T36QeHYRk9iaeM36OaIL/lj9sDzdqNoU8EMBiAY6dY+8X+
	hK94x7Zbbt6yxjBig+yo0TLBuFEq7IUmj8lRJ3j/qwohLlT3sTXxfvY30b2NsEJ9rtgW4XGoUD9
	9LF4ENvOuHpc9xhlZFZrxZASRSC0ul6HvFVpDzwEs40SKLWBDiliTRZVVEjuu2AbE2qzhORDKAn
	BRqRKsHrOE
X-Received: by 2002:a05:600c:8b53:b0:490:9d1b:f086 with SMTP id 5b1f17b1804b1-49266864977mr24965995e9.14.1782382297752;
        Thu, 25 Jun 2026 03:11:37 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4926417f0c7sm59950125e9.14.2026.06.25.03.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 03:11:37 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	avagin@gmail.com,
	axboe@kernel.dk,
	brauner@kernel.org,
	collin.funk1@gmail.com,
	david.laight.linux@gmail.com,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	kernel@infinite-source.de,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	luto@amacapital.net,
	metze@samba.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	val@packett.cool,
	viro@zeniv.linux.org.uk,
	w@1wt.eu,
	willy@infradead.org
Subject: Re: [PATCH v2 0/7] vmsplice: fix some problems in my previous vmsplice patchset
Date: Thu, 25 Jun 2026 13:11:32 +0300
Message-ID: <20260625101132.3859505-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
References: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"David Hildenbrand (Arm)" <david@kernel.org>:
> I think we concluded that we cannot rip out vmsplice that way at this point, and
> I suspect that Christian will drop that topic branch from -next after -rc1.

I think my patches still have a chance.

On fuse regression: I return EINVAL for particular combination of
flags used by fuse. This causes fuse to fail-back to non-vmsplice
code path. I did Debian code search, and I found none significant
packages, which use same combination of options.

So I think I was able to deal with fuse regression.

On CRIU named fifo "Not supported" regression: it is handled.

On CRIU major performance regression: it is NOT handled. But I still
think my approach is right. (See cover letter for details.)

(I wrote about all these in cover letter for this v2 patchset.)

So all regressions found so far (except for CRIU major performance
regression) are handled.

Other option is to introduce some deprecation period (as
suggested by Andrei Vagin). I can do this, if needed.

-- 
Askar Safin
