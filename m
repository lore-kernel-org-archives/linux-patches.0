Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04291170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30840C433C8;
	Mon, 11 Sep 2023 14:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441894;
	bh=Dh5bkD2v5lO44nje3QGcH0fscoGjOJlJyA60koBFXCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baUieoN11N/9dpQBmHkKAenmTqLbEiDFBTymI2l5K/emH7HEXfxYpSvgKd0FZjtgl
	 dvsxiXKqsEZLa7/leX5aLKdTzALPv3/U9djOyuMvTXggyzwi8IrdmdXw87jToyaRuN
	 cZXbrfJsFUllagPkIW5k/5eofjPjqpArKRejpxi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 573/739] Documentation: devices.txt: Remove ttyIOC*
Date: Mon, 11 Sep 2023 15:46:12 +0200
Message-ID: <20230911134707.110830987@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit e327fdc262345ca37b358a51ff0c0046ab1b8d15 ]

IOC4 serial driver was removed, remove associated devices
from documentation.

Fixes: a017ef17cfd8 ("tty/serial: remove the ioc4_serial driver")
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/b5deb1222eb92017f0efe5b5cae127ac11983b3d.1691992627.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/devices.txt | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-guide/devices.txt
index b1b57f638b94f..75a408f72402c 100644
--- a/Documentation/admin-guide/devices.txt
+++ b/Documentation/admin-guide/devices.txt
@@ -2692,14 +2692,8 @@
 		 46 = /dev/ttyCPM0		PPC CPM (SCC or SMC) - port 0
 		    ...
 		 49 = /dev/ttyCPM5		PPC CPM (SCC or SMC) - port 3
-		 50 = /dev/ttyIOC0		Altix serial card
-		    ...
-		 81 = /dev/ttyIOC31		Altix serial card
 		 82 = /dev/ttyVR0		NEC VR4100 series SIU
 		 83 = /dev/ttyVR1		NEC VR4100 series DSIU
-		 84 = /dev/ttyIOC84		Altix ioc4 serial card
-		    ...
-		 115 = /dev/ttyIOC115		Altix ioc4 serial card
 		 116 = /dev/ttySIOC0		Altix ioc3 serial card
 		    ...
 		 147 = /dev/ttySIOC31		Altix ioc3 serial card
@@ -2762,9 +2756,6 @@
 		 46 = /dev/cucpm0		Callout device for ttyCPM0
 		    ...
 		 49 = /dev/cucpm5		Callout device for ttyCPM5
-		 50 = /dev/cuioc40		Callout device for ttyIOC40
-		    ...
-		 81 = /dev/cuioc431		Callout device for ttyIOC431
 		 82 = /dev/cuvr0		Callout device for ttyVR0
 		 83 = /dev/cuvr1		Callout device for ttyVR1
 
-- 
2.40.1



