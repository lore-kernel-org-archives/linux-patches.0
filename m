Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4101EB9FF
	for <patches@lists.linux.dev>; Mon, 20 Jan 2025 20:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737404090; cv=none; b=hbYp4jZGi8EdCczCIa5LjCriTTg3I1k5gRKv6r07dWajMPuOr4uLk7wEOiFD4KEHyReqMY72SoQwvLKaW31MXJcblne11RUi34q4zhQLWhhCMKrCqyEnjvzchC0H9uFDCV2NO2fjjGkQtsZZiZhaRjGRzqDdEz2OvhU6z52XLqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737404090; c=relaxed/simple;
	bh=6hf1WVlRNtbV6BB6rYWgueh+46DGEF8ePqWhOl1AoIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aO+LE9vw1BMbM7+GjHI0ZOY+3CIf7TsfgFCUgcaYlTgci/C5KDbiLTkvqUB+Q8o+8yPgI0xfpDf5blUHBXC05JEi33VOt4kPy6IhHnhwwvN0oXQEgMXIl5isROqssVqfyumcNJIn+uAMomna+TDShaeV7clvORFLwBnpr586pvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=KDDtxWFm; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="KDDtxWFm"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2ef714374c0so7377473a91.0
        for <patches@lists.linux.dev>; Mon, 20 Jan 2025 12:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1737404088; x=1738008888; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jRP+e4ZOvxAmACDt3o2MfbmlfjOlJp4MoWMYFYojLk=;
        b=KDDtxWFmhz1dM5LePQhbXeSQ7Wpkb4J4yADpF6lIXQIW+54srOCBKsoYRJYZygqj44
         yuE2V05nd4/2dUTTkP7Gp3WEKCZUfYUVkkpctVejDVQtlGQTo2h/i6omQaKRuVHKAiiQ
         z7psWonpcdqf1bFNtlZI2LzSOsuNripToqk1GCyp/cwMJRSvugWUNaJB3J38lwA3CP4R
         2nM1afkFDKeJSyhS6lsXX7NKmhXEatwz+jnYnr9HHo6l+8xRvFyZHfL6gBpFGeVfwzCR
         JkewF3olbTqf314DMv62Fwm97l2bgPvTud7aqg1fokRPYYHotcP90C0AKhiFdb+FD1EF
         sRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737404088; x=1738008888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/jRP+e4ZOvxAmACDt3o2MfbmlfjOlJp4MoWMYFYojLk=;
        b=vllmUVX+XAkL0/FK85HDNLA4JkKl9jba+oKUn66Ny590OYO4Pq2pB+taQC8mcth4mm
         YrU9zuH+VOSue98WBVGw/98zRyxJ1krStj+Bg+22y1zJsimsvh2HgwzwOrIi7NmOR/Iz
         21Ww4pZ/02/lds8YsEqronNeNFGoK28cuiGZw2YKsQGqn0/iIblZon6Hw1EbkzuKCPnw
         EX8W73Wa9q8ESLiV9e5TI/r7CJV0JksVsBkf6LZ8k79HdbmBL38WJr/NcTPRzIms2uGP
         37ihSK+/TevOhGuE3fOCsJzQ3XbjcJSCDc4fy+7l3cqZ1xQeGDGubou5ll2FZiAic9bY
         NkoA==
X-Forwarded-Encrypted: i=1; AJvYcCWU6KACNVFQlynsv/h6OFA5zVdUHnwQJddU99NbdgKgSI4dYObIqZCvmeI6T8QKXqz+Ub6vfA/I@lists.linux.dev
X-Gm-Message-State: AOJu0YwbrfQ6uB7rTTD3r3nfvRt0TgmmHonwdd/PBVa2z/IDaG9aYAAg
	3614/7uyjWwg+c8oCUjv2eL6LPevintXnlMwUURqdLh+TCfPc+GZIxh2nAXW5K3NOwPmuwKK0I/
	iB82shyNWwA1PlEt0E/FFk5rQA698q5BDOsT7LA==
X-Gm-Gg: ASbGncsfBm33G1jH4ASlwBoCmhbF3vX5uYT+9CgtJqfYh5O4UaLmFfIeK6JBFoxLJqA
	2+Eo4ItPR0HmiFpGKBe6V2GJ3skUH9F/576a614LTt3mnoWAyo13kyObK+K7wkCm2SH/2
X-Google-Smtp-Source: AGHT+IEHsqX8eiyYDDPUc5K7KNONEDAIbAeMgq+P4sfBJgyO3B/hb2hP31vfH0q8Z/xBplOM/Zr9aqHuB38noI5iimw=
X-Received: by 2002:a17:90b:2f4b:b0:2ee:9229:e4bd with SMTP id
 98e67ed59e1d1-2f782beebb1mr21413569a91.2.1737404088241; Mon, 20 Jan 2025
 12:14:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250115103554.357917208@linuxfoundation.org> <20250115103554.776405922@linuxfoundation.org>
 <ACD4D6CC-C4D5-4657-A805-03C34559046E@cloudflare.com> <CAOQ4uxj21U_=_Lj0AfDHmLt2wAjQG3vhYh9hXyZ=KG-J+AUOxg@mail.gmail.com>
