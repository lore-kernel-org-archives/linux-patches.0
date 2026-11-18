Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049552;
	b=Nr523UfQSrElWgerpTYH6c/Fffmg/CjOXY1UxSgQui/4hRjhEVzpTw2+kU0nVSFuOOvI
	 CiO6D/vmyNy1k1j1PKOjl81mRFtAg5dE1VtGOTtpDy1ZCmCiuUf5PEs/Ans01j1A9YpiC
	 pMuaKLv2dvKVms0+oF4Or3gtt4INUNCjChjipy6n+NJxvQikUbs505ORIGsMiokvdpYKJ
	 PrcHhhl3SPOMyA10VzzegUifnvgargGv7biWdQgmXcjkQaN5e75YQusPDvIdQSBLw5SyH
	 99imaGKkIDnI4yB3ellKCFtXjpmSiNc6LSx/vD9zEiSs+J82fpspUqiOd/WpIcCvJ/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=04RvtDA8i1kCtyff7Mn/85jI+T1PZIWLwjYeeWHDOOc=;
	b=PZVqwba2elLOYek9gOvo75VFwJF1/V1YV1Chfb2//91xe0MiGPoRj3VbdNluw+sExfLR
	 Ti/thH3MsuOUVAvI+1i9+kRkJCDPZRIPTM1DtxPM0mVfPZ+6vriAjWYNtVGwXb5KfYNbU
	 zihiVttGh0qHG38JHYM4BreiKEYywI+PeoVpCx7R5hXaE30T4JEPPisUGqDFF3HdhUUF5
	 fgQdTjMtz0ijhRr95UgykPLLl22eojM716+GrPpCfmtRd8iJ6reJrgoNIUbmuP+mbgSZy
	 9E0HUSCsbPAKjirBAT296jJuvOPbeVU3XeGNlLIB9xNzyb+KIxClxHH+eJKXw7O1sxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLYbu1L+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD23606A32A;
	Thu, 19 Nov 2026 00:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLYbu1L+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43CC1F000C4;
	Thu, 19 Nov 2026 00:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049552;
	bh=04RvtDA8i1kCtyff7Mn/85jI+T1PZIWLwjYeeWHDOOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLYbu1L+i07kkaX8efMToKbmJKCniT78WoycyDhTKok1gtpo1syNhbD4gYQ3qEPR9
	 iwnEcR2Dg0Cnml70uUFlodOq7u86s3G4xl3CD1/ChGT1UYGD+7DXmnXfoN8ujdz44d
	 CdCEO5EwLUeIUluxVe8Jr+xR047y4fW293RJPaHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2391/2857] platform/olpc: Reserve space for a string terminator
Date: Wed, 18 Nov 2026 15:57:05 +0100
Message-ID: <20261118150327.614892076@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 1fe88b1741ff655bb59e4fd78178fe2c557b9185 ]

ec_dbgfs_cmd_write() copies user input into a zero-initialized stack
buffer and passes it to sscanf(). A write that overwrites the entire
buffer leaves no terminator, so the subsequent parsing can read beyond
the buffer.

Limit the copy to leave room for the trailing NUL.

Fixes: 6cca83d498bd ("Platform: OLPC: move debugfs support from x86 EC driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260926121250.3258285-2-yaojiale02@163.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/olpc/olpc-ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index 921520475ff68..9e9d20343faab 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -269,7 +269,7 @@ static ssize_t ec_dbgfs_cmd_write(struct file *file, const char __user *buf,
 
 	mutex_lock(&ec_dbgfs_lock);
 
-	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);
+	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf) - 1, ppos, buf, size);
 
 	m = sscanf(cmdbuf, "%x:%u %x %x %x %x %x", &ec_cmd_int[0],
 			&ec_dbgfs_resp_bytes, &ec_cmd_int[1], &ec_cmd_int[2],
-- 
2.53.0



