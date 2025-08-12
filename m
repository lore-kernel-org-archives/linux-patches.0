Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD35C2F8BE6;
	Tue, 12 Aug 2025 17:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020791; cv=none; b=XmPuTAMmF99Th+ytuDIsU+JG09PIZjz7Zo2bO8aouZSyPUqw9LwGvPRsqHoECpd8re2PePXnPxNKsZR2OzzoQHB5spO9na7rPWTecqrA0Km0XZ2A9UAmfPj3fUMtnCiLBp0Y7t6CbbDpMExof+Z2lPJh8B5kl3sY50m/PIaYDlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020791; c=relaxed/simple;
	bh=CcFSHaDcIryAl15vp/HPKHGlIE5/td6+3wk/vcPj5n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DokkTmItOh3184XxBIkOG398OQijWXYcvrSF3vtwBYL2hKzr7+x4OPo78MxtmEn94qzcMSRJS2wVY8WhC7c0Kn9TCN/Av46ET0yKjqN/gTs00N6rIdhEPBlAgewdWyHwUj2rNElS0snB2GEzw+2+ef3MWX1inVyfqFeF7AAaG5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EagPXAl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EagPXAl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51266C4CEF0;
	Tue, 12 Aug 2025 17:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020790;
	bh=CcFSHaDcIryAl15vp/HPKHGlIE5/td6+3wk/vcPj5n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EagPXAl72yOXu5QojeJDuyqVeowq1aB4GIm3qkx3Irs6QQwLjk7pCukjoLVdWC3OB
	 glI6KQZpxYHXO+nKxcnHhfsNKq9OJt5QMjUE8lbvZ3LVRwFA5Rdgw85mScsuiJ+8Xz
	 VMz8i+NZhXF6SmzrDKIpQj+pDlgzESeMCEmBg/xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/253] soundwire: stream: restore params when prepare ports fail
Date: Tue, 12 Aug 2025 19:29:17 +0200
Message-ID: <20250812172955.915655708@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2624441d2fa9..3f23d9f0f726 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1402,7 +1402,7 @@ static int _sdw_prepare_stream(struct sdw_stream_runtime *stream,
 		if (ret < 0) {
 			dev_err(bus->dev, "Prepare port(s) failed ret = %d\n",
 				ret);
-			return ret;
+			goto restore_params;
 		}
 	}
 
-- 
2.39.5



