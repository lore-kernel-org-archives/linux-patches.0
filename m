Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4563513C3CA;
	Tue, 14 May 2024 11:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684995; cv=none; b=QhQ1b2qw9NWmDk2hWsPM/bV02tgNW/lvGneKZrTJz2/ERxQjIqMLg5x6HwLlqcRGJfYGnk400TGHNMQq12h1ikWd4hmn4C8AvQEgqUhAeHN2vC8oOCJGj3/4lIyh6pNdCc/tmYzRZXgyUVgWD86DaVv4fF/vvdgBR7gM0vE4hpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684995; c=relaxed/simple;
	bh=djng8qHHt9wRAM3RjYjuhxa6rpSjCz/55qVfTCDZhWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hdxES7NDUfIKpCJ1GUHl8tVNSUrPNeAWLk9/oB1KG/oHF7nUEaZOrSoDcFvQ9a4ZaLk9YIJxmzu81Z3hPLvZCoaDU6wdSuYlGpPqBovzvRNypAro38SRjcVKP3XxowCr5vaiNX/sMOB8HFCHQyRM5FJcTuZWkPauRJWehs0EBXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOkhfkRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOkhfkRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A472EC32781;
	Tue, 14 May 2024 11:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684995;
	bh=djng8qHHt9wRAM3RjYjuhxa6rpSjCz/55qVfTCDZhWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOkhfkRhHLZe0CD13Qwq6e9TiR82wPZvUdw13xz7uoKA8JvuzYYxBY7O94lWJV0V5
	 ymHXTco+4ycR38kD5zq+FBsWLjCVukkDaTRc6FCqqgM5W1V3O3mUO4cATP6gtCMJ3/
	 9atgkTYx5/6OhS8PfhcQyz4834Buujizb/LJ3CNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/301] regulator: tps65132: Add of_match table
Date: Tue, 14 May 2024 12:16:30 +0200
Message-ID: <20240514101036.743763231@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Apitzsch <git@apitzsch.eu>

[ Upstream commit a469158eaf8f4b10263b417856d923dfa38ae96d ]

Add of_match table for "ti,tps65132" compatible string.
This fixes automatic driver loading when using device-tree,
and if built as a module like major linux distributions do.

Signed-off-by: André Apitzsch <git@apitzsch.eu>
Link: https://msgid.link/r/20240325-of_tps65132-v1-1-86a5f7ef4ede@apitzsch.eu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps65132-regulator.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/regulator/tps65132-regulator.c b/drivers/regulator/tps65132-regulator.c
index a06f5f2d79329..9c2f0dd42613d 100644
--- a/drivers/regulator/tps65132-regulator.c
+++ b/drivers/regulator/tps65132-regulator.c
@@ -267,10 +267,17 @@ static const struct i2c_device_id tps65132_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, tps65132_id);
 
+static const struct of_device_id __maybe_unused tps65132_of_match[] = {
+	{ .compatible = "ti,tps65132" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, tps65132_of_match);
+
 static struct i2c_driver tps65132_i2c_driver = {
 	.driver = {
 		.name = "tps65132",
 		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+		.of_match_table = of_match_ptr(tps65132_of_match),
 	},
 	.probe = tps65132_probe,
 	.id_table = tps65132_id,
-- 
2.43.0



