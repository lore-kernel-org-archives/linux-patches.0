Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978B33C2790;
	Tue, 21 Jul 2026 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649742; cv=none; b=IqzFQpQLa2pIv26672cFVTd0SOaCuBshZkxEHlFWrv/zusr+3xIQk1tvTag3Bv0EeBx6IxpddB1S21IqZZCl4S1ZWKK4NiKc6jx35hwnV11fHPR+bkD1OwlS3VM/Prmr3rfVyr0oqGqLFlrnxQGWbO0i/SpNBJhvGa/xklh+XQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649742; c=relaxed/simple;
	bh=QTrq6lz/1fBsb3s8ev8mJb1dmxDKpKX49bApsMqhjQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nw8rwswHmTM7NYdQZx7leNC6HY9QzS6LXuYS2c/mWIavKI6gpqd5dM61tEcOEFP6rfblWJ2BtlIelqtMomlm53RRW0OYfWYDSVCFIXt4DEJhu69HS/yjPdbvPLn0RoRUB3vGFlM3QiE9U3nFrzWRcJh2FKXJUT78+UezEVnpYQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DV+h2P3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DV+h2P3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C323C1F000E9;
	Tue, 21 Jul 2026 16:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649741;
	bh=bD8QvSchkEojS5lL8EzEHDqeVHrTWcZ2PKOcmVCgkvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DV+h2P3c0uyd9HBqNV4H1SeU2LPiRbVko/WDpJgn6SjvDeinHmZuudM1Atl6qgoTc
	 8vxnZt5g4CQs9yE+tx1XQLgYN/06bJrRcmuRGSe6WACsl1beWXUv8VKHE1R3isIy9C
	 +VZSX9/15M+nI0+6GkKTiEnfQJ/v00PhHYyb3gH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Scalbert <louis.scalbert@6wind.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0647/2077] tools: missed broadcast_neigh if_link uapi header
Date: Tue, 21 Jul 2026 17:05:20 +0200
Message-ID: <20260721152608.065709106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Scalbert <louis.scalbert@6wind.com>

[ Upstream commit 0134432215f0e0d4526544ac63dabe20e8a6951e ]

Add missing IFLA_BOND_BROADCAST_NEIGH in if_link uapi header.

Signed-off-by: Louis Scalbert <louis.scalbert@6wind.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20260603150331.1919611-2-louis.scalbert@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 32b0b8953343 ("bonding: 3ad: add lacp_strict configuration knob")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/uapi/linux/if_link.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 7e46ca4cd31bb5..97a2d4411534ae 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -1526,6 +1526,7 @@ enum {
 	IFLA_BOND_MISSED_MAX,
 	IFLA_BOND_NS_IP6_TARGET,
 	IFLA_BOND_COUPLED_CONTROL,
+	IFLA_BOND_BROADCAST_NEIGH,
 	__IFLA_BOND_MAX,
 };
 
-- 
2.53.0



