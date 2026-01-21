Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FF4392C44;
	Wed, 21 Jan 2026 18:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020065; cv=none; b=d0R3r77S7Fn0GM9I4jQHeNgo9eYwWqDnByhhv+lwVp4t/l6mRh7eioOa/gOjdlwiyywUx+lKaiibaS/yId99eZ0N5h+DGsBvx/u1zwnKeb+R/rBr56FQaU6DCOeml4FdQ4OYa4/vYhkiBnIYH9KUeurCYwcewQqMWHiYtYCm4/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020065; c=relaxed/simple;
	bh=jWbZ5vESx9gWG6Nybg94T2fLMWBBTNNq5xsPl5fUu08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxdco028pQegjRT1fN8yw3Xxnpg4ncT4uajAjZvRkXH3RKX8E01dJTcMEL2Oa4d18aCcQzPxL0JJ0G20aw+70yHqFy2+8quOcmrlX4SqCrJ9fiZxOtwzsAtP5LWiw0lPQqcRhmRu2adrrncwitRjetb6eSEZ6WLA8lRElT0j7l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/OwdS8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/OwdS8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422CCC4CEF1;
	Wed, 21 Jan 2026 18:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020065;
	bh=jWbZ5vESx9gWG6Nybg94T2fLMWBBTNNq5xsPl5fUu08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/OwdS8TRn+EPdLYj7N6bvXgPM2CrDXZC8J4FUPwmHZh4495tsBQ3Ybm33X1ScJa7
	 D3EiGEMwL/Tm41G4SwjU17O1ymaLoRy1eir1rmMu4G2Q+vBIVFnRZ3wU62fQtzG9FJ
	 Z3q0MNutCrp8Yd84mIIwAJWBuuEL/ahFkWUEwwCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/198] ALSA: hda/cirrus_scodec_test: Fix test suite name
Date: Wed, 21 Jan 2026 19:14:37 +0100
Message-ID: <20260121181420.319607099@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 6a0243c4020636482797acfd48d7d9b0ea2f2a20 ]

Change the test suite name string to "snd-hda-cirrus-scodec-test".

It was incorrectly named "snd-hda-scodec-cs35l56-test", a leftover
from when the code under test was actually in the cs35l56 driver.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2144833e7b414 ("ALSA: hda: cirrus_scodec: Add KUnit test")
Link: https://patch.msgid.link/20260113134056.619051-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cirrus_scodec_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/side-codecs/cirrus_scodec_test.c b/sound/hda/codecs/side-codecs/cirrus_scodec_test.c
index 159ac80a93144..dc35932b6b22f 100644
--- a/sound/hda/codecs/side-codecs/cirrus_scodec_test.c
+++ b/sound/hda/codecs/side-codecs/cirrus_scodec_test.c
@@ -320,7 +320,7 @@ static struct kunit_case cirrus_scodec_test_cases[] = {
 };
 
 static struct kunit_suite cirrus_scodec_test_suite = {
-	.name = "snd-hda-scodec-cs35l56-test",
+	.name = "snd-hda-cirrus-scodec-test",
 	.init = cirrus_scodec_test_case_init,
 	.test_cases = cirrus_scodec_test_cases,
 };
-- 
2.51.0



