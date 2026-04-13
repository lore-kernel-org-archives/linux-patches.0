Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B825A336881;
	Mon, 13 Apr 2026 17:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099803; cv=none; b=lFRc7yFzyiOJzpjO+/WMMawFXRdJZLwK5YbWdEGnJN7UuwT+v2lqSAFUEjwaj0ZKh0s1TmMoKIQnZ37n85kKvcEhduvcS4tYgr4tcdNiELOG2oZiF5Y5hndC4gh3c5VrNEappJmW4to0ok03cGFaatWWil0aaXahJvfrD0R+24E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099803; c=relaxed/simple;
	bh=Q57wfVqV9k8a5dYFwNMVHC6OwMXgeXVzIZ6KawLGDr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVIGjSIsnU2QrZL5t/TBzc6LcMrMSuXqJ/MNRj2xO2OjWblCcxNFUZwQUljdk8rHc4n3yAmGSkMxFtEMCv+XSQ48UmcSDfK4+PUCkay5iTofsoUabP8v9WN5z1LwiGowgnIH8v3s440lJ89iwAnRyXDh+nfkS5to3+82kpFshyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Npuaqa2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Npuaqa2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51786C2BCAF;
	Mon, 13 Apr 2026 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099803;
	bh=Q57wfVqV9k8a5dYFwNMVHC6OwMXgeXVzIZ6KawLGDr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Npuaqa2Mgyv2Q+lPGvepOKh2BQFCgo9YSZrYU0ezma0pWtYldhDvOSRA5DZtyPKfe
	 33l7dpg0ah1isVGCMzAqWudvfHjMQlFSiI5B+YWtL/alF7P8IP0JMDMzznSwJSz4Z2
	 68hnvvsJfigwcUb8h1O3eMAqWO38PrFUQYimjx2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 480/491] media: device property: Return true in fwnode_device_is_available for NULL ops
Date: Mon, 13 Apr 2026 18:02:05 +0200
Message-ID: <20260413155837.022688904@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Daniel Scally <djrscally@gmail.com>

[ Upstream commit 5273382d03763277aaf8c6a2d6088e2afaee0cf0 ]

Some types of fwnode_handle do not implement the device_is_available()
check, such as those created by software_nodes. There isn't really a
meaningful way to check for the availability of a device that doesn't
actually exist, so if the check isn't implemented just assume that the
"device" is present.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Daniel Scally <djrscally@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 2692c614f8f0 ("device property: Allow secondary lookup in fwnode_get_next_child_node()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -837,9 +837,15 @@ EXPORT_SYMBOL_GPL(fwnode_handle_put);
 /**
  * fwnode_device_is_available - check if a device is available for use
  * @fwnode: Pointer to the fwnode of the device.
+ *
+ * For fwnode node types that don't implement the .device_is_available()
+ * operation, this function returns true.
  */
 bool fwnode_device_is_available(const struct fwnode_handle *fwnode)
 {
+	if (!fwnode_has_op(fwnode, device_is_available))
+		return true;
+
 	return fwnode_call_bool_op(fwnode, device_is_available);
 }
 EXPORT_SYMBOL_GPL(fwnode_device_is_available);


