Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B823D1F7071;
	Tue,  3 Dec 2024 14:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237799; cv=none; b=twgrt4MPQvV2S3xN80vKUYpAGVjdW9jFx68iRmqk2Pv7cQujPRIXtPR2rRwaR9wRjX5cuFhLjvk9slO8DhUdX5h4gEd5559k3qE8g2DVXIygYaFEAiOxqCDpU7irTohmWJUZjxLQxIncY+MFiZrifxFloxwU9nu7s2Ui8E9RwyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237799; c=relaxed/simple;
	bh=5roS7Dkt2H1iCAUY6BsjjorPuGBaBUNP7m5p2mC0yWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpa0fkzsfgaHHIA0/xR9PbEqqPRSbOkLAGbM2x+r4e+uu+dkkDVeHJ5vWcX0vIik0cUPSB+CyKeb+KkAGWUrWgFPeoAzFqGezihrvBhYt54I+6JsiGeAJW6U4lHPL93F7rXzIhRO3UhudOz676JW2ppsmecD5XHtQgQV1XJi3ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aT5Iw6JC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aT5Iw6JC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC36EC4CECF;
	Tue,  3 Dec 2024 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237799;
	bh=5roS7Dkt2H1iCAUY6BsjjorPuGBaBUNP7m5p2mC0yWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aT5Iw6JCJurlvoc18pYBH9xpKg4rB9D3KI5E1hXlMF5NttL7ax/Utm1mTlAUpX3C8
	 xuLq+klFPQjWmV5A9rjC6+Tzm8s4vQsk3VHbiCX6vKK70ofpjc+OyXVTu88sdqbQpq
	 zV/T6Eh0wB406D40/Ch0ULSzqcGlipOwgrU5btv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Petri <mp@mpetri.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 032/817] ASoC: amd: yc: Support dmic on another model of Lenovo Thinkpad E14 Gen 6
Date: Tue,  3 Dec 2024 15:33:24 +0100
Message-ID: <20241203143956.903572213@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Petri <mp@mpetri.org>

[ Upstream commit 8c21e40e1e481f7fef6e570089e317068b972c45 ]

Another model of Thinkpad E14 Gen 6 (21M4)
needs a quirk entry for the dmic to be detected.

Signed-off-by: Markus Petri <mp@mpetri.org>
Link: https://patch.msgid.link/20241107094020.1050935-1-mp@localhost
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index dc476bfb6da40..2436e8deb2be4 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -227,6 +227,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21M3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M4"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



