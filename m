Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32624F204;
	Tue, 23 Jan 2024 00:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970334; cv=none; b=OE1SHEYjdA8Y0BgNwC5SKI3ExUoeVKPAU4vvkZcGC9WOJIOAmtYIo/8UqCpSud7gPavz0UbDGjNvDsovr5YInshCaigPlm4iczg9DNFG8MYXhBody5LVzTZebgKskoZ2f7RSaE8Ufvjm6YA37q/Nk/syPvCo+IIimvf6CNEMA54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970334; c=relaxed/simple;
	bh=hC+sKZe4hx66QlZMkW56Ff1ddanABCLMmgS78f+qF2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPyy06roNTI5buctoxsa4AWW1IS/QtmhSAhcA7pjiLI1iD9TwqG9XkTb+Rphu9MizOfHK0XbkNCU2b379c6XIiBTRK0uMt65reOIbZV18EYq3cpWhovCsww66jXNO7lR1N4j9dL6q4IJyI2rR8ap00N4yFAil87W1W9Athr21kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bB/mptIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bB/mptIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181D2C433F1;
	Tue, 23 Jan 2024 00:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970334;
	bh=hC+sKZe4hx66QlZMkW56Ff1ddanABCLMmgS78f+qF2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bB/mptIBPm7Fc5LscGFpd6TKdPRnBvSdZAuPI9NAfY9khMaICv4Nupu+fegLAh/tu
	 yU2q8to37i/Prsv01Jgn0hsSElZWhHunn1tEn4BY4tSpwsA4tPzcBwlwxfp4zM2Iax
	 gcj8crdBM1U2pBC+4tq1O4LfUzQTdGxB+ssPOr6g=
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
Subject: [PATCH 6.7 612/641] selftests: bonding: Change script interpreter
Date: Mon, 22 Jan 2024 15:58:36 -0800
Message-ID: <20240122235837.377500800@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



