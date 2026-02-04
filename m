Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2C422E3F0;
	Wed,  4 Feb 2026 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219107; cv=none; b=pQFACbLx/Btu50wwsjnOtH4I5o4t2InvclcLceHD+0e/vwF2jNkAXjlDKoEHjm9Tx0RR+0MIjoP+z0gdNmQuqnqUgTzglVBrPUf6W/x1moXSnrzkW24zPJagXQX2CVFBz1pRP1JBBppwOWnp42qdkKmAtBNOYoeTb5dybq9gZck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219107; c=relaxed/simple;
	bh=7mjvunwLEUX4ymE6XUjEja+Y4ruMTbCKpv3j2N/8Zik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qm6yyCs/oNtKZa1TcvyMDxZ40jazHgVi0lPVA01npK5eWWiVywFI3qIoWjMFArK6bPjbs6AkPGUVGfzZz9pCS/Cc6TxVKOX6i1+VC0akrQFghSOWJ7SQKPdpoVjJI3QfORbU3D1JUMGtkAelaYYenyeg6Eu3Qrkzs8TOerm2hUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwRuPBhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwRuPBhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3759C4CEF7;
	Wed,  4 Feb 2026 15:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219107;
	bh=7mjvunwLEUX4ymE6XUjEja+Y4ruMTbCKpv3j2N/8Zik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwRuPBhxPq5Dbq5NKEVU/3AsEXcEz5d0xlakMoS9UtMbsc9ydxjqk5xf62PlS9LfK
	 SKl5nPPscXActn/qjxAHpqHucq+AKjkHHKajmOCafx77w3Z98n27BtvwoCLX2GcI3O
	 ntYMeYcbo31dfzZhRFcAPHuvupb9MWfCxzlr23CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 070/122] ASoC: amd: yc: Add DMI quirk for Acer TravelMate P216-41-TCO
Date: Wed,  4 Feb 2026 15:40:52 +0100
Message-ID: <20260204143854.372227812@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit 9502b7df5a3c7e174f74f20324ac1fe781fc5c2d upstream.

Add a DMI quirk for the Acer TravelMate P216-41-TCO fixing the
issue where the internal microphone was not detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220983
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260126014952.3674450-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -668,6 +668,14 @@ static const struct dmi_system_id yc_acp
 			DMI_MATCH(DMI_PRODUCT_NAME, "GOH-X"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "RB"),
+			DMI_MATCH(DMI_BOARD_NAME, "XyloD5_RBU"),
+		}
+	},
+
 	{}
 };
 


