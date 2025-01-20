Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A38914D711
	for <patches@lists.linux.dev>; Mon, 20 Jan 2025 20:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737405955; cv=none; b=pdAcr2v7zJih0JNAaCIxB8Ua6b8p8LJ9XaC8pZSs1q4m5gqToqH5PYg6VzTxRTLe6x1Qhn5XfUMXGL4227y7cq167K2fsxAYZ4MFQmg66GQ6E5FsNg2tjsCv5gnk70tIPs1SbGAE9XXNnEZLoKndtEfIbo8P6HaVadwB7QEdM1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737405955; c=relaxed/simple;
	bh=B1fc6VaVoPg+OxPhm7Vx955ggbgbk+A3viiFYgMHq4c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MUmfwEcN+KVbjlzrk94b0alE/Harg4KvGDY5AfgMJLJ1NQZXZ7Z7pk1ZbvAhedDIjB+oI6QyT8tbDWMtu0Gsz6oMycOTVhVNwJkrzse8qWF+7anuP4DLqbwJY95ow7NiFl+iG1cKYTAqSTvnwq/OR8DxubgCvoRVrsVHav2KgGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O76LCdiQ; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O76LCdiQ"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso815359066b.3
        for <patches@lists.linux.dev>; Mon, 20 Jan 2025 12:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737405952; x=1738010752; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vHUeLNoU5ZiWDLFNbqGs69k51hnOr6PnhRFJ0UdxKvU=;
        b=O76LCdiQWPgaaOTGr69Qc0nvlemKuU3IW9fptBvaUANMciAVAzHqq6jvaA8BVUCnA0
         SFd2uLoPCS60guIWLnyYjI/FfV+00WH3e1vHt0gPxvyo9h6P52n8wa+nzRvowhrlTlLK
         MHCvy+YgqATHJ4wIsiOSTry5ly1bXkX2d5eVKBwrpZrVsnDiYkhh9y6g15ALPwlPro6D
         k56OlJ5ArMa0Yk8Y50siVT8+LtiN66AjPOFl/SRFlUwXbHafbc1Ca7sUu0NiMOSUg0Vv
         Yq4rL/ZRDArJ9tKKg1wvb5xYPcB+aXh5vfYMSnbxO+aVMndyAQ2FIUs+6ciOvuokIgfg
         Me6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737405952; x=1738010752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vHUeLNoU5ZiWDLFNbqGs69k51hnOr6PnhRFJ0UdxKvU=;
        b=KqR08N6RzTJ4CVUBlNwLJPQbvTCB0D1vzcGhORbMdcUTJzfEngRfYS+DXHewgQYTI2
         kD4dZhvE+VUj1my1qCZnIt3irXeXBjVu6ARvsXPy2zvBVDiuQ5lFWs2QSKeZ+vhpiKDL
         EKw5jCeO9CEQR4ZXhBvrlBRnFeEHQz2FtNH3FR8vzXLrFYihInuGBSfv1/EDlvBwO7s3
         ATZmYengN4fDJa4sebZ57cRWOD2rftk3jzwvGyFNkh1A/8R9HMMwiK2b9U7u+dAWdUQ9
         6Q6DoNoxHvXfY5FHBBUQMhfijumhq5BbNibj6Im23vP/GOKyEcMgJvVewAUs+2xhXpgt
         4ZyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtjgUFV80YaOpy2BJ3nuSo9Tobg2DlHOV3Q+VpL7TKloNJxtvTZjIYv+rVGCtZQ1bNvca9U817@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8TFDVtpdEebb1rHeu+gU8DAVqdxj9jrqQ2GYdkdYtL+gCkfcz
	mxp/beY8yDXaKaoLdxrovfVqVhehqUEWKe6iPPoZp1Gt1fS+NjZAYlaJfbUyoufLsJdp2UvSeVB
	qH6Ivihs0wMB564Ja2oMi+dXevwNGIM7BvIw=
X-Gm-Gg: ASbGncumuI2Gyb4gxyvNzGCBBWeDgdEaj/Rn2bt3kVLDcaN9+tBSWKtOiowopWUUQr9
	36xS9Jcek7x8uweTbgK4O5OZZI0iw9D6ER/krzoZ5quji4ioCfZo=
X-Google-Smtp-Source: AGHT+IEWBkZRTIQmsx/m+Z2duZQ1bJWGme8LV3u4MrnAGV7lIHjwqPnLeV2gwVhluN8CmdyH/yuJ/QlVqWoC46fjgUI=
X-Received: by 2002:a17:906:7314:b0:aa6:5d30:d971 with SMTP id
 a640c23a62f3a-ab38b0b81a2mr1521066566b.11.1737405951379; Mon, 20 Jan 2025
 12:45:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250115103554.357917208@linuxfoundation.org> <20250115103554.776405922@linuxfoundation.org>
 <ACD4D6CC-C4D5-4657-A805-03C34559046E@cloudflare.com> <CAOQ4uxj21U_=_Lj0AfDHmLt2wAjQG3vhYh9hXyZ=KG-J+AUOxg@mail.gmail.com>
 <CALrw=nH2gMfZUf=7rFSDRwD7bYzm5isvaY8rVPSG-6cf21OAfA@mail.gmail.com>
