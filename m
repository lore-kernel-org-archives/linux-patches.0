Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC3E3E557D
	for <patches@lists.linux.dev>; Fri, 28 Aug 2026 08:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787906642; cv=pass; b=vD5U97LzSXC1UxgiqT3fznGhj6uxtg8jwri8fdnvaJMX/1AaFIzXwnuq86pcAGr3gyIQh5RP+ejjpFkUbuo72/XaTZ8fJ/iKEetGGyMGWJXUbzVUIdM+HLCn01WmnwSPBDho3eaVtn9uBNHxH7R1cJ1YsdRdsmCr4cblosDI9pU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787906642; c=relaxed/simple;
	bh=+SsljDUXUlaGkl/5WsILjVk/5Y4d+UkaNdguJIKngg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rDbHWGaVeS4dQpKSBwpaSMpJCkoa6TkiwYT5WbFEHuDl9FghgO/JfQj0y1882MnFrUXnOywltJgdlNyV/XCEpVpysk6NYt4f1xTq0OJUwWYUqIxlUKd0F9IL/5RvI1+pXFSWhqm7vKIQ6qMCtHTNJhE/tmTSweH+UvA0fDeZRFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eHHjufBe; arc=pass smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eHHjufBe"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3a2b4743936so6333451fa.0
        for <patches@lists.linux.dev>; Fri, 28 Aug 2026 01:44:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787906639; cv=none;
        d=google.com; s=arc-20260327;
        b=OhHve3K+S1nRzEAp2QkAI2awfcfV8HOXmVXoQfKcMEkt5+q7GLH9orRZj/AoZQbRNg
         xb6glIEW3tOdS77VpibVKwbCsLzUuo0zR1F9xh7zIV3aaI6YOJCrZ+XLU3tS3xi8pu08
         yDvly9A4qEcwXM5i98hKNPiXSEuACU27iR4fKK0RZvwo9vpVg97Rpm6wSInAmEv9vxeI
         g0pTur7VoPF22EF9o0nUaMMPdQQLna0i8iauWhjyZkDk7MNutB6VZOyMCtMeTlHVr9rZ
         VFdXcGEfMFfLmjziPsnA1kVu+tVKSuaOCf64NWB0R6iOBOSKaqex05JMeNFpdIN38z7O
         vDcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zhsiaAmVjzmzESFqvr2tri1C/08hg86tA9bCn5YqmwM=;
        fh=Wu8l3ZME57g5L6FctVNlqwxd4yU3KaQJv9kB42ah4lo=;
        b=Nt5/tlFjAeUzsjqhoHQi44Cxoguqp8GkNWVZgFFq3v5ZbWrOBiOJTZduMhUOMRjzgH
         oI4JaFRFPU1sOFPp9i1Omajc9WZ8kfF1L0Fiu3IXnjeWEW4SiSrsjoxfSX9uXMeFG1n8
         t+ffu+ziMUl84JBOmJBDomFtWcyMY+gl4LTSqXCbRtqaQdwL05ii23IjRCviznbA3DC7
         4LpK64a2K9igMtnRIEnaD4lLAekgiWJgBsP0b7NSHOc7NI9flrbLkC7WSZMd5T6D2ugI
         djBe1RGvKsI3hJYh7azsH60BO6YtS88lfoq+KMJy0A0J6bYIytPNwS8Bglm7mL+/S+Ot
         f+RA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787906639; x=1788511439; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zhsiaAmVjzmzESFqvr2tri1C/08hg86tA9bCn5YqmwM=;
        b=eHHjufBeR+KCYb7t+owcbLlVyXOpiq8J2c43ZR/cxXpfVb2zQvP2W1OnoIkKxForJv
         SjDKBlvgBUAfeVjeIqcW7hrJChhlrJEF1KR2FcmQJ4fcfKdL4OOF0AEbjUnlDZDhJ1gp
         x+4tM9/O/JqtaswnPIIJBz5+qyin9+bmqB9YfRukKSOILxaNUKkK9ePkIG4nJ9ITb4Bd
         dUymgWDQ2HBJDiI0OOg90wUwkmXPhiWlNQiLZ6h/WEpO0V5KpG6s/kCfdlW1yJ8n++lh
         TMwS/TrMK5oY1CvEp4fOtNWzN9622nuao0MkYJqnxOiSGF9G/Tor8t++adcMARhTEkxv
         Ttvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787906639; x=1788511439;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zhsiaAmVjzmzESFqvr2tri1C/08hg86tA9bCn5YqmwM=;
        b=kX43itsGSM5ZLAU6Hn8FP2zZquieSppSmqY+ZLOhnTRzGtO0KTVgsn4hmkTxRUTUgK
         ZiGYuZOp3jDYFPKhvFAqBobDjlaVq6XAQpsOB5hEiB+y/+s+YihzvuLLTdoWzoR6NrFT
         R45O5M8IUQkNXMrLtPGwCVWcUrbpvwsmcmkVLTxjYmeV3vqOYuhGIhtaGSLjDx/xAFqo
         H/AkJsB13uhAHA9CrQmZQkUMwqRCTXjTl18sftg1rZ/D1O3Fa8iwWbBv/0Gx2HCo+Zxs
         4RApD08Gqq958uWZ46+Peke1H1aDayVeuTaevj92nI9y+oTylr1nQmDPrmv+rHb29mdF
         dGpg==
