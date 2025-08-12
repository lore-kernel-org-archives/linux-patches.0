Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89799305E08;
	Tue, 12 Aug 2025 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021944; cv=none; b=l32QRmJAh2ImnM2U4J8YI4J15bg4WhWorOSUwvNM/JuUHWrG+HtcUOm/HjqzQFAiBx3IE5KumCy8YcA1Nan+3MoJ0N0L9PqhnUZ/bCmkRPurREKVQ7jhztfXzJwuwpKw5F5F/J5jhXOyeTv9sS6Kur7SpleS410f8wLvv9Nu5XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021944; c=relaxed/simple;
	bh=51wXK7BH7TcZVxDiht6OSr+AzCVcoSHpIn0vj6N5dgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqHwqem4fbglrG3nPD9nCaF3ybEkzglWTCllTTA/d8eVXtC95rqDVLqK20bLXZKZy06jZOgFqBSes134yjAUdcFJRmdcLdp/5zsvmHz1nq8kw+iqL+JeV09Oroh7hBk1lTLIdpRHl3fxP4lK/AAUbpaqR4BzVbisJwmnqYP+VUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=um5saUXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="um5saUXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFFEC4CEF8;
	Tue, 12 Aug 2025 18:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021944;
	bh=51wXK7BH7TcZVxDiht6OSr+AzCVcoSHpIn0vj6N5dgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=um5saUXmUy3Lle+ojLjdHbyX5132pjmffJXzHnEdOLIlQ2/gNbeWYQGNJOr0XE4bn
	 TFPKRVsb5sze2XM41UNKbuedeq5cVMsBAc9f+IK00e/90C+W1AABIZbpzoO+E0/cyQ
	 k0R2mWeJPV80pWr4TStLljKMvndXECHFM5VbRYXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lane Odenbach <laodenbach@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/369] ASoC: amd: yc: Add DMI quirk for HP Laptop 17 cp-2033dx
Date: Tue, 12 Aug 2025 19:24:58 +0200
Message-ID: <20250812173014.796557202@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lane Odenbach <laodenbach@gmail.com>

[ Upstream commit 7bab1bd9fdf15b9fa7e6a4b0151deab93df3c80d ]

This fixes the internal microphone in the stated device

Signed-off-by: Lane Odenbach <laodenbach@gmail.com>
Link: https://patch.msgid.link/20250715182038.10048-1-laodenbach@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1689b6b22598..42d123cb8b4c 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -577,6 +577,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A7F"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A81"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



