Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860FA13EFEC;
	Tue, 27 Feb 2024 13:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041621; cv=none; b=sMOxpSMoQAO03ev6bqnzjy4LcIzxv4/ryNMjO6UXO8JatjcR5dWbvaWCOuBv4yERpXGrW1FrV2hsXUBeqKrMo+BuA+oVZcbcG3RJ80/sYHWToAgwj9tF1wfFcQlSk3ZtaOstlzqk537zJUTg3IXgKgL1VAp2Gi84pKBDzw4y1SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041621; c=relaxed/simple;
	bh=ULbGG5mqEsmilHVZEINh/xAFzKVv4lglBB8soxXNcvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TA8WPNrx21Epa5P/AkG2w6ZG0Jks0yG6PhcuL40hbVzSWQGBv6qeRNPFCQD/LXBDWPPewrzItrM5rceaRMIg4WglgYoIL6wc4NrZA9E97YAeuvfEQV7Sls/0Pyfy4BnfOa+bvCi3g8GvwVa4P4mc5ImV4bOPm3C56LyHcqAj4+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKL01f96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKL01f96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1060DC433C7;
	Tue, 27 Feb 2024 13:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041621;
	bh=ULbGG5mqEsmilHVZEINh/xAFzKVv4lglBB8soxXNcvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKL01f96UiTHzdeAQwXDBJg8101UacxB7TQ/MM5R6y5Aze+inylUMMoWl831DNrM6
	 mLRd6Hgb0GLGA7FO53aLJVDz3cN1py6P7IYh/fx7QuW3XtcFI7MtnYBa5TJ3xhaDnb
	 ojRN7Ier+p0n87g6bt8SepHgg8xn/Ic+jIb6KHuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/299] dmaengine: dw-edma: increase size of name in debugfs code
Date: Tue, 27 Feb 2024 14:22:04 +0100
Message-ID: <20240227131626.263137880@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit cb95a4fa50bbc1262bfb7fea482388a50b12948f ]

We seem to have hit warnings of 'output may be truncated' which is fixed
by increasing the size of 'name'

drivers/dma/dw-edma/dw-hdma-v0-debugfs.c: In function ‘dw_hdma_v0_debugfs_on’:
drivers/dma/dw-edma/dw-hdma-v0-debugfs.c:125:50: error: ‘%d’ directive output may be truncated writing between 1 and 11 bytes into a region of size 8 [-Werror=format-truncation=]
  125 |                 snprintf(name, sizeof(name), "%s:%d", CHANNEL_STR, i);
      |                                                  ^~

drivers/dma/dw-edma/dw-hdma-v0-debugfs.c: In function ‘dw_hdma_v0_debugfs_on’:
drivers/dma/dw-edma/dw-hdma-v0-debugfs.c:142:50: error: ‘%d’ directive output may be truncated writing between 1 and 11 bytes into a region of size 8 [-Werror=format-truncation=]
  142 |                 snprintf(name, sizeof(name), "%s:%d", CHANNEL_STR, i);
      |                                                  ^~
drivers/dma/dw-edma/dw-edma-v0-debugfs.c: In function ‘dw_edma_debugfs_regs_wr’:
drivers/dma/dw-edma/dw-edma-v0-debugfs.c:193:50: error: ‘%d’ directive output may be truncated writing between 1 and 11 bytes into a region of size 8 [-Werror=format-truncation=]
  193 |                 snprintf(name, sizeof(name), "%s:%d", CHANNEL_STR, i);
      |                                                  ^~

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-v0-debugfs.c | 4 ++--
 drivers/dma/dw-edma/dw-hdma-v0-debugfs.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-edma-v0-debugfs.c b/drivers/dma/dw-edma/dw-edma-v0-debugfs.c
index 0745d9e7d259b..406f169b09a75 100644
--- a/drivers/dma/dw-edma/dw-edma-v0-debugfs.c
+++ b/drivers/dma/dw-edma/dw-edma-v0-debugfs.c
@@ -176,7 +176,7 @@ dw_edma_debugfs_regs_wr(struct dw_edma *dw, struct dentry *dent)
 	};
 	struct dentry *regs_dent, *ch_dent;
 	int nr_entries, i;
-	char name[16];
+	char name[32];
 
 	regs_dent = debugfs_create_dir(WRITE_STR, dent);
 
@@ -239,7 +239,7 @@ static noinline_for_stack void dw_edma_debugfs_regs_rd(struct dw_edma *dw,
 	};
 	struct dentry *regs_dent, *ch_dent;
 	int nr_entries, i;
-	char name[16];
+	char name[32];
 
 	regs_dent = debugfs_create_dir(READ_STR, dent);
 
diff --git a/drivers/dma/dw-edma/dw-hdma-v0-debugfs.c b/drivers/dma/dw-edma/dw-hdma-v0-debugfs.c
index 520c81978b085..dcdc57fe976c1 100644
--- a/drivers/dma/dw-edma/dw-hdma-v0-debugfs.c
+++ b/drivers/dma/dw-edma/dw-hdma-v0-debugfs.c
@@ -116,7 +116,7 @@ static void dw_hdma_debugfs_regs_ch(struct dw_edma *dw, enum dw_edma_dir dir,
 static void dw_hdma_debugfs_regs_wr(struct dw_edma *dw, struct dentry *dent)
 {
 	struct dentry *regs_dent, *ch_dent;
-	char name[16];
+	char name[32];
 	int i;
 
 	regs_dent = debugfs_create_dir(WRITE_STR, dent);
@@ -133,7 +133,7 @@ static void dw_hdma_debugfs_regs_wr(struct dw_edma *dw, struct dentry *dent)
 static void dw_hdma_debugfs_regs_rd(struct dw_edma *dw, struct dentry *dent)
 {
 	struct dentry *regs_dent, *ch_dent;
-	char name[16];
+	char name[32];
 	int i;
 
 	regs_dent = debugfs_create_dir(READ_STR, dent);
-- 
2.43.0



