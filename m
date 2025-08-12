Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53AA1EBFE0;
	Tue, 12 Aug 2025 17:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021512; cv=none; b=SwiaPirBBu3yUM5Z6Uny672uYLiE4Sx/DYfD8kVVcdcqUe8LhMqItRPH/ypNeNUZKs+fIc/R1ahBk8NmPRcajCPz9ynjATTOw1DIa1XEAJwpk5PTkgGa+zfaI4kmjaM+xegegFACw4Yn8tH32cLSP1HkIy/yC37k67u1LN7/jfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021512; c=relaxed/simple;
	bh=omqrZeJQRNr5XL5YCSW2plgYiVfFWXKhuLGtZ8KKQ/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ajGlxeWf7+YtebXetwLNFFlwJqcjPPQWtZ5rOA0wd7LEDwVQ4uSplPZFXF+lrZ/IvCiRo41KEM2tmTsYOCq0QLk9dETokMZLff/hCcBRL2C8iQ1huNufSIPBnhV5L3iqlUowxid4iWblHjbRJ4c5FUSAyucIaf5jcL+nfJPbPoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkMg9zYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkMg9zYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22357C4CEF0;
	Tue, 12 Aug 2025 17:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021512;
	bh=omqrZeJQRNr5XL5YCSW2plgYiVfFWXKhuLGtZ8KKQ/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkMg9zYUlPvEU9fM/TYgb+opkb8kTBgFC4ZGh5yUU86xqZ2R/XaJ0CXLOIPpaNmAv
	 2cU3g/51z//ZIadK2Hd5cBYvOhcWisWvcLF0/XT4Aw1g9BduC92JPtswITLm9wrL1K
	 fwDa76q4FK5DJT7XQ0vo8eP3c995+t56uQBTTDkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/262] soundwire: stream: restore params when prepare ports fail
Date: Tue, 12 Aug 2025 19:28:52 +0200
Message-ID: <20250812172959.232658088@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 68d54887992d..8ebfa44078e8 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1409,7 +1409,7 @@ static int _sdw_prepare_stream(struct sdw_stream_runtime *stream,
 		if (ret < 0) {
 			dev_err(bus->dev, "Prepare port(s) failed ret = %d\n",
 				ret);
-			return ret;
+			goto restore_params;
 		}
 	}
 
-- 
2.39.5



