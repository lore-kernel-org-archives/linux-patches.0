Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A0D2F25EC;
	Fri, 10 Oct 2025 13:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102473; cv=none; b=j8+xoeZzbjJCiHefU5TT19O2ntd3YgRRtYCJVmSe8yceOV4Ntsb3bKE3JAf9uJ1lsjD07uw3GXZf+AcndCCi51vbJ0EhuNwbz78tCDMbcNGC2qsRObgKZpK8RsGQCf2nz+o5RttyyZoZOKyTJsbAuw7iB09bW4IzMiVITfVYiBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102473; c=relaxed/simple;
	bh=37276s9aDTKboCx1kq2wnDbrgnJOYp2BeIknOjZFlUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mh7KuP9k0to7dqDipvFVB9AgxLf+ZjSbtXEXt6lUt897j6y2xUMa5dvi87RRQe/vfCjZOrmswd/7H7Re81MxRFEswWK0jEJxunW65v9Rru5ElZgUzbC0ywYB4tDSfNEPRwpA3wJxAwn6zxjX8wHzvifY23xp+SjEY3XNz2VY/1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTM9OtPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTM9OtPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042EBC4CEF9;
	Fri, 10 Oct 2025 13:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102473;
	bh=37276s9aDTKboCx1kq2wnDbrgnJOYp2BeIknOjZFlUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTM9OtPOdQNo/P+8o5pYCg8xOKnZTyxkisfJfHysjz9RTJCtJI4Lr6mRiIXpBEMc7
	 Z3A/lsbS5RJTcDmPrA5pGh6GBYMfsWEY+5akLV2XWok9FOtnfv0djy3mjf+WWnc1wR
	 0iGMzS7aThl4G89sJUOQaza0sUcaHTl0iiz/oEfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 08/35] ASoC: amd: acp: Adjust pdm gain value
Date: Fri, 10 Oct 2025 15:16:10 +0200
Message-ID: <20251010131332.094312210@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit f1d0260362d72f9f454dc1f9db2eeb80cb801f28 ]

Set pdm gain value by setting PDM_MISC_CTRL_MASK value.
To avoid low pdm gain value.

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20250821054606.1279178-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/amd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/amd.h b/sound/soc/amd/acp/amd.h
index 854269fea875f..aa0aa64202fe4 100644
--- a/sound/soc/amd/acp/amd.h
+++ b/sound/soc/amd/acp/amd.h
@@ -135,7 +135,7 @@
 #define PDM_DMA_INTR_MASK       0x10000
 #define PDM_DEC_64              0x2
 #define PDM_CLK_FREQ_MASK       0x07
-#define PDM_MISC_CTRL_MASK      0x10
+#define PDM_MISC_CTRL_MASK      0x18
 #define PDM_ENABLE              0x01
 #define PDM_DISABLE             0x00
 #define DMA_EN_MASK             0x02
-- 
2.51.0



