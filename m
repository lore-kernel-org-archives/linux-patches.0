Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1172737F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302355; cv=none; b=an2WxxAFLpcQDB9sSMZ5zlXnWzkztV0N0ioiRYVpBtP6k386e7sJzFIpKun5Vp+lrkUwhBvHNLe3SZWlUqgIV9fbzjC+AGSq0G5ib9/UlOqu2It0zZbyEdhRg1D3ONmVM/t819OjDNkN8nS8ZXJqfNHatSQ1uO0dQ4KWfqzERbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302355; c=relaxed/simple;
	bh=haEb5M+3Ilz5Q2tZZKkg0GHOO7uKZJU4jRQR3O+Phdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkpY6TILVkf99/yPMqW3HXsN4gco6RnvTFWf4iPSOmvWYAZBPWfPqscCL0p2pE6nm20R2PJHL4V4cw07+w4+z+MoW2/TIZEB+Th0Cf0gfDsRqsg6ZEg+xhQEuPx93phkHdlSxv8aupZV6RvFRw+nEfWM5NXm2n83QSRdd3QwK/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8Ct3Oeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8Ct3Oeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578FBC116D0;
	Sat, 28 Feb 2026 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302354;
	bh=haEb5M+3Ilz5Q2tZZKkg0GHOO7uKZJU4jRQR3O+Phdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8Ct3OehYhrUNu9pB6dA1J4Tw7CE9j6gFGrzJh43WJx8z8C2krdtRikgPYTE4N9pD
	 fm+bGq8xDuzyb/zW6bddZTHeg9FvOK4louQfaBq7zD0GeACYyyYkQBTITlqakqeM6n
	 L7mo9/vg3WXEyhUuEJfOUJQ+bfO7jTnYBl+j53oD0U7H1a2WEguqZm80+2X6Sl1/yx
	 W3h+zBnwFvxOc5mz3ivmU1aQT9oLmNt96PU/gXumPjkkmM58oYo0V4Na2TzPe5I6qM
	 Tuq0jTR2oucOj8uY0SFC1p9ULtaqyF6wJu9ALPcQbO1hQ1Ji0K0r2d+fyDUxvkKFU2
	 M//AeQMv+T/ng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/232] HID: playstation: Add missing check for input_ff_create_memless
Date: Sat, 28 Feb 2026 13:08:53 -0500
Message-ID: <20260228181127.1592657-80-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit e6807641ac94e832988655a1c0e60ccc806b76dc ]

The ps_gamepad_create() function calls input_ff_create_memless()
without verifying its return value,  which can lead to incorrect
behavior or potential crashes when FF effects are triggered.

Add a check for the return value of input_ff_create_memless().

Fixes: 51151098d7ab ("HID: playstation: add DualSense classic rumble support.")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-playstation.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index 38d5171dd25b2..d6d86406f42fd 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -508,7 +508,9 @@ static struct input_dev *ps_gamepad_create(struct hid_device *hdev,
 #if IS_ENABLED(CONFIG_PLAYSTATION_FF)
 	if (play_effect) {
 		input_set_capability(gamepad, EV_FF, FF_RUMBLE);
-		input_ff_create_memless(gamepad, NULL, play_effect);
+		ret = input_ff_create_memless(gamepad, NULL, play_effect);
+		if (ret)
+			return ERR_PTR(ret);
 	}
 #endif
 
-- 
2.51.0

