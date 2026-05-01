Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499363FB074
	for <patches@lists.linux.dev>; Fri,  1 May 2026 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777651911; cv=pass; b=msdzsWPnVb9W0sRhtORMDrhiKLoMqTA3CuU7A7GNe6DKBFI6cqmEXoJEt8TBtnSow36H57usDjfn9/XQ2w9OlsYlQ+nAOM6ER23A6QyngtcfAz0C16AJu8YA2ayfcFBkwgpYGdcZmtFvfiJkHK0fr7C50ABYloza1nuAkRCiqRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777651911; c=relaxed/simple;
	bh=Lg3I4a5CVSLmEfFpzSrc+IJ6RbdpOOFMUy6frdtkKdg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cd3LyxnBnolhtxiP+MgUaVi1i23dPOFrVeLSSy8QXQJLmmqrGwHvbhrHwnCOdXSTWEE7l2i5/zP8V3bJBz9itYvG1PpAdN/xlLlleapUwsxQRQLYskXHLFbcHsXzftn5eBLPMd+QIxj7usm6LR/wMRuLsuyFSfO3FfVEbMi6Yb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qmxFMD9/; arc=pass smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qmxFMD9/"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12c565dd3a7so2914425c88.1
        for <patches@lists.linux.dev>; Fri, 01 May 2026 09:11:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777651899; cv=none;
        d=google.com; s=arc-20240605;
        b=kjqbcRtgkWEna9FmNrHfwSA9ntvLRlNCkz0BXTgCsHlxz/3N0Xzoq/z1TlLSEZ0ZJG
         gvoEx5PBFP0/8jGucJpq0UnnGCtMvFuV5UPlXRI+3gAElUeLaQ3h2IsHmvdXnobH6sdx
         h6sNVES9rFMRtrUkdDBeFfgbukytLwg51Y1JRHpA3LR8/G1mYB4SFZPtBLub4dEzb9eI
         WqoPYl263g6TrqPePdeGEhmv3pnPBScesyLYE9uGNXCLurjqjADRZ8QkGnhN08+WEDSm
         3H+s3gApKphVWCBjKS6DAoJKLH97Vyk7VJW86GxfDOvIGQYVYbik8aT40VzKo5biKBg+
         FMFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qUtLnk45BiKrXHINpVcyMQeBwCn16A0KrBFa2QFTWtI=;
        fh=NAEk+2gMjQmRD+tz1tjVRhiIJOuzBFyuWeDPV5y7iTs=;
        b=lyc1MrstvQ9cKePOiNQQzZiMY1nfzTjo/FH+MVwKpGQ7TMCct36q1HQsTxtGo5hoYR
         uEbxJPoAVrA1Lef+svaoa6q3RcLI3wqu9+9Q5letQwmOwPvfocAb8xbHH2Ky0cmWQaD6
         qaWnXisD3LWvTnZIYQGH1WuY0mPyNH9Hy9lPOESHTW8Ngr2ffqMvpZo1RjcJPJFAA26t
         CyC75p3oFI95E21QhCplzaruH/2GYZ+VfxVid4uIPF4OEW2NhkmWw1To1305RNGfMxe7
         8uM3SArh6u4qb5WFU2tg24Wwvo/gaj0b+JmO8rbUGC1c648x74GczEztoa1exvIrVjaj
         8AaQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777651899; x=1778256699; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qUtLnk45BiKrXHINpVcyMQeBwCn16A0KrBFa2QFTWtI=;
        b=qmxFMD9/u7RhBw0pp1ZEgwIeEKQ9eJmdT+djge39BX4PAuQn2wEEhhWUOBDhpaodET
         vvFXP5bHj1m4RgqAQ4r2Jp6lEGxKlAiAmh45dHR/2OxcEh+iS3yaOmDPvVRyTjYlatF4
         7Ji6cFy/RV6irGpXpDN9uTMb64BTK3f3fgCB0gxrlGWY4MT/UWt+hJPBIiENBUnY2tQw
         TzXRovygnreHjPgJKDvLjd1zBYQStKstA/YXJG2M2ODTa3gsXCvQ14wTZFW7JpyrPgAY
         uqMlLvuNfoqtEMO+T9c4iHr4r4o7l26ls+UhEj+ReNyd04YpdzDEGrKe8h4Q/YrJ3H5B
         cVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777651899; x=1778256699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qUtLnk45BiKrXHINpVcyMQeBwCn16A0KrBFa2QFTWtI=;
        b=Bg6IW8+rQRvhb4YxHld92zwemK88D34rdLJMlFd2/z6gG43/7rYT0dwFw7awl0PKoY
         7V51Sg1E1LLTBnLcriHdL3WKysRwJ4t/3lxmlrynAFCFvtsk/toZp1++Me4/+HDekfL3
         n/MkaK2Dn5IsFJNt3BIBLKjoAxBja5tRRytiQOvJ6fSgxF8h4wCuDP27aOFsF0aG9O/9
         Q4gi24qiomR/+5HCm5bbTNCWvq2cVPh80Xw9qDUHvtv1F9U3T8mUs/LoyYWywjTtdvxT
         O/quiq9/zzhkOyyI84FVy5lyZHmjYKGovC8IcgzbPWB+lP8SBXwbPGrd+hCswZj/beGC
         +uRA==
