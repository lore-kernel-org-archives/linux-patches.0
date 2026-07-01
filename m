Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D84A37997A
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782878484; cv=pass; b=ui06rI2+8FFRSVh7RJr+d48ewBQ/ZkR21xkeg0ZhWhdxU1y2UA8BUuBKvkx5meogJRq7iCe33T+P37nHAJnAU8zT+p8mQosAtKGDmiyAs/oljFefSBLeN4/iXpL8ko8Az87k9u2f7o6XNEM440hU9dThDMJp4AeoeR65hsCe0AQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782878484; c=relaxed/simple;
	bh=nbcaEzsRX9Wd5cutUSGHKNyzPWPZ9Pa/dME/ipm/wTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sF/vFt2iR/YYbhbQ1lgOfB5YBXLft0j1DPuFncP3HjvUNaqmrjp3NnqJmDutbGStIGlxXajjaS556wCvkUamOqDwnK494D/dOe44G6sBaJbgLa/miBh5cBQ2IJXyZ+8dG3RojFJ8UVdfusiM+LtwNIf3kI48Pc/Fn3B9eN2VeIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HrztMUuC; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HrztMUuC"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c128c8c7a76so40626866b.0
        for <patches@lists.linux.dev>; Tue, 30 Jun 2026 21:01:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782878478; cv=none;
        d=google.com; s=arc-20260327;
        b=qQWhWtwPpHnnwEzX9xdATrvkMv7j30Khvcb+aq1n6/t76UyvE6+Y2/Z1bkmlUZuN3y
         qAELZ8DFVJJKHE7lGQSxQVQ21GRkKWQfqWP4ahmK15HJDxNlPxysZgxrxM17nIj2mo38
         h9d6yZrOWrnKOEtiCU+i1EZmMXBhLedQnXyiM0/DhR14Z0B6/RdC5E0RAlT7fteaqJ9S
         rJsZgeeYbiXu+dqaqKAenuGgdhVvnNYeOrU7jMwUWyPIHCKNpBrDICXD3xUFQKvyyl98
         M2yLdTnAdbXE1xhW5gM2jP8xv9FhPID8Nn8z0ibXlAbWiUwgVOqFEEbclR4ZiRxQISNv
         0TbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nbcaEzsRX9Wd5cutUSGHKNyzPWPZ9Pa/dME/ipm/wTw=;
        fh=BH0icH/3pTEgBetO2hsJE5bTlnE5Kr7s7S1rePNZFMc=;
        b=Ah6mVtX7HmSGERo4Jq+DRUcNDxpthy/Cp6fWd5lFEgYfn6VjDw2biSzJvkq16cDv3I
         euPKJ8WN+3o1kXWeZFX4dlHw8oS1U2iKM9bz5sIqHFbWZ6ffON4cVGEr9CwjNWsA7sWf
         uyiEpRKlSc8iqacR4hjhRLInoJpj0Q2R6kJhRZPsFKv9LJCfX5djxCyYZkGdY8qYPGJD
         5xuM6v2W07Z6XBeUT0HRmoTmzEbkioVbIRbHII6aPRhwlhF3pJpE9uLw+123DZNELcFT
         7YtK0zkvdguAKW3K3NzevTMkwaGerz2owFstqb0zyJzjT8KJuS8LTXjbYAbzryGzm7/0
         v9lQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782878478; x=1783483278; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nbcaEzsRX9Wd5cutUSGHKNyzPWPZ9Pa/dME/ipm/wTw=;
        b=HrztMUuC2ldsrEnyI3URml0a5v4CnSvu6crck74IOYVNkSfnNt1DFbzbBvLJLSGtOV
         uzW++8KLaHngXXdCWrwpZAQIzTtMgx0Y0V/RveKFj25ZHfw+1yOJVKBKr5Tw43IX0rjW
         l/eCk3QLq8mY1BNRPB1XioUFixMlIXgHZBRPmFsGa4ztCgmqTuwJQjAZ11klsk1Mmoj7
         NEiqPsOONmQMJXdWuMtXeLBd37yhE1xWIVfs8LQDIhcy4gyhqW+ETICMKXivW6U8Ea1R
         zJqmVbX35L8mDDyq2YSWR1jkAyluYo4IvvvjrWt17xZhHuVWR+Nyq8rIARhb7w0fyTcs
         8dYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782878478; x=1783483278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nbcaEzsRX9Wd5cutUSGHKNyzPWPZ9Pa/dME/ipm/wTw=;
        b=h3zppwBKuzn8NVt6eD5450kdm7uk1gXzaBNLmK7kR+uprGByy+MtZl6VvPw9FTGPMq
         H9Wx1IwUTPMHJNyQ4pGwb82F4YpxQDRcc4nWlh2QHytMGCIWVfwn2EbzfdL+YNGqJ+mJ
         6S+6pggpXayXqqq1kXba15CLQZoIj2FpxH+ddU2kvDFo0v0Eb/KWUvgBLf7AY+Gd0YBx
         va0hWmN+l/+5iEJPlLlvQhm/9Q+0PmTTzZm/wCih6SER55UtWriewZm16v5ws+DPjTxx
         +Hxxe0lJ6Lz9q3eOyZpdo/Vf9vWzwqHINZ5iFhDBRJfOBGSPvS57lXL3eIqwQk+PvG5e
         +sVA==
