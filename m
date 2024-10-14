Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A300417C77;
	Mon, 14 Oct 2024 14:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916817; cv=none; b=PoVvnjPZfe82qxn5wuMXce960mtyxG411sHC/T48+Zk72uP2Md3dgSB42qZnjUqk7EWBwMHj+qgS3/Om4mbmwwlaQtp0d8mG9+0s7IvOZlZbimO9cfMlm3iE/LOBt+/bb2pN6EiNrCjZXnn2JfiN8iEg0WgDRVEc6RwIDkbLyW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916817; c=relaxed/simple;
	bh=Gm7F85uQ+3xiysGcpePeUW6La0Y+5pAIjg9gZ8ksTz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3P/wULJcykcrLTgXCBNKGy2N3qDvrcj6v2BAFxbfb6B0D7YkVWBqFbZve+mXE3Tu2dDfQG7u8IdZB+3sq35wkVT/S+eEb7766XygMSnYiGpowAg1umQwXUF68Vf5KEiRH1gN2A6WAtxRK8U72pTqOsO6at3GstXYuyJ1FCZfLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8MTiuBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8MTiuBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1635AC4CEC3;
	Mon, 14 Oct 2024 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916817;
	bh=Gm7F85uQ+3xiysGcpePeUW6La0Y+5pAIjg9gZ8ksTz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8MTiuBK2sh00c2meDE5QnwuBBkzEc+2lPM/cYDojbVEUyqWJIx/ttYy/MXWE8tDD
	 JN+oZQ59oAUSAMoOZAdFV7oozyjxhhlQHh1scr8xERKdQ8SjSFBsolA3JxPxjomnSb
	 /1AaX+m+bCbOlF7BChfk4gxpZVVzWmfZ50V/X/mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/213] selftests: net: Remove executable bits from library scripts
Date: Mon, 14 Oct 2024 16:19:07 +0200
Message-ID: <20241014141044.594323569@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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
 tools/testing/selftests/net/setup_loopback.sh | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 tools/testing/selftests/net/setup_loopback.sh

diff --git a/tools/testing/selftests/net/setup_loopback.sh b/tools/testing/selftests/net/setup_loopback.sh
old mode 100755
new mode 100644
-- 
2.43.0



