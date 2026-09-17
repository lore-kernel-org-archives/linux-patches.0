Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909624ED189;
	Thu, 17 Sep 2026 15:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660787; cv=none; b=B8mZQp8fnzqgtQo4S7i9X3PhnuLecACHq0aInWeFNyv9q6Yp+m5crWwRbI+71dadQONU8Bccxk4U6eiezNLyp5abqv0413QB2UEdjEag9sbdzpEBC0bxaQlRRzaUn1m2GrYDxK8ArH30EVXZ1II/BXgmCN7nThw1lOgLzJ1+GU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660787; c=relaxed/simple;
	bh=ggLwmefGluXipHlpH/yCcPO2C8E7qs63Q/ByZwXyf34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btrBy4L4gplnSD28QgH6EvhHMFF8GamHKYRsR9oysGT9GMRW6mF62ndUatUae19tChDZwMcWesi+H9uTLhRmc8+YlVHr3f77iWoWym8oAI5qwK1Xd5PQFt+FJWz/AK6ZnN4yCqtMufi/fuYO1L985tmj105yI7bb4Q3astLcQlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXS8yZ7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXS8yZ7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2751F000FF;
	Thu, 17 Sep 2026 15:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660786;
	bh=OXh1gcHsz6ESSJYC0dL+s5mkIybYR7t91AwXBMuWxpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXS8yZ7pocSX/uOOmeKz535tc3TzAHUWMC80KveymZBH7ZO0/kqZgKCDb/tpyiB9U
	 Tv7YBYTbp+tdbIlj+uY0tgzkYOKm23tcASE+oNMrnXfGHiqQXFFvv0TeYaO1WABwcU
	 HRVGMMdrmlK2R8daXzyNs6ZDUdObdGQnysezFcWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 710/733] accel/amdxdna: Disable device buffer exporting
Date: Thu, 17 Sep 2026 16:16:58 +0100
Message-ID: <20260917151410.581543002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 9480dd7ec3fcadd4217503e4bb32c16e19e4b21f ]

Device buffers are never intended to be exported. Disable exporting
support explicitly.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260526185058.1780869-1-lizhi.hou@amd.com
Stable-dep-of: f43fa4b8522b ("drm/xe/i2c: Fix the interrupt handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -758,9 +758,15 @@ static int amdxdna_gem_dev_obj_vmap(stru
 	return 0;
 }
 
+static struct dma_buf *amdxdna_gem_dev_obj_export(struct drm_gem_object *gobj, int flags)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static const struct drm_gem_object_funcs amdxdna_gem_dev_obj_funcs = {
 	.free = amdxdna_gem_dev_obj_free,
 	.vmap = amdxdna_gem_dev_obj_vmap,
+	.export = amdxdna_gem_dev_obj_export,
 };
 
 static const struct drm_gem_object_funcs amdxdna_gem_shmem_funcs = {


