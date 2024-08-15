Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C424D19EECF;
	Thu, 15 Aug 2024 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729153; cv=none; b=HRwFSGCQk02DnhZOhDhI7odVzrFQjL6+2vI5GrLDWnbhI4BphVWzbEevCMM1e6lJzLWkUE/LI7QWIGFhK6sro+A2Hv/AYKLNJC7mV5qlMXcGzSpfB6I9lMXo5FXZRXIepNd6tvEwN0k700mkkwYtFD4s0waMroONy7X96Cec3rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729153; c=relaxed/simple;
	bh=wfNjkiwjF3OQQaLpX0or6c2Q95TUZGbxbvgApXQCKn4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=swHAAVpJ+fek+9qF4hufrSQvXe1SpHHVfh6DUS2nuTHr15zIplKEMMQtAkCr/HfzafiaJTRIMR+XEfYJeOSBtjl3/i5giovrrjOZwbxQukrZ5wMhPZPm4mkJIE1bmg6CjSeKwgmeCkFZZEe8zpiLdLXlFfkA1bz3hyrkFOgQODo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RD1ZA3IO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RD1ZA3IO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50C9C4AF0A;
	Thu, 15 Aug 2024 13:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729153;
	bh=wfNjkiwjF3OQQaLpX0or6c2Q95TUZGbxbvgApXQCKn4=;
	h=From:To:Cc:Subject:Date:From;
	b=RD1ZA3IODvwLqwVDN+JLa1dWLE1WA+A3i7sWEUi62zpwIhS23RgIw7DEf44lM3Ft+
	 l4b+/2cn/ItD7TvTYDzndkJ9SrT45QAkfhT0GxzTumv+FsBYwOfibkpvSexup2jFOt
	 vcvaQnP06Ynm5owTVJaOFHb4cN3ToFnQXmwRvVN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.10 00/22] 6.10.6-rc1 review
Date: Thu, 15 Aug 2024 15:25:08 +0200
Message-ID: <20240815131831.265729493@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.10.6-rc1
X-KernelTest-Deadline: 2024-08-17T13:18+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.10.6 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.10.6-rc1

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu/display: Fix null pointer dereference in dc_stream_program_cursor_position

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Solve mst monitors blank out problem after resume

Kees Cook <kees@kernel.org>
    binfmt_flat: Fix corruption when not offsetting data start

Gergo Koteles <soyer@irl.hu>
    platform/x86: ideapad-laptop: add a mutex to synchronize VPC commands

Gergo Koteles <soyer@irl.hu>
    platform/x86: ideapad-laptop: move ymc_trigger_ec from lenovo-ymc

Gergo Koteles <soyer@irl.hu>
    platform/x86: ideapad-laptop: introduce a generic notification chain

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: Fix to Update HPD Data When ALS is Disabled

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: Fix UBSAN warning in parse_audio_unit()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Do copy_to_user out of run_lock

Pei Li <peili.dev@gmail.com>
    jfs: Fix shift-out-of-bounds in dbDiscardAG

Edward Adam Davis <eadavis@qq.com>
    jfs: fix null ptr deref in dtInsertEntry

Willem de Bruijn <willemb@google.com>
    fou: remove warn in gue_gro_receive on unsupported protocol

Chao Yu <chao@kernel.org>
    f2fs: fix to cover read extent cache access with lock

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on F2FS_INLINE_DATA flag in inode during GC

yunshui <jiangyunshui@kylinos.cn>
    bpf, net: Use DEV_STAT_INC()

Simon Trimmer <simont@opensource.cirrus.com>
    ASoC: cs35l56: Patch CS35L56_IRQ1_MASK_18 to the default value

WangYuli <wangyuli@uniontech.com>
    nvme/pci: Add APST quirk for Lenovo N60z laptop

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Define __ARCH_WANT_NEW_STAT in unistd.h

Fangzhi Zuo <jerry.zuo@amd.com>
    drm/amd/display: Prevent IPX From Link Detect and Set Mode

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Separate setting and programming of cursor

Wayne Lin <wayne.lin@amd.com>
    drm/amd/display: Defer handling mst up request in resume

Kees Cook <kees@kernel.org>
    exec: Fix ToCToU between perm check and set-uid/gid usage


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/loongarch/include/uapi/asm/unistd.h           |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  14 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |  94 ++++++++-----
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |   8 ++
 .../drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c    |   2 +-
 drivers/nvme/host/pci.c                            |   7 +
 drivers/platform/x86/Kconfig                       |   1 +
 drivers/platform/x86/amd/pmf/spc.c                 |  32 ++---
 drivers/platform/x86/ideapad-laptop.c              | 148 ++++++++++++++++++---
 drivers/platform/x86/ideapad-laptop.h              |   9 ++
 drivers/platform/x86/lenovo-ymc.c                  |  60 +--------
 fs/binfmt_flat.c                                   |   4 +-
 fs/exec.c                                          |   8 +-
 fs/f2fs/extent_cache.c                             |  50 +++----
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/gc.c                                       |  10 ++
 fs/f2fs/inode.c                                    |  10 +-
 fs/jfs/jfs_dmap.c                                  |   2 +
 fs/jfs/jfs_dtree.c                                 |   2 +
 fs/ntfs3/frecord.c                                 |  75 ++++++++++-
 net/core/filter.c                                  |   8 +-
 net/ipv4/fou_core.c                                |   2 +-
 sound/soc/codecs/cs35l56-shared.c                  |   1 +
 sound/usb/mixer.c                                  |   7 +
 26 files changed, 388 insertions(+), 179 deletions(-)


