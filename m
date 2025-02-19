Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D252517A2FE;
	Wed, 19 Feb 2025 09:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956811; cv=none; b=cDfSeMQV2K6gGb6eLArXDuN3a/dMvS67HlEQeer80m4nfZ8vkm3JlDE6ycCzihgHlGAgYE4X7BGnYfDGMAAcbKYI8uJNnYUDID/DWXTTJeK6t6Lag849Ba5weulJ6ORzCmyLIYcnaYYK/NnK99Mt7ueWKJrPjNqVHqQX5uADAoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956811; c=relaxed/simple;
	bh=r1StxcG3jceSxv3RTS8jNs6TIdnuDg42pKXHGttlKaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i93l4kb6NzpwGGmSNdK22ZxLs8N5nfUuSJjx0JqTXv/o52Bvdpq936lqH79jBG5qwUL8XMpIgmNxP4tjtrWymcoHHrGUJs8II+jby4Ug9K6F7J44M053z/t72OqvhyiZmBvbltQ/yuNBWaEMJtPIvvU+Q1SndLP8M2QAaGuqrIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5Voctg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5Voctg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CADC4CED1;
	Wed, 19 Feb 2025 09:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956811;
	bh=r1StxcG3jceSxv3RTS8jNs6TIdnuDg42pKXHGttlKaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5Voctg/xFCIxetMr6hQxTRKLURj8hP5n+f8XkWNIgumqzLds7GlCv3H3uKChcxtC
	 bxtIy+3ftVZUS8HJvx0iacXseQWVlnwrj0+X1yKbl4a1qI8e9VbONajnM+aeL39Ujb
	 DqYHIm6fFs+ZB4DVQQXPexPAVQ8CmmrbEe9nxuX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Anwar <farhan.anwar8@gmail.com>,
	Rayan Margham <rayanmargham4@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 308/578] platform/x86: acer-wmi: Ignore AC events
Date: Wed, 19 Feb 2025 09:25:12 +0100
Message-ID: <20250219082705.132690485@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ee67efdd54995..da765a7dedbc4 100644
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



