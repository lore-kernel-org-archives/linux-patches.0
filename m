Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9709E47CC82;
	Sat, 28 Feb 2026 17:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301325; cv=none; b=cUJ+IABMRZ0iW2yxV4/h+OuTIpSgu9W2glXAYZj+bc1Fwx3L5n98BuBTrtTZTkB+LsuW413/NUc4m0OhS60LNIYDn2gtlktKruVTHBGQNfG1HtyC3dO4kkJIYF9VI+DlF0qr93sJP6BchePyvl8kcaRI+LNhmBGUnKLwmaa9og4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301325; c=relaxed/simple;
	bh=dsRGnfj4WmFvhxIQVRCBtspoV4yLgLut1kN03RfXVo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRw84fposARs/GtiobOJZIh2zqb8VzCJVIu0HwmqiSQfh1pUkZUz/CSPS31gK15mU9lGh3PK5HE6P0mdhy9mBYqsJ10wCSGCdU+wWfFbv76knbiLSCzgbTHSwbmwEJQe1KeRYoCv48rxclG15e3UT3zYKGsJpKslXXWyCdbgPGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nc9CcYJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nc9CcYJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E630BC116D0;
	Sat, 28 Feb 2026 17:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301325;
	bh=dsRGnfj4WmFvhxIQVRCBtspoV4yLgLut1kN03RfXVo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nc9CcYJiF4MxM/eOBRd2ODz4WphWXGffizOOibBAZdgaSq/K7Luw2tIiD/Aj/iEEl
	 7L477GwAh0bQTQ4v2S6EeKC6y2WAxgKgxC0w1ljYOuoS8IeERJyBgkG1ULNVlOqdps
	 AK79YePMFUDL0JaiF/MY1IY7IBDg3KUt5eicx2d+JdvMeV6w429VhD/LQ1tuEqTWNH
	 sQb895vqhHYJsMrb9ansxmXQUfJm/Mx9FQckozGs+GT5CpeFJKmigCd8WumzvcqvMf
	 IH1hJEnNJDYesLK6fNReP78xfK8GLuV1gSvblVxV/qYO/hu1VsQCMHrfrTsrulMhhQ
	 g93AqVsnCllpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	stable@vger.kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 512/752] media: cx23885: Add missing unmap in snd_cx23885_hw_params()
Date: Sat, 28 Feb 2026 12:43:43 -0500
Message-ID: <20260228174750.1542406-512-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 141c81849fab2ad4d6e3fdaff7cbaa873e8b5eb2 ]

In error path, add cx23885_alsa_dma_unmap() to release the
resource acquired by cx23885_alsa_dma_map().

Fixes: 9529a4b0cf49 ("[media] cx23885: drop videobuf abuse in cx23885-alsa")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx23885/cx23885-alsa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index 25dc8d4dc5b73..717fc6c9ef21f 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -392,8 +392,10 @@ static int snd_cx23885_hw_params(struct snd_pcm_substream *substream,
 
 	ret = cx23885_risc_databuffer(chip->pci, &buf->risc, buf->sglist,
 				   chip->period_size, chip->num_periods, 1);
-	if (ret < 0)
+	if (ret < 0) {
+		cx23885_alsa_dma_unmap(chip);
 		goto error;
+	}
 
 	/* Loop back to start of program */
 	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP|RISC_IRQ1|RISC_CNT_INC);
-- 
2.51.0

