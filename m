Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3518B26296;
	Mon, 14 Oct 2024 15:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918465; cv=none; b=ZpE+8WbshhREPWpjgTnp2ZSQ2pXkVfD9zS+jfASMcaWIUhQ3frPVTYau638RQTSVtRJ7ntx/gv/4fy8nWVbJnhopVDAvka1kimW+/I864aYjvy2y9sT5smhrNMBBgpp3e3hsC1BkEjZIlwATlEkE45kEI3EsKVDKrpa8JGc8GEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918465; c=relaxed/simple;
	bh=sEcXxmyQARUNOaT3EoptZnb+d/Pd4cvAsCui8oDySlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieYPqTlysdFU/pCIbK1RH1xnutlSr0WpOb1DALb4zPn3Stb1uT7zJriAYUB0wCnjhc0swBu4HC2lvaSJmigrmQVQ2tounYl0g4ro1dCf1DyTbsHALv/lx8/4Hq6Sz4Zvpew+p9kyUnu30YVDz+m0Yt1FhyOPPxT9QoG5fENLTm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijDO2uei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijDO2uei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A813C4CEC3;
	Mon, 14 Oct 2024 15:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918465;
	bh=sEcXxmyQARUNOaT3EoptZnb+d/Pd4cvAsCui8oDySlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijDO2ueimhelALijKzpLQMwLVNVAB/hwNAoCh98mKRe3icRpin2P5X+L0y40ewuwT
	 FxN1livJKYzRxC7jlY50pX1fJtJFkiktkMUIrqjzJmmru8YFtxjjSY2WAV7qn1ocEk
	 vApPxXn6OpWk5HFpXB3sJTDqoIAE5IDLgbUubewo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 290/798] Input: i8042 - add another board name for TUXEDO Stellaris Gen5 AMD line
Date: Mon, 14 Oct 2024 16:14:04 +0200
Message-ID: <20241014141229.337411289@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit 01eed86d50af9fab27d876fd677b86259ebe9de3 upstream.

There might be devices out in the wild where the board name is GMxXGxx
instead of GMxXGxX.

Adding both to be on the safe side.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240910094008.1601230-2-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1138,6 +1138,13 @@ static const struct dmi_system_id i8042_
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxx"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxX"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |


