Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215905;
	b=IBpKZQtbCMMQGT1WkgUjNIqoPXV4hoBPyHBDJ/QktzImSHZig3/k58BswkZrGtzzSuqf
	 Hd9q5pv+gBRJTNO4FgQgwOtjyP/2GG13i45FSfflH7b+pYrVYFgIjT+PzvNDY4da+E1RT
	 nxt4VVO1opDt/9pOcLty08g+ramD+yrI923hTbMKTRP4SWfB/TsNGCMYNeeCsKLPZ5GXp
	 u03Dhqiux7mh61ykST0qrvam4z0/A5nazk5AyQyrMwZvL3XesEVy+HdFh/Gf1vv0/xIPe
	 wUvbIUkrs/EAuEf58sezbXRcVZ3XG+y9NnUe+NXoiZD6jNHGOMb27JHtTlNpXnI7dSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zxp3ERPgTcNifN3DiI1bGiQ8THltKhZtXAmBtMx+u34=;
	b=I+pSr6zh7UeiHY+J9z06VjbExL2CUhIQyl1MBWn+UAg4WgOSl8jfwbOjsJnWJsrlQzPR
	 ZonvRJOI0GDk2dGXAiCeQkyNqprygJX9t8mbZmP6tnrQqrsHF8z/7DIIcvEAAVyv+DI7a
	 tQufSGcxZmdn3hjnyoenLEGgs6tEMyYMQnfuaNoYT0IO1qLwUCPG26CmBe+eXN/O/JUH4
	 vLG8E7HtDv0VO+IyxmNou/ryvB3SNZPG7o2mPe2hV4CtvJWvsPol96jYwj5NV5B+Q1fiU
	 cLIg+HxYrQ3UZ8TmlFupOD0gLKLnTBvWPnzoA6DGI+SFJXSI/LVs5DASvfMm7cPbgBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cs1+2XzB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2996C606A31A;
	Wed, 28 Oct 2026 19:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cs1+2XzB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370721F01825;
	Wed, 28 Oct 2026 19:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215904;
	bh=Zxp3ERPgTcNifN3DiI1bGiQ8THltKhZtXAmBtMx+u34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cs1+2XzBrC4rizOajt9uTCw/tISjYv6f2dVmHWnMo22huElh051acUm2VHN9ZfNIm
	 aX/R0l7qfV/BmZT6Mc60Mr05JBcABm7JoW//Proc5X3bSo2uClusALChCjTe32LpxI
	 /hJjSeZrLa1rTawh/Dd1w7psaoHLgqaQoaArgrcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1374/1887] net: thunderbolt: Release the Rx HopID that was handed out on mismatch
Date: Wed, 28 Oct 2026 17:57:50 +0100
Message-ID: <20261028170530.717165385@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Ye <fy15309206903@gmail.com>

[ Upstream commit 2f1463554d0561a2fead81e3888604e5c1125e29 ]

tb_xdomain_alloc_in_hopid() passes the wanted HopID to ida_alloc_range()
as the lower bound, so a taken id is not an error there: the allocator
returns the next free one above it. tbnet_connected_work() asks for the
peer's transmit path, treats any other id as a failure and returns
without releasing what it got, so that allocation stays live for the rest
of the XDomain connection with nothing left holding a reference to it.

Release the id when it is not the one we asked for, the same way the
error unwind at the end of the function releases the expected one.

Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Ye <fy15309206903@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260811-b4-tbnet-hopid-v3-1-9e75d1b51331@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3c8b26ebf525 ("net: thunderbolt: Mark the connection down when bringing it up fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/thunderbolt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index f044a65f5e23a..a6a52d7d190af 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -625,6 +625,8 @@ static void tbnet_connected_work(struct work_struct *work)
 	ret = tb_xdomain_alloc_in_hopid(net->xd, net->remote_transmit_path);
 	if (ret != net->remote_transmit_path) {
 		netdev_err(net->dev, "failed to allocate Rx HopID\n");
+		if (ret >= 0)
+			tb_xdomain_release_in_hopid(net->xd, ret);
 		return;
 	}
 
-- 
2.53.0



