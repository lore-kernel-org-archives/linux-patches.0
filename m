Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC4333C530;
	Fri,  9 Jan 2026 12:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961581; cv=none; b=mgpOMrcLRPPdDs1IcCXHNmTs6rf8VXmVrWp+EKnqWNhRNkcOusFRtBgvB318VTKZErPBBZ1KLV46jhqYVhs8y4zrVAw1ANnvFH8/yEe5y4FaWa60Q8MqnWQrLFv1VLSLczvbBqoDGWbhOAHrZLFMm/BzEfotIWpjbBa+AOvg7ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961581; c=relaxed/simple;
	bh=Dra3HMnWQVBi8pImP08BoHvEQBWB4m9RP8losg1chWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u3/YKd9KW5lrUBVexEmATK17uHbK7M1HxyJAlzgHDcB7TODjOmbC7V8Q5ZvXkpU5coLrLTjaw/zP6TeIfBqtPchbydWII8sA1lrBubY7pGFR1NsKmKXpCg5KmI5XoBJzYBWMonpAPGMxDPeCCYoZyyOl2mG9BxpomEanFb6QcqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nx5MxiAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nx5MxiAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5749C4CEF1;
	Fri,  9 Jan 2026 12:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961581;
	bh=Dra3HMnWQVBi8pImP08BoHvEQBWB4m9RP8losg1chWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nx5MxiApKJwKiymuC55KASvVtiJGuJdqf+yl8njcEz7rNJITIH4mYkWJW52Ni4GjO
	 +QjkhFty8kc7vaA4lQJfNBFf04sQ2WOzEESTiDzeX4qRvR7u8UC+LXn4xpjHOP6VzK
	 kVq+2XP5/3UipRdExuawov5BWVtB1rgf7qAiDUGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ston Jia <ston.jia@outlook.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/634] platform/x86: huawei-wmi: add keys for HONOR models
Date: Fri,  9 Jan 2026 12:35:09 +0100
Message-ID: <20260109112118.618621586@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Ston <ston.jia@outlook.com>

[ Upstream commit 5c72329716d0858621021193330594d5d26bf44d ]

HONOR MagicBook X16/X14 models produced in 2025 cannot use the Print
Screen and YOYO keys properly, with the system reporting them as
unknown key presses (codes: 0x028b and 0x028e).

To resolve this, a key_entry is added for both the HONOR Print Screen
key and the HONOR YOYO key, ensuring they function correctly on these
models.

Signed-off-by: Ston Jia <ston.jia@outlook.com>
Link: https://patch.msgid.link/20251029051804.220111-1-ston.jia@outlook.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/huawei-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/huawei-wmi.c b/drivers/platform/x86/huawei-wmi.c
index ae5daecff1771..201e1f2e2c2f0 100644
--- a/drivers/platform/x86/huawei-wmi.c
+++ b/drivers/platform/x86/huawei-wmi.c
@@ -82,6 +82,10 @@ static const struct key_entry huawei_wmi_keymap[] = {
 	{ KE_KEY,    0x289, { KEY_WLAN } },
 	// Huawei |M| key
 	{ KE_KEY,    0x28a, { KEY_CONFIG } },
+	// HONOR YOYO key
+	{ KE_KEY,    0x28b, { KEY_NOTIFICATION_CENTER } },
+	// HONOR print screen
+	{ KE_KEY,    0x28e, { KEY_PRINT } },
 	// Keyboard backlit
 	{ KE_IGNORE, 0x293, { KEY_KBDILLUMTOGGLE } },
 	{ KE_IGNORE, 0x294, { KEY_KBDILLUMUP } },
-- 
2.51.0



