Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050303;
	b=cKr17/NNsK+PX4e7YHeWzzgiP4i9q47dcDpBCKMaDPipkU5y4yY7ifKp/RRCrNT713AF
	 GFRh/R7sbto5KUUjhA8KI77yhW4JJGVX8sfU0q5QKhjH6I33AAD6nPW6Awo9szawU62Qi
	 Ix2xij1BEedHLv5q4ehINevScQYWGQ2prZYmG5HFjoPixSsf4LWcQHMkdoDGPg9iorCGC
	 vCRe99DqvrPoloqzgVy0FiibGIEaesC811DZM17jdVkJkAkJ0T4o048mIK4CIWz1LpZXW
	 GzbY6kQZBkTi/KOGr2jPCuydmbyQddgoskBUJtwMysqf1mY2/k+rJbFG6CZRZGEqZDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rb2Du6npXX9C0vFQsTQ+EmLNfKFqV1KpUxoNfEdA9yM=;
	b=UBI2zODdkkyaES+mYawvwTttYRM9JPqlURCImyvJ3nPSv2W5vvt7yPnWpNSABnboVAmg
	 Ax2KxrekwSaa/aScwciQqoU5+Z/A1vaMjmUgxnuwUfJBl+IRde0cKWOFvonFx7Z7FFftf
	 h6S+sOVF7482zs1KVi97XWZP52Q8mQL3zg9JyGbYNDI2fhlgwIPtyxFbzuDReB3Wa5G/b
	 2+OVS5YLybd1aR/7CO1QlDO9tpisBW4zlJOEA5Ie1obvPyBsErhPCU+41aZuKRJRE568r
	 djwcCD3FPQbKXN0Mq5ua2LIH1Nx9SoyXbwd6T50C1npJZOfTqWQg8vwS4UUi0ZKx0ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQQ7RkbJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D569606A31C;
	Thu, 19 Nov 2026 01:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQQ7RkbJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953CE1F000C5;
	Thu, 19 Nov 2026 01:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050303;
	bh=Rb2Du6npXX9C0vFQsTQ+EmLNfKFqV1KpUxoNfEdA9yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQQ7RkbJb7QLLF0jnz1mige+k2hGdZOGzHZueaZk2ddOn3xal49lnfLf9vywI7Kps
	 BpdfTfQoad7ele1TPouv+M9TQFX7CAsAhxETCgUYU6fP8k60F3Q+HiH7I8TtK7NDZm
	 skaGyp1J8LmHCWUjI2cXpdNgb0TuziA9OF+xPqT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2659/2857] ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 16:01:33 +0100
Message-ID: <20261118150337.318072336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dec5da960af52..f55672f08a20b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7730,6 +7730,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	struct sockaddr_storage_rsp *sockaddr_storage;
 	unsigned int flags;
 	unsigned long long speed;
+	struct ethtool_link_ksettings cmd;
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
@@ -7764,10 +7765,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
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



