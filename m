Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45E64ABBB9;
	Thu, 17 Sep 2026 17:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667245; cv=none; b=ieHBLEbyGloaG4FTVeL2KVXEk4GsCEvX6gg3AN+HlBGAFrXbIUvoqSHsVzuYCTj3iDFUOOgH2wB/IH9DCx2ycOPWNfUTfui7CnCHEgtbt4ILe1Uiyer7LlrRzNIHsk9uATRfN/8FzasTAeISPXB1zL0TQma+PHY0mhfmFDn1BBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667245; c=relaxed/simple;
	bh=XTQjmyOTbRDoyPnoZscuMSJnr4kRNMURW08fUZmxw3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpRVE5rRqnYbJhlvxJv7dU5oTBdNT6fh26Qw50R2NNYr/vMQPhWJYp6pNqrArOXwiQaUffspfj/EBNvZtFHIx/97oY/6p778zGVCBRWhEFtb7it8ztJy4uIOL2BWp4nDozAsEHzFIHsWt0Gciz6jPn6mqKirRSY5ceHKqr05Uys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9MwJ+dL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9MwJ+dL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279921F000FF;
	Thu, 17 Sep 2026 17:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667244;
	bh=NenelXMwPtfcxqilE3nQ+jxCCRM3nh0ObrbU8zlsNio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9MwJ+dLf34Dsa/0SyE8RTIntposWiikwacWFI9aI2O1WEJBYg2a27Kxrg5mHUlEK
	 IbZWCzfMmmSRXrgg/ww6UpYwT7yNRvdBpt67UJAEyk2ABJkAMwe8V6ikRw59BTGfXp
	 CP85HXcr38AD/qqDTIh+eC9QMTA8iZEiBjK9NXsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0028/1102] soundwire: intel_auxdevice: Add cs42l43b to wake_capable_list
Date: Thu, 17 Sep 2026 15:59:31 +0100
Message-ID: <20260917151540.143792121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit be6d8daaab654e9b0a8508757534d556d399d0cd ]

Add cs42l43b (both packaging options) to the wake_capable_list
because it can generate jack events whilst the bus is stopped.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260429153614.741899-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_auxdevice.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index 61f07d2d75efc..078f9eaf5161b 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -47,6 +47,8 @@ struct wake_capable_part {
 };
 
 static struct wake_capable_part wake_capable_list[] = {
+	{0x01fa, 0x2A30},
+	{0x01fa, 0x2A3B},
 	{0x01fa, 0x4243},
 	{0x01fa, 0x4245},
 	{0x025d, 0x5682},
-- 
2.53.0



