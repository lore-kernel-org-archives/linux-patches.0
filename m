Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4951EC00C
	for <patches@lists.linux.dev>; Mon, 20 Jan 2025 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737392969; cv=none; b=duClSSVnzCYOYp3noU++R0R+BcODNRkCwOgellFzzhyagZ7izk7RlRg8Irmdd//NL8XuWD4Z3X2UA2QZLFeyaX1H95jHrVdNM9CRP51Z9NxGlsRUc/l4yD+7g5pyCE/1fmOHByp1wmW0iKHg/XxS0EzUc/ea4whA7X4h4iLVtsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737392969; c=relaxed/simple;
	bh=fyS5YWpdPWUDSW9MQD8/qYtsGTtLGowRSbzIEbhuoZY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZYzqKzIaDAVPtSE5PCkQ4VFCUvGx5U/pjx3hKclxbrtvVP3Q+R3yjSRJv5s6zxtTUdY5IvdO81BI8NXarEUUTW53ZHLMfEfb93eIdvWakV5Dyjhxttgl1qcrQdxKpZOO2WYf879Bbsd6rAzl97JbQ2HFfvYvPLENXeZvC4NKOxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=XxEz0P8H; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="XxEz0P8H"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-438a39e659cso13296805e9.2
        for <patches@lists.linux.dev>; Mon, 20 Jan 2025 09:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1737392965; x=1737997765; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nr1y38ufeJALflwuVe1SFU70QoP9WOKKKxgqQ3bthxE=;
        b=XxEz0P8HTIm9eaQn6MONAKjNiwJc3kp7jaIfiDmps75Mcb/xva9IoRCB7jlPRdAhvQ
         WEPie/rQoY/YkpdHvdw6Wluhy1D3YiluYt0yd6ecWwFUJsCmFQFv+gcholZuY4bRKRRp
         sa0HUC9/7WF3H1iRMqv1CxPerKtZvX6aCqqC0S1wHVvSTVg3LPurRYODUn+3R9bKq0jP
         yIFnuKla0Ur8Gd6audZnMiKTAm4Ov6mWnvQHtsPAAGLfkz52Wy3CUPJgurOCwzmaIDDB
         SCB3Zq/yaaiMbvEIccIAmHGvFlqzQqR4/yJ/yx3mULFRhZmgM7i15RczixJWraPIjMgh
         AcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737392965; x=1737997765;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nr1y38ufeJALflwuVe1SFU70QoP9WOKKKxgqQ3bthxE=;
        b=XPwD21VJC5idVuNlcu54C69bHoJvIKTO3dFGxO6EFb1IJc/OonqsZ14Pic1f3Nbqc2
         W3iE42avqbvmf1b6B2yfrK1k5R4D7RK80ZzmYqfNq/lY4MiTks3EIjGtlgcWCIe0CJV4
         euwLYkVwA7fH/giCq0BydEz9hMEUfeUXhDSj+r9B1BkMX24g/YbligVuEfDLaP6z71ti
         5sDQLR4HKf7z5hzhsFKi7iN9ZWZGLmcl78rqXBBOvDXqwNpYWevgTKegVH01h5GSecc5
         CD4wyk31dk+7AaN6vhRf7jiHOgYZFo5XOAShYIlYsmkohzonB++djJN/OLTI5Ca6THrx
         6tgw==
X-Forwarded-Encrypted: i=1; AJvYcCXwGr2AC3f34Rzm4C73/ZNBTbWeXonYMAZ7fiGJQ/F6vkNc1jAzO3s3PC13q1tPTVHdHQ40C+Fw@lists.linux.dev
X-Gm-Message-State: AOJu0YxtZafiYM2k1PrXaKnQzDDAczF6uxxv85kgEHDu4R2kTD3SbN09
	GqLt3triKT1NRB1HL2mU+ykEncENQ/gG0gLIHg5EWHKUtw6yE8MgoXCgqGVwEUc=
