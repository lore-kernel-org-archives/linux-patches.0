Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E6E48167F;
	Tue, 25 Aug 2026 14:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666456; cv=none; b=RWJ2aAMigW6kak4739gdfEJlZjihXj8KXhDsSazjzxpq+hgFFHyZxN9Dhbsg1W24JEv7nzxF2X51wYBtU12kJXRKPYi1ZKPJzDI+v8zyx38q3KxpntMtq1xNb2ksIecNh3+J9hXlZGAYj7fm8vrmS4w2FjD6vLWP0RYSewMLxfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666456; c=relaxed/simple;
	bh=oUWn2NWn5zsJGXS7AfEl7GFBkEdXcTHolDUBewfO1yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiwCzUb5DBl9jQ25WaD1Rw5HjyN2OZWjjEqeSQlzgFWbJScvhFDpWcsTiFg0NpN+OSZFrx6PPHfJFS5IP4qYmAasqt96oaCl92DYlGbbJchpq8N8jqs09ysjbYU+Z5wGQ2JUTXbrt/j2rWZDXMU6u4R8fM1B9muHUtS3W1NaYD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlzKVmEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlzKVmEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6421F000E9;
	Tue, 25 Aug 2026 14:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666455;
	bh=nbwmGHSTSLpzwtnVJ3QfB3/XyaQyR5Sd3pc6ZLjPwlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlzKVmEWvbPOL6wDWvzknEwPDZonOqkW3lSwbkhnAf2KkaefItLPjn9xsy9Ap/dhn
	 rGrj4u7fjXhHwU8KHW7j0H83kdifAu5A+pirAJskoF5qoF1dN+Js1lW5ES4vwHE88s
	 VHtD3svC/XiJIVPs7IPHinB2mTI4NtTRcbNoiseU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 48/57] Revert "Input: ims-pcu - fix race condition in reset_device sysfs callback"
Date: Tue, 25 Aug 2026 15:27:10 +0200
Message-ID: <20260825132543.214084585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 8b9ff928aa71a2ff6f559da45821b64fa4886a75.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/ims-pcu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index 1df5e773a1f34..5d2d1797ee209 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1192,8 +1192,6 @@ static ssize_t ims_pcu_reset_device(struct device *dev,
 
 	dev_info(pcu->dev, "Attempting to reset device\n");
 
-	guard(mutex)(&pcu->cmd_mutex);
-
 	error = ims_pcu_execute_command(pcu, PCU_RESET, &reset_byte, 1);
 	if (error) {
 		dev_info(pcu->dev,
-- 
2.53.0



