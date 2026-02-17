Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1736D2773E4;
	Tue, 17 Feb 2026 20:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361436; cv=none; b=qTJb/932/7ElkpuaZmluC5MNWLeAbaOxBMmWqIv3A37hX/vrMgJrkDGgBCjxLkNyGLCyTNRpSqsFbvqz41pFjptjxamxy1VkoUVR1bD8K7FgJg6vYOlcVB4y8MOZ4j78LkIGOxKGaAxaXt4/uvXrODEwx+yED1O3ZLWWY2F1Thk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361436; c=relaxed/simple;
	bh=VCFLAjVU8ReP+O/vY570Xg8i51ypQdjhf3EvcWFolF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dxy3EEpVRzERjHWrZr6WLWtahx6UPugyU3OiAIi5G6mu5jsqDNBjXVflkZABEXfYcAK3o1hWdTf1VtkHhBN14sRUADKxH9FOM+dxt7Sb6den3vhG20P/3uiYvds3Tsvy4hyZIbgcajy5M8LExvdzMiSKQZOgb7XOh66NKKTZl7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULpB3Ypt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULpB3Ypt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D64CC4CEF7;
	Tue, 17 Feb 2026 20:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361435;
	bh=VCFLAjVU8ReP+O/vY570Xg8i51ypQdjhf3EvcWFolF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULpB3YptIK30LhCicmGEtOvexLQ8pDnLojXMQk/rhuJb0jExHEHWVQP16TKPTAHWp
	 dKdasuh5KAKihSrW+93+5xYnPK0JhqKmLjwDrcbb0hkmQsRIthrmuxhSb9STAxLWav
	 tMnFzELFTs56czS3dSRDPoGnwuo1zvOa6U6ixowo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gongqi <550230171hxy@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 16/43] platform/x86/amd/pmc: Add quirk for MECHREVO Wujie 15X Pro
Date: Tue, 17 Feb 2026 21:31:56 +0100
Message-ID: <20260217200007.091343851@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gongqi <550230171hxy@gmail.com>

[ Upstream commit 2b4e00d8e70ca8736fda82447be6a4e323c6d1f5 ]

The MECHREVO Wujie 15X Pro suffers from spurious IRQ issues related to
the AMD PMC. Add it to the quirk list to use the spurious_8042 fix.

Signed-off-by: gongqi <550230171hxy@gmail.com>
Link: https://patch.msgid.link/20260122155501.376199-4-550230171hxy@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 404e62ad293a9..ed285afaf9b0d 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -302,6 +302,13 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "XxKK4NAx_XxSP4NAx"),
 		}
 	},
+	{
+		.ident = "MECHREVO Wujie 15X Pro",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "WUJIE Series-X5SP4NAG"),
+		}
+	},
 	{}
 };
 
-- 
2.51.0



