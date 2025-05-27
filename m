Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FB925DAE1;
	Tue, 27 May 2025 17:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366078; cv=none; b=gmEQAkdVUIfp81DSx2obUR4KLr5u+Se+dyPjaRYJaR7zeiad2qqGaG/GYU//4AAKecLFJ7CFu4eETby3h/0kWsmcj4bN+RHk6stmiiszm2t28N4tZLnwS9wN1yOzZLaF+H2ir8vDcrFv/Lza5YJbbizxz72tejiqukW6PH1xUh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366078; c=relaxed/simple;
	bh=h4v8k4XLsvylQuAMZHyCaEfsP7s0q2HOztKeWRs1iwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFh7wCPg1PxN0jYMNMGMV2RHbFFq8NHetTzuvbo35aslxzGTuTo09qG/pX6cdayU7WntxCFDhS7NTGRxjnzCHS/qlPZqtNUmbVxs5rhRttgqoahydEDVX5DeBQ4v6dA3g92HsZUKs/qfkKLLAPVE7Njy8tPUD5f18M2C6jcqSkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzwKN49T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzwKN49T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A9EC4CEE9;
	Tue, 27 May 2025 17:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366078;
	bh=h4v8k4XLsvylQuAMZHyCaEfsP7s0q2HOztKeWRs1iwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzwKN49TX7zA4P6Ozho9L4aSCRYHQIehX+aKnsdrPobMIprR5nHxKcJIDdu0cMO8T
	 wY5AbT6qh2e5NgiPYPyusBIsXoP8gOnF9XjhmnxBM2O7POD53RSJf2pz36PEGUPZGN
	 JbaL86t7S/dYmMSA/ac7uCkndLVJ80IaFJtpKKFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 576/626] ASoC: SOF: Intel: hda-bus: Use PIO mode on ACE2+ platforms
Date: Tue, 27 May 2025 18:27:49 +0200
Message-ID: <20250527162508.377046029@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 4e7010826e96702d7fad13dbe85de4e94052f833 upstream.

Keep using the PIO mode for commands on ACE2+ platforms, similarly how
the legacy stack is configured.

Fixes: 05cf17f1bf6d ("ASoC: SOF: Intel: hda-bus: Use PIO mode for Lunar Lake")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250509081308.13784-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-bus.c b/sound/soc/sof/intel/hda-bus.c
index b1be03011d7e..6492e1cefbfb 100644
--- a/sound/soc/sof/intel/hda-bus.c
+++ b/sound/soc/sof/intel/hda-bus.c
@@ -76,7 +76,7 @@ void sof_hda_bus_init(struct snd_sof_dev *sdev, struct device *dev)
 
 	snd_hdac_ext_bus_init(bus, dev, &bus_core_ops, sof_hda_ext_ops);
 
-	if (chip && chip->hw_ip_version == SOF_INTEL_ACE_2_0)
+	if (chip && chip->hw_ip_version >= SOF_INTEL_ACE_2_0)
 		bus->use_pio_for_commands = true;
 #else
 	snd_hdac_ext_bus_init(bus, dev, NULL, NULL);
-- 
2.49.0



