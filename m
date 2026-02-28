Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C1F175A62;
	Sat, 28 Feb 2026 17:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301421; cv=none; b=mCUFrQ63C+MUxs83N/Cmti1BREjqwQmsaYdb1ataalBISif+FTa2fQegv48P3C7qqgFhpB/nIXNcxDyd/rrfL/w51u7AuwgEvltu/1n60VIyQJL+8QsCnqRrCSmed4JYsHg2ruJAqGmUBswomiTnJ0QfpKUF3VhPHLpD2UkC5SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301421; c=relaxed/simple;
	bh=CVsQXwErh+3UDMxzd+f1OyBwyYab9vaX/eDRrIKzo50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5jRjLr+rgPV4vz+ceHB1jCaHtehry5SkLi+miQlGAMeRnHQFWQ2EKIOjLzvbYZNSNLwQTNqLFUdZoq/NaZSdHtqeznu6yQHC4SCDu3C5TbB+oRskTMwHov23rxdMNcw1VvrETT5ZzEzwW0AVRFvXjkmVojsMi0vGTvWv/2eOek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rk4TjXxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rk4TjXxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A3EC19423;
	Sat, 28 Feb 2026 17:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301421;
	bh=CVsQXwErh+3UDMxzd+f1OyBwyYab9vaX/eDRrIKzo50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rk4TjXxCgGfKQaPU8MthrQMTi9snVMRzVNsE16MIIcSWadUwsQR7VRwKOn/ei0hRn
	 +4EUOFGanSOsvqbufRDxuOL7z8y6Z0hW63e435X9nQtoCDXl+N5lRZuu98uT/Wz7vz
	 fC9+xu/uOM+1SOG0SX03w1Yz2VSxKw9JQ2iV14ks0OxOcFNYoeNZ14VAo6kGTqDH6y
	 sw41cKQZKaJ7lsuuXyJZTPqUy0uK81gBrcN/oZNV6gELs2Es2nsOd+5HsWJ/wsuO20
	 +ZiqY68zZ6aFy5rf0VOkAzdteKOrQwKalnkZ3e/h81/7FoIsPDwf3I8iiBU4QWkIwf
	 KYhPK7XqXMsPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Janne Grunau <j@jannau.net>,
	stable@vger.kernel.org,
	Neal Gompa <neal@gompa.dev>,
	Stephen Boyd <sboyd@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 611/752] spmi: apple: Add "apple,t8103-spmi" compatible
Date: Sat, 28 Feb 2026 12:45:22 -0500
Message-ID: <20260228174750.1542406-611-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Janne Grunau <j@jannau.net>

[ Upstream commit 6c54b0a801dd8227237ba0bf0728bb42681cf027 ]

After discussion with the devicetree maintainers we agreed to not extend
lists with the generic compatible "apple,spmi" anymore [1]. Use
"apple,t8103-spmi" as base compatible as it is the SoC the driver and
bindings were written for.

[1]: https://lore.kernel.org/asahi/12ab93b7-1fc2-4ce0-926e-c8141cfe81bf@kernel.org/

Fixes: 77ca75e80c71 ("spmi: add a spmi driver for Apple SoC")
Cc: stable@vger.kernel.org
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://patch.msgid.link/20260123182039.224314-7-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spmi/spmi-apple-controller.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spmi/spmi-apple-controller.c b/drivers/spmi/spmi-apple-controller.c
index 697b3e8bb0235..87e3ee9d4f2aa 100644
--- a/drivers/spmi/spmi-apple-controller.c
+++ b/drivers/spmi/spmi-apple-controller.c
@@ -149,6 +149,7 @@ static int apple_spmi_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id apple_spmi_match_table[] = {
+	{ .compatible = "apple,t8103-spmi", },
 	{ .compatible = "apple,spmi", },
 	{}
 };
-- 
2.51.0

