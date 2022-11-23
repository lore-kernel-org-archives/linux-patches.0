Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1101C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31D7C433C1;
	Wed, 23 Nov 2022 09:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195891;
	bh=3rrB4DSeXqgBgmYgLkVpBE4d+QmXYAW5M8u0tbqCAfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toB5zXB1o87P5KiGGFeU4wbtIRIstPlMx3IB48rHD27Y3luznJA5SZrdsniuOOGK3
	 juzkYrVgX0V3cu0W1rg6tZ9rRV/2d6VEfeXMFsb4719r/6+yOMVlp6jw1neNK/0LH+
	 uS9i5jUJZKsLGcJoRFSvp/LDTzkCOoAN33j881SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Tedd Ho-Jeong An <tedd.an@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/181] Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
Date: Wed, 23 Nov 2022 09:49:54 +0100
Message-Id: <20221123084603.739545024@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f937b758a188d6fd328a81367087eddbb2fce50f ]

l2cap_global_chan_by_psm shall not return fixed channels as they are not
meant to be connected by (S)PSM.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 16f954a4802c..761efd7da514 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1990,7 +1990,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 		if (link_type == LE_LINK && c->src_type == BDADDR_BREDR)
 			continue;
 
-		if (c->psm == psm) {
+		if (c->chan_type != L2CAP_CHAN_FIXED && c->psm == psm) {
 			int src_match, dst_match;
 			int src_any, dst_any;
 
-- 
2.35.1



