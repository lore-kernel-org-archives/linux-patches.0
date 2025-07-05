Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407E84C81
	for <patches@lists.linux.dev>; Sat,  5 Jul 2025 00:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751673877; cv=none; b=J9AVIdnXbAxvZYKQ8ktLJi281urvkEUtS0USkKKyUd5s2XBbYhFFLHsBVwCblcqw8sOlfn3YjjJMygapKFFFx9q49Lg4JDAxZe1ChZ8+yJTU682VNFUrBp8FPAJkMW9+FZPv0tD/UVowmY/xzuRRwedNMN9LDw1ArYCYeXknKvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751673877; c=relaxed/simple;
	bh=cQn9yrpoCKxPpNPYTaDD6vWUrHb9Ycp53SAjECtWP+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iBk1Zxhm8BK5hBYsLeN93d1UygRR9nBejYlo7K4d/mvDPjPAKVrEnaYBuDxd7wBrxD+emwJ8hlqu8pCGVfhaxPwHvXDq0Q6PpVXILYp6FSbkjr2frA12NdZkYCzb0kQfz2sWP9iG08O71D1/4ASOvVdmuniVNnDNTdv+qrSO49U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=DlO/ONzE; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="DlO/ONzE"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3139027b825so1046775a91.0
        for <patches@lists.linux.dev>; Fri, 04 Jul 2025 17:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1751673874; x=1752278674; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YohGG/02x8hX9vac+k+fEJpcSYnH2Xpq8TxgAOM+wZk=;
        b=DlO/ONzEHCEiJU8VZ+KOmehkANiNDN3XZ+4GFBxxutttJPyv7XWHvDYOO6FyA0WYb4
         pBIxbxGGFcE8Fm0xLJmmLC3uTCZxXqVE7aTwsJll5xqfdTtGiOtNXiBceBpPqKMtngcF
         P5C9aHcWBIFOVmMNG2xkWCLBKGQynnKFatcHSN1XWFOOiqe4wrnb0nCtA8DpFCsZBoHu
         CzVArb2kOfmREqKjVMPrHqa10PO+IqkmDbO3ysuJOlsTBwjQ8+KykQXeT2Bv+0KWDjIR
         c1WdPgzKPTlK84sBK90nYJOls7wQxc0JufTpHbqTbTyX6KixpTOohwc5ETeYOUh7q/No
         n/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751673874; x=1752278674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YohGG/02x8hX9vac+k+fEJpcSYnH2Xpq8TxgAOM+wZk=;
        b=karlmTQBfIEdociAEEOZv+fqp6gDnyX3pJNWSUQ9UE0gWaUkzqs0dN+WffHZwykV66
         2w1cU9Jq/cpf8QIwWBAVJNUEaiznSLmjfyoQlPup2bp3DWeovERzuna2yalNTcumFsEJ
         m8FGYJXBzjE+iBMfs/X3QRaZZEUwvfQBVUKXzBYjgd/lGLHest5jGArLiqW6hgmwzT2g
         gj8x80Vk9DdOTMj+nllx8mNAGk1dn2Q4iePbKFRLMMec1Waiy7sTZ7OaDzLLIpiJnea0
         eSBqJtmm7Y9go/qy4fV958mC/vZGMxVqeYIRysJe9D7zPgbQdDdlxVC4x86zWgBytled
         f8XA==
X-Forwarded-Encrypted: i=1; AJvYcCXrDtz/6HjGD+XcVJU7HLHPL4zE+zdktgAB7DP0xGVT/ncArT2syy2JnqcBBVQEnpDsyu9/q2dQ@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0A4Dty+PEnWpErPHAJ5f/B/r7YplZLOeioB78SjtzBDV0JrD0
	Ub6Y3iZZFeDswx1kA2V9Pa0sL8J7j/ipAIIQlhVyGOQwpesyjBIwoQOGF9h9LiFV0omcx73c3Ok
	jHMM6lwHjyRG12a/IQJ6SdENUYhdlD5xtUzG7XjGBrA==
X-Gm-Gg: ASbGncvq+3GFynv0gP6i3cEHyNsWuvDUXLxKw4vDJXkTWDaKare6Q7/npnplaZeKvQh
	tnGvr4S+r7EexegQdDvqpF1r7erjm3ASenP5ZM1yrkEBgl3HP49ftVOkdOghCT5fcvVxBDiG2Z/
	N2HLidgXyetj4k3GW6keMvqZp90OqeEBD9CDLVjVU7/ak=
X-Google-Smtp-Source: AGHT+IGf4zn55xJxNO+Ei2qbAPwEWfllK5AnE9LbEgnFHbpPBtwWNXxG6wc9ktZ1haf5oyrsvWhN4t1nDjOPW+/SnXw=
X-Received: by 2002:a17:90a:c2cb:b0:312:ec:412f with SMTP id
 98e67ed59e1d1-31aac44cc39mr7095613a91.14.1751673874549; Fri, 04 Jul 2025
 17:04:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250704125604.759558342@linuxfoundation.org>
In-Reply-To: <20250704125604.759558342@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 5 Jul 2025 09:04:18 +0900
X-Gm-Features: Ac12FXwD2bbzcylFZR2ONQNxm2E_WZHpZHRmFk4o3eqUNd6oubOnm7i8DFF4Oi8
Message-ID: <CAKL4bV7GRQZ7pd3srCr-KEHOJbs=Z+pWsS99Gadpgk5LeXzhgw@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Jul 4, 2025 at 11:44=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Jul 2025 12:55:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.5-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.15.5-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.5-rc2-gf6977c36decb
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Sat Jul  5 08:29:06 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
