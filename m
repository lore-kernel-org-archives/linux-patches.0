Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056711;
	b=0dPPWHxjjittBoUpYSJDFcPhqe48d/AVM6DGCHcRqmavtynfUVqTKKHmEKCLfkH45lth
	 zuqBCUgPJ45YQ91IgHg6Dx09mtydNkk8Pwqloqbatb+cVImPN7h14vDxdQV2YMTdMFfg+
	 dk6Jw9zof6bNiQZWI6vAzsmqTvjlKLVl0eB1bKDijhyhozlPt7cLcNa8a1DmTvOCDgpDu
	 kfwRLwdADp0fRgTby/mSZ7dRMKcUICJFZNA7KcooRjrL5gp7XH7ecNRG1dWLUBTfJe7Km
	 3ii1MfRcKBH6+A4MBD9DOyeWnlRwH7/F9AsVywNUgBCYuOriE4fWhY4Cc8mQ97PBBDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nl+vb+5UfAUIh8LOdieyoIzBOCZquWu7qi2FENmoA5o=;
	b=pVZxV5rTc7Kyu8xJk07EOurFjDJcfurJ3Otkv2VkSMUcuo+Uul6DlqWZdpCRWKxR0yeV
	 jLihLOWit1kKcTieIIkLuzaF5e9nOeqxy6wbUtWF11yl4VD8xWmRX1UZldE/5tGbDftVP
	 OZ8yodkIUE/gpEeHVLBI6JP75TBq4CO+Qd0r2JQ4TBGxE/X2OoGSYcHW8oPc/8YScLxh0
	 vBpqYGro2w1REdQnLABz2O/ddw0IHGZanCFsAwIUBOmgpsYMLshqUqjRYjxQY3tuSEx7m
	 f617l5prtAVKRfNdvaJUphLNN6NNHfk88emG+PM1hMPxi4QzZviSom4SKA51mMlDWgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FntmQ1RT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54024606A31C;
	Thu, 19 Nov 2026 02:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FntmQ1RT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC371F000C4;
	Thu, 19 Nov 2026 02:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056711;
	bh=nl+vb+5UfAUIh8LOdieyoIzBOCZquWu7qi2FENmoA5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FntmQ1RT9aCKB7mUvdnXLSmu0vWTE411UfvFykudPjVhCBBYLR6ofSo1PoAE8N3dM
	 /G5gQGTeRO+kwu4ThW69951N4a+r77LuALczPR0QM6dZ3v4h6LV35biY1LZs39aN/m
	 T3DH/WaBUZnip940TzwQ8V2vyCR8mFbuIa9rzrvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2078/2214] ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 16:02:34 +0100
Message-ID: <20261118150133.746463097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/smb2pdu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index da69dd9488f2e..367fe6d53aa62 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7557,6 +7557,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	struct sockaddr_storage_rsp *sockaddr_storage;
 	unsigned int flags;
 	unsigned long long speed;
+	struct ethtool_link_ksettings cmd;
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
@@ -7588,10 +7589,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
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



