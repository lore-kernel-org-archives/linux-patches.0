Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33C114A0A8
	for <patches@lists.linux.dev>; Tue, 20 Aug 2024 09:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724147364; cv=none; b=MViDlr7jBihr9a2WdDfPTo17D2emiu0fSnxTMiOKPHJqwGiTtdGV4+mmUBijC0ZT9OvtHYe7h0lNyQiwrskjtbiQAjJgm45xACzPLuSJhu/4yGZpQ3SdUHZFV5a4z6eKSMcEaEKKHkT2zQ25VzLtVS63FjPxnLpGZ2F5qLR2+vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724147364; c=relaxed/simple;
	bh=3JqT0Gg2JeFp/g987sd4pECRj7D9ynfXjo/MZ7zyE80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svu1NhHAAnGNGngx9Ll4gaRzOR9n0QLsmXjLx3KAuMSsZXyI7DyDP1SAcK/BmQ1tlpCSQHhfHBHyMXMBhR+P7vx+3ulDlF0gHhloR9S9O4RELuQUf2SVLh8K/dwj+g7MOjutx44yPJkmtK5rBHmlGjjiRA8nIwsPUuMnY2Gcynw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 01B221C0082; Tue, 20 Aug 2024 11:49:14 +0200 (CEST)
Date: Tue, 20 Aug 2024 11:49:13 +0200
From: Pavel Machek <pavel@denx.de>
To: Florian Bezdeka <florian.bezdeka@siemens.com>
Cc: Chris Paterson <Chris.Paterson2@renesas.com>,
	Pavel Machek <pavel@denx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux@roeck-us.net" <linux@roeck-us.net>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"patches@kernelci.org" <patches@kernelci.org>,
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
	"jonathanh@nvidia.com" <jonathanh@nvidia.com>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
	"srw@sladewatkins.net" <srw@sladewatkins.net>,
	"rwarsow@gmx.de" <rwarsow@gmx.de>,
	"conor@kernel.org" <conor@kernel.org>,
	"allen.lkml@gmail.com" <allen.lkml@gmail.com>,
	"broonie@kernel.org" <broonie@kernel.org>,
	Quirin Gylstorff <quirin.gylstorff@siemens.com>
Subject: Re: [PATCH 6.10 00/25] 6.10.6-rc3 review
Message-ID: <ZsRmmQOLiZ1KtQ1T@duo.ucw.cz>
References: <20240817085406.129098889@linuxfoundation.org>
 <ZsMNYtjBBUE5Ehqy@duo.ucw.cz>
 <TYYPR01MB12402A34A443D1F3A6556D902B78C2@TYYPR01MB12402.jpnprd01.prod.outlook.com>
 <0e62552b7b9c1cd1eca6aa1af64006c53230c4f0.camel@siemens.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0fLL3hkzIqPUgSKV"
Content-Disposition: inline
In-Reply-To: <0e62552b7b9c1cd1eca6aa1af64006c53230c4f0.camel@siemens.com>


--0fLL3hkzIqPUgSKV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > So we could blame it on the qemu-cip-siemens-muc machine, however, it w=
as quite happily booting 6.10.6-rc1 a few days ago:
> > https://lava.ciplatform.org/scheduler/job/1180857
> > 6.10.6-rc2 was also okay:
> > https://lava.ciplatform.org/scheduler/job/1181017
>=20
> As Chris pointed out that this might be related to our qemu instance in
> the CIP lab. We had a look and found the attached kernel splat. This
> seems not a guest but a host problem (which is Debian/6.1 based and not
> 6.10).

Aha, thanks a lot, things make sense now.

> I think you can continue, ignore the test result for this 6.10 release
> for now.=20
>=20
> We will investigate further. Let's see.
>=20
> For completeness the kernel log of the host is attached. LAVA runs into
> a timeout and marks the job as failed.

Thanks for the log. It seems something is seriously wrong with the
machine, likely deadlock in ext4 or storage subsystems. If there are
any suspect messages before this one, they may be useful.

Best regards,
								Pavel

