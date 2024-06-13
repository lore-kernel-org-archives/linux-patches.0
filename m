Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8A22CA6;
	Thu, 13 Jun 2024 12:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282472; cv=none; b=cvxAvqDiBtolx0gsUgcOgsnZ7D9fHFPB/2b+ePmVSPvDpyQSwhvrfi1Tkn24Yj5MV+xo2NOZUxU/uaESwsChZqqx8oYVZJrukUNCjVsvllANS7Yn8wiBoGtUu3dxOFqtbYqIbzFTPOS3xqZHWiN2kfDqD3DvIwMDjiStSn+vjCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282472; c=relaxed/simple;
	bh=DArZYwv8pMAXNuWwqHiHJI8jQHt98GK0lL5jILe5+V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnVyYfW8vC6KzomTKSdfz7iDEzxF9Rs3sSnYGjXvLufu6sCGOvpv7v2kmPzpL+kKcj+DALSyj8Aglgwpe1lwZM/JpBzpIPNspUemE4tzoMxZkQsGK/Fsuh4JnLkZQ6KMy+dTSX4METj//N2N0i7tx4Rvm8MClbO60LuIgiPeYfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmvfFSRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmvfFSRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ABDC2BBFC;
	Thu, 13 Jun 2024 12:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282471;
	bh=DArZYwv8pMAXNuWwqHiHJI8jQHt98GK0lL5jILe5+V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmvfFSRrbK/cCHP0uWbUajocfYPDJ6aNKBR30apPaSTLoBpo2vwGuv2VITnn+5H/+
	 mLFSV3Xv5Pwd19hkboak5L8+v+xV/RuiCcoorqYGqhd4fqeogCpKpe8b19gt0orw8u
	 MNbWqhjcxmbaP1cR+y5uDAGlqXebhjYOXKLMcovQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/402] Input: ioc3kbd - add device table
Date: Thu, 13 Jun 2024 13:33:25 +0200
Message-ID: <20240613113311.821884617@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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



