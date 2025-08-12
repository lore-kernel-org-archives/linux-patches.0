Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097FF2CA9;
	Tue, 12 Aug 2025 18:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024557; cv=none; b=G2IcmrJ7DUYEchJXzTeSVuGRp3ENidsDUns54JfyJMJ51UCFhIeq7P5VGk08SRt3Ni5wMxET/dac4L5gL0OS+H2ot0FiaD1GsxwBhkLOkLC75BjcpCDlwljN90L5e8hNTSgAeNce9zX49Y7QO8vBfUPVub9cd/RzOnOjDsBU7T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024557; c=relaxed/simple;
	bh=Ml77y9ZPHH577RzfxEDXkjFw6FzqwraltvrxKqo1Z6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dtpU+QL7qax3/8Sb4EwV6Rjp4c/iEKhlk+a2cohMaVV3g+Uj1xObcDXhCmdm4gAAVRKTjMJDdXdpFHHmn6EWVl/jtld5NaByJUxGm74ElQJcHqFAAYL5YcNrai4fbDnCbBmOFdvTtltbGc/ekNBTM/qwa51hUMyHBRRNUmRV2c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AgxR8GH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AgxR8GH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A672C4CEF0;
	Tue, 12 Aug 2025 18:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024556;
	bh=Ml77y9ZPHH577RzfxEDXkjFw6FzqwraltvrxKqo1Z6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AgxR8GHM+ZyY2bbSLwzpiHD87qMJ2tUlII1JJfrc1Ch4E2Se9bNK5jyxk4qp4D2K
	 28hKkl0iE4sS090jVzmUuql4kGXeagFUIV+av+m6hi3a9nj9NPF/w1Ce22sEwH6w/g
	 kqxBbQjPH4mnrfTs4n7sRXINTfD+36ofRCz7cI3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 408/627] soundwire: stream: restore params when prepare ports fail
Date: Tue, 12 Aug 2025 19:31:43 +0200
Message-ID: <20250812173434.804498198@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



