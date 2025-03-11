Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D95D25DCFA;
	Tue, 11 Mar 2025 15:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707354; cv=none; b=LGP+wb50UbzeCwyQUaGC9pbVJHlO7t46ziv1A6p4d/wDa3/lKQWzEkxsbzJFw6i95CgEBPBpr9g6kJfbI7lHyxlAjIAAI8KUI0qDbp12l1zFPvoD1n/T+xNCvpWGLHJRE/3XwBzYk0FqeS8gwQmVyZT9LDCiEA5KhTcGJWhKdOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707354; c=relaxed/simple;
	bh=7crTIl72n4GI1SVa85E06v2LOE4uCADByiV52bdGFZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgNYwSZtpDtD/oalJagEP7ibg+ui0ibr8tzrPgtj0GCnyQFDxUr81pUJzV6rjDVqFnmPumf1GdpqApOlFByb/+Fab2kHOdx+f3oclUb5kG7YRy2xctt2pOQTidc7GCxYtUUELJyylsqKltg6KQf1/D7CC+9t0I0SnHZC1G2PmrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9mesR/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9mesR/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990C0C4CEE9;
	Tue, 11 Mar 2025 15:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707354;
	bh=7crTIl72n4GI1SVa85E06v2LOE4uCADByiV52bdGFZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9mesR/fHydZTmQu6lEjFBMeJyeCeYviyLVxm+j7486oNdrSgyExaQkXubiCgvMEy
	 bfoDRaN69HBvpx/9dekRXQsxNgziaEHrjywHQageWv/FlHtBA6pX2OUdlNNGIL3b+X
	 0B+fZJIHub2qpjkH8/m7Rg+AhBaRHMkiohT0PgJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshal Chaudhari <hchaudhari@marvell.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 361/462] net: mvpp2: cls: Fixed Non IP flow, with vlan tag flow defination.
Date: Tue, 11 Mar 2025 16:00:27 +0100
Message-ID: <20250311145812.614759560@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshal Chaudhari <hchaudhari@marvell.com>

[ Upstream commit 2d253726ff7106b39a44483b6864398bba8a2f74 ]

Non IP flow, with vlan tag not working as expected while
running below command for vlan-priority. fixed that.

ethtool -N eth1 flow-type ether vlan 0x8000 vlan-mask 0x1fff action 0 loc 0

Fixes: 1274daede3ef ("net: mvpp2: cls: Add steering based on vlan Id and priority.")
Signed-off-by: Harshal Chaudhari <hchaudhari@marvell.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250225042058.2643838-1-hchaudhari@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 41d935d1aaf6f..3ad1327395877 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -318,7 +318,7 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 		       MVPP2_PRS_RI_VLAN_MASK),
 	/* Non IP flow, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_ETHERNET, MVPP2_FL_NON_IP_TAG,
-		       MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_TAGGED,
 		       0, 0),
 };
 
-- 
2.39.5



