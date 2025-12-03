Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09DE3314D9;
	Wed,  3 Dec 2025 15:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777597; cv=none; b=pVtD3dtr8bYlVnU8dyMdNt2/euBQmjF33G5soZQnB23eDT9scIdxBBnVeRXuPg1Mlpzx67ISioEdIkIa/GoHTF+wOooJetMu/SyY1oIAAFazDwfFBCbbXM7qke/ORLTHd54wGlhdZCtkNInwp709U9uaKkE8lbYjD9Okpy8FTI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777597; c=relaxed/simple;
	bh=5J3ke9G2a6nFw2PmoJ97VPP/7D1pd4Tr45lFQdtOHnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jjvy0Cb8p38gUBTO4sJdMLvFkTyQQLuopL2y9JjJsyoOFeTMyhfkETrvyFJiRDkPcribIj1S5QlHo6fLAmYdEk0AYV3rK+xYgbC731Txeo0u7Gv+fsO2LY80CumpvhNlMdUw6sLZtV/uYrQ9Xg2x3JmRpEktv1Wii2shktgmt/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UASODjxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UASODjxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B56DC4CEF5;
	Wed,  3 Dec 2025 15:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777596;
	bh=5J3ke9G2a6nFw2PmoJ97VPP/7D1pd4Tr45lFQdtOHnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UASODjxAXs2DSmcE0IFYN4QnSrev2qG2YwB01Ev2dzj6boKNHgr5v3EEky7Si6Qyy
	 EYoR90hvdR5Deh51kke5ZHH/V6Ep1xrWbpxbcct+wg7AQLDyJ5TOufsOQ/t3A/Fqtm
	 m12Byc6G3LK6iKvO3wR5rXvm5HIAhwNUe1zERXto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/392] mfd: stmpe-i2c: Add missing MODULE_LICENSE
Date: Wed,  3 Dec 2025 16:23:57 +0100
Message-ID: <20251203152417.304860933@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 00ea54f058cd4cb082302fe598cfe148e0aadf94 ]

This driver is licensed GPL-2.0-only, so add the corresponding module flag.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250725071153.338912-3-alexander.stein@ew.tq-group.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmpe-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index cd2f45257dc16..d52bb3ea7fb6f 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -139,3 +139,4 @@ module_exit(stmpe_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("STMPE MFD I2C Interface Driver");
 MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
+MODULE_LICENSE("GPL");
-- 
2.51.0