X-Forwarded-Encrypted: i=1; AHgh+RqETpV/812ut5orxeES00quKuRdVNg3GxvICd1uoPxa/CUV3wy/ujYT5JCB3Wp/ZE8PlcDRwlAW@lists.linux.dev
X-Gm-Message-State: AOJu0YyJduzz9BTFzUolyPHULXjjfn3XIZpugQxFOEdmIG19ru+bmi3A
	Uiy5UFOFa4xqalhSSWx5QNFQEv2YvMtNicTnBXUnQyTfDbZhYiiM1BEmyldRFiS8alX5YWpPDfg
	1Qkpm1ngv5hrVj7y660uo5+qmi8w73DE=
X-Gm-Gg: AfdE7clt/X7UN6/XDVBqfizTenBFsMErCd76K2+P6KDy9oSAflBtQhQPG4hhNHgl+k9
	KDW+GYymTiNv3se3lYnJ6byB5z9EZLH95P0CUSR/nTfsVqx3mrOCU+9ZbCKy3axY49q7RJhsIjP
	XB/BQNEofVj8T9+R3JFQGjAy4KnFla7yXEYxRJDCPoH9CGgRrcTGvp36XcJHGkWUXsds/MlPudR
	DUDssGZ48haXMIbx4JSUfcMOKAwNysERcuRLLGwxuT6E9RNFBLE+e7/7/pWO1prfKZkXEW6C2/D
	pt4ULoY=
X-Received: by 2002:a17:907:9694:b0:c0d:7c31:26a9 with SMTP id
 a640c23a62f3a-c12a79b53f2mr2792166b.2.1782878477949; Tue, 30 Jun 2026
 21:01:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
 <20260625101132.3859505-1-safinaskar@gmail.com> <63f7860c-4f5c-4682-8914-27978b9fbfe1@kernel.org>
 <20260629-bauland-knabbern-abgeladen-c0acbfa62cc2@brauner>
In-Reply-To: <20260629-bauland-knabbern-abgeladen-c0acbfa62cc2@brauner>
From: Askar Safin <safinaskar@gmail.com>
Date: Wed, 1 Jul 2026 07:00:41 +0300
X-Gm-Features: AVVi8CdRVGURQNkveI8Kk-KHYrlO3h9NseHLMt2SfGvb89Oznrvksp3ZeC4J-SY
Message-ID: <CAPnZJGAJROqfCWSeeBu31HsE6nmgxVqHTNeC554S5y1Y-VN19w@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] vmsplice: fix some problems in my previous
 vmsplice patchset
To: Christian Brauner <brauner@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, avagin@gmail.com, 
	axboe@kernel.dk, collin.funk1@gmail.com, david.laight.linux@gmail.com, 
	dhowells@redhat.com, fuse-devel@lists.linux.dev, hch@infradead.org, 
	jack@suse.cz, joannelkoong@gmail.com, kernel@infinite-source.de, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@amacapital.net, 
	metze@samba.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, torvalds@linux-foundation.org, 
	val@packett.cool, viro@zeniv.linux.org.uk, w@1wt.eu, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2026 at 11:56=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
> The amount of regression reports that we got in short succession doesn't
> make it likely that we can merge a plain degradation.

Let me repeat: this v2 patchset fixes all regressions found so far,
except for major CRIU performance regression

--=20
Askar Safin
