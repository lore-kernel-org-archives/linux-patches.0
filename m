Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C0A2C17A0;
	Thu, 12 Mar 2026 20:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345838; cv=none; b=oisN3/RB27V6jRaV6UyobajxjeQmHhfV1v4/F6/uOHkF2zoru7g1PxmGN/VUEInXtK73fSTZZsuB+XBN4cAWgVAmI66cpjMbRwzSf1K1/Mr/yZVrTrnsShpmPKkiMQe7Rsc8GnBQRX0RWRmqY2pSEbMAo2QblhD92bxRZ1NgNXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345838; c=relaxed/simple;
	bh=lHArvf/QNYmlF3oRsumsoF4CA6hMj6i3/UZ73tKe+ls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kNZngbmTJZ3rlYoOkx/07Pv7z9NF/nNbt6+dSkr4yT2XFXYAtwmnuoaDG7Zexnmdu9X7Q7Eyip2r+qJJNr1PCR60fY/c8TxPu0fLFIyty+oRXjsUiPKiIJrzldAD2WuGmoI527KRRjeRbw6rnjnTfY1j2bmY/NbVXL/u1InBp4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+oeMXc2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+oeMXc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAC0C4CEF7;
	Thu, 12 Mar 2026 20:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773345837;
	bh=lHArvf/QNYmlF3oRsumsoF4CA6hMj6i3/UZ73tKe+ls=;
	h=From:To:Cc:Subject:Date:From;
	b=Q+oeMXc2UETCbytnfbOfo1LTZvp7uXapnEbNRrLix0JjS1kHI+KYZz7eWL+t2XuuD
	 qhL2Q5M4GamYq+N94v6KyrupTq5ajfCH3PdOu8tDP0hwbiADaUvINo97jvuww3bArB
	 Gv0PVjqax8PezWShskHsWAQdbSvSUczONDUk7Frc=
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
Subject: [PATCH 6.19 00/13] 6.19.8-rc1 review
Date: Thu, 12 Mar 2026 21:03:32 +0100
Message-ID: <20260312200321.671986598@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.19.8-rc1
X-KernelTest-Deadline: 2026-03-14T20:03+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.19.8 release.
There are 13 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 13 Mar 2026 20:03:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.19.8-rc1

John Johansen <john.johansen@canonical.com>
    apparmor: fix race between freeing data and fs accessing it

John Johansen <john.johansen@canonical.com>
    apparmor: fix race on rawdata dereference

John Johansen <john.johansen@canonical.com>
    apparmor: fix differential encoding verification

John Johansen <john.johansen@canonical.com>
    apparmor: fix unprivileged local user can do privileged policy management

John Johansen <john.johansen@canonical.com>
    apparmor: Fix double free of ns_name in aa_replace_profiles()

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: fix missing bounds check on DEFAULT table in verify_dfa()

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: fix side-effect bug in match_char() macro usage

John Johansen <john.johansen@canonical.com>
    apparmor: fix: limit the number of levels of policy namespaces

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: replace recursive profile removal with iterative approach

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: fix memory leak in verify_header

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: validate DFA start states are in bounds in unpack_pdb

Victor Nogueira <victor@mojatatu.com>
    net/sched: Only allow act_ct to bind to clsact/ingress qdiscs and shared blocks

Paul Moses <p@1g4.org>
    net/sched: act_gate: snapshot parameters with RCU on replace


-------------

Diffstat:

 Makefile                                  |   4 +-
 include/net/act_api.h                     |   1 +
 include/net/tc_act/tc_gate.h              |  33 +++-
 net/sched/act_ct.c                        |   6 +
 net/sched/act_gate.c                      | 267 +++++++++++++++++++++---------
 net/sched/cls_api.c                       |   7 +
 security/apparmor/apparmorfs.c            | 225 +++++++++++++++----------
 security/apparmor/include/label.h         |  16 +-
 security/apparmor/include/lib.h           |  12 ++
 security/apparmor/include/match.h         |   1 +
 security/apparmor/include/policy.h        |  10 +-
 security/apparmor/include/policy_ns.h     |   2 +
 security/apparmor/include/policy_unpack.h |  83 ++++++----
 security/apparmor/label.c                 |  12 +-
 security/apparmor/match.c                 |  58 +++++--
 security/apparmor/policy.c                |  77 +++++++--
 security/apparmor/policy_ns.c             |   2 +
 security/apparmor/policy_unpack.c         |  65 +++++---
 18 files changed, 604 insertions(+), 277 deletions(-)


