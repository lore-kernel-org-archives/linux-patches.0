Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB951170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D7EC433C7;
	Mon, 11 Sep 2023 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441897;
	bh=J0mk+6ba9dlKGCFSkmaCDTAssUKf+Dbzbj6dsAnTvig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nx3pL7exgYbIUTAJ+pY5OWhpVs6ssYqp/CERFnquxajFSE7/nPJoLzLKoiovRsv8x
	 eystlNHWvPyANL+bFqGJnMCbFfLc3+zS+HhKMznxww4+YDKsUuU7tR+QIX2PlDYYin
	 hByM9iOSJlmtEY/xb/WriEQwjbN0oFXDXW7UZgLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 574/739] Documentation: devices.txt: Remove ttySIOC*
Date: Mon, 11 Sep 2023 15:46:13 +0200
Message-ID: <20230911134707.138921559@linuxfoundation.org>
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

[ Upstream commit 27681960f05515555441d7bf58d565cbc68137f3 ]

IOC3 serial driver was removed, remove associated devices
from documentation.

Fixes: 9c860e4cf708 ("tty/serial: remove the ioc3_serial driver")
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/f13b5c64f8cb6d8f2357d7be14397676b27ac2a2.1691992627.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/devices.txt | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-guide/devices.txt
index 75a408f72402c..1ba5b7c4973cd 100644
--- a/Documentation/admin-guide/devices.txt
+++ b/Documentation/admin-guide/devices.txt
@@ -2694,9 +2694,6 @@
 		 49 = /dev/ttyCPM5		PPC CPM (SCC or SMC) - port 3
 		 82 = /dev/ttyVR0		NEC VR4100 series SIU
 		 83 = /dev/ttyVR1		NEC VR4100 series DSIU
-		 116 = /dev/ttySIOC0		Altix ioc3 serial card
-		    ...
-		 147 = /dev/ttySIOC31		Altix ioc3 serial card
 		 148 = /dev/ttyPSC0		PPC PSC - port 0
 		    ...
 		 153 = /dev/ttyPSC5		PPC PSC - port 5
-- 
2.40.1



