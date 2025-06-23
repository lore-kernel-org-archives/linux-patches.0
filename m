Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13824223DE5;
	Mon, 23 Jun 2025 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717585; cv=none; b=YgSpUFNVDOck6K7URxfirwKkI+BlFI5G2TQxv4tdwvtLPcMW5OpPxDNc/PMVy67+1/kVt8crtW0MJWAIt4/rDpuI6LLhZRe/Bwr0NZpkDnGhOtPFVhlIk7K3gr4RbXLWO3zR0NTOjikUJ5yx4FHryyvzPd7qxKI7cllWL6Q3HJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717585; c=relaxed/simple;
	bh=GkvHBtr5VGhm7AbPpHc0YRmAiEoXHLiHpKKrc7jupz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhOV3z39adEEoxVZGN9U4LnzoHofOl5ZHmaPnzSywyEM1IV1uG2vtbffswjvyxZ//aVLGAhRi1G83kyAlgk2ix3ijBoW7vjhzKXwQ9I+NjIvfw42Z8Cq+WYH2DzoxiEE2BlD5WRh0rebTMXmecM17dCgcknPZBTPTKp0gGReyms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmHEeGSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmHEeGSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24F3C4CEEA;
	Mon, 23 Jun 2025 22:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717585;
	bh=GkvHBtr5VGhm7AbPpHc0YRmAiEoXHLiHpKKrc7jupz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmHEeGSy7AaJkXCQGtxSzOzZhg49cJEDKb8tWR6cy/W69GQtyM8K0MU44RuGc3PQ7
	 cC+6lgvpQqt30ixiV6itYYWrpnD7AaOa6bBuR0XYIr4HYGCsLkUJVbkV+Wk8T0SmX/
	 H6pZdT0PXH6ns5vlQYuMdQwS9T57b643S+6oHNtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 460/508] ALSA: hda/intel: Add Thinkpad E15 to PM deny list
Date: Mon, 23 Jun 2025 15:08:25 +0200
Message-ID: <20250623130656.443260217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2261,6 +2261,8 @@ static const struct snd_pci_quirk power_
 	SND_PCI_QUIRK(0x1734, 0x1232, "KONTRON SinglePC", 0),
 	/* Dell ALC3271 */
 	SND_PCI_QUIRK(0x1028, 0x0962, "Dell ALC3271", 0),
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=220210 */
+	SND_PCI_QUIRK(0x17aa, 0x5079, "Lenovo Thinkpad E15", 0),
 	{}
 };
 #endif /* CONFIG_PM */


