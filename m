Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE0463B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E747BC433D2;
	Mon, 20 Feb 2023 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900566;
	bh=W8VtXmAHNG0O/c4phLMZVw/qnHDdDAoil+tA0LeEuEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+UrpN4rLdwh+shABN1YrgTEosheok7iLbBcTiv9ZiVUElS7uX7kUFFNddqU4FYyi
	 Dt3UZ50EYeTntnZEZa7asusxg2n7S4TuH1KDs0kZTA813rI8WKRyE5QHMH965fF4uX
	 u8/qmVN1BLayc+LBflZnMdiruE/k2fcQAP1zc56Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 73/89] ALSA: hda/realtek - fixed wrong gpio assigned
Date: Mon, 20 Feb 2023 14:36:12 +0100
Message-Id: <20230220133555.713596609@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kailang Yang <kailang@realtek.com>

commit 2bdccfd290d421b50df4ec6a68d832dad1310748 upstream.

GPIO2 PIN use for output. Mask Dir and Data need to assign for 0x4. Not 0x3.
This fixed was for Lenovo Desktop(0x17aa1056). GPIO2 use for AMP enable.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/8d02bb9ac8134f878cd08607fdf088fd@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -771,7 +771,7 @@ do_sku:
 			alc_setup_gpio(codec, 0x02);
 			break;
 		case 7:
-			alc_setup_gpio(codec, 0x03);
+			alc_setup_gpio(codec, 0x04);
 			break;
 		case 5:
 		default:


