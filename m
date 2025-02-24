Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A01192B96;
	Mon, 24 Feb 2025 14:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407965; cv=none; b=TZ+AtbfouG586N5TL/z4jagORpLp2T5n1h5xuiove4POCuYAZEQPMOZE1yJrcdtxcm+B2OGsSvkgDGqVMjtgxJofcs4l7c+ZpH2dqSS5w9elVKTjGGRd45k+Tix7px2XYo4RNQ7t1jSbqYyB9uNFRMFYl4wrtDa/opUU8kKSGcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407965; c=relaxed/simple;
	bh=OKcU3RV+5ezdb72Wf4TRNpWOg0Wwb/RaSn7knm2gHpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foOdeQwOFkFtBbnJ5ZpG4ioL01dHXOrDgfZfl//Qma5pqLq2MTLLf7fQSmkG/JK4zcrjPk7ParyT0rzhtszCjj0KQCaepha8lYCk3zmTMUxtWft09SZhu8yEGzOCV+Kfw9bwO4/qmFUhGhqmKpC/HqUBssVsvMKq7fkyA7WZUaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyXpjNwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyXpjNwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0474DC4CED6;
	Mon, 24 Feb 2025 14:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407965;
	bh=OKcU3RV+5ezdb72Wf4TRNpWOg0Wwb/RaSn7knm2gHpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyXpjNwAdUKOJgdon0oDGWD92ZR+JIE8r4BmwJG5rBzcRtL6keFDa9VT9ki+p1lW4
	 bMPI82PEF7vLfEgoTbf4+s8SQvmYwrcVLy940WdeYKxsnT6ukovnX3uUjYfFkdXFls
	 7nZjlAsoYOLUCiUPsllBw1jR8nxyVc9eYn70Mkro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/140] nvmem: Simplify the ->add_cells() hook
Date: Mon, 24 Feb 2025 15:34:18 +0100
Message-ID: <20250224142605.333632488@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 1b7c298a4ecbc28cc6ee94005734bff55eb83d22 ]

The layout entry is not used and will anyway be made useless by the new
layout bus infrastructure coming next, so drop it. While at it, clarify
the kdoc entry.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231215111536.316972-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 391b06ecb63e ("nvmem: imx-ocotp-ele: fix MAC address byte order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c             | 2 +-
 drivers/nvmem/layouts/onie-tlv.c | 3 +--
 drivers/nvmem/layouts/sl28vpd.c  | 3 +--
 include/linux/nvmem-provider.h   | 8 +++-----
 4 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index ec35886e921a8..ed8a1cba361e2 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -815,7 +815,7 @@ static int nvmem_add_cells_from_layout(struct nvmem_device *nvmem)
 	int ret;
 
 	if (layout && layout->add_cells) {
-		ret = layout->add_cells(&nvmem->dev, nvmem, layout);
+		ret = layout->add_cells(&nvmem->dev, nvmem);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/nvmem/layouts/onie-tlv.c b/drivers/nvmem/layouts/onie-tlv.c
index 59fc87ccfcffe..defd42d4375cc 100644
--- a/drivers/nvmem/layouts/onie-tlv.c
+++ b/drivers/nvmem/layouts/onie-tlv.c
@@ -182,8 +182,7 @@ static bool onie_tlv_crc_is_valid(struct device *dev, size_t table_len, u8 *tabl
 	return true;
 }
 
-static int onie_tlv_parse_table(struct device *dev, struct nvmem_device *nvmem,
-				struct nvmem_layout *layout)
+static int onie_tlv_parse_table(struct device *dev, struct nvmem_device *nvmem)
 {
 	struct onie_tlv_hdr hdr;
 	size_t table_len, data_len, hdr_len;
diff --git a/drivers/nvmem/layouts/sl28vpd.c b/drivers/nvmem/layouts/sl28vpd.c
index 05671371f6316..26c7cf21b5233 100644
--- a/drivers/nvmem/layouts/sl28vpd.c
+++ b/drivers/nvmem/layouts/sl28vpd.c
@@ -80,8 +80,7 @@ static int sl28vpd_v1_check_crc(struct device *dev, struct nvmem_device *nvmem)
 	return 0;
 }
 
-static int sl28vpd_add_cells(struct device *dev, struct nvmem_device *nvmem,
-			     struct nvmem_layout *layout)
+static int sl28vpd_add_cells(struct device *dev, struct nvmem_device *nvmem)
 {
 	const struct nvmem_cell_info *pinfo;
 	struct nvmem_cell_info info = {0};
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index 1b81adebdb8be..ecd580ee84db9 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -158,9 +158,8 @@ struct nvmem_cell_table {
  *
  * @name:		Layout name.
  * @of_match_table:	Open firmware match table.
- * @add_cells:		Will be called if a nvmem device is found which
- *			has this layout. The function will add layout
- *			specific cells with nvmem_add_one_cell().
+ * @add_cells:		Called to populate the layout using
+ *			nvmem_add_one_cell().
  * @fixup_cell_info:	Will be called before a cell is added. Can be
  *			used to modify the nvmem_cell_info.
  * @owner:		Pointer to struct module.
@@ -174,8 +173,7 @@ struct nvmem_cell_table {
 struct nvmem_layout {
 	const char *name;
 	const struct of_device_id *of_match_table;
-	int (*add_cells)(struct device *dev, struct nvmem_device *nvmem,
-			 struct nvmem_layout *layout);
+	int (*add_cells)(struct device *dev, struct nvmem_device *nvmem);
 	void (*fixup_cell_info)(struct nvmem_device *nvmem,
 				struct nvmem_layout *layout,
 				struct nvmem_cell_info *cell);
-- 
2.39.5



