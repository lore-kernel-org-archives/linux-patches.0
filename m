Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C51435208B;
	Tue, 26 Aug 2025 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218835; cv=none; b=Y+esKSdN/XA3ViKwtmBTarQb8SSd1HJ3tQF6YroiWzDmXnaIQi7saZKn/0kjeJ9g+/mjja2g93kmyLPN50XOxxWZPMinDegdhrs62hB8INEH27eAM3RVMAGBGEbjoh2DCtAj5WnfuOeSYOzVl3aW5rpXEE6Z1R9B7qeIV7xdLOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218835; c=relaxed/simple;
	bh=oaYjI6oVFfD23Fn6Toz6wNpGYQK/SonMs7/8vBFkAzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q67YUw1MnB6HJfRzSEyEulQOo95yJlnFHjJUhI1kt0dM/id/XRfkhKv4aGytkF6H4LSvHm5wWeNPOgb44GkSq42coSISHHBCS8WCWnSIYZEiG11yxctBdtM6q05qt0LO/OMsNXzLILMGMnnXidDx1nkNWZfmj4YrDpaYUjnVf8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxeM/6Qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxeM/6Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC171C4CEF1;
	Tue, 26 Aug 2025 14:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218835;
	bh=oaYjI6oVFfD23Fn6Toz6wNpGYQK/SonMs7/8vBFkAzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxeM/6Qid2xA7MNIlo/ToZTFvESQcOOO+tMDAyDM/cL4zfoVw196HWbzecpGi/lxJ
	 Es1oX02cRs9tni5yjDuASYyBsbBhFQ+8lt7i0VrjF7yweVmeezy5Sv7Sqzq4kUo/Eh
	 QkfXaSM8t41lZtYhpzy1lhA0s7JA2GIsPQnpJ1ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/403] soundwire: stream: restore params when prepare ports fail
Date: Tue, 26 Aug 2025 13:07:26 +0200
Message-ID: <20250826110910.051104930@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3b3f909407c3..6e4c7bf9eb0d 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1532,7 +1532,7 @@ static int _sdw_prepare_stream(struct sdw_stream_runtime *stream)
 		if (ret < 0) {
 			dev_err(bus->dev, "Prepare port(s) failed ret = %d\n",
 				ret);
-			return ret;
+			goto restore_params;
 		}
 	}
 
-- 
2.39.5



