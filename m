Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AFC3E3C40;
	Tue, 31 Mar 2026 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974773; cv=none; b=SCsfttywNvrjIUi/ADnh+spG0nHJ8CSP+vXRuAx+82Wkwok1Q4bmh5HmmuPIrMUrys8e9zOIB/tLKE7uqWegYrgU6rUsdyBKag3Fc1MLltliDxtW1YENsxH6Q8CuKytL3OGvdceF4An7Z+wN8wJ/ydcW3Smq12c6xhutViwPitI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974773; c=relaxed/simple;
	bh=AAZQqDAPRqxhISvab/YLXTwZsWQOrV7a7ADs+l5Qc6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WFP5IcAanhK/RWExLYSkdZKUDiIeyVO81epmcG5+3yDy9thnlDKhstyn8AWVS5mG7bS57+JvvYgrHl0be2ZWEcORKoYkkVU0TKpXSk0Tko73PRLRgfufYOdipnp6zeVQj5xhdZio68F0JsagSVaDKSK8iEVK+NuFo6QCSjmoqS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mweK52y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mweK52y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F17C19423;
	Tue, 31 Mar 2026 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974773;
	bh=AAZQqDAPRqxhISvab/YLXTwZsWQOrV7a7ADs+l5Qc6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mweK52y5W1dbZ9ylkOLbIQAgEwr4fls50fnNV8qTgjm/8Us2Pv8IoryszFZtRBlLO
	 5pQNzQqHpvDNc+WwUBT9EFqeTvTcH053NsZuPVFlLtyyD1JxZMKdT+lIQ/6BE63AqV
	 NhkfxVOCzUe4OtFIGjH60mx/mcwonaUX05lp50Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 038/342] platform/x86: oxpec: Add support for OneXPlayer X1z
Date: Tue, 31 Mar 2026 18:17:51 +0200
Message-ID: <20260331161800.306105330@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 4049c46edb5d44c0de045f6f504371705dd603dd ]

X1z is a variant of OneXPlayer X1 A with 8840U. It seems that only one
user has this one. Add a quirk for it to the oxpec driver.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260223183004.2696892-3-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/oxpec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index 59d6f9d9a9052..623d9a452c469 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -219,6 +219,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)oxp_mini_amd_pro,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER X1z"),
+		},
+		.driver_data = (void *)oxp_x1,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
-- 
2.51.0



