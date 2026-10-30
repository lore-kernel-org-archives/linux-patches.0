Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362520;
	b=15fCD71Gd7uDz0ZhMPgnUxYl9sONEohinulmZ/PdT3dupLWpqEnYYrHY9J9LmUR2OKd5
	 /SaWIyIGYR9umXq6h4wCzFbsgyHP+gWFoSKP0rfMpu4oFLF5kXOHCgHF5FMqJH2lIfBBf
	 U2n99KXPXTY9Si9zsPvyBOxyDMqC/UMsoZEZYZERLUazoRQYA0+iCygGhB0Dht6BaJ2z1
	 MLMwxRAgqm1/N60lp8F5kfhQI9NaSxdDCj6V3eemIFjI+RnAlU4TuZhbtcrpP+0Asqjax
	 RR37QKpx2CNClW2Xg3swsc+Tj9FPVYhLIHQkfmn8qs7vl1e7gqNYrGKG+x1wMh4k1Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=zduN4WfUYv01Llk6xJOg5uu/XzefVpEyKeRryIQDT+Y=;
	b=yiM9fRmC/BDIlphx0KshFPXZWDJfibmTbFtmjR3+pHq8yv0Dpr3UA0h5djOPkzx20UKs
	 07tQMMhnOpXVkuABGRC2mYxz5u0fhzUzJi5bi/5bB01GgxYtEds+L5R0jgdDJ8FTKv9lK
	 +jlI1sfuSmFbQyRJzzgL0VCbbmJ+n3hlow7wc0bsBmDZIW6E/gGYt8eTSiOKhupcYsIR1
	 7wU1Yj4blpI/ulwfoiBdxmSyKWLSVU0/qhK4MXK2ntITy4uZMu+x26gyzyP+geK1/ARcN
	 z955UHqhGpv9JcUPxx4yI+qcd03I5VQ4bBVFQUDTxkkXqzFoEyUOYTrMhmWyawaBsrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2bMC73my;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5F6606A31D;
	Fri, 30 Oct 2026 12:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2bMC73my
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B49D1F000C1;
	Fri, 30 Oct 2026 12:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793362519;
	bh=zduN4WfUYv01Llk6xJOg5uu/XzefVpEyKeRryIQDT+Y=;
	h=From:To:Cc:Subject:Date;
	b=2bMC73mycUo6Qc7xiMztRNLHXVrZbJXFwFEUEZ7oqYk+2Yjd7+owIc6UZCk9CkDA4
	 E4PPMuVrLb0Ry9NgpN0iYEvFnjC2bCf4mfekMWLW0WOUyfVTmwz/3vCmzpUHjg5xGj
	 bHKhfCvXc4RRYlMFUUvmN7m+6PhrRQHPLwBEKWRY=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 7.2 00/10] 7.2.15-rc1 review
Date: Fri, 30 Oct 2026 13:15:01 +0100
Message-ID: <20261030121255.257615100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.2.15-rc1
X-KernelTest-Deadline: 2026-11-01T12:12+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.2.15 release.
There are 10 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 01 Nov 2026 12:12:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.2.15-rc1

Christian Brauner <brauner@kernel.org>
    fork: don't create io threads once PF_POSTCOREDUMP is set

Christian Brauner <brauner@kernel.org>
    fork: move the coredump and exec checks into create_io_thread()

Christian Brauner <brauner@kernel.org>
    exec: cancel io_uring requests before de_thread()

André Draszik <andre.draszik@linaro.org>
    kbuild: link-vmlinux.sh: improve detection of third pass requirement

Ridham Khurana <khurana.ridham222@gmail.com>
    platform: cznic: turris-omnia-mcu: Add missing MODULE_DEVICE_TABLE()

Daniel Schaefer <dhs@frame.work>
    iio: hid-sensor: als: scale each channel individually

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: don't hand out already failed sockets in smbdirect_socket_accept()

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: release failed pending sockets of a listener

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: don't wait for RDMA_CM_EVENT_DISCONNECTED in smbdirect_socket_destroy_sync()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: wait for negotiation before receiving another PDU


-------------

Diffstat:

 Makefile                                       |   4 +-
 drivers/iio/light/hid-sensor-als.c             |  22 +--
 drivers/platform/cznic/turris-omnia-mcu-base.c |   1 +
 fs/exec.c                                      |  11 +-
 fs/smb/server/server.c                         |   5 +
 fs/smb/smbdirect/accept.c                      | 227 ++++++++++++++++++-------
 fs/smb/smbdirect/connection.c                  |  12 +-
 fs/smb/smbdirect/internal.h                    |   2 +
 fs/smb/smbdirect/listen.c                      | 137 +++++++++++++--
 fs/smb/smbdirect/socket.c                      | 113 ++++++++++--
 fs/smb/smbdirect/socket.h                      |  42 +++++
 kernel/fork.c                                  |   4 +
 scripts/link-vmlinux.sh                        |  20 ++-
 13 files changed, 489 insertions(+), 111 deletions(-)


