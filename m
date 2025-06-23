Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF1270838;
	Mon, 23 Jun 2025 21:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715924; cv=none; b=p/doNTUV1mSTJqszRVuyj0X1JQikxXEfW6gg6F2q7kKzgX/hjanmXc/tHJIW2j44L+8DjsKdBYwAxDgUjjFp5zvhdA5FQLibrAKGVeTaUmWxfuFYK5GSpSMwR/9g1oFVJtVP+fY86J4iJEaPcYouCRRcqXN93o4N/Ra7n4smIOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715924; c=relaxed/simple;
	bh=JDTCA6z+QIQsaIB1vTvpWze+bDRbZMXFkyng3oSvHu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUODbXlmhzX7rfr1iXmpi6ppZPaD0+0/1OUVXXFipI6dBfbDrAjqmdNpa9JRGvzm53ogUUBtJGzvKbDIT0x0WPj4dbHVE+zvrdvrCw3Jyj0qEXjKiP0BIqwxEIHIkPodCDrD/TJjwzhw6WYRJzs4xRP95LrPBCZ2f2PhhHKCC9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VK4q1+1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VK4q1+1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4286AC4CEEA;
	Mon, 23 Jun 2025 21:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715924;
	bh=JDTCA6z+QIQsaIB1vTvpWze+bDRbZMXFkyng3oSvHu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VK4q1+1oz2T/YIPKR7aQWYG+0z5rblvjjy2/j4xqah0k30svyh9fqQYWC7cegPGYd
	 9iNB5hgYzBC2XLaK+AOx63NYoxSgRHLXC8Z+XwlARGGG0mGZwFNrWuZCpmn053+YU4
	 U3LZux6Bu1+1bLYECYe9O/jPAjuuc+VPdMrdXrYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 491/592] ALSA: hda/intel: Add Thinkpad E15 to PM deny list
Date: Mon, 23 Jun 2025 15:07:29 +0200
Message-ID: <20250623130712.111369662@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2276,6 +2276,8 @@ static const struct snd_pci_quirk power_
 	SND_PCI_QUIRK(0x1734, 0x1232, "KONTRON SinglePC", 0),
 	/* Dell ALC3271 */
 	SND_PCI_QUIRK(0x1028, 0x0962, "Dell ALC3271", 0),
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=220210 */
+	SND_PCI_QUIRK(0x17aa, 0x5079, "Lenovo Thinkpad E15", 0),
 	{}
 };
 


