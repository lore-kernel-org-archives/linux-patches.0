Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F161FF5EC;
	Wed,  7 May 2025 18:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643980; cv=none; b=IdT5+tSn4qcgtY5Q1iu6wkzK6B5UQGU6ypCQuyf4aiGcM+l+qSZ0nuSPgc/jQwohn0ETzXy6NwMTByJ1nF2VDIVKMeck7SfNPasgBH7XNStF+QO0w7x+HuyIel0hIeRx8TzmW1zhTWmNwr8NuLKCuCqzLibZBBydtXAWwmSEsHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643980; c=relaxed/simple;
	bh=5wPXc7uaUgRYr1Y9lF+McPK+SoYHav8eMxL8A4sVGas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBz1XdBBxkDgt+EBUpvwUZF+Onlf2Cvhe3v1U9GAowx759QFXjnZmtBrtQsxOuCWadlijZBA2CmV7jjRuSwKY04OBmnl8e1xd2cap8eh7Ybj0oeE6NSlIUyn2hL/2N5Duk2SKidfrPFPWipvmbZE1abBQZW9ipSZvLHhOO4fheM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8ddQepS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8ddQepS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEFDC4CEE2;
	Wed,  7 May 2025 18:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643980;
	bh=5wPXc7uaUgRYr1Y9lF+McPK+SoYHav8eMxL8A4sVGas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8ddQepS/5xm2nHvVwQXhxkIEodb5E2wT6WE13Zh6czSrEhrn6BNTEVgE9DrXXdA4
	 bsTwO2QbxQylTf6gxBQ6dizSqmdZqCyyOIb0Ae8RRcETz2s6oFUn4CaA6xpRyTiPiY
	 mJ51WmHThKjieTveU3GyBUzO/W8dtFEJXZFyA7xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nico Pache <npache@redhat.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	David Gow <davidgow@google.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 051/183] firmware: cs_dsp: tests: Depend on FW_CS_DSP rather then enabling it
Date: Wed,  7 May 2025 20:38:16 +0200
Message-ID: <20250507183826.758021166@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: Nico Pache <npache@redhat.com>

[ Upstream commit a0b887f6eb9a0d1be3c57d00b0f3ba8408d3018a ]

FW_CS_DSP gets enabled if KUNIT is enabled. The test should rather
depend on if the feature is enabled. Fix this by moving FW_CS_DSP to the
depends on clause.

Fixes: dd0b6b1f29b9 ("firmware: cs_dsp: Add KUnit testing of bin file download")
Signed-off-by: Nico Pache <npache@redhat.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250411123608.1676462-4-rf@opensource.cirrus.com
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/Kconfig | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/firmware/cirrus/Kconfig b/drivers/firmware/cirrus/Kconfig
index 0a883091259a2..e3c2e38b746df 100644
--- a/drivers/firmware/cirrus/Kconfig
+++ b/drivers/firmware/cirrus/Kconfig
@@ -6,14 +6,11 @@ config FW_CS_DSP
 
 config FW_CS_DSP_KUNIT_TEST_UTILS
 	tristate
-	depends on KUNIT && REGMAP
-	select FW_CS_DSP
 
 config FW_CS_DSP_KUNIT_TEST
 	tristate "KUnit tests for Cirrus Logic cs_dsp" if !KUNIT_ALL_TESTS
-	depends on KUNIT && REGMAP
+	depends on KUNIT && REGMAP && FW_CS_DSP
 	default KUNIT_ALL_TESTS
-	select FW_CS_DSP
 	select FW_CS_DSP_KUNIT_TEST_UTILS
 	help
 	  This builds KUnit tests for cs_dsp.
-- 
2.39.5



