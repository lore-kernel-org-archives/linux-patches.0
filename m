Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330DA13D258;
	Thu, 11 Apr 2024 10:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831636; cv=none; b=fukdACX4vvxXJtLVD3uyxiDMS8/PV8Yol2ejzAGxOxomIN9KW8/QPKiSvPGjae/oowpD0c1eei7AcJmwrmAoCgyuPkHz7d/sQkt7RrMfeej+TtvLyOcAgOuBYytmCrGL3c1cRP046FlxJwbVdPoDEFplkOfbof/aAwyCBKUbIJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831636; c=relaxed/simple;
	bh=s+r+Br2xJWUVvZ4BF5lhJa9uLAayM5MqGKv1t8GLLQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mh24xuQiIGSQdb4jmKHVmt/DX0wj8jgEReelgnI6+2jA5+o4jk++vP65mSuizaMznsAvXmOQBwuyGH2vCh2VE660nqYH30/18FeiQMUiB8agpV3o/N7mR6CgGV6Prnhyp73qAbV/qzee2IHADr0C+i79zdtSPwBAVr2uLwKMtqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kML5ux3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kML5ux3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FB2C433F1;
	Thu, 11 Apr 2024 10:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831636;
	bh=s+r+Br2xJWUVvZ4BF5lhJa9uLAayM5MqGKv1t8GLLQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kML5ux3VLM+IPEO62UEgMjU7XI2yv8qPM9TPn3L3oepNdYSMXEgbos6Fl6ExY/wy8
	 V0AJxj1qWduud4zfAL904OVzFPV9uT1X6LeDho5St+IP03HSWtzStwH8TofXssVHkj
	 /8xTXj5xQqas6W416zEvB8vX6dP/wNh2/NRGQNFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/294] slimbus: core: Remove usage of the deprecated ida_simple_xx() API
Date: Thu, 11 Apr 2024 11:53:59 +0200
Message-ID: <20240411095437.977781745@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 89ffa4cccec54467446f141a79b9e36893079fb8 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_range() is inclusive. So change this change allows one more
device. Previously address 0xFE was never used.

Fixes: 46a2bb5a7f7e ("slimbus: core: Add slim controllers support")
Cc: Stable@vger.kernel.org
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240224114137.85781-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/core.c b/drivers/slimbus/core.c
index 1d2bc181da050..69f6178f294c8 100644
--- a/drivers/slimbus/core.c
+++ b/drivers/slimbus/core.c
@@ -438,8 +438,8 @@ static int slim_device_alloc_laddr(struct slim_device *sbdev,
 		if (ret < 0)
 			goto err;
 	} else if (report_present) {
-		ret = ida_simple_get(&ctrl->laddr_ida,
-				     0, SLIM_LA_MANAGER - 1, GFP_KERNEL);
+		ret = ida_alloc_max(&ctrl->laddr_ida,
+				    SLIM_LA_MANAGER - 1, GFP_KERNEL);
 		if (ret < 0)
 			goto err;
 
-- 
2.43.0



