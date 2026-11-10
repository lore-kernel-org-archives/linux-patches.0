Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794271226;
	b=wbImjObyMdxjgQm14YGEHImCp9UBM0Ixi9vD5Ejd52iaaJQ26ALw2N2AP6AuuiMyXbbY
	 2yOy5H1JckgSD6xxL3qCUHNC3hRNEEiIRc1JISLSHrynwuhJnvFtDJDYySyEyheTCrH+3
	 tLx1tcjItkAABjqmWjPmnGbpHyCRp0vqukO+IfguXZ20/sDT7/Nr2oEkuXU2PQ6Rps/ru
	 Yvq4BX0/DcZf/0m7XS3GXfEJG86K0WC9rDJjw9y0bBa03Qj6nrKcTL888ijdrmG/SNdRY
	 G8UYiDo/Lhbi8BPf8z2E+fIB/B6fISN7L9KPh0PBGL9SmyQrXbu51cr2J0cWE013IbA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271226;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=jIHm29cyLSNyacJjUA9APKy30FWwePpOgwq8IJn4zQs=;
	b=sE0pcIB3sDH//2ZN7/j5/wVVYiU4lxwW8i6v4dSWELhV+vfyvideAX/kCXRWpPWvLCBt
	 3nRt6d3XdHw5L/gC4ZDg9GAUlGJvL38Ge39zfTFEhOSjGhpWSfdUG8aHxbEfIuRtAFT4b
	 hewkNxZNvdwDjn8JlcgiLp93hib65A82COL8zv4un0MecWvmhey8dhtVcJ/Hv09W7G9MB
	 H873c+A0k/3+6qHB/6+zDcTrKSjWJWiFrHdtvbFtivYjv8XI25hqlUTcaN2/DEXXNL6bW
	 esbWVtUzaCtpiqJP/Nk66vHRd9qkfgInvf0AUr6hDvukbUgXXII/DCj0A6THc0wDIsA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X9fzjnsx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.41
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B677C606A321
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 00:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B677C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X9fzjnsx
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-67583c777abso1852524d50.1
        for <patches@lists.linux.dev>; Mon, 09 Nov 2026 16:40:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794271225; cv=none;
        d=google.com; s=arc-20260327;
        b=GqMBkSV1i676cSV7Pie20+MPUKkLnZseSHrKSIRWUdG3tCTLvd/kYj7Dg437WkGiS4
         9FxDDuc12erFoR+xAQ4PL3NJfGzIm17wzD62JI68DstXfkaTuRh3gA0ZvFu/syGp3Xci
         oeSxoL+U97bZQE+zB8N9nfl1NwQNjnIr4U0Jr0xdwfHYVQxR/76MmazCUun8fcl+j7sG
         Iyiw9UUfC1HeBvgOXUvhj9WEVvKWh+Ff90XuWR3049rK/uO030qlXBfrFUiCbRHB0mI5
         T3XgO7x/OOSYq3KR0VTpqyWmvdMkQoCc2w1T2K1iiZTqA2CjR0qyeOVvjPkRTr/ef/q/
         Gc+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jIHm29cyLSNyacJjUA9APKy30FWwePpOgwq8IJn4zQs=;
        fh=oBNfpgZORKDRdtHDaOnjcYgaaQRWCEzTqVfwkQ4Xcig=;
        b=L+a4a0Yc+5zIO2J6HrZdf7MH7vgptsQeZZYy+BU7PslGL2BGNpMB5N/Yrhu74QK1u3
         v5BfkpTJ2DrnEn3raAmpo1gcKaK96EEpIoxiAK2F8RyFafmdKHDljCKzXIhlYNs+LT9C
         2ZHZvo6ChkZCb89qrQZslE+vkrv2PMLhHu3UxsqJOuC8/wKsRtoTjTxcK9SxhrrAf7qW
         fxZPbpeTrZmCyaofPcpLwcRC1jYmuiDpK0Vea9iV4gWuIi8JFw/gSwZ83W2dJYrSp3O8
         3A9C0bT0IFE36BQYZJoGRBrK/AQR/Q5WfF7f6cCfnHq5rfdns4C4EoPNEmivTWlHwVJ0
         RTsQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794271225; x=1794876025; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jIHm29cyLSNyacJjUA9APKy30FWwePpOgwq8IJn4zQs=;
        b=X9fzjnsxhqM0S58s96jozhIZ7xxnAWXdjswFTf4tX1EbtoctwBy1iwu9Fn+qnoy7zh
         HC42qkdXY6OorEaZNRsMLC58wjMyJVk1jwIWaE0LCReIE1zHLuIuHwtS4pOszt+BJH9x
         XImtEP+qqAA4AK0CzYSJHBzJ9sGO9ZYwuHFbiMX5Gmb8EfaPtRoejzHaavkGLm/fd9VH
         wfh0EZufpjVajKuQYXi9BxKAAiIPltQ0bacuf666ih0rFDYGO8zk3SLtgYvmOaiNsT3j
         q0cdFxSTHAcYfFy/yzR+eQgKyE/jHnBQcjNK9RkRM30rWvzd6nlzixSqlNUvxren4a3o
         udUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794271225; x=1794876025;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jIHm29cyLSNyacJjUA9APKy30FWwePpOgwq8IJn4zQs=;
        b=K759v64olcPkm33dacgg4z/yG7uBsH8D9SgAPedGe5ChNhO7lwjPsKkpuTG1AdLgfv
         f5WLvwJOQswmKngDK5y7Y8d+u6sudSZOlEfXrlLsQq5nk44rjOAeM/G/XAqbi3WNRU25
         FHyHCJZH3J8Kb8QQCSY/3huaQj72S/6wmHfKXr7YyIfSnvhzWPv2BlNivkimQtzd07zE
         TERhXWkOAeVh8mz1Lk204UmN7fWMc8EfdyQSz0zdnmuVMOYHvoQvjgRAY3Sp22mpaxk+
         KIXzGSCwPHW5BvrY26d0iUzV8t6sA3sYNrHEjYqdHJFAYzfPQgcGBYinaHAFOnBhVhu4
         1byA==
