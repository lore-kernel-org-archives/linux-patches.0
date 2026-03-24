Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21093397E97;
	Tue, 24 Mar 2026 15:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774366590; cv=none; b=V1KXi0XSlvwes1Wg/Wlh2y4vTrk1s+P+KCLqEHvQw4VWvkLrNhiFKmjJXa7BiFVVOGr6PjibTXS0m4fxQJ2udzO0s3xr94FcZBqmTP5PQeHYHgBEHBC10hdCXjQpin6FsIKL2HLxBew8TBMR26RamJgXnKX0HsMNz4ljvVu5c0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774366590; c=relaxed/simple;
	bh=KCHxUzmWbLNKy1drrRsHk3TR1rCpYa9StaBFImw7sk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DawIh/S3rW8pyCmxqpMIL81xo7i/siuZWdcGU7tHpWPS/h1qAfoLMYTB179n1te4mINT2n+4aaRjGs4d1A8BMCRgyl0ACacBpSz9IO7VV8zGTnIHlCEjGV8Nj2oLhgamHgnz0XlTiS99m7ogPWUyd7rb2SOtzIlcF8jFJSWp5Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6XY+wzj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6XY+wzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF8CC19424;
	Tue, 24 Mar 2026 15:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774366589;
	bh=KCHxUzmWbLNKy1drrRsHk3TR1rCpYa9StaBFImw7sk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n6XY+wzj3/Vr+KXSySB5qX+3cAB97WxhVm2HfVo8PS7TGswwP7BPt3fMG/0WCLYN+
	 sPWRqpkH+IxkxWkWo0QfU7bY7WMrFkXyDSkJC9gt9BnYrxZuwZfmKvu50LvBbaK/54
	 0Dp7fSxSdyVPhkBhl9lqO1gIerxt6S/f+hZz0DbZhTpzUmQe4NiKiyDupy1P6eqO6e
	 ihY9qkKB7LC/e7Ixkbf+5hFVlcB1Vf7O88q5VxAH6yN9EhmnZUeUUbuG5iaUbaYNVE
	 +oF4RnsvHnPhMPOufmPLARHcacOmt+BDAVjUkj2jWfY8H5T78yCxdHRQIJw3OP5jfM
	 Blj/OkxnbeC0w==
Date: Tue, 24 Mar 2026 15:36:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Brian Foster <bfoster@redhat.com>,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Matthew Wilcox <willy@infradead.org>,
	Gou Hao <gouhao@uniontech.com>, Theodore Ts'o <tytso@mit.edu>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Zhang Yi <yi.zhang@huawei.com>, Baokun Li <libaokun1@huawei.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
Message-ID: <d8080343-20cd-4a4a-b726-b9e3c6a5c5eb@sirena.org.uk>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260324073447.GA5062@francesco-nb>
 <mhqesgj3u7dr33zit6iwjhykw2zpuallru4qvoloyyqzdqgvki@bpwwmihh357r>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WZ2Eyfqnzhln8diZ"
Content-Disposition: inline
In-Reply-To: <mhqesgj3u7dr33zit6iwjhykw2zpuallru4qvoloyyqzdqgvki@bpwwmihh357r>
X-Cookie: Forest fires cause Smokey Bears.


--WZ2Eyfqnzhln8diZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2026 at 02:40:31PM +0100, Jan Kara wrote:
> On Tue 24-03-26 08:34:47, Francesco Dolcini wrote:

> > I have an ext4 Oops on arm

> > [   27.908560] 8<--- cut here ---
> > [   27.911697] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> > [   27.919880] [00000000] *pgd=00000000
> > [   27.923482] Internal error: Oops: 5 [#1] SMP ARM
> > [   27.928117] Modules linked in: 8021q cfg80211 imx_sdma coda_vpu v4l2_jpeg imx_vdoa dw_hdmi_ahb_audio fuse
> > [   27.937784] CPU: 1 PID: 736 Comm: tar Not tainted 6.1.167-rc1-6.8.6-devel+git.67c872a868ac #1
> > [   27.946342] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> > [   27.952889] PC is at ext4_mb_load_buddy_gfp+0xac/0x438

> Can you run this through "addr2line -i" to get exact position in that big
> function? Because from a quick look it doesn't ring a bell...

I have a bisect for an ext4 issue in v6.1 which comes out at:

# first bad commit: [29897d75d6491ffe23cdc9d96caba9282a20dfc3] ext4: convert bd_bitmap_page to bd_bitmap_folio

For an oops which looks very similar (but on arm64):

[  217.347067] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000

...

[  217.567412] Call trace:
[  217.569884] ext4_mb_load_buddy_gfp (include/asm-generic/bitops/generic-non-atomic.h:128 include/linux/page-flags.h:719 fs/ext4/mballoc.c:1536)
[  217.574388] ext4_discard_preallocations (fs/ext4/mballoc.c:5137)
[  217.579421] ext4_release_file (fs/ext4/file.c:167 (discriminator 1))
[  217.583396] __fput (fs/file_table.c:321 (discriminator 1))
[  217.586490] ____fput (fs/file_table.c:349)
[  217.589671] task_work_run (kernel/task_work.c:206 (discriminator 1))
[  217.593294] do_notify_resume (include/linux/resume_user_mode.h:49 arch/arm64/kernel/signal.c:1151)
[  217.597358] el0_svc (arch/arm64/kernel/entry-common.c:639)
[  217.600452] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:656)
[  217.604866] el0t_64_sync (arch/arm64/kernel/entry.S:585)

