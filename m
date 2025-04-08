Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFED26B942;
	Tue,  8 Apr 2025 12:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114397; cv=none; b=LqT/jFqWrnD+tUAf/d925WEjLTFNmC3L7VriLrJ/XJbR2lWGikS5E1mMYkmP9ar6rNBph6FkREiYuExYd/uk0RG7d+q+v4iDc3mE4wkORx9snkO7eGE/HR5ns7IZPGvCToX9fxuluAMdkJpNzQQbpLoFkd62aSSJlRgj8RVTRVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114397; c=relaxed/simple;
	bh=qCqiVGKMBS8tupEmk++r4BG9i+WEJPA/fdeEJ8it16Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKbpHQB/cgD8K0YhYQXWKGOTpMy0O51ntW0ZBbzSqniQen8qVIlyhsqcuEE3fxvFADngo/BWBwM4CrxBCMUMdzwLHBz4GJeZa44UfqqHan8Fo5g9uRE+a2x9ZuMGkWkMt/xgrjOfTkgAw0G0w7iuKSGRzalx82izkIxK0BTgZ2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUSFdOGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUSFdOGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9350DC4CEE5;
	Tue,  8 Apr 2025 12:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114396;
	bh=qCqiVGKMBS8tupEmk++r4BG9i+WEJPA/fdeEJ8it16Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUSFdOGMZO22KhbCYB1Vkw44Vu7TGi8k1R23BpMBKuRp+fwfDjqZXJs6w3DDmA42Q
	 wd0gZdE/lWAdyP0i4IN8hhNVAn/A0gwc2TNjIlFM85ucvvQohBjsxQCDOwV8OTLSLt
	 h3aUlU/e0WgsFWgpV4jOH8QdSTDKw0b7zF4LE63s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Lai <yi1.lai@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 092/499] selftests/pcie_bwctrl: Add set_pcie_speed.sh to TEST_PROGS
Date: Tue,  8 Apr 2025 12:45:04 +0200
Message-ID: <20250408104853.511714072@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



