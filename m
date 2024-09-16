Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC8A14E2ED;
	Mon, 16 Sep 2024 11:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726487968; cv=none; b=AmVn8BM0gAWWt363Izx3i+fHfSrA9Mn+d9UTUhpDyssWtmlXpTZsQM37a87pfqSD4Gx2sESjq6qxhnuhR1d0xZWeiU8pRsXQDOOI/wC4FQiVsJ+wgndxPOW4bOtwUbIyjG92gWFUk9E2NJDVj8kg9k55OFgwxnziLMetdQIhVaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726487968; c=relaxed/simple;
	bh=+y9oaGAwVL7k1tBj7P8OfFyh1DnwNx744UH67SEYE/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AogC0QUonAT0Sg2REbjfcwvUa6WTKujonMjr5/YQrwiyKTH8vIvPlGW30HbLxj/VRTzXOy2gSF64ik7wB4oQhO9/ztJAucPw4uVecZvqoHakVkFFu5SGHHDVtqA9jk2qC2c9nyHn9D10c75wrT18VVT58Qjy89/XoW7OJ3eiD14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALA4SGxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALA4SGxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC402C4CEC7;
	Mon, 16 Sep 2024 11:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726487968;
	bh=+y9oaGAwVL7k1tBj7P8OfFyh1DnwNx744UH67SEYE/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALA4SGxYcHDzuB0WdGsNwO6kB8VhG+OIcCsS0MVUTd7OTJM9kY+lyEyaEnh9lhQdH
	 GeaFaji8mv1UQNoyK9rHimqOsS1yxf/cXW26RMydpxw4q0m/0BpxME3l7Y9OymB8xQ
	 BDCWggMdO+XwPB2ssdsCyyEUIER4nPxDaQAHJcjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bouke Sybren Haarsma <boukehaarsma23@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/63] drm: panel-orientation-quirks: Add quirk for Ayn Loki Zero
Date: Mon, 16 Sep 2024 13:43:44 +0200
Message-ID: <20240916114221.220439291@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

From: Bouke Sybren Haarsma <boukehaarsma23@gmail.com>

[ Upstream commit b86aa4140f6a8f01f35bfb05af60e01a55b48803 ]

Add quirk orientation for the Ayn Loki Zero.

This also has been tested/used by the JELOS team.

Signed-off-by: Bouke Sybren Haarsma <boukehaarsma23@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240728124731.168452-2-boukehaarsma23@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 039da0d1a613..79ccf4959df4 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -208,6 +208,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_MATCH(DMI_BOARD_NAME, "KUN"),
 		},
 		.driver_data = (void *)&lcd1600x2560_rightside_up,
+	}, {	/* AYN Loki Zero */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ayn"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Loki Zero"),
+		},
+		.driver_data = (void *)&lcd1080x1920_leftside_up,
 	}, {	/* Chuwi HiBook (CWI514) */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hampoo"),
-- 
2.43.0