X-Forwarded-Encrypted: i=1; AHgh+RonzYXSpaQLUkJqfgVu5a6ytlUSpR/TxbqC2xA/GLzYhv9e49nwnQPwtcwIyfI6jOJs+JLyySOh@lists.linux.dev
X-Gm-Message-State: AFuF++nMialDLSqCMBlnTU138LkCCDZPQDb6A2hAqA4kx5BKLMCcsXIP
	p74D5q0cnnN4qBskjrxTOjUsaUy1niWxqE1YKNsY8FWL87IYLb5gQIgBVKCLY9UXPNAjjYgiypY
	8lP5KCQlYlP13jTx4c9uTpG8+m/yeS/E=
X-Gm-Gg: AR+sD13KdgdVAgjyocsV5Eq8/zUsSNLKfF6vyoWDLbGhnGucL+miucIVZLROPeqAdPq
	qzEqwdv1l3gS3TK2BFIW+LAZ8jx+s6w3ET8vnq5YVxeyKJDMWf9Nj4TdnKIgw7VWdCHy7pbulLK
	NXo8a/ZjNUjcsIIdfTpW2gV5TTbV//kifgyxnzcB426AaQWLICy9UipFH+smSB5hLAtALlvYpn1
	C97t03Kg+0zmaZRtoi0OECIrlzql6WFH2XvzbXprc9OzhYgK6yIMA+M1cXED4LJNv/e5qcBYJKU
	cUcH0IBsJNxlfd26ezynlRHl6hTjDNT1U/mAyDSQCyukvFqHkryEXyJyAJ3oAJhU3Jo/ZOUJq6+
	wIlY=
X-Received: by 2002:a2e:bc0a:0:b0:3a1:94fc:e1cf with SMTP id
 38308e7fff4ca-3a301b26568mr8446061fa.10.1787906638442; Fri, 28 Aug 2026
 01:43:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260825132541.986300899@linuxfoundation.org>
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 28 Aug 2026 14:13:44 +0530
X-Gm-Features: AcwNN1UhUoRQqGS--MuKqVVwHa7REQ0stzNan3AFZ6MJrTOOBIX7BijorBSHvPw
Message-ID: <CAC-m1rq1FSDpRMR4+hYrg0KnJVuiE4R6ggPyCKGfFKu8OqFdKQ@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 7:20=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.11 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
Build and Boot Report  7.1.11-rc1

I built and tested Linux kernel version 7.1.11-rc1 using the default
configurations
on both x86_64 and arm64 architectures in a virtualized environment.

The kernel compiled successfully on both architectures and booted
without issues.
I did not observe any regressions or new warnings in dmesg during boot.

Kernel version: 7.1.11-rc1
Configurations tested: x86_64_defconfig, defconfig
Architectures tested: x86_64, arm64
Kernel source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 822f846a60fc16f7c944c77d54276d8932b2c4e0

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
