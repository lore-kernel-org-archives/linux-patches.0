Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB7835C1B4;
	Wed,  8 Apr 2026 19:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674814; cv=none; b=hkRbIr5aegXynFBAUOcLoCWb1Eg1ztvm57CZ80CXGtiKZzSeoe1RbAazBrXLeeqJAgVEE3zFV1BNsrwfktk0JfKL87hJU9zfcliwc5Spt6DiaYa7MWkzWjekL9/Pv0JgSYvqbG6WiZoRnHj9a10pg4aRL2VDzW96gpLcuT4Epgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674814; c=relaxed/simple;
	bh=vpBxsaKq2j4fPGiyD7rePcSWM4LNPUY3NyYtLWOJ4NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQRP0cuHYG5J8w4DsD6V96eFL52AkQIboX7Ck6ZBxP5u+LFAq7cE98tobuBTZdbvT4igFTyjdt573JK5U1rdoDWSISZ0lWND5XLTX6iJBque8R8MR3OR5iGdkBXDube2UcmAN5HnR9I2xaZTz74diqOVDsUs/OoFhd2lX8l/95E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mObdDmET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mObdDmET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742A5C19421;
	Wed,  8 Apr 2026 19:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674814;
	bh=vpBxsaKq2j4fPGiyD7rePcSWM4LNPUY3NyYtLWOJ4NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mObdDmETRzLUb476t1+F35giOQywUlUiiZxV96jsGt8q9oLX/jDT0TRU3k3ndVQYe
	 cXeca3A8sLQv+gJUBjjNZLEcxVBgqSzHr3N+wstLkZFdP7/1OcfyqcZGfWgMygYJ8O
	 WwwLJl57nUBoG6DeniyV6BE1DG0pF2A1gdxlq28k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.19 211/311] Input: i8042 - add TUXEDO InfinityBook Max 16 Gen10 AMD to i8042 quirk table
Date: Wed,  8 Apr 2026 20:03:31 +0200
Message-ID: <20260408175947.281975415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit 5839419cffc7788a356428d321e3ec18055c0286 upstream.

The device occasionally wakes up from suspend with missing input on the
internal keyboard and the following suspend attempt results in an instant
wake-up. The quirks fix both issues for this device.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260223142054.50310-1-wse@tuxedocomputers.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1189,6 +1189,13 @@ static const struct dmi_system_id i8042_
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "X6KK45xU_X6SP45xU"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "WUJIE Series-X5SP4NAG"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |


