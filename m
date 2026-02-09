Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A03F37BE93;
	Mon,  9 Feb 2026 14:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647980; cv=none; b=ZuMhfs9I2b9vo6c1whn0wpc+VWUU0seTKNH+Br/C3G9P0Js573D570lmLDZe9LwBvM5JaLaMhXcqhgRmWWViX1cH8jbSXc3hSs95fwbaozVzDIM0GGF2s6IUs6K74A/jGqNSIk7JWC91H1SZVIug8qd5nzZHYQkGHnsg/to40gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647980; c=relaxed/simple;
	bh=5Gce1GNASLIKecKtOkiqNQOrM9WqYLGE59nDYiyLl1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFXTkH37T2MuMs2Y9pONqfyfSCtwVLJMJrvBnrSXlw0FsqJKjFHFAXSMDbnRGAKz5S5+l1LlINBp9VsOOKDUY4vzJIqEBi0gq/WHp44edrhhUHDcTZZjkK4mg0vlZjuO/bCboguO6u2DKrMZtKZKnK/AUpgIng/V6GUMeK36Afk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6JjnrF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6JjnrF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F26C116C6;
	Mon,  9 Feb 2026 14:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647980;
	bh=5Gce1GNASLIKecKtOkiqNQOrM9WqYLGE59nDYiyLl1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6JjnrF4fOKiK6kaQ494YyS3szafuEr4VbkKG55Vwzz86ozbXjy/wSNBbVFxdlueT
	 2Vl1LnIoJ8gGTRtVq23h6dZs8oiBbD/zHLA8z7PovdXpDcywlU0RNse6V6OAdAXwoh
	 peXja9J3785saPG511LMbCXh5JXBvoZ6d/rrGGPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/113] net: phy: add phy_interface_weight()
Date: Mon,  9 Feb 2026 15:23:54 +0100
Message-ID: <20260209142313.239874837@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 4beb44a2d62dddfe450f310aa1a950901731cb3a ]

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/E1uslwn-00000001SOx-0a7H@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: adcbadfd8e05 ("net: sfp: Fix quirk for Ubiquiti U-Fiber Instant SFP module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/phy.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index dfc7b97f9648d..6fe5d564beed4 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -187,6 +187,11 @@ static inline bool phy_interface_empty(const unsigned long *intf)
 	return bitmap_empty(intf, PHY_INTERFACE_MODE_MAX);
 }
 
+static inline unsigned int phy_interface_weight(const unsigned long *intf)
+{
+	return bitmap_weight(intf, PHY_INTERFACE_MODE_MAX);
+}
+
 static inline void phy_interface_and(unsigned long *dst, const unsigned long *a,
 				     const unsigned long *b)
 {
-- 
2.51.0



