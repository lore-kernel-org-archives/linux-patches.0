Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2B21D1E8A;
	Wed,  2 Oct 2024 14:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880290; cv=none; b=cEMKgGFj1KUynkfdlM+LK+1fokFwgwXWx6W7HcHJpHAa7ZlpseVc6vZbzedQiSNb9PiZ1bz535MDEKGGrRaDedKsQ1yMj5qwfM4Abci6dd1Eo07cwj2cJjYk5FDneDf/S6SoVaVQ1RglTc09CyxvjztvIm4l39+ppc/copyxblY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880290; c=relaxed/simple;
	bh=Jd7UUMbQgjD6ybpBQHrNmAQJubenuSn79a1DbZE7+IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3ncg7/PeIcpJvExBvO8gylEuSW8XfzhnZODwGkelToJFBdCQe3pbLbFhW9qPQuJKWWVyxb//my5klKsjcvdUiXK9Q2wq0eKpkf3VgFTod8vsaS5NP7TnTpXDz4Yzed8JaqMBign8Iinkgv5n/NEz2tQmyRmZmlQdYQ8bc4TmEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKFkIMXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKFkIMXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3836C4CECD;
	Wed,  2 Oct 2024 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880290;
	bh=Jd7UUMbQgjD6ybpBQHrNmAQJubenuSn79a1DbZE7+IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKFkIMXcDW/VNgL1WU8nTfdYy7i6AF4csBYY8K7QrhY0+804dLoa1odczkmJH763B
	 c7ByxlXxMaQRrf/xPV8Fatk95/e2+qYcx0fBnKen2VLAznr2w7H4URoTlHzJ5rEAns
	 mnsvpz8lWRlXm3L+Oo9HOAPW84XZPKRLKhbIfJe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 409/538] Input: i8042 - add another board name for TUXEDO Stellaris Gen5 AMD line
Date: Wed,  2 Oct 2024 15:00:48 +0200
Message-ID: <20241002125808.579110214@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


