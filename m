Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A8217E90E;
	Mon, 27 May 2024 19:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836916; cv=none; b=BKAVKAoeWuS4aEheo+VRXmArMf/dL9ZWHFjAxvCiwbP8MKTMEfmqveMCUYJraYdrZgLzurtXhLper2fMBtP0xXcJfXlvalbfkBoD5b2XFdca2NJYEEnUqLVeVlzhX8T/70Vb/nAtNCyDmiyME6vfGrtGFBhn7rpqzo//O8A5Ync=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836916; c=relaxed/simple;
	bh=DuMt4c5X/X1E+gCgSyjsUZ6sL91shpGFL4pjiVC9V/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUc6HY/wq0rEsObDfp2x2gO/umlaLHX3Bo4vjagsysC51M5kRHiARd5jEUSo4HNfvXSXmscAdweYuW3hGiDQfzsvA3LoCabdQ/agvAi/Mwmc71fKNpbOiLeq7iiM7OOlz5s4HCO7MYkeEntC9QCjyiaT5aYSlZJHCb2ShOELrNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sb2nlZ+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sb2nlZ+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D428C2BBFC;
	Mon, 27 May 2024 19:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836915;
	bh=DuMt4c5X/X1E+gCgSyjsUZ6sL91shpGFL4pjiVC9V/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sb2nlZ+J3n5oplZeJTS5Xa9evggyfoUEvFbFKulPi+WVXlgOByepKBy74w4iGgAHR
	 DkcLyicvo4UAUTfulvzpCNmEDShMxRjRQHkoEyMVKSejxmskeSSGPF+COfEqxHpPuo
	 rHgcPj8WeMs3xl8LzT8G+WXFHBn3l/M9F7w6C1h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 239/427] selftests: net: add missing config for amt.sh
Date: Mon, 27 May 2024 20:54:46 +0200
Message-ID: <20240527185624.813529959@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c499fe96d3f75a5cf50de6089dd8f1cddd1301a9 ]

Test needs IPv6 multicast. smcroute currently crashes when trying
to install a route in a kernel without IPv6 multicast.

Fixes: c08e8baea78e ("selftests: add amt interface selftest script")
Link: https://lore.kernel.org/r/20240509161919.3939966-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 5e4390cac17ed..04de7a6ba6f31 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -30,6 +30,7 @@ CONFIG_IP_GRE=m
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
 CONFIG_NF_CONNTRACK=m
+CONFIG_IPV6_MROUTE=y
 CONFIG_IPV6_SIT=y
 CONFIG_IP_DCCP=m
 CONFIG_NF_NAT=m
-- 
2.43.0



