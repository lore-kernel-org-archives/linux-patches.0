Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC2F136658;
	Tue, 23 Jan 2024 00:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969681; cv=none; b=Zj85I483YjgnMvIrkX20UeyGqhd1r+J8HOUJ55FAPdMOIpi+httx/zmS9nlk9zDFra+S0+Cu8azXSKlL6yDBxIiJEneeaedHpwmWYQhj3YD+iq42Rm+3pVX8HxXlpQThdA3GlPj6rBHhBqCoYTQLaRbkYLUC63xGHnTkefh4xuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969681; c=relaxed/simple;
	bh=UTROzBF8lkWcM1L6X/nvG501omNdXOGHdhihb2LDh/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqZXU7AcTAg4tIGexjJRvz1AHRj8/QmZvD2nRJrPhp3vHNN4CXspIcmIqVt3rTtdT+KfL+nJiyUZtXu5JAFRv+5pWVQDznh5MxZ3XJa9e99tZZ3tNxFrHUL3nC3efXWrM6yQI4blFASX3Y0G31OZryQWXSrUzUwrisZwx+D8mAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hn1buCKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hn1buCKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2051CC433C7;
	Tue, 23 Jan 2024 00:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969681;
	bh=UTROzBF8lkWcM1L6X/nvG501omNdXOGHdhihb2LDh/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hn1buCKhJzp1WlTTac6N2uhRQp4gzyU6Fw++sgnKguvyoMh8l3+uR5DOqKEnvSoMX
	 vxPXlaMr1vthq7ahKPf40c0pa0zTVY5Zz3f1m5A96RipafU1oKWVykKYeUYM9aspDx
	 fe4NhEWxHWJu8XAnDr5dZYnb6tTlHxG4z9gp/oh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 376/641] of: unittest: Fix of_count_phandle_with_args() expected value message
Date: Mon, 22 Jan 2024 15:54:40 -0800
Message-ID: <20240122235829.721291873@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 45bd0d28c717..cfd60e35a899 100644
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



