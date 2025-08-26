Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1041D26B747;
	Tue, 26 Aug 2025 13:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215858; cv=none; b=awJ8+JQsTmtHsJ79Apos+2xHIXxELc2jo0pQy1ERT8iMQO9oN/cQ8+SYhDT0iWbmXqw8nJdemgE2pVm2+tcRmjzp1lyOLJl6Wm92dcAF5TAoYhGUxA7byZQNFo5YRRVSZyW4rWUtuXd4ovdpUDtx9IJQXdDm8PzfMxSvS6nll8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215858; c=relaxed/simple;
	bh=EhO5/GVmxP29CyYjCvy4Bg/FhJxjTQkJ3psTtU79EMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NVgl7ehpBqsiF98WROX9mEd+uFOunc7MHSlGOTSL6k4BjDVCjkjXxMULurbifIWLlNuG3wG1KZ3zlcwJgGU+TjQn1s8ttOVKFXda0D4JmoXi1qTOtQqPFV/U79kus931+WJ6lMHG7gBkPmpPb5FO4IepPtMec7QawTVoES87uIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gU31Ouo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gU31Ouo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E07BC4CEF1;
	Tue, 26 Aug 2025 13:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215854;
	bh=EhO5/GVmxP29CyYjCvy4Bg/FhJxjTQkJ3psTtU79EMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gU31OuoSU2N3EAux9HGTpr+ceKkyau+YPvap5AuAZH3v1sqBdpgliOR3x+Q81usI
	 lbQYGwIIR2VtNErs5OaIuw3LmbgH1ZxQZmsOqe5INq0fvMCir5eP6m1lfukPyZInyg
	 ZEQHQwS01vg44UT4OkDEXj3faLdcQFxxTq+WtcQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/644] soundwire: stream: restore params when prepare ports fail
Date: Tue, 26 Aug 2025 13:04:41 +0200
Message-ID: <20250826110951.164627137@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit dba7d9dbfdc4389361ff3a910e767d3cfca22587 ]

The bus->params should be restored if the stream is failed to prepare.
The issue exists since beginning. The Fixes tag just indicates the
first commit that the commit can be applied to.

Fixes: 17ed5bef49f4 ("soundwire: add missing newlines in dynamic debug logs")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20250626060952.405996-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/stream.c b/drivers/soundwire/stream.c
index 8f9f4ee7860c..1b62cdadb089 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1575,7 +1575,7 @@ static int _sdw_prepare_stream(struct sdw_stream_runtime *stream,
 		if (ret < 0) {
 			dev_err(bus->dev, "Prepare port(s) failed ret = %d\n",
 				ret);
-			return ret;
+			goto restore_params;
 		}
 	}
 
-- 
2.39.5



