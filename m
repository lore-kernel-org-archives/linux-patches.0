Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06713199949
	for <patches@lists.linux.dev>; Mon, 20 Jan 2025 18:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737399289; cv=none; b=h2WQBsY8Z7J/EdkRchp7aVgaVtRp/1MQOabBlm/4Q5Lda/k0NA0T9jPXETYfk5k9Uzm/V6tr4S9Ae2tZT+fCpWrJ+Cnmd+XdUpZ3T8yuRKdD+JTZ/piPvbNAnF5f0zqOd9u85L7qIVGeDisSpNkQDoteVqn7SyUcWtJNs+4ecCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737399289; c=relaxed/simple;
	bh=4OagAVR8gFUXtyrRrmiCsMJpsxFxdG9HR40PlS7zF5s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RfMw2ViigMaiLBQAFNz8Gy55h/F/keHXYMNOFJpkIk/XlmQMty9uN+Xm3JoIegKgNxo3NVfM8xABqYHBY72bNsJ4QTBYLUsF0n5fjuZgkBWEu00keoC4Nim/OND5xShPlTfQaPGRgXPWxHDfUEP19io114kiz70vWxzzBP2VX3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cF3b10bA; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cF3b10bA"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so8925063a12.2
        for <patches@lists.linux.dev>; Mon, 20 Jan 2025 10:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737399286; x=1738004086; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YG1LrdTBFFMlPie23Dwklu/W4g9+gpZJQ3ow7EKHdek=;
        b=cF3b10bAx8hjCZAmUScBs4DuxpZFP/KS40QoCy/aRkFRI1Y2cECaNjJoaICuEuxC4X
         N3MS+SR2NO/LL6NhFaaCYsbRPpU+O++L0N8Zg4lK1K7AxARg/Y/q7bCHsqNsw5GFuU3V
         RfRC6sRbIFd2JB3XtbCQbhHIXkH4qhx35UBIk7nyElYEp3UImGjNbWKVVobtotoeUkNr
         N69NZqsPTWckuGa81HgqRnDJwMjP94eiNUWqoPZtZx2IEbj6z3hWaRksa767UL5u+HMO
         k2KFIdUcnysTLx9/Wo1WQHJqnWyKGT2hllrT+X0nDSqJ5KEU/SKYMWVXL2PuzR8ocCUG
         90Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737399286; x=1738004086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YG1LrdTBFFMlPie23Dwklu/W4g9+gpZJQ3ow7EKHdek=;
        b=gmdOHjoDUrDEV2EPlZQiAkeWeBrBVFfFmGPhXz5VEZtVpewHKZISc0zY5Pg2hfmX2w
         3aBBIzg+y1jW4vNRJCrx8MggbKXL4d5asi3DqF35XFm/Tqe+O8ofm4pEBV50i2xie9ht
         1kyNK/gl7RvK1wqsFkNj8DirCiitohzmQ+0epLDHiipcOuO3L5HdZ/6clNkMgn9ES4d2
         yyoaW3JOJgM+viZb/qFczbFivEobkXI+x6jOKnwCbpKDzicgnVeL78zkXuIyfDkDspx8
         uFHtPZThppEATUKBEneGpsTpoXi8NsSvFUHvvvJdxG4FftUjZ+YmpdpjlVY3Ul3DADHZ
         lA8g==
X-Forwarded-Encrypted: i=1; AJvYcCX3hNWUOaHpAJ8611wyHUidLZQpFN+mcM9sX2PLPGHkCln+jJuXqFL9clz2QP22J8no4P88FrH1@lists.linux.dev
X-Gm-Message-State: AOJu0Yyo9lcYKR/SHM4GD338Ctnw8M3swBKRiI1QWQ/AwbKV4Ts42oQk
	BCqUyXId6HcSW1etj2Iv7cJlU+RxPD5lqXKhpR+2Y7rnCIVk+a2hGQA+VPos5tbIU5uCCO2NzZT
	+hT4YVnMCqFMwEQ9wd6KLKe8KQZc=
X-Gm-Gg: ASbGncs1wipG7HfmRcS8TTrqdcyqoRiO/rUHXHHb0YPb4j3YmXB/ScXaX4sHiELVTN9
	KHqsFRmdYmIcGnKTiCpg8L3o0MFoWvktjAqaOXdYIcPh3i4ENBFU=
