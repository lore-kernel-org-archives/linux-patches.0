Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB7425E81A;
	Tue, 11 Mar 2025 15:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706102; cv=none; b=U/BG9R8iMZlFL+3PwC0IWAKRn3TclO2o4DNgDU9p9C4fkmCWzsIga3u5oCNm+UZrDzev7SpBqQgyPVvO18PN3p/P1kggX6ibWYQj1+lSlDpWMlPUu9MCtIgtX1H1TT+Oq5tJ3vblsj8NapizFM0bGMyDxvNIxe0BK3Zdy67ql4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706102; c=relaxed/simple;
	bh=WZrBt7VWIaxpVL7xz455Lk4n9E0lZop2WzQ6j9j/Tds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itulHieoIUZwYB2vRK26CGL5iOa9Pg5OgZZyOyVXTc2Qy6slwd0GI+wKq7GtAmbMVFPphs32AN8OQoooG+/XghpvT3Eu+O+aaqZLXxWMDkDqPiTonVbn/X4OtZ8cx4VgmIV2rJYc2Zl2ze8jzZ4Y1P8InaVvT0rYdn1uJFYXZ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s57jCoZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s57jCoZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC19FC4CEE9;
	Tue, 11 Mar 2025 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706102;
	bh=WZrBt7VWIaxpVL7xz455Lk4n9E0lZop2WzQ6j9j/Tds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s57jCoZsconArBQzOnFvha9XYDNdXiKtPAq05GZb/vW/0x2xOJgVgmpUohYRAeRv7
	 3Qt6z5a+4dc0rh/HytuUBbhIFpbTKr60j6EPmpisGWCpKCXLqXAz5fVeZBbIRIR6q/
	 cpbL7nl4c5IakEfXha7aA1hJL34UWWpjafKTFx0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshal Chaudhari <hchaudhari@marvell.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 263/328] net: mvpp2: cls: Fixed Non IP flow, with vlan tag flow defination.
Date: Tue, 11 Mar 2025 16:00:33 +0100
Message-ID: <20250311145725.363850248@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6122057d60c00..0f55444861cda 100644
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



