Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED179421A1D;
	Tue, 31 Mar 2026 16:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975206; cv=none; b=h+6g8twFJzcCmF8pKlGbjsYhLPtN2aKTeTVvZrQ4jePOQbRMGzQMlJmb6LRsAvnnXXVvAOx3u4D1EiKlsX+3XiYz40dUqlPv6pZsNwCnahLmarphtEpA6OFPhU/Nkx4l1CtSDa7X/ezVCWPWCg+SJHWB1qVaeHQRs7nfaBMQvvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975206; c=relaxed/simple;
	bh=b5EDOe3icRmVfzcrC4S5dTzKpqDtfQHCZje1QGFlgiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU5Z2vYCShJ8GcktHS1T5LhF2Ai5NRlaDqRX4D+opoNYccjCcZXfzV3EaMHWlzQGVof5ccKDnXWqax8kPZSZZEUY0fCq+MuxexPH+IcDkcfrThjTVrOuEOfYU3G7oBHwzvU4stTWvkxX7wlUfT1qRHLLPwqolrqr+75uwx3g9wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sy6WrLtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sy6WrLtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A4DC19423;
	Tue, 31 Mar 2026 16:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975205;
	bh=b5EDOe3icRmVfzcrC4S5dTzKpqDtfQHCZje1QGFlgiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sy6WrLtHlhvaec2V/Q7I1ZUbz7nCURdbBcj/Dcv550Y9tx0ExzsrSuD0J+zPbNg+e
	 7aSpBOMfZW8UmYT2keCbp590qsEi/LdtxbBfqpkCNUtgGcFXts3X0hw26ubD6ZYQ1v
	 ar+vHXWPAQfANotWWOLdgpkXu0qCRXS1Lar0cML4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juhyun Song <juju6985@outlook.kr>,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 205/342] Revert "ALSA: hda/intel: Add MSI X870E Tomahawk to denylist"
Date: Tue, 31 Mar 2026 18:20:38 +0200
Message-ID: <20260331161806.527410658@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 


