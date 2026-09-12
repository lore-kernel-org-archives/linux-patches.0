Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8062235AC1E;
	Sat, 12 Sep 2026 08:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201529; cv=none; b=dvp+2yo4IqzOMdDCK99d4e5pslVqwOXtuxHPMxcfK+AD/Ml5TSsFVet1AWLXSTTZOa5U7cCdJmAG6uSKaGwWvvWaz/TLPXuUAamjFtGD3x1AJRT1A7h6w5Gak59mvWVTA4W1YmRvG/zoH6YPy+C97kfmOJhaTR2Q9DqVkJr9XY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201529; c=relaxed/simple;
	bh=fWq6yzA47JIgn8uUDV2lDQT/KTrVGVbboat1Kxenvyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H96grcDKOc5VkSc93N6Cy3xePcJpJ1lAsk6ibqCABgnbwCAIvzfzc2tJbI+6UBJChrp1VUpSuhra0UF0xArbqvjddBQenUXlByW1+AoiYnHEF/0nB4/DEDJPPDhtOtZU2j2SKBRrDijx6vlPNTU7zAr9u/hpnDtNWUN0o/+CugY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzuF/Ovk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzuF/Ovk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143B91F000FF;
	Sat, 12 Sep 2026 08:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201528;
	bh=tvwuJnQUKyilDL7YJgUHVNuZMRwtiWvKUqo4O+SU6NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MzuF/OvkKgipcqbgkfjd01lC2W+49XprozPL+iVUCJPTXu5QwMbg785HqPai178mj
	 z0WkN/cKKztbtDGA6qviLfCoIPL1W2UFAgN9yCXSkfneYu9ZUIYsuhIKmUMtw5AzJ4
	 OAuq1oJl1dTLQ4DzqqxaU7Bfj6Nk24bIRhqz50Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosalie Wanders <rosalie@mailbox.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1015/1815] HID: sony: add missing __packed to struct with static_assert()
Date: Sat, 12 Sep 2026 08:46:05 +0200
Message-ID: <20260912065712.838751049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosalie Wanders <rosalie@mailbox.org>

[ Upstream commit 091c05c184f3a75a275ccc7ae29e17125dfaa661 ]

Fixes: 4b9c410e7d6d ("HID: sony: fix style issues")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607091026.R9Pxd3PG-lkp@intel.com/
Signed-off-by: Rosalie Wanders <rosalie@mailbox.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sony.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index af1ad2c233707..a8b3a1039f0ca 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -504,7 +504,7 @@ struct motion_output_report_02 {
 	u8 r, g, b;
 	u8 zero2;
 	u8 rumble;
-};
+} __packed;
 static_assert(sizeof(struct motion_output_report_02) == 7);
 
 #define SIXAXIS_REPORT_0xF2_SIZE 17
-- 
2.53.0