X-Forwarded-Encrypted: i=1; AL+hErGJAIyhqaQ1Rm3C0mPFAZhtCfxHMIAcQ4bKMFqTiTgQ34MhxoDqY1CjdD2EdRaiXx0wBqUfxIpX@lists.linux.dev
X-Gm-Message-State: APuU4Z/koYr4/8zspxwhXUKmkgJYY0y5a5uX/ZujQrZyBM8wPvF5Khc7
	jPG2EwfnOa+Qx+2u78JFbgyLQ4Q3US14Tq5XdQiyvXm5Ixs+lxLdHTQuM3tV9IJH3StUd9V+qsv
	5noZJry7poJmXA56P4WLICizq09T+z+Q=
X-Gm-Gg: AYBFou3CbRtFkulDYY78vqGBaaAZWGyRKiNzNQyC1XlTVNCo/n5JCp5yFG4vrBRMkSk
	SU0Xun4UutjNm4CZ4I4KCoYQ0gomSHahOYmU0RLTciOX/sFj40y8AW34R88xELVo+B9JbAZtt46
	Veu5DpcUeD3VT6d9gFBxefBcrX6YXX8tuQgcgId9p362Zy0aE1m/U2el8VW2O9XqkjYHO/xsuz3
	TNfmNhUvTEsdqpXaXxk/6urKxW1OGWltXik9BTmulpv+ghFVfxcgoTd2dngBW0K7Cm16YjP9IX6
	A7aaRR8Y5wBEH9kGgXFPVIYCiC6ujah7zBGGYRUghsAQOniBQYgVUx8kQ2o9dl8Vg9MN5UFTCBR
	eI8+8upSrNJvS0FWpLjgdS7m8bPTkFJshXMzTnjQFIDw5+IK0LJMaPpUY3An/Op6JRUqZT/I22h
	FYRHc3d4FNr7tVgT4rCDrlqAAe
X-Received: by 2002:a05:690e:1689:b0:67b:f2b4:5598 with SMTP id
 956f58d0204a3-67c5721ba80mr634363d50.47.1794271224699; Mon, 09 Nov 2026
 16:40:24 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261107134939.482764241@linuxfoundation.org> <20261108040721.203040-1-navonjohnlukose@gmail.com>
In-Reply-To: <20261108040721.203040-1-navonjohnlukose@gmail.com>
From: =?UTF-8?B?VGFsZXMgQS4gTWVuZG9uw6dh?= <talesam@gmail.com>
Date: Mon, 9 Nov 2026 21:40:12 -0300
X-Gm-Features: AclHuK9SHgHcicUs2AUaH2zErP3Dq7iLJexRZNx6FYTyrctQbb6uYGleUviNq6g
Message-ID: <CAHBRX4FXKxphkMUzBsV0Scqo5ZbFryUa7MfYa+6_wD5f_vDh-w@mail.gmail.com>
Subject: Re: [PATCH 7.3 0001/1257] drm/xe: Implement Wa_22016122933
To: Navon John Lukose <navonjohnlukose@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, 
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>, Matthew Brost <matthew.brost@intel.com>, 
	Sasha Levin <sashal@kernel.org>, =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, intel-xe@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg, Navon,

From my side I'd prefer this goes in now: it fixes real platform
freezes on MTL/ARL (TLB invalidation stalls on the media GT), and the
probe/resume cost Navon measured is the price of the stricter UC
mapping, not a functional regression.

Navon's follow-up keeps the fix with a WC CPU mapping and removes that
cost. I've reviewed and tested it, and it carries a Fixes: tag for this
commit, so it should reach stable on its own once it lands.

Thomas, Rodrigo: could you take a look at the follow-up when you have a cha=
nce?

https://lore.kernel.org/intel-xe/20261003222145.67240-1-navonjohnlukose@gma=
il.com/

Thanks,
Tales

Em dom., 8 de nov. de 2026 =C3=A0s 01:07, Navon John Lukose
<navonjohnlukose@gmail.com> escreveu:
>
> On ARL-H at least, this commit adds about 3 s to xe probe and 2.5 s to
> every s2idle resume, because the GuC buffers are now mapped UC on the CPU
> side. A follow-up maps them WC and keeps the TLB fix. It has Tales's
> Reviewed-by and Tested-by and a Fixes: tag for this commit, but is not
> merged yet:
>
> https://lore.kernel.org/intel-xe/20261003222145.67240-1-navonjohnlukose@g=
mail.com/
>
> Whether to take this now or wait for the follow-up is up to you and the
> xe maintainers (added to Cc).
>
> Thanks,
> Navon



--=20
Tales A. Mendon=C3=A7a
talesam.org | communitybig.org
