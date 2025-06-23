Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE762C9D;
	Mon, 23 Jun 2025 21:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713616; cv=none; b=Kohd4FSwSp6G2bPZd6kygvyiHKtTeMZ+5e8nFzh9qB9jdzMUgJrqyNTKhqUvZgrjgq3toEjdQI84nEOZ6iFmsQpg1g3JcuAKItb+Q69R4NeWgQ7wsle1ANKv7/y10u2lhxpO5HLT1joZdYrlVtoL9cTQqYKD9Z102fLyOyk8X5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713616; c=relaxed/simple;
	bh=1AyLYxWJpO2hPIqKYwQxOUQczggIFYHhWVVzYHsxJiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKq8bEVi5lXWyjrGPaIPvjmY7241sfDolgcLdMJr1pppon1b07CoEw0313S+ah8F5gB7L7QdubHLvyO3btMYacTqU9fQSgNKEqJ+YDnzlDT8gQ/y/d+8Uh10xuj3BI5HIQ0+xM4Yq1QGyLvihR8JNyDGIXVeM2U535LkWKLtPj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPevE2Cc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPevE2Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5361DC4CEEA;
	Mon, 23 Jun 2025 21:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713616;
	bh=1AyLYxWJpO2hPIqKYwQxOUQczggIFYHhWVVzYHsxJiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPevE2CciOJThtsYBQMWzPrPHyif9ZKEQJPm1e92hnF1S+tyyN2Ix1iFf9CotavIJ
	 XpROwE6DZMlVj9wCoxxjN2lUKcTAZ6kRfSf5Rcmi7dpXYiQk/OoiIvWH30bEIW0unO
	 zqZXz5arPtOUHXWMywnCES12H6AyUIF9Dk1olaMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 196/222] ALSA: hda/intel: Add Thinkpad E15 to PM deny list
Date: Mon, 23 Jun 2025 15:08:51 +0200
Message-ID: <20250623130618.125610299@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2261,6 +2261,8 @@ static struct snd_pci_quirk power_save_b
 	SND_PCI_QUIRK(0x1734, 0x1232, "KONTRON SinglePC", 0),
 	/* Dell ALC3271 */
 	SND_PCI_QUIRK(0x1028, 0x0962, "Dell ALC3271", 0),
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=220210 */
+	SND_PCI_QUIRK(0x17aa, 0x5079, "Lenovo Thinkpad E15", 0),
 	{}
 };
 #endif /* CONFIG_PM */


