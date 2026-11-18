Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056735;
	b=qllc14VFblRG5dQWoSmG1EYLueRCNdFLjmpyLxp0bmw2RKy6SQLMRrw5YVDsj+32QxDO
	 Ag32J80w2o0J2cyEMF4l2BYuGkbGtvO2XFu7h2Q4v6v+GHxTYz459OICSOIHdRp3Rpj1W
	 qGSKjodP+XV9Zlc1Urb2LQLj/CrC2+GlkESagdTR+pKyvKJRNTMVAqn2oNA0P5zhwaN8z
	 wdDndaU4FvnLA7MqpjLlz68XNdfa1xuVwmYVJcnD4kXb0hYTshXL9lEC0wqHFOyom6FWC
	 ULT4ohgzJhcVaaT33fdvg4qEEBEs3bx5gJmlcCoG1bU4mfvvRfGTMPK4qENFWbHZ7Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Ltvd5vKZNL1YPvAKzg4MnBiVGfYb8/PewdQJRnhYPo=;
	b=ZaPSOYPPHWA/gM7FNOYzPQcrESEyZG2+bp4I1+TBPGqitLPF1H4PGJCJzZj47Zw5MHRg
	 Xqe1NXGUKr7cD5UEciUZcNNeF5ovIcW/AUPZRoKWX4OUaCGg2rFCHkZkPlaVYs6P9L8GQ
	 Pzm71Pau+VZhSV+ziW7Y9D7r6sFU0VDcC6KIQecsXcXvjoRQoNZzpMBjINp6uTctlG6bq
	 EOLSyzmN7p1PuGX9FhA+OPcBDFf4ikP0CkcGk/c/vxFpBkMD/9S4kdQg7wv5NyM5UuWXM
	 LefIQ1DJL5G9VH133ZLhPTV2EPMH2ZzVSA1anxVcjrzRdsEzTXW2anmm8GQkwpce04A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiF1R234;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EF7606A325;
	Thu, 19 Nov 2026 02:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiF1R234
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D951F000C6;
	Thu, 19 Nov 2026 02:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056735;
	bh=/Ltvd5vKZNL1YPvAKzg4MnBiVGfYb8/PewdQJRnhYPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiF1R234S0nAhbMdsI8//zDyiRuwKTlZKqnIyfBTRdJqB+Taf4gAosjzUKJztlsV7
	 9JgAbWgBwcxN3bfa3ttaZV9B9IDH0mPUwPgm7Fnl4xo1kC0aPNJ3q+DKvM+Yj1ghIP
	 IETA++/Vt84b39RbBFAhMEkZdFxI5UZLMKACQLko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Travis Howard <thoward@lafayetteinstrument.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2095/2214] tg3: Add Datto SIRIS 5 1U Server to restart AER quirk table
Date: Wed, 18 Nov 2026 16:02:51 +0100
Message-ID: <20261118150134.455155984@linuxfoundation.org>
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
index 64e85516c2af1..3337f9c39d931 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18135,6 +18135,12 @@ static const struct dmi_system_id tg3_restart_snp_quirk_table[] = {
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



