Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351333793CE;
	Thu, 20 Aug 2026 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244414; cv=none; b=gBhhYNd6JUZfYLuE38LzMp9a4el8covu1nV63tC6bdu+j/DQhdsLj7iDq3I/HnZhW/aUL0kmHjJy+zJaZBoS5ZVhM0LtAIIaXLUvYVT2c33OjPiupoanMOqInNL0KaG1fnigbbsvUCLMoMh5r5BQV3uQ6bkuWqj1NhrTCMD4zHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244414; c=relaxed/simple;
	bh=9IjrqmAux05TJUNqqKpKVluDs945eRVMdG7VznPrlZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGzHhyeIjCOqxMsVkRxVGa0fLmWh6PsFLojwDSNMKfQx+DQ+ED3xdcFqDJyIEnsMidLzupJCAIlY/8+xMCYlc3KCNMl2S2X15aFkyj68bjkVvbsfjHHpIK9tkBOJrMpQPRRhuvtPFs1vAokQDjZD9a8ZrbkbDVbb49MYYcbrcRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6rw+pCj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6rw+pCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6DE1F000E9;
	Thu, 20 Aug 2026 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244413;
	bh=V1tCZXvK588h4K/clyuTUTbovv8KHZamUWeKUTQ3SzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6rw+pCjJLJaJ9UpLTpYoQ+iPyACsDoZj7oHJr0ybH9JBR5zPc6O+zrdXDJeMeC2k
	 /xXMYq2dNXHUy6esntevA2iYJpprhoP4RHmmKmYE09vv3dnqPEvcm1f5FuzU+zoQi0
	 UmXOuzX9WARH8HTMaI6Ey2FAUUsLdxYPo4yGz814=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Plowman <david.plowman@raspberrypi.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/235] media: i2c: imx219: Correct the minimum vblanking value
Date: Thu, 20 Aug 2026 16:56:36 +0200
Message-ID: <20260820145221.332961263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Plowman <david.plowman@raspberrypi.com>

[ Upstream commit e3b82d49bf676f3c873e642038765eac32ab6d39 ]

The datasheet for this sensor documents the minimum vblanking as being
32 lines. It does fix some problems with occasional black lines at the
bottom of images (tested on Raspberry Pi).

Signed-off-by: David Plowman <david.plowman@raspberrypi.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: 2c4f1ba73543 ("media: imx219: Fix maximum frame length in lines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -51,7 +51,7 @@
 #define IMX219_REG_VTS			0x0160
 #define IMX219_FLL_MAX			0xffff
 
-#define IMX219_VBLANK_MIN		4
+#define IMX219_VBLANK_MIN		32
 
 /* HBLANK control - read only */
 #define IMX219_PPL_DEFAULT		3448


