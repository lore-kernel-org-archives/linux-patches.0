Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49E028ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2135C433EF;
	Mon, 12 Dec 2022 13:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852576;
	bh=FL0FOTJJ/qrVP1nyrQUDU0ioCJE7D//1YdPTBN3xRAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpBVnqavfzf6jUhpRyuIzFBdZo6sSyAzwYK7/vBZJzxHfbXBELDfUfBvuUE4R2Bcn
	 gu2v3OVonKQEBRT80lXK7xoAvMTAljzo/ejG3zWshpEOskVkfXXKgV5b/K+5wEyzVu
	 sdNyALJiF6Hpu3qEij0aKwuCQmlRJ9UTEka5xu7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chethan T N <chethan.tumkur.narayan@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 108/157] Bluetooth: Remove codec id field in vendor codec definition
Date: Mon, 12 Dec 2022 14:17:36 +0100
Message-Id: <20221212130939.183507671@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chethan T N <chethan.tumkur.narayan@intel.com>

[ Upstream commit 93df7d56f15e217009323c0fbb5213ab7a14520b ]

As per the specfication vendor codec id is defined.
BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 4, Part E page 2127

Fixes: 9ae664028a9e ("Bluetooth: Add support for Read Local Supported Codecs V2")
Signed-off-by: Chethan T N <chethan.tumkur.narayan@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index a3c7dcfa0a05..4518c63e9d17 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1431,7 +1431,6 @@ struct hci_std_codecs_v2 {
 } __packed;
 
 struct hci_vnd_codec_v2 {
-	__u8	id;
 	__le16	cid;
 	__le16	vid;
 	__u8	transport;
-- 
2.35.1



