Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F89D3596EC;
	Tue, 16 Dec 2025 12:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886663; cv=none; b=Bvi5Vi6WVNq0A+BofRs0k5LncSMhH0T/tkjWY3U0KchABoayXBHtrxVNanwfUeV50lSIUoXlP3C+JJd/zH+c41UrPMFNH09Dgmc9vlvucmVKSBMwbka6WB/3rtP53BMNstADXcd+GTweWG+geVLBPbPlKbst58mZL8CEoX7w0n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886663; c=relaxed/simple;
	bh=8XfPQlbaJSvy0TINHjSxpry8VLqeDVMiKdcQfg48gi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUffFSWXhl/sB9bpE66inOt6dUuJEEx0+13GRMPFhMGNjBAL4O20sq4WWpVmSD8IHXyUlHGLQ90VaN29yt2D6t4hwlSfeC6O/SVMCdGgIRIahwSMf8b2NEes+yEkJ42yI+9oz7gB+aKlW5qqjYo8EPOMVRv5UJz5q61gY/pgOSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPl+cMOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPl+cMOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B11CC4CEF5;
	Tue, 16 Dec 2025 12:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886663;
	bh=8XfPQlbaJSvy0TINHjSxpry8VLqeDVMiKdcQfg48gi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPl+cMOGjw+Pux9pmPNVqzYJSJ96SPX1q2hHwbfRAok5CMZ4EBqtxO+U5xQrAjs3O
	 yIDMXt1dSehbiL8+APbJ98ybm5hhpFDJAaiu3+WAW/oKHz1EzQScu4kAlM2o3ZM6PS
	 Yq/68a34ui553ux3N+1N4R8zUjMmbJta1tXaRQwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 504/507] ALSA: hda/realtek: Add match for ASUS Xbox Ally projects
Date: Tue, 16 Dec 2025 12:15:45 +0100
Message-ID: <20251216111403.696452012@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

commit 18a4895370a79a3efb4a53ccd1efffef6c5b634e upstream.

Bind the realtek codec to TAS2781 I2C audio amps on ASUS Xbox Ally
projects. While these projects work without a quirk, adding it increases
the output volume significantly.

Cc: stable@vger.kernel.org # 6.17
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251026191635.2447593-2-lkml@antheas.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6725,6 +6725,8 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x12f0, "ASUS X541UV", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1313, "Asus K42JZ", ALC269VB_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1314, "ASUS GA605K", ALC285_FIXUP_ASUS_GA605K_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1384, "ASUS RC73XA", ALC287_FIXUP_TXNW2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x1394, "ASUS RC73YA", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x13b0, "ASUS Z550SA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1433, "ASUS GX650PY/PZ/PV/PU/PYV/PZV/PIV/PVV", ALC285_FIXUP_ASUS_I2C_HEADSET_MIC),


