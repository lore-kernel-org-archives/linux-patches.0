Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E5318E368;
	Mon, 28 Oct 2024 06:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097880; cv=none; b=JrQBNrVwqTCYJTCiOU9x99S5l39QqI20AK8IiX9BVZXvFvv2KfR4BQd9fC5oBEJTke6oS5Fpun18Whjf7+OTDxhvubAuHmPTn32Lww04OwFFSG0P5+OVr39eD5prce5s0ys1o9z3TCZlmCQYdLepELNEtloFwzNi0ivvaDS3ueg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097880; c=relaxed/simple;
	bh=gwyjGZ7gIxawOm9nlsntJXMI31uTP3DY0kV0+A4bqLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHbkUS/Iy1hDAYKOw/ahOdhGoWDumRi8Nqanc69pLDZqZC3NJZmLpV4julRaepvKiM+iHzRbqfDJx1DezoV0rLY1R49DG+0H7DmYOMlo7p836BcdyxwKZjChLeAO9fj9Zzf1g6p8TA3bysN9jVQt+/Tked6TELOgSveLym/w2mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjMVf9mV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjMVf9mV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D550CC4CEC3;
	Mon, 28 Oct 2024 06:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097880;
	bh=gwyjGZ7gIxawOm9nlsntJXMI31uTP3DY0kV0+A4bqLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjMVf9mVt2XGKmhmF6FWBHIPKr9qZoUILz14sNbH8K9VvRqa7vHkDBHzGagrPt+vc
	 O7ZU+LDZKQukIQ7V9Kob4q/FTbPlH4V4fUOo3H7c1faqqkie3z0CSH8JYd3qzI9yIE
	 g+jLUIC7PY43Y+1cWOuLqQjgSgaM4Orty8fz9r4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 189/208] ALSA: hda/tas2781: select CRC32 instead of CRC32_SARWATE
Date: Mon, 28 Oct 2024 07:26:09 +0100
Message-ID: <20241028062311.285455107@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit 86c96e7289c5758284b562ac7b5c94429f48d2d9 upstream.

Fix the kconfig option for the tas2781 HDA driver to select CRC32 rather
than CRC32_SARWATE.  CRC32_SARWATE is an option from the kconfig
'choice' that selects the specific CRC32 implementation.  Selecting a
'choice' option seems to have no effect, but even if it did work, it
would be incorrect for a random driver to override the user's choice.
CRC32 is the correct option to select for crc32() to be available.

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://patch.msgid.link/20241020175624.7095-1-ebiggers@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -173,7 +173,7 @@ config SND_HDA_SCODEC_TAS2781_I2C
 	depends on SND_SOC
 	select SND_SOC_TAS2781_COMLIB
 	select SND_SOC_TAS2781_FMWLIB
-	select CRC32_SARWATE
+	select CRC32
 	help
 	  Say Y or M here to include TAS2781 I2C HD-audio side codec support
 	  in snd-hda-intel driver, such as ALC287.


