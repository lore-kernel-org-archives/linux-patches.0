Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4819F1DB148;
	Thu, 17 Apr 2025 18:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915607; cv=none; b=cRh8HqTNo9FDK7gjPRqFUS0QFLKE5qlGBoubLdv6VW/r6K5QBcz3m4EEaO5KRMpZ/rfYcUzHwuaVEX9ECEmVxwZiQJqTrukIUIFgJ3n8FES6JhYbFGxtAATm5JksVARwlvZDoZ0jI6hndbAad3kj741YIkMSBR00/zlWNjDjHpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915607; c=relaxed/simple;
	bh=/BAVWs2Q+6t95bwOKzeYud6at072q45gC7fzxZe32PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rv6StvQPb1JjT5cDSGxnBZ8APB3iLluoGaX4RmCmF78QB/XRoTC238nCZTza15PkIEgMIMhX62FMJkpoKa9gJ9/7PnlPY2/jThlrSv5OCMcZn0y1iwTELdU+JfFKsn7fPj+1S1hw7MEdWpFeITbi8foq7Jgglg7lazDHRzm7+W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhDn8K9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhDn8K9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDF4C4CEE4;
	Thu, 17 Apr 2025 18:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915607;
	bh=/BAVWs2Q+6t95bwOKzeYud6at072q45gC7fzxZe32PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhDn8K9zmVZHdaVFHfIAOp3k9lXxDRy4BVBML+SLFUE65lfEOpyvwQhMyxTeOP3IK
	 IEFvcy6yLoWBci5gtgvHJh9tupD1lXuiU+Yw8cK33AhDAaMuvDXZdQ0CucaUk/h12e
	 x6TN+tD9XAaTU0KKe4ZsUDDTLHirZFk51wHw1M10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/393] HID: pidff: Remove redundant call to pidff_find_special_keys
Date: Thu, 17 Apr 2025 19:49:50 +0200
Message-ID: <20250417175114.876274588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 1bd55e79cbc0ea2d6a65f51e06c891806359c2f2 ]

Probably left out as a mistake after Anssi created the helper macro

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index d5734cbf745d1..6f6c47bd57eaa 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -1159,10 +1159,6 @@ static int pidff_find_special_fields(struct pidff_device *pidff)
 		return -1;
 	}
 
-	pidff_find_special_keys(pidff->control_id, pidff->device_control,
-				pidff_device_control,
-				sizeof(pidff_device_control));
-
 	PIDFF_FIND_SPECIAL_KEYS(control_id, device_control, device_control);
 
 	if (!PIDFF_FIND_SPECIAL_KEYS(type_id, create_new_effect_type,
-- 
2.39.5



