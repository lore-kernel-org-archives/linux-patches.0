Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D61563B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9365CC433EF;
	Mon, 20 Feb 2023 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900416;
	bh=IaVt5b25gIrCUtj8xEAjg82lbocUKKdnMK8t1dnvfl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToyXxm8/R9XfxF0XCgDMdGXHwLoEEcpjX22ebIc5aVxXA3ZNLygHQbu2VqRfKs4lA
	 qRiBbKBT8W3oelV2FSfh9AMWzkYwgMnTJdu3P3Uj9mhMwh2okoLtPK7Hl7445MmYnl
	 mhmnxYdbjqITF48LM2sQRNzZhDwIlm0MwBhThuNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/89] Input: i8042 - move __initconst to fix code styling warning
Date: Mon, 20 Feb 2023 14:35:16 +0100
Message-Id: <20230220133553.736348270@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Werner Sembach <wse@tuxedocomputers.com>

[ Upstream commit 95a9916c909f0b1d95e24b4232b4bc38ff755415 ]

Move __intconst from before i8042_dmi_laptop_table[] to after it for
consistent code styling.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220629112725.12922-2-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 9c445d2637c9 ("Input: i8042 - add Clevo PCX0DX to i8042 quirk table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index ee0b0a7237ad..27405c8d850a 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -795,7 +795,7 @@ static const struct dmi_system_id __initconst i8042_dmi_nopnp_table[] = {
 	{ }
 };
 
-static const struct dmi_system_id __initconst i8042_dmi_laptop_table[] = {
+static const struct dmi_system_id i8042_dmi_laptop_table[] __initconst = {
 	{
 		.matches = {
 			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
-- 
2.39.0



