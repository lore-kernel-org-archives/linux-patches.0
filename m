Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EAC3FB3B;
	Thu, 13 Feb 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460230; cv=none; b=eXt1g7i96GNPuuyme1ZtUTLRpFJJ7HgSm1/BnhWeOA2u3J9MrSsl8NxyDgbwVMgHkk5tcSwv7VIa54UhbbbVa9eakeyDiFN0lS7vq3j6M6TdUbgj0xhmdYHhnM0xpfMsQWOkT5OX4Wa3Sn6TVcoQwH+0Eh9r0BjdUocmWobJpmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460230; c=relaxed/simple;
	bh=Ysm0jBg4jFuGgdV5XBKYnwQ3L2wiLTSuEVDSwNBj7Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SxBgfuwjqqoupqEp/oowYd9+PT6rLWHs/6h0xYw5ClXMa/+Rj/0SK/dFQxbg0U7gjenAyttlZouQyXOI7j0/L/5yw5GFHeSxyny0zZLN283qnrXzhxSvDrkegjM/ESHxHYSWK53EtErmxmouxZaK9mbD6w485geERynJQ7h9pJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tvjufhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tvjufhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF4CC4CEE7;
	Thu, 13 Feb 2025 15:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460229;
	bh=Ysm0jBg4jFuGgdV5XBKYnwQ3L2wiLTSuEVDSwNBj7Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tvjufhZiCTbu3UYb1TnZVscfMarueuWoC29q6oVdGuL9okBvufTAPJvf947IWliM
	 A/GqTqxmwaxsbUQt5O5fNd5JWBMCvPyEgPRWk8y+3HGv0a3U1rsRDGAkfvqH60ULSL
	 35CeVDY7aKWF3eRq1KVfCeDnyUje658U93t5ZiIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Illia Ostapyshyn <illia@yshyn.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/273] Input: allocate keycode for phone linking
Date: Thu, 13 Feb 2025 15:27:04 +0100
Message-ID: <20250213142409.407339002@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Illia Ostapyshyn <illia@yshyn.com>

[ Upstream commit 1bebc7869c99d466f819dd2cffaef0edf7d7a035 ]

The F11 key on the new Lenovo Thinkpad T14 Gen 5, T16 Gen 3, and P14s
Gen 5 laptops includes a symbol showing a smartphone and a laptop
chained together.  According to the user manual, it starts the Microsoft
Phone Link software used to connect to Android/iOS devices and relay
messages/calls or sync data.

As there are no suitable keycodes for this action, introduce a new one.

Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/20241114173930.44983-2-illia@yshyn.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/input-event-codes.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
index a4206723f5033..5a199f3d4a26a 100644
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -519,6 +519,7 @@
 #define KEY_NOTIFICATION_CENTER	0x1bc	/* Show/hide the notification center */
 #define KEY_PICKUP_PHONE	0x1bd	/* Answer incoming call */
 #define KEY_HANGUP_PHONE	0x1be	/* Decline incoming call */
+#define KEY_LINK_PHONE		0x1bf   /* AL Phone Syncing */
 
 #define KEY_DEL_EOL		0x1c0
 #define KEY_DEL_EOS		0x1c1
-- 
2.39.5



