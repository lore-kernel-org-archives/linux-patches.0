Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A41334709;
	Mon, 18 Aug 2025 14:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525634; cv=none; b=cjnddTMR5lEjxZgJmvzuYBdQn9Dd+TYNrCaO51VjpjDSx3eSnH+Wtt9El6/J4UVvS/JFHAkNtpLVGbG3cGSFF83/Tkb4LSs3pHdHRxxaHN9tLhyv4iOwwkDdNtWVuMrsuhuV8NGVqGlPnD/MkQNJnmGCoLweke+5Ff0SOXEe8+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525634; c=relaxed/simple;
	bh=z3BZ7mGIqBde72W3g2cnJ7KTdh480Zz+rZA7P4FZ1O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYgX+KA9PMaK+Xbka3QBRjdEenIIlVMLP59I/Oa0c7OWQYLW6K1HSZqXqIVoWps4qECJqaKAzlOJJXTcahdxUONlCjtOV+Tr58EVdCAFMiGZY5YwCrwd+1uwPSj0OZnC+DH4K9OS1k2QoiA6go3SK8StKNpCtjaBM2VySb6X2J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgomF9t4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgomF9t4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0ABC4CEEB;
	Mon, 18 Aug 2025 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525634;
	bh=z3BZ7mGIqBde72W3g2cnJ7KTdh480Zz+rZA7P4FZ1O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PgomF9t4x8b3FJX/99m/1F4PgrN90YWCJfugvSmmWQl8TsSNHfe44rDOv5EqxnkY/
	 Fj5LoYYWrH1+VzwxSvaQtZJjArCfSGv4OIytV8j8GUgXaaqeYvt1V555HUV4cPppjL
	 PBfBg0x+fWSFRg6JfLeEAJBp37wRRQ4pAr4Yn2eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 322/570] drm/amd/pm: Use pointer type for typecheck()
Date: Mon, 18 Aug 2025 14:45:09 +0200
Message-ID: <20250818124518.259930596@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit b49e3d7ca71aaf1e3412d41522a11a56563799b5 ]

typecheck creates local variables based on the type passed. That could
result in stack frame size warnings like below in certain configs:

drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:2885:1: error: the frame size of 8304 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Checking against the pointer type is sufficient for the purpose of
getting a diagnostic message during build time.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Palmer Dabbelt <palmer@dabbelt.com>
Tested-by: Palmer Dabbelt <palmer@dabbelt.com>
Link: https://lore.kernel.org/r/20250610212141.19445-1-palmer@dabbelt.com
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h | 41 +++++++++++++-------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h
index 7473672abd2a..a608cdbdada4 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h
@@ -40,28 +40,29 @@
 #define SMU_IH_INTERRUPT_CONTEXT_ID_FAN_ABNORMAL        0x8
 #define SMU_IH_INTERRUPT_CONTEXT_ID_FAN_RECOVERY        0x9
 
-#define smu_cmn_init_soft_gpu_metrics(ptr, frev, crev)         \
-	do {                                                   \
-		typecheck(struct gpu_metrics_v##frev##_##crev, \
-			  typeof(*(ptr)));                     \
-		struct metrics_table_header *header =          \
-			(struct metrics_table_header *)(ptr);  \
-		memset(header, 0xFF, sizeof(*(ptr)));          \
-		header->format_revision = frev;                \
-		header->content_revision = crev;               \
-		header->structure_size = sizeof(*(ptr));       \
+#define smu_cmn_init_soft_gpu_metrics(ptr, frev, crev)                   \
+	do {                                                             \
+		typecheck(struct gpu_metrics_v##frev##_##crev *, (ptr)); \
+		struct gpu_metrics_v##frev##_##crev *tmp = (ptr);        \
+		struct metrics_table_header *header =                    \
+			(struct metrics_table_header *)tmp;              \
+		memset(header, 0xFF, sizeof(*tmp));                      \
+		header->format_revision = frev;                          \
+		header->content_revision = crev;                         \
+		header->structure_size = sizeof(*tmp);                   \
 	} while (0)
 
-#define smu_cmn_init_partition_metrics(ptr, frev, crev)                     \
-	do {                                                                \
-		typecheck(struct amdgpu_partition_metrics_v##frev##_##crev, \
-			  typeof(*(ptr)));                                  \
-		struct metrics_table_header *header =                       \
-			(struct metrics_table_header *)(ptr);               \
-		memset(header, 0xFF, sizeof(*(ptr)));                       \
-		header->format_revision = frev;                             \
-		header->content_revision = crev;                            \
-		header->structure_size = sizeof(*(ptr));                    \
+#define smu_cmn_init_partition_metrics(ptr, fr, cr)                        \
+	do {                                                               \
+		typecheck(struct amdgpu_partition_metrics_v##fr##_##cr *,  \
+			  (ptr));                                          \
+		struct amdgpu_partition_metrics_v##fr##_##cr *tmp = (ptr); \
+		struct metrics_table_header *header =                      \
+			(struct metrics_table_header *)tmp;                \
+		memset(header, 0xFF, sizeof(*tmp));                        \
+		header->format_revision = fr;                              \
+		header->content_revision = cr;                             \
+		header->structure_size = sizeof(*tmp);                     \
 	} while (0)
 
 extern const int link_speed[];
-- 
2.39.5



