Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FCA248BDE;
	Wed, 15 Jan 2025 10:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938433; cv=none; b=EdV3C111q2pwfpyLPMvngNq7u++UDlk2ivexsH8Fng5bwqkRE5l2n8pqio33QCoymNMj9CvSlMW/J1SBaOpvgVizD5TLjpty8fIIapTnYsB1NzlGiAdGdGYCIQ7AH7ZCIG0vYRr6Q1MInDWQBkkgSql3AwXF2dASx81mYQlJCp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938433; c=relaxed/simple;
	bh=OMM67OXpvpNSZzuNXXmZ9mkFyMh45Xf3T2T2cUKe1vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpNLiErUA0fiFkNOVyXW7EqRVPhOcsioqxbyptzVRBewc5xYUVChJWmYAU7QtW/NdiJJv5w8hqhxHOBbOXvVnLlqE7i+4os2mXy6Qnsd/riG0qqs0G/h51sMV/hFrSYpDWjADDcjkeua5dZrsO/C29MyYyOtysoezjumtq3N9gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0EWV6NH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0EWV6NH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94A4C4CEDF;
	Wed, 15 Jan 2025 10:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938433;
	bh=OMM67OXpvpNSZzuNXXmZ9mkFyMh45Xf3T2T2cUKe1vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0EWV6NHrGNesU5ZGAJDht5FEaqQsTtu+OqvwdvUNMaNvOXF5l3B4FKPiPt+/r9mB
	 LHDVrjodRAkH9SYyHBR8TnhwtvJTFFwx8vuYHa3JULj0adtefqOQ7iDjrNvWDInhyQ
	 T0cQL00jRCCbJk8H8ZXUD4O3PpWvmWPcpbdJWxOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guanjing <guanjing@cmss.chinamobile.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/189] firewall: remove misplaced semicolon from stm32_firewall_get_firewall
Date: Wed, 15 Jan 2025 11:37:57 +0100
Message-ID: <20250115103613.630553259@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guanjing <guanjing@cmss.chinamobile.com>

[ Upstream commit 155c5bf26f983e9988333eeb0ef217138304d13b ]

Remove misplaced colon in stm32_firewall_get_firewall()
which results in a syntax error when the code is compiled
without CONFIG_STM32_FIREWALL.

Fixes: 5c9668cfc6d7 ("firewall: introduce stm32_firewall framework")
Signed-off-by: guanjing <guanjing@cmss.chinamobile.com>
Reviewed-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bus/stm32_firewall_device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bus/stm32_firewall_device.h b/include/linux/bus/stm32_firewall_device.h
index 18e0a2fc3816..5178b72bc920 100644
--- a/include/linux/bus/stm32_firewall_device.h
+++ b/include/linux/bus/stm32_firewall_device.h
@@ -115,7 +115,7 @@ void stm32_firewall_release_access_by_id(struct stm32_firewall *firewall, u32 su
 #else /* CONFIG_STM32_FIREWALL */
 
 int stm32_firewall_get_firewall(struct device_node *np, struct stm32_firewall *firewall,
-				unsigned int nb_firewall);
+				unsigned int nb_firewall)
 {
 	return -ENODEV;
 }
-- 
2.39.5