Full log:

   https://lava.sirena.org.uk/scheduler/job/2595460#L3223

vmlinux:

   https://builds.sirena.org.uk/67c872a868ac98d7af3b5598c399eec173c1eb03/arm64/defconfig/vmlinux.xz

Full bisect log:

# bad: [67c872a868ac98d7af3b5598c399eec173c1eb03] Linux 6.1.167-rc1
# good: [f2ddafa93a259310ca47507153b7811ec54ab7fd] Linux 6.1.166
git bisect start '67c872a868ac98d7af3b5598c399eec173c1eb03' 'f2ddafa93a259310ca47507153b7811ec54ab7fd'
# test job: [67c872a868ac98d7af3b5598c399eec173c1eb03] https://lava.sirena.org.uk/scheduler/job/2595460
# bad: [67c872a868ac98d7af3b5598c399eec173c1eb03] Linux 6.1.167-rc1
git bisect bad 67c872a868ac98d7af3b5598c399eec173c1eb03
# test job: [19577ea2af78e1668d2dd7dd8ff49329363c8de6] https://lava.sirena.org.uk/scheduler/job/2596565
# bad: [19577ea2af78e1668d2dd7dd8ff49329363c8de6] parisc: Increase initial mapping to 64 MB with KALLSYMS
git bisect bad 19577ea2af78e1668d2dd7dd8ff49329363c8de6
# test job: [525e916e0f088809ef9111088480f7271d0c63cb] https://lava.sirena.org.uk/scheduler/job/2596655
# bad: [525e916e0f088809ef9111088480f7271d0c63cb] octeon_ep: avoid compiler and IQ/OQ reordering
git bisect bad 525e916e0f088809ef9111088480f7271d0c63cb
# test job: [be91f915a7a7e3c089fe5edaaae047dfed585492] https://lava.sirena.org.uk/scheduler/job/2596752
# bad: [be91f915a7a7e3c089fe5edaaae047dfed585492] usb: cdns3: remove redundant if branch
git bisect bad be91f915a7a7e3c089fe5edaaae047dfed585492
# test job: [7aaacb29d6420a3d9b09386545ee2d3afb5df5f3] https://lava.sirena.org.uk/scheduler/job/2596861
# good: [7aaacb29d6420a3d9b09386545ee2d3afb5df5f3] media: tegra-video: Use accessors for pad config 'try_*' fields
git bisect good 7aaacb29d6420a3d9b09386545ee2d3afb5df5f3
# test job: [d21133e5855b8a332718992df631a151276b3a93] https://lava.sirena.org.uk/scheduler/job/2596893
# good: [d21133e5855b8a332718992df631a151276b3a93] ext4: don't zero the entire extent if EXT4_EXT_DATA_PARTIAL_VALID1
git bisect good d21133e5855b8a332718992df631a151276b3a93
# test job: [fe80bba8f76f9f0995cdc64fc89b65173e1ae828] https://lava.sirena.org.uk/scheduler/job/2596923
# bad: [fe80bba8f76f9f0995cdc64fc89b65173e1ae828] ext4: convert bd_buddy_page to bd_buddy_folio
git bisect bad fe80bba8f76f9f0995cdc64fc89b65173e1ae828
# test job: [b41ad91ef08bd65607929c01da58a745c52f099a] https://lava.sirena.org.uk/scheduler/job/2596982
# good: [b41ad91ef08bd65607929c01da58a745c52f099a] ext4: remove unnecessary e4b->bd_buddy_page check in ext4_mb_load_buddy_gfp
git bisect good b41ad91ef08bd65607929c01da58a745c52f099a
# test job: [500bdda4b7db98fc1f979670924696d7ce449124] https://lava.sirena.org.uk/scheduler/job/2597035
# good: [500bdda4b7db98fc1f979670924696d7ce449124] ext4: delete redundant calculations in ext4_mb_get_buddy_page_lock()
git bisect good 500bdda4b7db98fc1f979670924696d7ce449124
# test job: [29897d75d6491ffe23cdc9d96caba9282a20dfc3] https://lava.sirena.org.uk/scheduler/job/2597064
# bad: [29897d75d6491ffe23cdc9d96caba9282a20dfc3] ext4: convert bd_bitmap_page to bd_bitmap_folio
git bisect bad 29897d75d6491ffe23cdc9d96caba9282a20dfc3
# first bad commit: [29897d75d6491ffe23cdc9d96caba9282a20dfc3] ext4: convert bd_bitmap_page to bd_bitmap_folio


--WZ2Eyfqnzhln8diZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnCr3UACgkQJNaLcl1U
h9AhPwf+LnCAWljh+Jg2oZwMn++V5J5sjjTB3AZdnIZ2nm1G7xpwUZu6SJ+SOtXJ
K0ICuKlUgVEUzTosryWfZJXQrd3qKVcW/ENhqZSRQ2P6u8Yo/4k22z0u5Ndl03Dz
ToG6diitF0/hl8Z3lbJfuWJWjKeKorYIoeW4ipOHDNYus1qJi1w4OOadAYQezI28
pQJsJUiQvEz3Or3Hf4R5Aj3taFS5kWNlhRz0ZDpkwvaYy6avBPTxsZyV0mrlkVOI
uXXXZWtT3fh3u3asVa9n4KypMZ5XxMrmk4bBupeIM2nqNO+i8cYOERhJa3ONnAlr
qvLQqt6JiwXoFhNvmXRhKk7jqbtg9A==
=SM+X
-----END PGP SIGNATURE-----

--WZ2Eyfqnzhln8diZ--
