Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EF155293A;
	Wed, 30 Sep 2026 17:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789735; cv=none; b=dab4vInX7YgqhFovOKlvUbZ5BmNYNwD5nsGz8xeMJ/F4wu4nRj3cFw0iJwCPYZp7UKRjKrc4AD59kVy44eIPXsrXhJPpzfJk4ReC7Al6VdrRBqPaGV96QRTksgLIf12KLuV6rOeKZg8xehcSm9lVgDvFAaICCCG7XjXUl+4q9Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789735; c=relaxed/simple;
	bh=kSHRADq/umigiDhYxGkwDytQo+BJuYFCmJpBg0thGW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HCqN3tCkdOVnZhETvcV/Jxu3d8Tg6m3NCp1JUqyqfameb1GLLa9gfrC72tyu8sMDOmGCMYiRziKVah0CteCLjFcLWjeCi8ccok4VoeWl4rHbUDXkeidUHJrtCZH3tMr5b2NmLnTPGXZrK33VMeTpPZZEO4dqit0GHomq8R7Qjkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gECFTj07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gECFTj07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE6F1F000FF;
	Wed, 30 Sep 2026 17:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789732;
	bh=l2XzgA6OxLEwgspHFswW8ZKFl/MjeY0D2Pki06+nxqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gECFTj07IzS+ncDUwTebmUQLTGY0FdwNq/BH6e5q/sWMyATIjdzIY7QuA9m6qkKdV
	 lPoyMBnBdZ7TBfC4+Tpje9MPu9Ewk3etZvcnRvDTXjBd878428YuVXtcV8aZO5aSYV
	 DGEthDogqiLg4Lq1yrJxx8uo5kyn8B3nZ86a8/yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 580/877] platform/x86: ISST: Validate max level for set feature
Date: Wed, 30 Sep 2026 17:24:51 +0200
Message-ID: <20260930152427.160296266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit e45d6b8472861d3bac86bb37f8556a7c5aca3266 ]

Validate the level before setting, so that it fails early instead of
failing later when checking the bit mask for allowed levels.

Fixes: ea009e4769fa3 ("platform/x86: ISST: Add SST-PP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-3-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -969,6 +969,9 @@ static int isst_if_set_perf_level(void _
 	if (!power_domain_info)
 		return -EINVAL;
 
+	if (perf_level.level > power_domain_info->max_level)
+		return -EINVAL;
+
 	if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 


