Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB663D75C2;
	Fri, 24 Apr 2026 13:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037647; cv=none; b=bTY8Nd0sLBecRbnKg2O1zLlGWB70kpozm0FIZ8/Mca8+j6EB7qJ78irxrGm0ikvTx03gVgCiizicPqwL8SrgISN5dI9Tyntkz8VZEldT+FhN6YQffuTNWrzvZxEGCxsTXFU3OxTuYItkBhSNfcUOJs9sJUN+PFjRDzi5GKoJUb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037647; c=relaxed/simple;
	bh=KBK0FsbMqfD7Wu8149TIICMeq2m0cwOzPXIIqDxaHP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu5TIRfbDtIMNDNMw6GlBctw47EuJKhm72edQgg+WYI9qnyZyAjBRLWmLbfaWFMpmvPoB/k0N7eCID8UGwAn8dkYap7GuXHxsjUD7vl8s4ps9HLC1RZwikku+PrfKkJxzj+8P5aekkDi/FuIK8Sk/EdkifQk7kLfhxofXI9uGOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mu/z4T3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mu/z4T3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB40C2BCB5;
	Fri, 24 Apr 2026 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037647;
	bh=KBK0FsbMqfD7Wu8149TIICMeq2m0cwOzPXIIqDxaHP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mu/z4T3ez7cAMYcqjZdzrORzdEoADQCP79HacUQvwxfSYtVmzzN6BaR5xk/mhyDF9
	 uUJbrrRPmLqC5zfUn8t0vfglfDcMGrq9DAedLqn/o7ZFOOVYMVWp7XtjXcs6QR5cJ8
	 cSOyQARb073xd3ZsJM2rSpVXaGkLvirKAgEGfJw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/166] ASoC: amd: yc: Add DMI quirk for Thin A15 B7VF
Date: Fri, 24 Apr 2026 15:28:41 +0200
Message-ID: <20260424132534.390261598@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 1f182ec9d7084db7dfdb2372d453c28f0e5c3f0a ]

Add a DMI quirk for the Thin A15 B7VF fixing the issue where
the internal microphone was not detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220833
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260316080218.2931304-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 8a666989a8f3d..05aff73408d51 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -717,6 +717,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "BM1403CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Thin A15 B7VE"),
+		}
+	},
 	{}
 };
 
-- 
2.53.0



