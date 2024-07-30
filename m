Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C101A6192;
	Tue, 30 Jul 2024 16:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357431; cv=none; b=RtNbbV732rE5lFfJ1qv/n4Gk4HuEUu3s16/dqMXJv4jL6E3+9NQUWh6VggNhAhHVpJ2pzoXa5w8cdGU68zvOd3hnWtwhu+45SWzMmE4lkMnRe47OAW4K5lQpMDf9Ts2yy1yEd5jvxudvRFAMi0GoOiyGcNUQ+xuU1K9Ui0E6Jzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357431; c=relaxed/simple;
	bh=sa/LX5/NAcEXx966baF2lS3j0ywpyLwOkFi1JhV6CKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BH/pjWFz+ZCpI+sdqLl4bO89NPtSYefozrbxwqz7Z+GllBeEAAfq0NHxGchGmT+dMwVwizykmKubWJlmaTFWkCaqd1T/b0Z2Md70bnVPciGjaEV+8B+MgYcIujDaqVfo7P9r8zVzqDlU8bWTfo0zNGm1v5zyFTtLKlXE3K3+0h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vujOniPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vujOniPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0203DC4AF0A;
	Tue, 30 Jul 2024 16:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357431;
	bh=sa/LX5/NAcEXx966baF2lS3j0ywpyLwOkFi1JhV6CKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vujOniPICl7I/1FRvBIUvCjJX/lqs54zQ4kL4lOeBiiopy6nZbxJsC1v2vshLY9EB
	 RgSWp7PY6HztFPC1ZWz0ITPvlkYH9iGwCUPZhds6g5TH0YMjkNo4i0LAlNmXRLIyyu
	 mHoSgYhBsRIKhcXeE2O6Vxenz/R7Ai9EwLhDti/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@svenpeter.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 253/809] Bluetooth: hci_bcm4377: Use correct unit for timeouts
Date: Tue, 30 Jul 2024 17:42:09 +0200
Message-ID: <20240730151734.588412364@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit 56c695a823e4ee1e5294a8340d5afe5de73828ec ]

BCM4377_TIMEOUT is always used to wait for completitions and their API
expects a timeout in jiffies instead of msecs.

Fixes: 8a06127602de ("Bluetooth: hci_bcm4377: Add new driver for BCM4377 PCIe boards")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_bcm4377.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_bcm4377.c b/drivers/bluetooth/hci_bcm4377.c
index d90858ea2fe59..a77a30fdc630e 100644
--- a/drivers/bluetooth/hci_bcm4377.c
+++ b/drivers/bluetooth/hci_bcm4377.c
@@ -32,7 +32,7 @@ enum bcm4377_chip {
 #define BCM4378_DEVICE_ID 0x5f69
 #define BCM4387_DEVICE_ID 0x5f71
 
-#define BCM4377_TIMEOUT 1000
+#define BCM4377_TIMEOUT msecs_to_jiffies(1000)
 
 /*
  * These devices only support DMA transactions inside a 32bit window
-- 
2.43.0



