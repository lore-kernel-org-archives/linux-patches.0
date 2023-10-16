Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2334241F8
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bjg6/ZLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB37EC433C7;
	Mon, 16 Oct 2023 14:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697466276;
	bh=7GucFv4ZVS5fCm3Pt9Uu8dOkjKvDy94tficb1jso9bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bjg6/ZLyeu+TD+X8Q/rsd48Zdg1Qc4hBqvrtdcO7KwCabcX2XxRrXDCYknc00H71O
	 FsrL43OacfBbljOPjLH15g6KpLHfCEXcxIQiWQe7Skg3bCj9bJoVi6hPDJRzxoF22p
	 Iz/MCeNm77+foqH9u34o/PMPATq7g1vBXizf6xVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Frotscher <sven.frotscher@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.5 019/191] ASoC: amd: yc: Fix non-functional mic on Lenovo 82YM
Date: Mon, 16 Oct 2023 10:40:04 +0200
Message-ID: <20231016084015.850933469@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Frotscher <sven.frotscher@gmail.com>

commit 1948fa64727685ac3f6584755212e2e738b6b051 upstream.

Like the Lenovo 82TL, 82V2, 82QF and 82UG, the 82YM (Yoga 7 14ARP8)
requires an entry in the quirk list to enable the internal microphone.
The latter two received similar fixes in commit 1263cc0f414d
("ASoC: amd: yc: Fix non-functional mic on Lenovo 82QF and 82UG").

Fixes: c008323fe361 ("ASoC: amd: yc: Fix a non-functional mic on Lenovo 82SJ")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Frotscher <sven.frotscher@gmail.com>
Link: https://lore.kernel.org/r/20230927223758.18870-1-sven.frotscher@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -238,6 +238,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82YM"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82UG"),
 		}
 	},


