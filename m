Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27303C5842;
	Tue, 16 Jun 2026 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632873; cv=none; b=t/BKhE2P1k8APw5UpIe0GY3FjHuGn//zzvfyt0oeTaJmhPYa+ACJO//zcVV9qMS+uO8XEyaFOaGhCj3rFN3+pC/2qCM1sUagZwR8rLeMrYs2APZQzjt4zk86/2F854wpb7s+C7UXRyV0SDH8UhJ8RoBCX5fcSri+ZjU0WbeqAHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632873; c=relaxed/simple;
	bh=vxBSZ+GbesXQaQMe7XhD4z9Qog5/YI/TKoJY0QN6F10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hu3l6Q+CDyTsqu5t5i/I09tf9/Rcq1BSjNQ3QgOKxGVIQbQaH4JTic31Z6xdpS/czfWM003k4gRa8t18+itAZ75GktVrrHIuG2mU6VW5+dO7JRZRDaeDSONQMKdQxVAEqIuceE71tSNVKx0ifdB1shU89HR3HQ2e21RDOHAZyLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeF2KFtN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeF2KFtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D48C1F000E9;
	Tue, 16 Jun 2026 18:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632872;
	bh=Ek/V/NhfxJC3xBlwFCdE4c22b0MS24nLTpweSAFsPlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeF2KFtNgrNMwtJFAhML0lOGEERnQeY4Jllo/v2UO8HJSDPdkGK9lics5HPVfJ4u/
	 Ojb1Of9AjLwCG1fA9AOgoOFxpvfwN40NUorieYaV/RHWtG6NmafVmm67v8xqEtewoq
	 VK4+jeFWkOKM1s2HUXnqRw6voU8TLBT1+TAjlZkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Erhardt <aer@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 494/522] ALSA: hda/hdmi: Add quirk for TUXEDO IBS14G6
Date: Tue, 16 Jun 2026 20:30:41 +0530
Message-ID: <20260616145148.898363391@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Erhardt <aer@tuxedocomputers.com>

commit d649c58bcad8fb9b749e3837136a201632fa109d upstream.

Depending on the timing during boot, the BIOS might report wrong pin
capabilities, which can lead to HDMI audio being disabled. Therefore,
force HDMI audio connection on TUXEDO InfinityBook S 14 Gen6.

Signed-off-by: Aaron Erhardt <aer@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260218213234.429686-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1999,6 +1999,7 @@ static const struct snd_pci_quirk force_
 	SND_PCI_QUIRK(0x1043, 0x86ae, "ASUS", 1),  /* Z170 PRO */
 	SND_PCI_QUIRK(0x1043, 0x86c7, "ASUS", 1),  /* Z170M PLUS */
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
+	SND_PCI_QUIRK(0x1558, 0x14a1, "TUXEDO InfinityBook S 14 Gen6", 1),
 	SND_PCI_QUIRK(0x8086, 0x2060, "Intel NUC5CPYB", 1),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", 1),
 	{}


