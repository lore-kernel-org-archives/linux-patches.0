Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52CF2BB0B;
	Sat,  3 Feb 2024 04:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933972; cv=none; b=oYyLTEhcwUiMY8tefeDFx1ImlHi+oseJfU6QPRDh09BovEgFg+iyLuzsNk55e/AgMYK9MrIexME9NR9f3QUu796VR3BQWd55ckyqjvO0PJPk6y4G2eeWfZKOQLSCp3FdW6t+UL3oIxRUUxVIzy+7qhpJrNxdQmUqLlt2RC+gffM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933972; c=relaxed/simple;
	bh=DKXKJ2xiX606mzbTKStbc4MFN0jDEdPZCU1C4mbCmD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVUqL1Ft+XQNEZpQCzqpTq0Kk+fI9emomb8vzcdky5hQY7r3mYYZ1LU82jvk88NMS1rXB+QOM7Gkk8THcRi30fXewK+lMX80DMnVVgQimh2lheXL398FE+BXfe5Hs+6klceUPg/QqnUtHjgQ5GPe8if0Bdmvf1yeBCbwNkLaUCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/p02VBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/p02VBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B128C433C7;
	Sat,  3 Feb 2024 04:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933972;
	bh=DKXKJ2xiX606mzbTKStbc4MFN0jDEdPZCU1C4mbCmD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/p02VBOSwedYuyclMpdBj/LrQNQEjh9v+keMwMzSkPqbRpbWi2qgQPqd1rAOX0ox
	 Cwl5Ki8GQNdo4BU7s5iJ+Lxha5f26R+HfYDM2O9LSlkCqKxC18lgy0Am99CYpd79Zo
	 G3jXobkeVAwmpkEqJNH3JsuIu/B2GbM3wPNioizI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 345/353] selftests: net: add missing config for NF_TARGET_TTL
Date: Fri,  2 Feb 2024 20:07:43 -0800
Message-ID: <20240203035414.672286602@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1939f738c73dfdb8389839bdc9624c765e3326e6 ]

amt test uses the TTL iptables module:

  ip netns exec "${RELAY}" iptables -t mangle -I PREROUTING \
  	-d 239.0.0.1 -j TTL --ttl-set 2

Fixes: c08e8baea78e ("selftests: add amt interface selftest script")
Link: https://lore.kernel.org/r/20240131165605.4051645-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 98c6bd2228c6..24a7c7bcbbc1 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -33,6 +33,7 @@ CONFIG_IP6_NF_NAT=m
 CONFIG_IP6_NF_RAW=m
 CONFIG_IP_NF_NAT=m
 CONFIG_IP_NF_RAW=m
+CONFIG_IP_NF_TARGET_TTL=m
 CONFIG_IPV6_GRE=m
 CONFIG_IPV6_SEG6_LWTUNNEL=y
 CONFIG_L2TP_ETH=m
-- 
2.43.0



