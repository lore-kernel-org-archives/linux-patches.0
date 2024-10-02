Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1BB198A1A;
	Wed,  2 Oct 2024 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877390; cv=none; b=hnEuGfpfxZ9PIYYb1DiQ/i4rVDVpL9fZGAyJsuaZpLxLe9u5qdpeUMVMCSMrfD17w7+2pa46WPAGoEYyg5a18B1JZtjcmb+BrhJYHW/FVHMSuKPvV5JKMbRUcyA1rdXPGGRXzb/3+AbYgWveFYRnzPek7CxILgd+5pOylMW6TpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877390; c=relaxed/simple;
	bh=blGiKQktssYj6zCH3mZrRZFGnAXgv+IM4Z8q684gKUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uc3lxpr9xF5MTWwwIzy2UJw5+4C6zAfR0PwaTwKrlw0U24iMVHH7s2KvNAiQYTSmyIYoSApjSznD7haUjuDYAbID4RABVS4dPKfSkuvTsDxjblRg34RDikU9Hu4xCDQ0vwnkqquj5QVyP1NdVKv6s4R3Ap44oc1pW3T3+FqjDTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfE1hxnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfE1hxnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64808C4CEC5;
	Wed,  2 Oct 2024 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877390;
	bh=blGiKQktssYj6zCH3mZrRZFGnAXgv+IM4Z8q684gKUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfE1hxnn4ow/t6suGY22YA0c/26lR/jVXcF/kuMJ1xfY2bZDBsFDZk0YDN+cfDYfl
	 rhsNI+EQFFNxKu1xhGzrTQcttiCuQ3c31TkDupefwzmArhDCqV8Ai71nGwljtTwhAd
	 ulDsfS8nNmfHihsGc2lZK3Fxze2JEXjaindsS3vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Xin Zeng <xin.zeng@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 034/634] crypto: qat - fix "Full Going True" macro definition
Date: Wed,  2 Oct 2024 14:52:14 +0200
Message-ID: <20241002125812.444156846@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>

[ Upstream commit 694a6f594817462942acbb1a35b1f7d61e2d49e7 ]

The macro `ADF_RP_INT_SRC_SEL_F_RISE_MASK` is currently set to the value
`0100b` which means "Empty Going False". This might cause an incorrect
restore of the bank state during live migration.

Fix the definition of the macro to properly represent the "Full Going
True" state which is encoded as `0011b`.

Fixes: bbfdde7d195f ("crypto: qat - add bank save and restore flows")
Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Reviewed-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
index 8b10926cedbac..e8c53bd76f1bd 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
@@ -83,7 +83,7 @@
 #define ADF_WQM_CSR_RPRESETSTS(bank)	(ADF_WQM_CSR_RPRESETCTL(bank) + 4)
 
 /* Ring interrupt */
-#define ADF_RP_INT_SRC_SEL_F_RISE_MASK	BIT(2)
+#define ADF_RP_INT_SRC_SEL_F_RISE_MASK	GENMASK(1, 0)
 #define ADF_RP_INT_SRC_SEL_F_FALL_MASK	GENMASK(2, 0)
 #define ADF_RP_INT_SRC_SEL_RANGE_WIDTH	4
 #define ADF_COALESCED_POLL_TIMEOUT_US	(1 * USEC_PER_SEC)
-- 
2.43.0



