Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6002571BA;
	Thu, 17 Apr 2025 18:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914487; cv=none; b=jcESRjNBLsMPK22pLWdJNDOr5XTPhTX4Tv1hlKfIzK3WmPBD+pEwGlmIGRMF8gVIF2upBs+zfuYF8wxob4iiQUKMGPMg4eGaSnkesHnJ8X8uv3xxBW/3PhLhjRmgt3WQz5IcGco7OliJQcbkuEBFqnIBtCOyYmHkHK77Zr53+1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914487; c=relaxed/simple;
	bh=2wmGXHtCgrc1q4RNBcPbmGXnDp1jULlaRtdXFTU45VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0RhHvIzvqbDJBcXmfcpZVAGSishycenicHMd/A/tAhlkSnNwaLe7wqngTolE3YO8NuJ+HM2BrzV/fnD43W/K6jgUeU1srbngLaPFOhdg+MgkPIg4/sqQ4WBMOL1eE4F1T3YT0kXCengoygsBcCZ20ou8XYVeyS0iYJp1LM06+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGKnptP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGKnptP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB3CC4CEE4;
	Thu, 17 Apr 2025 18:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914487;
	bh=2wmGXHtCgrc1q4RNBcPbmGXnDp1jULlaRtdXFTU45VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGKnptP/8t1XbJGGIaxcVPrg7cK98W9AjTv9FdlD8mgYlUF47yfehxC8R0MTytOnP
	 QvTEVslkmOVtWHVytFKWWBlF7I+oT1l2kFFGlzbiGHm1dERz35S56ZllNfhzSuxvWg
	 X5w+8hhRasgEaZsAzJBGCxnyhwk/ykCR5ohLTUbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 231/414] media: i2c: ccs: Set the devices runtime PM status correctly in probe
Date: Thu, 17 Apr 2025 19:49:49 +0200
Message-ID: <20250417175120.723485230@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 80704d14f1bd3628f578510e0a88b66824990ef6 upstream.

Set the device's runtime PM status to suspended in probe error paths where
it was previously set to active.

Fixes: 9447082ae666 ("[media] smiapp: Implement power-on and power-off sequences without runtime PM")
Cc: stable@vger.kernel.org # for >= v5.15
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3562,6 +3562,7 @@ static int ccs_probe(struct i2c_client *
 out_disable_runtime_pm:
 	pm_runtime_put_noidle(&client->dev);
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 
 out_cleanup:
 	ccs_cleanup(sensor);


