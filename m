Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAF72E62B4;
	Tue, 15 Jul 2025 13:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587060; cv=none; b=fL0n4YPYNzp/HPiLaQBjpOeJNd2hWI4NaVY7avNo+vHapFEI6LRb7k9yzgjjiORUJy3n249F5Q8S7d4xjmsDKIvxjXFPYuD50NTLdvZ+WKhVIFkb2BQa7Qb+BpN/HbdYA8jnjBF+J7FMowynfgemmfYOckYQO36p+wjc4jksjC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587060; c=relaxed/simple;
	bh=YGeZ4tyg2IPURAAB1LKloqsbQhN3zGTq4v7wuvGghuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYt5KfkV+xALxew50XYaNMdj57X0PNqM78nrTLqM0SISzfvJ6Mr5q/UC/24p4JPiP9kAwpSvSEwiOYnxGgRCA4x+dfX+v74Kt+caNmygqmae6Cy9ZeTeln+mosyWOAXRJMmHhdq1lfPpV8SP696o67zTPQYG9wfYO1FQTJkRWlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZgm4tOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZgm4tOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12478C4CEE3;
	Tue, 15 Jul 2025 13:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587060;
	bh=YGeZ4tyg2IPURAAB1LKloqsbQhN3zGTq4v7wuvGghuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZgm4tOp6EsRuwj3uERpxf7Ufxfj7H4Lqx+AmSmAqjLDKbi/ElOPPvx8YLxw3dyIf
	 9ZzhpJG47YkxkYJlThuXVvEMsTFBhhDA3iUmx4k5mFGoUUymmdQukdlHoNcq9LMCqk
	 z/stLhxpWY9DvQnlM0vN6lD0jGTzvnQK8on2+rF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.15 124/192] ASoC: Intel: sof-function-topology-lib: Print out the unsupported dmic count
Date: Tue, 15 Jul 2025 15:13:39 +0200
Message-ID: <20250715130819.869750090@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 16ea4666bbb7f5bd1130fa2d75631ccf8b62362e upstream.

It is better to print out the non supported num_dmics than printing that
it is not matching with 2 or 4.

Fixes: 2fbeff33381c ("ASoC: Intel: add sof_sdw_get_tplg_files ops")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20250619104705.26057-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/common/sof-function-topology-lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/intel/common/sof-function-topology-lib.c
+++ b/sound/soc/intel/common/sof-function-topology-lib.c
@@ -73,7 +73,8 @@ int sof_sdw_get_tplg_files(struct snd_so
 				break;
 			default:
 				dev_warn(card->dev,
-					 "only -2ch and -4ch are supported for dmic\n");
+					 "unsupported number of dmics: %d\n",
+					 mach_params.dmic_num);
 				continue;
 			}
 			tplg_dev = TPLG_DEVICE_INTEL_PCH_DMIC;


