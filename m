Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BB9168C1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C51C433D2;
	Mon,  8 May 2023 09:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539449;
	bh=R84EjpR6lRw95i3R8EXGT3NFX9+u4bkn1K2sBj0XC7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RL9GDHaN5DmtUBba5TfLx0zMhDkwU7vKsG5QtDwR78xu5hR0N495VcUI/PabuEAvr
	 9IKGZgf33jZF+B8XCILSi4kRRg9KrTd+g/hjrhrOpN2DwlriJDxwo8MbT9jX6fqny9
	 vIIvZLgggUHRAmM2RBsPddDvZ4ZiihkgYxqqZy1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Syed Saba Kareem <Syed.SabaKareem@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 021/611] ASoC: amd: ps: update the acp clock source.
Date: Mon,  8 May 2023 11:37:43 +0200
Message-Id: <20230508094422.407886243@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Syed Saba Kareem <Syed.SabaKareem@amd.com>

commit a4d432e9132c0b29d857b09ca2ec4c1f455b5948 upstream.

Updating the clock source from ACLK to default clock

Signed-off-by: Syed Saba Kareem <Syed.SabaKareem@amd.com>
Link: https://lore.kernel.org/r/20230331052102.2211115-1-Syed.SabaKareem@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/ps/pci-ps.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -98,7 +98,6 @@ static int acp63_init(void __iomem *acp_
 		dev_err(dev, "ACP reset failed\n");
 		return ret;
 	}
-	acp63_writel(0x03, acp_base + ACP_CLKMUX_SEL);
 	acp63_enable_interrupts(acp_base);
 	return 0;
 }
@@ -113,7 +112,6 @@ static int acp63_deinit(void __iomem *ac
 		dev_err(dev, "ACP reset failed\n");
 		return ret;
 	}
-	acp63_writel(0, acp_base + ACP_CLKMUX_SEL);
 	acp63_writel(0, acp_base + ACP_CONTROL);
 	return 0;
 }


