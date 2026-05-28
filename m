Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B80C2EF652;
	Thu, 28 May 2026 20:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000603; cv=none; b=cz3hChLoplpnhV1YO1gsHhq6YpPxftVWi9jM3Lhp6hslnypOO8mT+XUFsAnbLy+/6x3Ln8o1/SbnASPDN+IHMWGhXPe6sh/x8c6TdepFcHNDHQcvM3MzwztbAFtteYjfPaKGfg96kkiGAy7NBFSKr3OYRvkrqY22JUusTkEeXIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000603; c=relaxed/simple;
	bh=AZFDTOPMfJKyNwjXIOQTZt5dHEh1w4/doVe3Z+nLmRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YV4c7CxoTaZQNaPtBmN1YcTPU0dzyqwggHJ3G2yQ3sEETpe3C6S7eesDT5zn2M1O/DgC6n99ksD9mEVYwQ479N8Jk6q8D2RTyiq4ZuFoBCcpQ4BsFqb4ZRn+hzFluuUF/Tly8mDpmgpKcQb2NYhoB37dePOkPq+DxCRsug77PKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/hbO8wk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/hbO8wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A54A1F000E9;
	Thu, 28 May 2026 20:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000602;
	bh=WOsanqMRA6Bvv8G3OvMWDjU+TyfYl1xbghK3Fp+ZB2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/hbO8wkyFBzAFQcfcu5vxoTsbC4d/irCMn5vNvjWnukH8rIvpBQowFhCCCTWd78v
	 kgg2avSXrq00GnbmDUYcsbc9SNelumHadl9oZfU3OzexMu6agWW8NMpVEiWMTSx+HP
	 kwzJoopa14pQ9NJXvVgvL6cqhCHOEdRq9NtQTA+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.12 104/272] drm/bridge: chipone-icn6211: use devm_drm_bridge_add in i2c probe
Date: Thu, 28 May 2026 21:47:58 +0200
Message-ID: <20260528194632.290698452@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 73d01051e8040c0b1de7fd26b3b8d0c2ffa6895c upstream.

Use devm_drm_bridge_add() so the bridge is released if probe
fails after registration, and drop drm_bridge_remove() in chipone_i2c_probe.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Fixes: 8dde6f7452a1 ("drm: bridge: icn6211: Add I2C configuration support")
Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260430194944.78119-1-osama.abdelkader@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/chipone-icn6211.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/chipone-icn6211.c
+++ b/drivers/gpu/drm/bridge/chipone-icn6211.c
@@ -757,7 +757,9 @@ static int chipone_i2c_probe(struct i2c_
 	dev_set_drvdata(dev, icn);
 	i2c_set_clientdata(client, icn);
 
-	drm_bridge_add(&icn->bridge);
+	ret = devm_drm_bridge_add(dev, &icn->bridge);
+	if (ret)
+		return ret;
 
 	return chipone_dsi_host_attach(icn);
 }


