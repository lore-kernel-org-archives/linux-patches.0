Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051452;
	b=BMHCK3HFJ+3fKqfdWfRt8/hAn/WAR+RG9+VqW32d4GTKFQxm0t5EuqnI+u8SCAnVJxmd
	 ZbwinnslDqrRzl1v1Df8xMSuIy/yji6iirU99JZ2xpOEmrBMR4Ot1kSKAr5D0rnRIqQQE
	 cYDePmuacecSHoozvJ5smqG/s03xSLoegBA2vwmIYzRSm3ze+jLswmVjsDbcOaclyTHcU
	 y1VI7GbtwtaWfR7a4BzQ8QlLSUiHLQI4sP0cFpAdPSmDPCCvV+321lWdVOgaFDXA6bCRL
	 qfE7VAaDHF742hWN6vKPqWCB3rlI+jvQFAMQQPDjDr31PGK2xmcAijYC9rtnmVUt/7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ty0QA7juvh5nHd5y81OKa8Jv1EHBaEurWETDK0Tg1w=;
	b=ZTQdlFD+CxjGlO3cFSe7vfEUmLfS3BD1gxZbt01dheh44Z9WHb8aVBXWThdZWwmkXtws
	 Bj6eMXcrrljTAggLKR9CjbgYnuVCkYPDhNJi7g3QwM2oy8k46t3y9wvw+g74Oqhay2Le+
	 nP5DAczsGwVPErw+ppG4cEllxRvMICHkI7Hs5Sx0HAf7LR++CMplo5Elym/IGoQuMRomB
	 lPHchXXAWD46UhPw/PMpw1cLaOykGk0jlQR5MaoOTQ1toThIICPS/NA64gv5gu7qxUXLi
	 rrYwn/EGo4E2Rudydy5dfV4F4RPF1BpySUEqweVHdWXEIdyirSIaf+GJHiDQ098STRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUUFdE61;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AE4606A320;
	Thu, 19 Nov 2026 01:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUUFdE61
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9901F000C5;
	Thu, 19 Nov 2026 01:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051452;
	bh=6ty0QA7juvh5nHd5y81OKa8Jv1EHBaEurWETDK0Tg1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUUFdE61ePnKrgaLchF+yZoCoO14a1W44N7+0vKVoM8UC/iYdbBlTWKiF0mAOwKkd
	 01UUX792eX9fVafsYgrV+ZB+BdcUxYUuFVoazyZB88GEla9Uv2kD68JVN87oZljk/U
	 eQFm9g/OEDf+hBtnBgGZZd6W1Yh7T0lKthAcLr40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0179/2214] HID: rmi: check report length before trimming sentinel bytes
Date: Wed, 18 Nov 2026 15:30:55 +0100
Message-ID: <20261118150017.208403908@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 28a3e326fad2451bdb66b747dd1f7ccbb900eed6 ]

rmi_check_sanity() trims trailing 0xff sentinel bytes, but its loop
reads data[valid_size - 1] before checking that valid_size is non-zero.

Reverse the condition so the length is proved before the last byte is
inspected.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-rmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index a7d268ac45c49..e57b628db964e 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -386,7 +386,7 @@ static int rmi_check_sanity(struct hid_device *hdev, u8 *data, int size)
 	 * such reports here.
 	 */
 
-	while ((data[valid_size - 1] == 0xff) && valid_size > 0)
+	while (valid_size > 0 && data[valid_size - 1] == 0xff)
 		valid_size--;
 
 	return valid_size;
-- 
2.53.0



