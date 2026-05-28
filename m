Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D772C11F9;
	Thu, 28 May 2026 20:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999518; cv=none; b=DBG0mMPxi/rxlCS1BFKi6qSM05X14Ont/Je0WjqILvVMhJ3JbeCi79yu+WasumRwqPtPSqJead9ot0hq4cKO1mDc9aJ6OCC6DVklwOBt1dpILf3nS+aCvoop3KukitBQQPJwNV9qZjJlg2n5IVgXozwIjg1FtnrYZd8gfNRPp8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999518; c=relaxed/simple;
	bh=6ebgZ2NozLe/1+5aA8LDGglqjtwaJxdnlUsSYpxIdJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YDPLaTtQtBmG8elqDStNHRcwVVxiDdZUFNqUtZMntaHAmfI6sXA7hC5cSuztdVTrY6PtU2QVDHuXVMTK9CKfB+aXmoMt77ORJKJfjcMKgK0kx8f+QK2XZ3bZXMoT0NEAVC2pSVdsAnPlDpIFLs3zzMIYJnZW0/etSwvvG7AgWeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8KE1Fls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8KE1Fls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6541A1F000E9;
	Thu, 28 May 2026 20:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999516;
	bh=XbUwfSe5CQLQNtznpEZ6U0JgJUGydyKhj+KIkk9Mrnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8KE1FlskyIA2dSm4JMsg1L76OJIx85fLScFZQn6TtrOPG/fNWOcVSHmvpDLqzsIG
	 Ai8BWqK9EnNLqqjZuNIbVMA9Kgmvqj9fheeldAKzPPFq8FiXSadoAmNDz2Aj8vio0v
	 194AooPbaTzzdone4h0GSiDra/m6EpM1q78bLcvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Goutham <sgoutham@marvell.com>,
	Linu Cherian <lcherian@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	hariprasad <hkelam@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	stable <stable@kernel.org>,
	Sam Daly <sam@samdaly.ie>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 095/377] octeontx2-af: CGX: add bounds check to cgx_speed_mbps index
Date: Thu, 28 May 2026 21:45:33 +0200
Message-ID: <20260528194641.106867100@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Daly <sam@samdaly.ie>

commit c0bf0a4f3f1f5f57aa83e1400ba4f56f0abfd542 upstream.

cgx_speed_mbps has 13 elements but RESP_LINKSTAT_SPEED can yield values
0-15. If it returns a value >= 13, this causes an out-of-bounds array
access. Add a bounds check and default to speed 0 if the index is out of
range.

Fixes: 61071a871ea6 ("octeontx2-af: Forward CGX link notifications to PFs")
Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: Linu Cherian <lcherian@marvell.com>
Cc: Geetha sowjanya <gakula@marvell.com>
Cc: hariprasad <hkelam@marvell.com>
Cc: Subbaraya Sundeep <sbhatta@marvell.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: stable <stable@kernel.org>
Signed-off-by: Sam Daly <sam@samdaly.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026051352-refined-demise-e88d@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1294,13 +1294,18 @@ static inline void link_status_user_form
 					   struct cgx_link_user_info *linfo,
 					   struct cgx *cgx, u8 lmac_id)
 {
+	unsigned int speed;
+
 	linfo->link_up = FIELD_GET(RESP_LINKSTAT_UP, lstat);
 	linfo->full_duplex = FIELD_GET(RESP_LINKSTAT_FDUPLEX, lstat);
-	linfo->speed = cgx_speed_mbps[FIELD_GET(RESP_LINKSTAT_SPEED, lstat)];
 	linfo->an = FIELD_GET(RESP_LINKSTAT_AN, lstat);
 	linfo->fec = FIELD_GET(RESP_LINKSTAT_FEC, lstat);
 	linfo->lmac_type_id = FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, lstat);
 
+	speed = FIELD_GET(RESP_LINKSTAT_SPEED, lstat);
+	linfo->speed = speed < ARRAY_SIZE(cgx_speed_mbps) ?
+		       cgx_speed_mbps[speed] : 0;
+
 	if (linfo->lmac_type_id >= LMAC_MODE_MAX) {
 		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d reported by firmware on cgx port%d:%d",
 			linfo->lmac_type_id, cgx->cgx_id, lmac_id);


