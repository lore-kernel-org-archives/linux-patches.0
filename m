Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB66B107B4;
	Sat,  3 Feb 2024 04:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933955; cv=none; b=Ixqfg2PLdtzt+q2SnpIFIDbNZ6ceU6+PZkTWkZgiSfRPUPuyWsE4kYqcktxuQtYFf6o+AG7ny3ktzWglI3Z9eoe6j87faYEN43emK6T4wEWaSxPj0Sf3T3urOe7EeWcBwcyUd76Y2kQWZLJH53nvCmA/lFDNWPeqXYYyZhZUYyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933955; c=relaxed/simple;
	bh=ENKPD03hTt/yK5tx0SaoInjMF7+QeQNRSVoRpW0nUPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mV41YytpIOgBvnfOGwmpuM49G+7OLI1FIntpcIw+effnxbL29tqfnE9uCF28BxCKcGue0brWva/Bx/VgBXVKglK/o8MEtEu9vDvvG9xU1gyKCJlEkBe7T2K9hBAxBV+1pKXVG0mIQNN7ozY6pjytabtMp7ln6RZ41wSRqmOHa/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyjmh783; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyjmh783"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9F6C433F1;
	Sat,  3 Feb 2024 04:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933954;
	bh=ENKPD03hTt/yK5tx0SaoInjMF7+QeQNRSVoRpW0nUPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyjmh783qgdwMZi2KMSuc1/fYtMgnJN0lasva+VceZCF1h1PzvkzNByqMplIOawRE
	 BFGfahuAHM/A/aajLgOR5YHD2lCfrOyz/JXHyspgJgR9QPCgk5Oc+RkpTR11b51p1t
	 tnsF4Qha5+WhHXbKMlZF3fSfoHhwN+hFrd8C2gpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias May <matthias.may@westermo.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 323/353] selftests: net: add missing config for GENEVE
Date: Fri,  2 Feb 2024 20:07:21 -0800
Message-ID: <20240203035414.042972624@linuxfoundation.org>
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
index b4e811f17eb1..dad385f73612 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -19,6 +19,7 @@ CONFIG_BRIDGE_VLAN_FILTERING=y
 CONFIG_BRIDGE=y
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_VLAN_8021Q=y
+CONFIG_GENEVE=m
 CONFIG_IFB=y
 CONFIG_INET_DIAG=y
 CONFIG_IP_GRE=m
-- 
2.43.0



