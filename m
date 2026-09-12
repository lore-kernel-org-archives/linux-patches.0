Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB5930DEA6;
	Sat, 12 Sep 2026 16:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228859; cv=none; b=XRdTL00n57DSLgmmvKDyGq3+SHtbR0VoIqiUlTCK/18gVrR2ydirhuanydGkG4I16jn0L2N9AyuKQm5kvTvk8X7zaT8OYYOwYt/hXRjuIQzEg0juGXN3vpCwPRuxkl811gpGHXaM785Ay2jl7zG1DOkPV0ldr0c2Sp2smmoFLGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228859; c=relaxed/simple;
	bh=wBoUmKFDbGR2JtvqLMO81tvl9+MBba3XyQPk1d64dU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRsyyDEnV5xVDIwChu5g4TjaD/CT1AtY5irIPxkt5KEtcofVuy3EgtXjAK+89EY1CMgaG2PU+gL6NbShR20XP+ViZdm2sD+TunuBx0ZOT3eU4YN95PQuBtn7zmL+ajTR6DHdSL7ZSY1H7qxbWfpKaURZ+ELaZYUf8UkBXk2Mq10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMx0CTof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMx0CTof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A781F000FF;
	Sat, 12 Sep 2026 16:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228858;
	bh=5CwniUh9cpBjV96/UE5wxmwfwTG1Be9aT5os2Y6h7oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMx0CTof3BAI0DEsszCLc+5Zukda9m7ajx2rsuIJr+UsaBGBrBOpUsdTLAvj4Cqnx
	 60pino8Caa1UTJawR4rJJpzRG2Prw3zMkqFSaJhtogy/fzjvCHmxKbPXZYZRo0mC9t
	 lhNfw3AZU1EhovcbX/Lhdj/s3OvIYXz64O9jrqDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0472/1191] platform/chrome: cros_ec_typec: Set parent of partner PD object
Date: Sat, 12 Sep 2026 08:53:20 +0200
Message-ID: <20260912065558.834750228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit ab3593eeef606816bcc28b12690c51379c3d12eb ]

In order to tell what Type-C device a PD object belongs to, its parent
needs to be set. Use the Type-C partner USB PD registration wrapper
to set the parent appropriately for PD objects which are created for
connected Type-C partners.

Cc: Benson Leung <bleung@chromium.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Link: https://lore.kernel.org/r/20221122220538.2991775-3-pmalani@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a0a8cd9fc9c4 ("platform/chrome: cros_ec_typec: Reject out-of-bounds PD cap count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 748efa73378ca..17f53bb25eade 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -972,7 +972,7 @@ static void cros_typec_register_partner_pdos(struct cros_typec_data *typec,
 	if (!resp->source_cap_count && !resp->sink_cap_count)
 		return;
 
-	port->partner_pd = usb_power_delivery_register(NULL, &desc);
+	port->partner_pd = typec_partner_usb_power_delivery_register(port->partner, &desc);
 	if (IS_ERR(port->partner_pd)) {
 		dev_warn(typec->dev, "Failed to register partner PD device, port: %d\n", port_num);
 		return;
-- 
2.53.0



