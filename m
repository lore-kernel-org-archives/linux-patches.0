Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C4C2BE03D;
	Fri, 23 Jan 2026 18:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192443; cv=none; b=qCpr3GhwVhiOZmyAMJfVPEXVdRLYgDAglWtlzBm5tAvT8UgYkJoQwyn/7Zpux5ddYPWtxb/DEkzsFdUzP6JkExu+xKbjs/NHTiesc3T78HvfwfHCbsUEG/ftUZ+Mx56l02ZISvWrqV536rok7MIi43SFqhE+ImjelCuhtiDYd5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192443; c=relaxed/simple;
	bh=18xLU7cFZwgMxh6+rQ9VFg6Y240mlvTsBUNqFwNX7qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peEehd+Dyi1IhmtjitSd9248SoeoAmq5Fqym9NVq4nz7tBwvLcinWRbHHUjI/vxW2wV8AP8EgflTGNcg6Hw3oSmO1EA/dgF+ljQ97MJArGSE02oE9X78j9poLPN8giyO8UKC7rRXoi+Fi8h5ofWNIIcB6ZNvTYuVXwvs29aRbQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRs7bElL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRs7bElL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE21C19424;
	Fri, 23 Jan 2026 18:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769192443;
	bh=18xLU7cFZwgMxh6+rQ9VFg6Y240mlvTsBUNqFwNX7qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRs7bElLik2suTbKMtcTvvhZ6A6hTHTY/+xL1A4mdwIbwPsAJXMtOkca66mkXD9J2
	 bjVZjJiuR4gST49AS3Db8YF69IgenwbrfYMD0JZDlHoJ7leAg6NMQJ4s+3Kan/bz+J
	 pyl+6YmO8BP9eSY3FYuC8mS3cLB6ItfIrjxD9ba7nRsfaDAdkKpbChGV3Aiu0M5/P8
	 4mrOGWaDadWAV0jRlYhwPjSri8I1VItbH+9Br4dTF7ahhCILA7V1WjFne3a0u67m+m
	 qkOkVZ5dZjIyCqrFKGJm0r15pnVW3X7lfVI6VJSlFJfowEgitxhxdOI0yiquJM82rr
	 t/vAF4LYTl+iQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Janne Grunau <j@jannau.net>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	Neal Gompa <neal@gompa.dev>
Subject: [PATCH 06/10] spmi: apple: Add "apple,t8103-spmi" compatible
Date: Fri, 23 Jan 2026 10:20:34 -0800
Message-ID: <20260123182039.224314-7-sboyd@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260123182039.224314-1-sboyd@kernel.org>
References: <20260123182039.224314-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Janne Grunau <j@jannau.net>

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
---
 drivers/spmi/spmi-apple-controller.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spmi/spmi-apple-controller.c b/drivers/spmi/spmi-apple-controller.c
index 697b3e8bb023..87e3ee9d4f2a 100644
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
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

