Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE412F619D;
	Thu, 15 Jan 2026 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497192; cv=none; b=QqDLS4l8I3+Slec3BIuvol1IUoJHx/yLdXGgve9cRbeakEDErSlirhBHigs7UsdTsCFO8EaGnbK2YAGgNmDJh74RtYEmr1rz+n27KPuXFNE4KpQTbS4v4Ix0hLbjpuXSrkrnUQcExTp7oz2mZpZcZDOAVURqCCHk3iWhqzeFRj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497192; c=relaxed/simple;
	bh=0T/WwvwFyz+0FrmyfKN35UDrX4I+jcWCb0xYJK/nXwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nq4JkZ9f7l3/kFqYF4GXPwC9rhJq2V49Y7WxLKXr6g2bQshmmUuKk7fxkPVUYCYJl7EQMeyVz20JbpS8aYfnSJcFfDnTdJ7W3Fj6q++FC4KMpMjIfLe7ZH+g0+wk36axzQ87m2yLCvf5P7/rk3NJ+ackz5ytweE1S8Siee9jGdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmrrIVuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmrrIVuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4302C116D0;
	Thu, 15 Jan 2026 17:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497192;
	bh=0T/WwvwFyz+0FrmyfKN35UDrX4I+jcWCb0xYJK/nXwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmrrIVuDLCM6lzm1DbyK5f99qua5S7LKWFyuUHC/m4bp/L2PSMqXu/z8mfs52nPMq
	 NW/EqmX1oYD+ot7ShnM1VgsLSqJIVgAtQ4P/TZO6g+6wTe67kWdXzDgWF+Ia5Vf3wa
	 efnzZFBRp+qyX5hLPuSa4U1r5KC5dBXQ4hcNEubA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Elantsev <elantsew.andrew@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 69/72] ASoC: amd: yc: Add quirk for Honor MagicBook X16 2025
Date: Thu, 15 Jan 2026 17:49:19 +0100
Message-ID: <20260115164146.005464311@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

From: Andrew Elantsev <elantsew.andrew@gmail.com>

[ Upstream commit e2cb8ef0372665854fca6fa7b30b20dd35acffeb ]

Add a DMI quirk for the Honor MagicBook X16 2025 laptop
fixing the issue where the internal microphone was
not detected.

Signed-off-by: Andrew Elantsev <elantsew.andrew@gmail.com>
Link: https://patch.msgid.link/20251210203800.142822-1-elantsew.andrew@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index fce918a089e37..cbb2a1d1a823c 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -521,6 +521,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 C7UCX"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HONOR"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GOH-X"),
+		}
+	},
 	{}
 };
 
-- 
2.51.0



