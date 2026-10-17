Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CC53587DE;
	Sat, 17 Oct 2026 17:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257159; cv=none; b=krXIvPjt2udOzp13HRyemp/P9HgCrAD7hjoWfD8KijfxS9ZriJ9kkYtR0MftEoT0Qnj82RsXMZ5+NofJKruoqtX76pSxxm8t3DWKqMq7ltx8kuJZ0u8PMwPekTQJKeLvX8/wjNfB60XlrKqAzfh8UfRmEO9A7NbHLq2+jMIV3zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257159; c=relaxed/simple;
	bh=Nw21+9G+0V639kob+wSOA5iYPuK78f/XHRPOfcRcuQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UW+fAXFW9isXJRq35+t4/U/WQEXuhpFrczXQSFc+X5p9AUZSRzplOjqjYaBt4pNCL1e7LGl5a61LSPjA18Q/5BUrW8XptCc1B1I8qKFKhjdk3kfDbjPCQ6ETL9S5Si6+C/aTpI4kUcoFZT+187tTl/nErcae+tLNr8i/V6EfZrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYUqOOGI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYUqOOGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D618F1F000C4;
	Sat, 17 Oct 2026 17:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257158;
	bh=v20kWHLeQ3QJUHhwLlbeZ6LrPAoFY6Hudsl+MwdJOVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYUqOOGIvFgSSLn2RdMOem8072XISpuDiA18PyqU4DVzGPJIEf/jXF1ENdJ3bCCh2
	 ejScix71XUgMJ1YSRPlSeMXER1sprbm3f3YsH1XiMYEl/yiDEgiLyTLZVxgip969iu
	 veSAH9SbOCx9UJSlH7jZCBRvrA7Im/GvM9wpdQ0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Garland <minimelkav@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0469/1674] ASoC: amd: yc: Add DMI quirk for Acer Aspire Go 15 (AG15-21P)
Date: Sat, 17 Oct 2026 17:45:41 +0200
Message-ID: <20261017160443.154701081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Garland <minimelkav@gmail.com>

commit d0cb7a7b2a490c381ad97f53155d02a748b60dea upstream.

The Acer Aspire Go 15 (AG15-21P, board MDC Herbag2_MDU) has two PDM
DMICs connected to the ACP. The BIOS does not set the AcpDmicConnected
_DSD property, so the acp6x machine driver never registers the DMIC
card. The existing Herbag_MDU entry does not match this board name, so
add a DMI quirk for it.

Tested on BIOS V1.11: the acp6x DMIC capture device is registered and
records audio on both channels.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Garland <minimelkav@gmail.com>
Link: https://patch.msgid.link/20261005-acp6x-herbag2-quirk-v1-1-a1f2683d758f@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -699,6 +699,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "MDC"),
+			DMI_MATCH(DMI_BOARD_NAME, "Herbag2_MDU"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "System76"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "pang12"),
 		}


