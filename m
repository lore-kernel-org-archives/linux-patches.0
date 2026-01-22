Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B002DE70C
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 01:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769046423; cv=pass; b=aXXKZQdLfKLgmglDaYA2Mi/MSnI9OM574wCJWPWOpgTNbRrf3hMIxW0hnhl5yLwcZe0e2VdDWaBerEpu6ktEbxZwRPg8j51QeZFsrbU0JOHXjJ7jyLmlqSUaOEEdSTlnQjeCzil6XE+aRtkDXWLm2h++zcg+DkA9R/+4x6MKhHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769046423; c=relaxed/simple;
	bh=0u8zE8DwwJ3CkOI5RZfv+1sTutkTchoW6WqM0X17EGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m4t3vIGEtWy5Q+BJa4x7ge9FHeiD9OCuGQrV8qSlfKVFYEmBOp0m3Kh0Tj0+g7oeP0eYwhZIbQK/XKf9O2R9BBH9mcss5KqO2XNl0zNg6MlKNb1Z9JukuG6mj7NaTXy7j4yari6rXyPGZM+R/eYJTIX2MV8gLBdc+7N5ay3MGhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=TMJdcLXm; arc=pass smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="TMJdcLXm"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-66109b09b53so146940eaf.1
        for <patches@lists.linux.dev>; Wed, 21 Jan 2026 17:47:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769046420; cv=none;
        d=google.com; s=arc-20240605;
        b=LbhJQzrFGbWMWiOA6UcPc11CSGGHZezvVU169PBjV+hXU7XU+xDUojEZpypmTpSyXr
         9EftCF7nmBPgqkUjAq9znzImXk+mzWWxBqlpMQ8JQKpLIwrGUdDlcZw5yPuHpi4N2tQe
         SHr4Ddxtq1Gi4D6ErKiWkt9RGl0hc1Yr4/dZRKJH3OG80l15uahtLJy2g6143E3gSGYi
         FJySt8pUnEYz5ZOOJmM3BMUqXWm6YcYP2aSjVaUaLXRHI2G8TUB959ttX9DhKQbr8FK1
         HmD8/b9ZwFSQGqBbSc089vvZ4In6qzXyVnTETYGwa0WGPqBZbHNrpiSBqTG6LTjXh9Tb
         4ZUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9PTzoubPp4hDkja30sWF+suRnJHt7y0QXrdAbJ13kqA=;
        fh=zO9qaczDI5FDCjaBBXt/q+yjWWyNmDUMDzRDIpHoGN4=;
        b=j58z4GrEak0HX5Pazn1V+ipTdYyJkqKJQr4DQCeDKtg+CrUflA/pJBG6PX1ek02Y/P
         qc5RrHHcbkuAqCVRIysjj5k738gbJTT2/tNrAZaOUlMVK+haqU1OtF3PVjhVs3248LZl
         CrQEjhR9HtOoxjoQiYd2CgVHJ5U9by4lKC4SuLPXxP8SvgO0aa72AbK2SnCJ4vtZs54H
         6Aw4vTxGAq2HOkLk5R6xSAPcAOeKCtTnzpX+IQUY6zLf34pHsMU+JvnJS1m1kKKB+ENS
         yQ2S3Qdlg9IWAZUaBpav8oZVvRXHRQ5UgLHKw56gDqcLENzjy4f6LsOVAUiiM4s6PYul
         Tl/A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1769046420; x=1769651220; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9PTzoubPp4hDkja30sWF+suRnJHt7y0QXrdAbJ13kqA=;
        b=TMJdcLXmuC+d+ueuQAob7jZkgNbrZhobNQ6v6+0xPSHDn4EMLDuSPC5/zya9h3Brib
         a4YSTbzQOfUQCcuyZd37tXHK/CN2p5lbw4Ye9fQO32Ti13mcSjdOdFbeMD0rJhQTdreQ
         kVszbpjdkfpJp3kljjiTbFNWJ/PljCRTdS3YQ3HKEuFG2teiB1N+LkyiagZpZEiPJLPv
         fvvk/qDy8oPDXUMNVCXC6SdK2o9msLmJ66wK8HPDLQNvNdVkJCOo9f3xHNvM2GGx9EVo
         1TrfcqVJWoId1NhiPTHLGLKH7PKr+nqucbSt+/A1FYWRWZ9+8lLtgTfvkbSDEDExVZr3
         Lr1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769046420; x=1769651220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9PTzoubPp4hDkja30sWF+suRnJHt7y0QXrdAbJ13kqA=;
        b=kVVXvpRGDd73yRJoB1XTvQWIRsDwwNp5mObbz4bUWCPfItldnvyFo9hkTl2bth4xFq
         gMl1c/uR9dcLTlqQSICgbHWWGngaQfbs0PHZbIofb9Gpbhi0Gs8WT20XrPEUfTnuHjQw
         MjQACn/pB59aAN5XywCyuQxqInvf/paPRD/cdVgDXKqLcaSuC/geLWr58F/ppRPwK4mL
         PvImPO6ghO/LRjXgt60W0TE468NN+Ii8cMRmhtpLk3dgIX2NabM361bVIIrD8eb9ZM3z
         hsOqlTqdLBIdih4K+OtpqL4/CiSFQaKbnnHuNtOl6o5Q9hpRPv4Eq5Mkb0cO/J4o376C
         d/ag==
