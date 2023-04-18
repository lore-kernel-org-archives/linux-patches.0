Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A122572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC79CC433D2;
	Tue, 18 Apr 2023 12:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821852;
	bh=iSKRnCMXnp7Af6WCSWCtH/isYlOhKmZjT8VkxonZ5eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBmOV2IHM6HWFYKr1usBWxGHJjPGynm1pI3faVQoZCahwcAAkIt/WWVC1cXGffsFg
	 gyiEXha2m5R1v/VfRhwKagPOw3E9cdlFZ2mT1kMEO3Ul9fD5Ak7lwrR+BTFeRexqV7
	 Ggi11H5EB9RhMD2JgQeVlyOmEtY01UVYagIHc55w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/134] selftests: openvswitch: adjust datapath NL message declaration
Date: Tue, 18 Apr 2023 14:22:01 +0200
Message-Id: <20230418120315.225588375@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aaron Conole <aconole@redhat.com>

[ Upstream commit 306dc21361993f4fe50a15d4db6b1a4de5d0adb0 ]

The netlink message for creating a new datapath takes an array
of ports for the PID creation.  This shouldn't cause much issue
but correct it for future cases where we need to do decode of
datapath information that could include the per-cpu PID map.

Fixes: 25f16c873fb1 ("selftests: add openvswitch selftest suite")
Signed-off-by: Aaron Conole <aconole@redhat.com>
Link: https://lore.kernel.org/r/20230412115828.3991806-1-aconole@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/openvswitch/ovs-dpctl.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
index 3243c90d449e6..5d467d1993cb1 100644
--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -62,7 +62,7 @@ class OvsDatapath(GenericNetlinkSocket):
         nla_map = (
             ("OVS_DP_ATTR_UNSPEC", "none"),
             ("OVS_DP_ATTR_NAME", "asciiz"),
-            ("OVS_DP_ATTR_UPCALL_PID", "uint32"),
+            ("OVS_DP_ATTR_UPCALL_PID", "array(uint32)"),
             ("OVS_DP_ATTR_STATS", "dpstats"),
             ("OVS_DP_ATTR_MEGAFLOW_STATS", "megaflowstats"),
             ("OVS_DP_ATTR_USER_FEATURES", "uint32"),
-- 
2.39.2



