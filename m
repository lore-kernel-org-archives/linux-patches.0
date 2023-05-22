Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9D7171B7
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4413C433EF;
	Mon, 22 May 2023 19:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784376;
	bh=0FgOAeLWITfHqxmvydovCvhdnSidBbTih1SuweCVZcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tluOI+znHUz51SIdgKH72sx3Pqi9RqtswkaR9UYQeBO2FLRyfeWg9wW/bEknM5DAc
	 gTUycQC0oS839M280bDfmLRaNgh9fWsctOWk3cTuU8GhqhqEI5Z3hPsnhJ4iqcgkqq
	 VJH7nnS7ErgiSwGbXyvu1Biv7GJ3gE66gl9zALdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 060/364] media: pvrusb2: VIDEO_PVRUSB2 depends on DVB_CORE to use dvb_* symbols
Date: Mon, 22 May 2023 20:06:05 +0100
Message-Id: <20230522190414.290722502@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Rix <trix@redhat.com>

[ Upstream commit 1107283b3351bef138cd12dbda1f999891cab7db ]

A rand config causes this link error
vmlinux.o: In function `pvr2_dvb_create':
(.text+0x8af1d2): undefined reference to `dvb_register_adapter'

The rand config has
CONFIG_VIDEO_PVRUSB2=y
CONFIG_VIDEO_DEV=y
CONFIG_DVB_CORE=m

VIDEO_PVRUSB2 should also depend on DVB_CORE.

Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/Kconfig b/drivers/media/usb/pvrusb2/Kconfig
index f2b64e49c5a20..9501b10b31aa5 100644
--- a/drivers/media/usb/pvrusb2/Kconfig
+++ b/drivers/media/usb/pvrusb2/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VIDEO_PVRUSB2
 	tristate "Hauppauge WinTV-PVR USB2 support"
-	depends on VIDEO_DEV && I2C
+	depends on VIDEO_DEV && I2C && DVB_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_CX2341X
-- 
2.39.2



