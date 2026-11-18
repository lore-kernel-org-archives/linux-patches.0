Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061216;
	b=pTthgzTklQ80Vg7arRPLjKlkaMXUQVOwFwYl9IYu9Hgv8WxG+KIQAR0tXoMSBH2Vdu7Q
	 EJEk5dc90iTdln9B+AaYkScnyIhdShJPMEWpK6wO0i5trs2xivZgS9X0kTO/pRBa//6q+
	 XOXT2MEZeS65yglNMFRGux9/0L0/tShNE0sJVsVogSCNh0Ct5S/01BEXMgN7Avf25LLev
	 lCbqIIFguLkfgRU9oUyiaOvtAhbi2mjPRatcD9IpAW2RHsVNv1JipD5sxuk4A4vdYtvjW
	 1UNRstmxff3gPvV0Co1CbwssiFJoZqehLi4iKI3RyXqgEdLswo8eqtcqIEZfun9s5uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XhuY9+v4NWr74GavN86+ti7GQb8YUl6vBj58t+6fhvA=;
	b=DmBix/Sj93bmQhXEikpH/CtlkBfr+YMcXjr6rmn1X76ZovKEUv8SjufAZDWFqg4wCI+c
	 r/RmuULp2CjSBtG3gEVnyQbS3TDsOPjjG8HHfqXLmFd+En38EOVN1wxlTpDx5uMy/sjCx
	 Gfu+cZ+lAsBF+c0qAJpgmm98Zi0Mi2fE14W4Oj9nM1t7LxXArLoMru5WcpbtCoal29t+6
	 FcdC5Pi6rIOi+0Nm0x0uMX4omVbWgrE6+P1O+n/FUoeMEpv1RYm3168H8Y9nMdGyBlcaC
	 h7KtKWaAmmitmXfV7uvEcm3ApJVXCwFLWDlzlDGAmadnEsdK9cdc3JAgo9ZoGTN+dfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvQtXLIY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01141606A325;
	Thu, 19 Nov 2026 04:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvQtXLIY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522001F000C4;
	Thu, 19 Nov 2026 04:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061215;
	bh=XhuY9+v4NWr74GavN86+ti7GQb8YUl6vBj58t+6fhvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvQtXLIYtIqzKOa/yaG2ERBw7HeBdmx/L1r+O9pzG/iUiwyQwGsPvnzN2ewZQI20r
	 fZG65HaioWnZXJe5DnQdcCyP+VTkzidPgS3gbfTnRhcl7C+yHzXUWHCyBtMaBT/lHL
	 +GUMv5/F7/ZczDlsimMjC7ELiLA/XmwegzvyjJTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1474/1848] wifi: carl9170: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:58:32 +0100
Message-ID: <20261118150021.003416061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit ece30e1daf6a9c95d6f9d0518534a0b9c8c7fd42 ]

The "buf" buffer comes from the user.  We use it to store a number or
two so it doesn't need to be large.  It gets passed to sscanf() in the
write functions such as carl9170_debugfs_erp_write().  Ensure that
buffer is NUL terminated.

This is debugfs so it's root only.

Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Acked-by: Jeff Johnson <jjohnson@kernel.org>
Link: https://patch.msgid.link/674270ab4aeefa1982362c0ea4132427e14f15eb.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index 19009aafc4e16..7c4beb337b553 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -121,7 +121,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 	if (!count)
 		return 0;
 
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 
 	ar = file->private_data;
@@ -134,7 +134,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 	if (!dfops->write)
 		return -ENOSYS;
 
-	buf = vmalloc(count);
+	buf = vmalloc(count + 1);
 	if (!buf)
 		return -ENOMEM;
 
@@ -142,6 +142,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 		err = -EFAULT;
 		goto out_free;
 	}
+	buf[count] = '\0';
 
 	if (mutex_trylock(&ar->mutex) == 0) {
 		err = -EAGAIN;
-- 
2.53.0



