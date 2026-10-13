Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426FE35F18B;
	Tue, 13 Oct 2026 12:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894654; cv=none; b=fZGAeCdea0zlYMngPQOv7NdNuxcBhf9rsSpam57P3CnwqA0yJpLXLXKnQ0bKzOXDBKUSdZNvi1187WdrLAtV1PhYihoz0dlJYCU9Y9deRV0T5OHdwEzbzUdpO5iV22TJxrt1BdoeviYdmzl6uNUxzMsVFRGh48J+jOO3sROtGzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894654; c=relaxed/simple;
	bh=n7DUo2nQ2OAru94YwG/rxlHEqBNqvQevYRuTMLJhHGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjoMQKRCEswd07aH7TMWl24iW8fj1BuBhhyReu2fU120GiyfTylWlX/+k5OjMHOypTA+0B5vRrazhqwuPATvQ8EXnX09ICde/J7v1LITVMuhADtJDakNJ2hJauiDPMHGopkEkGI3oHQ9L96SXidPi2dDBjnAT6bi06BJtWiao0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naPUYOub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naPUYOub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EC91F000FF;
	Tue, 13 Oct 2026 12:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894653;
	bh=ex+l2u+7PX6fvBmkKuAdbenbgKV+y9sY5DZqqAzIyac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=naPUYOubHdsf3x5a7RxqHEIuUVuJ4BfvSm8UVUj/xNj6x0kcnf2/IKmcp+vF6OPIm
	 vIEKgDmS+HUm2R/GuLGeelk/kNMTcMlA+ffnZ/IuHOTNe6cDxQno40O29sbX0N1+ZO
	 BnTuDcO4RqAXbNMjbXRJVToRhIiVwVBugHStI3rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/497] ASoC: SOF: ipc4-priv: Add kernel doc for fw_context_save of sof_ipc4_fw_data
Date: Tue, 13 Oct 2026 13:32:59 +0200
Message-ID: <20261013112908.171074615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit cec49fa47bccadb288fd984ef2a5c45e8a2e2099 ]

The kernel documentation is missing entry for the fw_context_save.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20250619105623.4546-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-priv.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/ipc4-priv.h b/sound/soc/sof/ipc4-priv.h
index ea3323b90343d..0889de04b0170 100644
--- a/sound/soc/sof/ipc4-priv.h
+++ b/sound/soc/sof/ipc4-priv.h
@@ -71,6 +71,7 @@ struct sof_ipc4_fw_library {
  * @max_num_pipelines: max number of pipelines
  * @max_libs_count: Maximum number of libraries support by the FW including the
  *		    base firmware
+ * @fw_context_save: Firmware supports full context save and restore
  *
  * @load_library: Callback function for platform dependent library loading
  * @pipeline_state_mutex: Mutex to protect pipeline triggers, ref counts, states and deletion
-- 
2.53.0