In-Reply-To: <CALrw=nH2gMfZUf=7rFSDRwD7bYzm5isvaY8rVPSG-6cf21OAfA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 20 Jan 2025 21:45:40 +0100
X-Gm-Features: AbW1kvZ0gIEcaS411WOfD-bU7x2BoEbmailmkukgdIHZSO8qPhqa-mVtl_XY-Ag
Message-ID: <CAOQ4uxj+dRP2MwaOzKPbaryv9HuxmmONhug_95ATCpZHP-pzWw@mail.gmail.com>
Subject: Re: [PATCH 6.6 010/129] ovl: do not encode lower fh with upper
 sb_writers held
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2025 at 9:14=E2=80=AFPM Ignat Korchagin <ignat@cloudflare.c=
om> wrote:
>
> On Mon, Jan 20, 2025 at 6:54=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Mon, Jan 20, 2025 at 6:09=E2=80=AFPM Ignat Korchagin <ignat@cloudfla=
re.com> wrote:
> > >
> > >
> > >
> > > > On 15 Jan 2025, at 10:36, Greg Kroah-Hartman <gregkh@linuxfoundatio=
n.org> wrote:
> > > >
> > > > 6.6-stable review patch.  If anyone has any objections, please let =
me know.
> > > >
> > > > ------------------
> > > >
> > > > From: Amir Goldstein <amir73il@gmail.com>
> > > >
> > > > [ Upstream commit 5b02bfc1e7e3811c5bf7f0fa626a0694d0dbbd77 ]
> > > >
> > > > When lower fs is a nested overlayfs, calling encode_fh() on a lower
> > > > directory dentry may trigger copy up and take sb_writers on the upp=
er fs
> > > > of the lower nested overlayfs.
> > > >
> > > > The lower nested overlayfs may have the same upper fs as this overl=
ayfs,
> > > > so nested sb_writers lock is illegal.
> > > >
> > > > Move all the callers that encode lower fh to before ovl_want_write(=
).
> > > >
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > Stable-dep-of: c45beebfde34 ("ovl: support encoding fid from inode =
with no alias")
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > >
> > > Hi,
> > >
> > > This patch seems to trigger the following warning on 6.6.72, when run=
ning simple =E2=80=9C$ docker run --rm -it debian=E2=80=9D (creating a cont=
ainer):
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 12 PID: 668 at fs/namespace.c:1245 cleanup_mnt+0x130/0x=
150
> > > Modules linked in: xt_conntrack(E) nft_chain_nat(E) xt_MASQUERADE(E) =
nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) bridge(E) stp=
(E) llc(E) xfrm_user(E) xfrm_algo(E) xt_addrtype(E) nft_compat(E) nf_tables=
(E) overlay(E) kvm_amd(E) ccp(E) kvm(E) irqbypass(E) crc32_pclmul(E) sha512=
_ssse3(E) sha256_ssse3(E) sha1_ssse3(E) aesni_intel(E) crypto_simd(E) crypt=
d(E) iTCO_wdt(E) virtio_console(E) virtio_balloon(E) iTCO_vendor_support(E)=
 tiny_power_button(E) button(E) sch_fq_codel(E) fuse(E) nfnetlink(E) vsock_=
