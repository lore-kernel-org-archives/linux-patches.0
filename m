Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021367;
	b=E+TdTTJCwhBFaAKp9tbqEHJqhwlTLlJeNwxqn/ym8zK19YvnDPO4PKKrsGL1mrO/2YUn
	 bhXP8bn/wddKW2D9cpwZSCGouSt/9JT/WY+hD5HW+oCN2WnvrwcFYY/+7B9R8y0OiRk9V
	 f4hVQzZ9M3Iy74Q8N3oxXX1UK5AvTPyoJ4rpsG7bwcO6Knki3w5peyzfUqwt4eMAodVuX
	 xNQ+g4+2C4kHNFtTIclmN/uIiBsOwJCHgnMmtoMCm/4Vy13WigFMWd3jxUxYY+Ljbsjig
	 14kN0J0D8bINfdnyzuVLzUjhHE9KTrJNMu35J3CXFxfOpQqeHrhPWXXayURakX2fW1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=svcFdLpFivdgvXvQm6U39nSUp3+5uKLlReDKotZoB08=;
	b=Bp9IqUUiB0bOHKSlwKix5YUZy+b1bWndN3XCQLPvJJ8/aQgZVUthtjS/HIl3yNSSlVsI
	 3N1FrUhgbvqDLopiIVS1j1Qj8//9/bwZzmovIxQaYOMO+4bVumvM/gm0mERvSlM0welGi
	 lQVJoc9vVnwSK6X/bGDV7ymO32JJfQixXzPtvM1wYKXeuy6Eh9zzbbBwnOYrN7FeaBkY0
	 ehEQJb88XL5WZTPmHpm+/PGHvLq8P5UTFPzZJC467QS3eapPi0FXZE7iur/aX4iiicNNW
	 W7o5opuCsxn2f76ub+BYXMMCmcvtYqZTWm4Qg75YT87pIwj0TEu8/cLvUMWfPQr9WUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOCQc2Te;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA7C606A325;
	Wed, 18 Nov 2026 17:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOCQc2Te
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCFE1F000C4;
	Wed, 18 Nov 2026 17:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021367;
	bh=svcFdLpFivdgvXvQm6U39nSUp3+5uKLlReDKotZoB08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOCQc2Team13lnip+P/nIZLvT9HsxLuhRtg/BfiHLJqmpdn/7ejlyqFo/bsrd8Ode
	 gZgp8gRUtDrBCFQWhOChH2LHVpV90qchXTmixiUuUvt519WXuvG9bh6l+J278UwoLe
	 r3d5KEXgTL/JqXuU96z0cpDvn67pv2XmLn88nNxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2283/2651] ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 15:58:43 +0100
Message-ID: <20261118150407.492598991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit 2bc1d25fc8597fa6cbf6b1ff92653881939a6436 ]

fsctl_query_iface_info_ioctl() used to call
netdev->ethtool_ops->get_link_ksettings() directly and never checked the
return value. If the callback fails, cmd.base.speed may be left
uninitialized. Also, SPEED_UNKNOWN (-1) is treated as a numeric link speed
and would be converted into a bogus link speed.

Use __ethtool_get_link_ksettings() to acquire the per-netdev ops lock when
needed. Fall back to 1Gbps when the query fails, or when the reported speed
is 0 or SPEED_UNKNOWN.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1c8037c85de95..26dc8933e2a0f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10683,6 +10683,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	struct sockaddr_storage_rsp *sockaddr_storage;
 	unsigned int flags;
 	unsigned long long speed;
+	struct ethtool_link_ksettings cmd;
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
@@ -10717,10 +10718,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		nii_rsp->Next = cpu_to_le32(152);
 		nii_rsp->Reserved = 0;
 
-		if (netdev->ethtool_ops->get_link_ksettings) {
-			struct ethtool_link_ksettings cmd;
-
-			netdev->ethtool_ops->get_link_ksettings(netdev, &cmd);
+		if (!__ethtool_get_link_ksettings(netdev, &cmd) &&
+		    cmd.base.speed && cmd.base.speed != SPEED_UNKNOWN) {
 			speed = cmd.base.speed;
 		} else {
 			ksmbd_debug(SMB, "%s %s\n", netdev->name,
-- 
2.53.0



