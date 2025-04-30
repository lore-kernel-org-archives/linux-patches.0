Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3C4214A6E
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 08:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746000774; cv=none; b=dfChqBaGT7tf0n8Sm3tveAM4OZFPC6w+Hw55BLtg3DWz4NxCKboz9b2/Vi1ka7XcYCGElrtsNDGg7AZ/WzMN8xMQZNZcJRQbuM1o0wn/+b4ADxEnK8n6dV/c5mbxkuVM4DbwnINgZsoTYJooai+8NiadJHD+C7nINI4+s6QC2h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746000774; c=relaxed/simple;
	bh=PVtnVO7GXratpyuATMxm8/jjsqq5vOvJJL/vhUNPcBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jChtvYuDtyAo8KYlj7sWApXN5Rep6t9jPIeK+f1hOiMSvWPd9OtPNDIEb6G432VeIJVViC85SSrrxA1mTJRXFsJ9BxN2WYhVQ8JK40MB+iHOsq9YAMqOpzbxb24/3JnOW9Ov98uQ1TdgfYH0HjtcYKgQ2wZUWjjojx//eCCTd7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starlabs.sg; spf=pass smtp.mailfrom=starlabs.sg; dkim=pass (2048-bit key) header.d=starlabs-sg.20230601.gappssmtp.com header.i=@starlabs-sg.20230601.gappssmtp.com header.b=k+a8B4g6; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starlabs.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starlabs.sg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=starlabs-sg.20230601.gappssmtp.com header.i=@starlabs-sg.20230601.gappssmtp.com header.b="k+a8B4g6"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e61d91a087so11019541a12.0
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 01:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starlabs-sg.20230601.gappssmtp.com; s=20230601; t=1746000771; x=1746605571; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PVtnVO7GXratpyuATMxm8/jjsqq5vOvJJL/vhUNPcBI=;
        b=k+a8B4g6qZDrzY0EAEJZR5d1d6/m3TL+fnup5bcOQTvFy6BkZk5XY2fiqBmyxvJTjg
         /7uhiwYwkdU4MlOK89esAo35xsq3ICKbuI6kPlz2mmaODIzHmw93p1PRX9CCNl6PUCDs
         rzNFOJ0Y/ua4nhu8evtbLbcrZI1Qu5uBOVuOgf4y+UDJnmNjH/pElP8SjuXVkRn3qymj
         iiPAzDWrAq/I8IMZh6KogUW9eQujP3tyIr61bejoPvBV2iVvSiCfuKq983U4xH1PGlb7
         b7d+8vGDe7BhzrituSZqYZ2KsFEUb5F/5DMafb+YDWS44eXQjiN85LnPVkNYkz76Tgpd
         Yt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746000771; x=1746605571;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PVtnVO7GXratpyuATMxm8/jjsqq5vOvJJL/vhUNPcBI=;
        b=PsxCI6UUGWHLip+RWACOaqDWTb0ilP15jHej6d2G8baonPkqTIQMH4yDVgnz5liPTp
         jPEWXlHiik3XqrhhQy2MWfhFen8yHL1IYzc/YV/ogRq13A8mpEDnDfLxQr/7Q5/+AA3q
         CwlafsSwY9ri9VcKkAuGc+OcfJpjNVZ4s8477a6/9zMXMaSTMe9Dc/m27X7YAFohvfb4
         NIOn7tAEe2Xjn5CaMtkpN7+wA888NkuRaMiTj0JC2RBBYAY5uotaCJ7r4WHqxNnsM38L
         ZaTcas6W8a7BaNITiVTcWEpOrhB05ihdnu+BAHc83AjEigMEkwmC3X5lDi/S2iCAEpB3
         CXww==
X-Forwarded-Encrypted: i=1; AJvYcCVv7+2fubF3GddTPyYs3WPTJInyub6Rv56UQ1dUWk/EhZWOFohGS8D8SNrrFzbNOBzdFmlMzigA@lists.linux.dev
X-Gm-Message-State: AOJu0Ywxr9VNWkLCRsmgLyWiY7dIERrR0Os/FXhObl873yPzdANHnV6R
	Ri9RYM5VYRFyACGL8LXeLALshtInmuyoOXm9UGG2euwKrGbKnaKs/skONeW18OglVn6pN+doM/d
	lTydb2bKXW1pcZfpKm1gGuxzrYGNVPSvMNF0+Sg==
X-Gm-Gg: ASbGncuQcLlnEaqN4SVDtukDuhNTGH1mqzAmOtez9ewgMz2sQ6hPBsLc56T0/A5ZaKk
	t/O2VGQr4rZQgYzsJyfHRCE57A4sTFMLatQSFCgS4v0Oe5HHw0ZlaRar45WkSAAM6llYdrQFmA8
	XFIVVV8NefhiMDjBaf3SUUf1n4+p+Ovc7j4GM=
X-Google-Smtp-Source: AGHT+IFNWjxWL7Dh5ql/e4L69Pv2wTSo/Ar8t+DCb6Y3X8ZxuWGrWjZMPBC9p7z9Uy0oMjX3PneNQaawvUn1sMJ6Z/w=
X-Received: by 2002:a17:907:7fa5:b0:ac7:7e3e:6d3c with SMTP id
 a640c23a62f3a-acee2605d08mr158531066b.55.1746000770815; Wed, 30 Apr 2025
 01:12:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429161123.119104857@linuxfoundation.org> <20250429161123.269149769@linuxfoundation.org>
In-Reply-To: <20250429161123.269149769@linuxfoundation.org>
From: "Tai, Gerrard" <gerrard.tai@starlabs.sg>
Date: Wed, 30 Apr 2025 16:12:39 +0800
X-Gm-Features: ATxdqUFjPnSe0IzqLH6r7t0V1qG1afdCoVRaQ9M8lCRx5zfrVreULKjiixuLTMw
Message-ID: <CAHcdcOnHVSAF9DOjGqSWrZYiS-5LyXHimdVou6zf-6zZyvZhPg@mail.gmail.com>
Subject: Re: [PATCH 5.15 003/373] codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Cong Wang <xiyou.wangcong@gmail.com>, Simon Horman <horms@kernel.org>, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

I have a question regarding the patchset this patch belongs to.

I saw the recent netdev thread
https://lore.kernel.org/stable/6fa68b02-cf82-aeca-56e6-e3b8565b22f4@applied-asynchrony.com/
and noticed that for the patchset
https://lore.kernel.org/all/174410343500.1831514.15019771038334698036.git-patchwork-notify@kernel.org/
only patch 06/11 "codel: remove sch->q.qlen check before
qdisc_tree_reduce_backlog()" was pulled into 6.6, 6.1, 6.12, 6.13, 6.14
stable. This was to fix a UAF vulnerability.

In this case for the 5.15 release (and 5.10 and 5.4), the rest of the set
is once again excluded. I'm not familiar with the process of pulling kernel
patches so I may be missing something - is excluding the rest of the
patchset intentional?

From my understanding, this patch depends on the previous patches to work.
Without patches 01-05 which make various classful qdiscs' qlen_notify()
idempotent, if an fq_codel's dequeue() routine empties the fq_codel qdisc,
it will be doubly deactivated - first in the parent qlen_notify and then
again in the parent dequeue. For instance, in the case of parent drr,
the double deactivation will either cause a fault on an invalid address,
or trigger a splat if list checks are compiled into the kernel. This is
also why the original unpatched code included the qlen check in the first
place.

I think that the rest of the patchset should be pulled as well, for all
releases.

Cheers,
Gerrard
