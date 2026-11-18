Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024609;
	b=SjejEyTa6BWtQ4kt7IGsQieF6go2pbEntLs9Cwee9CZKwQEmDRlG5BvwQQZTh8YlO1Q4
	 an7TOagtf3OtmwYlHDkHzpb6AFGUo0dIApRdrrzLHt/lJEgwbsMU7qqJxyreDzg5sc5Dj
	 inNRsdSarrZiusZp+DVHh3Bqt0XJOOh5NyL68jSN8eqy+DHcZd4qitSMp8z3/OJ9ySz9h
	 9kmkGDiFYjprxXgj9zsMVWhQS/QcYIEoOvDVywIj3rEKqRPsmZZGOryzHsVJ4Lsw7S9co
	 qPDrsXR4ZK1ladSK+SlC1NopypLmZ3C0qJI5omuFw8jdcbohXlrfZ2L9cC0yhSSKHjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0WsVtEFLJAqenPdkrE0oj54T5k0YZmb0ap0Tl5odwKo=;
	b=Kny2IKCt1bw12ruk1ZLcN05L7+siZxXuUOCXaTldYCIk+MQgmNthmDXjQXDHs5pZmGoh
	 d9Tfe9ctRRNEyE/PWyzGMhXpLN4BiYiskXjC2myO67EJF2ivdbEyrLTAMuDxSgZq21tBK
	 zjEs8G8a8yREqcyfMKmxeh61NB7WIjeBE3l3RmR8afHZweo8zEHzDuH55m5X7pk+QS+mZ
	 MpwLgwvnavQpWdpiHIOc8IQrioH3xxudDKxJKcSVLHt0yThfSz0Hywe5eK5vc3N17yKHR
	 wnOwZac8Vv8mK503Dqg4Che1HdP1aYx3WKbrAe4/fy81jP4OznwGJiYzY/gjeHUsxsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IdMOrjUu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332CF606A335;
	Wed, 18 Nov 2026 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IdMOrjUu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E381F000C6;
	Wed, 18 Nov 2026 17:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024609;
	bh=0WsVtEFLJAqenPdkrE0oj54T5k0YZmb0ap0Tl5odwKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdMOrjUuzN25zASft9shXEMQiSI7z4chqxQPk3YwrQOegCqQWO6DjBbOkfCUPMmkW
	 KB6aFX4jM5rI/datxrVy0FE/FtT+lpYOgdokW7ntji7Ln06FEPvAu0SvRg9ZB95XkC
	 hu6Fbj5egXpmjHBHZPJzsvndnlNbuQHE/Szek/mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0787/2151] iommu/vt-d: Do not ignore context table copy failures
Date: Wed, 18 Nov 2026 15:42:02 +0100
Message-ID: <20261118150150.772864169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 53e15f28829ff304f94883e8f3f1f5074aa2a0a2 ]

copy_translation_tables() currently logs copy_context_table() failures
but still returns success, so partial copy failures are silently ignored.

That means Intel IOMMU may run with only part of the old tables copied.
Then some old domain IDs may not be reserved, and later may be reused by
new domains. With stale hardware cache entries still around, this can
cause bad DMA translations, DMA faults, or domain aliasing.

Fix by aborting on the first context-table copy failure, freeing temporary
context-table pages, and returning an error so caller falls back to a
clean root table path.

Fixes: f93b4ac5929a ("iommu/vt-d: Use ida to manage domain id")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 5c07ddd931b20..135a268e2f2ca 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2062,7 +2062,7 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 		if (ret) {
 			pr_err("%s: Failed to copy context table for bus %d\n",
 				iommu->name, bus);
-			continue;
+			goto err_free_ctxt_tbls;
 		}
 	}
 
@@ -2094,11 +2094,27 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 	memunmap(old_rt);
 	return 0;
 
+err_free_ctxt_tbls:
+	/*
+	 * None of these tables have been linked into iommu->root_entry yet,
+	 * so they are unreachable and must be freed here.
+	 */
+	for (bus = 0; bus < ctxt_table_entries; bus++)
+		iommu_free_pages(ctxt_tbls[bus]);
+	kfree(ctxt_tbls);
 out_unmap:
 	memunmap(old_rt);
 err_free_bitmap:
 	bitmap_free(iommu->copied_tables);
 	iommu->copied_tables = NULL;
+
+	/*
+	 * Only reservations taken from the old context entries can be in the
+	 * ida at this point; no domain has been allocated on this IOMMU yet.
+	 * ida_destroy() empties it and leaves it ready for reuse.
+	 */
+	ida_destroy(&iommu->domain_ida);
+
 	return ret;
 }
 
-- 
2.53.0