loopback(E) vmw_vsock_virtio_transport_common(E) vsock(E) efivarfs(E) ip_ta=
bles(E) x_tables(E) virtio_net(E) net_failover(E) virtio_blk(E) virtio_scsi=
(E) failover(E) crc32c_intel(E) i2c_i801(E) virtio_pci(E) virtio_pci_legacy=
_dev(E) i2c_smbus(E) lpc_ich(E) virtio_pci_modern_dev(E) mfd_core(E) virtio=
(E) virtio_ring(E)
> > > CPU: 12 PID: 668 Comm: dockerd Tainted: G E 6.6.71+ #18
> > > Hardware name: KubeVirt None/RHEL, BIOS edk2-20230524-3.el9 05/24/202=
3
> > > RIP: 0010:cleanup_mnt+0x130/0x150
> > > Code: 2c 01 00 00 85 c0 75 16 e8 6d fb ff ff eb 8a c7 87 2c 01 00 00 =
00 00 00 00 e9 6a ff ff ff c7 87 2c 01 00 00 00 00 00 00 eb de <0f> 0b 48 8=
3 bd 30 01 00 00 00 0f 84 e9 fe ff ff 48 89 ef e8 18 e7
> > > RSP: 0018:ffffc9000095fec8 EFLAGS: 00010282
> > > RAX: 00000000fffffffe RBX: 0000000000000000 RCX: 0000000000000010
> > > RDX: 0000000000000010 RSI: 0000000000000010 RDI: 0000000000000010
> > > RBP: ffff888109ea57c0 R08: ffffffffbc27ab60 R09: 0000000000000000
> > > R10: 0000000000037420 R11: 0000000000000000 R12: ffff88810acba9bc
> > > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > > FS: 00007f1041ffb6c0(0000) GS:ffff88903fc00000(0000) knlGS:0000000000=
000000
> > > CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 000000c000b7f02f CR3: 00000001034ca002 CR4: 0000000000770ee0
> > > PKRU: 55555554
> > > Call Trace:
> > > <TASK>
> > > ? cleanup_mnt+0x130/0x150
> > > ? __warn+0x81/0x130
> > > ? cleanup_mnt+0x130/0x150
> > > ? report_bug+0x16f/0x1a0
> > > ? handle_bug+0x53/0x90
> > > ? exc_invalid_op+0x17/0x70
> > > ? asm_exc_invalid_op+0x1a/0x20
> > > ? cleanup_mnt+0x130/0x150
> > > ? cleanup_mnt+0x13/0x150
> > > task_work_run+0x5d/0x90
> > > exit_to_user_mode_prepare+0xf8/0x100
> > > syscall_exit_to_user_mode+0x21/0x40
> > > ? srso_alias_return_thunk+0x5/0xfbef5
> > > do_syscall_64+0x45/0x90
> > > entry_SYSCALL_64_after_hwframe+0x60/0xca
> > > RIP: 0033:0x55d0e0726dee
> > > Code: 48 83 ec 38 e8 13 00 00 00 48 83 c4 38 5d c3 cc cc cc cc cc cc =
cc cc cc cc cc cc cc 49 89 f2 48 89 fa 48 89 ce 48 89 df 0f 05 <48> 3d 01 f=
0 ff ff 76 15 48 f7 d8 48 89 c1 48 c7 c0 ff ff ff ff 48
> > > RSP: 002b:000000c000145a10 EFLAGS: 00000216 ORIG_RAX: 00000000000000a=
6
> > > RAX: 0000000000000000 RBX: 000000c000b7fce0 RCX: 000055d0e0726dee
> > > RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000c000b7fce0
> > > RBP: 000000c000145a50 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000216 R12: 000000c000b7fce0
> > > R13: 0000000000000000 R14: 000000c000b06e00 R15: 1fffffffffffffff
> > > </TASK>
> > > ---[ end trace 0000000000000000 ]=E2=80=94
> > >
> > > This commit was pointed by my bisecting 6.6.71..6.6.72, but to double=
-check it I had to revert the following commits to make 6.6.72 compile and =
not exhibit the issue:
> >
> > Can you say what the compile error was?
> > Maybe it is easy to fix without reverting the entire bunch.
>
> Just to revert 26423e18cd6f I needed to revert a3f8a2b13a27 as well
> (otherwise there were conflicts). But then the compilation failed with
>
> fs/overlayfs/export.c: In function =E2=80=98ovl_dentry_to_fid=E2=80=99:
> fs/overlayfs/export.c:255:67: error: =E2=80=98dentry=E2=80=99 undeclared =
(first use in
> this function)
>   255 |         fh =3D ovl_encode_real_fh(ofs, enc_lower ?
> ovl_dentry_lower(dentry) :
>       |                                                                  =
 ^~~~~~
>
> so I had to revert a1a541fbfa7e as well

Care to try this backport branch without the buggy dependency
based off of v6.6.71:

https://github.com/amir73il/linux/commits/ovl-6.6.y/

Sorry, I had no time to test this, but the conflicts are pretty trivial.
I also added a manual backport of another related patch from 6.12.y
while at it.

>
> > Just by looking, it is hard for me to guess what caused the scripts to
> > pull in this dependency patch.
> >
> > >
> > >   * a3f8a2b13a277d942c810d2ccc654d5bc824a430 (=E2=80=9Covl: pass real=
inode to ovl_encode_real_fh() instead of realdentry
> > > =E2=80=9D) [ Upstream commit 07aeefae7ff44d80524375253980b1bdee2396b0=
 ]
> > >   * 26423e18cd6f709ca4fe7194c29c11658cd0cdd0 (=E2=80=9Covl: do not en=
code lower fh with upper sb_writers held=E2=80=9D) [ Upstream commit 5b02bf=
c1e7e3811c5bf7f0fa626a0694d0dbbd77 ]
> > >   * a1a541fbfa7e97c1100144db34b57553d7164ce5 ("ovl: support encoding =
fid from inode with no alias=E2=80=9D) [ Upstream commit c45beebfde34aa71af=
bc48b2c54cdda623515037 ]
> > >

These should be reverted in 6.6.y apply the backports from my branch instea=
d.

Thanks,
Amir.
