Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0F241B8E4;
	Sat, 12 Sep 2026 10:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210637; cv=none; b=CkMf2bCHP/YLwx8GtO8oOYKb3rJLScx8Gd/J/gR9o/BdY9ASpXQhDz5U6t0JXCCSBRpx414DayG4yCAe8GRDtyAZiPOL7VTDcU7ZkhqnAieW8/CfkRlqjUrSuBef8jqwwaK/2TMhTZ6TOqFxS8hioljkdY8NmScOZTWwfiO66Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210637; c=relaxed/simple;
	bh=+tgrKMT/58g+D5YhzFryqws28e+79RVt5hOzbBgNy00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQu2jV/VOBKxVOpboFt21A7fim9KafmP6jpFLnyzISBDcHYAdvtQtrLSrceKT/TRSbHATGMv+k6w7A8Fv9MDbfwBRT1E9xnkztI3vU/PjXWJ79pkJ+3fbctYJP4ObSsSjyblovkjeuqWDuzhJxOfWkggWtDbEvZaHVnK397j+rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaqo4/Ij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaqo4/Ij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326FE1F000FF;
	Sat, 12 Sep 2026 10:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210636;
	bh=/j91IqaEX0t253UbWPuPT7GwIYykFSs0+OMQsgOT0DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaqo4/Ij9rdB7lXDjvWUCn36eYWbRvvIBywhQXTk1xkh9aMGDdsKdWsEXx+3GTaa6
	 uJH4UR8a8sCVRvk5/6LRlLxN85Tb3AzzDOMpKRS6K99N1jl9kTRoP7O3JtMeWU33nM
	 UZiVE8JUTuUSHCwN9hh+aAf7VW0ny665xLOM0EzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1068/1518] crypto: qat - remove dead ADF_HEX code
Date: Sat, 12 Sep 2026 08:53:57 +0200
Message-ID: <20260912065647.608645661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit 61135c1597af56eb454d53c9d7cda90d5e5dc566 ]

The ADF_HEX value type is defined in the adf_cfg_val_type enum and
handled in adf_cfg_add_key_value_param(), but no caller in the tree
uses it.

Remove the unused ADF_HEX enum value and its dead handling code.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg.c        | 3 ---
 drivers/crypto/intel/qat/qat_common/adf_cfg_common.h | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index 3b42e29047bcc..7180dd2b504a1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -292,9 +292,6 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 			 "%ld", (*((long *)val)));
 	} else if (type == ADF_STR) {
 		strscpy(key_val->val, (char *)val);
-	} else if (type == ADF_HEX) {
-		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
-			 "0x%lx", (unsigned long)val);
 	} else {
 		dev_err(&GET_DEV(accel_dev), "Unknown type given.\n");
 		kfree(key_val);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
index d63f4dcccbb5d..5922d018f5b98 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
@@ -28,7 +28,6 @@ enum adf_cfg_service_type {
 
 enum adf_cfg_val_type {
 	ADF_DEC,
-	ADF_HEX,
 	ADF_STR
 };
 
-- 
2.53.0



