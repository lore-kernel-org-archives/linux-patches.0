Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D732A13D607;
	Thu, 13 Jun 2024 12:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281283; cv=none; b=LYQdO7KnDrnVT/cOdWYV+5NZQ6NPV8vwLTX1jCJYUbbqq0Us9DP31uqFiJnOiQk9tomGBXNv6mjomuYgeoTvoXOhBz5SQSrEI9CoJ56pWCtex6zmZuXs50ZWFp979jO5wsTnrheSLBw8yyM1VJp5iCEdp5kI+xM+T62B7t2Y/38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281283; c=relaxed/simple;
	bh=SIxYwKwmiVp7NENIemxOfDRZP+6/i5GY+bjLTKKBrcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mo4oEM26r5zHbm3eKj8AnJ9Ubsc1Ksll5TT86O2Y4hMyAno1cvNSQm5jX3YqrMCyQwKyCPMcENGQyZRu083sqGHq6JXPZqHT1SxXbCJh0PMyx7RVj6EuZKdSriuHDj6XcqpABvMkqdYRx/EBemC618fSznqobOXVf7d82AeTl+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSzOCEs0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSzOCEs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0B8C2BBFC;
	Thu, 13 Jun 2024 12:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281283;
	bh=SIxYwKwmiVp7NENIemxOfDRZP+6/i5GY+bjLTKKBrcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSzOCEs0r0WnlTxZs01F/ylLv8c7Ig/hPnorOUtARjIlpEI9HQ9znjU4qJ+dOzuJv
	 3izLiOKtGGd6C7soLd7GrkL6TVuCk3usJTlNq6swLW6mPB8SQ+AvV7ne/i9RIdwiCF
	 gtE4J0BPAhFYQDPrDMOXiNsWng51j5UqVgsfXPC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/317] Input: ioc3kbd - add device table
Date: Thu, 13 Jun 2024 13:33:33 +0200
Message-ID: <20240613113255.099158773@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Karel Balej <balejk@matfyz.cz>

[ Upstream commit d40e9edcf3eb925c259df9f9dd7319a4fcbc675b ]

Without the device table the driver will not auto-load when compiled as
a module.

Fixes: 273db8f03509 ("Input: add IOC3 serio driver")
Signed-off-by: Karel Balej <balejk@matfyz.cz>
Link: https://lore.kernel.org/r/20240313115832.8052-1-balejk@matfyz.cz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/ioc3kbd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/ioc3kbd.c b/drivers/input/serio/ioc3kbd.c
index 50552dc7b4f5e..676b0bda3d720 100644
--- a/drivers/input/serio/ioc3kbd.c
+++ b/drivers/input/serio/ioc3kbd.c
@@ -200,9 +200,16 @@ static void ioc3kbd_remove(struct platform_device *pdev)
 	serio_unregister_port(d->aux);
 }
 
+static const struct platform_device_id ioc3kbd_id_table[] = {
+	{ "ioc3-kbd", },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, ioc3kbd_id_table);
+
 static struct platform_driver ioc3kbd_driver = {
 	.probe          = ioc3kbd_probe,
 	.remove_new     = ioc3kbd_remove,
+	.id_table	= ioc3kbd_id_table,
 	.driver = {
 		.name = "ioc3-kbd",
 	},
-- 
2.43.0



