Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434822566E9;
	Thu, 17 Apr 2025 18:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914099; cv=none; b=AWT1J+K4oLJX401ze13CueufBmX96GYz49jnZHEhuFMdMpPRLe4EQfMn4gmc8CKQPyLDB0KZKikkQMMNVQn/tgiqIqRUlNTIjctDgN2RZrfj0BHDzGDZGjhJsqKfYAxyBCQi9d2MjDvDQ6POQspuAlCJs8mRoOGD60G2f4jVWWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914099; c=relaxed/simple;
	bh=k3ftBJVlaqUZu6E52MBOqJeI5+67rPj5sy1YuXxv9F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFCCKhDQSrxJRrtreR29kAsuAwJTZnP8FnisDhmoHuNNwganeASbDPt1FQLDOx5gFQGq3lzGXHQkWvS8jchlz88M3xwFfQoNHffSHq89mjKCAoiaPuP1hYz63kXZcXxpwg+0QiNfYM4WXyqzXndX8dM8GwwLiQody3og2g1Ke8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlXXjyoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlXXjyoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E73C4CEEA;
	Thu, 17 Apr 2025 18:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914098;
	bh=k3ftBJVlaqUZu6E52MBOqJeI5+67rPj5sy1YuXxv9F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlXXjyohU9Iw3iNhHwnFuBWG0sZ5PDob1Wya2gYJo26nR9WsmWkK8lAkNuesIYH57
	 gZ7SZ1u923Ym2mmi649Cns6EaUSw1/Hwi+yXjt5Zt06IZt9SBNk/xl5urtQsOZ+MEM
	 afwQ2jqc3areQpVo6HXGn0eh6+Xmxmhxut1iS7SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Birger Koblitz <mail@birger-koblitz.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 105/414] net: sfp: add quirk for 2.5G OEM BX SFP
Date: Thu, 17 Apr 2025 19:47:43 +0200
Message-ID: <20250417175115.663354370@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Birger Koblitz <mail@birger-koblitz.de>

[ Upstream commit a85035561025063125f81090e4f2bd65da368c83 ]

The OEM SFP-2.5G-BX10-D/U SFP module pair is meant to operate with
2500Base-X. However, in their EEPROM they incorrectly specify:
Transceiver codes   : 0x00 0x12 0x00 0x00 0x12 0x00 0x01 0x05 0x00
BR, Nominal         : 2500MBd

Use sfp_quirk_2500basex for this module to allow 2500Base-X mode anyway.
Tested on BananaPi R3.

Signed-off-by: Birger Koblitz <mail@birger-koblitz.de>
Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/20250218-b4-lkmsub-v1-1-1e51dcabed90@birger-koblitz.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 7dbcbf0a4ee26..9369f52977694 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -515,6 +515,8 @@ static const struct sfp_quirk sfp_quirks[] = {
 
 	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
 	SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
+	SFP_QUIRK_M("OEM", "SFP-2.5G-BX10-D", sfp_quirk_2500basex),
+	SFP_QUIRK_M("OEM", "SFP-2.5G-BX10-U", sfp_quirk_2500basex),
 	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("Turris", "RTSFP-2.5G", sfp_fixup_rollball),
-- 
2.39.5



