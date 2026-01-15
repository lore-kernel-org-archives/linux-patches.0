Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E143C1988;
	Thu, 15 Jan 2026 17:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498010; cv=none; b=hcbWKuqzYUOkgkh8ZM/GqBheyfgYuiOOmU1CnwDMAYQyCQqZUrsFIJ/N6z+K3gIOAxVOsQYqI40EvwesqYZS9k10luxjz7Jsvmvq+8Zqsh5rSFn8jt/c5Ltj89gmDT7qtSKfMUfKRyzHr24DkMh0ClDqpRDNnahiyMqhrl9kr9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498010; c=relaxed/simple;
	bh=EA7piO6ZovgTOs0buPEJRh8xLuv4/oAxV3IwhGJZNuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiXGEopS+c2JrPZgPK6ahDnrQj0BtepT10lgMjCrlHxOD0ya4tahJ1JnYmLvVq1KT9ZJqSTyxbHcmS9rVL3hrNpux9G9QjJdAgy4Kt0Czy576zrrQQas91a6WQc3OjGmmyZ+Jzavf/hLbIX/YZIE6pOaGRQw0X2Zg81EH60cWk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tl1vLMIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tl1vLMIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D372C19423;
	Thu, 15 Jan 2026 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498010;
	bh=EA7piO6ZovgTOs0buPEJRh8xLuv4/oAxV3IwhGJZNuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tl1vLMImkwBCd2AbgRuhTur1fj/J5X7gf1jNs7JjGDWyXS69xfkvlMugCG3QihRqI
	 K5ktAKY94ZKgDcw0FFT9n7XCcAW2ZxELcESPhdovdORB6XxBEM0gHUW1rnicr0q+XJ
	 c/WjzK1qCK5oRUg3/jFixVMZXT0ZZxjK+28B6ITI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 248/554] Input: i8042 - add TUXEDO InfinityBook Max Gen10 AMD to i8042 quirk table
Date: Thu, 15 Jan 2026 17:45:14 +0100
Message-ID: <20260115164255.215957117@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit aed3716db7fff74919cc5775ca3a80c8bb246489 upstream.

The device occasionally wakes up from suspend with missing input on the
internal keyboard and the following suspend attempt results in an instant
wake-up. The quirks fix both issues for this device.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251124203336.64072-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1161,6 +1161,13 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "X5KK45xS_X5SP45xS"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with nomux + reset + noloop + nopnp. Luckily,


