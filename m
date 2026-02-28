Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E32DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301851; cv=none; b=j59LALEp12nMbxdRWg3NOYs7wwPRlSMhWz2scfWcV/WplvqeRkx5CtsOYmXTy2KY/P+vdX8ALyTasEHRDie39eRgTmvqoxAmjHiRyiWaI2C4qYngBBkbLS+fyL2Dnx6Xe92kANM1z0Uv6jiFnfmkV6zyVldBYRhhAeMueDm4igE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301851; c=relaxed/simple;
	bh=toKc4KepMKnPqW2zl4SJ1ZJ9TO83x4x3PRMfSLttgYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yk98uBU64yCSRUbk9akW1NDHMWssS6FZpxWTLqwS54bnd1J6iNvLTbdtyWCKY05OBxud2HBwLOwNiGSVMJ7615HW7qsLZigc7yg6q4GLu71w8mZInNArGmijtzI87XFSkXo/iq+hR0xdQ5dAxZGPmES2dKY9Zou0tE1M/B+dV7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s+NvtJGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+NvtJGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00832C19425;
	Sat, 28 Feb 2026 18:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301851;
	bh=toKc4KepMKnPqW2zl4SJ1ZJ9TO83x4x3PRMfSLttgYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+NvtJGBBf45ZxdGwQUE6MyZWHD/ELzhFfnt9R+4fZl+0tBmM+Uxnd4nk/+CL/UhV
	 rJbg2G2PooJ4KkmSnBR6CX+KURUzoxrI4d2Vjz8hwJfLQc5XZ4KT9haw3aft699EIU
	 XtmKAYCZyP/utDlLDH7xVnBMif/JHd4t0Y4PTD86IpPtzfNlPVeUORBkXYSlcKr+ad
	 rcHwqT25LBcdLmUSi5y9E548Skuy/Sw3WdMXji7U7gVJTzZnZBjVwKibFHvN1VKLMX
	 BWKT97maAl0A0shOkiao5xoPIsMo4CxUaw57jKM1StovFDsTO6lYk+6aQpzSCVad9y
	 Syo+3vkXPTJAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Yijun Shen <Yijun.Shen@Dell.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 272/385] crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
Date: Sat, 28 Feb 2026 12:58:14 -0500
Message-ID: <20260228180011.1568201-272-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Mario Limonciello (AMD)" <superm1@kernel.org>

[ Upstream commit 5e599d7871bf852e94e8aa08b99724635f2cbf96 ]

tee_init_ring() only declares PSP dead if the command times out.
If there is any other failure it is still considered fatal though.
Set psp_dead for other failures as well.

Fixes: 949a0c8dd3c2 ("crypto: ccp - Move direct access to some PSP registers out of TEE")
Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://patch.msgid.link/20260116041132.153674-3-superm1@kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/tee-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5e1d80724678d..af881daa5855b 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -125,6 +125,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
 			FIELD_GET(PSP_CMDRESP_STS, reg));
 		tee_free_ring(tee);
+		psp_dead = true;
 		ret = -EIO;
 	}
 
-- 
2.51.0

