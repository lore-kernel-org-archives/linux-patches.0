Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5891B143736;
	Thu, 13 Feb 2025 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460233; cv=none; b=rowdzqvTwpF5WH3eyMPZ3Be2cBATILqaLqvjYdmwAQS2VN/CgFHMa3FFEMkeMmg6KphkTjsCljehgcXTlD1ifPTRQUUUggNa31UtDq6p6Nfl2v4iimSP094gfH0vYsJD3LcKyOvlA+B7FlrHB0x+uFeNgQRoPQs/3EyKZhvE3VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460233; c=relaxed/simple;
	bh=wwLH19/I4ipqMNl/VRwTE+HC5Q4omtWQhr9cH7EnvQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WE5FH39eKli77cTMYX7rkK3Pi7hf0WYNQ73lwch1ZH3bLxH41MYIk8tyd4ggU3Hk214tdacw5rbDtdWeigdSpbYYPbyizdbufBmkmdJ0IdBXt9cCzUBN+dqQxv7D+KrgsmLUhHBp/Nf9xHK6KLidOvU+hg0CXZQAXJA443a27Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTd9RCX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTd9RCX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38A5C4CED1;
	Thu, 13 Feb 2025 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460233;
	bh=wwLH19/I4ipqMNl/VRwTE+HC5Q4omtWQhr9cH7EnvQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTd9RCX4qOhV9tACvreE700jGjbNUDBdf0SqCVOqo8EVogP5UNis5x4KzYn+mA6Y2
	 58Q4v0MXCkxV9TWab7Jc34cmDeBMRwifLUHUQV8BaWWp4+0TmP5hJqdWTKGaZ3N8Wu
	 k5cN8WAeTnwpFyx/wLeqsgjk3cLlKnOOQUNoOkiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Anwar <farhan.anwar8@gmail.com>,
	Rayan Margham <rayanmargham4@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/273] platform/x86: acer-wmi: Ignore AC events
Date: Thu, 13 Feb 2025 15:27:05 +0100
Message-ID: <20250213142409.446114268@linuxfoundation.org>
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit f6bfa25c6665f8721421ea94fe506cc22f1d4b43 ]

On the Acer Swift SFG14-41, the events 8 - 1 and 8 - 0 are printed on
AC connect/disconnect. Ignore those events to avoid spamming the
kernel log with error messages.

Reported-by: Farhan Anwar <farhan.anwar8@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/2ffb529d-e7c8-4026-a3b8-120c8e7afec8@gmail.com
Tested-by: Rayan Margham <rayanmargham4@gmail.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250119201723.11102-2-W_Armin@gmx.de
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 377a0becd1a18..868faccfb8628 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -88,6 +88,7 @@ enum acer_wmi_event_ids {
 	WMID_HOTKEY_EVENT = 0x1,
 	WMID_ACCEL_OR_KBD_DOCK_EVENT = 0x5,
 	WMID_GAMING_TURBO_KEY_EVENT = 0x7,
+	WMID_AC_EVENT = 0x8,
 };
 
 static const struct key_entry acer_wmi_keymap[] __initconst = {
@@ -1999,6 +2000,9 @@ static void acer_wmi_notify(u32 value, void *context)
 		if (return_value.key_num == 0x4)
 			acer_toggle_turbo();
 		break;
+	case WMID_AC_EVENT:
+		/* We ignore AC events here */
+		break;
 	default:
 		pr_warn("Unknown function number - %d - %d\n",
 			return_value.function, return_value.key_num);
-- 
2.39.5