> [1639290.742208] INFO: task lava-run [job: :70173 blocked for more than 1=
20 seconds.
> [1639290.742223]       Not tainted 6.1.0-22-amd64 #1 Debian 6.1.94-1
> [1639290.742231] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
> [1639290.742241] task:lava-run [job:  state:D stack:0     pid:70173 ppid:=
2131   flags:0x00000002
> [1639290.742244] Call Trace:
> [1639290.742245]  <TASK>
> [1639290.742247]  __schedule+0x34d/0x9e0
> [1639290.742253]  schedule+0x5a/0xd0
> [1639290.742255]  wb_wait_for_completion+0x82/0xb0
> [1639290.742258]  ? cpuusage_read+0x10/0x10
> [1639290.742261]  __writeback_inodes_sb_nr+0xa0/0xd0
> [1639290.742263]  try_to_writeback_inodes_sb+0x55/0x70
> [1639290.742266]  ext4_nonda_switch+0x80/0x90 [ext4]
> [1639290.742289]  ext4_da_write_begin+0x61/0x2c0 [ext4]
> [1639290.742306]  ? __file_remove_privs+0xbb/0x150
> [1639290.742309]  generic_perform_write+0xcd/0x210
> [1639290.742313]  ext4_buffered_write_iter+0x84/0x140 [ext4]
> [1639290.742328]  vfs_write+0x232/0x3e0
> [1639290.742332]  ksys_write+0x6b/0xf0
> [1639290.742334]  do_syscall_64+0x55/0xb0
> [1639290.742337]  ? ksys_read+0x6b/0xf0
> [1639290.742339]  ? exit_to_user_mode_prepare+0x44/0x1f0
> [1639290.742342]  ? syscall_exit_to_user_mode+0x1e/0x40
> [1639290.742344]  ? do_syscall_64+0x61/0xb0
> [1639290.742345]  ? syscall_exit_to_user_mode+0x1e/0x40
> [1639290.742347]  ? do_syscall_64+0x61/0xb0
> [1639290.742349]  ? do_syscall_64+0x61/0xb0
> [1639290.742350]  ? __do_sys_newfstatat+0x4e/0x80
> [1639290.742353]  ? exit_to_user_mode_prepare+0x44/0x1f0
> [1639290.742355]  ? syscall_exit_to_user_mode+0x1e/0x40
> [1639290.742357]  ? do_syscall_64+0x61/0xb0
> [1639290.742358]  ? syscall_exit_to_user_mode+0x1e/0x40
> [1639290.742360]  ? do_syscall_64+0x61/0xb0
> [1639290.742362]  ? syscall_exit_to_user_mode+0x1e/0x40
> [1639290.742363]  ? do_syscall_64+0x61/0xb0
> [1639290.742365]  ? do_syscall_64+0x61/0xb0
> [1639290.742366]  ? do_syscall_64+0x61/0xb0
> [1639290.742367]  ? do_syscall_64+0x61/0xb0
> [1639290.742369]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> [1639290.742371] RIP: 0033:0x7fc69729e240
> [1639290.742373] RSP: 002b:00007ffcfc6840e8 EFLAGS: 00000202 ORIG_RAX: 00=
00000000000001
> [1639290.742375] RAX: ffffffffffffffda RBX: 0000000000a860f8 RCX: 00007fc=
69729e240
> [1639290.742376] RDX: 0000000000004000 RSI: 00000000019198d0 RDI: 0000000=
00000000d
> [1639290.742378] RBP: 0000000000004000 R08: 0000000000000000 R09: 0000000=
000000000
> [1639290.742378] R10: 0000000000000003 R11: 0000000000000202 R12: 00007fc=
6971a4fc0
> [1639290.742380] R13: 000000000000000d R14: 0000000000a440e0 R15: 0000000=
000000000
> [1639290.742382]  </TASK>
> [1639411.519101] INFO: task lava-run [job: :70173 blocked for more than 2=
41 seconds.
> [1639411.519115]       Not tainted 6.1.0-22-amd64 #1 Debian 6.1.94-1


--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--0fLL3hkzIqPUgSKV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZsRmmQAKCRAw5/Bqldv6
8pGKAJ9RHSELhrd+5IPl20N6+p5iKhqNDACfaupYKHpsBvI2lsUI1fMmzE1anAw=
=LDAA
-----END PGP SIGNATURE-----

--0fLL3hkzIqPUgSKV--
