Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7683C4C33D1;
	Wed, 30 Sep 2026 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786368; cv=none; b=ql3oOWDna9n3aSVViiw73a2rylTQlcU3RegP4ZFkDpmQ66mLDYzD7zD9LAQNj/dc7BdwvB00MunQZghbkiPmW8DOVdzVliyGXBwnJJWr0EuHPVCLq8f9RMQdODtP0GpGUOzjOwl3Q+Qc+2wTnhIDxZE6b8mbYFnUzd4aKWx/x+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786368; c=relaxed/simple;
	bh=xOM7wQ5P3zIBXWtUCEONfikhe/C0VbG89iBXda0t4eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2GJjsRBA/YkPHg5nkob/5YDQPzcQxzvsq7P/8g28Fibm/G/vcggo5gv1iOdkyqhaUBsYfoz+y4md+W+vlqQtTvTJzMW6MsJ/G6ecH91oDAgdFM72LKQza9+HqC1MA6pIMZ6Rjfdbbf/B5Xc2jmacfuOWh0sPkBMkaoq2YGwGq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TklJW0RJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TklJW0RJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF72A1F000FF;
	Wed, 30 Sep 2026 16:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786367;
	bh=684Kk59t9TlmwxDJQYtpqphOpid1bw/a+8APDbceWic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TklJW0RJuaQM6XakmEliu3D0obOh2m8WIAsRSnqmCquqkKDNf/nDmIdsUmh+wuliX
	 sZ/j8CrwYW+0F1XVAIdxDA2V2duscpXMRL3RJ7AkTxNS0BrG5GaYHtTu9Btsl9hss9
	 opaIpys5YLxbunPIinpRUcJ8BNsW9pWXxMMW1KbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 782/982] ASoC: SOF: ipc4-topology: Clarify bind failure caused by missing fw_module
Date: Wed, 30 Sep 2026 17:25:18 +0200
Message-ID: <20260930152433.553270721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit de6aa72b265b72bca2b1897d5000c8f0147d3157 ]

The original patch uses a feature in lib/vsprintf.c to handle the invalid
address when tring to print *_fw_module->man4_module_entry.name when the
*rc_fw_module is NULL.
This case is handled by check_pointer_msg() internally and turns the
invalid pointer to '(efault)' for printing but it is hiding useful
information about the circumstances. Change the print to emmit the name
of the widget and a note on which side's fw_module is missing.

Fixes: e3720f92e023 ("ASoC: SOF: avoid a NULL dereference with unsupported widgets")
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/alsa-devel/4826f662-42f0-4a82-ba32-8bf5f8a03256@kili.mountain/
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Link: https://lore.kernel.org/r/20230403090909.18233-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>

[ Backport to 6.1.y follow-up to e3720f92e023: replace its (efault)
  pointer formatting with source/sink diagnostics; only hunk locations
  differ. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 9540ba6ef659e..ee6f6edec970c 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1601,10 +1601,12 @@ static int sof_ipc4_route_setup(struct snd_sof_dev *sdev, struct snd_sof_route *
 	int ret;
 
 	if (!src_fw_module || !sink_fw_module) {
-		/* The NULL module will print as "(efault)" */
-		dev_err(sdev->dev, "source %s or sink %s widget weren't set up properly\n",
-			src_fw_module->man4_module_entry.name,
-			sink_fw_module->man4_module_entry.name);
+		dev_err(sdev->dev,
+			"cannot bind %s -> %s, no firmware module for: %s%s\n",
+			src_widget->widget->name, sink_widget->widget->name,
+			src_fw_module ? "" : " source",
+			sink_fw_module ? "" : " sink");
+
 		return -ENODEV;
 	}
 
-- 
2.53.0



