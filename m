Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384846D549;
	Tue, 21 Jul 2026 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656594; cv=none; b=Yg/Ls+DR+bFvw7Q14ESbR2Im7IW7bu1ligZz8GJdKfOUA6W9o3Pya9yLfvQvw708g1vvX6wyAavc/MnhDM8ADTGXFOIcxeNRNEWyrMUetwKRHztAO7OQpFAjKNxnowlOOBIQJ5FrKf+V4bkNwt15NspUmoxwLVoJZTNEwNcitd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656594; c=relaxed/simple;
	bh=A2tgYeRxzsML39IxeDvS96rXqdxSwXS1FW4l0evk5Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFTVrWs1wRe9WGUIFps41re1FJWMb56WJaCQArlZ5GP6IPefUNDlk6gFHbQROrXKHWTb4QPDB53TzK06Fs4l03Qq0yHmFatJaYF/dNrov5e0bo1gMwxfz1fhT9DvrTur/nEOYmp5kWjes/8P9Ns2XTZ6yeab3wJCJOptJjLbD/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdzu0UBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdzu0UBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA611F000E9;
	Tue, 21 Jul 2026 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656593;
	bh=dj3Z336LhKd9zbCsk1CQRjNhyym89zjUkAGUSzNRzq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdzu0UBA0dTTHCZHkSZpoOmvCW68w7f+ElJb7oBowf1rzbLbkqjh8xys/W+V/5fZ0
	 7g9OTepfdadUm4EO+jXEX9eZoqqsXKCXVO2FFrQdZveMysfIQiYvn44DM60gjJTspO
	 +ncLO8hVIP1jhf9Q1+PvxHI2Dd2oJV/T5WWRmePo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Scalbert <louis.scalbert@6wind.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0446/1611] tools: missed broadcast_neigh if_link uapi header
Date: Tue, 21 Jul 2026 17:09:22 +0200
Message-ID: <20260721152525.327450619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



