Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3EB220686;
	Mon, 23 Jun 2025 21:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715800; cv=none; b=slKEvOpez4OPpdNRiwYbKa8jFkF7HWqEuzyWPvIKCefCDVW+gmUgl69csOUtwyLb1x3gUWMpv6W5y4j2dhwAj133AdTLp2d0srn8nnG6e0X4rE2o4KuIZucEXrmgOjthO6S28iGKW3jK2jkEeZpj3fyocbE2ql4LRxJK6dl6zIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715800; c=relaxed/simple;
	bh=nYZSaMi8OP0Wt0hjiOUufg7pRXWiGJcKkaxEi7v0C+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rMyvWovA76cGGl8EcnrcXWY4siwM2gNdiENAbCsDLW5sKKOyjEEVsi6AWIOb/m6QvMNFX8LLK0GFDbdJq3OBylVcBTLiepWQXxF45K54Grq7MfTE13lNFFzjN+WuvB0sAJk919CbPsu5O6q92t4qsI+sWYuSDxP9QLrHqMYGwaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shEUfusC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shEUfusC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B816C4CEED;
	Mon, 23 Jun 2025 21:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715799;
	bh=nYZSaMi8OP0Wt0hjiOUufg7pRXWiGJcKkaxEi7v0C+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shEUfusCUPkq6ucqGI1e94z1zCCNOTBgHRcUDDEUP9h7ryqVYpRDvID6g2ff7EVPT
	 A0qWEQ2G7C4MmU6WGl/4/1lKH86ebZiTWj4M2FxX3+7Y8BoN1jtW17jBLbgVcsgpXN
	 J11k1xCL5CHUQKMPt6Hln2u4IdalgAjYuFk/PxwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cihan Ozakca <cozakca@outlook.com>,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.15 481/592] Revert "platform/x86: alienware-wmi-wmax: Add G-Mode support to Alienware m16 R1"
Date: Mon, 23 Jun 2025 15:07:19 +0200
Message-ID: <20250623130711.875867743@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

commit e2468dc700743683e1d1793bbd855e2536fd3de2 upstream.

This reverts commit 5ff79cabb23a2f14d2ed29e9596aec908905a0e6.

Although the Alienware m16 R1 AMD model supports G-Mode, it actually has
a lower power ceiling than plain "performance" profile, which results in
lower performance.

Reported-by: Cihan Ozakca <cozakca@outlook.com>
Cc: stable@vger.kernel.org # 6.15.x
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250611-m16-rev-v1-1-72d13bad03c9@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -91,7 +91,7 @@ static const struct dmi_system_id awcc_d
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m16 R1 AMD"),
 		},
-		.driver_data = &g_series_quirks,
+		.driver_data = &generic_quirks,
 	},
 	{
 		.ident = "Alienware m16 R2",


