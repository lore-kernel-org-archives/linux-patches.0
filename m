Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAAF2D7DED
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 18:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770661404; cv=pass; b=HmnSMksKylQ3YyBYjRUxWkFn1ZyOu/iy8hXnt2wFRG32WR5QF0aE/a8whtPaNtsCB5LiECoLIrI7CzZ/7dDkhebxjFsWseBdJeIYdEl3Ul32cLgmnAkmeNkbpWJVqcDpCrknGkokrbhLQ6idZUGzH98z32ffrmU/m/AgPbKrYYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770661404; c=relaxed/simple;
	bh=Ze/Rk5WFcOqujthpZphKY+7Nj1NmEfH45a4ZKRl1LFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=efuUYH5Ped6jZnxE5sFnYrDUDHdp+ko8NkPgZyMQR8lrEiD3lXUAbRJkAgbPoNtpTVJkPeUYTDnuBvv/PE7zaQ3neb5wlzYJ3r1Q9IK/8J7IwMLlfkbUZfxjnw5hXSBQZTxwJZefAy/bR1z+gzn9kXLI1JkdDRN6gcGq8hQCyLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IfcUFemA; arc=pass smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IfcUFemA"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2ba68df3687so2487420eec.1
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 10:23:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770661403; cv=none;
        d=google.com; s=arc-20240605;
        b=KQK7t3jflP9qu2UPIH/+mDwxuE3Ru9JR/+9gJ9ZIe9utj5BrbdnZK5JJOTOrgvJQe0
         yfhKMFOZWkgrJpQSuCZ0SKRq/6PHvCs1EtotiWqqQvqs+81n3heMDIuM6pLbaN4JjKje
         bCTH63F+H/V5kKQrvzMqN5/driPt4OcB30evR4Iy3iRjQDeQIsbzREY6cPcAePMwXl9G
         l8YWW03xHdbzD/R149qamiK7BZxfFVbMNqTaNlJWifsehAHhOflilrp9L279z/kkNq+P
         hjjaMM3gdh89kTDuObXnoRZVvBes7CJoCvTp7Mo4KUfPJErpAN/bsynm41O7Ljc28Vbv
         fxcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sMVaof/1OVk8lLRJok2TPHua87GRlj8RXP7UoaSkwnI=;
        fh=oTwlzBl/FbbzdleRNMRJvDNL6rtUjS5Xjdg/+WL0CGg=;
        b=ldFAgQNz6BfSxZMfcxFig/E4yljVDPYEafSz9L2GbZq71DgdwvgZb6ocYkYb2QuZ38
         NH4lwSJPmNbt6MIIqoCrp6T5bYerUs+0qM4iclNJiUPV5mP/lTm5BiYrX8EKBMpiggTD
         tauP+crMCmh5mMFSp8YGX3VMgU8EN2xd1uzaQi6nAgL/5vTn1Wx9dRd8lnBjlGOliRp0
         ftfUqXwsv9nifKz5WEwDK1rLZswizdB8jh5KVXVvO4wBWYlrQ0SsHs521jwFsphFgByu
         A50H3XCyy4yuIH0M3Xn9QiLw5dHUnQSwW2o6fGUNKTNBm2/g1a5wO7NicnHvzFNdDJPN
         6fOA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770661403; x=1771266203; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sMVaof/1OVk8lLRJok2TPHua87GRlj8RXP7UoaSkwnI=;
        b=IfcUFemAGmcmNRfe2bRZ6M6tgpmp6wPHQJnh0vdEvLmF6dVmn7jdMxFVEXLrpQkULY
         x9GQBLqoRQmY0byH1jdyynH8lDCKJRN9MBt6h4awgH10HSN8yHLGCNuYDSQwmr4lx5R9
         StDv8iTfD2184VXXY/CuBikjUQgUonXeQdKCGZ84ro3b+LV9dg/7bcSjpTamY/LZreYQ
         R1/KBSnI6uidg8+TQeD2KiAzOz2IyHHcCJcuf2t9OW+T70ZAgrAj0B5Ai5oUne9REgmN
         VbcMptUesu5ekk+K0rLgq6D+rGoMoh2X6iQ2zCPgAIWKKksAvo7dCK53B/NUbZ+4AgQz
         1Qgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770661403; x=1771266203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sMVaof/1OVk8lLRJok2TPHua87GRlj8RXP7UoaSkwnI=;
        b=Ezso/DHbzSHebiJG/sG9aoHc5WZ8r55R8fnk4v8YH9Z+YDz/YmPaclUFlmeO//kgVp
         gwF1SEkDm0a2WvJRnnH5ynLmQPMVE4Kv88pjwVyu4Pc/lgO65uLGsPvNq14/QpZ0KyG4
         5WUtsSZphjsRuPf8TtDxDxmUao5nn9fRwFYTwVOtRLspFe4A3LncEw+Sn1R2d5qASh90
         eYNSC4VV26rklp6Y/FbtC9nbOoqCSJ4s2i1Xx8vVNLrJziJhVAgcPr+zv12ccJRvaGe8
         eLRqSPvBxgr3brNAyVPzh1p+ezqL/wyooaDpI6oCPtnXpVzyHnsy2oAXCuZfTTH0pKqm
         cxXA==
