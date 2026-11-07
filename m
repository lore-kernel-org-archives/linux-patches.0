Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061688;
	b=GqP8Av148/aXoIN5GDjr4+DUwCrTJ0ktPTRa2FX/IblOue6PFViiTlYG+/v8Z2mLAJyJ
	 gKojuJXjp5DQWZixoNaUHGEb2f1H14OvrUGl1HQy3fzWfI/AODKrR3HF5A26cAqDpY9hy
	 3MW1yiXZ3X7lZFRSelwOxl2nvbg/0AuastnS0os5XP1S5PVODRq6RncOXQcl2r4h4+5JT
	 zKIPZ8AhSMMp3Rtmw+XVxmtCOH84+aGktknRqC9OrUnve+w96eZYxesygqVoXgsogyZBr
	 FTLJBg6eP4Mp+67hMn5upH+X/EEAXmn7ae0V+8L5rTLaeOeqUiOdV7ISgzhQurt8iqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+v1O7trVvIiuuSvpRP6EFapGkWVtIb5sPcVE/8SgnQE=;
	b=LehIbgHAmyfpn93E/9pf8v/ikrDGfgQ2Pj0/xGiONplDMUr/4V4pWNmcVCCKHWViqECv
	 XcpX7UyjEooaRPHFTZLMS0IsQLndV7Xn47lC8PuN3WezcvsvraQSPZzoJbMX+bTKkqixw
	 6DeAQ5xtQ3Vh+g9+YPuOUZL4veEvyUeja+xSAE3y2rkCWP+uBuQhZdzHZ5uDNWjKYd27F
	 /bfv/0Orzr8V/H4gA+WJuHFXxHcomaqwGyvz5Aam/8HQNIk0X+vK3Z48aUQrWbITYqUEy
	 hLAwysUobacp2UwG7p8/PwnAvEeF4f1Eh5tJqtP+qornAp7FhI6HRnoTE9w5XC4PReA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNxWgIAu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20132606A32C;
	Sat,  7 Nov 2026 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNxWgIAu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E9F1F0089F;
	Sat,  7 Nov 2026 14:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061688;
	bh=+v1O7trVvIiuuSvpRP6EFapGkWVtIb5sPcVE/8SgnQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNxWgIAuzHPVLln2N3e9ffZCUIC7NDR9S9EhOWS9RODop2fHscgwWW4Dfm1wNs8zR
	 3GXk/X4+yJxtHbpjXqjFhhiwRwPur7LH3We262qr8G18EeG2owtTj34X/AbrNROSlX
	 fpqxDguNL1SA/HKzDLff6l1Gw/wVA2vDwi6cEG/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0738/1536] xfs: dont rescan ifree and icount when frozen
Date: Sat,  7 Nov 2026 08:45:54 -0500
Message-ID: <20261107135018.246793500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 18028768415e3c05ab7edb22d740e2f4dc52836a upstream.

LOLLM points out that it's pointless to rescan the AGs if we've already
frozen the filesystem because there won't be any more perturbations.
Fix this to mark the scan incomplete and exit.

Cc: stable@vger.kernel.org # v5.2
Fixes: 75efa57d0bf5fc ("xfs: add online scrub for superblock counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -379,6 +379,11 @@ retry:
 	 * to maintain ifree <= icount before giving up.
 	 */
 	if (fsc->ifree > fsc->icount) {
+		if (fsc->frozen) {
+			xchk_set_incomplete(sc);
+			return -EFSCORRUPTED;
+		}
+
 		if (tries--)
 			goto retry;
 		return -EDEADLOCK;


