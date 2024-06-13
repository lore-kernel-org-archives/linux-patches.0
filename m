Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4329142E84;
	Thu, 13 Jun 2024 12:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281000; cv=none; b=ZitieM5DLa6Y8VABsu9fUls8usuoFY1S14KI4hlEwThSk0M1mZpEGuxJideLHSh/rgiSCDGUYlNmGSQ/YORfUqyD7oqB+HaamfeJhDfzKr3HbNhxWXHpkNjLsDbh/DB8A5leaNTbMqNyghzk70uGV208MeeLDwE5G0fdJhf9SUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281000; c=relaxed/simple;
	bh=rO0Iec/KHqumFFcUf4HdBQ0B5NOehRC2wQzC/ovjo+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+cKhi9Ih4sssA/Y8Xi0OvM28N5oDgrwueGxvYVI2FsN5HXkzngWAlD7hcaCRHi0N9vLI+AWtf0o2t8mtrG3EomeeXhbb/n48cQ4DjFVYagTQ8fBCnxhJnMCT6lyTV/FrGLD4XFhjcojVCZ0kwAclgRnwcAZwEkt5b4qJFYQasQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yELakhF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yELakhF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF86C2BBFC;
	Thu, 13 Jun 2024 12:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281000;
	bh=rO0Iec/KHqumFFcUf4HdBQ0B5NOehRC2wQzC/ovjo+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yELakhF3RLnEF1UBYsZtI3f+75h/ExMR6zCvfGGF67vDQQ+FWUzQE9i6Z9p3iB6dS
	 voKRxh5Eru7nSq24jhV1SSoUQF1rT08kBYM01C7lMSUOylBCr5Zkyq0s2/9Xlju71P
	 XXCg1DbOczcx35g0tKZSsVfPonzYyh4YqzVDJp/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/317] drm/bridge: lt9611: Dont log an error when DSI host cant be found
Date: Thu, 13 Jun 2024 13:32:05 +0200
Message-ID: <20240613113251.690014804@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit cd0a2c6a081ff67007323725b9ff07d9934b1ed8 ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Fixes: 23278bf54afe ("drm/bridge: Introduce LT9611 DSI to HDMI bridge")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-4-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index 660e05fa4a704..7f58ceda5b08a 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -766,10 +766,8 @@ static struct mipi_dsi_device *lt9611_attach_dsi(struct lt9611 *lt9611,
 	int ret;
 
 	host = of_find_mipi_dsi_host_by_node(dsi_node);
-	if (!host) {
-		dev_err(lt9611->dev, "failed to find dsi host\n");
-		return ERR_PTR(-EPROBE_DEFER);
-	}
+	if (!host)
+		return ERR_PTR(dev_err_probe(lt9611->dev, -EPROBE_DEFER, "failed to find dsi host\n"));
 
 	dsi = mipi_dsi_device_register_full(host, &info);
 	if (IS_ERR(dsi)) {
-- 
2.43.0



