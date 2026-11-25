Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617819;
	b=LWU4AopebTTG8DDTb6dgjL3SlMISyysM7iz1JlIFpdzo2+BC6dYqes3jx1HLABoJ9aLy
	 EMwA5kZoGfr5jQI16hgdtWUKQ+T8wIKVMbODkw4P/70QrLL1M7AyiYi/nk8sUqfeI2rY0
	 ZnzPCCd2xbtxzQrFySIUoKrTyE8aYW/tHkl2/2l01aTwf8yGJo9O+stJgaxRzae3a8d2W
	 FQYL2i91Zj21QnGYsvWS1EiAtIV+458g/jft/SS0vjut1giMzcbh91BRuGk5/zI+/hb/v
	 Dj6O2EQSHnxa610k9zj6fpVul3AlF3JBlMvWYHowsdpX4zpO+IkV6MEh3+mGxIemKPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6A9NQIB1ZV1KThynGwm+LAuoUVKs1IAyokVJbnN9U0c=;
	b=eEbB90tiXoaBaLMJ/UjKOKs8MLdducLEPurbvIc0nfhJ0EA1jCqyoQBm6/sk2VZGqQ7+
	 8k5e1LJgw1TIoN4+9YsDKt2lNhC1dx/KPvclPxyo7oflfKY0b7FV3i6CMmbYrolMZsTEv
	 3tF4r+nY9sV8xzmPhxHJNLFyKCw4enmRUoBonGwACi4NE/TAKXxdFwg0adUfbCrU3o6Sd
	 856X7dwwHgHgQADbSt9Y/m0nryfNGcyDtqCg2+p2o3KbexCga4rsr/78xGNvmT5M9tfkG
	 71oN+gTJE+ZuOLcZQA6GeZRrcbI7QX59ZiReWt+1lzKDH/nlVd2CfTciAnHUXt+zlnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGu2m5vC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10700606A321;
	Wed, 25 Nov 2026 14:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGu2m5vC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6571F000C4;
	Wed, 25 Nov 2026 14:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617818;
	bh=6A9NQIB1ZV1KThynGwm+LAuoUVKs1IAyokVJbnN9U0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGu2m5vClFtz6TQmrj5Zu+570knqfNRVq9h/U008Gy7dX3jNJQObh/sDDLcfL7nBb
	 DxsKyNjyj0AyGGr5JJrcqakqNk5pyHFpxjvyEI3DKfcBvBTlFYaZsc2BCg/Xz+5F6x
	 AhZpkI3fh5spK6vpT84fqJsKJ1WUyIY1ODAl2A7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0085/1005] net/smc: fix limit_smc_hs sysctl on big-endian architecture
Date: Wed, 25 Nov 2026 15:23:43 +0100
Message-ID: <20261125143823.732045965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 162cf592b577cccf04515100563e819d9eba5c4a ]

net->smc.limit_smc_hs is a bool, but its sysctl entry uses
proc_dointvec_minmax() with .maxlen = sizeof(int), so the handler
accesses four bytes at the address of a one-byte field.

On little-endian this works with the extra bytes being written in struct
padding. On big-endian (tested on s390x) the bool sits at the most
significant byte of the int therefore the bool stays false and the "1"
goes into padding. The sysctl reads back 1 but SMC sockets created
afterwards see limit_smc_hs as disabled.

Fix this by using proc_dobool() handler and adjust the maxlen to the
right value.

Fixes: f8406a2fd279 ("net/smc: add sysctl for smc_limit_hs")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20261028225350.3753-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_sysctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index 09dad48337f61..f58cf256f61ab 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -160,11 +160,9 @@ static const struct ctl_table smc_table[] = {
 	{
 		.procname	= "limit_smc_hs",
 		.data		= &init_net.smc.limit_smc_hs,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(bool),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.proc_handler	= proc_dobool,
 	},
 	{
 		.procname	= "smcr_max_send_wr",
-- 
2.53.0



