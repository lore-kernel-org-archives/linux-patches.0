Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4513B3BE7;
	Mon, 23 Mar 2026 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274424; cv=none; b=XZCt4DAyIFiiI3wj0b3c6JYEKZ04CeAgRhQx41gglBmDotR9CelRi4pQIkZDujFBoXwgeJOLhSyOikmFvSJdUJkzR2v2YkYEYWy+8+j8i5ywVrQxshTk8boq6GvKC9ZjWLZmTihBGm5Emh8bftxIPtjsgjv2q45Kvb5QAAmabI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274424; c=relaxed/simple;
	bh=Zzr/TZdP6nra41VkRssJpCxhyL1WLDsH8wY+cSr1rh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foLrN9V/qltLlt5FNs9ZZU5c/ymswYITBHf7egdMcp1johh3wln/tDu1Sd1XwEWYNNjW/CpOCfd5ElidcF3RmYalo54qz+Ner8LJ7XWcbVh9UpugGSjNr/3TWtYfZASzjseE8kaScHdkAzyPbssNQE9b1wyOd0ArGvm3Nbq55Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ht7Lg/Ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ht7Lg/Ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FE5C4CEF7;
	Mon, 23 Mar 2026 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274424;
	bh=Zzr/TZdP6nra41VkRssJpCxhyL1WLDsH8wY+cSr1rh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ht7Lg/JuzeNwH6usdwtWR2rNv8lYgfHa3U0c/fTTRxjEnKA9E4AYvdgN33KIDiZBo
	 8sRWRUtd12Qf5Fs3mt5GfExjnkzMiXEQqW2Wc/qtnW0Zv9h0Ns3VZIAyYiahhA7dob
	 TggePKYzgHjtuD3HIdR8I/TG2H4YLRWc8wwLnZ64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 211/220] drm/bridge: dw-hdmi-qp: fix multi-channel audio output
Date: Mon, 23 Mar 2026 14:46:28 +0100
Message-ID: <20260323134511.206063437@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit cffcb42c57686e9a801dfcf37a3d0c62e51c1c3e ]

Channel Allocation (PB4) and Level Shift Information (PB5) are
configured with values from PB1 and PB2 due to the wrong offset
being used. This results in missing audio channels or incorrect
speaker placement when playing multi-channel audio.

Use the correct offset to fix multi-channel audio output.

Fixes: fd0141d1a8a2 ("drm/bridge: synopsys: Add audio support for dw-hdmi-qp")
Reported-by: Christian Hewitt <christianshewitt@gmail.com>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20260228112822.4056354-1-christianshewitt@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c
index 60166919c5b54..ace9d8bcdd197 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c
@@ -838,7 +838,7 @@ static int dw_hdmi_qp_config_audio_infoframe(struct dw_hdmi_qp *hdmi,
 
 	regmap_bulk_write(hdmi->regm, PKT_AUDI_CONTENTS0, &header_bytes, 1);
 	regmap_bulk_write(hdmi->regm, PKT_AUDI_CONTENTS1, &buffer[3], 1);
-	regmap_bulk_write(hdmi->regm, PKT_AUDI_CONTENTS2, &buffer[4], 1);
+	regmap_bulk_write(hdmi->regm, PKT_AUDI_CONTENTS2, &buffer[7], 1);
 
 	/* Enable ACR, AUDI, AMD */
 	dw_hdmi_qp_mod(hdmi,
-- 
2.51.0



