Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E24B2F5491;
	Tue, 31 Mar 2026 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976675; cv=none; b=HU0qGJ8Mw+XzYKJBUKsH5B54ZWnjrSL9ycC+YPrhG5YlkY6uBfF3aCaNUul16fMeex4clKHyuhJxQzZwlc6bfnNUWe4BPVn0FcIxkYQ6EtVKjTfkyZwg8BgxKdiM8Y40LpuCjjIbNs4P5EQ7nwQdCJLMzW+0wi6tBOpLPuc49Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976675; c=relaxed/simple;
	bh=cJd7i8Y8CrkO2y4SB6KsTw1+7PQ3aW1q4OErz5csI6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9CKtAPvu4PSAcqDAAkFeyL/NL0VhMq5IKcrlBpPUFbHIef55vbGZStDZHza5AFFEoGpvRY5swfYfmfRrtrhgjpcbiSvfK14XM3bXvt8U2bQNj77YmMKHiXwkLHOseWu1IQwz4b7igcoLBmd/JDt9EihsoHlzXJQSJ0O1odgO0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vBPUhXkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vBPUhXkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D721DC19423;
	Tue, 31 Mar 2026 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976675;
	bh=cJd7i8Y8CrkO2y4SB6KsTw1+7PQ3aW1q4OErz5csI6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBPUhXkhvkmNofrKHh686oIyPKtfEbrfUxj/gAGygykhmis4lO5VAffD42ov7uPH1
	 c4GeksRrHVycyw/kUuCdGgkSheWw5jq/1bobTdmLLNcpKy6nGLnI40TpjXlqDxj+55
	 Y2v49ruqzIc6uxiZJAaTQg/MbB/d83WerZ0T8bxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juhyun Song <juju6985@outlook.kr>,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 184/309] Revert "ALSA: hda/intel: Add MSI X870E Tomahawk to denylist"
Date: Tue, 31 Mar 2026 18:21:27 +0200
Message-ID: <20260331161800.234854005@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit ed4da361bf943b9041fc63e5cb6af01b3c0de978 upstream.

commit 30b3211aa2416 ("ALSA: hda/intel: Add MSI X870E Tomahawk
to denylist") was added to silence a warning, but this effectively
reintroduced commit df42ee7e22f03 ("ALSA: hda: Add ASRock
X670E Taichi to denylist") which was already reported to cause
problems and reverted in commit ee8f1613596ad ("Revert "ALSA: hda:
Add ASRock X670E Taichi to denylist"")

Revert it yet again.

Cc: stable@vger.kernel.org
Reported-by: Juhyun Song <juju6985@outlook.kr>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221274
Cc: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260326190542.524515-1-mario.limonciello@amd.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/controllers/intel.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -2077,7 +2077,6 @@ static const struct pci_device_id driver
 	{ PCI_DEVICE_SUB(0x1022, 0x1487, 0x1043, 0x874f) }, /* ASUS ROG Zenith II / Strix */
 	{ PCI_DEVICE_SUB(0x1022, 0x1487, 0x1462, 0xcb59) }, /* MSI TRX40 Creator */
 	{ PCI_DEVICE_SUB(0x1022, 0x1487, 0x1462, 0xcb60) }, /* MSI TRX40 */
-	{ PCI_DEVICE_SUB(0x1022, 0x15e3, 0x1462, 0xee59) }, /* MSI X870E Tomahawk WiFi */
 	{}
 };
 


