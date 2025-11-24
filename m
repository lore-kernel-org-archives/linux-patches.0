Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDD72E975F;
	Mon, 24 Nov 2025 08:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971635; cv=none; b=qkXF3hD+hJujxT/wa8rruxsWyD2GOyLksWWum30RNflfGiyHioxBmfDb0wqkj2b4UvLBF0HRviQ4GezP4ciZhJo9dKidethUlhdJHn+B7pCO50bIqUzQucTxhSGAxoERPRfNme8Bq0oMudGhswR71K82jkUoP8we8A4/ssLuwX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971635; c=relaxed/simple;
	bh=JyM3QapQ0fOX726psd5F5CQRWKc/V3Z8RGP9Mi9+hAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EN6r88xNlPLditw+RCcjUkI7Jvl8FVjHNbvkVzxFOB1oK8Jtq0LE6wbJ+dYZcIvAp/ln473ffrxt05q7hJA2ZYKurGOrlmiHuxyjWO9lPTK5B48KNeemZFRTbXZFV+CULTG9ZjAlor1435PyDcNmg4U+cf9SQCOl0kVmEbFgM80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FxuPJqe8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FxuPJqe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AD6C4CEF1;
	Mon, 24 Nov 2025 08:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971634;
	bh=JyM3QapQ0fOX726psd5F5CQRWKc/V3Z8RGP9Mi9+hAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxuPJqe8+JUDjYgC1kxtkSsbxi8YGFvwlYx93+lwEMZ4AowGiT3q8z385gnvBBP64
	 /P/vRwTmdhYZaui12Wyjpc6VM4uglWkhmUKqFVtd1/4+eiW4ivMcjANJq3OyPLFoJH
	 wV3wvncb3eJ3JkNJin7zbg8VkTQ2BNpyiVTYelk6OZYvyafh8En0x/ial/xuZCQv2M
	 D+cfhwnFovt2RHCIHTLJ+JT1oNPUFPMp5ZmgltO5ssYyZk2H+Hw/GxXxMTFyYAvrSX
	 7Z1BPXqKbeXQsEf1WvnjYVQZyjQrQt5K/+MRBMOUHFCUNQZ8Cwic5MADB8P6QNp6G+
	 VaaMnTFtpQ3/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marcos Vega <marcosmola2@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mpearson-lenovo@squebb.ca,
	mario.limonciello@amd.com,
	kuurtb@gmail.com,
	luzmaximilian@gmail.com,
	edip@medip.dev,
	krishna.chomal108@gmail.com,
	julien.robin28@free.fr,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] platform/x86: hp-wmi: Add Omen MAX 16-ah0xx fan support and thermal profile
Date: Mon, 24 Nov 2025 03:06:30 -0500
Message-ID: <20251124080644.3871678-16-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124080644.3871678-1-sashal@kernel.org>
References: <20251124080644.3871678-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Marcos Vega <marcosmola2@gmail.com>

[ Upstream commit fa0498f8047536b877819ce4ab154d332b243d43 ]

New HP Omen laptops follow the same WMI thermal profile as Victus
16-r1000 and 16-s1000.

Add DMI board 8D41 to victus_s_thermal_profile_boards.

Signed-off-by: Marcos Vega <marcosmola2@gmail.com>
Link: https://patch.msgid.link/20251108114739.9255-3-marcosmola2@gmail.com
[ij: changelog taken partially from v1]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:



 drivers/platform/x86/hp/hp-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index e10c75d91f248..ad9d9f97960f2 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -96,6 +96,7 @@ static const char * const victus_thermal_profile_boards[] = {
 static const char * const victus_s_thermal_profile_boards[] = {
 	"8BBE", "8BD4", "8BD5",
 	"8C78", "8C99", "8C9C",
+	"8D41",
 };
 
 enum hp_wmi_radio {
-- 
2.51.0