X-Gm-Gg: ASbGncvdmhxMjadTJ1Bzsp3KHDpFRNp9XIfirRwMYAco+Ez2YPXpabUQwscP9rsJC+j
	YaaN8VjF63HP62ja9Ew8mR7pDN91TrKEJbWNV+EpBRzlLP5jat9u0xmHSjXS8MutL2J8B/hIbuG
	r/wLn1Io53LYlO/ZaDIVLfEcYJg/XNFHsP/gTl09RUVAAQQEWvEuaHW9s1oZlsfLzQrHg4VtPvo
	+h437LwVEHqQQYZo0K69FTskPjcQF8Ns1MQySGIupSQ8LsYIjT6LNgEWqmYVIETetMm2Sn2rkBw
	sA==
X-Google-Smtp-Source: AGHT+IGFa01kzsP341kFau49gPPQFE0Dv3uLKviYZaha+issmbSb7Z6d+WzLmwoPq1upw5nurlQFFA==
X-Received: by 2002:a05:600c:1d16:b0:436:a3a3:a70c with SMTP id 5b1f17b1804b1-438914390dbmr117049435e9.28.1737392965180;
        Mon, 20 Jan 2025 09:09:25 -0800 (PST)
Received: from smtpclient.apple ([104.28.154.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4389046bab0sm144280535e9.38.2025.01.20.09.09.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jan 2025 09:09:24 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: Re: [PATCH 6.6 010/129] ovl: do not encode lower fh with upper
 sb_writers held
From: Ignat Korchagin <ignat@cloudflare.com>
In-Reply-To: <20250115103554.776405922@linuxfoundation.org>
Date: Mon, 20 Jan 2025 17:09:12 +0000
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 Sasha Levin <sashal@kernel.org>,
 kernel-team@cloudflare.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <ACD4D6CC-C4D5-4657-A805-03C34559046E@cloudflare.com>
References: <20250115103554.357917208@linuxfoundation.org>
 <20250115103554.776405922@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Amir Goldstein <amir73il@gmail.com>
X-Mailer: Apple Mail (2.3826.300.87.4.3)



> On 15 Jan 2025, at 10:36, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> 6.6-stable review patch.  If anyone has any objections, please let me =
know.
>=20
> ------------------
>=20
> From: Amir Goldstein <amir73il@gmail.com>
>=20
> [ Upstream commit 5b02bfc1e7e3811c5bf7f0fa626a0694d0dbbd77 ]
>=20
> When lower fs is a nested overlayfs, calling encode_fh() on a lower
> directory dentry may trigger copy up and take sb_writers on the upper =
fs
> of the lower nested overlayfs.
>=20
> The lower nested overlayfs may have the same upper fs as this =
overlayfs,
> so nested sb_writers lock is illegal.
>=20
> Move all the callers that encode lower fh to before ovl_want_write().
>=20
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Stable-dep-of: c45beebfde34 ("ovl: support encoding fid from inode =
with no alias")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Hi,

This patch seems to trigger the following warning on 6.6.72, when =
running simple =E2=80=9C$ docker run --rm -it debian=E2=80=9D (creating =
a container):

------------[ cut here ]------------
WARNING: CPU: 12 PID: 668 at fs/namespace.c:1245 cleanup_mnt+0x130/0x150
Modules linked in: xt_conntrack(E) nft_chain_nat(E) xt_MASQUERADE(E) =
nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) bridge(E) =
stp(E) llc(E) xfrm_user(E) xfrm_algo(E) xt_addrtype(E) nft_compat(E) =
nf_tables(E) overlay(E) kvm_amd(E) ccp(E) kvm(E) irqbypass(E) =
crc32_pclmul(E) sha512_ssse3(E) sha256_ssse3(E) sha1_ssse3(E) =
aesni_intel(E) crypto_simd(E) cryptd(E) iTCO_wdt(E) virtio_console(E) =
virtio_balloon(E) iTCO_vendor_support(E) tiny_power_button(E) button(E) =
sch_fq_codel(E) fuse(E) nfnetlink(E) vsock_loopback(E) =
vmw_vsock_virtio_transport_common(E) vsock(E) efivarfs(E) ip_tables(E) =
x_tables(E) virtio_net(E) net_failover(E) virtio_blk(E) virtio_scsi(E) =
failover(E) crc32c_intel(E) i2c_i801(E) virtio_pci(E) =
virtio_pci_legacy_dev(E) i2c_smbus(E) lpc_ich(E) =
virtio_pci_modern_dev(E) mfd_core(E) virtio(E) virtio_ring(E)
CPU: 12 PID: 668 Comm: dockerd Tainted: G E 6.6.71+ #18
Hardware name: KubeVirt None/RHEL, BIOS edk2-20230524-3.el9 05/24/2023
RIP: 0010:cleanup_mnt+0x130/0x150
Code: 2c 01 00 00 85 c0 75 16 e8 6d fb ff ff eb 8a c7 87 2c 01 00 00 00 =
00 00 00 e9 6a ff ff ff c7 87 2c 01 00 00 00 00 00 00 eb de <0f> 0b 48 =
83 bd 30 01 00 00 00 0f 84 e9 fe ff ff 48 89 ef e8 18 e7
RSP: 0018:ffffc9000095fec8 EFLAGS: 00010282
RAX: 00000000fffffffe RBX: 0000000000000000 RCX: 0000000000000010
RDX: 0000000000000010 RSI: 0000000000000010 RDI: 0000000000000010
RBP: ffff888109ea57c0 R08: ffffffffbc27ab60 R09: 0000000000000000
R10: 0000000000037420 R11: 0000000000000000 R12: ffff88810acba9bc
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS: 00007f1041ffb6c0(0000) GS:ffff88903fc00000(0000) =
knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c000b7f02f CR3: 00000001034ca002 CR4: 0000000000770ee0
PKRU: 55555554
Call Trace:
<TASK>
? cleanup_mnt+0x130/0x150
? __warn+0x81/0x130
? cleanup_mnt+0x130/0x150
? report_bug+0x16f/0x1a0
? handle_bug+0x53/0x90
? exc_invalid_op+0x17/0x70
? asm_exc_invalid_op+0x1a/0x20
? cleanup_mnt+0x130/0x150
? cleanup_mnt+0x13/0x150
task_work_run+0x5d/0x90
exit_to_user_mode_prepare+0xf8/0x100
syscall_exit_to_user_mode+0x21/0x40
? srso_alias_return_thunk+0x5/0xfbef5
do_syscall_64+0x45/0x90
entry_SYSCALL_64_after_hwframe+0x60/0xca
RIP: 0033:0x55d0e0726dee
Code: 48 83 ec 38 e8 13 00 00 00 48 83 c4 38 5d c3 cc cc cc cc cc cc cc =
cc cc cc cc cc cc 49 89 f2 48 89 fa 48 89 ce 48 89 df 0f 05 <48> 3d 01 =
f0 ff ff 76 15 48 f7 d8 48 89 c1 48 c7 c0 ff ff ff ff 48
RSP: 002b:000000c000145a10 EFLAGS: 00000216 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 000000c000b7fce0 RCX: 000055d0e0726dee
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000c000b7fce0
RBP: 000000c000145a50 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000216 R12: 000000c000b7fce0
R13: 0000000000000000 R14: 000000c000b06e00 R15: 1fffffffffffffff
</TASK>
---[ end trace 0000000000000000 ]=E2=80=94

This commit was pointed by my bisecting 6.6.71..6.6.72, but to =
double-check it I had to revert the following commits to make 6.6.72 =
compile and not exhibit the issue:

  * a3f8a2b13a277d942c810d2ccc654d5bc824a430 (=E2=80=9Covl: pass =
realinode to ovl_encode_real_fh() instead of realdentry
=E2=80=9D) [ Upstream commit 07aeefae7ff44d80524375253980b1bdee2396b0 ]
  * 26423e18cd6f709ca4fe7194c29c11658cd0cdd0 (=E2=80=9Covl: do not =
encode lower fh with upper sb_writers held=E2=80=9D) [ Upstream commit =
5b02bfc1e7e3811c5bf7f0fa626a0694d0dbbd77 ]
  * a1a541fbfa7e97c1100144db34b57553d7164ce5 ("ovl: support encoding fid =
from inode with no alias=E2=80=9D) [ Upstream commit =
c45beebfde34aa71afbc48b2c54cdda623515037 ]

I can also confirm we don=E2=80=99t see this warning on the latest =
6.12.10 release, so perhaps we have missed some dependencies in 6.6?

Ignat

> fs/overlayfs/copy_up.c   | 53 +++++++++++++++++++++++++---------------
> fs/overlayfs/namei.c     | 37 +++++++++++++++++++++-------
> fs/overlayfs/overlayfs.h | 26 ++++++++++++++------
> fs/overlayfs/super.c     | 20 ++++++++++-----
> fs/overlayfs/util.c      | 10 ++++++++
> 5 files changed, 104 insertions(+), 42 deletions(-)
>=20
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index ada3fcc9c6d5..5c9af24bae4a 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -426,29 +426,29 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs =
*ofs, struct dentry *real,
> return ERR_PTR(err);
> }
>=20
> -int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
> -   struct dentry *upper)
> +struct ovl_fh *ovl_get_origin_fh(struct ovl_fs *ofs, struct dentry =
*origin)
> {
> - const struct ovl_fh *fh =3D NULL;
> - int err;
> -
> /*
> * When lower layer doesn't support export operations store a 'null' =
fh,
> * so we can use the overlay.origin xattr to distignuish between a copy
> * up and a pure upper inode.
> */
> - if (ovl_can_decode_fh(lower->d_sb)) {
> - fh =3D ovl_encode_real_fh(ofs, lower, false);
> - if (IS_ERR(fh))
> - return PTR_ERR(fh);
> - }
> + if (!ovl_can_decode_fh(origin->d_sb))
> + return NULL;
> +
> + return ovl_encode_real_fh(ofs, origin, false);
> +}
> +
> +int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
> +      struct dentry *upper)
> +{
> + int err;
>=20
> /*
> * Do not fail when upper doesn't support xattrs.
> */
> err =3D ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh->buf,
> fh ? fh->fb.len : 0, 0);
> - kfree(fh);
>=20
> /* Ignore -EPERM from setting "user.*" on symlink/special */
> return err =3D=3D -EPERM ? 0 : err;
> @@ -476,7 +476,7 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, =
struct dentry *upper,
>  *
>  * Caller must hold i_mutex on indexdir.
>  */
> -static int ovl_create_index(struct dentry *dentry, struct dentry =
*origin,
> +static int ovl_create_index(struct dentry *dentry, const struct =
ovl_fh *fh,
>    struct dentry *upper)
> {
> struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> @@ -502,7 +502,7 @@ static int ovl_create_index(struct dentry *dentry, =
struct dentry *origin,
> if (WARN_ON(ovl_test_flag(OVL_INDEX, d_inode(dentry))))
> return -EIO;
>=20
> - err =3D ovl_get_index_name(ofs, origin, &name);
> + err =3D ovl_get_index_name_fh(fh, &name);
> if (err)
> return err;
>=20
> @@ -541,6 +541,7 @@ struct ovl_copy_up_ctx {
> struct dentry *destdir;
> struct qstr destname;
> struct dentry *workdir;
> + const struct ovl_fh *origin_fh;
> bool origin;
> bool indexed;
> bool metacopy;
> @@ -637,7 +638,7 @@ static int ovl_copy_up_metadata(struct =
ovl_copy_up_ctx *c, struct dentry *temp)
> * hard link.
> */
> if (c->origin) {
> - err =3D ovl_set_origin(ofs, c->lowerpath.dentry, temp);
> + err =3D ovl_set_origin_fh(ofs, c->origin_fh, temp);
> if (err)
> return err;
> }
> @@ -749,7 +750,7 @@ static int ovl_copy_up_workdir(struct =
ovl_copy_up_ctx *c)
> goto cleanup;
>=20
> if (S_ISDIR(c->stat.mode) && c->indexed) {
> - err =3D ovl_create_index(c->dentry, c->lowerpath.dentry, temp);
> + err =3D ovl_create_index(c->dentry, c->origin_fh, temp);
> if (err)
> goto cleanup;
> }
> @@ -861,6 +862,8 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx =
*c)
> {
> int err;
> struct ovl_fs *ofs =3D OVL_FS(c->dentry->d_sb);
> + struct dentry *origin =3D c->lowerpath.dentry;
> + struct ovl_fh *fh =3D NULL;
> bool to_index =3D false;
>=20
> /*
> @@ -877,17 +880,25 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx =
*c)
> to_index =3D true;
> }
>=20
> - if (S_ISDIR(c->stat.mode) || c->stat.nlink =3D=3D 1 || to_index)
> + if (S_ISDIR(c->stat.mode) || c->stat.nlink =3D=3D 1 || to_index) {
> + fh =3D ovl_get_origin_fh(ofs, origin);
> + if (IS_ERR(fh))
> + return PTR_ERR(fh);
> +
> + /* origin_fh may be NULL */
> + c->origin_fh =3D fh;
> c->origin =3D true;
> + }
>=20
> if (to_index) {
> c->destdir =3D ovl_indexdir(c->dentry->d_sb);
> - err =3D ovl_get_index_name(ofs, c->lowerpath.dentry, &c->destname);
> + err =3D ovl_get_index_name(ofs, origin, &c->destname);
> if (err)
> - return err;
> + goto out_free_fh;
> } else if (WARN_ON(!c->parent)) {
> /* Disconnected dentry must be copied up to index dir */
> - return -EIO;
> + err =3D -EIO;
> + goto out_free_fh;
> } else {
> /*
> * Mark parent "impure" because it may now contain non-pure
> @@ -895,7 +906,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx =
*c)
> */
> err =3D ovl_set_impure(c->parent, c->destdir);
> if (err)
> - return err;
> + goto out_free_fh;
> }
>=20
> /* Should we copyup with O_TMPFILE or with workdir? */
> @@ -927,6 +938,8 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx =
*c)
> out:
> if (to_index)
> kfree(c->destname.name);
> +out_free_fh:
> + kfree(fh);
> return err;
> }
>=20
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 80391c687c2a..f10ac4ae35f0 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -507,6 +507,19 @@ static int ovl_verify_fh(struct ovl_fs *ofs, =
struct dentry *dentry,
> return err;
> }
>=20
> +int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
> +      enum ovl_xattr ox, const struct ovl_fh *fh,
> +      bool is_upper, bool set)
> +{
> + int err;
> +
> + err =3D ovl_verify_fh(ofs, dentry, ox, fh);
> + if (set && err =3D=3D -ENODATA)
> + err =3D ovl_setxattr(ofs, dentry, ox, fh->buf, fh->fb.len);
> +
> + return err;
> +}
> +
> /*
>  * Verify that @real dentry matches the file handle stored in xattr =
@name.
>  *
> @@ -515,9 +528,9 @@ static int ovl_verify_fh(struct ovl_fs *ofs, =
struct dentry *dentry,
>  *
>  * Return 0 on match, -ESTALE on mismatch, -ENODATA on no xattr, < 0 =
on error.
>  */
> -int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
> -      enum ovl_xattr ox, struct dentry *real, bool is_upper,
> -      bool set)
> +int ovl_verify_origin_xattr(struct ovl_fs *ofs, struct dentry =
*dentry,
> +    enum ovl_xattr ox, struct dentry *real,
> +    bool is_upper, bool set)
> {
> struct inode *inode;
> struct ovl_fh *fh;
> @@ -530,9 +543,7 @@ int ovl_verify_set_fh(struct ovl_fs *ofs, struct =
dentry *dentry,
> goto fail;
> }
>=20
> - err =3D ovl_verify_fh(ofs, dentry, ox, fh);
> - if (set && err =3D=3D -ENODATA)
> - err =3D ovl_setxattr(ofs, dentry, ox, fh->buf, fh->fb.len);
> + err =3D ovl_verify_set_fh(ofs, dentry, ox, fh, is_upper, set);
> if (err)
> goto fail;
>=20
> @@ -548,6 +559,7 @@ int ovl_verify_set_fh(struct ovl_fs *ofs, struct =
dentry *dentry,
> goto out;
> }
>=20
> +
> /* Get upper dentry from index */
> struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry =
*index,
>       bool connected)
> @@ -684,7 +696,7 @@ int ovl_verify_index(struct ovl_fs *ofs, struct =
dentry *index)
> goto out;
> }
>=20
> -static int ovl_get_index_name_fh(struct ovl_fh *fh, struct qstr =
*name)
> +int ovl_get_index_name_fh(const struct ovl_fh *fh, struct qstr *name)
> {
> char *n, *s;
>=20
> @@ -873,20 +885,27 @@ int ovl_path_next(int idx, struct dentry =
*dentry, struct path *path)
> static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
>  struct dentry *lower, struct dentry *upper)
> {
> + const struct ovl_fh *fh;
> int err;
>=20
> if (ovl_check_origin_xattr(ofs, upper))
> return 0;
>=20
> + fh =3D ovl_get_origin_fh(ofs, lower);
> + if (IS_ERR(fh))
> + return PTR_ERR(fh);
> +
> err =3D ovl_want_write(dentry);
> if (err)
> - return err;
> + goto out;
>=20
> - err =3D ovl_set_origin(ofs, lower, upper);
> + err =3D ovl_set_origin_fh(ofs, fh, upper);
> if (!err)
> err =3D ovl_set_impure(dentry->d_parent, upper->d_parent);
>=20
> ovl_drop_write(dentry);
> +out:
> + kfree(fh);
> return err;
> }
>=20
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 09ca82ed0f8c..61e03d664d7d 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -632,11 +632,15 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs =
*ofs, struct ovl_fh *fh,
> int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool =
connected,
> struct dentry *upperdentry, struct ovl_path **stackp);
> int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
> -      enum ovl_xattr ox, struct dentry *real, bool is_upper,
> -      bool set);
> +      enum ovl_xattr ox, const struct ovl_fh *fh,
> +      bool is_upper, bool set);
> +int ovl_verify_origin_xattr(struct ovl_fs *ofs, struct dentry =
*dentry,
> +    enum ovl_xattr ox, struct dentry *real,
> +    bool is_upper, bool set);
> struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry =
*index,
>       bool connected);
> int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
> +int ovl_get_index_name_fh(const struct ovl_fh *fh, struct qstr =
*name);
> int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
>       struct qstr *name);
> struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh =
*fh);
> @@ -648,17 +652,24 @@ struct dentry *ovl_lookup(struct inode *dir, =
struct dentry *dentry,
>  unsigned int flags);
> bool ovl_lower_positive(struct dentry *dentry);
>=20
> +static inline int ovl_verify_origin_fh(struct ovl_fs *ofs, struct =
dentry *upper,
> +       const struct ovl_fh *fh, bool set)
> +{
> + return ovl_verify_set_fh(ofs, upper, OVL_XATTR_ORIGIN, fh, false, =
set);
> +}
> +
> static inline int ovl_verify_origin(struct ovl_fs *ofs, struct dentry =
*upper,
>    struct dentry *origin, bool set)
> {
> - return ovl_verify_set_fh(ofs, upper, OVL_XATTR_ORIGIN, origin,
> - false, set);
> + return ovl_verify_origin_xattr(ofs, upper, OVL_XATTR_ORIGIN, origin,
> +       false, set);
> }
>=20
> static inline int ovl_verify_upper(struct ovl_fs *ofs, struct dentry =
*index,
>   struct dentry *upper, bool set)
> {
> - return ovl_verify_set_fh(ofs, index, OVL_XATTR_UPPER, upper, true, =
set);
> + return ovl_verify_origin_xattr(ofs, index, OVL_XATTR_UPPER, upper,
> +       true, set);
> }
>=20
> /* readdir.c */
> @@ -823,8 +834,9 @@ int ovl_copy_xattr(struct super_block *sb, const =
struct path *path, struct dentr
> int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upper, struct =
kstat *stat);
> struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry =
*real,
>  bool is_upper);
> -int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
> -   struct dentry *upper);
> +struct ovl_fh *ovl_get_origin_fh(struct ovl_fs *ofs, struct dentry =
*origin);
> +int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
> +      struct dentry *upper);
>=20
> /* export.c */
> extern const struct export_operations ovl_export_operations;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 2c056d737c27..e2574034c3fa 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -879,15 +879,20 @@ static int ovl_get_indexdir(struct super_block =
*sb, struct ovl_fs *ofs,
> {
> struct vfsmount *mnt =3D ovl_upper_mnt(ofs);
> struct dentry *indexdir;
> + struct dentry *origin =3D ovl_lowerstack(oe)->dentry;
> + const struct ovl_fh *fh;
> int err;
>=20
> + fh =3D ovl_get_origin_fh(ofs, origin);
> + if (IS_ERR(fh))
> + return PTR_ERR(fh);
> +
> err =3D mnt_want_write(mnt);
> if (err)
> - return err;
> + goto out_free_fh;
>=20
> /* Verify lower root is upper root origin */
> - err =3D ovl_verify_origin(ofs, upperpath->dentry,
> - ovl_lowerstack(oe)->dentry, true);
> + err =3D ovl_verify_origin_fh(ofs, upperpath->dentry, fh, true);
> if (err) {
> pr_err("failed to verify upper root origin\n");
> goto out;
> @@ -919,9 +924,10 @@ static int ovl_get_indexdir(struct super_block =
*sb, struct ovl_fs *ofs,
> * directory entries.
> */
> if (ovl_check_origin_xattr(ofs, ofs->indexdir)) {
> - err =3D ovl_verify_set_fh(ofs, ofs->indexdir,
> - OVL_XATTR_ORIGIN,
> - upperpath->dentry, true, false);
> + err =3D ovl_verify_origin_xattr(ofs, ofs->indexdir,
> +      OVL_XATTR_ORIGIN,
> +      upperpath->dentry, true,
> +      false);
> if (err)
> pr_err("failed to verify index dir 'origin' xattr\n");
> }
> @@ -939,6 +945,8 @@ static int ovl_get_indexdir(struct super_block =
*sb, struct ovl_fs *ofs,
>=20
> out:
> mnt_drop_write(mnt);
> +out_free_fh:
> + kfree(fh);
> return err;
> }
>=20
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 0bf3ffcd072f..4e6b747e0f2e 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -976,12 +976,18 @@ static void ovl_cleanup_index(struct dentry =
*dentry)
> struct dentry *index =3D NULL;
> struct inode *inode;
> struct qstr name =3D { };
> + bool got_write =3D false;
> int err;
>=20
> err =3D ovl_get_index_name(ofs, lowerdentry, &name);
> if (err)
> goto fail;
>=20
> + err =3D ovl_want_write(dentry);
> + if (err)
> + goto fail;
> +
> + got_write =3D true;
> inode =3D d_inode(upperdentry);
> if (!S_ISDIR(inode->i_mode) && inode->i_nlink !=3D 1) {
> pr_warn_ratelimited("cleanup linked index (%pd2, ino=3D%lu, =
nlink=3D%u)\n",
> @@ -1019,6 +1025,8 @@ static void ovl_cleanup_index(struct dentry =
*dentry)
> goto fail;
>=20
> out:
> + if (got_write)
> + ovl_drop_write(dentry);
> kfree(name.name);
> dput(index);
> return;
> @@ -1089,6 +1097,8 @@ void ovl_nlink_end(struct dentry *dentry)
> {
> struct inode *inode =3D d_inode(dentry);
>=20
> + ovl_drop_write(dentry);
> +
> if (ovl_test_flag(OVL_INDEX, inode) && inode->i_nlink =3D=3D 0) {
> const struct cred *old_cred;
>=20
> --=20
> 2.39.5
>=20
>=20
>=20
>=20

