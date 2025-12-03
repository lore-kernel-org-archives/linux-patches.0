Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4282D314B65;
	Wed,  3 Dec 2025 16:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779930; cv=none; b=heRJ0nRG9sieoRWrIyoZlJek2BZZj6XUQRpdtGLgtMlIDWdvtK2cfS2FW7IDJJw/+nZ2ahkWgJ+DYI87OMznzCulxCUn5sHrEBlhVhLo6m6FkoMqd5nmhT6ukMhL7OXZeeIu8jGW384nXVBRbRWYMXtc9JGcwbRMdwvYo9bg7O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779930; c=relaxed/simple;
	bh=U8Umdr5YxMgnL7SJlbdAHtiaWJ3khUOHBRracd+TC2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWTT1yrZQSYfuS0Z1mY8jw6HEmWG9ftNN+IO83WXSIaK5lY4XpO+uGYabOuncqK1V4/5J2rfV0VCUxyxGCsHhgsIR49eiuIWmrv9zLAGmHkRQ9tuxsoTdLcVjHu0QDK6gzX5CSFmP3k2aiICas8JyFdsWthqZh9RC0UlKPCNX60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbX2EtuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbX2EtuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D117FC4CEF5;
	Wed,  3 Dec 2025 16:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779928;
	bh=U8Umdr5YxMgnL7SJlbdAHtiaWJ3khUOHBRracd+TC2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbX2EtuDn8Hbzo2qLZjZEXSWZjf5a74J4DRVWsAkJtn+apg0F6y2xds4dOUSJiJy7
	 0NgBvz5aG8Ld30iOPSk+zCXnVLECZxOU4eN1CiOOIJKUuldbmCrL5fnHFxqdSl5Esl
	 gTPIJFZCpyKAGGfYtBw5qoBCWm0kkbWrwAJDrJ0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Alexey Charkov <alchark@gmail.com>,
	Hugh Cole-Baker <sigmaris@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 405/568] mmc: sdhci-of-dwcmshc: Change DLL_STRBIN_TAPNUM_DEFAULT to 0x4
Date: Wed,  3 Dec 2025 16:26:47 +0100
Message-ID: <20251203152455.521964899@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

commit a28352cf2d2f8380e7aca8cb61682396dca7a991 upstream.

strbin signal delay under 0x8 configuration is not stable after massive
test. The recommandation of it should be 0x4.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Tested-by: Alexey Charkov <alchark@gmail.com>
Tested-by: Hugh Cole-Baker <sigmaris@gmail.com>
Fixes: 08f3dff799d4 ("mmc: sdhci-of-dwcmshc: add rockchip platform support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -52,7 +52,7 @@
 #define DLL_TXCLK_TAPNUM_DEFAULT	0x10
 #define DLL_TXCLK_TAPNUM_90_DEGREES	0xA
 #define DLL_TXCLK_TAPNUM_FROM_SW	BIT(24)
-#define DLL_STRBIN_TAPNUM_DEFAULT	0x8
+#define DLL_STRBIN_TAPNUM_DEFAULT	0x4
 #define DLL_STRBIN_TAPNUM_FROM_SW	BIT(24)
 #define DLL_STRBIN_DELAY_NUM_SEL	BIT(26)
 #define DLL_STRBIN_DELAY_NUM_OFFSET	16


