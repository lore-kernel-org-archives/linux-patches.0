Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAEA12E67;
	Sat,  3 Feb 2024 04:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933712; cv=none; b=JnJh2mEdAKh9+fHR+QbuGWGDtx0PqhhrEvC2I8QPQZkvjvxMLURiR6PdQsAx0Z55EvwiHoWj6M6v6+0Esd5bp+TXoob0jKJabuh+hDQHuuBoEfWg/0lbzuZlUu9yQy0/LVtRGQ8sVGwQHgriwHh15incHTV2b89gvumIPCSUnvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933712; c=relaxed/simple;
	bh=kxnL3GpX2D8RCqBoCor2xk4hddOG5hwtnKIieXlDtnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReMnkU1HuhBhxBe7xDy+k3h3CMxw0+kYANpoda0x2RAZ1Qslvs/EO0hJ+yAojqmScx6ygNMxzJ/2IA+0HLTJXTWsLeIUZY5ARM6W9uP2EcXnk1Mb+5ZXXbVTkBqIWRbwoaBZAb2FvJlxDYGRnWTdi6f6WibteYtDBvfY3GiW830=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsVpcDpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsVpcDpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24975C433F1;
	Sat,  3 Feb 2024 04:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933712;
	bh=kxnL3GpX2D8RCqBoCor2xk4hddOG5hwtnKIieXlDtnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsVpcDpblcI1Ff04ZPKvDWgSkuyXk+blAkJdQjluxieeFObDkzS8Fbfgg8C1xFDrl
	 TFKezxBqZxvDuHlhT2k6baMmbv2M9JYW0PivlxixChMa+TFOYKzROBbOyOylni0UlV
	 rNxKdo6PPnRzrcEueCEnNx/cZlryleXWdqkjq9jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 315/322] selftests: net: enable some more knobs
Date: Fri,  2 Feb 2024 20:06:52 -0800
Message-ID: <20240203035409.206936921@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit c15a729c9d45aa142fb01a3afee822ab1f0e62a8 ]

The rtnetlink tests require additional options currently
off by default.

Fixes: 2766a11161cc ("selftests: rtnetlink: add ipsec offload API test")
Fixes: 5e596ee171ba ("selftests: add xfrm state-policy-monitor to rtnetlink.sh")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/9048ca58e49b962f35dba1dfb2beaf3dab3e0411.1706723341.git.pabeni@redhat.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 24a7c7bcbbc1..3b749addd364 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -22,6 +22,8 @@ CONFIG_VLAN_8021Q=y
 CONFIG_GENEVE=m
 CONFIG_IFB=y
 CONFIG_INET_DIAG=y
+CONFIG_INET_ESP=y
+CONFIG_INET_ESP_OFFLOAD=y
 CONFIG_IP_GRE=m
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
@@ -93,3 +95,4 @@ CONFIG_IP_SCTP=m
 CONFIG_NETFILTER_XT_MATCH_POLICY=m
 CONFIG_CRYPTO_ARIA=y
 CONFIG_XFRM_INTERFACE=m
+CONFIG_XFRM_USER=m
-- 
2.43.0



