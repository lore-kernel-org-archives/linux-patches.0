Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02FB2FF16C;
	Wed, 10 Dec 2025 07:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352075; cv=none; b=iguy/m6SBg74MPI+3OiQP0nDX4dJlbJBhBMrsG1nveozzW2TOxjJ57wW2agZ0XyVkEyOlR9OuExXsBVrauAKRTpCmnjCNPLh/sbieD8mdEoJKyZvKowKECgMuDrNUooOmff1yKw2kg49kUJZ/HEPWRTcpzSl3lhnGLPaj7gnuAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352075; c=relaxed/simple;
	bh=1IsqzElEmxMUT1mmd6kx0WbgU+VE7cK1P24dAs+/18M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XB+g32s4nBb7fhqn8/Ur+K2CUaFyDbALzt9jVSUuUYhDB6RunS5V3XZrsdjVD454gCFk79auhQblUntXo1bloQzTIMjLYH5hOGuGcozOvBz5L0i1uqiW7FgXzop7m1XMgAkdaU6AQPTutovi/ZiDs1h1WuCpWA2XIR/+6fZaXpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWv0KUq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWv0KUq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A89C4CEF1;
	Wed, 10 Dec 2025 07:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352075;
	bh=1IsqzElEmxMUT1mmd6kx0WbgU+VE7cK1P24dAs+/18M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWv0KUq0tybXQf2PSnU/ohr5+rK07iR9baOImwhO+xrqpMvamvxAYw4YXN3WIUjv6
	 idAJ5reGfuKGtZfrpX8ciC2CnW6q+MkErqUqCsnPalVsa0HwmH3xVIj06s9oi6m5gE
	 Y1hJr3pOBRiMXyLWMae54G3h8e1Y1YuRTk618gW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	April Grimoire <april@aprilg.moe>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 39/60] HID: apple: Add SONiX AK870 PRO to non_apple_keyboards quirk list
Date: Wed, 10 Dec 2025 16:30:09 +0900
Message-ID: <20251210072948.838064060@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: April Grimoire <april@aprilg.moe>

[ Upstream commit 743c81cdc98fd4fef62a89eb70efff994112c2d9 ]

SONiX AK870 PRO keyboard pretends to be an apple keyboard by VID:PID,
rendering function keys not treated properly. Despite being a
SONiX USB DEVICE, it uses a different name, so adding it to the list.

Signed-off-by: April Grimoire <april@aprilg.moe>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 61404d7a43ee1..57da4f86a9fa7 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -355,6 +355,7 @@ static const struct apple_key_translation swapped_fn_leftctrl_keys[] = {
 
 static const struct apple_non_apple_keyboard non_apple_keyboards[] = {
 	{ "SONiX USB DEVICE" },
+	{ "SONiX AK870 PRO" },
 	{ "Keychron" },
 	{ "AONE" },
 	{ "GANSS" },
-- 
2.51.0



