Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A218425745F;
	Tue, 25 Mar 2025 12:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905691; cv=none; b=OFLMA3JWsBjCdX/BHxSbf1LkPkFD6mayH5uLy8zSpiLdIBc2xF9UUtn545oPFcPfFq5oTSYj4ozUwQftKt1rfCe1BPKn5PjdymsQ9R0+2eAiu9hicielZZ5/YGJ1/XDlH2rstRSRO+jon+aeRU8F0N/TPDgCULho9pj6XWJeYBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905691; c=relaxed/simple;
	bh=92MKGCSZTxCNA9o8/WwA8OsmUSYKi6/cQGgV+NqUO28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pE9D/MZmRlmv8amxBf761Q74Y7U55+59Q83mhsVn9lSvKBaZbHEorhl1WQY3KzBk6zLQHrKXlSVIBygALILKy8/LeBguzcZ1dPpixZFmVuVyMiokbZU1ebXrU4+BoAPj6igYF5QQ8CFU/BbL+qLDYxLl2euFZXsln4Bx1qR28TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8I3lOA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8I3lOA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52883C4CEE4;
	Tue, 25 Mar 2025 12:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905691;
	bh=92MKGCSZTxCNA9o8/WwA8OsmUSYKi6/cQGgV+NqUO28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8I3lOA7ha7Zthi+Sy16JrslL7Sxx7pg4bWRVT+SdyKdpCrbPx1IlLQaw1FFNn8FP
	 9UD5VtbQzY2SeL4+9XqYfzv5dpbWxze7lfH8YWO26wJvROmre0Kc3A3jaGYABo5EAW
	 jF5jmNSYUXrs3QZNxUZ3K0hiSybLhitEIiV/93OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 104/198] Input: i8042 - swap old quirk combination with new quirk for NHxxRZQ
Date: Tue, 25 Mar 2025 08:21:06 -0400
Message-ID: <20250325122159.383610909@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 729d163232971672d0f41b93c02092fb91f0e758 upstream.

Some older Clevo barebones have problems like no or laggy keyboard after
resume or boot which can be fixed with the SERIO_QUIRK_FORCENORESTORE
quirk.

With the old i8042 quirks this devices keyboard is sometimes laggy after
resume. With the new quirk this issue doesn't happen.

Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://lore.kernel.org/r/20250221230137.70292-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1209,18 +1209,10 @@ static const struct dmi_system_id i8042_
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/*
-		 * Setting SERIO_QUIRK_NOMUX or SERIO_QUIRK_RESET_ALWAYS makes
-		 * the keyboard very laggy for ~5 seconds after boot and
-		 * sometimes also after resume.
-		 * However both are required for the keyboard to not fail
-		 * completely sometimes after boot or resume.
-		 */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "NHxxRZQ"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {


