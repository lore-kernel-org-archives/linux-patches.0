Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DE419AA40;
	Tue, 16 Jul 2024 15:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144631; cv=none; b=YU58XqQ0oMq7IyiCuBPse0WNM2M10+sUWpWykDWfgyKi17c4uNrX/sXIRgj4A5RrT5X90YuRxMMkwDrJbyfHl66WT6QGvVmxA2xkhteUFb3CsDzOc9ZpxpUvIJ7lqhMh9o0Ixkig6wRzWgxyZymCyJjviBlvvKAO5CRe3DXQXMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144631; c=relaxed/simple;
	bh=pDcYJXfRt8tcCEsMtGiXkjqfSbr/xiALyXPnI9zGWqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrwBa2kJ4wW/hdLK/mh5Lmw5A/shIVu99Ea8aBqZZUBMueiSTkFDBbzwdJ1gPMvswPPzg4TprvbBl9R+dYUzpVBNSPZ2y64ah8urn+F7ZXvzQf/6L5lmGdebguhHxXwPGf2dyY1KgS9VKbkHJrzOQcxvBIGU77zjF/x0JrK9xY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0PUeAyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0PUeAyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A397C116B1;
	Tue, 16 Jul 2024 15:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144630;
	bh=pDcYJXfRt8tcCEsMtGiXkjqfSbr/xiALyXPnI9zGWqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0PUeAyXni0LpOw4NxbslzI0L+9VGuZOyn0skRg8wUUerg5cXiMm1Xs+8fsVB5UfL
	 6XLHfpg4T92GEpYN8t4HsMjdBi0MKWB4D+oyFlIjRl2MFk+kPzz6aMFi/DPpgjimcn
	 rruvvZFTYKfVIjhuKvbqx/AANa6+b3HmOhahULo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hmtheboy154 <buingoc67@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/108] platform/x86: touchscreen_dmi: Add info for the EZpad 6s Pro
Date: Tue, 16 Jul 2024 17:31:09 +0200
Message-ID: <20240716152748.061440306@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hmtheboy154 <buingoc67@gmail.com>

[ Upstream commit 3050052613790e75b5e4a8536930426b0a8b0774 ]

The "EZpad 6s Pro" uses the same touchscreen as the "EZpad 6 Pro B",
unlike the "Ezpad 6 Pro" which has its own touchscreen.

Signed-off-by: hmtheboy154 <buingoc67@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240527091447.248849-3-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 8cb07f0166c26..dce2d26b1d0fc 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1277,6 +1277,17 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_DATE, "04/24/2018"),
 		},
 	},
+	{
+		/* Jumper EZpad 6s Pro */
+		.driver_data = (void *)&jumper_ezpad_6_pro_b_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Jumper"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Ezpad"),
+			/* Above matches are too generic, add bios match */
+			DMI_MATCH(DMI_BIOS_VERSION, "E.WSA116_8.E1.042.bin"),
+			DMI_MATCH(DMI_BIOS_DATE, "01/08/2020"),
+		},
+	},
 	{
 		/* Jumper EZpad 6 m4 */
 		.driver_data = (void *)&jumper_ezpad_6_m4_data,
-- 
2.43.0



