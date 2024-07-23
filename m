Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DF2157A55;
	Tue, 23 Jul 2024 18:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759828; cv=none; b=NWZCkzm90BaI6p6aaM7VjjLk2Ase4MhSOsP6RgoBeZHSs5OxQNOwW0rnlwUeyIJ3cr50xSthzngwIzy3rpGnd4fgSsP/Ub6iKYxjFEfbA9i9s0GjmbecUPzypUc/ys8iy6/1gUP8czAYuL+OKLMsFLHHo1BBQy+s74N7zlfKv9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759828; c=relaxed/simple;
	bh=pqQAx8g9EIUnpN/fciVXGm99s4o1nkHLfU2LcgKNTJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+u7I0kdGfdllxnVP+1WcZL2WeYpm4xIGuge7Mks9jfcODknwO9x7RD6yQwPdoTzBtz8rSWAXRmJ0e7vDKKFNrx2y586jWcVOCw2aqix2/gtH01O5UkmPK9qtusztPfWkg2sVJg1L1v0RvfSgB7CFOTO9WkgawwKyCmI66gZyBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrvMoNg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrvMoNg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D394AC4AF0A;
	Tue, 23 Jul 2024 18:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759828;
	bh=pqQAx8g9EIUnpN/fciVXGm99s4o1nkHLfU2LcgKNTJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrvMoNg1tqduaDDjA+oHGcqScIZoozJUkeuh46iqKb1vusEzV7HQ3wzoXZpwlU4pz
	 92xL7tDdYZ113xrDvr2dCC87QheRvXeGsnzB7eorqd5BxCcpp+r4PzYwEShcy4M/Rc
	 f4tGTTRVlIWgmmahZQZ14OiYo8na/itJMvdwpE3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 012/163] PNP: Hide pnp_bus_type from the non-PNP code
Date: Tue, 23 Jul 2024 20:22:21 +0200
Message-ID: <20240723180143.944811224@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit edcde848c01eb071a91d479a6b3101d9cf48e905 ]

The pnp_bus_type is defined only when CONFIG_PNP=y, while being
not guarded by ifdeffery in the header. Moreover, it's not used
outside of the PNP code. Move it to the internal header to make
sure no-one will try to (ab)use it.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pnp/base.h  | 1 +
 include/linux/pnp.h | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index e74a0f6a31572..4e80273dfb1ec 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -6,6 +6,7 @@
 
 extern struct mutex pnp_lock;
 extern const struct attribute_group *pnp_dev_groups[];
+extern const struct bus_type pnp_bus_type;
 
 int pnp_register_protocol(struct pnp_protocol *protocol);
 void pnp_unregister_protocol(struct pnp_protocol *protocol);
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index ddbe7c3ca4ce2..314892a6de8a0 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -435,8 +435,6 @@ struct pnp_protocol {
 #define protocol_for_each_dev(protocol, dev)	\
 	list_for_each_entry(dev, &(protocol)->devices, protocol_list)
 
-extern const struct bus_type pnp_bus_type;
-
 #if defined(CONFIG_PNP)
 
 /* device management */
-- 
2.43.0



