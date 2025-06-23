Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCA71E3DCD;
	Mon, 23 Jun 2025 22:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717168; cv=none; b=bp8OHRoL7j3hy/1pv+6ztmQckCF7EDqlAEj2oWas/OkYHXevy0TAM87BPVsPv+ELhwSVwmvh9fWNX9e60eW1A4mtiJ/YmVJAP/0bHYT+sjYaAZPZkYr7RAGY8iUG2KhKbPXN/WWGnsAz4H3rTCYNAKgIbPnbPNKCMiE6a6bZGa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717168; c=relaxed/simple;
	bh=lGyDc+yqAfHx0H/IpSMbO/37zyUgjWYtynxUDsUJb8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szMXyRhsbMIV7eDozvGFgmI1/NX/2w50tZRD/mUBcJ2U06lWF2vp4ptUTtKRSoy3AaMluP+TvNUNjC9IfYVF39GCDhnUoypqHrQanf8wWhtcemA0yKWm1wOlu7KvHGuJycIgk5cmckv8MeMNMOGDjjs5GEORn9UmnWcFUKh6xQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RE8+6eY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RE8+6eY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77A2C4CEEA;
	Mon, 23 Jun 2025 22:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717168;
	bh=lGyDc+yqAfHx0H/IpSMbO/37zyUgjWYtynxUDsUJb8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RE8+6eY9VVuxlg/G4KIj9XkqStK2BkkFq/y6RWnb2bkCYgTfN27t4nWB+cbQ5OJE9
	 rTyDAsS7t7jRQ5FDAg7qCy6gRaWNGxe6jg7o+kIS47ndure0TM8WFSPMMC/nNOJX/e
	 MouUxu+KY90TS7N74ZHoQTm2NHFKauf4HEW/sjhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 332/414] ALSA: hda/intel: Add Thinkpad E15 to PM deny list
Date: Mon, 23 Jun 2025 15:07:49 +0200
Message-ID: <20250623130650.287374446@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c987a390f1b3b8bdac11031d7004e3410fe259bd upstream.

Lenovo Thinkpad E15 with Conexant CX8070 codec seems causing ugly
noises after runtime-PM suspend.  Disable the codec runtime PM as a
workaround.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220210
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250608091415.21170-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2286,6 +2286,8 @@ static const struct snd_pci_quirk power_
 	SND_PCI_QUIRK(0x1734, 0x1232, "KONTRON SinglePC", 0),
 	/* Dell ALC3271 */
 	SND_PCI_QUIRK(0x1028, 0x0962, "Dell ALC3271", 0),
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=220210 */
+	SND_PCI_QUIRK(0x17aa, 0x5079, "Lenovo Thinkpad E15", 0),
 	{}
 };
 


