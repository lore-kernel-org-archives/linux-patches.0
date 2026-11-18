Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051051;
	b=XALMhNeFcYTuqV+5VEMYJzMiCIBErnv3mRn8icnDka579+rBA4sODGEJ3/jhR2cORhiS
	 iy+6c4GTdF5kUNO/MtGBO/V/aAf6o/G8E8C5+r1vos22hxa1yKBiCIPDgkgxTFOz6APtI
	 qCUlakN5vfCyYDh0PcqKg2rW1GKGfZI2YvOppa9wzEMqVFzJ5Ha54w7DvUZEM0vduV2U2
	 GQun1Wu9TQlo7pk7LrRof0bCSk+j2zjjeDBEFgN9aKHJSaMHUGF1X+i3M7w8hpShiutZu
	 fO9iU/mYKi2PRsuD6PQf1cOzzbKTHrA7VmI9PuK8RQ0wNvrtg45sSwt6ixJqPhYDlcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bieOWp3JkdagOxz0XG7e50bzhX/+i7eX8+IrxPUbNTM=;
	b=gTBlNTodrkEIsW0zQZYmklPQgBl8G6qv0jyrIUqqOdHxRmiS1rJfaPEhzi0qzxSw5vm1
	 tJwrawYU4ax8A5PxIznxJBrUjmk+lXvCuA5zHS+RNeowvXx2bLhJQ6NZI8xmqVF8Gsvdo
	 TJKlDvQaIZCom9I621NB6COULUgEV2hgbDbNP/Wj7xqej6jkp0Bd7K37+UCY5aBiRd7MU
	 ir0smNqGQg3TXLdLTMOZY4OGtStYRcikEdHkZ8ReBGsHsLp9DdVTYRhtSdRiUpP5fuZTo
	 7n8oDl7uBWWUE0vZ7J9QZUP/4Z39wSTfhvhHE9FA+W+3JoH1WSB71z2jzVpBmc41qBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fy2ibHQH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCB0606A325;
	Thu, 19 Nov 2026 01:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fy2ibHQH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170641F000C4;
	Thu, 19 Nov 2026 01:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051050;
	bh=bieOWp3JkdagOxz0XG7e50bzhX/+i7eX8+IrxPUbNTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fy2ibHQHNddx/bNMVYt5enJ37PVm2TvPCgPGNAk1XRia4f8GsNtzfbxmMgrOQF5ck
	 IezqDE4fK435qxyrMpZK1Gukz8L6TyR2K0UppS+hP4xGRvmeQPJG9vFDzHQ+wrKAnK
	 Sc96B6U+l8Sh33NyI6d3sUhYsDafOMFwJsjt4f94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0070/2214] pinctrl: sx150x: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:29:06 +0100
Message-ID: <20261118150012.792684624@linuxfoundation.org>
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

[ Upstream commit 5fe4b12c087db3e565f53b87f1dafdf2f0d1ee0f ]

The driver has a match table for the i2c bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-sx150x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-sx150x.c b/drivers/pinctrl/pinctrl-sx150x.c
index 484a3b9e875c1..6998e24afc5c2 100644
--- a/drivers/pinctrl/pinctrl-sx150x.c
+++ b/drivers/pinctrl/pinctrl-sx150x.c
@@ -829,6 +829,7 @@ static const struct i2c_device_id sx150x_id[] = {
 	{"sx1509q", (kernel_ulong_t) &sx1509q_device_data },
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, sx150x_id);
 
 static const struct of_device_id sx150x_of_match[] = {
 	{ .compatible = "semtech,sx1501q", .data = &sx1501q_device_data },
-- 
2.53.0



