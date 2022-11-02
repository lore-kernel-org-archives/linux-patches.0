Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497687E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A663C433D6;
	Wed,  2 Nov 2022 02:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357402;
	bh=0Wm2kfcjQxhzSRT7cdIl2vtAJtEKxeApRMIRgBalmn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAXP7r9v9svrpQ98qF93zC5iUqDBO4EgCBiCQ3iQqRbc4imlSPxUPll31IkGvu40A
	 mUhLsF0OnR9fxPPAqm1YYrzUadMU3mjPvWOaa6ZiYGGOFUiNxUNO3MIrIHMfievQBJ
	 zV0BeX4sZm1PpIAXaLCXiRESJKC9nRo2l3Km3D9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Jonathan Toppins <jtoppins@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 164/240] selftests: net: Fix netdev name mismatch in cleanup
Date: Wed,  2 Nov 2022 03:32:19 +0100
Message-Id: <20221102022115.091060985@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit b2c0921b926ca69cc399eb356162f35340598112 ]

lag_lib.sh creates the interfaces dummy1 and dummy2 whereas
dev_addr_lists.sh:destroy() deletes the interfaces dummy0 and dummy1. Fix
the mismatch in names.

Fixes: bbb774d921e2 ("net: Add tests for bonding and team address list management")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
index 9684163949f0..33913112d5ca 100755
--- a/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
+++ b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
@@ -18,7 +18,7 @@ source "$lib_dir"/lag_lib.sh
 
 destroy()
 {
-	local ifnames=(dummy0 dummy1 team0 mv0)
+	local ifnames=(dummy1 dummy2 team0 mv0)
 	local ifname
 
 	for ifname in "${ifnames[@]}"; do
-- 
2.35.1



