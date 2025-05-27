Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769992566;
	Tue, 27 May 2025 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368506; cv=none; b=VZ4cETNAxbnGCF6mogPaXcCIpxZH0NegBC2xojEWoCtL9jzaSR+/2b3PV0ZzYYic13CqICU5SHgFGGlxIaW0mYK+T9kxy1rrhL34LVBoHzOVjlLT9obEX3AXGuy8Ydf3ump3hofLpLmFKrOm/B3cghkJ117U63h8lG9CEliiB9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368506; c=relaxed/simple;
	bh=cx1OW/EJCnuo6qu+rh91UqZ0hVPOK0ORQGSdVM8XYnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXgBMuzRljgPltS6X+FTs1jGwu1srxHtVqUp/bUIJlPSgjzJdZnwiSgCYcPnfNgcFgz6ZSHso9dCAfwz4LReTp7a8YVDXK4wodOtFTtDzlXRgFu3KywalE0hFISZxH4Wr8T+CoIvJNhT2+3yra8gMXj8vUL4ulSM1thZTS9XGGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gzmi+32j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gzmi+32j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E72C4CEE9;
	Tue, 27 May 2025 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368506;
	bh=cx1OW/EJCnuo6qu+rh91UqZ0hVPOK0ORQGSdVM8XYnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gzmi+32joYf92Uqf5cmBQqzrsimYE0uk41h8aORKn2llSLmXBB6rfmmxcl7HrBEXL
	 LKL5NK44/tYU+o2++SM6puzQZJrw2Euyr0LX+G91JMheDEsnOxXOBvGXFKes6NA/h8
	 NgQkWk5/aRmPqLW7CQossLO0LLNvRJKmgR7cDSmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 728/783] ASoC: SOF: Intel: hda-bus: Use PIO mode on ACE2+ platforms
Date: Tue, 27 May 2025 18:28:45 +0200
Message-ID: <20250527162542.766876709@linuxfoundation.org>
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
 sound/soc/sof/intel/hda-bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/sof/intel/hda-bus.c
+++ b/sound/soc/sof/intel/hda-bus.c
@@ -76,7 +76,7 @@ void sof_hda_bus_init(struct snd_sof_dev
 
 	snd_hdac_ext_bus_init(bus, dev, &bus_core_ops, sof_hda_ext_ops);
 
-	if (chip && chip->hw_ip_version == SOF_INTEL_ACE_2_0)
+	if (chip && chip->hw_ip_version >= SOF_INTEL_ACE_2_0)
 		bus->use_pio_for_commands = true;
 #else
 	snd_hdac_ext_bus_init(bus, dev, NULL, NULL);


