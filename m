Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707BE322749;
	Mon, 20 Apr 2026 15:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700599; cv=none; b=ltT100e3nCEkIO3BMvj8Y57uVPbg9+ID8Tbxvxo1+iJrISqEas3K34EoCWztTMw5rBL6DdhD9yz7nA3fxwW7JsxFAW+0Vogcru4XYQz5nBK9KyrQoaJIGLT5XdFHnnb2PNRhBtSKbslIoRlmZRnNWEIYZe69J8w2falx8FJDUno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700599; c=relaxed/simple;
	bh=XPRRB5yWtMSGu39NxauxbWtVa4n45Lvl4ImRoh3tRE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rtxJSHip/usTnnU2BS8TjkDPxEglr+APixTNJ3Yf9sMS+VZx58VNkYzEsTTx8uFk1ndUxUZrsYYfW3fBQ/y9kktlzr60Kxiyu3rgMjB1aze0ua9IGC9nhFYfOxijdolLqi5l4NIenDsXkBNNI4PQEF7jYC+tCEf2uBSFRJyNHdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBpn1gkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBpn1gkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071B8C19425;
	Mon, 20 Apr 2026 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700599;
	bh=XPRRB5yWtMSGu39NxauxbWtVa4n45Lvl4ImRoh3tRE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBpn1gknYLaw6AO+vsT1ns8CKuoZSQQ+98uv72pKuMQDoNZZTMRBVD/6EUwuarJ/t
	 AcfscLpF0cSsh4vxR5pBgN3bhvhV1hcuAI8iwff29bYjG26IIO6t2RLzllb2qeO6NR
	 8cqVz9qFFq8BB4ghzT9eWqHbOLlHi3yB4KZkJOSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/198] platform/x86: asus-nb-wmi: add DMI quirk for ASUS ROG Flow Z13-KJP GZ302EAC
Date: Mon, 20 Apr 2026 17:39:54 +0200
Message-ID: <20260420153936.165615305@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit 0198d2743207d67f995cd6df89e267e1b9f5e1f1 ]

The ASUS ROG Flow Z13-KJP GZ302EAC model uses sys_vendor name ASUS
rather than ASUSTeK COMPUTER INC., but it needs the same folio quirk as
the other ROG Flow Z13. To keep things simple, just match on sys_vendor
ASUS since it covers both.

Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260312212246.1608080-1-matthew.schwartz@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 6a62bc5b02fda..8dad7bdb8f612 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -548,7 +548,7 @@ static const struct dmi_system_id asus_quirks[] = {
 		.callback = dmi_matched,
 		.ident = "ASUS ROG Z13",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Flow Z13"),
 		},
 		.driver_data = &quirk_asus_z13,
-- 
2.53.0



