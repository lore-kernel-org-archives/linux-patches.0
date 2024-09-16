Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E77157E9F;
	Mon, 16 Sep 2024 12:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488225; cv=none; b=RFmeu/A7caAQDiBo3GDrkJgTwpuG8DlMYHXt0KrU8ATku/6MxKKGgqtvyX4yVmkjd91gWigAWciKVsPCNZBDnUY/r60Rpg3oXplIYZQkxzspnY7CNtoK/bEr/G/u+lep3bfF5148SFcopgBawQpuSL33/mIQJl/3zFVAvhISHOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488225; c=relaxed/simple;
	bh=cCqHzIFQdlz1EuVQ21XjiaIw7pIBSrObZkUT4xGiCS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDjLt4YnBuibDaFRc7BluxAMxQOwuRR1w31cADS474T1lmS00IcU5a9XB15mx5uQANE+XihtTMcPhGAXMbux5ICYmoNWne4DIylXYIIVElrLJ+qdqrcsjeyDU2b8of8DJ2QRI0Gbgvi4nraFF0M5PYGX7qamG9hVtH4QR+1feJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2O6o5Ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2O6o5Ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6C7C4CEC4;
	Mon, 16 Sep 2024 12:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488225;
	bh=cCqHzIFQdlz1EuVQ21XjiaIw7pIBSrObZkUT4xGiCS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2O6o5SsvwzgQvNBWyMU57G/jvdc2BE3aPmG5BUk1hyXknauTfFwGLdEel71m05j+
	 izVIGjPo/5/W2oWFROSZWM5aVyKW+vx10vtb5hJGEzV44xim9/kaNzbMI7WFmS1lvq
	 lvjZWxq+qfKPUdzmi2VatiwQZybP+oI7lINkZqFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bouke Sybren Haarsma <boukehaarsma23@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 011/121] drm: panel-orientation-quirks: Add quirk for Ayn Loki Zero
Date: Mon, 16 Sep 2024 13:43:05 +0200
Message-ID: <20240916114229.300719362@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bouke Sybren Haarsma <boukehaarsma23@gmail.com>

[ Upstream commit b86aa4140f6a8f01f35bfb05af60e01a55b48803 ]

Add quirk orientation for the Ayn Loki Zero.

This also has been tested/used by the JELOS team.

Signed-off-by: Bouke Sybren Haarsma <boukehaarsma23@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240728124731.168452-2-boukehaarsma23@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 903f4bfea7e8..40473c705562 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -208,6 +208,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_MATCH(DMI_BOARD_NAME, "KUN"),
 		},
 		.driver_data = (void *)&lcd1600x2560_rightside_up,
+	}, {	/* AYN Loki Zero */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ayn"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Loki Zero"),
+		},
+		.driver_data = (void *)&lcd1080x1920_leftside_up,
 	}, {	/* Chuwi HiBook (CWI514) */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hampoo"),
-- 
2.43.0



