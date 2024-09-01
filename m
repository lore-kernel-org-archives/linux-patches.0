Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886011DFD1;
	Sun,  1 Sep 2024 16:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209795; cv=none; b=Z7O4g/qJUuF8pNHwBQNf9PVGFqLFeNkOLEJAl+FBJrVDKqJFL+PbP0/RfkiXiGaW7HH9xzEly8QlE21FkLuJPa4ZBZain765Rv0PN6BYEPeoOu3SRiM7y1EkQytjlGxgvgBCRoI8MIktHD561+mktASL3UvZyTTQhtLFR9BHcqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209795; c=relaxed/simple;
	bh=BNduLgJKXb5XvEbvZoLOyRoZv+rQYXMIndEqlqUOMR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XYwn3KIkqhV1PY8gXn3t1cyJWPTzN6hzo5EjelJaZhS4Z+CfW7ywYdCe0yyzJAuc0E7S3ELbClJznrntm54brgpk2qGvoDRwttD1aUXUWPQg1kv6o9FI+cB0DsnGIjuW+ylYUdjzjFS9lh4yYwNTyKPfQbQc4baXChfDVievHzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiVMk7YW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiVMk7YW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3A9C4CEC3;
	Sun,  1 Sep 2024 16:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209795;
	bh=BNduLgJKXb5XvEbvZoLOyRoZv+rQYXMIndEqlqUOMR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiVMk7YWfdf3b4pkd6NxKSJ9wD5Bjxwnarh0g9m2rhgw27jN/yMpPt0EZwNBMB7Ps
	 opoDiAg9S1QO+67mflg9fSsMacaU4KvZ3E8VjxDeUfLhj7wCaPAzEBBDd/aPXDqWQE
	 EMvcgf78SmulF0KaauzYWmLww0MdLcylXKHhGe00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominique Martinet <asmadeus@codewreck.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/151] Revert "Input: ioc3kbd - convert to platform remove callback returning void"
Date: Sun,  1 Sep 2024 18:18:10 +0200
Message-ID: <20240901160818.998146019@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 0096d223f78cb48db1ae8ae9fd56d702896ba8ae which is
commit 150e792dee9ca8416f3d375e48f2f4d7f701fc6b upstream.

It breaks the build and shouldn't be here, it was applied to make a
follow-up one apply easier.

Reported-by: Dominique Martinet <asmadeus@codewreck.org>
Link: https://lore.kernel.org/r/Zs6hwNxk7QkCe7AW@codewreck.org
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230920125829.1478827-37-u.kleine-koenig@pengutronix.de
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/ioc3kbd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/input/serio/ioc3kbd.c
+++ b/drivers/input/serio/ioc3kbd.c
@@ -190,7 +190,7 @@ static int ioc3kbd_probe(struct platform
 	return 0;
 }
 
-static void ioc3kbd_remove(struct platform_device *pdev)
+static int ioc3kbd_remove(struct platform_device *pdev)
 {
 	struct ioc3kbd_data *d = platform_get_drvdata(pdev);
 
@@ -198,6 +198,8 @@ static void ioc3kbd_remove(struct platfo
 
 	serio_unregister_port(d->kbd);
 	serio_unregister_port(d->aux);
+
+	return 0;
 }
 
 static const struct platform_device_id ioc3kbd_id_table[] = {
@@ -208,7 +210,7 @@ MODULE_DEVICE_TABLE(platform, ioc3kbd_id
 
 static struct platform_driver ioc3kbd_driver = {
 	.probe          = ioc3kbd_probe,
-	.remove_new     = ioc3kbd_remove,
+	.remove         = ioc3kbd_remove,
 	.id_table	= ioc3kbd_id_table,
 	.driver = {
 		.name = "ioc3-kbd",


