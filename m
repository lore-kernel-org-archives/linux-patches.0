Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D116B2512D9;
	Wed,  5 Mar 2025 18:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198117; cv=none; b=TTQ/5eWA/mCQva4DyD59idbgEE5jRVQwNKWMpLdVuHHKtp8i9qmqyJrvuSQMeupvsxHzkGCEhN2sWjZBJBlNbngoPJV8a4YyyGOO1S1x30K46rANJvsVfI/TWNrHh1SlewmFTwlV4Sbs0/S7xaAjRjfrH61PvngPEhreUtD5F8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198117; c=relaxed/simple;
	bh=UTbLbgFRfzatikuvwkCaAko6G7Vo9YQJlMshoMoceR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYmOmeL/JdOB/HCzUZJB0bvAUNG/PA1Gk8gk0QGTPmAAL4FiHJkM++Mir2T5qIwxKckJdLWH80YCvIPdnzWN28ZhXKzBznDRtmm38B35nKkxw3sPSOhHSafD7ZS0qJiktPzCpLog6oE2hxR+aLTVjxeWnMiTCKl/VcsT3MgoqIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhAsTlrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhAsTlrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0934CC4CED1;
	Wed,  5 Mar 2025 18:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198117;
	bh=UTbLbgFRfzatikuvwkCaAko6G7Vo9YQJlMshoMoceR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhAsTlrxJuNoTzP3gNoXbAJ2UQfsYGv6uuG2xJXvj7VumFNu2WwHWvrCZBm/iSfEu
	 4La4BckHI887yWRt7v+oY/RqtA8MVzljaoIEb0HyGX+5Vy+Xzs78AYzKEz+79uP4V7
	 pk0d0FPbaEHUN2O0Im5t+9fCU6hZADh5Ib+PIRkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/150] thermal: of: Simplify thermal_of_should_bind with scoped for each OF child
Date: Wed,  5 Mar 2025 18:48:19 +0100
Message-ID: <20250305174506.629288099@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 69f3aa6ad92447d6e9f50c5b5aea85b56e80b198 ]

Use scoped for_each_child_of_node_scoped() when iterating over device
nodes to make code a bit simpler.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20241010-b4-cleanup-h-of-node-put-thermal-v4-1-bfbe29ad81f4@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 423de5b5bc5b ("thermal/of: Fix cdev lookup in thermal_of_should_bind()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 5d3d8ce672cd5..111d2c15601b9 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -298,7 +298,7 @@ static bool thermal_of_should_bind(struct thermal_zone_device *tz,
 				   struct thermal_cooling_device *cdev,
 				   struct cooling_spec *c)
 {
-	struct device_node *tz_np, *cm_np, *child;
+	struct device_node *tz_np, *cm_np;
 	bool result = false;
 
 	tz_np = thermal_of_zone_get_by_name(tz);
@@ -312,7 +312,7 @@ static bool thermal_of_should_bind(struct thermal_zone_device *tz,
 		goto out;
 
 	/* Look up the trip and the cdev in the cooling maps. */
-	for_each_child_of_node(cm_np, child) {
+	for_each_child_of_node_scoped(cm_np, child) {
 		struct device_node *tr_np;
 		int count, i;
 
@@ -331,7 +331,6 @@ static bool thermal_of_should_bind(struct thermal_zone_device *tz,
 				break;
 		}
 
-		of_node_put(child);
 		break;
 	}
 
-- 
2.39.5



