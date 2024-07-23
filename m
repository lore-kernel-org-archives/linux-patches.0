Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7917114AD17;
	Tue, 23 Jul 2024 12:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721737736; cv=none; b=SGnzaco45x+BXH71GRQ026XC9Bl1flkl1beVSVyoqvbQgER1EgU89ZhNwO5mZOvdfV9GMTMDX7iS/j1xoP2UCiFs/pyPzrG+dM9znQCF6BwzUhWmHdl4CR652C4id0snpdHwPQL6IkdckA+Yu9GyIQK0yAuwosdXBgI8vssVTOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721737736; c=relaxed/simple;
	bh=awSwb2cboI6RqbmY+PFcqfIX6SEr4n5iGukXM6aXalY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GTg5VmjH0wzVoRhKoFoF0ILftnBPmI9N13D79Vl5hQc07OhXeqAZuY9VFbNwc7pCWezbEIjBD6b4ZRO2EezBgaQaNZdKiXGpMAZfYAbxkTwDA3F3T1gpcnSBhPePQI//wT13zCO6uLfBabGGHddYKDZ5oj9yKjs/AaxxmUbPjuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwnVNnef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwnVNnef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A50C4AF09;
	Tue, 23 Jul 2024 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721737736;
	bh=awSwb2cboI6RqbmY+PFcqfIX6SEr4n5iGukXM6aXalY=;
	h=From:To:Cc:Subject:Date:From;
	b=lwnVNnefIrTL2KtFIWWEOSfniUcnhU+7QrZVSZ6Ee62qJyB7KzRneenMKmBMJLA6L
	 zOeaCOs8bY2/aHQb0OjWvTiKcCL/zJ1ai2+UOHVCbZ8igUslc158dZVPpZR3lHVlAZ
	 3d0xSFemGUMApDxwLIoz69sO7/nXClkpEM6lkCd4=
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
Subject: [PATCH 6.10 00/11] 6.10.1-rc2 review
Date: Tue, 23 Jul 2024 14:28:51 +0200
Message-ID: <20240723122838.406690588@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.1-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.10.1-rc2
X-KernelTest-Deadline: 2024-07-25T12:28+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.10.1 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 25 Jul 2024 12:28:30 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.1-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.10.1-rc2

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Allow thermal zones to tell the core to ignore them

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix error pbuf checking

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Limit Speaker Volume to +12dB maximum

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Use header defines for Speaker Volume control definition

Hao Ge <gehao@kylinos.cn>
    tpm: Use auth only after NULL check in tpm_buf_check_hmac_response()

David Howells <dhowells@redhat.com>
    cifs: Fix setting of zero_point after DIO write

David Howells <dhowells@redhat.com>
    cifs: Fix server re-repick on subrequest retry

Steve French <stfrench@microsoft.com>
    cifs: fix noisy message on copy_file_range

David Howells <dhowells@redhat.com>
    cifs: Fix missing fscache invalidation

David Howells <dhowells@redhat.com>
    cifs: Fix missing error code set

Kees Cook <kees@kernel.org>
    ext4: use memtostr_pad() for s_volume_name


-------------

Diffstat:

 Makefile                                    |  4 +--
 drivers/char/tpm/tpm2-sessions.c            |  5 +--
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c |  7 +++-
 drivers/thermal/thermal_core.c              | 51 ++++++++++++++---------------
 drivers/thermal/thermal_core.h              |  3 ++
 drivers/thermal/thermal_helpers.c           |  2 ++
 fs/ext4/ext4.h                              |  2 +-
 fs/ext4/ioctl.c                             |  2 +-
 fs/smb/client/cifsfs.c                      |  2 +-
 fs/smb/client/file.c                        | 21 +++++++++---
 fs/smb/client/smb2pdu.c                     |  3 --
 include/sound/cs35l56.h                     |  2 +-
 io_uring/kbuf.c                             |  4 ++-
 sound/soc/codecs/cs35l56.c                  |  6 +++-
 14 files changed, 69 insertions(+), 45 deletions(-)


