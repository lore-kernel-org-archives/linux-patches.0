Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F7B19E967;
	Thu,  9 Oct 2025 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025493; cv=none; b=JPuMg+ZM1B8FwHfxlmAUBDQyh8CgTsws+9LM2parvEBm5OvIILjhPJ+1AS21mpRBVf6I+Xjyw+/ybESmvTmOr4JzXrR6Vt+gmz4BEZ/bMYADc4G1YRn7y1fJMil9WcngVaTcTsQQsPiUQQ9NjAK8uG/avgoQWSQ40e7NUKActnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025493; c=relaxed/simple;
	bh=UKm9SEYPUAsn6ZnlOTERMD4FkIdrAs6P9akhvatSUds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fppTwZe/NxY88WQf4DOsU3wnFwLUlW/YwYK1qjCl7IzXlgmDTYuNmUNOUiGZGhhvXB+9auigfVg6OSzLc41CFAjNrlcoNQKASAfGB/NlFBGsAdP77GVXM2nzii4tJ1N8Lo+JEqQKcc4BsJdfC0wbGIO/dX1/Vp38+Hjpsfc1mo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3wpdBe+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3wpdBe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22403C4CEFE;
	Thu,  9 Oct 2025 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025492;
	bh=UKm9SEYPUAsn6ZnlOTERMD4FkIdrAs6P9akhvatSUds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3wpdBe+rOoG5MjQbLZhjSYb3S9cCjSD4QOYd1fzVypV0wj3a0tiUXLzMq4zg0iGk
	 jCWivBcuXP6uj3ZSLlSp1+qTf+e1i70RRQ9UerXmq+Mt0P3U363hXU0eyzXpfp+gqk
	 OYzNuh9DZWCrm50M2GGk/OIhfJtbvcLS6IVdY68xoq3UCIEM/kjHf9j0rerKCtE/Mg
	 8QWj2jXl/fIrCMmal9fa8Tqovvl9sPIsi2fvxfleucAyRTaHGDj8AbyWXCkE6d6WnA
	 5mDTwsehbAwCNDMe72Wz2JjkjSsj6POnuhZdxRxrqJ3f74TMT1GmkCatvXodKzr4yE
	 7HPkCHEi4c5yQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	op-tee@lists.trustedfirmware.org
Subject: [PATCH AUTOSEL 6.17-5.4] tee: allow a driver to allocate a tee_device without a pool
Date: Thu,  9 Oct 2025 11:54:40 -0400
Message-ID: <20251009155752.773732-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>

[ Upstream commit 6dbcd5a9ab6cb6644e7d728521da1c9035ec7235 ]

A TEE driver doesn't always need to provide a pool if it doesn't
support memory sharing ioctls and can allocate memory for TEE
messages in another way. Although this is mentioned in the
documentation for tee_device_alloc(), it is not handled correctly.

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The change simply drops the `|| !pool` guard in `tee_device_alloc()`
  (`drivers/tee/tee_core.c:892`), which currently rejects drivers that
  intentionally omit a shared-memory pool even though the API contract
  and docs (`include/linux/tee_core.h:123`) have long advertised `pool`
  as optional. Today that mismatch means such drivers cannot register at
  all, so user-visible functionality is blocked.
- Other subsystem code already treats a missing pool as a valid state
  and bails out safely: shared-memory allocators check `if
  (!teedev->pool)` before dereferencing it and return an error to user
  space (`drivers/tee/tee_shm.c:78`), so allowing allocation without a
  pool doesn’t create new NULL dereferences or change behaviour for
  drivers that do use shared memory.
- Existing in-tree TEE implementations still guard their pool setup with
  `IS_ERR()` checks (e.g. OP-TEE in `drivers/tee/optee/smc_abi.c:1651`),
  so a genuine failure still propagates an error instead of slipping
  through; we only unblock the documented “no pool” case.
- The patch is tiny, self-contained, and doesn’t alter ioctls or data
  structures, making the regression risk very low while fixing a long-
  standing real bug that prevents compliant drivers from loading.
  Backporting keeps the stable tree consistent with the exported TEE API
  and supports downstream drivers that rely on the documented behaviour.

 drivers/tee/tee_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index acc7998758ad8..133447f250657 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -889,7 +889,7 @@ struct tee_device *tee_device_alloc(const struct tee_desc *teedesc,
 
 	if (!teedesc || !teedesc->name || !teedesc->ops ||
 	    !teedesc->ops->get_version || !teedesc->ops->open ||
-	    !teedesc->ops->release || !pool)
+	    !teedesc->ops->release)
 		return ERR_PTR(-EINVAL);
 
 	teedev = kzalloc(sizeof(*teedev), GFP_KERNEL);
-- 
2.51.0

