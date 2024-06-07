Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0561527A4
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 11:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717760007; cv=none; b=GO1tv5retWknbKfNXSDQo3tSot/UM7TLZyK6wYRE9DmEiMPbwNJtsgmTG1+ORlaScArPUFav67kHvNp7RZkxJZJlxot4xmlhpIhe+lz17EhgWmv9lQLw4L2yOSJOemJop095fE4uQg5sB2aDGDD7e9jXeCr+US6A1mvTG1VwjE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717760007; c=relaxed/simple;
	bh=2wr+lHAs0v9eNSflllxbXQVFuP35fXI9JtBvHoVR5yM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Oeg7RMk0QaNt5DNH4SpTo4EbjefuAlkVM5Kg1SeO61DYIg9zLMg8GgANYCQ74ZNB3mziGqSzychfV6YheqDE1dBWnDebb3U/S/2tYin0YCPYHZ8uiUWhwpdwErIxwTZfbcCFfI46Si7haIqWYSXTtbXPUgFtHnNvo3KbJYp563A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=UnpWJO4P; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="UnpWJO4P"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-6cdf9a16229so1487111a12.3
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 04:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1717760005; x=1718364805; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xONs9cG3bwLvzUz0akmZOGXQK5GwoaC52V868nn/RM0=;
        b=UnpWJO4Pv3lNs9ncoz9XLXuE/7OdzCEYSPNWw3BRihqqmKzj4udxCMtzlT4b2p64t5
         IHZszoNq+YjkJ5N/BBnEegAl3IDunKTB3k0Qa5sB49BVi9HtVmMuQAm+/bmRqPY7X9Ih
         xTMsFclE3X4h4J4OppWpBVpmaHA2I2RP8QPKpYO+we0Pt1VErFM6KMXnmOFh6lbmmEld
         yIfa6byTL3bqNafljPGod/PNatuIEURlTY4nXao8ZIFsN4Wy3Wx9BhWzCRWSh1E7LhMP
         jtRSoDgnr+zGY//lDZTIbfqv4LaD1X2Er1Q5sWOE1qigjBunYL/+4SEpFyH8eJBstI7g
         iBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717760005; x=1718364805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xONs9cG3bwLvzUz0akmZOGXQK5GwoaC52V868nn/RM0=;
        b=fTTvxy4guNxO5HAmDPeOnmIm+jXfA34AgcjrO5ie3ZUM6qk2+2hI0ltPBBbCaP50Pr
         XO4B0TULK/fK/in2RMnvNg6RCzgXqNq1swIcJu13QrE35/1ywVa3d93goC6oU9O5cPkl
         VoWdbEu7gtju6Yqkk7qgXHE2Q5rPnpZkHr7As+m8pfE3RlW5mH3TciFc+TWupttJtdO9
         /eJfQ1M0kFOZPrfQPFKX1/4/BUdzJrlAnus6YALIPy2UudGbRuCi0+re8vxGpnzGqXRK
         ijG70k07fpLPbfQ5GIWs5hW3l2/BxfWKNvvFC+h6opPL9oQkV6PacmFwK7KawtdqGXzv
         HCcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcaPfeuEo6LTyUONaLUFiDligOmV7pDGG4r8Skd6fyoc4hmdXVGBmTgzuSHaufMUMfEvVAB1UPcLyp7nllwLgM1T5t5CPBYw==
X-Gm-Message-State: AOJu0Yyu5FPCMElgxsJUIkTv7cd0g1p0wA+Ku+SNzkGRybNwyR+1LuoA
	0JA94w1KSea3+eSmSLJlZ09CjpVuX3NpDeJwWdCg0/xEybPTx81dCcdDH54rWJGgR6K3v5OI/ZC
	p2ieJ0nIwxXntrQXaMMQzLB7reBlg5j6YAPUZgw==
X-Google-Smtp-Source: AGHT+IG7+ZIc0p1zJoLLk91skDbqRsWdWPxDuKxxght4BciIei9F3bE1Mu7itn3uqV0BQDye1Nze6/TKU7qLlbcHg+E=
X-Received: by 2002:a17:90a:5207:b0:2c2:1d0f:3c6e with SMTP id
 98e67ed59e1d1-2c2bcc6b446mr2113104a91.37.1717760005426; Fri, 07 Jun 2024
 04:33:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131732.440653204@linuxfoundation.org>
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 7 Jun 2024 20:33:13 +0900
Message-ID: <CAKL4bV7_mPSr6FKH6j75hsHiOG-Zu20+rotzG4uU04qz91eAJw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Jun 6, 2024 at 11:18=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.33-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.33-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.33-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240522, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Fri Jun  7 20:08:16 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
