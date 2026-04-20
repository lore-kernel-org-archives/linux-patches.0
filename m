Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD32426EC0;
	Mon, 20 Apr 2026 13:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691761; cv=none; b=vBBHQvAwyBqKFawkwFkeS7mBaHO4X+K+HxWs88yVwX2DFsq8/mPbQs5GSWVVE756GB6owCtyUOjDoWWVfekAf+CmnhdYYqhFcJ24YpFqCk+fuDMBHMBUku/swbcsOvoSd/DRc13ouRtj//Pu2JAZmGeCHrnrh4uChJPMBXngsG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691761; c=relaxed/simple;
	bh=yb9wV433VWplu4WMVzXQK9J6zk7jb2ixWEEMwxVyEV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2h0hHMwkQT5/JaT5VoRAjf0vo9LI08oTJ1Ve0hT/zPgFzINeuQBAu6NlXvP00cOaxQtdbFKJEsJnK2ZQAhXRPCGccaaVXSMTATN1XpyDQAGRvt+SWIN6R61mGbXx32KxC3CeHNszqT+QvZS5oGNe5/d2drwflIK8Iuy07owcng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pZMfgyjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pZMfgyjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04742C2BCC4;
	Mon, 20 Apr 2026 13:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691761;
	bh=yb9wV433VWplu4WMVzXQK9J6zk7jb2ixWEEMwxVyEV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZMfgyjWxVg+acpqXR2mWiiicbPgkQ+is8EadR4mCUMOspt0lnlqCoazePMM9h5Un
	 qUF29BC6XCXkv+UX/clMpkIZi5N7p+LTLx4tDOJ+hlTznG8fjFt3J3cw6OXqgBhyWI
	 JXfHEo3IoTeVsUKX+TMNd+kqvUqKdiMB3ElmgeSVdcF2A0xiWpEVn6ZquMO8Z/I36K
	 7ne0j4WcaGKTH03n0kPmpicTnNXkJvsjgCAOKq9SNq9sOwVMGLondhs1+QhT8g7QGC
	 vgHufB42n8HqYuLfW0tFcPidWv6SWOwwwzUJskpXFJhT0CpbukYmHST/AhOT5PLsRN
	 oodfse4JKfxwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mengyuanlou@net-swift.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	maciej.fijalkowski@intel.com,
	piotr.raczynski@intel.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: txgbe: leave space for null terminators on property_entry
Date: Mon, 20 Apr 2026 09:19:32 -0400
Message-ID: <20260420132314.1023554-178-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Fabio Baltieri <fabio.baltieri@gmail.com>

[ Upstream commit 5a37d228799b0ec2c277459c83c814a59d310bc3 ]

Lists of struct property_entry are supposed to be terminated with an
empty property, this driver currently seems to be allocating exactly the
amount of entry used.

Change the struct definition to leave an extra element for all
property_entry.

Fixes: c3e382ad6d15 ("net: txgbe: Add software nodes to support phylink")
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Tested-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260405222013.5347-1-fabio.baltieri@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 41915d7dd372a..be78f8f61a795 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -399,10 +399,10 @@ struct txgbe_nodes {
 	char i2c_name[32];
 	char sfp_name[32];
 	char phylink_name[32];
-	struct property_entry gpio_props[1];
-	struct property_entry i2c_props[3];
-	struct property_entry sfp_props[8];
-	struct property_entry phylink_props[2];
+	struct property_entry gpio_props[2];
+	struct property_entry i2c_props[4];
+	struct property_entry sfp_props[9];
+	struct property_entry phylink_props[3];
 	struct software_node_ref_args i2c_ref[1];
 	struct software_node_ref_args gpio0_ref[1];
 	struct software_node_ref_args gpio1_ref[1];
-- 
2.53.0

