Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A3526B0B5;
	Thu, 13 Feb 2025 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458964; cv=none; b=T8yNHzdu0EcjH5INzaGMtVd7eRZaiv+GUZQELw3fBewTklI5Knk2oZEsUTcCW41wL0GbhZdYRiFlRkHeadf7Ljt9qaIABIFZETJdz6SwJM4PJZ2pk5Yjv233ixb0rXhUdejOlV+bfBXhe91WZAoW4dJawhtyc/UGEy76P5kkBb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458964; c=relaxed/simple;
	bh=VRAJj/WPDSRZEeE5im6JLCpD69TeLATI/DWO2RS7Yr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iziuCKgN85YdqS6UBemLMmaIg40u4n9nvTySuywJ6jjn10cr5IzgH9Tojbj+KxHDtws7b191C7mK4zW81o7mw8LrNsrjQe4VTO4xImB0LjpGvuT/JTqQfjRQdlv01DejQWNf6/YcSotcDiO+1e9SJ59Yvss906xxY0TOzORAKmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2Ly7yRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2Ly7yRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64D5C4CED1;
	Thu, 13 Feb 2025 15:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458964;
	bh=VRAJj/WPDSRZEeE5im6JLCpD69TeLATI/DWO2RS7Yr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2Ly7yRDJLgXkRKWpvo0XduyshZUm6OdyVCRY9w5P8op/+h8BjedVsa+CrqON8tsI
	 eL2JmATlfRFeMPOAN27HQHTlq3g8eCYhxJWWAc0Q7+M5sicXAm2x5Q37F52c43W8x9
	 usfWKbg2wx/JOySTAdeEQbo3jZymub8UYCnnVnJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Anwar <farhan.anwar8@gmail.com>,
	Rayan Margham <rayanmargham4@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 101/443] platform/x86: acer-wmi: Ignore AC events
Date: Thu, 13 Feb 2025 15:24:26 +0100
Message-ID: <20250213142444.508530053@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 1b966b75cb979..ac4f8ab45bdc0 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -95,6 +95,7 @@ enum acer_wmi_event_ids {
 	WMID_HOTKEY_EVENT = 0x1,
 	WMID_ACCEL_OR_KBD_DOCK_EVENT = 0x5,
 	WMID_GAMING_TURBO_KEY_EVENT = 0x7,
+	WMID_AC_EVENT = 0x8,
 };
 
 enum acer_wmi_predator_v4_sys_info_command {
@@ -2321,6 +2322,9 @@ static void acer_wmi_notify(union acpi_object *obj, void *context)
 		if (return_value.key_num == 0x5 && has_cap(ACER_CAP_PLATFORM_PROFILE))
 			acer_thermal_profile_change();
 		break;
+	case WMID_AC_EVENT:
+		/* We ignore AC events here */
+		break;
 	default:
 		pr_warn("Unknown function number - %d - %d\n",
 			return_value.function, return_value.key_num);
-- 
2.39.5



