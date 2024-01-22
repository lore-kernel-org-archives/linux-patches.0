Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B966BB56;
	Tue, 23 Jan 2024 02:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975377; cv=none; b=qFDS3LRZ8p3mq10vypOX2Z9rl2Mk+5qhBxXAy376gYsFwhOH0CtUaF6z+3QuBKM6tXbIy/+m7Au23HzbZnk9OuJufJNuN02dlYsA6PkHgQpJht9skkMB35h3jeLpQfplYAOvvSKsZ3N0SCf0Q0x8+T0wh9TAvKf/01LITuLEgys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975377; c=relaxed/simple;
	bh=9nZOllORmb8ls4Ps6Y+8FXFnmjj+ul3UjVBektDlNpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuQRArc8Fth4J+vgKZSn8OhV1Z+ot4SduY4V5rC5Fp+R0GCdQlvryOk9KPdS2DUdKK8Ze6qxnt6+cs1vJdfB8cdurLCL21Ec9nvnWm5erG2RJReT5YKOc6+PUqyAJ+ppn4ARc3uqV1yoMxF1lRBipa28X1XvKGfvuKv7WeFu2ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdHwvxqU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdHwvxqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781AFC43394;
	Tue, 23 Jan 2024 02:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975377;
	bh=9nZOllORmb8ls4Ps6Y+8FXFnmjj+ul3UjVBektDlNpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdHwvxqUYjaBy1BLDi0q4yc1FtrOAdh1++Nx6UvaDDTa7WMtposAua51DNiE4V9ld
	 bkxnTAu0WMFB1hgbDrlTC3Pql16QzwGOR/IS1VxnJPuLLPALJixDUfwqrhXMh4t9oO
	 +9VSXcfrJpIFQ6slnr+uCk1tAAs6ELNKG0McWids=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 340/583] of: unittest: Fix of_count_phandle_with_args() expected value message
Date: Mon, 22 Jan 2024 15:56:31 -0800
Message-ID: <20240122235822.429538464@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c63f5963751b..f278def7ef03 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -574,7 +574,7 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 	}
 
 	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
-	unittest(rc == 8, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
+	unittest(rc == 8, "of_count_phandle_with_args() returned %i, expected 8\n", rc);
 
 	for (i = 0; i < 9; i++) {
 		bool passed = true;
-- 
2.43.0



