Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E463134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EA7C4339E;
	Mon, 12 Jun 2023 10:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566748;
	bh=PSdixpSoLxZr3MErKo1fFILJcOYY6UhEHggkjqKoJjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uD3ZTyelm2lwJmXfRutBTlSqYjnTsCZH5GhR6MLJaliVpGsJikYyaDsOoLHVDUazo
	 iePJaLqPuIwoAJ4gBsorcxC0BJRHyNyoLJI07zD+nFdYgamEi4UFslzbjb4lXPl/iM
	 3gtM3pFweX+F3F0TBFT2lokV9yJ1BDzcONwsSSGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 003/160] platform/surface: aggregator_tabletsw: Add support for book mode in KIP subsystem
Date: Mon, 12 Jun 2023 12:25:35 +0200
Message-ID: <20230612101715.285470391@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 9bed667033e66083d363a11e9414ad401ecc242c ]

Devices with a type-cover have an additional "book" mode, deactivating
type-cover input and turning off its backlight. This is currently
unsupported, leading to the warning

  surface_aggregator_tablet_mode_switch 01:0e:01:00:01: unknown KIP cover state: 6

Therefore, add support for this state and map it to enable tablet-mode.

Fixes: 9f794056db5b ("platform/surface: Add KIP/POS tablet-mode switch driver")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20230525213218.2797480-2-luzmaximilian@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_aggregator_tabletsw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/surface/surface_aggregator_tabletsw.c b/drivers/platform/surface/surface_aggregator_tabletsw.c
index 9fed800c7cc09..a18e9fc7896b3 100644
--- a/drivers/platform/surface/surface_aggregator_tabletsw.c
+++ b/drivers/platform/surface/surface_aggregator_tabletsw.c
@@ -201,6 +201,7 @@ enum ssam_kip_cover_state {
 	SSAM_KIP_COVER_STATE_LAPTOP        = 0x03,
 	SSAM_KIP_COVER_STATE_FOLDED_CANVAS = 0x04,
 	SSAM_KIP_COVER_STATE_FOLDED_BACK   = 0x05,
+	SSAM_KIP_COVER_STATE_BOOK          = 0x06,
 };
 
 static const char *ssam_kip_cover_state_name(struct ssam_tablet_sw *sw, u32 state)
@@ -221,6 +222,9 @@ static const char *ssam_kip_cover_state_name(struct ssam_tablet_sw *sw, u32 stat
 	case SSAM_KIP_COVER_STATE_FOLDED_BACK:
 		return "folded-back";
 
+	case SSAM_KIP_COVER_STATE_BOOK:
+		return "book";
+
 	default:
 		dev_warn(&sw->sdev->dev, "unknown KIP cover state: %u\n", state);
 		return "<unknown>";
@@ -233,6 +237,7 @@ static bool ssam_kip_cover_state_is_tablet_mode(struct ssam_tablet_sw *sw, u32 s
 	case SSAM_KIP_COVER_STATE_DISCONNECTED:
 	case SSAM_KIP_COVER_STATE_FOLDED_CANVAS:
 	case SSAM_KIP_COVER_STATE_FOLDED_BACK:
+	case SSAM_KIP_COVER_STATE_BOOK:
 		return true;
 
 	case SSAM_KIP_COVER_STATE_CLOSED:
-- 
2.39.2