In-Reply-To: <CAOQ4uxj21U_=_Lj0AfDHmLt2wAjQG3vhYh9hXyZ=KG-J+AUOxg@mail.gmail.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Mon, 20 Jan 2025 20:14:37 +0000
X-Gm-Features: AbW1kvac28fnret9E1P_cHAVyWRnTMTm6m2rbw5tIEQGz7-zO5Kanz1wha917Wg
Message-ID: <CALrw=nH2gMfZUf=7rFSDRwD7bYzm5isvaY8rVPSG-6cf21OAfA@mail.gmail.com>
Subject: Re: [PATCH 6.6 010/129] ovl: do not encode lower fh with upper
 sb_writers held
To: Amir Goldstein <amir73il@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2025 at 6:54=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Mon, Jan 20, 2025 at 6:09=E2=80=AFPM Ignat Korchagin <ignat@cloudflare=
.com> wrote:
> >
> >
> >
> > > On 15 Jan 2025, at 10:36, Greg Kroah-Hartman <gregkh@linuxfoundation.=
org> wrote:
> > >
> > > 6.6-stable review patch.  If anyone has any objections, please let me=
 know.
> > >
> > > ------------------
> > >
> > > From: Amir Goldstein <amir73il@gmail.com>
> > >
> > > [ Upstream commit 5b02bfc1e7e3811c5bf7f0fa626a0694d0dbbd77 ]
> > >
> > > When lower fs is a nested overlayfs, calling encode_fh() on a lower
> > > directory dentry may trigger copy up and take sb_writers on the upper=
 fs
> > > of the lower nested overlayfs.
> > >
> > > The lower nested overlayfs may have the same upper fs as this overlay=
fs,
> > > so nested sb_writers lock is illegal.
> > >
> > > Move all the callers that encode lower fh to before ovl_want_write().
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > Stable-dep-of: c45beebfde34 ("ovl: support encoding fid from inode wi=
th no alias")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> >
> > Hi,
> >
> > This patch seems to trigger the following warning on 6.6.72, when runni=
ng simple =E2=80=9C$ docker run --rm -it debian=E2=80=9D (creating a contai=
ner):
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 12 PID: 668 at fs/namespace.c:1245 cleanup_mnt+0x130/0x15=
0
> > Modules linked in: xt_conntrack(E) nft_chain_nat(E) xt_MASQUERADE(E) nf=
_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) bridge(E) stp(E=
) llc(E) xfrm_user(E) xfrm_algo(E) xt_addrtype(E) nft_compat(E) nf_tables(E=
) overlay(E) kvm_amd(E) ccp(E) kvm(E) irqbypass(E) crc32_pclmul(E) sha512_s=
sse3(E) sha256_ssse3(E) sha1_ssse3(E) aesni_intel(E) crypto_simd(E) cryptd(=
E) iTCO_wdt(E) virtio_console(E) virtio_balloon(E) iTCO_vendor_support(E) t=
iny_power_button(E) button(E) sch_fq_codel(E) fuse(E) nfnetlink(E) vsock_lo=
opback(E) vmw_vsock_virtio_transport_common(E) vsock(E) efivarfs(E) ip_tabl=
es(E) x_tables(E) virtio_net(E) net_failover(E) virtio_blk(E) virtio_scsi(E=
) failover(E) crc32c_intel(E) i2c_i801(E) virtio_pci(E) virtio_pci_legacy_d=
ev(E) i2c_smbus(E) lpc_ich(E) virtio_pci_modern_dev(E) mfd_core(E) virtio(E=
) virtio_ring(E)
> > CPU: 12 PID: 668 Comm: dockerd Tainted: G E 6.6.71+ #18
> > Hardware name: KubeVirt None/RHEL, BIOS edk2-20230524-3.el9 05/24/2023
> > RIP: 0010:cleanup_mnt+0x130/0x150
> > Code: 2c 01 00 00 85 c0 75 16 e8 6d fb ff ff eb 8a c7 87 2c 01 00 00 00=
 00 00 00 e9 6a ff ff ff c7 87 2c 01 00 00 00 00 00 00 eb de <0f> 0b 48 83 =
