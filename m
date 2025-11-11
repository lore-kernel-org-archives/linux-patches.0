Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D0C2C026E;
	Tue, 11 Nov 2025 01:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823181; cv=none; b=oTB2FhAZQd00DilOw0KYJOowZIE+jXOoZpDpXmYqYKAikrCCxaoC4VCRNmgCrqFj8dPuX9x4NMeScYRnUO7QkrPULHoEgz5mx35H8yIUqKBvCW3h7GxJ9KJGkgECvuo2ezYnvL9j+L0G409CEJW6Uayu3je/7mnYL93+U7de4o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823181; c=relaxed/simple;
	bh=z5sfeEliNNOzcXhkJ9twYVLzi3sHJhc9RKxufjFBwLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNRBjlLET1axd1X3EiLtjMCl+sei+pBXKWBZEA4K7jy9B8k/HFhnn/Hewscd0af333sCAgt4BZtNaANBLf8oG3OmjF7o+J7BJDCzimJ45Ja8fZjPm/ZYN+ZmBFSb/mDpX5I63qy1zGS1ILGgBi5ZUz6j+z7QS2tefz6xoiN6aCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayPDOZ1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayPDOZ1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637FBC16AAE;
	Tue, 11 Nov 2025 01:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823181;
	bh=z5sfeEliNNOzcXhkJ9twYVLzi3sHJhc9RKxufjFBwLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayPDOZ1T3R1YBd6zikKkxfTMooUGrcCHdnjl76qByoElwaHRyWiJNGDsVYiSX+VYE
	 2SDHZSdwywQPTt6hCCCAipRqZbTsc7SYHL5BF8A5DIMUkPsF534avqslMP4j1rAoa0
	 /oZtE4BHovVkFihtUhI4iHF7r9FVs4ysFGihGROI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Neal Gompa <neal@gompa.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/565] pmdomain: apple: Add "apple,t8103-pmgr-pwrstate"
Date: Tue, 11 Nov 2025 09:39:59 +0900
Message-ID: <20251111004530.158673882@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Janne Grunau <j@jannau.net>

[ Upstream commit 442816f97a4f84cb321d3359177a3b9b0ce48a60 ]

After discussion with the devicetree maintainers we agreed to not extend
lists with the generic compatible "apple,pmgr-pwrstate" anymore [1]. Use
"apple,t8103-pmgr-pwrstate" as base compatible as it is the SoC the
driver and bindings were written for.

[1]: https://lore.kernel.org/asahi/12ab93b7-1fc2-4ce0-926e-c8141cfe81bf@kernel.org/

Signed-off-by: Janne Grunau <j@jannau.net>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/apple/pmgr-pwrstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pmdomain/apple/pmgr-pwrstate.c b/drivers/pmdomain/apple/pmgr-pwrstate.c
index 9467235110f46..82c33cf727a82 100644
--- a/drivers/pmdomain/apple/pmgr-pwrstate.c
+++ b/drivers/pmdomain/apple/pmgr-pwrstate.c
@@ -306,6 +306,7 @@ static int apple_pmgr_ps_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id apple_pmgr_ps_of_match[] = {
+	{ .compatible = "apple,t8103-pmgr-pwrstate" },
 	{ .compatible = "apple,pmgr-pwrstate" },
 	{}
 };
-- 
2.51.0



