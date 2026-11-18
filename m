Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015392;
	b=ab7Oi4aJcLVeEPm+vHTTDybmrhf1s/Siw9/bofbG/I0U0cjVYkt6w0rIVCXQleinQXAB
	 274QFXjpX4oDMSu1mvsNByeajZaanL6W93UBQ3xbOndQ52aO6PT9/pdaJpouCN99hJV+S
	 glaxdxKATSiabDGTfkHYThroaFbeFuk6dYNrbZk4G1tu6E1NqrxnkuFDBPRniwwvgBomU
	 8p/T+oS9L+TNvjJbCQMLpPjKwENZxGjpttYAKwD9hItadw1BCQ6pjtvLcD8wK8DoPLcrE
	 jsc7l2rhNh7oFQzNGbebf2xwdKhtv+7bZkZH/UUtWEATQ9q2iX23+qP6QvL6gyQ3ZcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bHvpJBzqKxevo/gaZp1k7mRr+LHqEOHS1PTiWeM6r7w=;
	b=onJ+HI5Ef3l7LwnQ/mg1K8iX1AYJC60aRwuSNORb9u7/xYyVKbR8SHADtv1Hp3RtBpmm
	 orfhI0xtVs4f27rSboJVu6SpMEH8kyCSYvDZYnYVMG2yNAxiPeTcHsn8lWp9nelMYcAfW
	 MvOuo93uf76JmoJ8I29I4jCu+NmPH3Vk/v93kn/En0rIqguTnSzPKozggCGThS8goJOC1
	 t90x5M8TJ0VxhUI4NBwETOOkcY/5bFhkdXFawX6DWJhlPA82X9THo3J1z3QfTDpBrbyJm
	 1Vu6NBicsTj8OsrwKHbaMSGKue0SJta5T4r8mlsizQuDdSeKaV4c6lP8vcoBOuL35LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cm4Xufcv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A286606A31C;
	Wed, 18 Nov 2026 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cm4Xufcv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD17A1F000C4;
	Wed, 18 Nov 2026 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015392;
	bh=bHvpJBzqKxevo/gaZp1k7mRr+LHqEOHS1PTiWeM6r7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cm4XufcvM5kWnwj9BXwgv7bVFitWk2lMPV16T4/uVWSF1j7syanDgQ8On8Q7uM0A3
	 VPOYbdxC/Ksi/VSVq+7BUlWS+wrLKkl7JPpe0cfcVx9r0/QVF00moYn0DDO7eKnXqi
	 a6HOClCmY/mcHjEetTExz6l9s75D9aVjJhiAdlwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0155/2651] wifi: mm81x: fix type bugs handling sdio_readl/writel()
Date: Wed, 18 Nov 2026 15:23:15 +0100
Message-ID: <20261118150253.434869654@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 37f018809909dfc99646b1b1f79c2b3968e7890a ]

The sdio_readl() and sdio_writel() functions, instead of returning kernel
error codes, instead stores the error codes in a parameter.  These caller
functions pass should pass an int pointer to store the error code but
instead pass a signed long.

This will not work on big endian systems.  On little endian systems
passing a ssize_t means negative error codes are converted to positive
values near UINT_MAX.  This doesn't cause a problem at runtime because
in mm81x_sdio_reg32_write() the error codes are discarded and we always
return -EIO.  In mm81x_sdio_reg32_read() the high bits are truncated
away so the positive value is re-converted back to negative and the
code works as intended.

Either way, passing an int is the correct thing and is a cleanup.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/aoa7Hj1W7ETOrOzO@stanley.mountain
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/morsemicro/mm81x/sdio.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/sdio.c b/drivers/net/wireless/morsemicro/mm81x/sdio.c
index 96fce187dd352..65277399bf189 100644
--- a/drivers/net/wireless/morsemicro/mm81x/sdio.c
+++ b/drivers/net/wireless/morsemicro/mm81x/sdio.c
@@ -381,7 +381,7 @@ static int mm81x_sdio_dm_read(struct mm81x *mors, u32 address, u8 *data,
 
 static int mm81x_sdio_reg32_write(struct mm81x *mors, u32 address, u32 val)
 {
-	ssize_t ret = 0;
+	int ret = 0;
 	u32 original_address = address;
 	struct mm81x_sdio *sdio = (struct mm81x_sdio *)mors->drv_priv;
 	struct sdio_func *func1 = sdio->func->card->sdio_func[0];
@@ -391,7 +391,7 @@ static int mm81x_sdio_reg32_write(struct mm81x *mors, u32 address, u32 val)
 
 	address &= 0x0000FFFF;
 	sdio_writel(func1, (__force u32)cpu_to_le32(val),
-		    (__force u32)cpu_to_le32(address), (int *)&ret);
+		    (__force u32)cpu_to_le32(address), &ret);
 	if (ret)
 		goto error;
 
@@ -411,7 +411,7 @@ static int mm81x_sdio_reg32_write(struct mm81x *mors, u32 address, u32 val)
 static int mm81x_sdio_reg32_read(struct mm81x *mors, u32 address, u32 *val)
 {
 	u32 value;
-	ssize_t ret = 0;
+	int ret = 0;
 	struct mm81x_sdio *sdio = (struct mm81x_sdio *)mors->drv_priv;
 	struct sdio_func *func1 = sdio->func->card->sdio_func[0];
 
@@ -419,8 +419,7 @@ static int mm81x_sdio_reg32_read(struct mm81x *mors, u32 address, u32 *val)
 					 MM81X_CONFIG_ACCESS_4BYTE);
 
 	address &= 0x0000FFFF;
-	value = sdio_readl(func1, (__force u32)cpu_to_le32(address),
-			   (int *)&ret);
+	value = sdio_readl(func1, (__force u32)cpu_to_le32(address), &ret);
 	if (ret)
 		return ret;
 
-- 
2.53.0



