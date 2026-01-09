Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E9A32FA3D;
	Fri,  9 Jan 2026 11:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959442; cv=none; b=KOYbEBfRq4/KAtT5FKyU6MW6ri89clCh7o3gJ1DeB6lT/zjqaqAdlyblRMIOwtEuBLkIEMO5aPtRSUPhHUK6k+sqhDQVpFX5jOH7v7ksp6cIeWFk0BqqiEL/Oxee6etL8qKueK4ZNwAOsmk8MLw1ORV3oO7wTOch8C6gK8mnNrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959442; c=relaxed/simple;
	bh=eDYBQC88p1f6hgo9yGGgHjDsALo5+Cqw9P+uKXmgoB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X0cHmSS7GWucI1ojZxYkVFiFYUTtjoX1kZtrJKXXhTGflXRqKBijP/t9oUhSgQ+Ox3tGLcVXRZrnbrUX3tAWwbsKGRW7MH7dYh4gxMcvQJQpRjf5khD38Hb8sETFZ/KPQjgl1qc8oZjxXj98NWIlwbMrE5J586vT/67x5dxIicY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPjvUSkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPjvUSkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C583C4CEF1;
	Fri,  9 Jan 2026 11:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959442;
	bh=eDYBQC88p1f6hgo9yGGgHjDsALo5+Cqw9P+uKXmgoB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPjvUSkxLFIpxbqQMcTy8AcEuZNBcQy3pnR6BqN8ZiHjpPGIEc4l7kYuvEyqnI0FH
	 KVQc3hw4itQ/C8/mD4V3bxGqIq2mYstBWfSAAKFpQEfs3ivdOLEh+kFgyHXftIe9gY
	 91A2k7wzi7uE2240HQM102JakKyagsynmRHaGuMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/737] platform/x86/amd/pmc: Add spurious_8042 to Xbox Ally
Date: Fri,  9 Jan 2026 12:32:55 +0100
Message-ID: <20260109112135.354191417@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit c0ddc54016636dd8dedfaf1a3b482a95058e1db2 ]

The Xbox Ally features a Van Gogh SoC that has spurious interrupts
during resume. We get the following logs:

atkbd_receive_byte: 20 callbacks suppressed
atkbd serio0: Spurious ACK on isa0060/serio0. Some program might be trying to access hardware directly.

So, add the spurious_8042 quirk for it. It does not have a keyboard, so
this does not result in any functional loss.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4659
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20251024152152.3981721-3-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 271cbeaa59af3..a5031339dac8c 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -116,6 +116,14 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21A1"),
 		}
 	},
+	{
+		.ident = "ROG Xbox Ally RC73YA",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "RC73YA"),
+		}
+	},
 	/* https://bugzilla.kernel.org/show_bug.cgi?id=218024 */
 	{
 		.ident = "V14 G4 AMN",
-- 
2.51.0



