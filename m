Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027B44EB86F;
	Thu, 17 Sep 2026 16:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660801; cv=none; b=R+fRXPzD+Px0lNSIs9lnjOBb2Qztc11xKZHJuCsMPq4cxR5SyUWecBCHjtyDfGsLbRbt6KvguvCHOBVPy879Dz72Ss4oS5r3FuyOkwM9RwvOnMk4P6qCLy3rdpEOCzO5eojixL4ZbAeUBCtgHAz5XecnQG5YWDygW3IfD/esNRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660801; c=relaxed/simple;
	bh=jWAV7tvcPj9iivbLEvT+P8XfjaQxiTwwG6J1ZMBnVZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MmH74P8esyku4A8J7la7pJPyZqFTFygGtavvRGydVgxnZ6aSvIew1KVLN+Iy+upgD96+CveTGrlqlFbXyJesLsy0qKh6KVvzKzVobEuC5WvirwLZjgpC9HhGMZu0MhMM/mbSq5Qv8uTl5vwwvtC+KG9Ginyx1QIeCY3NO5Ehf08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTuGcUOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTuGcUOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3686A1F000FF;
	Thu, 17 Sep 2026 15:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660799;
	bh=8VZ+m+0Zq+PFahm5968HNFKFU+Cc2/bGfWTh+yKvp5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTuGcUOjdiqZwqvcJtznRfEws6pTicun999eq8+fBO7iYdFmWPbdknpDI3JXSAGRk
	 ps/+ebAmMJRkXpaMMp1LMpANhjkSxXCZwxcXLn5Ffz/jRnig7Zgp/bIYylq65Zyq13
	 DrO3YxM8G7b79rqcFTXWa2XapBlWNF2wQngQoGAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Arda=20Do=C4=9Fu=20Ari?= <arfeliousheres@gmail.com>,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 714/733] platform/x86: hp-wmi: Fix board_params typo for 8DD6 board
Date: Thu, 17 Sep 2026 16:17:02 +0100
Message-ID: <20260917151410.704359880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arda Doğu Ari <arfeliousheres@gmail.com>

[ Upstream commit ee02ed6308fbbd851c4e5c1f642d029617049a12 ]

When adding support for board 8DD6, &omen_v1_no_ec_thermal_params
was passed as driver_data instead of &omen_v1_no_ec_board_params.

Because active_board_params expects a pointer to struct
hp_wmi_board_params, dereferencing active_board_params->thermal_profile
results in a type confusion bug and invalid memory access. Update the entry
to point to omen_v1_no_ec_board_params.

Fixes: a7320d6eb9c42 ("platform/x86: hp-wmi: Add support for OMEN MAX 16-ak0xxx (8DD6)")
Cc: stable@vger.kernel.org
Signed-off-by: Arda Doğu Ari <arfeliousheres@gmail.com>
Reviewed-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260827235139.154462-1-arfeliousheres@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -291,7 +291,7 @@ static const struct dmi_system_id hp_wmi
 	},
 	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8DD6") },
-		.driver_data = (void *)&omen_v1_no_ec_thermal_params,
+		.driver_data = (void *)&omen_v1_no_ec_board_params,
 	},
 	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8E35") },


