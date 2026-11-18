Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061997;
	b=JHxlncU/GRkXGjebfUha7kuILJlskdG9ozG1zzl8vIAuJPJJ1xeTawwB5AS/e2Bfr14W
	 nZAbYlvblPtunF9vzo80i/7nBRWrKBBKne5A0zLvjjI8jalItgVYmsY8iK5qN1f+fBTsf
	 uatKbqNkx2Hxb9JGx6ZrYaBIp0Kwyp/lJGXWnEfgNyQCf8twAX65cZrWaVyWck0rbfY+3
	 rjOU8E7WkYqbRyvpwecho5p62eq3/orq4yDcv7clYSMcgjX2M8snvTq2dFehnqmhdy3bZ
	 Toui5rIoQCCC3VUGgGeOuBtm5Cns3yhPUYlZtwOQVNh/oe/yTtJEa/6kx0r6A5wWkfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F+2rswXhzI+HexKmk3t4SySlnGg4WRI1UsIhXEKgCpU=;
	b=kl9QvGyjoWK0pYZ3/aza1u5jrKJfe5OcOgb3+0Xbq+1nest0M2ovus0Jvu9KodJX875w
	 nqjnLpWvxXe6PuKc/Xe1YILHGkp9XdHPigfexPwoAmF/gC6ypYcjtZUGsK+T7sP91uSfn
	 KgrRNwPRaClhBW5AcXmQr+lR2oolVdm3bR5TabzTW0w1dqSAIw/b2g36rpwJV/ojWpuEO
	 TnMd2v9bryRp/GhiKLcGtuLQIKU57CkMSli4LRwJ0+laC7CvQQeI4bVomXP5DmBL5DoJK
	 UwBQTp9XH6RELUIqgrpiAGqQx6dE+E3bFR4cOybSzVNsLPo+XWYULoZZRAZTZMY7dtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QVhU5ICj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56D360A2601;
	Thu, 19 Nov 2026 04:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QVhU5ICj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C621F000C4;
	Thu, 19 Nov 2026 04:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061997;
	bh=F+2rswXhzI+HexKmk3t4SySlnGg4WRI1UsIhXEKgCpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVhU5ICj9bYzanBT+Un0DYuJHnUj5pnXQqj9LFaofk18GVl69iRYzNI2SuLoQlJEr
	 8AmpoDmWHxYxs13fpmJNMmj1Q9irsTw052yMG4YhIntRyP20Yo+ex4ggYU9dpg2VVM
	 ATxTmxf/SvmuIxkqi76/p2IMGVD439oHXoEKD/48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Travis Howard <thoward@lafayetteinstrument.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1753/1848] tg3: Add Datto SIRIS 5 1U Server to restart AER quirk table
Date: Wed, 18 Nov 2026 16:03:11 +0100
Message-ID: <20261118150032.848547011@linuxfoundation.org>
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

From: Travis Howard <thoward@lafayetteinstrument.com>

[ Upstream commit a55eb6a622141352131aa6156bbd6ce5da79d9b5 ]

The Datto SIRIS 5 1U Server is a Dell OEMR XL R640 (Dell's OEM-ready
variant of the PowerEdge R640) sold under Datto's identity. Its DMI
strings report sys_vendor "datto" and product_name "SIRIS 5 1U Server",
so it does not match the existing "PowerEdge R640" entry in
tg3_restart_aer_quirk_table.

As on the PowerEdge R640, a system restart triggers a fatal PCIe AER
on the BCM5720 during ACPI _PTS for S5, which the iDRAC logs as
PCI1318 and which hangs the reboot. Power off is unaffected.

Clearing the same PCI_EXP_DEVCTL error-reporting bits on both BCM5720
functions from userspace immediately before restart allows the system
to reboot normally, confirming the quirk applies to this platform.

Fixes: e0efe83ed325 ("tg3: Disable tg3 PCIe AER on system reboot")
Signed-off-by: Travis Howard <thoward@lafayetteinstrument.com>
Link: https://patch.msgid.link/20261019-tg3-datto-aer-quirk-v1-1-f0eccfb2ab5d@lafayetteinstrument.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 3f5cd16c79210..e0317ea710d63 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18203,6 +18203,12 @@ static const struct dmi_system_id tg3_restart_snp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R750"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "datto"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SIRIS 5 1U Server"),
+		},
+	},
 	{}
 };
 
-- 
2.53.0



