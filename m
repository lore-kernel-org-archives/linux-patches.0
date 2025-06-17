Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3FC18A6AE;
	Tue, 17 Jun 2025 15:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174621; cv=none; b=rZif2dkjMZRi34eijhGm5yAmXVAZEH4YTWBx3iB8wMF2WPCgv/vGNwWXf4Qnw1dlpTVuEA2d6uYivkevK/24Qiv+vdTOYNpEblvbNr/svjLWNUc+IN08e9fkkKfXvVlfcCmvBfjkQo7gwVfuYsnlkfBvaL16vVu8GcwZSsf+j/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174621; c=relaxed/simple;
	bh=OBU/Kh97nF0ZyP/QguJyJlC1Y//p7kly2PUrFPQu4VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO+ZEKFhH4X5v431XHd7N7pcFkWAyfk09dPO740pcDRO3t6vFujcbFL3y5mhCek9L+HYRNf/28KS9HaqDDSSw5u0BLj6YwNou4r5HX3Ez3KVrzLI8N1pyk2jvaQWhbQzD35jehVT7dlImXW+cWyeQMmAXMwmWYpf5HxrtNDL5mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7k0s1oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7k0s1oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46DAC4CEE7;
	Tue, 17 Jun 2025 15:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174621;
	bh=OBU/Kh97nF0ZyP/QguJyJlC1Y//p7kly2PUrFPQu4VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7k0s1ocdix9/+ZpwYHMCRY+3JuyUSTttcRmObnqOsAQM8kXcNGnTJKXFZa+Kc7uI
	 9Zts7xhaqKlcl+q6VsuTIWkFV2xcr3aslGE+UJX4uInIcQoayNtyCugD4lzi/vcH7O
	 MwRE7cxqImf4dUDBMRT6Hti1vh21BhASirZFBjJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/512] spi: tegra210-quad: remove redundant error handling code
Date: Tue, 17 Jun 2025 17:20:10 +0200
Message-ID: <20250617152421.328306494@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vishwaroop A <va@nvidia.com>

[ Upstream commit 400d9f1a27cc2fceabdb1ed93eaf0b89b6d32ba5 ]

Remove unnecessary error handling code that terminated transfers and
executed delay on errors. This code was redundant as error handling is
already done at a higher level in the SPI core.

Fixes: 1b8342cc4a38 ("spi: tegra210-quad: combined sequence mode")
Signed-off-by: Vishwaroop A <va@nvidia.com>
Link: https://patch.msgid.link/20250416110606.2737315-3-va@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index fd6863e89cddd..30ed4120a2ef1 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1175,10 +1175,6 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 
 exit:
 	msg->status = ret;
-	if (ret < 0) {
-		tegra_qspi_transfer_end(spi);
-		spi_transfer_delay_exec(xfer);
-	}
 
 	return ret;
 }
-- 
2.39.5



