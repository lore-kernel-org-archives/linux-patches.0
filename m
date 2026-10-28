Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216156;
	b=rlic+So9MChq0ejnlevIGval9BALp8FZfg3bmgmz6akA0AAz27aqYjl+s5KVRFT0zY14
	 jt3JqcGgLex4kWAUM8QGUjZ+DkZUMXNy44lGzBTXoedAuUw+ZPfwpTvwvJtrzuYnQpU0H
	 IH+wCIPzDcb/czBIvaV+dPLH9gT3rBqVvTxgvfLHrwD86GC8A2FwrdpD1Gvea6INF0MWM
	 B7IScLfGaD3yAzYrDHtXiG11KtLsieuALGx8k+UmgZV/rvM/97KfFPQmKuei4GWQ4bojr
	 werIkbnkxYw+f9ETJxqK40/DKZadssI6nrVDgcHqshre5UGG1wky4PoipA/KOImytIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wfajevJxFFjrPkmr1EGD8e15OTafxiYDSZCEZKH+ZRs=;
	b=Zso32ppqc8wxwDhogSPHtgLkmpBwLYSCW67zx1eMopkz9G4AAl4AfbJWuu3yCE1BXtq1
	 IhBJiN4wrLekLlU7OkDmmpfzRtV41UeJhRS8QaGqBvjdWOpyCMYF1sbju37wd+shdEfiD
	 yAeiHZRM4ZOjQ9jak//LDb6kZRI8oKd2o4VQEwpkr0qibJ+UHT6LoV3nJawRjq9WulD//
	 mI4X/J0I2phzay3vBnYv3g9WJGqQbNczwxkhtnyAHSDLrNT2579n8M+/Jl8hdc31u7cjT
	 TOTpNw0jKjCTYpEuEf2Sj0HN47QAgoV8kBbPyGhnuyOspf3/VPhNQXGqrj9EnVHot4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZO1+fDXF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8AF606A31A;
	Wed, 28 Oct 2026 19:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZO1+fDXF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D521F01828;
	Wed, 28 Oct 2026 19:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216156;
	bh=wfajevJxFFjrPkmr1EGD8e15OTafxiYDSZCEZKH+ZRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZO1+fDXFT5mMstmSBU7q2ArHMPhs+ScAvhlg2kphWhOwy5zJBzl83QbzO2e3bgoZf
	 hvfSeHFBryJKB/5bx+mx8KpefQp/W3OfK5embo1fHyMSaAXZKpCCHvy3zG/XYihyJV
	 LWL0EB/aVyVr8QViX8xmuTcISUZaDoGdJY5JCPq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1417/1887] HID: mcp2221: clear rxbuf after I2C/SMBus transfer completes
Date: Wed, 28 Oct 2026 17:58:33 +0100
Message-ID: <20261028170531.703960387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit db2333f88729c8aae062cb171ed058725ff5c901 ]

mcp_i2c_smbus_read() stores the caller-supplied buffer pointer in
mcp->rxbuf for the duration of a transfer but never clears it when the
transfer finishes or times out. Once the caller frees or reuses the
buffer, mcp->rxbuf becomes a dangling pointer. A delayed or spurious
MCP2221_I2C_GET_DATA report can then drive mcp2221_raw_event() to
memcpy device data into the freed memory, causing a write
use-after-free.

Route all return paths through a single exit point that clears
mcp->rxbuf and mcp->rxbuf_size, so that the existing !mcp->rxbuf guard
in the raw_event handler can reject any report arriving after the
transfer has ended.

Fixes: 67a95c21463d ("HID: mcp2221: add usb to i2c-smbus host bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-mcp2221.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index 4e52af7ec43f6..2356f5d7b3941 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -302,7 +302,7 @@ static int mcp_i2c_smbus_read(struct mcp2221 *mcp,
 
 	ret = mcp_send_data_req_status(mcp, mcp->txbuf, 4);
 	if (ret)
-		return ret;
+		goto out;
 
 	mcp->rxbuf_idx = 0;
 
@@ -324,7 +324,7 @@ static int mcp_i2c_smbus_read(struct mcp2221 *mcp,
 			} else {
 				usleep_range(980, 1000);
 				mcp_cancel_last_cmd(mcp);
-				return ret;
+				goto out;
 			}
 		} else {
 			retries = 0;
@@ -334,6 +334,10 @@ static int mcp_i2c_smbus_read(struct mcp2221 *mcp,
 	usleep_range(980, 1000);
 	ret = mcp_chk_last_cmd_status_free_bus(mcp);
 
+out:
+	mcp->rxbuf = NULL;
+	mcp->rxbuf_size = 0;
+
 	return ret;
 }
 
-- 
2.53.0



