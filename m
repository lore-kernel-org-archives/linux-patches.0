Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F641925AA;
	Thu,  5 Sep 2024 09:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529391; cv=none; b=iHmsQOCX3pAZ21gxqikeWc9u9uJEg608lXrSkUbmaelqiLPADK0KCibsPYXkY4KatgvIi8E8gYoWTcXaY4sXmFmqjvm3q2fLBp2yRHpmhlJERcJ8SBGvcoA2MOygaOlKPnuuFz6arMlvPyFUnpe15yioX1UzeFsxpqQSkAfc7Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529391; c=relaxed/simple;
	bh=iQvt4xxQ/X79sVYNfwOr+wFD5qdTbj/BazJdz6eDATQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kwxpYil9zgBEIfkp3CnbDzfXH8aZDL3KgktMG58Oo6Hwv6UFC5BxSOQlC8M51ae9W0Scy1KiypI6V8IvkE5xcYoQJXuRppJC5KJypFmPKzTLUhhh+U+PTw49m6WEeF+eqZuyaADf5alArpS02aNtfsI76tA0LKYaT8FbUSIPFXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpNbP4Kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpNbP4Kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABFDC4CEC3;
	Thu,  5 Sep 2024 09:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529390;
	bh=iQvt4xxQ/X79sVYNfwOr+wFD5qdTbj/BazJdz6eDATQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpNbP4KwQ2SxKit1ZipstUw2bN6me3YcOTHBQKZwPujfeiBPDr4zYT0bKUko30iej
	 j++n83z/Yacyh+xuqeRtR1NwrY965FjDrH2tqbS+kscxZQd9CPHIqe6ERuAHXJXEF7
	 zHxCHiYutw2li+eAvkC+eYi0JQnU7ipzvq6fZuc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 018/184] platform/x86/amd: pmf: Add quirk for ROG Ally X
Date: Thu,  5 Sep 2024 11:38:51 +0200
Message-ID: <20240905093732.958127991@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 4c83ee4bf32ea8e57ae2321906c067d69ad7c41b ]

The ASUS ROG Ally X has the same issue as the G14 where it advertises
SPS support but doesn't use it.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20240729020831.28117-1-luke@ljones.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/pmf-quirks.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/pmf/pmf-quirks.c b/drivers/platform/x86/amd/pmf/pmf-quirks.c
index 0b2eb0ae85feb..460444cda1b29 100644
--- a/drivers/platform/x86/amd/pmf/pmf-quirks.c
+++ b/drivers/platform/x86/amd/pmf/pmf-quirks.c
@@ -29,6 +29,14 @@ static const struct dmi_system_id fwbug_list[] = {
 		},
 		.driver_data = &quirk_no_sps_bug,
 	},
+	{
+		.ident = "ROG Ally X",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "RC72LA"),
+		},
+		.driver_data = &quirk_no_sps_bug,
+	},
 	{}
 };
 
@@ -48,4 +56,3 @@ void amd_pmf_quirks_init(struct amd_pmf_dev *dev)
 			dmi_id->ident);
 	}
 }
-
-- 
2.43.0



