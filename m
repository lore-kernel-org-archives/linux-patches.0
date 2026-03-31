Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4192D73AD;
	Tue, 31 Mar 2026 17:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976453; cv=none; b=SLEHlmG2pRci656SmLLnrfPddkfmRdzXAMATpZISxgmagg87vSQ3/hmLhyX4n7+hzLs7QvqEvWKQ0Z6e7+5qcM40Mop4atrosuX7B3M88kjYV56pqdJod9BcXKEr+/LloKshBjVWMlo6wy9rnBXrH/WiWkhxf1+Sx++0yCza1Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976453; c=relaxed/simple;
	bh=f6s7IptUZHoo+ycQngdFYdYVCH5xwuIHwhouCy61Yag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1kHFxn5IAFsB3A9DkFwwQ8M1b7n3jxEwDs05su3gOTJF14HaiPt/cTfB6JgBiFyJTnOaGGft3AQDWV3IXFIi7UAEwXAHteDi+1PtHoEmfvf8KmF/aB62YYS+79e/Xw+GOwRBIEsUhyalgb/VEUhZaMdjefMfLmUTAew2yM3G4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIPr8/6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIPr8/6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B06C19423;
	Tue, 31 Mar 2026 17:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976453;
	bh=f6s7IptUZHoo+ycQngdFYdYVCH5xwuIHwhouCy61Yag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIPr8/6s9tjnpsYuyK1A4KFRGuxxYF1OydCNJsKX+tTf6syoHlCl+KwoRfh0+33YJ
	 cggjRF3r3fojJkQlS19sUTHJf4+/ajYXrqrtAPiVO9s9xK5suYNqdmyIe+xGEozbv5
	 bU4VXO6cLhkY/5aRkR/D52+/8L59O3+G4cUAOwbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/309] ALSA: hda/realtek: add quirk for ASUS UM6702RC
Date: Tue, 31 Mar 2026 18:19:29 +0200
Message-ID: <20260331161755.916846415@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 0d3429f12133c2ca47aa82ddab2342bc360c47d3 ]

The sound card of this machine cannot adjust the volume, it can only
be 0 or 100%. The reason is that the DAC with pin 0x17 is connected
to 0x06. Testing found that connecting 0x02 can fix this problem.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220356
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260306123317.575346-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a42c3d43f5d93..38fe144e6238a 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7104,6 +7104,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1e93, "ASUS ExpertBook B9403CVAR", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1eb3, "ASUS Ally RCLA72", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x1ed3, "ASUS HN7306W", ALC287_FIXUP_CS35L41_I2C_2),
+	HDA_CODEC_QUIRK(0x1043, 0x1ee2, "ASUS UM6702RA/RC", ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x1ee2, "ASUS UM6702RA/RC", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1c52, "ASUS Zephyrus G15 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
-- 
2.51.0



