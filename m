Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEA32EA729;
	Tue, 17 Jun 2025 16:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178702; cv=none; b=T7HhGnjMK4DChH/3sQ+zYrBsfaDDTmOI9htHIdxZ1l1gDURYeqA749iUCRWru1/sY+M0B4YKF4g8cE/vx1xZAnzyO3vfPq8dhy6cbBU6QbeKLh3nit6Dx0g4jp4f0sLwVDpAwwOpwrncrL8jR9l2EhfJdeQZJNMBX6E9gEn3InU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178702; c=relaxed/simple;
	bh=i27bWy4ZbkUoskZXLIf237mB6hgkZXzwkQp0FsKtgZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEe9FLuCaWkko//+oVznf2kIu3YvQkYLr5/aLZuiQhX7ZSGHDXzStJXakxg75OuCVsplwrINwsHUDy3sd3mfqnDYocXVRdDsOCvJ8IH4nGKJ0fJUykQBoY5teSPdbfiSsVLAJTOTNSUbT+kVW/9Sck0g2xLtXbdkOsPDM37smFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3ZfVSwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3ZfVSwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EB0C4CEE3;
	Tue, 17 Jun 2025 16:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178702;
	bh=i27bWy4ZbkUoskZXLIf237mB6hgkZXzwkQp0FsKtgZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3ZfVSwJK1p/b8f360Iq369/6Daa0k6SfjEVrcR0VLiMLyI45glycinEqyL97zwy2
	 4QE9PebhgjXvZMBWLPfURAKvYWKIWtSZE4Udzhk7RNYfn4Xmai6E+hHz7ApgIi4rIB
	 uCKtc9DDjYo2zx7pZK2L8cBKaB+KV7xH1E/zdZUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Clark <james.clark@linaro.org>,
	Mike Leach <mike.leach@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 527/780] coresight: core: Disable helpers for devices that fail to enable
Date: Tue, 17 Jun 2025 17:23:55 +0200
Message-ID: <20250617152512.971843777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yabin Cui <yabinc@google.com>

[ Upstream commit f6028eeeb5e4cf86f93f805098c84974a79bba8a ]

When enabling a SINK or LINK type coresight device fails, the
associated helpers should be disabled.

Fixes: 6148652807ba ("coresight: Enable and disable helper devices adjacent to the path")
Signed-off-by: Yabin Cui <yabinc@google.com>
Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250429231301.1952246-3-yabinc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-core.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index dabec7073aeda..d3523f0262af8 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -465,7 +465,7 @@ int coresight_enable_path(struct coresight_path *path, enum cs_mode mode,
 		/* Enable all helpers adjacent to the path first */
 		ret = coresight_enable_helpers(csdev, mode, path);
 		if (ret)
-			goto err;
+			goto err_disable_path;
 		/*
 		 * ETF devices are tricky... They can be a link or a sink,
 		 * depending on how they are configured.  If an ETF has been
@@ -486,8 +486,10 @@ int coresight_enable_path(struct coresight_path *path, enum cs_mode mode,
 			 * that need disabling. Disabling the path here
 			 * would mean we could disrupt an existing session.
 			 */
-			if (ret)
+			if (ret) {
+				coresight_disable_helpers(csdev, path);
 				goto out;
+			}
 			break;
 		case CORESIGHT_DEV_TYPE_SOURCE:
 			/* sources are enabled from either sysFS or Perf */
@@ -497,16 +499,19 @@ int coresight_enable_path(struct coresight_path *path, enum cs_mode mode,
 			child = list_next_entry(nd, link)->csdev;
 			ret = coresight_enable_link(csdev, parent, child, source);
 			if (ret)
-				goto err;
+				goto err_disable_helpers;
 			break;
 		default:
-			goto err;
+			ret = -EINVAL;
+			goto err_disable_helpers;
 		}
 	}
 
 out:
 	return ret;
-err:
+err_disable_helpers:
+	coresight_disable_helpers(csdev, path);
+err_disable_path:
 	coresight_disable_path_from(path, nd);
 	goto out;
 }
-- 
2.39.5



