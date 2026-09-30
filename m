Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473C038C42F;
	Wed, 30 Sep 2026 19:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795024; cv=none; b=WQM/ghwz/lBcYhE0PEximTyZNiXF0bomIdfLB4AOf//tyo3anx9yD3pkj9stgyk2ka9eD4woNh4eFDrKDTU6PLyw4uQrulpFXylW6QFUkhqXeeLQCzxHKr4rr2qxLniJbFrIya+aPD1kxtXzIgzErTQv3inL8eg8MqmcnRQ85OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795024; c=relaxed/simple;
	bh=004dQzBVO42wuF4D9XZL3JhX84jZOjeHMtc5C+EwOyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvpiDDCslRzdRooSZYsDfD18bxRPwQpMNmkQlEFcmhE6s2QGMCjYIXXr7fJc4QX1xHqQ17BEEBBvB7CgcixDy0oFmAgz80s84VR/f/MSO5boKJs+Gse2Dh8mdrvNMGmt4HhwswzKxFvsxmNLus1A0Vzn1KL63re5j+mr5Dg3G/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFF+NClZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFF+NClZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15621F00898;
	Wed, 30 Sep 2026 19:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795023;
	bh=mLUN3SbWIEsP3um/+MgFcYf9emgb+eCXGcWTRXA8uk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFF+NClZSAXwz9xCZ8PgwmpOhxYr5lkq9oZZUldqe3a1BKpEwvkZMog8aIhP1fhsX
	 0ZJCJ+S1yqqbdFk0DAIRPsaZCBTq058jJ45pn6Z4B0YlwuTu8zOSufIiOTvPH00T3a
	 F7Hntef7hvTsDCvAxt90QpGHDMXkbforhUs+Wv8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0414/1193] Bluetooth: btintel: Print firmware SHA1
Date: Wed, 30 Sep 2026 17:18:18 +0200
Message-ID: <20260930152443.396403475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit a2e7707bba21b373c7b429ad7f9030d63dfb4542 ]

Intel Read Version event contains a TLV(0x32) having firmware sha1 in
operational image.

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: a086c0892969 ("Bluetooth: btintel: validate version TLV value lengths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 5 +++++
 drivers/bluetooth/btintel.h | 4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 43ddde0a4d48c..bac58babec1e7 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -530,6 +530,8 @@ static int btintel_version_info_tlv(struct hci_dev *hdev,
 	bt_dev_info(hdev, "%s timestamp %u.%u buildtype %u build %u", variant,
 		    2000 + (version->timestamp >> 8), version->timestamp & 0xff,
 		    version->build_type, version->build_num);
+	if (version->img_type == 0x03)
+		bt_dev_info(hdev, "Firmware SHA1: 0x%8.8x", version->git_sha1);
 
 	return 0;
 }
@@ -625,6 +627,9 @@ static int btintel_parse_version_tlv(struct hci_dev *hdev,
 			memcpy(&version->otp_bd_addr, tlv->val,
 							sizeof(bdaddr_t));
 			break;
+		case INTEL_TLV_GIT_SHA1:
+			version->git_sha1 = get_unaligned_le32(tlv->val);
+			break;
 		default:
 			/* Ignore rest of information */
 			break;
diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
index 3a2d5b4219ddb..d19fcdb9ff0b6 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -41,7 +41,8 @@ enum {
 	INTEL_TLV_LIMITED_CCE,
 	INTEL_TLV_SBE_TYPE,
 	INTEL_TLV_OTP_BDADDR,
-	INTEL_TLV_UNLOCKED_STATE
+	INTEL_TLV_UNLOCKED_STATE,
+	INTEL_TLV_GIT_SHA1
 };
 
 struct intel_tlv {
@@ -69,6 +70,7 @@ struct intel_version_tlv {
 	u8	min_fw_build_yy;
 	u8	limited_cce;
 	u8	sbe_type;
+	u32	git_sha1;
 	bdaddr_t otp_bd_addr;
 };
 
-- 
2.53.0



