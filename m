Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60ED27FD49;
	Wed, 23 Apr 2025 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419615; cv=none; b=chancR8HQf1bPwOoivy77wrx5vXdElgXxnO//4rKFqtPtUCFx3ZPOhE5rm8GxXsUIqE2gsBeSJc01lnmJXJXi2TT3be2dHcQBQILXRMxJtdcv3AgrDW10AEqogNy174nPvWYIwSdcd6JMJeTbQ8t7G69lgMrSHJYhlxmc9gO3LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419615; c=relaxed/simple;
	bh=Ij2Skx1UqL30yxzXhDFIZczhE83DF8V0DtWUKM0g2RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rU8p/edaPpXDaZqFsnmjrFhLFNB5dgu1d381dPleCo9P9EtD0HVHXZPuikpGpxeeU3xbOekFRqDlGYHCCiEG4YHxuB+MRDW2anLr1+ux05o7aw5Ym3nCzVd7rVSlPdK5rsApa4lEP1OaoqROeTfaqpxkAmHPhBOpz1WI2OZBPSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4y9knpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4y9knpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB12C4CEE2;
	Wed, 23 Apr 2025 14:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419615;
	bh=Ij2Skx1UqL30yxzXhDFIZczhE83DF8V0DtWUKM0g2RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4y9knpME1WFWsaJIkp5ZEon28b0AdWzQzWqPK82utOi1X17qHsAP5mXyGjdlei5w
	 eQ3Kz4v9hpfzNFSuH1wPsRidP0QcLtG8ezU4cwtJqeTjtxzWMewvEBFDX8z0icyBIe
	 KoWW3TfAer2xlMuuNbiWw7Sh1eQnzCaBO6UgQ6sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/223] ALSA: hda/cirrus_scodec_test: Dont select dependencies
Date: Wed, 23 Apr 2025 16:41:33 +0200
Message-ID: <20250423142617.981215446@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit e9c7fa025dc6125eb47993515d45da0cd02a263c ]

Depend on SND_HDA_CIRRUS_SCODEC and GPIOLIB instead of selecting them.

KUNIT_ALL_TESTS should only build tests that have satisfied dependencies
and test components that are already being built. It must not cause
other stuff to be added to the build.

Fixes: 2144833e7b41 ("ALSA: hda: cirrus_scodec: Add KUnit test")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250409114520.914079-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/pci/hda/Kconfig b/sound/pci/hda/Kconfig
index dbf933c18a821..fd9391e61b3d9 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -96,9 +96,7 @@ config SND_HDA_CIRRUS_SCODEC
 
 config SND_HDA_CIRRUS_SCODEC_KUNIT_TEST
 	tristate "KUnit test for Cirrus side-codec library" if !KUNIT_ALL_TESTS
-	select SND_HDA_CIRRUS_SCODEC
-	select GPIOLIB
-	depends on KUNIT
+	depends on SND_HDA_CIRRUS_SCODEC && GPIOLIB && KUNIT
 	default KUNIT_ALL_TESTS
 	help
 	  This builds KUnit tests for the cirrus side-codec library.
-- 
2.39.5



