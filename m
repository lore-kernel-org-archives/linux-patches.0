Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06B228BAB7;
	Wed, 23 Apr 2025 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420992; cv=none; b=W8dIdmbhX975xcecHo6ewDNBwzfCs0PJofMKfYCT93m9gu47rmUPdfP37kdcVuCLA5lJmGPwiJKbv+Jebxkz096xUdSiPfztqxcRJKFSi/i/eDb/XWItYO964zTwAR2rUgwKTRTFQJ2ysLy5uLSj9bO+LXigAtScKs2Q+Qh7sJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420992; c=relaxed/simple;
	bh=hLBu7WK1WowL/iDw6KsdNpnY/twPdih5pKbgnf15+E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KfvweDBW/zGwfvwgox3tZzBmHQcwy1R2S/1KDa2LnGyCgkrDF2nAN2EeVOc2nqNPdyf9ljkm98u8WsaU2QdqDi9Sn2Zuf7ftjOBaXA9JlYVzuRUPacqH8RTSw3QWrWC2qSHwdbt83UFuYaJPH0AT7+ATr+PsWqVyYz2ksELyOGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WP2nBZ7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WP2nBZ7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7373DC4CEE2;
	Wed, 23 Apr 2025 15:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420991;
	bh=hLBu7WK1WowL/iDw6KsdNpnY/twPdih5pKbgnf15+E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WP2nBZ7pbWWZolYeYnSY0vtJXhsdU5Wgif68HlbrOqmVzIjdT8Cx+9c8wVxHhBPqJ
	 mUfAhkTVJ0YmCnwmu9iVOPyYS+NnoGQb4OUsD00xq6xtc3S9Mzi+OwxSxbbj7FMRZk
	 qS70a0Oy7b230asgXyjD01VPelj1HTKrzUGumI8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 122/393] media: i2c: adv748x: Fix test pattern selection mask
Date: Wed, 23 Apr 2025 16:40:18 +0200
Message-ID: <20250423142648.405168012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

commit 9e38acacb9d809b97a0bdc5c76e725355a47158a upstream.

The mask to select the test-pattern in register ADV748X_SDP_FRP is
incorrect, it's the lower 3 bits which controls the pattern. The
GENMASK() macro is used incorrectly and the generated mask is 0x0e
instead of 0x07.

The result is that not all test patterns are selectable, and that in
some cases the wrong test pattern is activated. Fix this by correcting
the GENMASK().

Fixes: 3e89586a64df ("media: i2c: adv748x: add adv748x driver")
Cc: stable@vger.kernel.org
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[hverkuil: fixed tiny typo in commit log: my -> by]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/adv748x/adv748x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -322,7 +322,7 @@ struct adv748x_state {
 
 /* Free run pattern select */
 #define ADV748X_SDP_FRP			0x14
-#define ADV748X_SDP_FRP_MASK		GENMASK(3, 1)
+#define ADV748X_SDP_FRP_MASK		GENMASK(2, 0)
 
 /* Saturation */
 #define ADV748X_SDP_SD_SAT_U		0xe3	/* user_map_rw_reg_e3 */