X-Google-Smtp-Source: AGHT+IF5QXimVOSCBRvo0uvvUosj5rQp/5GveZu8jIYF3jHPLGB712YIoEpFOZEz9zcXORWXNBZFz+3zsn87k0Q7qfA=
X-Received: by 2002:a17:907:934a:b0:aa6:9624:78fd with SMTP id
 a640c23a62f3a-ab38b4c6436mr1474156866b.48.1737399285778; Mon, 20 Jan 2025
 10:54:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250115103554.357917208@linuxfoundation.org> <20250115103554.776405922@linuxfoundation.org>
 <ACD4D6CC-C4D5-4657-A805-03C34559046E@cloudflare.com>
In-Reply-To: <ACD4D6CC-C4D5-4657-A805-03C34559046E@cloudflare.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 20 Jan 2025 19:54:34 +0100
X-Gm-Features: AbW1kvZalEtkjbJOkMrF9HjaM5pEKEwJnuw7J16rQ5ghsXNWIldYwYSngoiIsHw
Message-ID: <CAOQ4uxj21U_=_Lj0AfDHmLt2wAjQG3vhYh9hXyZ=KG-J+AUOxg@mail.gmail.com>
Subject: Re: [PATCH 6.6 010/129] ovl: do not encode lower fh with upper
 sb_writers held
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2025 at 6:09=E2=80=AFPM Ignat Korchagin <ignat@cloudflare.c=
om> wrote:
>
>
>
> > On 15 Jan 2025, at 10:36, Greg Kroah-Hartman <gregkh@linuxfoundation.or=
g> wrote:
> >
> > 6.6-stable review patch.  If anyone has any objections, please let me k=
now.
> >
> > ------------------
> >
> > From: Amir Goldstein <amir73il@gmail.com>
> >
> > [ Upstream commit 5b02bfc1e7e3811c5bf7f0fa626a0694d0dbbd77 ]
> >
> > When lower fs is a nested overlayfs, calling encode_fh() on a lower
> > directory dentry may trigger copy up and take sb_writers on the upper f=
s
> > of the lower nested overlayfs.
> >
> > The lower nested overlayfs may have the same upper fs as this overlayfs=
,
> > so nested sb_writers lock is illegal.
> >
> > Move all the callers that encode lower fh to before ovl_want_write().
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Stable-dep-of: c45beebfde34 ("ovl: support encoding fid from inode with=
 no alias")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
>
> Hi,
>
> This patch seems to trigger the following warning on 6.6.72, when running=
 simple =E2=80=9C$ docker run --rm -it debian=E2=80=9D (creating a containe=
r):
>
> ------------[ cut here ]------------
> WARNING: CPU: 12 PID: 668 at fs/namespace.c:1245 cleanup_mnt+0x130/0x150
> Modules linked in: xt_conntrack(E) nft_chain_nat(E) xt_MASQUERADE(E) nf_n=
at(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) bridge(E) stp(E) =
llc(E) xfrm_user(E) xfrm_algo(E) xt_addrtype(E) nft_compat(E) nf_tables(E) =
overlay(E) kvm_amd(E) ccp(E) kvm(E) irqbypass(E) crc32_pclmul(E) sha512_sss=
e3(E) sha256_ssse3(E) sha1_ssse3(E) aesni_intel(E) crypto_simd(E) cryptd(E)=
 iTCO_wdt(E) virtio_console(E) virtio_balloon(E) iTCO_vendor_support(E) tin=
y_power_button(E) button(E) sch_fq_codel(E) fuse(E) nfnetlink(E) vsock_loop=
back(E) vmw_vsock_virtio_transport_common(E) vsock(E) efivarfs(E) ip_tables=
(E) x_tables(E) virtio_net(E) net_failover(E) virtio_blk(E) virtio_scsi(E) =
failover(E) crc32c_intel(E) i2c_i801(E) virtio_pci(E) virtio_pci_legacy_dev=
(E) i2c_smbus(E) lpc_ich(E) virtio_pci_modern_dev(E) mfd_core(E) virtio(E) =
virtio_ring(E)
> CPU: 12 PID: 668 Comm: dockerd Tainted: G E 6.6.71+ #18
> Hardware name: KubeVirt None/RHEL, BIOS edk2-20230524-3.el9 05/24/2023
> RIP: 0010:cleanup_mnt+0x130/0x150
> Code: 2c 01 00 00 85 c0 75 16 e8 6d fb ff ff eb 8a c7 87 2c 01 00 00 00 0=
0 00 00 e9 6a ff ff ff c7 87 2c 01 00 00 00 00 00 00 eb de <0f> 0b 48 83 bd=
 30 01 00 00 00 0f 84 e9 fe ff ff 48 89 ef e8 18 e7
> RSP: 0018:ffffc9000095fec8 EFLAGS: 00010282
> RAX: 00000000fffffffe RBX: 0000000000000000 RCX: 0000000000000010
> RDX: 0000000000000010 RSI: 0000000000000010 RDI: 0000000000000010
> RBP: ffff888109ea57c0 R08: ffffffffbc27ab60 R09: 0000000000000000
> R10: 0000000000037420 R11: 0000000000000000 R12: ffff88810acba9bc
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS: 00007f1041ffb6c0(0000) GS:ffff88903fc00000(0000) knlGS:00000000000000=
00
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c000b7f02f CR3: 00000001034ca002 CR4: 0000000000770ee0
> PKRU: 55555554
> Call Trace:
> <TASK>
> ? cleanup_mnt+0x130/0x150
> ? __warn+0x81/0x130
> ? cleanup_mnt+0x130/0x150
> ? report_bug+0x16f/0x1a0
> ? handle_bug+0x53/0x90
> ? exc_invalid_op+0x17/0x70
> ? asm_exc_invalid_op+0x1a/0x20
> ? cleanup_mnt+0x130/0x150
> ? cleanup_mnt+0x13/0x150
> task_work_run+0x5d/0x90
> exit_to_user_mode_prepare+0xf8/0x100
> syscall_exit_to_user_mode+0x21/0x40
> ? srso_alias_return_thunk+0x5/0xfbef5
> do_syscall_64+0x45/0x90
> entry_SYSCALL_64_after_hwframe+0x60/0xca
> RIP: 0033:0x55d0e0726dee
> Code: 48 83 ec 38 e8 13 00 00 00 48 83 c4 38 5d c3 cc cc cc cc cc cc cc c=
c cc cc cc cc cc 49 89 f2 48 89 fa 48 89 ce 48 89 df 0f 05 <48> 3d 01 f0 ff=
 ff 76 15 48 f7 d8 48 89 c1 48 c7 c0 ff ff ff ff 48
> RSP: 002b:000000c000145a10 EFLAGS: 00000216 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 000000c000b7fce0 RCX: 000055d0e0726dee
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000c000b7fce0
> RBP: 000000c000145a50 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000216 R12: 000000c000b7fce0
> R13: 0000000000000000 R14: 000000c000b06e00 R15: 1fffffffffffffff
> </TASK>
> ---[ end trace 0000000000000000 ]=E2=80=94
>
> This commit was pointed by my bisecting 6.6.71..6.6.72, but to double-che=
ck it I had to revert the following commits to make 6.6.72 compile and not =
exhibit the issue:

Can you say what the compile error was?
Maybe it is easy to fix without reverting the entire bunch.
Just by looking, it is hard for me to guess what caused the scripts to
pull in this dependency patch.

>
>   * a3f8a2b13a277d942c810d2ccc654d5bc824a430 (=E2=80=9Covl: pass realinod=
e to ovl_encode_real_fh() instead of realdentry
> =E2=80=9D) [ Upstream commit 07aeefae7ff44d80524375253980b1bdee2396b0 ]
>   * 26423e18cd6f709ca4fe7194c29c11658cd0cdd0 (=E2=80=9Covl: do not encode=
 lower fh with upper sb_writers held=E2=80=9D) [ Upstream commit 5b02bfc1e7=
e3811c5bf7f0fa626a0694d0dbbd77 ]
>   * a1a541fbfa7e97c1100144db34b57553d7164ce5 ("ovl: support encoding fid =
from inode with no alias=E2=80=9D) [ Upstream commit c45beebfde34aa71afbc48=
b2c54cdda623515037 ]
>
> I can also confirm we don=E2=80=99t see this warning on the latest 6.12.1=
0 release, so perhaps we have missed some dependencies in 6.6?
>

Nah. pulling in the dependency patch was wrong.
This patch was not supposed to be applied detached from the entire series
https://lore.kernel.org/linux-unionfs/20230816152334.924960-1-amir73il@gmai=
l.com/
and I think this is a risky series to backport.

Thanks,
Amir.