X-Forwarded-Encrypted: i=1; AJvYcCWJqZFkHT8XaCNNEZK6S5twrjDg4j7tSdE7NazZifh22/0UX19NUkeAx68rjnkycRVCXHEDgIWG@lists.linux.dev
X-Gm-Message-State: AOJu0YxjoSmcP/7EaJ9hXq2kgGW9I0/JkdFE16HXMr1LJ4Mbiy3m/RDI
	dzNn76aMZvBwqxIUnX7NLF8/O5eggJrWWXViONvO9yL/wTNXbstbz7cA3N2lOJg3zxOf9O0X016
	aPDP7V77g143viomoQlt5dZoiTq8oMI73kUTDNj/IOg==
X-Gm-Gg: AZuq6aIqshfH7FIVlESaY4Cyldg313cf1XmXB36a+5JrXvBkZL1hva2XNNMUWWgO5Sd
	uER8lImtQ17ap/l/DwHjFA8MpLx5NQXqVEFCejvaDkl54bsJpZCXzU+8gW8wQi7fIIlug+8X+kx
	dv9c0jZdHG9pBg8dZKjYR2uuvrYp4AZNaqYqZSG01H3MC0t+3E+8j0Ww7faNCokD+Q69o5hOyyw
	V9D+hNwj80I5zGP8FgjeEPAX14r+2gAMEHoFbGXN9lhFp03bpyO0qPG6np4s40LVchFgYY9Uzzh
	h+65RqwD
X-Received: by 2002:a05:6820:4d5a:20b0:662:b8fe:201 with SMTP id
 006d021491bc7-662b8fe0440mr1740999eaf.23.1769046420173; Wed, 21 Jan 2026
 17:47:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
From: Vincent Chen <vincent.chen@sifive.com>
Date: Thu, 22 Jan 2026 09:46:47 +0800
X-Gm-Features: AZwV_QiJd5q6gXWC5pBl8iW8G0RoL8rDe_7SQsYQAor2KcNuj9vdHUwn-MU0KzM
Message-ID: <CABvJ_xiUK9BqUJS9-Sk1sS4vhVhyXN8P8NooZ0t_Zp7ycG0bAw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Convert riscv to use the generic iommu page table
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, linux-riscv@lists.infradead.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Tomasz Jeznach <tjeznach@rivosinc.com>, Will Deacon <will@kernel.org>, lihangjing@bytedance.com, 
	Xu Lu <luxu.kernel@bytedance.com>, patches@lists.linux.dev, 
	xieyongji@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jason,

I tested this patch set on my side with the QEMU-virt machine.
I used the following QEMU command for testing:

  $QEMU/qemu-system-riscv64 \
    -M virt,aia=3Daplic-imsic,aia-guests=3D7,iommu-sys=3Don -m 8G -nographi=
c \
    -bios $OPENSBI_IMAGE \
    -serial mon:stdio -serial null -nographic \
    -device e1000e,netdev=3Dnet0 \
    -netdev user,id=3Dnet0 \
    -cpu rv64,v=3Dtrue,vlen=3D256,ssdbltrp=3Dtrue,smdbltrp=3Dtrue \
    -device '{"driver":"virtio-9p-device","fsdev":"share","mount_tag":"host=
0"}'
\
    -fsdev local,id=3Dshare,path=3Dshare,security_model=3Dmapped \
    -append 'console=3DttyS0 earlycon' \
    -kernel $KERNEL_IMAGE \
    -gdb tcp::6234 \
    -smp 4

The boot log shows that the e1000e is successfully added to IOMMU group 1:

  [    0.752808] pci 0000:00:00.0: Adding to iommu group 0
  [    0.753279] pci 0000:00:01.0: Adding to iommu group 1
  [...]
  [    0.763212] e1000e 0000:00:01.0: enabling device (0000 -> 0002)
  [    0.765241] e1000e 0000:00:01.0: Interrupt Throttling Rate
(ints/sec) set to dynamic conservative mode
  [    0.868120] e1000e 0000:00:01.0 eth0: (PCI Express:2.5GT/s:Width
x1) 52:54:00:12:34:56
  [    0.868740] e1000e 0000:00:01.0 eth0: Intel(R) PRO/1000 Network Connec=
