Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C0613D609;
	Tue, 23 Jul 2024 11:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721735530; cv=none; b=cEwBydD0WwZQYzqAsilmQgjHYQ3RQkCg6AsBdGs9SA5Q7ZtFVt5LHIaWC/DfiFC8vtutP3xR9V+7KVTmaxhkEq57NBJStzNwNEpOgGAc0VwWo4HbxVnNyLaf+fnpwPEwfpZ83vJ3XFfOXnzpDide6wU2iwCiXldlmEzGoklBKzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721735530; c=relaxed/simple;
	bh=mwasLmA3UqDoqZDlD7yKei2JQ2hx5htgK1//Ltn4O+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FtWITfq55UfMdjmMJcJM0Vka00uy4xckLD4zf7+YKc63+mc+XAyA42tF9KJKW+VjU3zzDO0qUynhrXa1oROGRd/+Bz20o7hj9/EpvwpPUu9uJx5RclxM+uljeHuGnGNPN5bHTlLSSDl7ggE0j2AAAFUuiI8CxQaptIig0YW0LDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w79mWa0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w79mWa0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62F9C4AF0A;
	Tue, 23 Jul 2024 11:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721735530;
	bh=mwasLmA3UqDoqZDlD7yKei2JQ2hx5htgK1//Ltn4O+E=;
	h=From:To:Cc:Subject:Date:From;
	b=w79mWa0Ts7zSA1IydzkU52uptj7dfdfyOg+XcHZYxz/IAyGEtp3E6n6W6lJRmgMip
	 ifCZpJ1BHVG3/v1W1+CPevUVnEkThVsz4MuzO54Vs/U3AGriQRPo44nxVJnzpnw9gO
	 Q7FxIbsLdQ6iCWSvuREBDOXvFe0VW4hO+jpetzUc=
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
Subject: [PATCH 6.10 0/9] 6.10.1-rc1 review
Date: Tue, 23 Jul 2024 13:51:54 +0200
Message-ID: <20240723114047.281580960@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.10.1-rc1
X-KernelTest-Deadline: 2024-07-25T11:40+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.10.1 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 25 Jul 2024 11:40:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.10.1-rc1

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

 Makefile                         |  4 ++--
 drivers/char/tpm/tpm2-sessions.c |  5 +++--
 fs/ext4/ext4.h                   |  2 +-
 fs/ext4/ioctl.c                  |  2 +-
 fs/smb/client/cifsfs.c           |  2 +-
 fs/smb/client/file.c             | 21 +++++++++++++++++----
 fs/smb/client/smb2pdu.c          |  3 ---
 include/sound/cs35l56.h          |  2 +-
 sound/soc/codecs/cs35l56.c       |  6 +++++-
 9 files changed, 31 insertions(+), 16 deletions(-)


