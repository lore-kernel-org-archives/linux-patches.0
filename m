Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032AA27FD6F;
	Tue, 27 May 2025 17:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366634; cv=none; b=J6RANqc13YCkRHKqUCzN6s2wCQrZ2b0cdfYVMz6kGe/aJdTM9FVeNQ09Vj+U4tAxJotN9k/gwPky9hLSsPspdzQZ0+Rvy+Ha8Hey5k1lk6Pw/EmNr7dNg1Rmm0eVTIPWpHuO50zi0Q/bqX7rwjYBDk9jewKVev3FA2hgxYeMkKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366634; c=relaxed/simple;
	bh=2Wt7VZ0lywYOPIEQXI23VuPiMaU0o5XJ7vC+1EJehdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQbVvo/Z4qNB5kRtkUEV9avCO+pnpbQVdcO408Hm9wtba/WPYMzLdl68hN1B7ZQF+JW3+lEq//DLsn/6e20s+oTpRDxXSmBontTA7KV6jitZVzy616zwEWzHQNCZfUiqdZpOA1v1d20jIxiYFIMooYCkcEnixbEZ2nbXwzq/mVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bscglo07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bscglo07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5B6C4CEEA;
	Tue, 27 May 2025 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366633;
	bh=2Wt7VZ0lywYOPIEQXI23VuPiMaU0o5XJ7vC+1EJehdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bscglo071HPzsiAZ3dCJUKhimdU/oBz1dvFO5tBEt+g7qE3SzJhvCg7sTLPqhhiqK
	 guiiQXO9ieTTHmS9Y4ggP/bMR6JEtzgwwJww0YGwqKu9nE3jZZggU6YryLPdCKeIgD
	 vBHvCp16J35TgiBhnMDyxhNrPtGsvQJdEo4LDjoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanket Goswami <Sanket.Goswami@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 132/783] i2c: amd-asf: Set cmd variable when encountering an error
Date: Tue, 27 May 2025 18:18:49 +0200
Message-ID: <20250527162518.524646196@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit b719afaa1e5d88a1b51d76adf344ff4a48efdb45 ]

In the event of ASF error during the transfer, update the cmd and exit
the process, as data processing is not performed when a command fails.

Co-developed-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250217090258.398540-2-Shyam-sundar.S-k@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-amd-asf-plat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-amd-asf-plat.c b/drivers/i2c/busses/i2c-amd-asf-plat.c
index 93ebec162c6dd..61bc714c28d70 100644
--- a/drivers/i2c/busses/i2c-amd-asf-plat.c
+++ b/drivers/i2c/busses/i2c-amd-asf-plat.c
@@ -69,7 +69,7 @@ static void amd_asf_process_target(struct work_struct *work)
 	/* Check if no error bits are set in target status register */
 	if (reg & ASF_ERROR_STATUS) {
 		/* Set bank as full */
-		cmd = 0;
+		cmd = 1;
 		reg |= GENMASK(3, 2);
 		outb_p(reg, ASFDATABNKSEL);
 	} else {
-- 
2.39.5



