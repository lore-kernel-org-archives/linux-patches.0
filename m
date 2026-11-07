Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063296;
	b=DEITTj6v+ZhmvTbphU6dxL3aZxCiLlJr9cPcmWkSeK94eLXP5GOf4jTZf1OrGInVFbji
	 jBSlrrIJho/EMexExjrOuSFU9j6VP8f10KirOmGJImEW2PvFWxjhLFFQ9I9GWQKad5GvL
	 C5AGWXRkHk9UZ0D6sPbZzTMDsBZvs8zne9urX9zjvbrCmjzXp6s4gifGpcl1hj4XKN1r3
	 fRBfopzUUoFFFmOFnbu4anhnDAOjhbqgue6/zzOHTU/iP2f07hEEjp/bYru3HhMgZYgPH
	 F0EVc6MaR6U86Tuf7K76XRzKVzRXqncwaygqP7v/5rs36tqeV/BAHkx5wpGiAhGthrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GLg8FUx9SqNmeKFttNQ7URxemdOcQSTTJWQysPoxzs0=;
	b=3oZPi9R+pNtqsQ54ybn8Lt7f8gvLxGgKNzGOo6H7GsqJBI2g/SWrWH1UN5Y5kq0YsxB4
	 6oGB/ZjgnECnaiQq7wXvn4+M2orO1mpoCTFvgfNF5727VEXYqKpmf91OPtHKfOhpvaAr9
	 Ux2uRFf8Q+rvblD+Zawij89hgEc/J4wajOou4trijyxRJTE5ucnsUE33MAw1wDAXg2qVj
	 PaP6/Az0TY+fOpvdEBJM37YJAvTnHKdzVJgdwQ11b04EJFtgiOx97T9LZW+mN1xLUvl70
	 ZaqyTany8PNS04Z+INHydikEN3xJR9MqUUfG96B2V3fwgOje1Jb1nVoPX1JweFBI2Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nANMM26z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C918B606D816;
	Sat,  7 Nov 2026 14:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nANMM26z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781CD1F008A3;
	Sat,  7 Nov 2026 14:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063295;
	bh=GLg8FUx9SqNmeKFttNQ7URxemdOcQSTTJWQysPoxzs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nANMM26zr9jxQvDFiAZnVTWGX/Rtj5zKWhK0qXXZemPOwXfeTVvCnQBqaU11UeoOp
	 3Vd4B/uDGkJg2+OmIWkuW7GQ3UV2YkzmfQe+AufCMWjHgxfSiq/t5NwEw7PZ29aFri
	 sC3nVCcpPMzC3Lsv6y6lWPpXUxugkisfAzDGQOjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 488/869] platform/x86/amd/pmf: Validate the APTS state index
Date: Sat,  7 Nov 2026 08:52:50 -0500
Message-ID: <20261107134910.116923556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 192dddd5aa45166450820cef16521bdf23976a73 ]

The static slider APTS state index is supplied by the BIOS as an 8-bit
value, but apts_config_store contains only APTS_MAX_STATES entries. An
invalid firmware value can therefore cause amd_pmf_update_slider_v2() to
read beyond the end of the array.

Validate the selected index before applying the slider values and return
an error when it is out of range.

Fixes: 8362e862fb87 ("platform/x86/amd/pmf: Update sps power thermals according to the platform-profiles")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260903182927.3556274-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/sps.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/sps.c b/drivers/platform/x86/amd/pmf/sps.c
index c28f3c5744c25..bf101e527b115 100644
--- a/drivers/platform/x86/amd/pmf/sps.c
+++ b/drivers/platform/x86/amd/pmf/sps.c
@@ -248,20 +248,24 @@ static int amd_pmf_update_sps_power_limits_v2(struct amd_pmf_dev *pdev, int pwr_
 	switch (pwr_mode) {
 	case POWER_MODE_PERFORMANCE:
 		index = config_store_v2.sps_idx.power_states[src][POWER_MODE_BEST_PERFORMANCE];
-		amd_pmf_update_slider_v2(pdev, index);
 		break;
 	case POWER_MODE_BALANCED_POWER:
 		index = config_store_v2.sps_idx.power_states[src][POWER_MODE_BALANCED];
-		amd_pmf_update_slider_v2(pdev, index);
 		break;
 	case POWER_MODE_POWER_SAVER:
 		index = config_store_v2.sps_idx.power_states[src][POWER_MODE_BEST_POWER_EFFICIENCY];
-		amd_pmf_update_slider_v2(pdev, index);
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	if (index >= APTS_MAX_STATES) {
+		dev_err(pdev->dev, "Invalid APTS index: %d\n", index);
+		return -EINVAL;
+	}
+
+	amd_pmf_update_slider_v2(pdev, index);
+
 	return 0;
 }
 
-- 
2.53.0



