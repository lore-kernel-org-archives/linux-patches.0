Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC295674E;
	Wed, 23 Apr 2025 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419737; cv=none; b=tShA9hsmE6Dmwn4MRasa55n/K/AObwv8Y1tYhxwnPCrFQimcmnCrN9fjKTu1JW2+bfJvbeUG2u85QurdEpVJKIsynY7prgqhv7VZlunMGLJPZN7aO9ptlDtTFf5DuoHX7Hu8KAGPSwRwbcecls+PwdlZusvp1kHwYexmzwh+ouU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419737; c=relaxed/simple;
	bh=6b4dpYPhbEXYrSrhZcGn9zkobVSQCHvfLqLCdiKQ1mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DacTH3rz56cfCvxsJhb4+B0bEJD5coS4jtvGg0EsykpXRR4u6C+NlGFDhEfeqrTESr3PwXg/o1mg8dFYT78KJPsQml/7jOisApcM+JGDWYXw7Uwxpu4/9L9OwSHFyOXZRDVH2IHZ+PDqgJqY4QeeuKA0q3k7I65j/YU3dJR3Obo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RogRtzVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RogRtzVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81138C4CEE3;
	Wed, 23 Apr 2025 14:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419736;
	bh=6b4dpYPhbEXYrSrhZcGn9zkobVSQCHvfLqLCdiKQ1mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RogRtzVNz6k2Wrk2cL+0lRtj3bGQuzzS7pFbNt06PxCRGK8sD1KN2HOgYkj+c0mHP
	 bMCJC2+bV4xlQm6X5+pEoEke+W1KESCrVvoAlaesj/zXwIqV+RSXt39P1JokOeWL8f
	 R8B4ly8rPQwGomQw/wykvGeqyk4fvDvnwHsIK+TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 018/241] ALSA: hda/cirrus_scodec_test: Dont select dependencies
Date: Wed, 23 Apr 2025 16:41:22 +0200
Message-ID: <20250423142621.261715107@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 84ebf19f28836..ddbbfd5b274f5 100644
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



