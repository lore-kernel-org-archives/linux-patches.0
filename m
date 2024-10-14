Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C691415D5C5;
	Mon, 14 Oct 2024 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919685; cv=none; b=gTFq2SE4K5pxK6qiBk82iMPvQcQ3VRZsiPb5diTE53kyCWtJr7IqBIq8mAk/TCGaGdSxdiLGGJaha7B6ySlRLVJ6Sls/iipXQYO7t8/tMSdnltc6XRrv7nSqJfDsCAk/3A0FQXgVVRITbvYf8Mu+zLmIj5R4e0ulkt414W073PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919685; c=relaxed/simple;
	bh=YX84QDnycb6AFbLPMgvNuo23HrN/knBdkx6QPmLS+N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5RILWysEMde+rsdcKwfRpMaVkgxKSiIDdND5BfLSQTI9SGxevSjc+jAx8oFi96ed8U/uWgLS/fP1RjMOWxmB2DNHzcoYWgZeiv1itdHlAMUTSWp3r5p+BVbvaJMyBfazo8U5U5UWe5kBQsDyQG9mj7yoa8+/gcYhUPOgx4GWLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evf1jhVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evf1jhVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7196C4CEC3;
	Mon, 14 Oct 2024 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919685;
	bh=YX84QDnycb6AFbLPMgvNuo23HrN/knBdkx6QPmLS+N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evf1jhVs4qeIsCVjbatTENORYh85jjyv0kO0RHnPJj+Xnpqqn2YPA5DKUP59vCIa+
	 HL6P/6bPhdVwkovTsdiagPlTsVf65J2En3adrGk+IWWEZ/sny5gFMcGFDhsR7j7UsV
	 XlHjS6Y4buIrSX0mRtVihzr/TM0KL0Dg7Lvhkg9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 679/798] selftests: net: Remove executable bits from library scripts
Date: Mon, 14 Oct 2024 16:20:33 +0200
Message-ID: <20241014141244.746906500@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit 9d851dd4dab63e95c1911a2fa847796d1ec5d58d ]

setup_loopback.sh and net_helper.sh are meant to be sourced from other
scripts, not executed directly. Therefore, remove the executable bits from
those files' permissions.

This change is similar to commit 49078c1b80b6 ("selftests: forwarding:
Remove executable bits from lib.sh")

Fixes: 7d1575014a63 ("selftests/net: GRO coalesce test")
Fixes: 3bdd9fd29cb0 ("selftests/net: synchronize udpgro tests' tx and rx connection")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Link: https://lore.kernel.org/r/20240131140848.360618-4-bpoirier@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/net_helper.sh     | 0
 tools/testing/selftests/net/setup_loopback.sh | 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 tools/testing/selftests/net/net_helper.sh
 mode change 100755 => 100644 tools/testing/selftests/net/setup_loopback.sh

diff --git a/tools/testing/selftests/net/net_helper.sh b/tools/testing/selftests/net/net_helper.sh
old mode 100755
new mode 100644
diff --git a/tools/testing/selftests/net/setup_loopback.sh b/tools/testing/selftests/net/setup_loopback.sh
old mode 100755
new mode 100644
-- 
2.43.0



