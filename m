Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC2160266;
	Tue, 23 Jan 2024 01:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974669; cv=none; b=F7wedAZnz1qdaie+v3INGP6bopzfqPkQA/cTiTGscRcFJwVMMB1C+QoWC9IaEgRSUF1p+OqVbAuThxsy3aw0bpcfryuTmbtlDG4nZXD0x1z8FW1wXYFAKSvNKNa6tcziqoM+Ro/RkVwEIWkxLIbj4ohSJGDQ14T5iwuPJi2ZeEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974669; c=relaxed/simple;
	bh=QkaquBxnJT1mFWZtClseYGONSXuoGX7qnfB0QaMCS8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tW+DOkiGUdycLa0kanXIUPvZ2js9kYAee9HTprFb/wehNGPR625t3+jpslT1r7MeEvecKxNYgU1vs16YZZVQiFtjoATNJ+8rgM0y5lSUM9V6lUVzleJN5MHVpIaPg0JOSqH3Rbc9mtaMeidE3wGqukvKJ0TXwwsn3m94PQy1sZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWDr28Co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWDr28Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97F2C433F1;
	Tue, 23 Jan 2024 01:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974669;
	bh=QkaquBxnJT1mFWZtClseYGONSXuoGX7qnfB0QaMCS8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWDr28CoU+fOENBt0B5wO95/IL5BTnCk/ynpjhRLukf3w9IPTPK0G0YCz4zpSoEMi
	 ebCbPGcPhgYboSdIXgVhLvJH3zccDjKNoBVxXQK0Z9cbeEIj4LMOSHd616Xq5eaOqf
	 XkQMtVnD5XEQxBTgjFGrh38mF+RFvp1XGiK+ilIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/374] of: unittest: Fix of_count_phandle_with_args() expected value message
Date: Mon, 22 Jan 2024 15:58:18 -0800
Message-ID: <20240122235753.156827303@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 716089b417cf98d01f0dc1b39f9c47e1d7b4c965 ]

The expected result value for the call to of_count_phandle_with_args()
was updated from 7 to 8, but the accompanying error message was
forgotten.

Fixes: 4dde83569832f937 ("of: Fix double free in of_parse_phandle_with_args_map")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20240111085025.2073894-1-geert+renesas@glider.be
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index f3a136d75093..699daf0645d1 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -566,7 +566,7 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 	}
 
 	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
-	unittest(rc == 8, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
+	unittest(rc == 8, "of_count_phandle_with_args() returned %i, expected 8\n", rc);
 
 	for (i = 0; i < 9; i++) {
 		bool passed = true;
-- 
2.43.0



