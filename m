Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064036;
	b=E4TtoKavwE4DkgEjqs8grruBCFaqY8fPZXYJ8y0TiABJKxHg/jth9q59m3JNUvBYeVKk
	 hqF59nzLE/WDzZgjxwJB1jVgBMd+8cyZtULLpfQFoISHP4KcByYvITSrR2ihCFRLMsjFA
	 Bz6O/4vaq1ylgHhDc+VKqxqU9Uq/Dv31O1ZkfPIsGhCsyesVRBmv7eQxCXjbtLcHGuGD5
	 BOkSn4985eQHRhC/bi2U2NErPTHjjdzRutkhL9ylPlTRD3oxMSI6+tX9LgPXhA9f/ChR5
	 Y6YhgknVWYuWfd/azkyPuliehOgLxpMr6KaCKw/czKCe+Sbohuyf7/hfIXm4QB1fCeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jmZugGC91Micsi1lxPis3p0i6WlXZ0VXnNVGX8CMMYs=;
	b=0wUSCujbizBMvRsSVil5mTGztYmbR39KKf4Usvg4bJiC37ZDEG0kPjM6EutcTY0AlTI5
	 bp46fEj1DxWuX71KrN5yew1nIiY5k+d7NXtuJ3MBeu9MtzuZVd5tcbWNZJrQ4G6L4bWZH
	 xsznU2dpYSy6cArHivNhzqUXS3WK5iakdOl/vAXLU1fitQjrzggwEU65haNCFeP1yRqTj
	 YkEGrBc8qjysiBYaVzg5Vm6sB5+hieg0+y58pegAJz7SMZTN7Ge313WeA67qhaJ958aOA
	 5tNPh8+CeqCPSXgP5uCyTMWnxkd/xTidR79szdFWvlMCHh4X/HwFJIq7M36Pmw8TDlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TpWFNRfo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2A9606A9CB;
	Sat,  7 Nov 2026 15:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TpWFNRfo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2E51F008A3;
	Sat,  7 Nov 2026 15:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064035;
	bh=jmZugGC91Micsi1lxPis3p0i6WlXZ0VXnNVGX8CMMYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpWFNRfoYgMzFJp7RJoNNtbm2kXy/pmK1Y0P1iubj00XYqHgt+1mRZTPi5uY9N29w
	 qWVrwT85wge+Rltgi5xqM01sxHwoAmfEMMvB2TQNLYZwEQiV6zg3htAWG6bVGcF1hw
	 0WipIlllj2Dxikolzb7ytN6Qry3eK0O/k1zxekMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0172/1257] media: i2c: alvium-csi2: balance runtime PM usage count on remove
Date: Sat,  7 Nov 2026 08:41:08 -0500
Message-ID: <20261107134944.101594789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 0d2ca640318612402ae1c640d2da56b2914ff994 ]

alvium_probe() increments the runtime PM usage count with
pm_runtime_get_noresume() before enabling runtime PM. The probe error
path correctly balances this reference with pm_runtime_put_noidle(),
but the normal remove path only disables runtime PM.

pm_runtime_disable() does not decrement the usage count, so a
successful probe followed by driver removal leaves the runtime PM
usage count unbalanced.

Add the missing pm_runtime_put_noidle() to the remove path, matching
the existing probe error cleanup.

This issue was found by manual code inspection.

Fixes: 0a7af872915e ("media: i2c: Add support for alvium camera")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/alvium-csi2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/alvium-csi2.c b/drivers/media/i2c/alvium-csi2.c
index f51f9b9877592..f218999e0ed90 100644
--- a/drivers/media/i2c/alvium-csi2.c
+++ b/drivers/media/i2c/alvium-csi2.c
@@ -2523,6 +2523,7 @@ static void alvium_remove(struct i2c_client *client)
 	 * make sure to turn power off manually.
 	 */
 	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
 	if (!pm_runtime_status_suspended(dev))
 		alvium_set_power(alvium, false);
 	pm_runtime_set_suspended(dev);
-- 
2.53.0



