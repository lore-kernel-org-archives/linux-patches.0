Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039840;
	b=n/H4orNE/WQMCjkZT/H7KXM7l11xlCPypUe/WvzSoLTwoHe1a+v9jSPPJoDj5GXMTLr5
	 6Wo+2bA2N8laxnz7Nk4nwtu7SDSzRgcQ3vmotvnEl+aGVPCHFQFvAod62vd5JWc4RFQnF
	 fXjdjSYfKHg7/bJU38U38YA/nuiEGdo4FcfcMq13O+M4RCI7GM0KU9zekyeFtB80PZhox
	 b+I55YGyk6lLQgAKRU9LExW6/ACS5v+9yIzge/VH+4COmrZfHHvDHQgcfd9MUQaBqtoY3
	 9O207nunxDgkyDzEjXoBK79Wzsj4tOIkNt/LBacFNjk3LGz5uW+O2VNC1WuanygfEJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qTF9b4AcYTnmjjtreXDJFUqbMzXlPWWZHL3XCU0vNAs=;
	b=4GOiFBK7iRqL6lwq/uF0Sz1WuoozGzvMxJjfq8qbudlpXR0k7JrY5FTTx0Av3buVZAt3
	 XycUjflCxJYn2lkExrHR34RWv+r2ygoDKxPHo7nWVT51yaThcMnjmT2AB9OTgGefdNIFn
	 ROBVS9FdTgq1PDUp3HOK5F+GXKuWL+rpLFtQ9yhL7pdmfFswVeqCrmbDL3Fy3I/GzcHjV
	 2XLxPExh4hFglH6A3rqd63ghUxtSSkbM0g6BkF8J4muQ2yeUyM+g+qhi/KwaFGdlM0AWX
	 DT9LIU27tqFvfgkga434GtTb6Ap4oU/k0IeWWXufJ/6tzZhIe2kvADDyNkpj0+C52dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vnT/eOpI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CFF606A320;
	Wed, 18 Nov 2026 22:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnT/eOpI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE84F1F000C4;
	Wed, 18 Nov 2026 22:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039840;
	bh=qTF9b4AcYTnmjjtreXDJFUqbMzXlPWWZHL3XCU0vNAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnT/eOpIxKV8xKgUb7jdV3tz45JjhEmoUdBuy0GoLlEu7NVsBZNJ4XgRm4aWoOuYW
	 18MqmTDoDJldUc97dZ1vI8z3arrP5QZ34fLryTxRJXcy5Kzw4QhGy+lI3L62pJNURo
	 EDylGDyddLOfcR0qRVYBeSDXN+c3u7LSULFHCDv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2245/3318] clk: si521xx: correct the SI52147 OF output enable map
Date: Wed, 18 Nov 2026 15:47:47 +0100
Message-ID: <20261118150429.196071322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7a4cc47d715f08309089d40b8c29fb0ba79917db ]

The SI52147 data sheet assigns DIFF0 through DIFF3 output-enable bits to
0x17 in control register 1. The OF match data uses 0x15, leaving the
DIFF2 bit out of the map, while the I2C ID table already uses the
documented value.

Use 0x17 for the SI52147 OF entry so both enumeration paths expose the
documented outputs.

Fixes: edc12763a3a29 ("clk: si521xx: Clock driver for Skyworks Si521xx I2C PCIe clock generators")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si521xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-si521xx.c b/drivers/clk/clk-si521xx.c
index 5886bc54aa0e7..bc5a4e12bae03 100644
--- a/drivers/clk/clk-si521xx.c
+++ b/drivers/clk/clk-si521xx.c
@@ -373,7 +373,7 @@ MODULE_DEVICE_TABLE(i2c, si521xx_id);
 static const struct of_device_id clk_si521xx_of_match[] = {
 	{ .compatible = "skyworks,si52144", .data = (void *)SI521XX_OE_MAP(0x5, 0xc0) },
 	{ .compatible = "skyworks,si52146", .data = (void *)SI521XX_OE_MAP(0x15, 0xe0) },
-	{ .compatible = "skyworks,si52147", .data = (void *)SI521XX_OE_MAP(0x15, 0xf8) },
+	{ .compatible = "skyworks,si52147", .data = (void *)SI521XX_OE_MAP(0x17, 0xf8) },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, clk_si521xx_of_match);
-- 
2.53.0



