Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B9B200B8B
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 20:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736367158; cv=none; b=P7UJgYpukWj1/il1tS31ica9oQzZlXKdx5vkXcH8pGehwkh5vPmgKMsSB4UnueKltdu/GVUyzKYypovjhT567IHmUhB+M3dzVSHTJwFTLmFAXtQVul3UqaYQkVMxrbpD4wj2GYV1tgVw9gbsDz8VLHPbK1oi5/vBmwTjJopbXN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736367158; c=relaxed/simple;
	bh=en9xb+4vR1d1qHmpfGEiAM4eqj6lnh9amgRCvFZCoPc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uVp/xZLL+HUov5bhAli1T7JwFkYbdQy6JqzjVe7vGwHXj2M/LdfZIXBlW32qdjuMttkFv6uIAphXpkokuyyWEt0cy54bIZK1J9TebDNYRdEWvnpnNhXOUm6Ed7lX5vF3TWebCe97iCnS/TS1Jf9LmgSt7Qf0CuopOfTXesK1JYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MFHkiA+O; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MFHkiA+O"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4363dc916ceso8431875e9.0
        for <patches@lists.linux.dev>; Wed, 08 Jan 2025 12:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736367154; x=1736971954; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pJwa6soGDW/D/CQ3ohXXjQgefQaYPFZAUIQrEzDhKr8=;
        b=MFHkiA+Ov/bCarVQzEHmNKqVbFdmvbzt5wlXYVkVn2vi5CyiKi+kCoHuddSuoTJ3dg
         3TjjfoX528HWxuFxnzqFtHaXsjFHTnmxfPQgFyE0PmIdhBCu0pkqmpoqW77bDrR6HoZl
         NQKzEy6ostVn0qYyLkcwl7y1FJaJh8qiOLM25HAgvu6E7SLroGiSdUYWoJZeMVQvfAnG
         EiUYmKGK64kUfENvMnfXeA+hB5D46ysravlWr/M147FhAAI+tNxi1kBNir9PNrJRzQOP
         uWJNeZe6lg7q7Hq5hqdTgycvd8iqJbDDyh9OamuwBkkXdBDXr5jVhgXzqaJhWepFUcmK
         kSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736367154; x=1736971954;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pJwa6soGDW/D/CQ3ohXXjQgefQaYPFZAUIQrEzDhKr8=;
        b=ty8OnRcP/jYazouKJGtHsttOeHKr6UeqOwgmuNcQLmwu21JJKTJ2SpYURzW59kQJ6X
         1FPQfVJeKysLOL6qq+wq4q8YGIORBc6rUl8tBfF0xoI21P+7MJr34LEyV2HPlxSjucy5
         qWHmSG3sccIezumN3QIcxd4cVj5e556nOtACINeGuVGuaWapr1xBVd+86HdsgDn+HPTm
         0l6klq7JW49F1KNhtOL+THlVveuLnHsSwhLcwGJ9Z/p+GcN+GpSaKVDTo1sb+lT/wqRG
         qPO3wlCn9VYK+F+BLW0A7CM4427FE4VGMffHhG6G7AT3lpwED17UCgDVYkOAnjaK6dVa
         lOjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVswfvtT6FW1angAwfDdhPPIZ7q2DOOO56ZxSL9NlkTvz8pQGUzpi8eaMHTQiZikbHs1tWOPM9a@lists.linux.dev
X-Gm-Message-State: AOJu0YxOVSltVdpPfBQdCTkCNnBtrdpvx9yutAvu7QYiIcSMVmnHR15Q
	frS/OuO74HWmdz2UKQM5xWqbwIcOwCBzkL/ky+jBjebB6+cn2iUBYk9rBaHDWl0=
X-Gm-Gg: ASbGnct8ddwCfPXyDqtV0LEW55BPvrIElyggGembQVsYyZSWzZQ/6c7liqHBrq4dYw7
	T9EwpubAhxUj4iMrxVO3l4O/HdBN/SZC7T9ehI0xNX/GUI4CEdShQbhfbO0hvojjDIv5jnLSLux
	WAKcTrQ0wYgWGaz/XAwrEfuH7yFATp2aBoyrq1VkImq3BtgKVygxIzNOVayF8JGKGlgOQIPAxg6
	EuAKKvjDGFGWhwvN71GGYMCcZuV14MAcbWLZv3aw2j8XOscdOfkOGKLF8j47pQbvMmH3fzEpnq+
	3sz0QQj3Yptrb+ZvKgQiCEPb1xN+HC8INgqg2aphnYP1K2MhfTb8dz8JBvTMBVFK97hnsdx3KAu
	0U0X73Q1dT1lf
X-Google-Smtp-Source: AGHT+IFFUuLRuyHyZbtVEf04FLbJfO1StakUQOTMrZ8DLPg3gAtYkaJGhzIv761uiLZWJ0QE8Q9mNg==
X-Received: by 2002:a05:600c:2ed2:b0:436:747d:55c9 with SMTP id 5b1f17b1804b1-436e881e867mr5509625e9.5.1736367153913;
        Wed, 08 Jan 2025 12:12:33 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2dc0069sm32471805e9.11.2025.01.08.12.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 12:12:33 -0800 (PST)
Message-ID: <6f46c75da6f865b04d3038cae8d3bfc6460ad02f.camel@suse.com>
Subject: Re: [PATCH blktests] nvme/053: provide time extension alternative
From: Martin Wilck <martin.wilck@suse.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Luis Chamberlain
	 <mcgrof@kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
 "patches@lists.linux.dev"
	 <patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Date: Wed, 08 Jan 2025 21:12:32 +0100
In-Reply-To: <53p73kfx7akmecsc3sofrmga7o7m32gg2lp7e44nacxgwarfoo@u74aepo5erqs>
References: <20241218111340.3912034-1-mcgrof@kernel.org>
	 <53p73kfx7akmecsc3sofrmga7o7m32gg2lp7e44nacxgwarfoo@u74aepo5erqs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-12-20 at 11:37 +0000, Shinichiro Kawasaki wrote:
> On Dec 18, 2024 / 03:13, Luis Chamberlain wrote:
> > I get this failure when I run this test:
> >=20
> > awk: ...rescan.awk:2: warning: The time extension is obsolete.
> > Use the timex extension from gawkextlib
>=20
> get_sleep_time() {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local duration=3D$((RANDOM % 5=
0 + 1))
>=20
> 	echo "$((duration / 10))"."$((duration % 10))"
> }
>=20
> With this, we should be able to drop the awk script form the test
> case.
>=20
> Martin, what do you think?

Fine with me, and actually, nice. This way we don't need awk at all.
Do you want me to submit a patch, or will you do it yourself?

Martin

