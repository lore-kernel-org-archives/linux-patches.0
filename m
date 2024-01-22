Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A13B12DD9D;
	Tue, 23 Jan 2024 00:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968980; cv=none; b=Oq6ghcpXnXSgZ4NRGTD6dvjtpTI2FNv4ALzV64IWoX7uZP0o6G9Ujak9cAoMpvZTlqImVuF6FeIffs25Y6uXkFH7mKjpfq4JjBvRuf4QusLNDgZULYHbjrVl9zkRJgAiQVC/47SJJpzFhkigGiw91UGdIrPTWOLt3VOZ10Wc9fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968980; c=relaxed/simple;
	bh=rUwMN39GDUvtKksVMV4P0jt3DHHrkYUNI8TRh6e3/gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEjFdUoNPGQUzSPWeI6aDluhlSzSri4G9EH68VaYSLvohtXeTmXevAWr3SZgezJD+w2EdVzTlNCmqpCNDf7lcUJVd8vCncNaJDa7OjSF+CriYkVs1Zu3z9ktrClncwaCoEqwFTnpJ0ma0pmErDVN7MNudUVUOdXJZ3+3ZWTrN3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2mD7EWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2mD7EWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1894C433C7;
	Tue, 23 Jan 2024 00:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968979;
	bh=rUwMN39GDUvtKksVMV4P0jt3DHHrkYUNI8TRh6e3/gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2mD7EWdsnG6xgUsfCgXZg1PrP0ofTnkrpat1nUr8Yf7Cux9R0UQf+PWjCt2GgHQ2
	 oDx6ZZBQYMpmoRj/L5Lwba8zY19xTL1E7djOm5NSSnSRiCNLGsWAyNRKHYPzho1ogg
	 Em9iKz3faAXdSqRCaxBNEiyIux1lbaLrSNc50Fe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/194] of: unittest: Fix of_count_phandle_with_args() expected value message
Date: Mon, 22 Jan 2024 15:57:48 -0800
Message-ID: <20240122235725.154230881@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b1924062c939..1ed470b03cd7 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -500,7 +500,7 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 	}
 
 	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
-	unittest(rc == 8, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
+	unittest(rc == 8, "of_count_phandle_with_args() returned %i, expected 8\n", rc);
 
 	for (i = 0; i < 9; i++) {
 		bool passed = true;
-- 
2.43.0



