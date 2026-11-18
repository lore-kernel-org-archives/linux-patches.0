Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060648;
	b=E/O+GDIc5CuvwV2YakffIEEGRmqDX0YWXL8b10sIr7GbKI5FJLJZC/bhVkwas5079Sym
	 4llFEghIAjvbxvnicHUlZtNFMoT5hspvxXjdauYVfqJRvxo1heXpD+vSnqjR+v6KaLNfD
	 JyLzl8CW49NkFUh+lAwRtPr43tckTqcKzsdbd8X3uIow5wJyU/PkSZ8dpob5ay0pmKCDq
	 G+dzehjJONVPTjeJy2DAafwbPbMojLjd64SG/RKtjf0XmVb8D3neDjG8dsnGhMgQaE8RZ
	 yekKofazXygcN4YG8fmK7bzcr4Imev8Iem/dNuoVuMeKsoEi9SL2cpHTPKUuf76936Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ED+rse5v2cHPHziHlE53d8UQDRcy5taryeXnwB1okF8=;
	b=CastUPN6qx1tq21eomMgXE21VXt2ItufMME+AilRlKzvv8g0WA08ZCmeikJXFyi6b+hY
	 hmlRSH6h+6F97aKcuXYqUVHmJp0wfMUzfDruQoQ1+ghpv592PKr7nAURdFCqbSV/tfnvy
	 Zod6sH21tCZz6LSu6HuLwDgZdf+/RFy38M0Bcpw/hGgwrEP6pmdhcWa1tMRV3m9DkCR/w
	 AUWL72nj6sXWT2l95Bn7WVNfnZNvItKVjn4/rsbEX/EcV0HatRt9twie/CVDUdkkqiRCb
	 glXtHl5BZ3d7bWsmPkVi/NesLj7YAaim0uTAuShtuh13DFGgPwVFu4amz5if8oacccA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zz9ZfqD9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002A7606A320;
	Thu, 19 Nov 2026 03:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zz9ZfqD9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D9A1F000C4;
	Thu, 19 Nov 2026 03:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060647;
	bh=ED+rse5v2cHPHziHlE53d8UQDRcy5taryeXnwB1okF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zz9ZfqD9IB469lQH9kWCHgm+TsZuvqKIp1KPAW7NAkjtK0nHaETWcR3t4+W366LaI
	 P2XVqwmV5W+CCsHDXUGWYyUT20LbNDX1HNNMEd5MDCDwwl/ImuC73JA/gKTK2m0zg1
	 g8OFCxtkAC5y0BBj/EU4acepbvSnMVWM65zxe5K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1273/1848] ata: sata_dwc_460ex: Dont enable interrupt if libATA core registration fails
Date: Wed, 18 Nov 2026 15:55:11 +0100
Message-ID: <20261118150012.927975952@linuxfoundation.org>
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

From: Nikolay Borisov <nik.borisov@suse.com>

[ Upstream commit e137035fcd66cb454c479bb989968561bbc60341 ]

Recent 4bbc16a353a9 commit changed the timing when interrupts are
enabled. However it didn't account for the libATA registration step. So
it's possible that interrupts are enabled when the device is not
registered with libATA core.

Resolve the issue by failing the entire registration process in case of
failure to register with libATA.

Fixes: 4bbc16a353a9 ("ata: sata_dwc_460ex: enable SATA interrupts only after IRQ handler is registered")
Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/r/20260917150707.1643330-1-nik.borisov@suse.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 28473059296c4..11d5aaf4be37f 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1265,11 +1265,14 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	 * error_handler() to execute a dummy Softreset EH session
 	 */
 	err = ata_host_activate(host, irq, sata_dwc_isr, 0, &sata_dwc_sht);
-	if (err)
+	if (err) {
 		dev_err(dev, "failed to activate host");
+		goto error_out;
+	}
 
 	/* Enable SATA Interrupts */
 	sata_dwc_enable_interrupts(hsdev);
+
 	return 0;
 
 error_out:
-- 
2.53.0



