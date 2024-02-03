Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB3C1B944;
	Sat,  3 Feb 2024 04:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933476; cv=none; b=Yw6vu8xT9NvycvDLHmCParzqEaUVljyGWxV0NSxrMwK8TW2KqjcWmcW0ADDYaRfo0M9rzOpJB82hyo6VnEayScJZS/jEOsGlJTCc1Qlp0vH9br7FnABNclb4tRwALD93XUxxmxSoxaddsN7FqdhR8AJVXoZZXjRdVmk0JGaDVuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933476; c=relaxed/simple;
	bh=McQzFvW7CfH3EGA5jgfd29kSoMff53f4MBTmsYlVh1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYYKMxAMKzV3T4/PHfY8ANtyaih6tQBq2/3x8CUFkjVXvKFebCofhzS8pxjLA74dX5Y5nLuG8UnIXFRFx0tXm0aQga4cbxF4oxPAAvuwj+FCmhc8j2G9EaFKLpyx3oVZT312N56TXVTEml88WJvtpDFqAjYuCXSS1PwHKHBx36c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9EnfTcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9EnfTcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940DAC43390;
	Sat,  3 Feb 2024 04:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933476;
	bh=McQzFvW7CfH3EGA5jgfd29kSoMff53f4MBTmsYlVh1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9EnfTcLbSW94cyzOvZhnHuZGle8UMNgermRqjuNqR3GDwc/4AEP3te7pArQgzGtX
	 epMkO4VtM9j9u3l5Rg+UQ3mllrE9uLsrmd6aDgCvX0zVKz4SdWm0PpT+wIxpdVdT2E
	 cpH3AEauFZLm7wcB1DBwYwY6PwPCrUWRkgaMfKfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias May <matthias.may@westermo.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/219] selftests: net: add missing config for GENEVE
Date: Fri,  2 Feb 2024 20:06:15 -0800
Message-ID: <20240203035345.490787951@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Matthias May <Matthias.May@westermo.com>

[ Upstream commit c9ec85153fea6873c52ed4f5055c87263f1b54f9 ]

l2_tos_ttl_inherit.sh verifies the inheritance of tos and ttl
for GRETAP, VXLAN and GENEVE.
Before testing it checks if the required module is available
and if not skips the tests accordingly.
Currently only GRETAP and VXLAN are tested because the GENEVE
module is missing.

Fixes: b690842d12fd ("selftests/net: test l2 tunnel TOS/TTL inheriting")
Signed-off-by: Matthias May <matthias.may@westermo.com>
Link: https://lore.kernel.org/r/20240130101157.196006-1-matthias.may@westermo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index bd89198cd817..ec097f245726 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -13,6 +13,7 @@ CONFIG_IPV6_VTI=y
 CONFIG_DUMMY=y
 CONFIG_BRIDGE=y
 CONFIG_VLAN_8021Q=y
+CONFIG_GENEVE=m
 CONFIG_IFB=y
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
-- 
2.43.0



