Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EE071B51;
	Mon, 15 Apr 2024 14:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191181; cv=none; b=CjZncDeuryylMETJ7C1Ta/tiqWKEhMDfVyLjeer8p/TcBZmcUh82OESRNuy8+4h+afgtQCnjFewCWPkDQU+++h0zUN9j+J0ucP4GzGWZMEYteLh0evGkoekZmCobZBGEoqAGRsgI69RU1kiqBQmQmpl7LuCeGawox6T7HyGAGJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191181; c=relaxed/simple;
	bh=dJjOcOaaJYl9eUuqmCdbKdtuCP3x6IS2S87FxSqf2A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omV9JCz8avbG5JzznYP2aS18vT6NPHTdVjDLiaJdw1LCo/ZLQ9KXqFsX7Uclmeq6zFcCUdjaKvLIp7g0anku/68sX5vAf6DCQwbk8azXa+MgLjLV+sczFfuqdne9TiRHGeV19fzr7skVFpeqqFVuuEdOvZyBPO6gB9BBmbIBYuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1j+FYbjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1j+FYbjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2BCC113CC;
	Mon, 15 Apr 2024 14:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191181;
	bh=dJjOcOaaJYl9eUuqmCdbKdtuCP3x6IS2S87FxSqf2A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1j+FYbjDGXS0f41hj06S7WYSLBWo2qya3xJ7XtNyr0NCSqOnWy5ZdOhtrxpqFgHKm
	 3b3m/leUxOyjakCQ+0D7EDB/WPwo3lfZlL/MKArTYvBiIM000WBMhtvtYBezl3Jqp5
	 93/JqFqPX8u77ksZJJ8xEi0LLPZ+GhPrMDWw00TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 060/172] cxl: Remove checking of iter in cxl_endpoint_get_perf_coordinates()
Date: Mon, 15 Apr 2024 16:19:19 +0200
Message-ID: <20240415142002.241293035@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 648dae58a830ecceea3b1bebf68432435980f137 ]

The while() loop in cxl_endpoint_get_perf_coordinates() checks to see if
'iter' is valid as part of the condition breaking out of the loop.
is_cxl_root() will stop the loop before the next iteration could go NULL.
Remove the iter check.

The presence of the iter or removing the iter does not impact the behavior
of the code. This is a code clean up and not a bug fix.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/20240403154844.3403859-2-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 592780b8391f ("cxl: Fix retrieving of access_coordinates in PCIe path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index b2a2f6c34886d..0332b431117db 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2160,7 +2160,7 @@ int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 	 * port each iteration. If the parent is cxl root then there is
 	 * nothing to gather.
 	 */
-	while (iter && !is_cxl_root(to_cxl_port(iter->dev.parent))) {
+	while (!is_cxl_root(to_cxl_port(iter->dev.parent))) {
 		cxl_coordinates_combine(&c, &c, &dport->sw_coord);
 		c.write_latency += dport->link_latency;
 		c.read_latency += dport->link_latency;
-- 
2.43.0



