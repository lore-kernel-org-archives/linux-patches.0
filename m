Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F77D1DFEF;
	Wed, 20 Nov 2024 12:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107385; cv=none; b=THATyBV341gadCxTA9Uviz/a/I0a7AzRwJZe4puBlpWKQQ17VSOv5AJjy6W89VgEgaq+3KBjPgDSqqBTOkMmDPdxHp1Sy8ARjyWKyovlbzQKAGc0XrbMmxsS2r8q3xXcslOC30AY2lmzeZiM8XRt0eR5qzSiuc29+mWduTONQB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107385; c=relaxed/simple;
	bh=OmmppcBnBAOqTLsXY/hhk6hLRcj/o2lOl3O3Ptzq98A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lJda0DwdrvPLovRQ7/geWtOL3ZWrONTk9dlj1YR3g7WpKVNWVJhrDVQVOxi7zX4op0oOAyQMcXGt6+8roSO8x+TvVP4jcn0Gmz0rIkY2SlsOAdK+ZZlfpAYMu+fAlMX+YM44hFZ0e/xz5PqrDq/SFqHWCzZH9e9h2vS+j9WqIEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XjCQoDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XjCQoDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080F7C4CECD;
	Wed, 20 Nov 2024 12:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107385;
	bh=OmmppcBnBAOqTLsXY/hhk6hLRcj/o2lOl3O3Ptzq98A=;
	h=From:To:Cc:Subject:Date:From;
	b=0XjCQoDc2I9a4+Gm77gE7MUMp0nYdSHYqzDXvu80TOE+85N13kUZ6GreAPi1IWxM6
	 8PN+SHBLOys+oQYVDiM1ogu7v5ki1jcFFwl1905wLuTDWabs0/NxiFlekxNFabdGc2
	 Y0ggFasCU6y6n246NWLY6xpR8KpRcTLBdEZK25Jw=
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
	hargar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 6.12 0/3] 6.12.1-rc1 review
Date: Wed, 20 Nov 2024 13:55:54 +0100
Message-ID: <20241120124100.444648273@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.1-rc1
X-KernelTest-Deadline: 2024-11-22T12:41+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.1 release.
There are 3 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 22 Nov 2024 12:40:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.1-rc1

Liam R. Howlett <Liam.Howlett@Oracle.com>
    mm/mmap: fix __mmap_region() error handling in rare merge failure case

Benoit Sevens <bsevens@google.com>
    media: uvcvideo: Skip parsing frames of type UVC_VS_UNDEFINED in uvc_parse_format

Hyunwoo Kim <v4bel@theori.io>
    hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer


-------------

Diffstat:

 Makefile                           |  4 ++--
 drivers/media/usb/uvc/uvc_driver.c |  2 +-
 mm/mmap.c                          | 13 ++++++++++++-
 net/vmw_vsock/hyperv_transport.c   |  1 +
 4 files changed, 16 insertions(+), 4 deletions(-)


