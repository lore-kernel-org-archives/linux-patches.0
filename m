Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91EF313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301008; cv=none; b=PAY9Je+9FOLx1xEz634J+mY4/sy7s4EbeaCjb6V3c0v4lDZrmpbdH1grIQdNxikgaKR0I4RILR9XISFrPRYFPAw7JnKaJVqA/CoQJbKws590kl6jy2BNZpV1xJkcoAGhVUUlLtHc95L37ZIK5VGPaUEKyYjU61IzVso3O0pKF3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301008; c=relaxed/simple;
	bh=wdudqbYngq88C0TzinB/h0Ifxxl/S8VyroMgpAofPbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTwPYL36Gmr07a7CyHGueL5xqpfWnQt/GaIUcjD4HI4IcAhkY41AWGYAGwJyq7FYQJ28CZuVZgLo9DX8O3MKHmfjgUni4zDGKwagd6hCyDPXhYz8tANB/z4DAIhjHqaLn2ro1w0SpA2GLIn9EPB2op1e8XCawZA/ucFShUhHPHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebaCxHH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebaCxHH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBB0C116D0;
	Sat, 28 Feb 2026 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301008;
	bh=wdudqbYngq88C0TzinB/h0Ifxxl/S8VyroMgpAofPbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebaCxHH/8Sum1AHduGXVyRug+1KC4Q5zkjzxC0MxwpgtLaGSLEMZt12L4wV++R9AD
	 6bjq53qD2XeHTJMVQ1FnsqttrzisQSLOxa3voAT0gyxo9UjSsShVubn4Y2XP4SgkVL
	 25BBWJAQ9p+LCh0nlv4b/g80aajmehLEUxFJkjZQcmyHPxO4kF3EQvYaCJu6Thnard
	 ppjjSjR3F1QUwwr0tWR2bs3WPvxZDOb4m2uWFuUIq6xbzeBEWxw+M6rXvAF3FNapBA
	 I9w9+Knt9HcuQSc7XINEfqgP6Bc09J7EssccAVcvy+azH7g7XiVVN0L0f/72gYb5Bo
	 G8wPXwg/nRevA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Joey Bednar <linux@joeybednar.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/752] HID: apple: Add "SONiX KN85 Keyboard" to the list of non-apple keyboards
Date: Sat, 28 Feb 2026 12:37:33 -0500
Message-ID: <20260228174750.1542406-142-sashal@kernel.org>
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

From: Joey Bednar <linux@joeybednar.com>

[ Upstream commit 7273acfd0aef106093a8ffa3b4973eb70e5a3799 ]

The SoNiX KN85 keyboard identifies as the "Apple, Inc. Aluminium
Keyboard" and is not recognized as a non-apple keyboard. Adding "SoNiX
KN85 Keyboard" to the list of non-apple keyboards fixes the function
keys.

Signed-off-by: Joey Bednar <linux@joeybednar.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 57da4f86a9fa7..233e367cce1d1 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -354,6 +354,7 @@ static const struct apple_key_translation swapped_fn_leftctrl_keys[] = {
 };
 
 static const struct apple_non_apple_keyboard non_apple_keyboards[] = {
+	{ "SONiX KN85 Keyboard" },
 	{ "SONiX USB DEVICE" },
 	{ "SONiX AK870 PRO" },
 	{ "Keychron" },
-- 
2.51.0

