Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D440423A7C;
	Tue, 31 Mar 2026 16:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974742; cv=none; b=B2x2u5afUJ405krxMbLDvRDJI+ycsUcCRu9gSp0j+D9b8ny3brTFzNjf2ZRnrKSYw8h//ge3mp4v+b0ZHKiZFCSzuEIxSYTXDm4ecIROMqvUuCuTvXwSbGJGOnT7sIbn5DEnkj2ULdMlERpa/dVLuPB6UzU5dEN5gIqJuJz5OA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974742; c=relaxed/simple;
	bh=jq2d0UBvNS0xvHNTeS+oTU+T2zbuseQ9mhCuU+K0EWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jog5okNEhrHxLfD+l/Foxo8+PbJloMxQvppUjxQfQQXwL3J0lnNfJyJi3EBw1C6ad3YrLa+qOxC89B06ETTBqVuUGarTNW+3p5q0By4cxYPQLme9MQsiqmmy+uy+RJm0vV77dVkmkXXInJvXPaoeYEgIZLRbiPGgX96LWqSDb2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjfxUQK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjfxUQK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7058C2BCB1;
	Tue, 31 Mar 2026 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974742;
	bh=jq2d0UBvNS0xvHNTeS+oTU+T2zbuseQ9mhCuU+K0EWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjfxUQK/1e7StmwCtNDi+u0nqnDWWKoT40m4Tz+jORCugN5KYcZyzIesmhzKp1t9q
	 PS2kdVN4zzi7s1qvvADr8y694J+ug2senre7ny9M99cdbsS+vrLNAeZyAGBIAHzn/v
	 7o3vSahOAXAWbE5nws3IUM3SCoWwIYhP2VJUncAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varad Amol Pisale <varadpisale.work@gmail.com>,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 027/342] platform/x86: hp-wmi: Add Omen 16-xd0xxx fan and thermal support
Date: Tue, 31 Mar 2026 18:17:40 +0200
Message-ID: <20260331161759.909576740@linuxfoundation.org>
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

From: Krishna Chomal <krishna.chomal108@gmail.com>

[ Upstream commit 3c99a545b372c77b5d39715968a141f523eccbf2 ]

The HP Omen 16-xd0xxx (board ID: 8BCD) has the same WMI interface as
other Victus S boards, but requires quirks for correctly switching
thermal profile (similar to HP Omen 16-wf1xxx, board ID: 8C78).

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_thermal_params.

Testing on HP Omen 16-xd0xxx confirmed that platform profile is
registered successfully and fan RPMs are readable and controllable.

Tested-by: Varad Amol Pisale <varadpisale.work@gmail.com>
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260218050235.94687-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 9fcc18635e4e7..bc550da031fa1 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -168,6 +168,10 @@ static const struct dmi_system_id victus_s_thermal_profile_boards[] __initconst
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BBE") },
 		.driver_data = (void *)&victus_s_thermal_params,
 	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BCD") },
+		.driver_data = (void *)&omen_v1_thermal_params,
+	},
 	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BD4") },
 		.driver_data = (void *)&victus_s_thermal_params,
-- 
2.51.0



