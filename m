Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829409;
	b=y7GcCEOdXZElJU8vcZkDUb++DTlRQuChxzcL1X9EIaZNLkiSo+nuTQvZiWRpkKSRMWC8
	 RR5JOnACUMYmpw3CtEo4gPCbTfpyqPXttfY2K9cCKjsi4dLKysEQkHMEBdU+cB3nDpIQ+
	 pC0tysPTJjRPS3F3fR5teaiDhM4qMa59GVMDCzWxPStfUG2BFvpBSj+Idz/f7NzHfYKQH
	 LJEtwNCnn9Qn/gVd5esaIf0dOD5NupljJlYngyKrFOTGooDHr/YWQ4eC6fQejqNUdKOfZ
	 D7N8BGx3ioEoVwI+Q+WdSkbDa4p+WxuRhWgphgpc/V1c4fYrUOchmg7KSp25uaG1EQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ets7bNxwBH3mLoU2HCjojr3F2kwFKfJn+hNW4XIdthw=;
	b=v9G0nT2Jm/6NaP/+3/po8UY3NTWyE7Yowcgc/lDeNwIEzGW7u40BVFZANylj25i8DmEu
	 KBEWft8J464A+UB26GQhwujFNKQ5Yssz0xxuzOv8x/aSEfOjw23IKC/xjebsVCSx20yd8
	 vAyFVAwS6dA3pBOGsQ9gAwbA1v9IwoKAqM8wWs0D13hQpeiG2JMHWbycdw5clOrJNuwmS
	 /mIBCWn9R1QRyGxqlZlCctyxb+X4VasrgGNlHiMTNSWA9AiTZXQtXtrR/vyGEFZv5K1fS
	 5fIlRv1LBFGpmQXFu8F5deMDX+fytRak8fmSueNLfAaPpY5mhP05TIF239W3v2aw5tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ypl/Wq2U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669AA606A865;
	Wed,  4 Nov 2026 21:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypl/Wq2U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59441F00A15;
	Wed,  4 Nov 2026 21:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829409;
	bh=Ets7bNxwBH3mLoU2HCjojr3F2kwFKfJn+hNW4XIdthw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypl/Wq2UuPkWLcphUNOjsxLVToCIFWi0Mm+2917iPpoKvxOXVRnRKhW2uFyUkb6bd
	 sonOS1Y0GRpNxLKIsQCPU5Sd8XIRbrOJazJv44n2M68vvf1FGn5WkcTZ6DEJdoZHVU
	 l1I+vV69Nt2HclR44ojZeteFiwBR/znxrndWXNAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devansh Soni <devanshsoni874@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0109/1005] staging: rtl8723bs: fix missing unregister_netdev on sdio_alloc_irq failure
Date: Wed,  4 Nov 2026 15:57:22 -0500
Message-ID: <20261104211046.703770643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devansh Soni <devanshsoni874@gmail.com>

[ Upstream commit 51b554f1a758570159a770983c7a0ccd7c761491 ]

In rtw_drv_init(), if rtw_drv_register_netdev() succeeds but
sdio_alloc_irq() fails, the error path jumps to free_if1 and calls
rtw_sdio_if1_deinit(). However, rtw_sdio_if1_deinit() calls
rtw_free_netdev() without a preceding unregister_netdev(), freeing a
still-registered netdev but leaving stale sysfs entries behind.

Signed-off-by: Devansh Soni <devanshsoni874@gmail.com>
Link: https://patch.msgid.link/20260619125724.12458-1-devanshsoni874@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index ae379e99736ad..e9bf6c3b18af0 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -379,10 +379,13 @@ static int rtw_drv_init(
 
 	status = sdio_alloc_irq(dvobj);
 	if (status != _SUCCESS)
-		goto free_if1;
+		goto free_netdev;
 
 	status = _SUCCESS;
 
+free_netdev:
+	if (status != _SUCCESS)
+		rtw_unregister_netdevs(dvobj);
 free_if1:
 	if (status != _SUCCESS && if1)
 		rtw_sdio_if1_deinit(if1);
-- 
2.53.0



