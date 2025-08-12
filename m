Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878B429BD9A;
	Tue, 12 Aug 2025 19:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026415; cv=none; b=h522ItBb12DeBXl3w+WoFJcVQFcZlgpNmv4QAk+cu7KGPsfnhhUuHBoI9SBxsxC4Jn72scNIsSlQA6ckjbk8Wgi6XsYBwaaBAITsIYXEd+8cgoRHN4cZEWUkIqRK1HklSitO6szNCHmL438F79JXC1bBHuK11k+XToiGHaZslJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026415; c=relaxed/simple;
	bh=tf5mqeEkc8TaAPxXzAioFfDzI3b1jdzK9SM0MZic1nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b3ZIC6N+EBm9GnwdJOTaDpcMx2nNCsksvudfYKyaaBcFMap6yKubNF7XY1QE27xis8XGk+MB1rsFe3SCTotgH/XI0m5eC3QfFgIKlBxOWeKvvPojQSSusSuEvFE8ElntxNyHIujShquArDAQRAwTkfKwniKWoPHerQH257yL/RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeVTcKoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeVTcKoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D0CC4CEF0;
	Tue, 12 Aug 2025 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026415;
	bh=tf5mqeEkc8TaAPxXzAioFfDzI3b1jdzK9SM0MZic1nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeVTcKoB5+EI2gwATXFLVBU9n81dgDlwEtIEU9nQ1YmJ82Ah8rG4/IQcnldh6lPlM
	 IgF9zJgyJdvzykNbDp1sHGfqZCBBIK/dc85bQmX2iILfvBFWV3uyp00sEuWFIsCkvf
	 MX+rXCD4PLZqdgWQwgWRz1NzcxTMXVmmcvBTTPnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 297/480] soundwire: stream: restore params when prepare ports fail
Date: Tue, 12 Aug 2025 19:48:25 +0200
Message-ID: <20250812174409.682107090@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a4bea742b5d9..38c9dbd35606 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1510,7 +1510,7 @@ static int _sdw_prepare_stream(struct sdw_stream_runtime *stream,
 		if (ret < 0) {
 			dev_err(bus->dev, "Prepare port(s) failed ret = %d\n",
 				ret);
-			return ret;
+			goto restore_params;
 		}
 	}
 
-- 
2.39.5



