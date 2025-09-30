Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A43A846F;
	Tue, 30 Sep 2025 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245770; cv=none; b=Z3RVkktueKEDsFbrph5SlrUUSKJv0OyyOzUbFeftAQCi3ee7XI+99ZYzSHlRmZRccrqg05k+1kO2s2WMe00CNzM4pMRFaq9xoZTPx89gWtz6KQPk52k7x53fmXotYzGcS7WTvxBllnHXo5crH/33pQqrNJRTroYExFSTfrd7T/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245770; c=relaxed/simple;
	bh=vv7KViAnXvcNe/aLUpZ8k2e4qvuZJY71sBrGO5qO3QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a62BKkOUR57gF+1aab3Q0uPEkqBAUa52P8jBOYTXckmVpEQghNxcrzQi6/ThcMuno6T1xnTw/Nkri8HbBKIDCcreHDOJabiiEmW60wlQ/Ej8NRgdFyqD2oOrn85pdFpN1c7z4Yo/7sGQT/QVrG+S3UgA7jDTQ7VLq5JcnePTP0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmDNlPJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmDNlPJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8684AC4CEF0;
	Tue, 30 Sep 2025 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245770;
	bh=vv7KViAnXvcNe/aLUpZ8k2e4qvuZJY71sBrGO5qO3QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmDNlPJ52PvIOXVM+HsHgn+TMnFMgCYlHPQj3R2iS9A8nPB+XTSG7CuGPZZiJwIUA
	 4a0rufMHoO/55jJcxFk+sSIv+niv0u491/8hn8R9YCkVF7bFeAl1B6ZFTgORjkdY04
	 FXrouvgYXPZq3X965AcIFZeFtk7rZvsRssr1mUco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 44/91] bnxt_en: correct offset handling for IPv6 destination address
Date: Tue, 30 Sep 2025 16:47:43 +0200
Message-ID: <20250930143823.004336776@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 3d3aa9472c6dd0704e9961ed4769caac5b1c8d52 ]

In bnxt_tc_parse_pedit(), the code incorrectly writes IPv6
destination values to the source address field (saddr) when
processing pedit offsets within the destination address range.

This patch corrects the assignment to use daddr instead of saddr,
ensuring that pedit operations on IPv6 destination addresses are
applied correctly.

Fixes: 9b9eb518e338 ("bnxt_en: Add support for NAT(L3/L4 rewrite)")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Link: https://patch.msgid.link/20250920121157.351921-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 273c9ba48f09a..b896f8d20ff33 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -244,7 +244,7 @@ bnxt_tc_parse_pedit(struct bnxt *bp, struct bnxt_tc_actions *actions,
 			   offset < offset_of_ip6_daddr + 16) {
 			actions->nat.src_xlate = false;
 			idx = (offset - offset_of_ip6_daddr) / 4;
-			actions->nat.l3.ipv6.saddr.s6_addr32[idx] = htonl(val);
+			actions->nat.l3.ipv6.daddr.s6_addr32[idx] = htonl(val);
 		} else {
 			netdev_err(bp->dev,
 				   "%s: IPv6_hdr: Invalid pedit field\n",
-- 
2.51.0



