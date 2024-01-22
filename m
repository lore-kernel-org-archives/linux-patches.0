Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A423E129A63;
	Tue, 23 Jan 2024 00:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968742; cv=none; b=sX0zP/ng8WpCbky4YRaURKyvtl+IUO5fRIuF1w65XAqzEVPRI/2L/dPwF2F1Hu9SumA3IAz9VEfWb/IX6kBw++J1iLJfrqPJ1Yg+y+liv2LYptI6WSe/VmnRQ9N3tHNaTzmIK3iDfOML2Hx/KnbaJigoFDsy2uTUmtwouHEH4zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968742; c=relaxed/simple;
	bh=gpTSv8LbrzdzY/h8W3HZdzmLdmHFQg3aoSfoDFrUeek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSLLda65m7C+SfhxabgNPPNhtlai0jkxkMRfH+IRmff50Aj7RI7zENMVXac1wG0SX47xV8l8279DXjabKkG9OX0ava1fqkDA2te5/BJ1mGcYCgC/pUJiv/P5y9Yfc8rKufSEDlH3xg8nhlu48hVcdpxkOyjJEcDelQswXOIVpdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vY9sZ1Kc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vY9sZ1Kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC078C433F1;
	Tue, 23 Jan 2024 00:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968742;
	bh=gpTSv8LbrzdzY/h8W3HZdzmLdmHFQg3aoSfoDFrUeek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vY9sZ1Kcez+8KItY7Sin8iSF9Tg9LzDklc4hgdEaZViyosqmdKH0RsVuicdzs/tIN
	 INo1kDI3rv70NULEaBW4HU9p60rAR8N9vxHZh5SKSWGlAHVEYYC8dQtT3Qq8kl9rZQ
	 lB07ZjRYQzqDOUSuJHuco8rMydufJWJH+54b9wkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esther Shimanovich <eshimanovich@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/194] Input: i8042 - add nomux quirk for Acer P459-G2-M
Date: Mon, 22 Jan 2024 15:55:55 -0800
Message-ID: <20240122235720.304250187@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esther Shimanovich <eshimanovich@chromium.org>

[ Upstream commit 335fe00319e030d481a54d5e0e68d50c5e672c0e ]

After the laptop lid is opened, and the device resumes from S3 deep
sleep, if the user presses a keyboard key while the screen is still black,
the mouse and keyboard become unusable.

Enabling this quirk prevents this behavior from occurring.

Signed-off-by: Esther Shimanovich <eshimanovich@chromium.org>
Link: https://lore.kernel.org/r/20231130195615.v2.1.Ibe78a9df97ecd18dc227a5cff67d3029631d9c11@changeid
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 5df6eef18228..1ab7f27bc906 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -351,6 +351,14 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		},
 		.driver_data = (void *)(SERIO_QUIRK_DRITEK)
 	},
+	{
+		/* Acer TravelMate P459-G2-M */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate P459-G2-M"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
 	{
 		/* Amoi M636/A737 */
 		.matches = {
-- 
2.43.0



