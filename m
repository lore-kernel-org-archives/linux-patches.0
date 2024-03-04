Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E091EB5A;
	Mon,  4 Mar 2024 21:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587754; cv=none; b=ETcocxLWgIsp22n7829yal0PXFMa6jyVqR1PtBEP2lunYjRoMO1NJkArg8rhfJjfDmZPGY7ChB6J+XYeqivKpN9hDKFUWognJf6Eus+zP8outOcGPZvaBk0I57v6Sg4YbrzQT6cZ3GgmEeI2A6UTAGsKzTwmO8SNTYOw/o1LqQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587754; c=relaxed/simple;
	bh=8ucPpuAhe+YVrPROIuF0HLu27gj6W7zrqu4ZpWpeB7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqo0aIWs1+mBTloc3TjIJVlhjZ4YwJbhTyut3bR3280QdDKG5KxOel0rC4CqlPcwpLBYOwAjPMZxMarflQKKRsL/LKEfpYF5cQP7MlwIVbhCcYkd/8xCJgQ8WY8cJq3QVUWsFNTP+QQoR5c/jjOdPP/NljbSD+n+cs7E7q6hhnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iDoG1mT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iDoG1mT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30469C433F1;
	Mon,  4 Mar 2024 21:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587753;
	bh=8ucPpuAhe+YVrPROIuF0HLu27gj6W7zrqu4ZpWpeB7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0iDoG1mTu4s7D25ozneoCwJZn1R/yhwpdrAIqilN/P9FGF6U9+H3hP/3mmzpB+AbD
	 p+WdPFDxhK80LfK9TAbtUfAfclNQYSgWUOERPS8KpEhpiuV4hli1bAwiSnHDX3WnKu
	 DOkj4PCewFKbgVRMdPuz/wENcqUZZlHw/2X0x/4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 077/162] ALSA: hda/realtek: tas2781: enable subwoofer volume control
Date: Mon,  4 Mar 2024 21:22:22 +0000
Message-ID: <20240304211554.313441995@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

commit c1947ce61ff4cd4de2fe5f72423abedb6dc83011 upstream.

The volume of subwoofer channels is always at maximum with the
ALC269_FIXUP_THINKPAD_ACPI chain.

Use ALC285_FIXUP_THINKPAD_HEADSET_JACK to align it to the master volume.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=208555#c827

Fixes: 3babae915f4c ("ALSA: hda/tas2781: Add tas2781 HDA driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/7ffae10ebba58601d25fe2ff8381a6ae3a926e62.1708687813.git.soyer@irl.hu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9578,7 +9578,7 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = tas2781_fixup_i2c,
 		.chained = true,
-		.chain_id = ALC269_FIXUP_THINKPAD_ACPI,
+		.chain_id = ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	},
 	[ALC245_FIXUP_HP_MUTE_LED_COEFBIT] = {
 		.type = HDA_FIXUP_FUNC,


