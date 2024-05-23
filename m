Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3961E504;
	Thu, 23 May 2024 13:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470108; cv=none; b=fgUFpBYiZaKiXqRVv+LNivOF9PiZSa1STYxZYmwOuiWCp0ctWByHyStsZkcJvEcJB005qBXNZiKGfpm18dxseoxuCBEfkg+vKZnPtyGRnFFMjgeuY/T0AWpkhQhjiun8AhNIZL/kR1bV39vLZL0O6pmmF5cH2PskBMFt/cjfayI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470108; c=relaxed/simple;
	bh=ka6xgn+l2sPMoaUiujBeOXXTgwAjsFqNJu9EamNSPw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m7e+1Uqrz9QhN5bNtSOUpFmj280D3KiqICGzPITvT5x+l3FE2L4eIofzfSMEWOsk53Dest7wFprV2TIBXbbAgNrPap9Vy2SUH+HNqRNiIsYUfHfo9obLVcFG/BwIskLT9POgEQXOq5nExtwXHYoslAnsfvb1ZHh8j+64obktfJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5MIARVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5MIARVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D4EC2BD10;
	Thu, 23 May 2024 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470108;
	bh=ka6xgn+l2sPMoaUiujBeOXXTgwAjsFqNJu9EamNSPw4=;
	h=From:To:Cc:Subject:Date:From;
	b=O5MIARVNTct6x3r6mruQSvIdicgvR4z/td1SCxEnM2A2OS/K/WExsqI5tkFdiNxuP
	 r4VT03780/YeyPTYiyrb3+wOI/Di4CZOc1w37mP/2fihTNZj4s7AEIJ5Zr18Ba6wvD
	 TGohWP3CN1jmvTqq/reehs5GfSK0QHp8ACE/k1ME=
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
Subject: [PATCH 4.19 00/18] 4.19.315-rc1 review
Date: Thu, 23 May 2024 15:12:23 +0200
Message-ID: <20240523130325.727602650@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.315-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.315-rc1
X-KernelTest-Deadline: 2024-05-25T13:03+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 4.19.315 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.315-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.315-rc1

Akira Yokosawa <akiyks@gmail.com>
    docs: kernel_include.py: Cope with docutils 0.21

Daniel Thompson <daniel.thompson@linaro.org>
    serial: kgdboc: Fix NMI-safety problems from keyboard reset code

Tom Zanussi <tom.zanussi@linux.intel.com>
    tracing: Remove unnecessary var_ref destroy in track_data_destroy()

Tom Zanussi <tom.zanussi@linux.intel.com>
    tracing: Generalize hist trigger onmax and save action

Tom Zanussi <tom.zanussi@linux.intel.com>
    tracing: Split up onmatch action data

Tom Zanussi <tom.zanussi@linux.intel.com>
    tracing: Refactor hist trigger action code

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have the historgram use the result of str_has_prefix() for len of prefix

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Use str_has_prefix() instead of using fixed sizes

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Use str_has_prefix() helper for histogram code

Steven Rostedt (VMware) <rostedt@goodmis.org>
    string.h: Add str_has_prefix() helper function

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Consolidate trace_add/remove_event_call back to the nolock functions

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: Remove unneeded synth_event_mutex

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: Use dyn_event framework for synthetic events

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: Add unified dynamic event framework

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: Simplify creation and deletion of synthetic events

Dominique Martinet <dominique.martinet@atmark-techno.com>
    btrfs: add missing mutex_unlock in btrfs_relocate_sys_chunks()

Mikulas Patocka <mpatocka@redhat.com>
    dm: limit the number of targets and parameter size area

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"


-------------

Diffstat:

 Documentation/sphinx/kernel_include.py   |    1 -
 Makefile                                 |    4 +-
 drivers/md/dm-core.h                     |    2 +
 drivers/md/dm-ioctl.c                    |    3 +-
 drivers/md/dm-table.c                    |    9 +-
 drivers/tty/serial/kgdboc.c              |   30 +-
 fs/btrfs/volumes.c                       |    1 +
 include/linux/string.h                   |   20 +
 include/linux/trace_events.h             |    2 -
 kernel/trace/Kconfig                     |    4 +
 kernel/trace/Makefile                    |    1 +
 kernel/trace/trace.c                     |   26 +-
 kernel/trace/trace_dynevent.c            |  210 ++++++
 kernel/trace/trace_dynevent.h            |  119 ++++
 kernel/trace/trace_events.c              |   32 +-
 kernel/trace/trace_events_hist.c         | 1082 ++++++++++++++++++------------
 kernel/trace/trace_probe.c               |    2 +-
 kernel/trace/trace_stack.c               |    2 +-
 tools/testing/selftests/vm/map_hugetlb.c |    7 -
 19 files changed, 1068 insertions(+), 489 deletions(-)


