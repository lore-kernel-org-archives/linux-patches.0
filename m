Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FEA6FB3;
	Tue, 23 Jan 2024 00:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968444; cv=none; b=f8JJgUFl1c/xzvjoY+mX7bHM8Dc+cpd6xEybtySaeO4xvDyyxkkS9LhKRoRSMU1Oag2wj6AL3YRh1k8IiHdrbKsW3jDcFIj6d2XPAY2KBnyfKvr6phqm/q8TppgwngtXxtf4GBb0/vCjPBNwlEY76H62TrKu2SEkzCfx8rSqCOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968444; c=relaxed/simple;
	bh=YwhjUFcQ8S9etgL10ZJFiusgleatOm8z2dAAtiuCbd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JooGGkn+kx/RftaTSaF4ntmX/VizWRcrjy/H+0K9T12tJraU/Ntanj+30lJRbdyOjsmXEgjD8WXOQ944tGO3v/F4+rzu/2kySgtypkqLUW/wBqZt44rsmr/Ed13W+s3PuAP9G2KBxNjPxhuD6OBauWbPyeMPRqYR0PBgLEIqiWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bz+cuN8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bz+cuN8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AE2C433C7;
	Tue, 23 Jan 2024 00:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968444;
	bh=YwhjUFcQ8S9etgL10ZJFiusgleatOm8z2dAAtiuCbd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bz+cuN8BaacdhcYQU3qlB6i043eV5YT4ZxEWzdMsqqvmESZxHyMquFvOlqmF1EGQA
	 /INtKVOvRfIcjRyN/blzXCrFmj85gCI/4uIgdwBcMcn/7aouqgiVuBe7LCgg8frLaN
	 l4U5gNZQHMe9ihxrawhsjaNPmdHnv4rRINUc7Qxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/148] of: unittest: Fix of_count_phandle_with_args() expected value message
Date: Mon, 22 Jan 2024 15:57:47 -0800
Message-ID: <20240122235716.938191323@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 52f2943be5b5..8abd541b811d 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -496,7 +496,7 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 	}
 
 	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
-	unittest(rc == 8, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
+	unittest(rc == 8, "of_count_phandle_with_args() returned %i, expected 8\n", rc);
 
 	for (i = 0; i < 9; i++) {
 		bool passed = true;
-- 
2.43.0