tion
  [    0.869087] e1000e 0000:00:01.0 eth0: MAC: 3, PHY: 8, PBA No: 000000-0=
00

In this environment, I used iperf3 to verify that the e1000e functions
correctly. The result shows that the test completed successfully:

  # iperf3 --bind-dev eth0 -c speedtest.uztelecom.uz -t 120 -i 10 -V -Z -p =
5203
  iperf 3.20
  Linux buildroot 6.19.0-rc4-00059-g92d6f969eb10 #10 SMP Wed Jan 21
11:06:14 CST 2026 riscv64
  Control connection MSS 1460
  Time: Thu, 22 Jan 2026 01:30:52 GMT
  Connecting to host speedtest.uztelecom.uz, port 5203
  [...]
  [  5] local 10.0.2.15 port 58132 connected to 195.69.189.215 port 5203
  Starting Test: protocol: TCP, 1 streams, 131072 byte blocks,
omitting 0 seconds, 120 second test, tos 0
  [ ID] Interval          Transfer    Bitrate        Retr  Cwnd
  [  5]   0.00-10.01  sec  5.62 MBytes  4.71 Mbits/sec    0    128 KBytes
  [  5]  10.01-20.01  sec  44.0 MBytes  36.9 Mbits/sec    0    128 KBytes
  [...]
  [  5] 110.01-120.05 sec  69.1 MBytes  57.7 Mbits/sec    0    128 KBytes
  - - - - - - - - - - - - - - - - - - - - - - - - -
  Test Complete. Summary Results:
  [ ID] Interval          Transfer    Bitrate        Retr
  [  5]   0.00-120.05 sec   676 MBytes  47.2 Mbits/sec    0             sen=
der
  [  5]   0.00-120.05 sec   675 MBytes  47.2 Mbits/sec                  rec=
eiver
  CPU Utilization: local/sender 3.8% (0.0%u/3.8%s), remote/receiver
5.2% (0.7%u/4.6%s)

  iperf Done.

Thank you very much for enabling the generic IOMMU page table mechanism to
support RISC-V IOMMU.

Tested-by: Vincent Chen <vincent.chen@sifive.com>

On Tue, Jan 6, 2026 at 11:07=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> This is a fairly straightforward conversion of the RISC-V iommu driver to
> use the now merged generic iommu page table code.
>
> It brings support for SVNAPOT which is a 64K contiguous page. Otherwise i=
t
> should not change the behavior.
>
> The series disables SADE as the dirty tracking support is not implemented
> in the driver and should be done somewhat differently. The generic code
> gets further along though this does not include the format implementation
> of read and clear dirty.
>
> The format implementation should be able to support the 32 bit option, bu=
t
> this does not enable the iommu implementation as there seems to be no use=
r
> today.
>
> It looks like RISCV could support the DYNAMIC_TOP option. It would requir=
e
> some additional work on the core side to interact safely with SIGN_EXTEND=
.
>
> This is on github: https://github.com/jgunthorpe/linux/commits/iommu_pt_r=
iscv
>
> v2:
>  - Rebase to v6.19-rc1
>  - Fix typo in PT_FEAT_RISCV_SVNAPOT_64K
> v1: https://patch.msgid.link/r/0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nv=
idia.com
>
> Jason Gunthorpe (5):
>   iommupt: Add the RISC-V page table format
>   iommu/riscv: Disable SADE
>   iommu/riscv: Use the generic iommu page table
>   iommu/riscv: Enable SVNAPOT support for contiguous ptes
>   iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
>
>  drivers/iommu/generic_pt/.kunitconfig        |   1 +
>  drivers/iommu/generic_pt/Kconfig             |   9 +
>  drivers/iommu/generic_pt/fmt/Makefile        |   2 +
>  drivers/iommu/generic_pt/fmt/defs_riscv.h    |  29 ++
>  drivers/iommu/generic_pt/fmt/iommu_riscv64.c |  11 +
>  drivers/iommu/generic_pt/fmt/riscv.h         | 313 +++++++++++++++++++
>  drivers/iommu/riscv/Kconfig                  |   8 +-
>  drivers/iommu/riscv/iommu-bits.h             |   4 +-
>  drivers/iommu/riscv/iommu.c                  | 302 +++---------------
>  include/linux/generic_pt/common.h            |  16 +
>  include/linux/generic_pt/iommu.h             |  11 +
>  11 files changed, 445 insertions(+), 261 deletions(-)
>  create mode 100644 drivers/iommu/generic_pt/fmt/defs_riscv.h
>  create mode 100644 drivers/iommu/generic_pt/fmt/iommu_riscv64.c
>  create mode 100644 drivers/iommu/generic_pt/fmt/riscv.h
>
>
> base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
> --
> 2.43.0
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
