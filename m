Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4749B1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AA9C433D2;
	Wed, 28 Dec 2022 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243796;
	bh=Az+C2DkIvphMvXJJFfptiK2CQLMYct9hBqhW2Scu1yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRdbjrppcmM0ClaHKLJChHLh0GBxnPRb3U2IxpPim/KoeoVMtnJ76TZjRK0jNiDCD
	 Sofjhc9D+OknPBjPyWzC/KJ5aX7fFM+HoIDTKZyUug8dBM6kbXkT5jyKxKOm3UMy09
	 SAuQoyThZGct42gOQk6a76RLQC3JYuWElgNnUk28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0557/1146] Bluetooth: Fix EALREADY and ELOOP cases in bt_status()
Date: Wed, 28 Dec 2022 15:34:56 +0100
Message-Id: <20221228144345.298799241@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 63db780a93eb802ece1bbf61ab5894ad8827b56e ]

'err' is known to be <0 at this point.

So, some cases can not be reached because of a missing "-".
Add it.

Fixes: ca2045e059c3 ("Bluetooth: Add bt_status")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/lib.c b/net/bluetooth/lib.c
index 469a0c95b6e8..53a796ac078c 100644
--- a/net/bluetooth/lib.c
+++ b/net/bluetooth/lib.c
@@ -170,7 +170,7 @@ __u8 bt_status(int err)
 	case -EMLINK:
 		return 0x09;
 
-	case EALREADY:
+	case -EALREADY:
 		return 0x0b;
 
 	case -EBUSY:
@@ -191,7 +191,7 @@ __u8 bt_status(int err)
 	case -ECONNABORTED:
 		return 0x16;
 
-	case ELOOP:
+	case -ELOOP:
 		return 0x17;
 
 	case -EPROTONOSUPPORT:
-- 
2.35.1



