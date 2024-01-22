Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D67657B3;
	Tue, 23 Jan 2024 01:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971773; cv=none; b=PugXL6uFjJZvbNdcmBNH/bV5DKPE1T2msEGxvsBmW3XpYSXnLrlT5Aw7ckSx9D5A4dMz8+JOgNYehTuTI0fBWfroOR9PVUqM5WDUeOKqYapGMn51o24SICUQyKe3quBaLIjKJhKtSHygKOQd+KH6oAVFSSI1xg7m8PcwvCgPNQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971773; c=relaxed/simple;
	bh=AxFRtAQw8bEbezvtxfcY7PunHo9MAcjSI7yboVM/R5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHl3/HMaYiHLgShelatnuMNsBP0ybCmIdgpUKMBBAn8dFvGHo6ifyxiuyvfS0OXb6+7keqpIXei9q/IGLYSd9rYm7hTphjVzGTZiQIAU5z41FSAePw5HwjrUjrUkoSojAzQhKGy0BSSmDVzKzHugh8L1UTUDZAWy5K+1mz5hmQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+F2Udik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+F2Udik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D446C433C7;
	Tue, 23 Jan 2024 01:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971773;
	bh=AxFRtAQw8bEbezvtxfcY7PunHo9MAcjSI7yboVM/R5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+F2UdikKealcFjIdl5CL2Z2z1Sp4rKDkWXV/bQEqMbSNj8IKhbWp5OBIdREp9AQw
	 gRjZKi7SiYytXdS4YBWG7kZhrxpSCHDk46z1NtsS+rNDkTBq7XAEop/6Tw3ITMJhOM
	 MJIkRke5aoO4lCa4eXI58U55GRdtVlT2wMieSEGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/286] of: unittest: Fix of_count_phandle_with_args() expected value message
Date: Mon, 22 Jan 2024 15:58:22 -0800
Message-ID: <20240122235739.667497726@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 197abe33b65c..f9083c868a36 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -565,7 +565,7 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 	}
 
 	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
-	unittest(rc == 8, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
+	unittest(rc == 8, "of_count_phandle_with_args() returned %i, expected 8\n", rc);
 
 	for (i = 0; i < 9; i++) {
 		bool passed = true;
-- 
2.43.0



