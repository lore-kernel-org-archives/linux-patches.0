Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEFC12E46;
	Sat,  3 Feb 2024 04:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933683; cv=none; b=W0Rm8SabaHB0qkdLyVBTbjiW7Rpv4CSCkLa9s+zPHU+tx9A5Ea+3IaRBaKLqN3RbVb0y04pAGq3GV54xOunrw7daehKMClDeqo/6RkvxfJ2mYR5hasdpmaVE3wvJtrV2jzrZTdYnWBsSaHFNANW2PWJ1cUkvpplIGTGSEz1ftqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933683; c=relaxed/simple;
	bh=hpfhMGbkGXZOlaFLDw2q/yA2a9YxH1QDyVbISrAiSyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QdJXYgp2MjZ64dl1Lbw9xsStxjUOvLFTljin8xA3VF6SjVS7qoWnEfgd472gRbggySwXxCCnliXZxDbc1zJRpeQ0vjIYQEnlDtdjpCwgKPkQEJ5SYhuSeNo3FMJ8o0sgJJSXEl9Hb/66g9ARBwpOm7dppwOr+N9CZEOaUSNMsjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJ2T9DDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJ2T9DDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D22C433C7;
	Sat,  3 Feb 2024 04:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933683;
	bh=hpfhMGbkGXZOlaFLDw2q/yA2a9YxH1QDyVbISrAiSyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJ2T9DDFzFp9jIEEmIeMQ7fiDxZwNenySfN8XfExkSVE4wTwh/8Yu2f9Lvm7lkv67
	 LDG1nP08QOmM6VteOqYQbv0B8KA5pghuqKg2AWRWxdEiDUBcJuez0sySFsMm7J4rZM
	 oDSLju0Mn06hylPNqds0aaVl2iKmlSWSPw/MS37g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 278/322] net: dsa: mt7530: fix 10M/100M speed on MT7988 switch
Date: Fri,  2 Feb 2024 20:06:15 -0800
Message-ID: <20240203035408.080783594@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit dfa988b4c7c3a48bde7c2713308920c7741fff29 ]

Setup PMCR port register for actual speed and duplex on internally
connected PHYs of the MT7988 built-in switch. This fixes links with
speeds other than 1000M.

Fixes: 110c18bfed41 ("net: dsa: mt7530: introduce driver for MT7988 built-in switch")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/a5b04dfa8256d8302f402545a51ac4c626fdba25.1706071272.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 035a34b50f31..4b6ac3f29f8f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2848,8 +2848,7 @@ static void mt753x_phylink_mac_link_up(struct dsa_switch *ds, int port,
 	/* MT753x MAC works in 1G full duplex mode for all up-clocked
 	 * variants.
 	 */
-	if (interface == PHY_INTERFACE_MODE_INTERNAL ||
-	    interface == PHY_INTERFACE_MODE_TRGMII ||
+	if (interface == PHY_INTERFACE_MODE_TRGMII ||
 	    (phy_interface_mode_is_8023z(interface))) {
 		speed = SPEED_1000;
 		duplex = DUPLEX_FULL;
-- 
2.43.0



