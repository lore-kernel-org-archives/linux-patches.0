Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E47612DDA1;
	Tue, 11 Nov 2025 00:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822320; cv=none; b=mel84Mnm80Ixkm5U8MrxUynks4FibXsE2NwQ1+PcNvV8fQjC9yKHci1b0rpLrbx2n9H+z0d1OxAOM57T4fsZBmZY4U7XKQKJbm9EjwJjHaSL4u9fLBNYZKixE+70vnCffreM4r+MsFy3f7CdE+UyNUtj12wweeIRm1wF14Hg0iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822320; c=relaxed/simple;
	bh=QtEcIDfQhUeWXIKL5PPG8jYQ7kD7uikckKM+Gdux9M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nxd4xCydk5vN5aDuoUjnztnyjiJagI9FqDehqNQxcKAVCdDIybXvjyctt+EvmBmNnC6K11xJyKIULVhrrmjLLiIwguC85hbHm6MapPkzaKxUdJmhP8JOp6uNFAvB5YjW3k0NQhwU6xIHFK1P0a8lSL5i8ic0PDDus4vyNBdFYmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9ybqPle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9ybqPle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C6DC4CEFB;
	Tue, 11 Nov 2025 00:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822320;
	bh=QtEcIDfQhUeWXIKL5PPG8jYQ7kD7uikckKM+Gdux9M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9ybqPleCbsctyGyO1r4JhZRXfBQxb6/gerx8NeRJzDdum9AFUbOFIhDQe/aViGfT
	 vk5kiJ6zVYjkl7sshkUu6zGp3FMAXjsArAV+k6bLU6wjmU/RENYm9vOgsbe31wkKnZ
	 DxA9SKyv6J1eDVFg1st6h33greLvk8pS4/4KcVGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/565] ASoC: cs-amp-lib-test: Fix missing include of kunit/test-bug.h
Date: Tue, 11 Nov 2025 09:38:02 +0900
Message-ID: <20251111004527.467366868@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ec20584f25233bfe292c8e18f9a429dfaff58a49 ]

cs-amp-lib-test uses functions from kunit/test-bug.h but wasn't
including it.

This error was found by smatch.

Fixes: 177862317a98 ("ASoC: cs-amp-lib: Add KUnit test for calibration helpers")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20251016094844.92796-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs-amp-lib-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs-amp-lib-test.c b/sound/soc/codecs/cs-amp-lib-test.c
index a6e8348a1bd53..1bc43a4cfe09c 100644
--- a/sound/soc/codecs/cs-amp-lib-test.c
+++ b/sound/soc/codecs/cs-amp-lib-test.c
@@ -6,6 +6,7 @@
 //                    Cirrus Logic International Semiconductor Ltd.
 
 #include <kunit/test.h>
+#include <kunit/test-bug.h>
 #include <kunit/static_stub.h>
 #include <linux/firmware/cirrus/cs_dsp.h>
 #include <linux/firmware/cirrus/wmfw.h>
-- 
2.51.0



