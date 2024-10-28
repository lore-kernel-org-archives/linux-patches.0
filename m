Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E85615B10D;
	Mon, 28 Oct 2024 06:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097714; cv=none; b=bg+VcfB62fAlHC0LTrmHfWPUS58Spmj5gmQRxvcCo6VfTD0qP7KTX5mJLLtWxFrYN5tstAuipgIAw18wir0HqwA8CwBA9+NUT3RbigKDyB88+AYkBV38v69XFDcQcifMNj2gIIazm9paOkUJEbeC/3nCj5N3YO3W0SsP5G4vqsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097714; c=relaxed/simple;
	bh=GL6Ai4ymTdrmM8vI01obQovrdjZDwPNV3CbwuYNmRD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvcu9CVx5OTWruKbpImLPc0Ocj6id0XD1PZlC0ULL2KAdEv5ypTgH++DFdI3yD5PfY237pEjqyZODpmL/b43tfIKGCwwQbnD2o8wP2lOSm7owpE9uwTixuoMemuO4jV4wVYVifs9wsd96AAzj/Sq1WOMnpoAPZpZYuxa3/sYV6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5hYNMSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5hYNMSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D88C4CEC3;
	Mon, 28 Oct 2024 06:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097714;
	bh=GL6Ai4ymTdrmM8vI01obQovrdjZDwPNV3CbwuYNmRD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5hYNMSWs6KjyPfCso4g9bpKIuJMJ6ILzfpWllR4HnornUvWCEzoUHP/GiYXJnt5Y
	 ZDIK1775eQxpkvLw6JKQe/WdPbu3hihKq8UjoWB74Xt2C3GyQz7cmYuNyChk0MfzDC
	 19jh6HXkAoAvKPw+/fUW90f+hfPL852Gxd4NfsK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lawrence Glanzman <davidglanzman@yahoo.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/208] ASoC: amd: yc: Add quirk for HP Dragonfly pro one
Date: Mon, 28 Oct 2024 07:24:56 +0100
Message-ID: <20241028062309.513652858@linuxfoundation.org>
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

From: David Lawrence Glanzman <davidglanzman@yahoo.com>

[ Upstream commit 84e8d59651879b2ff8499bddbbc9549b7f1a646b ]

Adds a quirk entry to enable the mic on HP Dragonfly pro one laptop

Signed-off-by: David Lawrence Glanzman <davidglanzman@yahoo.com>
Link: https://patch.msgid.link/1249c09bd6bf696b59d087a4f546ae397828656c.camel@yahoo.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 248e3bcbf386b..76f5d926d1eac 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -444,6 +444,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A3E"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A7F"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



