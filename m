Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D737B110A;
	Tue, 23 Jan 2024 02:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975769; cv=none; b=PbzKbsA6WdvV1jUYNZU280Kyji9a7jyepXsw9rT2DflZTVB9vsvnnmWoRczod/SgRkSLuhcfckiES0JGHK6UsAOTMvM+BQDkBk9dH1kzCbreRdlCemA99ro3Cux2xAObrCWIAicdqZXxsQ5uVmKM0Kr8o8kZ/oC+A9lTefzr6vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975769; c=relaxed/simple;
	bh=xXKfRFOVnODuREsB59BHNHDCYybwnFMxfnrjdtOx44g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chBkISd8ZswCpmKLWlV0ongjrgq2UjNY8scb/zdeOXlzsgvtlHaCF0E0li9S6Tr3yOmf4vvIC9IjyYNykpM0ss507mH6DUnZ51thrtBg7PY7HeRvxn2XOrtkXM7gBaL8CA86Bn18lsD3gSvm3LtDyQ3HXNLgQDpyJNbXuI1/fpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9kpHSnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9kpHSnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63610C433C7;
	Tue, 23 Jan 2024 02:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975769;
	bh=xXKfRFOVnODuREsB59BHNHDCYybwnFMxfnrjdtOx44g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9kpHSntHmD1XEhugil46lyOTxoPhd8Rd5SQw3jZtgQ04oiJMsp/FR1XSaPtOqM1w
	 p9gC4i211rvXgM3as/kE6F3oKDEM3YlHmZF1Ap+nGuyQUHAZGtDcC8cmnb+P9YDNg1
	 vWqppihZbAiOV9Dp7QM9AH/14OXcCL1YySTd7NLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Petr Machata <petrm@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 553/583] selftests: bonding: Change script interpreter
Date: Mon, 22 Jan 2024 16:00:04 -0800
Message-ID: <20240122235829.071426949@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit c2518da8e6b0e248cfff1d4b6682e14020bd4d3f ]

The tests changed by this patch, as well as the scripts they source, use
features which are not part of POSIX sh (ex. 'source' and 'local'). As a
result, these tests fail when /bin/sh is dash such as on Debian. Change the
interpreter to bash so that these tests can run successfully.

Fixes: d43eff0b85ae ("selftests: bonding: up/down delay w/ slave link flapping")
Tested-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/bonding/mode-1-recovery-updelay.sh    | 2 +-
 .../selftests/drivers/net/bonding/mode-2-recovery-updelay.sh    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh b/tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh
index ad4c845a4ac7..b76bf5030952 100755
--- a/tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh
+++ b/tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 # Regression Test:
diff --git a/tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh b/tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh
index 2330d37453f9..8c2619002147 100755
--- a/tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh
+++ b/tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 # Regression Test:
-- 
2.43.0