X-Forwarded-Encrypted: i=1; AJvYcCXCzPiVMs/y9wI88lNmZ7xM5DiWCmevVcW6hu0u/F9uluf/Rg41GDUFwdkhxrjw4u/gIsmfTJ7U@lists.linux.dev
X-Gm-Message-State: AOJu0YxryLxQu9YndhhB0Nqdq5HoCe8Gc24N4rbtpZa4cxvawUDDi8Sw
	ebQsR2o1pmZY+W9tIJpl5myxlbi4RMGiBRuVuvzQYRvhRY314qRtrcWszv9WimK3CgOxvUDcL6r
	DQ4ZL15RrENKTJmO2zqwYWDK5cJJNM5Y=
X-Gm-Gg: AZuq6aJrZlFqjNPdxlpJsdQ0oHke4zV4xSGrpxQhF4e8GS3e6ybYIVbX41uTSOza92Z
	Mut21xONpTUWdBfGsyNWaChp2hSnxE/sgh08md4peFR6kozU8R133yn0/P1JdDuMDaN6vo3sKVK
	JxPlywb5ZqAeG8VypaiQmmUIrPXQok1IEC0WTiRigeXvR/xqcQMJelPMwywpZeIf4eYj3u78JV/
	kUkyMfLnDaTT5FKu/HsT0gFl+Y7jiNPIwOiSO+uC07WiQk4WgXR1knFj8ahTOF4Cz04wvPejZ0a
	adu6EvCo0Luf63LmB3c7Ukd2ZdlGL3+eOS568ml6X9V5ZzSQRAHc4pD45WKb9fU4Iyrc1TD9SyT
	QdfG4lFZj38H8c7ofP+qhEbFglL3U8UZyezD0kCUkHwq2cdEIFDnrbS6ndDs7aLCBnBnEsJyXCT
	NfHY2fm7o=
X-Received: by 2002:a05:693c:631a:b0:2b8:c1b4:9cb7 with SMTP id
 5a478bee46e88-2b8c1b4a017mr2572950eec.22.1770661402855; Mon, 09 Feb 2026
 10:23:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260209142320.474120190@linuxfoundation.org> <0c7d0dcb-fb37-420e-bf42-7929f7bdf781@gmx.de>
In-Reply-To: <0c7d0dcb-fb37-420e-bf42-7929f7bdf781@gmx.de>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Mon, 9 Feb 2026 19:23:10 +0100
X-Gm-Features: AZwV_Qha5YCQzRf67ubA4-i0FU-1CsrY-YCKhL9ssBpK8maTgChfHYLPFkRtMLI
Message-ID: <CADo9pHjJpiWd+D3yn-zy=wuhYW3YbG3P3hsL91VM5sjsoKnwaA@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
To: Ronald Warsow <rwarsow@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested on: Arch Linux Machine a Dell Micro 3050 with a
model name    : Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz
and works as it should


Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den m=C3=A5n 9 feb. 2026 kl 18:25 skrev Ronald Warsow <rwarsow@gmx.de>:
>
> Hi
>
> no regressions here on x86_64 (Intel 11th Gen. CPU)
>
> Thanks
>
> Tested-by: Ronald Warsow <rwarsow@gmx.de>
>
