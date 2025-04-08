Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01D9264614;
	Tue,  8 Apr 2025 11:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111102; cv=none; b=LV5HWOLtTcbSqQhLvsA1J2eGgKKO4UolTTot4g63svp6AhBqIrQzgyYxjfPDlESOq5oxLPJfs9tgLvvbSc0FL0a86FJ47UF5pIUJK0by2ivezk5z3IL7T40UeWbEwvYKUl+mS6fYM0jUbX2lcd2BoVSaEU8kRb2Z3E825O09MyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111102; c=relaxed/simple;
	bh=n6zc/5hjTBt+4C2yWLC33+uEuf0s+Oyhp7mu/gXscTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGHesmggibiRvneFGTwZZMxvheF+dc6pnpSHVqPHB6/I2gdVW/k5vSc7rlx164x0aj2scCb3olR0qjmoNrp78kIlhSgw1uR2+wApsHVjbdwLlYYm1IMnnkSMgjj4DFFAA7gvuPYCq0LW9/+VmRMMHjOkfUdj4D0y9UlNsVTF5dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TW+iD+f5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TW+iD+f5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1C9C4CEE5;
	Tue,  8 Apr 2025 11:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111102;
	bh=n6zc/5hjTBt+4C2yWLC33+uEuf0s+Oyhp7mu/gXscTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TW+iD+f5RoSGxAQUJJOm829yh+5cBdfVr0oEqoENM1NgVfjUs6Kw71UentUM1IYa3
	 +gBS2kDmCzpYUm8pBA9RbrO/Qpg3PxEDO2QdC91FCmTigK2JTQzM3UDjNxidPrJhyi
	 +Kd7OJVamqzpb7rkn3lFWAvUuZ35xVQlvWYTtyVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Lai <yi1.lai@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 310/731] selftests/pcie_bwctrl: Add set_pcie_speed.sh to TEST_PROGS
Date: Tue,  8 Apr 2025 12:43:27 +0200
Message-ID: <20250408104921.488070560@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Lai <yi1.lai@intel.com>

[ Upstream commit df6f8c4d72aebaf66aaa8658c723fd360c272e59 ]

The test shell script "set_pcie_speed.sh" is not installed in INSTALL_PATH.
Attempting to execute set_pcie_cooling_state.sh shows warning:

  ./set_pcie_cooling_state.sh: line 119: ./set_pcie_speed.sh: No such file or directory

Add "set_pcie_speed.sh" to TEST_PROGS.

Link: https://lore.kernel.org/r/Z8FfK8rN30lKzvVV@ly-workstation
Fixes: 838f12c3d551 ("selftests/pcie_bwctrl: Create selftests")
Signed-off-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/pcie_bwctrl/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/pcie_bwctrl/Makefile b/tools/testing/selftests/pcie_bwctrl/Makefile
index 3e84e26341d1c..48ec048f47afd 100644
--- a/tools/testing/selftests/pcie_bwctrl/Makefile
+++ b/tools/testing/selftests/pcie_bwctrl/Makefile
@@ -1,2 +1,2 @@
-TEST_PROGS = set_pcie_cooling_state.sh
+TEST_PROGS = set_pcie_cooling_state.sh set_pcie_speed.sh
 include ../lib.mk
-- 
2.39.5