bd 30 01 00 00 00 0f 84 e9 fe ff ff 48 89 ef e8 18 e7
> > RSP: 0018:ffffc9000095fec8 EFLAGS: 00010282
> > RAX: 00000000fffffffe RBX: 0000000000000000 RCX: 0000000000000010
> > RDX: 0000000000000010 RSI: 0000000000000010 RDI: 0000000000000010
> > RBP: ffff888109ea57c0 R08: ffffffffbc27ab60 R09: 0000000000000000
> > R10: 0000000000037420 R11: 0000000000000000 R12: ffff88810acba9bc
> > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > FS: 00007f1041ffb6c0(0000) GS:ffff88903fc00000(0000) knlGS:000000000000=
0000
> > CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000000c000b7f02f CR3: 00000001034ca002 CR4: 0000000000770ee0
> > PKRU: 55555554
> > Call Trace:
> > <TASK>
> > ? cleanup_mnt+0x130/0x150
> > ? __warn+0x81/0x130
> > ? cleanup_mnt+0x130/0x150
> > ? report_bug+0x16f/0x1a0
> > ? handle_bug+0x53/0x90
> > ? exc_invalid_op+0x17/0x70
> > ? asm_exc_invalid_op+0x1a/0x20
> > ? cleanup_mnt+0x130/0x150
> > ? cleanup_mnt+0x13/0x150
> > task_work_run+0x5d/0x90
> > exit_to_user_mode_prepare+0xf8/0x100
> > syscall_exit_to_user_mode+0x21/0x40
> > ? srso_alias_return_thunk+0x5/0xfbef5
> > do_syscall_64+0x45/0x90
> > entry_SYSCALL_64_after_hwframe+0x60/0xca
> > RIP: 0033:0x55d0e0726dee
> > Code: 48 83 ec 38 e8 13 00 00 00 48 83 c4 38 5d c3 cc cc cc cc cc cc cc=
 cc cc cc cc cc cc 49 89 f2 48 89 fa 48 89 ce 48 89 df 0f 05 <48> 3d 01 f0 =
ff ff 76 15 48 f7 d8 48 89 c1 48 c7 c0 ff ff ff ff 48
> > RSP: 002b:000000c000145a10 EFLAGS: 00000216 ORIG_RAX: 00000000000000a6
> > RAX: 0000000000000000 RBX: 000000c000b7fce0 RCX: 000055d0e0726dee
> > RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000c000b7fce0
> > RBP: 000000c000145a50 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000216 R12: 000000c000b7fce0
> > R13: 0000000000000000 R14: 000000c000b06e00 R15: 1fffffffffffffff
> > </TASK>
> > ---[ end trace 0000000000000000 ]=E2=80=94
> >
> > This commit was pointed by my bisecting 6.6.71..6.6.72, but to double-c=
heck it I had to revert the following commits to make 6.6.72 compile and no=
t exhibit the issue:
>
> Can you say what the compile error was?
> Maybe it is easy to fix without reverting the entire bunch.

Just to revert 26423e18cd6f I needed to revert a3f8a2b13a27 as well
(otherwise there were conflicts). But then the compilation failed with

fs/overlayfs/export.c: In function =E2=80=98ovl_dentry_to_fid=E2=80=99:
fs/overlayfs/export.c:255:67: error: =E2=80=98dentry=E2=80=99 undeclared (f=
irst use in
this function)
  255 |         fh =3D ovl_encode_real_fh(ofs, enc_lower ?
ovl_dentry_lower(dentry) :
      |                                                                   ^=
~~~~~

so I had to revert a1a541fbfa7e as well

Thanks

> Just by looking, it is hard for me to guess what caused the scripts to
> pull in this dependency patch.
>
> >
> >   * a3f8a2b13a277d942c810d2ccc654d5bc824a430 (=E2=80=9Covl: pass realin=
ode to ovl_encode_real_fh() instead of realdentry
> > =E2=80=9D) [ Upstream commit 07aeefae7ff44d80524375253980b1bdee2396b0 ]
> >   * 26423e18cd6f709ca4fe7194c29c11658cd0cdd0 (=E2=80=9Covl: do not enco=
de lower fh with upper sb_writers held=E2=80=9D) [ Upstream commit 5b02bfc1=
e7e3811c5bf7f0fa626a0694d0dbbd77 ]
> >   * a1a541fbfa7e97c1100144db34b57553d7164ce5 ("ovl: support encoding fi=
d from inode with no alias=E2=80=9D) [ Upstream commit c45beebfde34aa71afbc=
48b2c54cdda623515037 ]
> >
> > I can also confirm we don=E2=80=99t see this warning on the latest 6.12=
.10 release, so perhaps we have missed some dependencies in 6.6?
> >
>
> Nah. pulling in the dependency patch was wrong.
> This patch was not supposed to be applied detached from the entire series
> https://lore.kernel.org/linux-unionfs/20230816152334.924960-1-amir73il@gm=
ail.com/
> and I think this is a risky series to backport.
>
> Thanks,
> Amir.