X-Forwarded-Encrypted: i=1; AFNElJ/3PozfSbAjcdc0WtwZoFQ2+vrbvIZNNMSXyANd4RJEzmoD3iXfHlKNUkPpYsRRi5jBBtyuumki@lists.linux.dev
X-Gm-Message-State: AOJu0Yynm3rjG1G1OBQgvPHLBRTFcldNMSXWVIxPFO0O4kGj/qmqtW6l
	+KOFrktaPgwrPMAlgWU/RfkvpRp/c466VFSfe8tg/5/Ths9EwIvKIJmjfq3vAYp0F05GLorM4Ta
	dhzX5C9B08yAmnWhAIIPYL3lEWAlGppYp+lcjqYsO
X-Gm-Gg: AeBDieu9aAqY9rYw3d/gXfk/i87QUrGLbzyKwmCHi9T2Q9YTsZ/mi/G/1qLjNzoNlyU
	Sfk9x23R0SW+0JhyIjE0lEV5agXWahq5fI7a5rWa7E9uKgpMtD+kEJZOxwTGqYssWksvYiOQ5Um
	0166nK1pbhOKiUHqzbzikMab9CWJjH4CMxmnV4wXxsdkBftgahgh8G9HO0uyQ6JoNyKz+CHCsS4
	ZNzV8qzQDIIKURT/LywilY26qoHAHzXGHgXB0BHf5Zg1/hVIVUIJtEQmXPA4N0ms38Ng5ya14Nh
	az4iB+zD0NKw43ZeKnh5xRwYWocLGWgw/y7RYMBu
X-Received: by 2002:a05:7022:423:b0:12d:e126:b7c8 with SMTP id
 a92af1059eb24-12deac411demr3607716c88.13.1777651898369; Fri, 01 May 2026
 09:11:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 1 May 2026 09:11:11 -0700
X-Gm-Features: AVHnY4IcOZBEwRDeFauz0p7wo2ItTFGZpUDr4nDVbee6fBs6NBQ1Q0W5r-m7yp8
Message-ID: <CALzav=ci8bi3=sY+F3HJTB5sOQ_pJ8Lm+kz0CDBBWVXry5P98w@mail.gmail.com>
Subject: Re: [PATCH 00/11] mlx5 support for VFIO self test
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	patches@lists.linux.dev, Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 5:08=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> Add an mlx5 driver to VFIO self test. This is largely a remix of the
> existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
> to issue RDMA WRITE operations which effectively perform memory
> copies using DMA. Since mlx5 has a stable programming ABI this
> should work on devices from CX5 to current HW. The device FW must
> support the QP loopback configuration.

> This entire series was coded by Claude Code in about 4 days.

Very exciting. Josh Hilke from Google is also working on using AI to
create a selftest driver for Intel IGB NICs so VFIO selftests can run
in QEMU [1]. So it's encouraging to see you were able to do it with
mlx5.

[1] https://www.qemu.org/docs/master/system/devices/igb.html

> For those interested, the flow I used was broadly a prompt sequence
> sort of like:
>
>  - Hey Claude, go look at the falcon series, VFIO self test, the
>    mlx5 driver, rdma-core and some PDF documentation and make a
>    plan to put mlx5 under the selftest.
>  - Write an rdma-core application using the built-in VFIO provider
>    that can do the required memcpy operations that vfio selftests
>    wants.
>    (This resulted in a 1k loc C file that compiled and ran the
>     first time but had a few bugs related to device programming
>     that the AI resolved.)
>  - Replace the rdma-core components with open-coded versions to
>    create a fully stand-alone program that does the DMA memcpy.
>  - Review and audit the thing.
>  [Pause and de-slop it]
>  - Make it work on a PF too (this is surprisingly hard!).

Can it work on CX VFs? We're interested in continuously performing
memory copies across a Live Update using a VF via selftests to
demonstrate SR-IOV preservation (when we eventually get there).

>  [Move to a kernel tree and copy all the .md files and .c program
>   it made]
>  - Hey Claude, look at all this stuff and make a broad plan to
>    actually build a VFIO self test.
>  - Here is my 1 sentence advice on what each patch should look
>    like, make a detailed plan to make a patch for every one.
>  [Pause and polish the patch plans]
>  - Execute plan X then commit it [pause and de-slop each patch,
>    repeat].
>  [Review and final polish]
>
> It is based on a tree with the falcon series applied.

Thanks for sending, I look forward to reviewing!
