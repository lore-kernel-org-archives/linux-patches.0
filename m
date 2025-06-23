Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF4B16D9BF;
	Mon, 23 Jun 2025 22:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717173; cv=none; b=GZ6nx7u3SLDwahrJVjGhjaNGHt4xIb5KJD0DsGEOlhyS+RmK0M8SO2xI7WvuqRHZOo10o/z+ioAzl0BBhTtx549XTeVmSkn6fwAVgMvBQg++vRUlPi+wq5Y7BkIrlv/35WwD9d5mSJ9XwVAKMjUpGC+SJed+53Kv9KJdu6gloA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717173; c=relaxed/simple;
	bh=QUY9veXfGBtoWI17IIgguIrlBu5W0EhgywDbF2GEOy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWe+Ki8Fc2CueH/2KSm9QsRHbb7Fw+QE6jw82ilk3B/IVzwEAXXOFo+jE3//q7uZNJITRU+d/uCNdcUD2KvgZZDOVfHOx1UnHc738nw7zX5mhanXy30xPbY6fYDTF4mBxOyUk+KjiMulUiwpbvZPctMz6/6dmlYzcetWJtsQOGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KD/D9SRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KD/D9SRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BEDC4CEEA;
	Mon, 23 Jun 2025 22:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717172;
	bh=QUY9veXfGBtoWI17IIgguIrlBu5W0EhgywDbF2GEOy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KD/D9SRn0my2b9LBS93KKnzoZZ9rxC+xZRZBTpib2ZOJz/IKFqwAROfsKprLjufmx
	 h0AJVDR7ln+dAIc9KiCbjmI3EtSxdFsAUn4ONgJRHyz89jMlStzIfi7mwhxvKZNhDh
	 xZdjIwKOs2YeEfP32whqA0COHf3kcidTjGZwq38A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Talhah Peerbhai <talhah.peerbhai@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 375/508] ASoC: amd: yc: Add quirk for Lenovo Yoga Pro 7 14ASP9
Date: Mon, 23 Jun 2025 15:07:00 +0200
Message-ID: <20250623130654.552840953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Talhah Peerbhai <talhah.peerbhai@gmail.com>

[ Upstream commit a28206060dc5848a1a2a15b7f6ac6223d869084d ]

Similar to many other Lenovo models with AMD chips, the Lenovo
Yoga Pro 7 14ASP9 (product name 83HN) requires a specific quirk
to ensure internal mic detection. This patch adds a quirk fixing this.

Signed-off-by: Talhah Peerbhai <talhah.peerbhai@gmail.com>
Link: https://patch.msgid.link/20250515222741.144616-1-talhah.peerbhai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1f94269e121af..d5dc1d48fca94 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -304,6 +304,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83AS"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83HN"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
@@ -353,7 +360,7 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M5402RA"),
 		}
 	},
-        {
+	{
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
2.39.5



