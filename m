Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2496148CFD;
	Tue, 23 Jan 2024 00:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971465; cv=none; b=sizrbrsBQuRZ41pnWHxtWkTTrDc40wkLvvec6bH1hAYBtxlRLtXu+haWYB+Z3scsVKTOH6JaVaUDwDxTAeywFw+fHOJ4my5wXEns4Hasx+XFYcqo8z+nMaNA/G3Lj+oAOmlKuTHkxu6dUoKRnzNra7ZzBXWQYksAzYNw6C3Ku9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971465; c=relaxed/simple;
	bh=VzuBvOEWev6/bBAQ56Qv0jdWXKihWw0Jiyvb4bgxx3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xg8vfdiJbEv+c8MxHf92QjAYk23VDqo4vJODlLNEJJLnwP0KXkn3Z3XIzRFueE7YVux5ylas+SwFX/4mm9a/9lhT10G4Tbu5QeqyLTPBdjRMJa7CuQJqCd+VXuccvkhWuTq6nPoAAVsZZfluLRNzCcWSqoRgjiUsFM+48YAlyWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+S9jYMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+S9jYMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619B1C433F1;
	Tue, 23 Jan 2024 00:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971464;
	bh=VzuBvOEWev6/bBAQ56Qv0jdWXKihWw0Jiyvb4bgxx3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+S9jYMHXIUTiB6BKHa3C/FXibvtzSKJ4SXIW1IwL4xCh+qjDWFlQloA/ep7A+noc
	 DSPT7mKt6mMWGXq1GcJ0bTsMA+tCbkbqmgd6hqDYzD2AfKwzbxlNrcLYT7SWklCq3k
	 IEbrCpkyWXpwE2yZhMeNtHexL1VyzEipBZudxKdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 247/417] of: unittest: Fix of_count_phandle_with_args() expected value message
Date: Mon, 22 Jan 2024 15:56:55 -0800
Message-ID: <20240122235800.432693949@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b59cb9ba1979..e541a8960f1d 100644
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



