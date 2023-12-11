Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A1C5102A;
	Mon, 11 Dec 2023 18:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqiRT3HY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD53EC433C7;
	Mon, 11 Dec 2023 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320615;
	bh=YwG7Us0bsOeEP9RE7N7MxGzRsHDb6ydqGjRs71uzLZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqiRT3HYVtIhBviEaCGzNP4q01nWdxS9zagXfKW8UgDMwUXXYqqfn5Hjw0riHXIx3
	 Qxm4zE9r5EJmyoy3hJApmEmk9Jrb4jReYx4RdLtGE2TOs8pRB1Kwr6ygOy2PYHYtLz
	 W/wA2HPFMSHWtLPwUcFSEPxuMD6D4pXyaWNL378M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 109/194] ALSA: hda/realtek: Add Framework laptop 16 to quirks
Date: Mon, 11 Dec 2023 19:21:39 +0100
Message-ID: <20231211182041.340333365@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 8804fa04a492f4176ea407390052292912227820 upstream.

The Framework 16" laptop has the same controller as other Framework
models.  Apply the presence detection quirk.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231206193927.2996-1-mario.limonciello@amd.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10031,6 +10031,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
 	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x0005, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0


