Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024105;
	b=jH0eoYmGTIA2wJA+3+q9ogy4IwnwsEtZuoa6PtXBKeeo8FoEEh47bfov1cENBAD9UOGL
	 Yn9ZlZ/L6ark6h9drWgJ57HELS2zwO2kh5onKdeqgOARReox969BlDLzO1b6ZsigDaoOJ
	 +v/Ai51WaCO7Y0HJ5jFsj/toJfKoeI4I8d6q7bG67aDTBBaP2d76niNs/Vho6HRfx8GOz
	 O3hnN2GriK3KnewJ1ZnS85tUjCT09k1TovgGm7B60+unk031Updeh51IflbX5rpf2eNWk
	 BWNyVNEBSSivE+re1ILfh2XF/cTT7UNbpJG10APdZEHeE0N9PxMdckgAPuxflt3q3Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HBDu3VzGSFsvj+8DAmagdpexNNtDz10bHyrqIidsTBE=;
	b=JQ89oA+6Ny2h3XcL5i3z5+LbWNTdvvghwdiq+IpSY9rPLRiGgQjRTXaSN0ZbEV3LRdzw
	 /cMRyGIUWzGYVzhKarBLK+QQ8Ux6Ep638YpAXEdgGwWlpANlCbf2QCrXmAunX5EZNHInh
	 MMKOmV96k5AutKySsWs0oMzOOMHmsI3trsIR+vvcz/2CedX5s6PoUL7R+rJ01oPFfA6VQ
	 NHeFxTsCL2A+Z8N2EV3EJ1SDc8azXJ0iIXWIWeF/AKgn9wPz8VB623kxbhadnk8KLiEVJ
	 MDIFKFSxu06xQIbGxCtQS/j2Kexzu4nfGOhGnD8ihGnemTTrrB1+n9s3m1PZlZumY3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+ttb2NI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1BE606A325;
	Wed, 18 Nov 2026 17:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+ttb2NI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF98C1F000C4;
	Wed, 18 Nov 2026 17:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024105;
	bh=HBDu3VzGSFsvj+8DAmagdpexNNtDz10bHyrqIidsTBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+ttb2NIcsdaSDUMsKX5/AF+NZKcpCmx2RMXlZm0tsln+u/WFgjaloJbeJbTlTvBS
	 K8wafRuga0rUUuf+Bbm1HR824UX2ADpiXrgdKyZcL4UsdIhl+JTXyIGVtDC0mmgpXa
	 OihfFuBzM0ePUYGMArsW4Qdx1S0T7nDg3ndQDZDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0566/2151] i3c: mipi-i3c-hci: Restore controller state if i3c_hci_enable_ibi() returns an error
Date: Wed, 18 Nov 2026 15:38:21 +0100
Message-ID: <20261118150142.566244532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit ad869331ac616bf192c04081ef7e206e1d106ad8 ]

i3c_hci_enable_ibi() performs controller-side setup before sending the
ENEC CCC to enable IBIs on the target.  If the ENEC CCC fails, the
function returns an error but leaves the controller configured as if IBI
enabling had succeeded.

Fix the error path by undoing the earlier setup when the ENEC CCC fails,
ensuring the controller state remains consistent with the failed enable
operation.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260920151248.46936-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index e9fd314eb17b9..6bb33193970b2 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -522,11 +522,15 @@ static int i3c_hci_enable_ibi(struct i3c_dev_desc *dev)
 	struct i3c_master_controller *m = i3c_dev_get_master(dev);
 	struct i3c_hci *hci = to_i3c_hci(m);
 	struct i3c_hci_dev_data *dev_data = i3c_dev_get_master_data(dev);
+	int ret;
 
 	mipi_i3c_hci_dat_v1.clear_flags(hci, dev_data->dat_idx, DAT_0_SIR_REJECT, 0);
 	scoped_guard(spinlock_irqsave, &hci->lock)
 		hci->ibi_devs[dev_data->dat_idx] = dev;
-	return i3c_master_enec_locked(m, dev->info.dyn_addr, I3C_CCC_EVENT_SIR);
+	ret = i3c_master_enec_locked(m, dev->info.dyn_addr, I3C_CCC_EVENT_SIR);
+	if (ret)
+		__i3c_hci_disable_ibi(hci, dev);
+	return ret;
 }
 
 static int i3c_hci_disable_ibi(struct i3c_dev_desc *dev)
-- 
2.53.0



